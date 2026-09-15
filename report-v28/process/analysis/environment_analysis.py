"""Inventory explicit command-lookup and parameter-rejection feedback."""
from pathlib import Path
import collections, datetime, hashlib, json, re
B=Path(__file__).resolve().parents[1]
RX=re.compile(r'^(?:/bin/)?(?:ba)?sh:\s*(?:line\s+)?\d+:\s*([^:\n]+):\s*(?:command not found|not found)\s*$',re.M)

def main():
    rows=[];protocol=[]
    for line in (B/'extraction/events.jsonl').open(encoding='utf-8'):
        e=json.loads(line)
        if e['tool_family']!='service':continue
        missing=sorted(set(x.strip() for x in RX.findall(e.get('stderr') or '')))
        if missing:
            rows.append({k:e.get(k) for k in ['event_id','run_id','config','task','session_id','actor','role','dispatch_time','result_time','exit_code','elapsed_seconds','source_file','source_line','result_source_file','result_source_line'] } | {'unavailable_commands':missing,'diagnostic_lines':[x for x in (e.get('stderr') or '').splitlines() if RX.fullmatch(x)],'input_command':e['arguments'].get('command','')})
        if e.get('exit_code') is None and re.search(r'Mcp error: -32603: (?:container_exec argument out of range|argument out of range: max_lines|invalid container_exec arguments|could not convert string to float:)', e.get('output_text') or ''):
            protocol.append({k:e.get(k) for k in ['event_id','run_id','config','tool','arguments','source_file','source_line','result_source_file','result_source_line','output_text']})
    rows.sort(key=lambda r:r['dispatch_time'])
    seen=set()
    for r in rows:
        r['commands_previously_reported_unavailable_in_same_session']=[cmd for cmd in r['unavailable_commands'] if (r['session_id'],cmd) in seen]
        seen.update((r['session_id'],cmd) for cmd in r['unavailable_commands'])
    summary={'observed_calls':len(rows),'affected_runs':len({r['run_id'] for r in rows}),'affected_sessions':len({r['session_id'] for r in rows}),'outer_exit_zero':sum(r['exit_code']==0 for r in rows),'later_same_session_unavailability_calls':sum(bool(r['commands_previously_reported_unavailable_in_same_session']) for r in rows),'commands':{},'configs':{},'protocol_no_exit_code_calls':len(protocol),'input_sha256':hashlib.sha256((B/'extraction/events.jsonl').read_bytes()).hexdigest(),'interpretation':'Counts explicit unavailable-command feedback in actual stderr. Multiple diagnostics within a call count once. Repeated feedback does not independently prove waste or a causal time penalty.'}
    for cmd in sorted({x for r in rows for x in r['unavailable_commands']}):
        rr=[r for r in rows if cmd in r['unavailable_commands']]
        summary['commands'][cmd]={'calls':len(rr),'runs':len({r['run_id'] for r in rr}),'sessions':len({r['session_id'] for r in rr})}
    for config in 'ABC':
        rr=[r for r in rows if r['config']==config]
        summary['configs'][config]={'calls':len(rr),'runs':len({r['run_id'] for r in rr}),'sessions':len({r['session_id'] for r in rr}),'outer_exit_zero':sum(r['exit_code']==0 for r in rr),'later_same_session_unavailability_calls':sum(bool(r['commands_previously_reported_unavailable_in_same_session']) for r in rr)}
    for name,x in [('environment_candidates.json',rows),('protocol_errors.json',protocol),('environment_summary.json',summary)]:
        (B/'analysis'/name).write_text(json.dumps(x,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(summary,ensure_ascii=False,indent=2))
if __name__=='__main__':main()
