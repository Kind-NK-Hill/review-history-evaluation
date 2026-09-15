"""Build both reader-oriented PDFs from real LaTeX with retained evidence."""
from pathlib import Path
from datetime import datetime, timezone
import argparse
import hashlib
import json
import shutil
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parent

def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()

def build(lang, engine, online):
    source = ROOT / "latex" / lang / "main.tex"
    work = ROOT / "qa/build" / lang
    work.mkdir(parents=True, exist_ok=True)
    command = [engine, "--keep-logs", "--keep-intermediates", "--outdir", str(work)]
    if not online:
        command.append("--only-cached")
    command.append(str(source))
    start = time.perf_counter()
    result = subprocess.run(command, cwd=source.parent, capture_output=True, timeout=180)
    (work / "console.stdout.txt").write_bytes(result.stdout)
    (work / "console.stderr.txt").write_bytes(result.stderr)
    record = {"at_utc": datetime.now(timezone.utc).isoformat(), "language": lang,
              "actual_latex_compilation": True, "command": command,
              "exit_code": result.returncode, "seconds": time.perf_counter()-start,
              "source_sha256": {p.name:sha(p) for p in sorted(source.parent.iterdir()) if p.suffix in {".tex",".bib"}}}
    if result.returncode == 0:
        final = ROOT / "output/pdf" / ("review_evaluation_" + lang + ".pdf")
        final.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(work / "main.pdf", final)
        record["pdf_sha256"] = sha(final)
        record["pdf"] = final.relative_to(ROOT).as_posix()
    (work / "BUILD.json").write_text(json.dumps(record,indent=2)+"\n",encoding="utf-8")
    print(json.dumps({k:record[k] for k in ["language","exit_code","seconds"]}))
    stderr = result.stderr.decode("utf-8",errors="replace")
    print("\n".join(stderr.splitlines()[-18:]))
    return result.returncode

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--language", choices=["en","zh","both"], default="both")
    parser.add_argument("--online", action="store_true", help="Allow fetching missing TeX resources")
    args=parser.parse_args()
    engine=shutil.which("tectonic")
    if not engine:
        raise SystemExit("Tectonic is required; this build does not substitute another PDF generator.")
    langs=["en","zh"] if args.language=="both" else [args.language]
    for lang in langs:
        code=build(lang,engine,args.online)
        if code:
            raise SystemExit(code)

if __name__=="__main__":
    main()
