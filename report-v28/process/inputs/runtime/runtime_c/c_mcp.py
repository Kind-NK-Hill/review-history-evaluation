"""Seven-action MCP surface for the C coordinator."""
from __future__ import annotations
import argparse, hashlib, json, os, subprocess, sys, time, uuid
from datetime import UTC, datetime
from pathlib import Path

TOOLS = {
 "get_status": ({}, []),
 "read_artifact": ({"artifact_id":{"type":"string"},"start_line":{"type":"integer","minimum":1},"max_lines":{"type":"integer","minimum":1,"maximum":1000}}, ["artifact_id"]),
 "assign_writer": ({"task_id":{"type":"string"},"base_candidate_id":{"type":"string"},"instruction":{"type":"string","minLength":1}}, ["task_id","base_candidate_id","instruction"]),
 "build_check": ({"candidate_id":{"type":"string"}}, ["candidate_id"]),
 "review_candidate": ({"task_id":{"type":"string"},"candidate_id":{"type":"string"}}, ["task_id","candidate_id"]),
 "math_check": ({"task_id":{"type":"string"},"candidate_id":{"type":"string"}}, ["task_id","candidate_id"]),
 "submit_bundle": ({"candidate_id":{"type":"string"},"stop_reason":{"type":"string","enum":["believes_complete","unable_to_continue","budget_choice"]},"unresolved":{"type":"array","items":{"type":"string"}}}, ["candidate_id","stop_reason"]),
}
VISIBLE_BYTES=40000
DESCRIPTIONS={"get_status":"查看当前候选、动作和剩余时间。","read_artifact":"读取一个已登记的公开或运行产物。","assign_writer":"让持久作者从当前候选工作并返回新候选。","build_check":"对完整候选运行固定技术检查。","review_candidate":"用固定标准审核指定任务和候选。","math_check":"用固定数学咨询检查登记候选。","submit_bundle":"封存当前完整候选并结束运行。"}

def main():
 p=argparse.ArgumentParser(); p.add_argument("--config",type=Path,required=True); p.add_argument("--evidence",type=Path,required=True); p.add_argument("--parent-dispatch-id",required=True); p.add_argument("--deadline-epoch",type=float,required=True); a=p.parse_args()
 a.evidence.mkdir(parents=True,exist_ok=False); log=a.evidence/"tool-events.jsonl"
 cfg=json.loads(a.config.read_text(encoding="utf-8")); backend=[sys.executable,str(Path(__file__).with_name("c_backend.py")),"--config",str(a.config),"--parent-dispatch-id",a.parent_dispatch_id]
 def record(x):
  with log.open("a",encoding="utf-8") as f: f.write(json.dumps({"at":datetime.now(UTC).isoformat(),**x},ensure_ascii=False)+"\n"); f.flush(); os.fsync(f.fileno())
 def call(name,args):
  if name not in TOOLS: raise ValueError("unknown action")
  props,required=TOOLS[name]
  if set(args)-set(props) or any(k not in args for k in required): raise ValueError("invalid action arguments")
  for key,value in args.items():
   spec=props[key];kind=spec.get("type")
   if kind=="string" and not isinstance(value,str):raise ValueError("invalid string argument: "+key)
   if kind=="integer" and (not isinstance(value,int) or isinstance(value,bool)):raise ValueError("invalid integer argument: "+key)
   if kind=="array" and (not isinstance(value,list) or not all(isinstance(v,str) for v in value)):raise ValueError("invalid array argument: "+key)
   if "enum" in spec and value not in spec["enum"]:raise ValueError("invalid enum argument: "+key)
   if isinstance(value,str) and len(value)<spec.get("minLength",0):raise ValueError("empty argument: "+key)
   if isinstance(value,int) and not spec.get("minimum",value)<=value<=spec.get("maximum",value):raise ValueError("argument out of range: "+key)
  if time.time()>=a.deadline_epoch: raise TimeoutError("root deadline reached")
  cid=str(uuid.uuid4()); request=a.evidence/f"request-{cid}.json"; request.write_text(json.dumps({"action":name,"arguments":args},ensure_ascii=False),encoding="utf-8")
  record({"event":"request","call_id":cid,"action":name,"arguments":args})
  backend_error=None
  try:cp=subprocess.run([*backend,"--request",str(request)],capture_output=True,timeout=max(1,a.deadline_epoch-time.time()))
  except Exception as error:
   backend_error=repr(error)
   stdout=getattr(error,"stdout",None) or b"";stderr=getattr(error,"stderr",None) or b""
   cp=subprocess.CompletedProcess(backend,124 if isinstance(error,subprocess.TimeoutExpired) else 1,stdout,stderr)

  raw=a.evidence/f"result-{cid}.bin"; raw.write_bytes(cp.stdout); (a.evidence/f"stderr-{cid}.bin").write_bytes(cp.stderr)
  result={"exit_code":cp.returncode,"stdout":cp.stdout[:VISIBLE_BYTES].decode("utf-8",errors="replace"),"stderr":cp.stderr[:VISIBLE_BYTES].decode("utf-8",errors="replace"),"stdout_sha256":hashlib.sha256(cp.stdout).hexdigest(),"stdout_bytes":len(cp.stdout),"stdout_truncated":len(cp.stdout)>VISIBLE_BYTES,"stderr_sha256":hashlib.sha256(cp.stderr).hexdigest(),"stderr_bytes":len(cp.stderr),"stderr_truncated":len(cp.stderr)>VISIBLE_BYTES}
  result["backend_error"]=backend_error
  record({"event":"result","call_id":cid,"action":name,**result}); return {"content":[{"type":"text","text":json.dumps(result,ensure_ascii=False)}],"isError":cp.returncode!=0}
 for line in sys.stdin.buffer:
  req=None
  try:
   req=json.loads(line); method=req.get("method")
   if "id" not in req: continue
   if method=="initialize": result={"protocolVersion":req.get("params",{}).get("protocolVersion","2024-11-05"),"capabilities":{"tools":{}},"serverInfo":{"name":"c-pilot","version":"1"}}
   elif method=="tools/list": result={"tools":[{"name":n,"description":DESCRIPTIONS[n],"inputSchema":{"type":"object","properties":s[0],"required":s[1],"additionalProperties":False}} for n,s in TOOLS.items()]}
   elif method=="tools/call":
    q=req.get("params",{}); result=call(q.get("name"),q.get("arguments") if isinstance(q.get("arguments"),dict) else {})
   elif method=="ping": result={}
   else: result={"resources":[]} if method=="resources/list" else {"prompts":[]}
   out={"jsonrpc":"2.0","id":req["id"],"result":result}
  except Exception as e: out={"jsonrpc":"2.0","id":req.get("id") if isinstance(req,dict) else None,"error":{"code":-32603,"message":str(e)}}
  sys.stdout.buffer.write((json.dumps(out,ensure_ascii=True)+"\n").encode()); sys.stdout.buffer.flush()
if __name__=="__main__": main()
