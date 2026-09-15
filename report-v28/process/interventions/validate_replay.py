"""Replay arguments only, against prototype and pure guards extracted by AST."""
from pathlib import Path
import ast,collections,copy,datetime,hashlib,json
from parameter_preflight import validate

HERE=Path(__file__).resolve().parent;BASE=HERE.parent
RUNTIME=BASE/'inputs/runtime'

def guard_function(source,kind):
    tree=ast.parse(source)
    main=next(n for n in tree.body if isinstance(n,ast.FunctionDef) and n.name=='main')
    if kind=='container_exec':
        execute=next(n for n in main.body if isinstance(n,ast.FunctionDef) and n.name=='execute')
        branch=next(n for n in execute.body if isinstance(n,ast.If) and isinstance(n.test,ast.Compare) and ast.unparse(n.test)=="name == 'container_exec'")
        selected=[]
        for node in branch.body:
            if isinstance(node,ast.Assign) and any(isinstance(t,ast.Name) and t.id=='command' for t in node.targets):break
            selected.append(copy.deepcopy(node))
        fn=ast.parse('def guard(arguments):\n    supplied = arguments if isinstance(arguments, dict) else {}\n').body[0]
        fn.body.extend(selected)
        context={}
    else:
        selected=[]
        call=next(n for n in main.body if isinstance(n,ast.FunctionDef) and n.name=='call')
        for node in call.body:
            if isinstance(node,ast.If) and 'time.time' in ast.unparse(node.test):break
            selected.append(copy.deepcopy(node))
        fn=ast.parse("def guard(arguments):\n    name = 'read_artifact'\n    args = arguments if isinstance(arguments, dict) else {}\n").body[0]
        fn.body.extend(selected)
        assignment=next(n for n in tree.body if isinstance(n,ast.Assign) and any(isinstance(t,ast.Name) and t.id=='TOOLS' for t in n.targets))
        context={'TOOLS':ast.literal_eval(assignment.value)}
    fn.body.append(ast.Return(ast.Constant(True)))
    module=ast.fix_missing_locations(ast.Module(body=[fn],type_ignores=[]))
    allowed={'set','isinstance','str','float','len','ValueError','int','bool','list','all','any','dict'}
    for n in ast.walk(module):
        if isinstance(n,ast.Call):
            assert (isinstance(n.func,ast.Name) and n.func.id in allowed) or (isinstance(n.func,ast.Attribute) and n.func.attr in {'get','items'}),ast.unparse(n)
        assert not isinstance(n,(ast.Import,ast.ImportFrom,ast.With,ast.AsyncWith,ast.Global,ast.Nonlocal))
    exec(compile(module,'<extracted-pure-argument-guard>','exec'),context)
    return context['guard'],ast.unparse(module)

def main():
    output=HERE/'argument_replay';output.mkdir(exist_ok=True)
    sources={arm:(RUNTIME/f'runtime_{arm.lower()}/container_mcp.py').read_text(encoding='utf-8') for arm in 'ABC'}
    coordinator=(RUNTIME/'runtime_c/c_mcp.py').read_text(encoding='utf-8')
    guards={};guardcode={}
    for arm,source in sources.items():guards[arm],guardcode[arm]=guard_function(source,'container_exec')
    readguard,readcode=guard_function(coordinator,'read_artifact')
    assert len(set(guardcode.values()))==1
    (output/'extracted_container_guard.py').write_text(guardcode['B']+'\n',encoding='utf-8')
    (output/'extracted_read_artifact_guard.py').write_text(readcode+'\n',encoding='utf-8')
    events=[json.loads(line) for line in (BASE/'extraction/events.jsonl').open(encoding='utf-8') if line.strip()]
    known=json.loads((BASE/'analysis/protocol_errors.json').read_text(encoding='utf-8'))
    known_ids={e['event_id'] for e in known}
    rows=[];differences=[];knownrows=[];controls={}
    for event in events:
        tool=event['tool'].split('.')[-1]
        if event['tool_family']!='service' or tool not in {'container_exec','read_artifact'}:continue
        args=event['arguments'];before=json.dumps(args,ensure_ascii=False,sort_keys=True)
        result=validate(tool,args)
        assert json.dumps(args,ensure_ascii=False,sort_keys=True)==before
        try:
            (guards[event['config']] if tool=='container_exec' else readguard)(args)
            reference_accepted=True;reference_error=None
        except (ValueError,TypeError,OverflowError) as error:
            reference_accepted=False;reference_error=type(error).__name__
        observed_argument_rejection=event['event_id'] in known_ids
        row={k:event[k] for k in ['event_id','run_id','config','tool','source_file','source_line','result_source_line']}
        row.update(result,arguments_sha256=hashlib.sha256(before.encode()).hexdigest(),reference_accepted=reference_accepted,reference_error_type=reference_error,observed_argument_rejection=observed_argument_rejection)
        rows.append(row)
        if result['accepted']!=reference_accepted:differences.append(row)
        if observed_argument_rejection:knownrows.append(row)
        elif result['accepted']:
            key=(event['config'],tool)
            if key not in controls or event['event_id']<controls[key]['event_id']:controls[key]=row
    summary={'created_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'scope':'static argument replay only; no recorded command executed and no input rewritten','supported_tools':['container_exec','read_artifact'],'tested_calls':len(rows),'prototype_accepted':sum(r['accepted'] for r in rows),'prototype_rejected':sum(not r['accepted'] for r in rows),'known_argument_rejections':len(known_ids),'known_rejections_covered':len(knownrows),'known_rejections_detected':sum(not r['accepted'] for r in knownrows),'accepted_by_original_guard_but_rejected':sum(r['reference_accepted'] and not r['accepted'] for r in rows),'guard_disagreements':len(differences),'per_tool':{tool:dict(collections.Counter('accepted' if r['accepted'] else 'rejected' for r in rows if r['tool'].endswith('.'+tool))) for tool in ['container_exec','read_artifact']},'input_sha256':hashlib.sha256((BASE/'extraction/events.jsonl').read_bytes()).hexdigest(),'validator_sha256':hashlib.sha256((HERE/'parameter_preflight.py').read_bytes()).hexdigest(),'runtime_source_sha256':{**{arm:hashlib.sha256((RUNTIME/f'runtime_{arm.lower()}/container_mcp.py').read_bytes()).hexdigest() for arm in sources},'C_coordinator':hashlib.sha256((RUNTIME/'runtime_c/c_mcp.py').read_bytes()).hexdigest()},'limitations':['Accepting arguments does not mean command success, artifact existence, mathematical success or root deadline availability.','Reference guards were extracted and executed only up to the validation boundary; no bridge logging or backend subprocess was run.','Observed inputs are used for this development check, not an independent held-out estimate of future error reduction.']}
    assert summary['known_rejections_detected']==9
    assert not differences
    assert summary['accepted_by_original_guard_but_rejected']==0
    for name,value in [('summary.json',summary),('known_rejections.json',knownrows),('valid_controls.json',list(controls.values())),('disagreements.json',differences)]:
        (output/name).write_text(json.dumps(value,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    with (output/'all_supported_calls.jsonl').open('w',encoding='utf-8') as f:
        for row in rows:f.write(json.dumps(row,ensure_ascii=False)+'\n')
    print(json.dumps(summary,ensure_ascii=False,indent=2))

if __name__=='__main__':main()
