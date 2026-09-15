"""Read-only archive extraction. All writes are constrained to this new directory."""
import csv, hashlib, json, pathlib, re, collections, datetime, zipfile
ROOT=pathlib.Path('D:/Grad_Study/Practimum/Formalization')
OUT=pathlib.Path(__file__).resolve().parent
TEAM=OUT.parent; V=TEAM/'combined_revision_v7_20260912'
CONS=ROOT/'review_history_retro_20260901/research_framework/full_workflow_eval_codesign_20260910/evaluation_consistency_r1_20260911'
HIST=ROOT/'review_history_retro_20260901/research_framework/evaluation_rebuild_v2_20260907'
E19=ROOT/'reports/pipeline_evolution/releases/v0.3.1/evidence/E19'
tracked={}; entries=[]; gaps=[]
def read(p):
 p=pathlib.Path(p); b=p.read_bytes(); tracked[str(p)]=hashlib.sha256(b).hexdigest(); return b.decode('utf-8-sig')
def j(p): return json.loads(read(p))
def sha(p):
 p=pathlib.Path(p); h=hashlib.sha256(p.read_bytes()).hexdigest(); tracked[str(p)]=h; return h
def alias(x):
 if isinstance(x,dict): return {alias(k):alias(v) for k,v in x.items()}
 if isinstance(x,list): return [alias(y) for y in x]
 if isinstance(x,str):
  x=x.replace(str(ROOT),'ROOT').replace(ROOT.as_posix(),'ROOT')
  x=x.replace('C:\\Users\\kdsde','USER_HOME').replace('C:/Users/kdsde','USER_HOME')
  return x.replace('ROOT\\','ROOT/')
 return x
def write(name,s):
 p=OUT/name; assert p.resolve().is_relative_to(OUT);p.parent.mkdir(parents=True,exist_ok=True);p.write_text(s,encoding='utf-8',newline='\n')
def dump(name,o):write(name,json.dumps(alias(o),ensure_ascii=False,indent=2)+'\n')
def extract(eid,p,pointers=None,lines=None,title='',namespace='',inline=True):
 p=pathlib.Path(p)
 if not p.exists():gaps.append({'id':eid,'source':alias(str(p)),'status':'本次未找到'});return None
 s=read(p); original_sha=tracked[str(p)]
 if lines:
  ls=s.splitlines(); data='\n\n'.join(f'[original lines {a}-{min(b,len(ls))}]\n'+'\n'.join(ls[a-1:b]) for a,b in lines); locator='; '.join(f'lines {a}-{b}' for a,b in lines); ext='txt'
 elif pointers is not None:
  obj=json.loads(s);data={}
  for pointer in pointers:
   val=obj
   try:
    for part in pointer.strip('/').split('/') if pointer else []:val=val[int(part)] if isinstance(val,list) else val[part.replace('~1','/').replace('~0','~')]
    data[pointer]=val
   except (KeyError,IndexError): data[pointer]={'packaging_note':'pointer missing'}
  locator=', '.join(pointers) or '(whole object)';ext='json'
 else:
  try:data=json.loads(s);ext='json';locator='(whole object)'
  except ValueError:data=s;ext='txt';locator=f'lines 1-{len(s.splitlines())}'
 filename=f'sources/{eid}.{ext}'; content=json.dumps(alias(data),ensure_ascii=False,indent=2) if ext=='json' else alias(data)
 write(filename,content+'\n')
 item={'id':eid,'title':title or p.name,'namespace':namespace,'original_path':alias(str(p)),'original_sha256':original_sha,'locator':locator,'package_file':filename,'package_sha256':hashlib.sha256((OUT/filename).read_bytes()).hexdigest(),'transformation':'摘录/JSON序列化；ROOT及USER_HOME路径别名；原字段不改；并非原字节副本','status':'已核对原记录'}
 entries.append(item)
 item['_excerpt']=content if inline and len(content)<14000 else ''
 return eid
def csvwrite(name,rows):
 keys=list(dict.fromkeys(k for row in rows for k in row));p=OUT/name
 with p.open('w',encoding='utf-8-sig',newline='') as f:
  w=csv.DictWriter(f,fieldnames=keys);w.writeheader()
  for row in rows:w.writerow({k:json.dumps(alias(v),ensure_ascii=False,separators=(',',':')) if isinstance(v,(dict,list)) else alias(v) for k,v in row.items()})
def pick(d,keys):return {k:d[k] for k in keys if k in d}
def recursive(o):
 if isinstance(o,dict):
  yield o
  for x in o.values():yield from recursive(x)
 elif isinstance(o,list):
  for x in o:yield from recursive(x)

# Frozen state and lightweight extraction, no analysis reruns.
z=j(V/'ev/Z002'); registry=j(V/'ev/Z008'); costs=j(V/'ev/Z011'); current=j(V/'ev/Y002_CURRENT_MAIN_RESULTS.json'); metrics=j(V/'DERIVED_RUN_METRICS.json'); bindings=j(CONS/'ROOT_ENDPOINT_BINDINGS.json'); census=j(CONS/'ATTEMPT_CENSUS_DATA.json')
roots={x['root_id']:x for x in z['all_41_root_rows']}; main={x['root_id']:x for x in current['main_rows']}; regs={x['root_id']:x for x in registry['runs']}; natives={x['root_id']:x for x in census['solver_roots']}; bound={x['root_id']:x for x in bindings['roots']}
extract('B01',V/'ev/Z002',['/cutoff_epoch','/cutoff_beijing','/version_denominators','/scope'],namespace='Z002')
extract('B02',V/'DERIVED_RUN_METRICS.json',['/schema','/rules','/summaries'],namespace='revision7 DERIVED_RUN_METRICS')
extract('B03',CONS/'assemble_final_delivery_r1.py',lines=[(1,74)],title='已归档主表选入程序（只读）',namespace='Z synthesis source')
extract('A01',V/'ev/Y001_CURRENT_ACCEPTANCE.zh-CN.md',namespace='Y001')
extract('A02',V/'ev/Y002_CURRENT_MAIN_RESULTS.json',namespace='Y002',inline=False)
extract('A03',V/'ev/Y005_PROCESSING_REPAIRS.json',namespace='Y005')
extract('A04',V/'ev/Y006_TEST_RESULTS.json',namespace='Y006')
extract('A05',V/'ev/Y007_STAGE_COMPLETED.json',namespace='Y007')
for n,name in enumerate(['RULE_INTERPRETATION.json','H1_DETAILED_RULE_R1.json','H1_DELIVERY_EVIDENCE_SCOPE_ADDENDUM_R1.json','H1_DELIVERY_ORIGINAL_PROVENANCE_R1.json','L3_RULE_AND_CANDIDATE_ROSTER.json','L3_PRE_EVALUATION_SCOPE_ADDENDUM_R1.json','L3_TASK_TAIL_READING_REGISTRATION_R1.json','L7_CONTRACT_DIAGNOSIS.json','L2_REASSESSMENT_PLAN.json','L3_REASSESSMENT_PLAN.json','H1_REASSESSMENT_PLAN.json','H1_ADJUDICATION_PLAN.json'],10):
 extract(f'A{n}',CONS/name,namespace='consistency r1',inline=n<18)
for n,name in enumerate(['X003_ATTRIBUTION_AND_SCOPE.json','X012_FINAL_SCOPE_CLARIFICATION.json','X020_NEW_RESOURCE_LEDGER.json','X027_RESOURCE_AUDIT.json','X053_REVIEW_RESULT.json','X058_REVIEW_RESULT.json'],30):extract(f'A{n}',V/'ev'/name,namespace=name.split('_')[0])
extract('B04',CONS/'FROZEN_LIBRARY_BINDING.json',namespace='Z frozen library')
extract('B05',CONS/'FULL_SOURCE_CONTRACT_SCAN_11_R2.json',namespace='consistency full contract scan',inline=False)
extract('B06',V/'evidence/SETTINGS_INPUTS.json',namespace='I settings manifest',inline=False)
extract('B09',V/'ev/I18088',lines=[(1,20),(173,181)],namespace='I18088 frozen M2 source',title='M2 原始四阶矩条件（最小教材片段）')
extract('B10',V/'ev/I18089',namespace='I18089 frozen M2 task',title='M2 准备摘要的中心化四阶矩条件')
extract('B12',ROOT/'ep-a-stage-l7/development-ac-r1/cases/a5ef5c2f70ca8ec650cd55ef69e1ea9bb0f37cc956f22c4dd8115aa4740df669/subject/upstream/ProbabilityTheory/chapter_10/thm_10_11.lean',namespace='original A-L7 endpoint input',title='L7 上游清单额外项：空白目标注释')
ep=CONS.parent/'formal_endpoint_20260911/endpoint.py'
assert sha(ep)=='95acef5cc3987c4d587797c178d7c3a1cd89f8de103563d28855b08866c4b9e6'
extract('A06',ep,lines=[(245,360),(507,575),(605,744)],namespace='original endpoint; hash matches pinned execution manifest',title='原终验实际绑定程序：输入、格式、会话与裁决')
for name in ['report.en.md','appendix.en.md']:
 extract('BASE-'+name.split('.')[0],TEAM/'Revisions from 913'/name,lines=[(1,24)],namespace='user revision9 exact baseline')

# Use existing root bindings to join original and reevaluation candidate identities.
decision_root={}
for rid,row in roots.items():
 for b in row['all_original_evaluation_sources']:
  if b and b.get('path'):decision_root[str(pathlib.Path(b['path']))]=rid
 for obj in recursive(bound[rid]):
  for key,val in obj.items():
   if isinstance(val,str) and val.endswith('decision.json'):decision_root[str(pathlib.Path(val))]=rid
candidate_map={}
for f in ['L2_REASSESSMENT_PLAN.json','L3_REASSESSMENT_PLAN.json','H1_REASSESSMENT_PLAN.json','LEGACY_AFFECTED_CANDIDATE_ROSTER_R1.json']:
 for o in recursive(j(CONS/f)):
  if o.get('candidate_id') and o.get('original_decision'):
   dec=o['original_decision'];dec=dec.get('path') if isinstance(dec,dict) else dec
   candidate_map[o['candidate_id']]={'root_id':decision_root.get(str(pathlib.Path(dec))),**pick(o,['private_source_arm','development_version','original_case','original_verdict']),'original_decision':dec}
for o in current['affected_and_supplementary_rows']:
 if o.get('candidate_id'):
  dec=o.get('original_decision',{}); dec=dec.get('path') if isinstance(dec,dict) else dec
  if dec:candidate_map.setdefault(o['candidate_id'],{'root_id':decision_root.get(str(pathlib.Path(dec))),'private_source_arm':o.get('arm'),'original_decision':dec})

runrows=[]; root_evidence=[]
for i,(rid,row) in enumerate(roots.items()):
 n=natives[rid];g=regs[rid];cur=main.get(rid); decision=row.get('original_selected_decision') or {}; cand={}; inputfiles=[]
 if decision.get('path'):
  p=pathlib.Path(decision['path']);case=p.parent.parent
  if p.exists():cand=pick(j(p),['candidate_id','anonymous_candidate_id','input_binding_sha256','verdict','decision_method','reason'])
  ip=case/'input-binding.json'
  if ip.exists():
   ib=j(ip);inputfiles=ib.get('files',[]);cand['input_binding_file_sha256']=sha(ip);cand['input_binding_path']=str(ip);cand['protocol']=pick(ib,['schema','protocol_epoch','prompt_template_version','candidate_package_status','evaluation_scope','formal_comparison_eligible'])
  else:ib={}
 else:ib={}
 rolecalls=[pick(c,['dispatch_id','role','runtime_role','model','effort','receipt','receipt_sha256','source_session','record_gap']) for c in costs['calls'] if c.get('root_id')==rid and c['category'].startswith('solver_')]
 evidence={'root_id':rid,'original_frozen_row':row,'native_registry':{k:v for k,v in g.items() if k not in ['resolved_recorded_public_configs']},'input_files':inputfiles,'selected_candidate':cand,'native_census':n,'actual_solver_roles':rolecalls,'resolved_recorded_public_configs':g.get('resolved_recorded_public_configs'), 'endpoint_binding':pick(bound[rid],['rules','selected_original_evaluation','selection_rule','selection_reason'])}
 root_evidence.append(evidence)
 rr={'root_id':rid,'task_group':row['task_group'],'arm':row['arm'],'version_subset':row['version_subset'],'main_panel':rid in main,'run_id':row['run_id'],'selected_candidate_identity':cand,'original_selected_decision':decision,'original_selected_verdict':row['original_selected_verdict'],'current_main_verdict':cur.get('current_verdict') if cur else None,'current_reason':cur.get('reason') if cur else None,'current_criterion_source':'A01/A02' if cur else None,'selected_candidate_scope':row['selected_candidate_scope'],'same_root_continuation':row['same_root_continuation'],'repair_trial':row['repair_trial'],'selection_basis':'B03 recorded version filter; not proof of preregistration','input_manifest':inputfiles,'input_bindings':g.get('input_bindings'),'implementation_versions':g.get('role_versions'),'models_by_actual_role':rolecalls,'library_container_bindings':g.get('original_container_image_bindings'),'actual_stop_rule_source':g.get('actual_stop_rule_source'),'actual_stop_evidence':g.get('actual_stop_evidence'),'root_and_continuation_paths':g.get('root_and_continuation_paths'),'comparison_status':row['comparison_status'],'source_id':'B07','source_pointer':f'/roots/{i}','common_time_eligible':rid in main and row['task_group'] in metrics['summaries']['span_seconds']['groups'],'common_tokens_eligible':rid in main and row['task_group'] in metrics['summaries']['input_tokens']['groups']}
 rr.update(pick(n,['budget_seconds','first_dispatch_epoch','native_clock_start_epoch','candidate_submission_epoch','last_role_return_epoch','outer_controller_end_epoch','native_root_span_seconds','native_all_dispatches_closed','missing_actor_receipts','usage','usage_observed_lower_bound','usage_missing_call_counts']))
 runrows.append(rr)
dump('sources/B07-root-bindings.json',{'packaging_note':'Mechanical join; native clock snapshots were already in Z008. No database or runtime executed. Input files are frozen endpoint views, not blanket proof of identical original solver inputs.','sources':{str(p):sha(p) for p in [V/'ev/Z002',V/'ev/Z008',CONS/'ATTEMPT_CENSUS_DATA.json',CONS/'ROOT_ENDPOINT_BINDINGS.json',V/'ev/Z011']},'roots':root_evidence})
csvwrite('RUN_INDEX.csv',runrows)

# Read only tiny receipts, requests and final public assessment objects; no full role logs.
calls=[c for c in costs['calls'] if c['category'] in ['original_common_endpoint','consistency_reevaluation']]
xledger=j(V/'ev/X020_NEW_RESOURCE_LEDGER.json')
for x in xledger['actual_receipts']:
 p=x.get('receipt') or x.get('path') or x.get('actor_receipt');
 if not p:
  p=next(v for v in x.values() if isinstance(v,str) and v.endswith('actor-receipt.json'))
 receipt=j(p);calls.append({'category':'L7_supplement_0517','receipt':p,'dispatch_id':receipt['dispatch_id'],'model':receipt['model'],'effort':receipt['reasoning_effort']})
evalrows=[]; evalsources=[]
for i,c in enumerate(calls):
 p=pathlib.Path(c['receipt']);receipt=j(p);attempt=p.parents[1];case=p.parents[4];slot=p.parents[2].name;cp=case.name;candidate=cp.replace('-adjud','');rid=c.get('root_id') or candidate_map.get(candidate,{}).get('root_id')
 resultpath=attempt/'trusted-evaluation.json'
 if not resultpath.exists():resultpath=attempt/'REVIEW_RESULT.json'
 if not resultpath.exists():resultpath=attempt/'trusted-execution-failure.json'
 if not resultpath.exists():resultpath=case/'results'/f'{slot}.json'
 result=j(resultpath) if resultpath.exists() else {};assessment=result.get('assessment',result) or {};requestp=case/'requests'/f'{slot}.json'
 if not requestp.exists() and slot=='adjudicator':requestp=case/'arbitration/request.json'
 request=j(requestp) if requestp.exists() else {};configp=p.parent/'worker-config.json';cfg=j(configp) if configp.exists() else {};command=cfg.get('command',[])
 raw_public_source=None; raw_public=None
 if not result or result.get('assessment_origin')=='trusted_execution_failure':
  lp=p.parent/'raw-public-events.bin'
  if lp.exists():
   msgs=[]
   for ln,line in enumerate(read(lp).splitlines(),1):
    try:lo=json.loads(line)
    except ValueError:continue
    if lo.get('type')=='item.completed' and lo.get('item',{}).get('type')=='agent_message':msgs.append((ln,lo['item'].get('text','')))
   if msgs:
    ln,txt=msgs[-1];clean=re.sub(r'^```(?:json)?\s*|\s*```$','',txt.strip())
    try:raw_public=json.loads(clean);assessment=raw_public
    except ValueError:pass
    raw_public_source={'path':str(lp),'sha256':sha(lp),'line':ln,'scope':'last public agent message only'}
 model=command[command.index('-m')+1] if '-m' in command else request.get('model');effort=next((s.split('=',1)[1].strip('"') for s in command if s.startswith('model_reasoning_effort=')),request.get('effort'))
 if not rid and c['category']=='L7_supplement_0517':rid=next(k for k,v in roots.items() if v['arm']=='C' and v['task_group']=='L7' and k in main)
 related=roots.get(rid,{});finalp=case/'final/decision.json';final=j(finalp) if finalp.exists() else {};ibp=case/'input-binding.json';ib=j(ibp) if ibp.exists() else {};policies={str(q):sha(q) for q in case.glob('*POLICY*.json')};summaryp=attempt/'execution-summary.json';summary=j(summaryp) if summaryp.exists() else {}
 rawvotes={k:v for k,v in assessment.items() if k=='verdict' or k.startswith('overall_') or k in ['confidence','dimensions','summary','limitations']}
 metadata=pick(receipt,['schema','run_id','arm','role','dispatch_id','model','reasoning_effort','source_session','parent_dispatch_id','session_ids','deadline','public_events_sha256','raw_public_events_sha256'])
 formatstatus=pick(result,['assessment_accepted','issues','source_exposure_verified','subject_manifest_unchanged','no_model_retry'])
 if 'execution_receipt' in result:formatstatus.update({'accepted_trusted_evaluation_exists':result.get('assessment_origin')!='trusted_execution_failure','assessment_origin':result.get('assessment_origin'),'accepted_or_synthetic_verdict':result.get('verdict'),'execution_receipt':result['execution_receipt']})
 if result.get('assessment_origin')=='trusted_execution_failure':formatstatus['failure_reason']=result.get('summary')
 original_results={str(q):sha(q) for q in (case/'results').glob('*.json')} if (case/'results').exists() else {}
 ev={'dispatch_id':receipt['dispatch_id'],'ledger_record':c,'receipt_source':{'path':str(p),'sha256':sha(p)},'receipt':metadata,'request_source':{'path':str(requestp),'sha256':sha(requestp)} if requestp.exists() else None,'request':pick(request,['schema','request_id','candidate_id','slot','model','effort','allowance_seconds','subject_manifest','prompt_sha256']),'worker_config_source':{'path':str(configp),'sha256':sha(configp)} if configp.exists() else None,'requested_model_flag':model,'requested_effort_flag':effort,'result_source':{'path':str(resultpath),'sha256':sha(resultpath)} if resultpath.exists() else None,'raw_assessment_fields':rawvotes,'format_and_execution':formatstatus,'original_result_files':original_results,'final_decision_source':{'path':str(finalp),'sha256':sha(finalp)} if finalp.exists() else None,'final_decision':pick(final,['schema','verdict','reason','reviewer_verdicts','adjudicator_verdict','adjudication_required','candidate_id','input_binding_sha256']),'input_protocol':pick(ib,['schema','protocol_epoch','prompt_template_version','formal_comparison_eligible']),'input_files':ib.get('files',[]),'pinned_implementation':summary.get('pinned_b_endpoint_implementation'),'candidate_mapping':candidate_map.get(candidate),'policy_sources':policies}
 ev['raw_public_source']=raw_public_source
 if raw_public:ev['raw_public_assessment']=raw_public
 evalsources.append(ev)
 evalrows.append({'dispatch_id':receipt['dispatch_id'],'stage':c['category'],'session_ids':receipt.get('session_ids'),'source_session':receipt.get('source_session'),'runtime_role':receipt.get('role'),'slot':slot,'root_id':rid,'task_group':related.get('task_group'),'candidate_arm':related.get('arm'),'runtime_receipt_arm':receipt.get('arm'),'candidate_version':related.get('version_subset'),'main_panel_root':rid in main,'candidate_id':assessment.get('candidate_id') or assessment.get('anonymous_candidate_id') or candidate,'case_directory_id':cp,'original_candidate_mapping':candidate_map.get(candidate),'request_id':assessment.get('request_id') or request.get('request_id'),'request_model':model,'request_effort':effort,'receipt_model':receipt.get('model'),'receipt_effort':receipt.get('reasoning_effort'),'platform_returned_model':None,'platform_returned_model_note':'Not present in checked receipt/request/session metadata; provider identity not inferred from request','input_rule_version':pick(ib,['protocol_epoch','prompt_template_version']) or pick(request,['schema','prompt_sha256']),'subject_manifest':request.get('subject_manifest'),'raw_verdicts':{k:v for k,v in rawvotes.items() if k=='verdict' or k.startswith('overall_')},'raw_confidence':assessment.get('confidence'),'format_status':formatstatus,'original_final_verdict':final.get('verdict'),'Y_current_root_verdict':main.get(rid,{}).get('current_verdict'),'Y_processing_or_reuse':'See A01/A02/A03; current verdict belongs to selected root candidate; supplementary/partial opinions not automatically selected','receipt_path':str(p),'receipt_sha256':sha(p),'source_id':'A40','source_pointer':f'/calls/{i}'})
dump('sources/A40-call-evidence.json',{'note':'Each record cites original receipt/request/result bytes and keeps model request versus receipt separate. Platform-returned model is not observed here. Arm on consistency runtime receipts is infrastructure metadata, not candidate arm.','calls':evalsources})
csvwrite('EVALUATION_INDEX.csv',evalrows)

# Full small version-specific prompts, and selected exception public objects.
seen=set()
for row,ev in zip(evalrows,evalsources):
 key=(row['stage'],row['task_group'] if row['stage']!='original_common_endpoint' else json.dumps(row['input_rule_version']),row['slot'].startswith('adjud'))
 if key not in seen:
  seen.add(key);p=pathlib.Path(ev['receipt_source']['path']).parent/'prompt.txt';extract(f'AP{len(seen):02}',p,namespace=row['stage'],title=f'{key} 原始实际请求',inline=False)
 if row['task_group']=='M3' or (row['task_group']=='H1' and (row['slot'].startswith('adjud') or ev['format_and_execution'].get('issues'))):
  rp=ev['result_source'];
  if rp:extract(f'AX{len([x for x in entries if x["id"].startswith("AX")])+1:02}',rp['path'],namespace=row['stage'],inline=False)

# History: frozen decision projection plus three existing members, no new judgments.
receipt=j(E19/'10_projection_receipt.json')
extract('C01',E19/'10_projection_receipt.json',['/analysis_revision','/investigation_sources','/decision_validation/status','/decision_validation/scope','/decision_validation/target_decisions','/decision_validation/positive','/decision_validation/registered_subject_binding_conflicts','/decision_validation/positive_and_registered_object_eligible','/decision_validation/confirmed_boundaries','/decision_validation/unknown_decisions','/main_exclusions','/coverage','/limitations'],namespace='E19/10',inline=False)
decpath=HIST/'investigation/revisions/v0.7.1/source_decisions/target_change_adjudications.jsonl';mappath=HIST/'investigation/revisions/v0.7.1/source_decisions/main_relation_qualification_map.jsonl'
decisions=[json.loads(s) for s in read(decpath).splitlines()];relations=[json.loads(s) for s in read(mappath).splitlines()]
chosen=['rel_1cc426169a021d9dd54961c8','rel_371ecb44ba45170919976d80','rel_7b7d8c2be77fd84f07915a2b']
for i,rid in enumerate(chosen,2):
 for p,rows in [(mappath,relations),(decpath,decisions)]:
  match=next((k for k,o in enumerate(rows) if o['relation_id']==rid),None)
  if match is not None:extract(f'C0{i}-'+('map' if p==mappath else 'decision'),p,lines=[(match+1,match+1)],namespace='E19 frozen v0.7.1',title=rid)
extract('C05',HIST/'investigation/rebuild_v071_decisions.py',lines=[(1,36),(126,175),(240,285),(310,346)],namespace='E19 historical decision projection code')
extract('C06',HIST/'investigation/revisions/v0.7.1/source_decisions/revision_provenance.json',namespace='E19 v0.7.1 history')
extract('C07',HIST/'investigation/revisions/v0.7.1/source_decisions/qualification_validation.json',namespace='E19 v0.7.1 validation',inline=False)
# Sampling marker, preserve full algorithm but do not execute it.
extract('E01',E19/'16_selection_rule.py.txt',lines=[(1,190)],namespace='E19/16')
selection=j(E19/'15_selection.json');selkeys=[k for k in selection if any(x in k for x in ['stratum','semantics','seed','rule','inputs_used','inputs_not','note'])];extract('E02',E19/'15_selection.json',['/'+k for k in selkeys],namespace='E19/15')

# A-L1 recovery: only known small files and public final JSON from one pointed log.
a=ROOT/'fw_pilot_20260910_staging/pilot-runs-r1/pilot-prob_13_9-A-r1';helpdir=a/'help/a8eee636-20ec-4f4a-abd8-21254581e629';rec=j(a/'reviewer-result-recovery.json')
extract('D01',a/'reviewer-result-recovery.json',namespace='N02')
extract('D02',helpdir/'actor/actor-receipt.json',['/schema','/run_id','/dispatch_id','/parent_dispatch_id','/session_ids','/source_session','/model','/reasoning_effort','/deadline','/raw_public_events_sha256'],namespace='N11')
extract('D03',helpdir/'recovered-raw-review.json',namespace='N02')
extract('D04',a/'a-controller/result.json',['/schema','/run_id','/status','/blocker','/turns','/author_session','/deadline','/workflow_claim'],namespace='N02')
log=helpdir/'actor/raw-public-events.bin';finals=[];thread_events=[]
for num,line in enumerate(read(log).splitlines(),1):
 try:o=json.loads(line)
 except ValueError:continue
 if o.get('type')=='thread.started':thread_events.append({'line':num,'event':o})
 item=o.get('item',{})
 if o.get('type')=='item.completed' and item.get('type')=='agent_message':finals.append((num,line))
if finals:
 num,_=finals[-1];extract('D05',log,lines=[(x['line'],x['line']) for x in thread_events]+[(num,num)],namespace='N02 pointed public log',title='仅会话起始标识和最后公开回复；未摘取私有推理')

# Missing usage comes from the ledger, never inferred to meet a target count.
missing=[c for c in costs['calls'] if c['category'].startswith('solver_') and any(v is None for v in c.get('usage',{}).values())]
dump('sources/B08-missing-usage.json',{'original_source':alias(str(V/'ev/Z011')),'original_sha256':sha(V/'ev/Z011'),'selection':'solver categories with one or more recorded usage field null','calls':missing})

summary={'packaging_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'mechanical_checks_only':True,'root_count':len(runrows),'main_count':sum(x['main_panel'] for x in runrows),'main_pass_by_arm':dict(collections.Counter(x['arm'] for x in current['main_rows'] if x['current_verdict']=='pass')),'call_counts':dict(collections.Counter(x['stage'] for x in evalrows)),'missing_root_join_calls':[x['dispatch_id'] for x in evalrows if not x['root_id']],'requested_models':dict(collections.Counter((x['request_model'] or 'unknown')+' / '+(x['request_effort'] or 'unknown') for x in evalrows)),'receipt_models':dict(collections.Counter((x['receipt_model'] or 'unknown')+' / '+(x['receipt_effort'] or 'unknown') for x in evalrows)),'sessions_count':len([s for x in evalrows for s in x['session_ids'] or []]),'unique_session_count':len(set(s for x in evalrows for s in x['session_ids'] or [])),'historical_relations':len(relations),'historical_positive':sum(d.get('fixed_source_target_comparable') is True for d in decisions),'historical_boundary':sum(d.get('fixed_source_target_comparable') is False for d in decisions),'historical_unknown':sum(r['target_decision_id'] is None for r in relations),'missing_usage_calls':len(missing),'gaps':gaps}
dump('sources/PACKAGING_CHECKS.json',summary)
dump('sources/SOURCE_INDEX.json',[{k:v for k,v in e.items() if k!='_excerpt'} for e in entries])
write('EVIDENCE.md','# 可离线核查的原始证据\n\nROOT 表示原 Formalization 工作区；USER_HOME 表示用户主目录。这些是来源定位别名，不是外部链接。原文件 SHA-256 针对读取的完整原始字节；包内文件为明确范围的摘录，另列哈希。没有复制整个日志、教材、数据库或私有推理。\n\n## 结构化证据\n\n- [B07：41 个运行的原字段与输入绑定](sources/B07-root-bindings.json)，RUN_INDEX 的 source_pointer 指向其 roots 数组；各源文件原始哈希列于文件头。\n- [A40：114 次评价的回执、请求与公开结果](sources/A40-call-evidence.json)，EVALUATION_INDEX 的 source_pointer 指向其 calls 数组；每个对象分列原文件路径和哈希。\n- [B08：缺失用量原账本行](sources/B08-missing-usage.json)。\n- [本次机械核对记录](sources/PACKAGING_CHECKS.json)。\n\n'+ '\n\n'.join(f'## {e["id"]} — {e["title"]}\n\n命名空间：`{e["namespace"]}`；状态：{e["status"]}。\n\n原路径：`{e["original_path"]}`\n\n原 SHA-256：`{e["original_sha256"]}`\n\n范围：`{e["locator"]}`\n\n[包内摘录]({e["package_file"]})；包内 SHA-256：`{e["package_sha256"]}`。转换：{e["transformation"]}。\n\n'+ ('```\n'+e['_excerpt']+'\n```' if e['_excerpt'] else '较长结构化对象保存在上述包内文件；无需访问原电脑。') for e in entries)+'\n')
dump('sources/READ_SOURCE_HASHES.json',{'sources':alias(tracked),'note':'Original bytes hashed during this packaging run; recheck performed at finalization.'})
print(json.dumps(summary,ensure_ascii=False,indent=2))
