"""Verify public file bytes; no builds, model calls or external filesystem reads."""
from pathlib import Path
import hashlib,json
ROOT=Path(__file__).resolve().parent
manifest=json.loads((ROOT/'PUBLIC_RELEASE.json').read_text(encoding='utf-8'))
errors=[]
for item in manifest['files']:
    p=(ROOT/item['file']).resolve()
    if not p.is_relative_to(ROOT) or not p.is_file():errors.append(item['file']+': missing or unsafe path')
    elif hashlib.sha256(p.read_bytes()).hexdigest()!=item['sha256']:errors.append(item['file']+': hash mismatch')
print(json.dumps({'files':len(manifest['files']),'passed':not errors,'errors':errors},indent=2))
raise SystemExit(bool(errors))
