"""Pure argument checks matching the frozen bridge; no command execution.

Prototype intentionally covers container_exec and read_artifact, the two tools
responsible for all nine observed argument rejections. It does not rewrite input.
"""
from __future__ import annotations
import math

def validate(tool: str, arguments: object) -> dict:
    tool=tool.split('.')[-1]
    if tool not in {'container_exec','read_artifact'}:
        return {'supported':False,'accepted':None,'errors':[],'schema_warnings':[]}
    errors=[];warnings=[]
    def error(field,code,explanation):errors.append({'field':field,'code':code,'explanation':explanation})
    if not isinstance(arguments,dict):
        error('$','object_required','参数必须是一个对象。')
        return {'supported':True,'accepted':False,'errors':errors,'schema_warnings':warnings}
    if tool=='container_exec':
        for field in sorted(set(arguments)-{'command','timeout_seconds'}):
            error(field,'unexpected_field','该工具仅接受command与timeout_seconds。')
        if not isinstance(arguments.get('command'),str):
            error('command','string_required','command是必填字符串。')
        elif len(arguments['command'])>100000:
            error('command','too_long','command最多100000个字符；请由调用者拆分后重新提交。')
        raw=arguments.get('timeout_seconds',600)
        try:value=float(raw)
        except (ValueError,TypeError,OverflowError):
            error('timeout_seconds','not_numeric','timeout_seconds必须可转换为有限数值，范围为0.1至600秒。')
        else:
            if not math.isfinite(value) or not 0.1<=value<=600:
                error('timeout_seconds','out_of_range','timeout_seconds必须在0.1至600秒之间。')
            if not isinstance(raw,(float,int)) or isinstance(raw,bool):
                warnings.append({'field':'timeout_seconds','code':'bridge_coercion','explanation':'原桥接器会尝试数值转换；接口规范要求数值类型。本原型保持原桥接器的接受结果，未修改参数。'})
    else:
        for field in sorted(set(arguments)-{'artifact_id','start_line','max_lines'}):
            error(field,'unexpected_field','read_artifact仅接受artifact_id、start_line、max_lines。')
        if not isinstance(arguments.get('artifact_id'),str):error('artifact_id','string_required','artifact_id是必填字符串；此处不检查该产物是否登记。')
        for field in ['start_line','max_lines']:
            if field not in arguments:continue
            value=arguments[field]
            if not isinstance(value,int) or isinstance(value,bool):error(field,'integer_required',field+'必须是整数。')
            elif value<1 or (field=='max_lines' and value>1000):error(field,'out_of_range',field+'必须至少为1'+('，最多1000。' if field=='max_lines' else '。'))
    return {'supported':True,'accepted':not errors,'errors':errors,'schema_warnings':warnings}

if __name__=='__main__':
    import json,sys
    request=json.load(sys.stdin)
    result=validate(request.get('tool',''),request.get('arguments'))
    print(json.dumps(result,ensure_ascii=False,indent=2))
    raise SystemExit(0 if result['accepted'] else 2)
