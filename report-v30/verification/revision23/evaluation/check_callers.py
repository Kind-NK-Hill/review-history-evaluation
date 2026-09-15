from pathlib import Path
import json, subprocess, hashlib, uuid
HERE=Path(__file__).resolve().parent
ROOT=next(p for p in HERE.parents if (p/'ProbabilityTheoryFormalization/AGENTS.md').is_file())
E=ROOT/'review_history_retro_20260901/research_framework/replication_20260913/acceptance'
results=[]
for slot,leaf in [('r2-m1-a','M1'),('r2-l3-c','L3')]:
    cfg=json.loads((E/slot/'technical/container.json').read_text())
    volume=next(x['Name'] for x in cfg['Mounts'] if x['Destination']=='/work')
    name='report23-check-'+leaf.lower()+'-'+uuid.uuid4().hex[:8]
    args=['docker','run','--name',name,'--network','none','--mount',f'type=volume,source={volume},target=/work,readonly','--mount',f'type=bind,source={HERE},target=/checks,readonly','--entrypoint','/bin/bash','-w','/work/ProbabilityTheoryFormalization',cfg['Image'],'--noprofile','--norc','-c',f'lake env lean /checks/{leaf}.lean']
    p=subprocess.run(args,capture_output=True,text=True,encoding='utf-8',errors='replace',timeout=240)
    (HERE/(leaf+'.log')).write_text(p.stdout+'\n'+p.stderr,encoding='utf-8')
    results.append({'slot':slot,'file':leaf+'.lean','sha256':hashlib.sha256((HERE/(leaf+'.lean')).read_bytes()).hexdigest(),'exit_code':p.returncode,'image':cfg['Image'],'original_volume_read_only':volume,'command':args,'output':p.stdout+p.stderr})
    print(slot,p.returncode,(p.stdout+p.stderr)[-2200:],flush=True)
(HERE/'caller_checks.json').write_text(json.dumps(results,ensure_ascii=False,indent=2),encoding='utf-8')
