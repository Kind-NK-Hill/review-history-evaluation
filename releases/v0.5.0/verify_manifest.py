"""Verify the delivered file bytes before rebuilding or recomputing."""
from pathlib import Path
import hashlib
import json
ROOT=Path(__file__).resolve().parent
manifest=json.loads((ROOT/"MANIFEST.json").read_text(encoding="utf-8"))
errors=[]
for entry in manifest["files"]:
    relative=Path(entry["file"])
    target=(ROOT/relative).resolve()
    if relative.is_absolute() or not target.is_relative_to(ROOT):
        errors.append({"file":entry["file"],"error":"invalid manifest path"})
        continue
    if not target.is_file():
        errors.append({"file":entry["file"],"error":"missing"})
    elif hashlib.sha256(target.read_bytes()).hexdigest()!=entry["sha256"]:
        errors.append({"file":entry["file"],"error":"hash mismatch"})
print(json.dumps({"files":len(manifest["files"]),"passed":not errors,"errors":errors},indent=2))
raise SystemExit(bool(errors))

