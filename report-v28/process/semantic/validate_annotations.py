"""Structural/source validation; does not certify semantic labels."""
from pathlib import Path
import collections,hashlib,json,datetime,os
B=Path(__file__).resolve().parents[1]

def stamp(x):return datetime.datetime.fromisoformat(x.replace('Z','+00:00')) if x else None

def long_path(p):
    p=Path(p).absolute()
    return Path('\\\\?\\'+str(p)) if os.name=='nt' and not str(p).startswith('\\\\?\\') else p

def main():
    bundle_path=B/'source_bundle_manifest.json'
    bundle=json.loads(bundle_path.read_text(encoding='utf-8')) if bundle_path.exists() else {}
    bundled=bundle.get('final_sources',{})
    aliases=bundle.get('final_source_aliases',{})
    annotations=[]
    for p in sorted((B/'semantic').glob('annotations_[ABC].json')):
        annotations += json.loads(p.read_text(encoding='utf-8'))
    events={}
    for line in (B/'extraction/events.jsonl').open(encoding='utf-8'):
        e=json.loads(line)
        events[e['event_id']]={k:e.get(k) for k in ['run_id','session_id','actor','dispatch_time','result_time','source_file','source_line','result_source_file','result_source_line','tool']}
    issues=[];final_files={};facts=[]
    pairs=collections.Counter((a['run_id'],a['sample_kind']) for a in annotations)
    for key,n in pairs.items():
        if n!=1:issues.append({'key':key,'issue':'duplicate_sample','count':n})
    for a in annotations:
        key=a['run_id']+':'+a['sample_kind']; ids=a.get('evidence_event_ids',[])+[x['event_id'] for x in a.get('actions',[])]
        ids += [a.get('start_event_id'),a.get('end_event_id')]
        for eid in set(ids)-{None}:
            if eid not in events:issues.append({'key':key,'event':eid,'issue':'missing_event'})
            elif events[eid]['run_id']!=a['run_id']:issues.append({'key':key,'event':eid,'issue':'foreign_run'})
        start=events.get(a.get('start_event_id'));end=events.get(a.get('end_event_id'))
        if start:
            source_pair=(a['start_source_file'].replace('\\','/'),a['start_source_line'])
            permissible={(start['source_file'].replace('\\','/'),start['source_line'])}
            if start.get('result_source_file'): permissible.add((start['result_source_file'].replace('\\','/'),start['result_source_line']))
            if source_pair not in permissible:
                issues.append({'key':key,'issue':'start_source_mismatch'})
        if start and end:
            t0=stamp(start['result_time'] if a['sample_kind']=='first_lean_feedback' else start['dispatch_time']);t1=stamp(end['result_time'])
            if t0 and t1 and t1<t0:issues.append({'key':key,'issue':'negative_window'})
            elapsed=(t1-t0).total_seconds() if t0 and t1 else None
        else:elapsed=None
        snippets=[]
        for x in a.get('final_evidence',[]):
            p=Path(x['path'])
            locator=x['path'].replace('\\','/')
            source_key=aliases.get(locator,locator)
            if source_key in bundled:
                p=B/bundled[source_key]['bundled_path']
            else:
                issues.append({'key':key,'issue':'source_not_bundled','path':str(p)});continue
            if not long_path(p).is_file():issues.append({'key':key,'issue':'missing_final_file','path':str(p)});continue
            lines=long_path(p).read_text(encoding='utf-8-sig').split('\n');n=x['line']
            if not 1<=n<=len(lines):issues.append({'key':key,'issue':'invalid_final_line','path':str(p),'line':n});continue
            digest=hashlib.sha256(long_path(p).read_bytes()).hexdigest();final_files[p.as_posix()]=digest
            snippets.append({'path':p.as_posix(),'line':n,'sha256':digest,'text':'\n'.join(lines[max(0,n-3):min(len(lines),n+3)]),'claim':x['detail_zh']})
        facts.append({'key':key,'start_event_id':a.get('start_event_id'),'end_event_id':a.get('end_event_id'),'observed_window_seconds':elapsed,'semantic_progress':a['progress'],'semantic_final_adoption':a['final_adoption'],'final_source_snippets':snippets})
    result={'annotation_count':len(annotations),'run_count':len({a['run_id'] for a in annotations}),'counts_by_config':dict(collections.Counter(a['run_id'][-1] for a in annotations)),'issues':issues,'final_source_files':len(final_files),'semantic_validation':'not established by these structural checks'}
    for name,x in [('validation.json',result),('source_checks.json',facts),('final_source_hashes.json',final_files)]:
        (B/'semantic'/name).write_text(json.dumps(x,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(result,ensure_ascii=False,indent=2))
    if issues: raise SystemExit(1)
if __name__=='__main__':main()
