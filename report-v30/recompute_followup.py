"""Recompute matched-task sensitivity from frozen rows; never execute logged commands."""
from pathlib import Path
import argparse,json,math,statistics
R=Path(__file__).resolve().parent
def load(p):return json.loads(p.read_text(encoding='utf-8'))
def compute():
 rows=[r for r in load(R.parent/'report-v28/evaluation/assessment.json')['rows'] if r['batch']==2]
 keys={(r['group'],r['arm']) for r in rows}
 assert len(rows)==len(keys)==33
 groups={r['group'] for r in rows};assert len(groups)==11
 assert all(math.isfinite(r['minutes']) and r['minutes']>=0 for r in rows)
 by={(r['group'],r['arm']):r['minutes'] for r in rows}
 def summarize(skip):
  keep=sorted(groups-set(skip));values={a:[by[g,a] for g in keep] for a in 'ABC'}
  sums={a:sum(v) for a,v in values.items()}
  return {'n':len(keep),'sum':sums,'median':{a:statistics.median(v) for a,v in values.items()},'B_minus_C':sums['B']-sums['C'],'B_faster':sum(by[g,'B']<by[g,'C'] for g in keep),'C_faster':sum(by[g,'C']<by[g,'B'] for g in keep)}
 data={'all':summarize([]),'without_H1':summarize(['H1']),'without_H1_M2_L6':summarize(['H1','M2','L6']),'leave_one_out':{g:summarize([g]) for g in sorted(groups)}}
 expected=load(R/'research/analysis_20260915/two_pass_review_20260915/round2/sensitivity.json')
 def compare(a,b):
  if isinstance(a,dict):
   for k,v in a.items():compare(v,b[k])
  else:assert math.isclose(a,b,rel_tol=1e-10,abs_tol=1e-8),(a,b)
 compare(data,expected)
 p=load(R/'research/analysis_20260915/final_research_supplement_20260915/evidence/progress_observations.json')
 times={x['event']:x['time_min'] for x in p['states']}
 gap=times['E154']-times['E053'];assert math.isclose(gap,p['elapsed_first_local_check_to_author_check_min'],abs_tol=1e-8)
 return {'matched_task_sensitivity':data,'M2_first_helper_to_author_check_minutes':gap,'frozen_results_match':True,'new_semantic_judgments':False,'new_model_runs':False}
if __name__=='__main__':
 a=argparse.ArgumentParser();a.add_argument('--output',type=Path);o=a.parse_args();data=compute()
 if o.output:
  with o.output.open('x',encoding='utf-8') as f:json.dump(data,f,ensure_ascii=False,indent=2);f.write('\n')
 print(json.dumps({'passed':True,'groups':11,'B_minus_C':data['matched_task_sensitivity']['all']['B_minus_C'],'without_H1_M2_L6':data['matched_task_sensitivity']['without_H1_M2_L6']['B_minus_C'],'M2_interval':data['M2_first_helper_to_author_check_minutes']}))
