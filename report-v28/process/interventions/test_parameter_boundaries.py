"""Synthetic boundary checks, separate from the historical replay."""
import json
from pathlib import Path
from parameter_preflight import validate

cases=[]
def add(name,tool,args,accepted):cases.append((name,tool,args,accepted))
for value,accepted in [(.1,True),(600,True),(.09,False),(601,False),(0,False),(float('nan'),False),(float('inf'),False),(None,False),('bad number',False),('600',True),(True,True)]:
    add('timeout '+repr(value),'container_exec',{'command':'arbitrary text; never executed','timeout_seconds':value},accepted)
add('default timeout','container_exec',{'command':''},True)
add('unknown exec key','container_exec',{'command':'text','max_lines':10},False)
add('missing command','container_exec',{},False)
add('nonstr command','container_exec',{'command':['x']},False)
add('command exactly maximum','container_exec',{'command':'x'*100000},True)
add('command above maximum','container_exec',{'command':'x'*100001},False)
add('read defaults','read_artifact',{'artifact_id':'artifact-id'},True)
for value,accepted in [(1,True),(1000,True),(1001,False),(0,False),(1.5,False),(True,False),('10',False)]:
    add('max_lines '+repr(value),'read_artifact',{'artifact_id':'artifact-id','max_lines':value},accepted)
add('start line zero','read_artifact',{'artifact_id':'artifact-id','start_line':0},False)
add('start line high','read_artifact',{'artifact_id':'artifact-id','start_line':100001},True)
add('unknown read key','read_artifact',{'artifact_id':'id','path':'x'},False)
add('missing artifact','read_artifact',{},False)
results=[]
for name,tool,args,accepted in cases:
    result=validate(tool,args)
    results.append({'name':name,'expected_accepted':accepted,'actual_accepted':result['accepted'],'passed':result['accepted']==accepted,'errors':result['errors'],'schema_warnings':result['schema_warnings']})
    assert result['accepted']==accepted,name
unsupported=validate('build_check',{'candidate_id':'c1'})
assert unsupported['supported'] is False and unsupported['accepted'] is None
out={'fixture_kind':'synthetic boundary cases; not observed research calls','passed':len(results),'total':len(results),'unsupported_tool_explicit':True,'results':results}
(Path(__file__).resolve().parent/'argument_replay/boundary_tests.json').write_text(json.dumps(out,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps({k:v for k,v in out.items() if k!='results'},ensure_ascii=False))
