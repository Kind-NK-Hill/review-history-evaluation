"""Render every report page and record read-only PDF/text checks."""
from pathlib import Path
import os, shutil
import json
import subprocess
import hashlib
import pdfplumber
from pypdf import PdfReader
ROOT = Path(__file__).resolve().parent
POPPLER = os.environ.get('PDFTOPPM') or shutil.which('pdftoppm')
if not POPPLER:
    raise SystemExit('Install Poppler and add pdftoppm to PATH, or set PDFTOPPM to its executable path.')
records = {}
for lang in ("en", "zh"):
    pdf = ROOT / "output/pdf" / f"review_evaluation_{lang}.pdf"
    dest = ROOT / "qa/render" / lang / hashlib.sha256(pdf.read_bytes()).hexdigest()[:12]
    dest.mkdir(parents=True, exist_ok=True)
    subprocess.run([str(POPPLER), "-png", "-r", "105", str(pdf), str(dest / "page")], check=True, capture_output=True)
    reader = PdfReader(pdf)
    pages = [p.extract_text() or "" for p in reader.pages]
    (ROOT / "qa" / f"text_{lang}.txt").write_text("\n\n".join(f"PAGE {i+1}\n{t}" for i,t in enumerate(pages)), encoding="utf-8")
    outliers = []
    with pdfplumber.open(pdf) as doc:
        for i,p in enumerate(doc.pages):
            outside = [c.get("text","") for c in p.chars if c["x0"] < 20 or c["x1"] > p.width-20 or c["top"] < 20 or c["bottom"] > p.height-20]
            if outside:
                outliers.append({"page":i+1, "outside_20pt_trim":"".join(outside)})
    records[lang] = {"pdf":pdf.relative_to(ROOT).as_posix(), "pages":len(pages), "sha256":hashlib.sha256(pdf.read_bytes()).hexdigest(), "nonempty_pages":all(t.strip() for t in pages), "replacement_character":any("\ufffd" in t for t in pages), "trim_outliers":outliers, "rendered_pages":len(list(dest.glob("page-*.png"))), "render_directory":dest.relative_to(ROOT).as_posix()}
(ROOT / "qa/pdf_checks.json").write_text(json.dumps(records, indent=2, ensure_ascii=False)+"\n",encoding="utf-8")
print(json.dumps(records, ensure_ascii=False))
