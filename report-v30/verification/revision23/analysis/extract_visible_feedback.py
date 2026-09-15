from pathlib import Path
import json,hashlib
O=Path(__file__).resolve().parent;H=O.parent
p=H/'runs/r2-m2-b/author-01/full-public-trace.jsonl'

def strings(value,depth=0):
    if depth>16:return
    if isinstance(value,dict):
        for v in value.values():yield from strings(v,depth+1)
    elif isinstance(value,list):
        for v in value:yield from strings(v,depth+1)
    elif isinstance(value,str):
        yield value
        try:decoded=json.loads(value)
        except (ValueError,TypeError):return
        if decoded!=value:yield from strings(decoded,depth+1)

out=[]
for line in p.read_bytes().split(b'\n'):
    if not line.strip():continue
    event=json.loads(line)
    if event.get('type')!='response_item' or event.get('payload',{}).get('type')!='function_call_output':continue
    matches=[s for s in strings(event) if '平方子列扩展是循环论证' in s]
    if matches:
        out.append({'ordinal':event['ordinal'],'timestamp':event['timestamp'],
                    'call_id':event['payload'].get('call_id'),'decoded_visible_text':min(matches,key=len),
                    'raw_event':event})
result={'source':str(p),'source_sha256':hashlib.sha256(p.read_bytes()).hexdigest(),
        'method':'Recursive JSON decoding of recorded model-visible function output; no hidden reasoning read or exported.',
        'events':out}
(O/'M2B_FEEDBACK_VISIBLE.json').write_text(json.dumps(result,ensure_ascii=False,indent=2),'utf-8')
print(json.dumps({'matching_visible_events':len(out),'ordinals':[e['ordinal'] for e in out]}))
