"""Recompute specified report tables from bundled records, without model calls.

All generated files go to a new output directory. Logged commands are data;
only the included analysis scripts and pure parameter checks are executed.
"""
from pathlib import Path
import argparse, csv, gzip, hashlib, json, math, shutil, statistics, subprocess, sys

HERE=Path(__file__).resolve().parent
GROUPS=('L1','L2','L3','L4','L5','L6','L7','M1','M2','M3','H1')
def read(p):return json.loads(p.read_text(encoding='utf-8-sig'))
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def dump(p,x):p.write_text(json.dumps(x,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')

def outcome_summary(assessment):
    rows=assessment['rows']
    expected={(b,a,g) for b in (1,2) for a in 'ABC' for g in GROUPS}
    keys=[(r['batch'],r['arm'],r['group']) for r in rows]
    if len(keys)!=66 or set(keys)!=expected:
        raise ValueError('Expected one record per batch/configuration/task: 66 unique records')
    for r in rows:
        if r['outcome'] not in ('pass','fail') or r['recorded_outcome'] not in ('pass','fail'):
            raise ValueError('Unknown outcome')
        if not math.isfinite(r['minutes']) or r['minutes']<=0:
            raise ValueError('Invalid elapsed time')
        if r['outcome']!=r['recorded_outcome'] and not r.get('correction_basis'):
            raise ValueError('Changed outcome without a recorded justification')
    result={str(b):{a:{
        'pass':sum(r['outcome']=='pass' for r in rows if r['batch']==b and r['arm']==a),
        'recorded_pass':sum(r['recorded_outcome']=='pass' for r in rows if r['batch']==b and r['arm']==a),
        'median_minutes':statistics.median(r['minutes'] for r in rows if r['batch']==b and r['arm']==a)
    } for a in 'ABC'} for b in (1,2)}
    if result!=assessment['summaries']:raise ValueError('Recomputed outcome/time summaries differ from frozen results')
    return result

def run_script(p,work):
    result=subprocess.run([sys.executable,'-B',str(p)],cwd=work,capture_output=True)
    logs=work/'logs';logs.mkdir(exist_ok=True)
    (logs/(p.stem+'.stdout.txt')).write_bytes(result.stdout)
    (logs/(p.stem+'.stderr.txt')).write_bytes(result.stderr)
    if result.returncode:raise RuntimeError(f'{p.name} failed; see {logs}')

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output',type=Path,required=True,help='New, empty directory for all generated files')
    args=parser.parse_args();output=args.output.resolve()
    if output.is_relative_to(HERE) or (output.exists() and any(output.iterdir())):
        raise SystemExit('Choose a new or empty output directory; existing files are never overwritten')
    output.mkdir(parents=True,exist_ok=True)
    assessment=read(HERE/'evaluation/assessment.json')
    if sha(HERE/'evaluation/policy.json')!=assessment['policy_sha256']:
        raise ValueError('Policy hash mismatch')
    summary=outcome_summary(assessment)
    for caller in read(HERE/'evaluation/caller_checks.json'):
        if caller['exit_code']!=0 or sha(HERE/'evaluation'/caller['file'])!=caller['sha256']:
            raise ValueError('Saved caller receipt/source mismatch')
    timing=read(HERE/'evaluation/second_batch_timing.json')['rows']
    residual=max(abs(r['latest_role_return_epoch']-r['started_epoch']-r['uniform_first_dispatch_to_last_role_return_seconds']) for r in timing)
    if residual>0.001:raise ValueError('Saved timestamp arithmetic mismatch')
    process=output/'process';shutil.copytree(HERE/'process',process)
    raw=process/'extraction/events.jsonl'
    with gzip.open(process/'extraction/events.jsonl.gz','rb') as zipped,raw.open('wb') as out:
        shutil.copyfileobj(zipped,out)
    expected_sha=read(HERE/'PROVENANCE.json')['compressed_event_input']['uncompressed_sha256']
    if sha(raw)!=expected_sha:raise ValueError('Event archive hash mismatch')
    bundle=read(process/'source_bundle_manifest.json')
    for item in bundle['final_sources'].values():
        source=process/item['bundled_path']
        if sha(source)!=item['sha256']:raise ValueError('Bundled final-source hash mismatch')
    for path in ['analysis/analyze.py','analysis/environment_analysis.py','semantic/summarize.py','semantic/validate_annotations.py','interventions/validate_replay.py','interventions/test_parameter_boundaries.py']:
        run_script(process/path,output)
    for path in ['analysis/summary.json','analysis/run_summary.json','semantic/summary.json']:
        if read(process/path)!=read(HERE/'process'/path):
            raise ValueError('Recomputed data differ from frozen results: '+path)
    new_env=read(process/'analysis/environment_summary.json');old_env=read(HERE/'process/analysis/environment_summary.json')
    if new_env!=old_env:raise ValueError('Environment summary differs from frozen results')
    annotations=read(process/'semantic/summary.json')
    provenance=read(process/'semantic/summary_provenance.json')
    if provenance.get('second_agent_records')!=44 or provenance.get('lead_investigator_records')!=22:
        raise ValueError('Incorrect review provenance')
    if read(process/'semantic/validation.json')['issues']:raise ValueError('Invalid source references')
    checks={'rows':66,'outcome_and_time_tables_match':True,'process_tables_match':True,
        'bundled_final_sources':len(bundle['final_sources']),'timestamp_arithmetic_max_error_seconds':residual,
        'review_provenance':{'second_agent_records':44,'lead_investigator_records':22,'all_nonblind':True},
        'source':{'assessment_sha256':sha(HERE/'evaluation/assessment.json'),'events_sha256':sha(raw)},
        'scope':'Recomputed frozen assessments, event classifications, annotations and static argument checks. No fresh mathematical judging, Lean build or model run.'}
    dump(output/'verification.json',checks)
    dump(output/'outcomes_and_time.json',summary)
    table=['# Recomputed results','','Counts use the common mathematical-outcome policy. Elapsed time includes documented waiting and continuations.','','| Batch | Configuration | Passed / tasks | Median elapsed minutes |','|---|---|---|---|']
    for batch,arms in summary.items():
        for arm,row in arms.items():table.append(f"| {batch} | {arm} | {row['pass']} / 11 | {row['median_minutes']:.2f} |")
    table += ['','## First-retrieval records','','| Final connection | Records |','|---|---|']
    for key,count in annotations['cohorts']['first_math_retrieval']['final_adoption'].items():table.append(f'| {key} | {count} |')
    (output/'TABLES.md').write_text('\n'.join(table)+'\n',encoding='utf-8')
    with (output/'task_results.csv').open('w',newline='',encoding='utf-8') as stream:
        writer=csv.DictWriter(stream,fieldnames=['batch','arm','group','outcome','recorded_outcome','minutes','estimated_time','reason'])
        writer.writeheader();writer.writerows({k:r[k] for k in writer.fieldnames} for r in assessment['rows'])
    print(json.dumps(checks,ensure_ascii=False,indent=2))

if __name__=='__main__':main()
