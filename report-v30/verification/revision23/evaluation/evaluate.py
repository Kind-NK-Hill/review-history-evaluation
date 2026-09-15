"""Reconcile preserved assessments under an explicit common outcome policy.

This does not generate mathematical verdicts from a compiler exit code. Existing
semantic assessments are retained; each correction requires a named justification
and, for interface corrections, a checked caller against the frozen delivery.
"""
from pathlib import Path
from collections import Counter
import json,csv,hashlib,statistics
HERE=Path(__file__).resolve().parent
ROOT=next(p for p in HERE.parents if (p/'ProbabilityTheoryFormalization/AGENTS.md').is_file())
TEAM=ROOT/'reports/trajectory_analysis/team_review_v031_trajectory_v3_20260911'
OLD=TEAM/'combined_revision_v22_20260914'
E=ROOT/'review_history_retro_20260901/research_framework/replication_20260913'
GROUPS=['L1','L2','L3','L4','L5','L6','L7','M1','M2','M3','H1']
def read(p):return json.loads(Path(p).read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def resolve(p):return ROOT/p[5:] if p.startswith('ROOT/') else Path(p)
def verify_binding(path):
    b=read(path);files=[]
    for f in b['files']:
        p=path.parent/'subject'/f['category']/f['logical_path']
        assert p.exists(), str(p)
        assert sha(p)==f['sha256'], 'Changed evidence: '+str(p)
        files.append({'path':str(p),'sha256':f['sha256'],'category':f['category']})
    return files
def validate_rows(rows):
    expected={(b,a,g) for b in [1,2] for a in 'ABC' for g in GROUPS}
    keys=[(r['batch'],r['arm'],r['group']) for r in rows]
    assert set(keys)==expected and len(keys)==66,'Incomplete or duplicate panel'
    for r in rows:
        assert r['outcome'] in ['pass','fail']
        assert r['evidence'] and r['reason']
        assert r['minutes']>0
        if r['outcome']!=r['recorded_outcome']:
            assert r.get('correction_basis'),'Unjustified correction'
            for f in r.get('caller_evidence',[]):
                assert sha(HERE/f['file'])==f['sha256'] and f['exit_code']==0,'Caller proof not verified'
    return True
def main():
    original=read(OLD/'REPORT_DATA.json')
    index=list(csv.DictReader((OLD/'manuscript/evidence/r9_rewrite_evidence/RUN_INDEX.csv').open(encoding='utf-8-sig')))
    idx={(r['arm'],r['task_group']):r for r in index if r['main_panel']=='True'}
    policy=read(HERE/'policy.json');rows=[]
    for old in original['timing']:
        a,g=old['arm'],old['group'];raw=idx[a,g]
        identity=json.loads(raw['selected_candidate_identity']);binding=resolve(identity['input_binding_path'])
        ev=verify_binding(binding)
        r={'batch':1,'arm':a,'group':g,'recorded_outcome':old['outcome'],'outcome':old['outcome'],
           'minutes':old['cumulative_solving_window_minutes'],'original_minutes':old['original_minutes'],
           'estimated_time':old['estimated'],'binding_path':str(binding),'binding_sha256':sha(binding),
           'evidence':ev,'reason':policy['groups'][g]['inherited_basis'],'semantic_basis':'Retained previously corrected assessment, checked for compatibility with common policy.',
           'recorded_decision':json.loads(raw['original_selected_decision'])}
        if a=='A' and g=='L7':
            continuation=OLD/'verification/revision13/a-l7/RESULTS.json'
            d=read(continuation);assert d['dimensions']['mathematics']=='pass' and d['dimensions']['repair_reasonableness']=='pass'
            r['continuation_result']={'path':str(continuation),'sha256':sha(continuation),'target_hashes':d['target_hashes']}
            r['binding_note']='Original-run binding retained as provenance; final completion uses the separately bound continuation identified above.'
        if g=='L3' and a in 'AB':r['reason']='The original input sequence is required to be integrable at every index. Eventual integrability does not imply that premise; covering it requires an added tail argument.'
        rows.append(r)
    data=read(E/'RESULTS.json');timing={r['slot_id']:r for r in read(HERE.parent/'stage2_uniform_timing_20260914.json')['rows']}
    callers={x['slot']:x for x in read(HERE/'caller_checks.json')}
    for x in data['acceptance']:
        sid=x['slot_id']
        if not sid.startswith('r2-'):continue
        _,g,a=sid.split('-');g=g.upper();a=a.upper()
        binding=Path(x['input_binding']['path']);assert sha(binding)==x['input_binding']['sha256']
        ev=verify_binding(binding);decision=read(x['terminal']['decision']['decision'])
        assert decision['input_binding_sha256']==sha(binding)
        tech=x['technical_result']['facts'];assert tech['technical_status']=='pass' and not tech['nonstandard_axioms']
        verdict=decision['verdict'];assert verdict in ['pass','fail']
        minutes=timing[sid]['uniform_first_dispatch_to_last_role_return_seconds']/60
        r={'batch':2,'arm':a,'group':g,'recorded_outcome':verdict,'outcome':verdict,'original_minutes':minutes,
           'minutes':minutes+(1122.899/60 if sid=='r2-l3-a' else 0),'estimated_time':False,
           'binding_path':str(binding),'binding_sha256':sha(binding),'evidence':ev,
           'reason':policy['groups'][g]['inherited_basis'],'semantic_basis':'Retained completed common assessment; unchanged task-specific mathematical requirements.',
           'recorded_decision':x['terminal']['decision']['decision'],'technical_evidence':tech}
        if sid in callers:
            c=callers[sid];assert c['exit_code']==0 and sha(HERE/c['file'])==c['sha256']
            r.update(outcome='pass',correction_basis=policy['corrections'][sid],reason=policy['corrections'][sid],caller_evidence=[c])
        elif sid=='r2-m2-b':
            r.update(outcome='pass',correction_basis=policy['corrections'][sid],reason=policy['corrections'][sid],route_compliance='Does not follow the stipulated subsequence-first route; full-sequence theorem already proved.')
        rows.append(r)
    for r in rows:
        r['recorded_outcome_stage']='previously corrected first-batch assessment including A-L7 continuation' if r['batch']==1 else 'original final common acceptance of the second batch'
    validate_rows(rows)
    rows.sort(key=lambda r:(r['batch'],GROUPS.index(r['group']),r['arm']))
    summaries={str(b):{a:{'pass':sum(r['outcome']=='pass' for r in rows if r['batch']==b and r['arm']==a),'recorded_pass':sum(r['recorded_outcome']=='pass' for r in rows if r['batch']==b and r['arm']==a),'median_minutes':statistics.median(r['minutes'] for r in rows if r['batch']==b and r['arm']==a)} for a in 'ABC'} for b in [1,2]}
    result={'policy_sha256':sha(HERE/'policy.json'),'status':'complete','review_type':'retrospective common-policy reconciliation, not a new blind rejudging of all proofs','field_definitions':{'recorded_outcome':'Outcome recorded before this reconciliation; the stage differs by batch and is identified in recorded_outcome_stage. It is not a common-stage original score.'},'source_hashes':{'RESULTS.json':sha(E/'RESULTS.json'),'RUN_INDEX.csv':sha(E/'RUN_INDEX.csv')},'summaries':summaries,'rows':rows}
    (HERE/'assessment.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),encoding='utf-8')
    with (HERE/'assessment.csv').open('w',newline='',encoding='utf-8-sig') as f:
        w=csv.DictWriter(f,fieldnames=['batch','arm','group','recorded_outcome','recorded_outcome_stage','outcome','minutes','original_minutes','estimated_time','reason','binding_sha256']);w.writeheader()
        for r in rows:w.writerow({k:r[k] for k in w.fieldnames})
    print(json.dumps({'summaries':summaries,'evidence_files_checked':sum(len(r['evidence']) for r in rows),'rows':len(rows)},ensure_ascii=False))
if __name__=='__main__':main()
