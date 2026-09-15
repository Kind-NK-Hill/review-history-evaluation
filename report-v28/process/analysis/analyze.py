"""Reproducible observations of public tool feedback; never rerun logged commands."""
from __future__ import annotations
import collections, datetime, hashlib, json, posixpath, re, shlex, statistics
from pathlib import Path

BASE = Path(__file__).resolve().parents[1]
OUT = BASE / 'analysis'
REPORT = BASE / 'inputs/REPORT_DATA.json'
LEAN_ERROR = re.compile(r'^(?P<path>(?:(?:/[^\n:]+|[^\s:\n]+)\.lean|/dev/stdin|<stdin>)):(?P<line>\d+):(?P<col>\d+):\s*error(?:\([^\n)]*\))?:\s*(?P<message>[^\n]*)', re.M)

def dump(path, value):
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2)+'\n', encoding='utf-8')

def write_rows(path, rows):
    with path.open('w', encoding='utf-8', newline='\n') as f:
        for row in rows: f.write(json.dumps(row, ensure_ascii=False)+'\n')

def instant(value):
    if value is None: return None
    return datetime.datetime.fromisoformat(value.replace('Z', '+00:00')).timestamp()

def shell_view(command):
    """Mask heredoc bodies before lexical classification, preserving invocations."""
    lines = command.split('\n'); kept=[]; queue=[]
    for line in lines:
        if queue:
            if line.strip()==queue[0]: queue.pop(0)
            continue
        kept.append(line)
        # Only literal shell delimiters, not << inside quoted replacement strings.
        matches=re.findall(r"<<-?\s*(?:'([^']+)'|\"([^\"]+)\"|([A-Za-z_][A-Za-z_0-9]*))",line)
        for m in matches: queue.append(next(x for x in m if x))
    return '\n'.join(kept), bool(queue)

def segments(command):
    view, unclosed = shell_view(command)
    try:
        lex=shlex.shlex(view, posix=True, punctuation_chars=';&|()<>\n')
        lex.whitespace=' \t\r'; lex.commenters='#'; lex.whitespace_split=True
        tokens=list(lex)
    except ValueError:
        return [], True
    result=[]; current=[]
    for tok in tokens:
        if tok and all(ch in ';&|()\n' for ch in tok):
            if current: result.append({'tokens':current,'after':tok}); current=[]
        else: current.append(tok)
    if current: result.append({'tokens':current,'after':''})
    return result, unclosed

def command_name(tokens):
    for n,t in enumerate(tokens):
        if re.match(r'^[A-Za-z_][A-Za-z_0-9]*=',t): continue
        return n, posixpath.basename(t)
    return 0,''

def without_redirects(tokens):
    out=[]; skip=False
    for tok in tokens:
        if skip: skip=False;continue
        if tok in {'>','>>','<','<<','<<<','>&','<&'}:
            if out and out[-1] in {'0','1','2'}: out.pop()
            skip=True;continue
        out.append(tok)
    return out

def normalized_path(path, cwd):
    if any(c in path for c in '$`*?{}'): return None
    return posixpath.normpath(path if path.startswith('/') else posixpath.join(cwd,path))

def classify(event):
    command=(event.get('arguments') or {}).get('command','')
    tool=event['tool'].split('.')[-1]
    segs, parse_problem=segments(command)
    labels=set(); checks=[]; cwd='/work/ProbabilityTheoryFormalization'
    dynamic = parse_problem or bool(re.search(r'(^|[;\n])\s*(for|while|if|case)\b|\$\(', shell_view(command)[0]))
    read_names={'cat','sed','head','tail','less','wc','ls','find','rg','grep','pwd','stat','sha256sum','diff','cmp'}
    for i,seg in enumerate(segs):
        raw=without_redirects(seg['tokens']); n,name=command_name(raw); t=raw[n:]
        if name=='cd' and len(t)>1:
            resolved=normalized_path(t[1],cwd)
            if resolved: cwd=resolved
        if name in read_names: labels.add('read_or_search')
        if name in {'rg','grep','find'}: labels.add('search_command')
        if name in {'python','python3','tee','apply_patch','cp','mv','touch','mkdir','rm','perl'} or (name=='sed' and any(x.startswith('-i') for x in t[1:])):
            labels.add('write_or_script')
        if name=='git': labels.add('version_control')
        if name in {'formalize','python','python3'} and '--phase2-mode' in t:
            k=t.index('--phase2-mode'); mode=t[k+1] if len(t)>k+1 else ''
            labels.add('workflow_operation')
            if mode=='build-check' and not any(x in t for x in ['--help','-h']):
                target=None
                for flag in ['--tasks','--task-id']:
                    if flag in t and len(t)>t.index(flag)+1: target=t[t.index(flag)+1]
                checks.append({'kind':'formalize_build','target':target,'segment':i,'cwd':cwd})
        lake_tokens=t[:]
        if name=='lake' and len(t)>3 and t[1] in {'-d','--dir'}:
            resolved=normalized_path(t[2],cwd)
            if resolved: cwd=resolved
            lake_tokens=[t[0]]+t[3:]
        is_lake_lean=name=='lake' and lake_tokens[1:3]==['env','lean']
        if is_lake_lean or name=='lean':
            args=lake_tokens[3:] if is_lake_lean else t[1:]
            paths=[x for x in args if (x.endswith('.lean') or x=='/dev/stdin') and not x.startswith('-')]
            if '--stdin' in args: paths.append('/dev/stdin')
            for path in paths:
                checks.append({'kind':'lean_stdin' if path=='/dev/stdin' else 'lean_file','target':normalized_path(path,cwd),'segment':i,'cwd':cwd})
        if name=='lake' and len(lake_tokens)>1 and lake_tokens[1]=='build' and not any(x in lake_tokens for x in ['--help','-h']):
            paths=[x for x in lake_tokens[2:] if re.fullmatch(r'[A-Za-z_][A-Za-z_0-9]*(?:\.[A-Za-z_][A-Za-z_0-9]*)*',x)]
            checks.append({'kind':'lake_build','target':','.join(paths) or '<default build>','segment':i,'cwd':cwd})
    if tool in {'build_check','math_check'}:
        labels.add('workflow_operation')
        checks.append({'kind':'service_'+tool,'target':(event.get('arguments') or {}).get('candidate_id'),'segment':None,'cwd':cwd})
    if checks: labels.add('check_invocation')
    if tool in {'request_help','assign_writer','review_candidate'}: labels.add('delegate_or_review')
    if tool in {'read_artifact','get_status'}: labels.add('read_collaboration')
    if tool=='submit_bundle': labels.add('submit')
    if event.get('tool_family')=='discovery': labels.add('tool_discovery')
    if not labels: labels.add('other_command_or_service')
    stdout=event.get('stdout') or ''; stderr=event.get('stderr') or ''
    feedback=stdout+'\n'+stderr
    diagnostics=[m.groupdict() for m in LEAN_ERROR.finditer(feedback)]
    observations=[]
    for c in checks:
        state='unresolved'; why='insufficient_or_compound_output'; target=c['target']
        matched=[]
        for d in diagnostics:
            resolved=normalized_path(d['path'],c['cwd'])
            if c['kind']=='lean_file' and resolved==target: matched.append(d)
            elif c['kind']=='lean_stdin' and d['path'] in {'/dev/stdin','<stdin>'}: matched.append(d)
            elif c['kind'] in {'formalize_build','service_build_check'} and len(checks)==1: matched.append(d)
            elif c['kind']=='lake_build':
                modules=(target or '').split(',')
                modulepaths=[m.replace('.','/')+'.lean' for m in modules]
                if len(checks)==1 or any(d['path'].endswith(p) for p in modulepaths): matched.append(d)
        truncated=bool(event.get('stdout_truncated') or event.get('stderr_truncated'))
        single_build=sum(x['kind']=='lake_build' for x in checks)==1
        position=c['segment']
        preceding_or=position is not None and position>0 and segs[position-1]['after']=='||'
        prior_read=False
        if position is not None:
            for prior in segs[:position]:
                prior_tokens=without_redirects(prior['tokens']); _,prior_name=command_name(prior_tokens)
                if prior_name in {'cat','tail','head','rg','grep'} or (prior_name=='sed' and '-i' not in prior_tokens): prior_read=True
        build_success=single_build and bool(re.search(r'^Build completed successfully',feedback,re.M)) and not preceding_or and not event.get('timed_out') and not (prior_read and event.get('exit_code')!=0)
        if c['kind']=='lake_build' and build_success and not matched:
            state='check_passed';why='explicit_build_completion'
        elif matched:
            state='negative_feedback';why='located_lean_diagnostic'
        elif c['kind']=='formalize_build':
            if target and re.search(r'Build check passed for\s+'+re.escape(target)+r'\b',feedback):
                state='check_passed';why='explicit_target_build_pass'
            elif target and re.search(r'Build check failed for\s+'+re.escape(target)+r'\b',feedback):
                state='negative_feedback';why='explicit_target_build_fail'
        elif c['kind']=='lake_build' and build_success:
            state='check_passed';why='explicit_build_completion'
        elif c['kind']=='service_build_check':
            structured=event.get('structured_result') or {}
            result=structured.get('result') or {}
            if structured.get('action')=='build_check' and result.get('execution_status')=='completed' and isinstance(result.get('compile_pass'),bool):
                state='check_passed' if result['compile_pass'] else 'negative_feedback'
                why='structured_candidate_compile_result'
        elif c['kind'] in {'lean_file','lean_stdin'}:
            # Conservative success: one check, literal final invocation, no pipeline/error masking.
            is_final=c['segment']==len(segs)-1
            has_mask=any('|' in s['after'] or s['after']=='&' for s in segs[c['segment']:])
            if len(checks)==1 and is_final and not dynamic and not has_mask and not preceding_or and event.get('exit_code')==0 and not truncated and not event.get('timed_out'):
                state='check_passed';why='final_direct_lean_exit_zero'
        observations.append({**c,'state':state,'reason':why,'diagnostics':matched,'output_truncated':truncated,'compound_command':len(segs)>1,'dynamic_shell':dynamic})
    return {'event_id':event['event_id'],'run_id':event['run_id'],'config':event['config'],'task':event['task'],'session_id':event['session_id'],'actor':event['actor'],'role':event['role'],'tool':event['tool'],'dispatch_time':event['dispatch_time'],'result_time':event['result_time'],'labels':sorted(labels),'shell_parse_problem':parse_problem,'checks':observations,'exit_code':event.get('exit_code'),'timed_out':event.get('timed_out'),'tool_elapsed_seconds':event.get('elapsed_seconds'),'source_file':event['source_file'],'source_line':event['source_line'],'result_source_file':event.get('result_source_file'),'result_source_line':event.get('result_source_line'),'command_sha256':hashlib.sha256(command.encode()).hexdigest() if command else None}

def build_episodes(features, events):
    """File-check sequences within one session; all scope changes remain inspectable."""
    groups=collections.defaultdict(list)
    for f in features:
        for c in f['checks']:
            if c['kind']!='lean_file' or not c['target']: continue
            groups[(f['run_id'],f['session_id'],c['target'])].append((f,c))
    episodes=[]
    bysession=collections.defaultdict(list)
    for f in features: bysession[(f['run_id'],f['session_id'])].append(f)
    for entries in bysession.values(): entries.sort(key=lambda f:f['dispatch_time'] or '')
    for (run,session,target),checks in sorted(groups.items()):
        checks.sort(key=lambda fc:fc[0]['dispatch_time'] or '')
        pending=None
        for f,c in checks:
            if c['state']=='negative_feedback':
                if pending is None:
                    pending={'run_id':run,'config':f['config'],'task':f['task'],'session_id':session,'target':target,'start_event_id':f['event_id'],'start_feedback_time':f['result_time'],'negative_checks':[],'intervening_unresolved_checks':[],'scope':'same path and session; proof-goal continuity requires evidence review'}
                pending['negative_checks'].append(f['event_id'])
            elif c['state']=='check_passed' and pending:
                pending.update({'end_event_id':f['event_id'],'end_feedback_time':f['result_time'],'terminal':'later_same_file_check_passed'})
                episodes.append(pending);pending=None
            elif pending: pending['intervening_unresolved_checks'].append(f['event_id'])
        if pending:
            last=bysession[(run,session)][-1]
            pending.update({'end_event_id':None,'end_feedback_time':last['result_time'] or last['dispatch_time'],'terminal':'no_later_same_file_pass_observed'})
            episodes.append(pending)
    for i,e in enumerate(episodes,1):
        e['episode_id']=f'file-sequence-{i:04d}'
        start=instant(e['start_feedback_time']);end=instant(e['end_feedback_time'])
        between=[f for f in bysession[(e['run_id'],e['session_id'])] if (instant(f['dispatch_time']) or 0)>=(start or 0) and (instant(f['dispatch_time']) or 0)<=(end or 0)]
        e['elapsed_seconds']=max(0,end-start) if end is not None and start is not None else None
        e['subsequent_calls']=len(between)
        e['action_labels']=dict(collections.Counter(label for f in between for label in f['labels']))
        e['subsequent_event_ids']=[f['event_id'] for f in between]
        e['final_adoption']='not_inferred'
    return episodes

def main():
    events=[json.loads(line) for line in (BASE/'extraction/events.jsonl').open(encoding='utf-8') if line.strip()]
    assert len({e['event_id'] for e in events})==len(events)
    features=[classify(e) for e in events]
    eventmap={e['event_id']:e for e in events}
    episodes=build_episodes(features,eventmap)
    common=json.loads(REPORT.read_text(encoding='utf-8'))
    rows=[]
    for r in common['rows']:
        if r['batch']!=2: continue
        run=f"r2-{r['group'].lower()}-{r['arm'].lower()}"
        ff=[f for f in features if f['run_id']==run]
        checks=[c for f in ff for c in f['checks']]
        seq=[e for e in episodes if e['run_id']==run]
        discovery=sum('tool_discovery' in f['labels'] for f in ff)
        rows.append({'run_id':run,'config':r['arm'],'task':r['group'],'common_outcome':r['outcome'],'run_minutes':r['minutes'],'public_tool_events':len(ff),'service_tool_calls':len(ff)-discovery,'discovery_calls':discovery,'actions':dict(collections.Counter(label for f in ff for label in f['labels'])),'check_observations':dict(collections.Counter(c['state'] for c in checks)),'same_file_sequences':len(seq),'same_file_later_pass':sum(e['terminal']=='later_same_file_check_passed' for e in seq),'sessions':len({f['session_id'] for f in ff})})
    assert len(rows)==33 and len({r['run_id'] for r in rows})==33
    summary={'scope':'second-batch 33 original runs; retrospective descriptive process measurement','events':len(events),'runs':len(rows),'configs':{},'check_kinds':dict(collections.Counter(c['kind'] for f in features for c in f['checks'])),'check_states':dict(collections.Counter(c['state'] for f in features for c in f['checks'])),'shell_parse_problem':sum(f['shell_parse_problem'] for f in features),'same_file_sequences':len(episodes),'same_file_sequence_ends':dict(collections.Counter(e['terminal'] for e in episodes)),'interpretation':'Same-file recheck sequences are candidate recovery evidence, not validated goal-level recovery rates. Composite action labels can overlap.'}
    for arm in 'ABC':
        rr=[r for r in rows if r['config']==arm]
        summary['configs'][arm]={'runs':len(rr),'median_minutes':statistics.median(r['run_minutes'] for r in rr),'public_tool_events':sum(r['public_tool_events'] for r in rr),'service_tool_calls':sum(r['service_tool_calls'] for r in rr),'discovery_calls':sum(r['discovery_calls'] for r in rr),'actions':dict(sum((collections.Counter(r['actions']) for r in rr),collections.Counter())),'check_observations':dict(sum((collections.Counter(r['check_observations']) for r in rr),collections.Counter())),'same_file_sequences':sum(r['same_file_sequences'] for r in rr),'same_file_later_pass':sum(r['same_file_later_pass'] for r in rr)}
    write_rows(OUT/'event_features.jsonl',features)
    write_rows(OUT/'file_check_sequences.jsonl',episodes)
    dump(OUT/'run_summary.json',rows);dump(OUT/'summary.json',summary)
    dump(OUT/'analysis_provenance.json',{'created_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'input_sha256':hashlib.sha256((BASE/'extraction/events.jsonl').read_bytes()).hexdigest(),'common_result_sha256':hashlib.sha256(REPORT.read_bytes()).hexdigest(),'analysis_sha256':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),'protocol_status':'v1 frozen descriptive analysis; automatic classifications are reviewed candidate observations, not a semantic recovery census'})
    print(json.dumps(summary,ensure_ascii=False,indent=2))

if __name__=='__main__': main()
