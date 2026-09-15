"""Copy the reading bundle to a NEW directory and expand its declared event input."""
from pathlib import Path
import argparse,gzip,hashlib,json,os,shutil
def lp(p):
 p=p.resolve()
 return Path('\\\\?\\'+str(p)) if os.name=='nt' and not str(p).startswith('\\\\?\\') else p
R=lp(Path(__file__).parent)
if __name__=='__main__':
 a=argparse.ArgumentParser();a.add_argument('--output',required=True,type=Path);args=a.parse_args();out=lp(args.output)
 if out.exists():raise SystemExit('Choose a new output directory; existing contents are never overwritten.')
 if out.is_relative_to(R):raise SystemExit('Choose an output outside the source report directory.')
 shutil.copytree(R,out,ignore=shutil.ignore_patterns('__pycache__','*.pyc'))
 item=json.loads((R/'PROVENANCE.json').read_text(encoding='utf-8'))['materialize_from_existing_archive'];p=out/item['file'];p.parent.mkdir(parents=True,exist_ok=True)
 with gzip.open((R/item['archive']).resolve(),'rb') as src,p.open('xb') as dst:shutil.copyfileobj(src,dst)
 with p.open('rb') as f:assert hashlib.file_digest(f,'sha256').hexdigest()==item['sha256']
 print(json.dumps({'reading_bundle':str(out),'event_bytes':p.stat().st_size,'hash_verified':True}))
