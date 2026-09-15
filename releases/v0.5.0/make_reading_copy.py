"""Generate an online reading copy of the delivered PDFs without editorial changes."""
from pathlib import Path
import hashlib
import json
import shutil
import subprocess

ROOT = Path(__file__).resolve().parent
OUT = ROOT / "reading"

def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()

def main():
    pdftotext = shutil.which("pdftotext")
    pdftoppm = shutil.which("pdftoppm")
    if not pdftotext or not pdftoppm:
        raise SystemExit("Install Poppler and put pdftotext and pdftoppm on PATH.")
    # Check the delivered package before deriving any reading copies.
    subprocess.run([__import__("sys").executable, "-B", str(ROOT / "verify_manifest.py")], check=True)
    OUT.mkdir(exist_ok=True)
    index = ["# Online reading copy", "", "These pages are generated directly from the delivered version 0.5.0 PDFs. They contain no added explanation or review. Page numbers below count PDF pages, including front matter; the printed page number remains visible in each image.", "", "The extracted text is for searching and reading. Extraction can flatten mathematical notation, tables, and columns. The page image preserves the PDF layout and is authoritative for those details. The PDFs remain the report of record.", ""]
    record = {"method": "Poppler pdftotext -layout and pdftoppm -png -r 120", "reports": {}}
    for lang in ("en", "zh"):
        source = ROOT / "output/pdf" / f"review_evaluation_{lang}.pdf"
        dest = OUT / lang
        dest.mkdir(exist_ok=True)
        text_path = dest / "full_text.txt"
        subprocess.run([pdftotext, "-layout", "-enc", "UTF-8", str(source), str(text_path)], check=True)
        pages = text_path.read_text(encoding="utf-8").split("\f")
        if not pages[-1].strip():
            pages.pop()
        subprocess.run([pdftoppm, "-png", "-r", "120", str(source), str(dest / "page")], check=True, capture_output=True)
        images = sorted(dest.glob("page-*.png"))
        if len(images) != len(pages):
            raise SystemExit(f"Page count mismatch: {lang}")
        index += [f"## {'English' if lang == 'en' else '中文'}", "", f"[PDF](../output/pdf/review_evaluation_{lang}.pdf) · [Complete extracted text]({lang}/full_text.txt)", ""]
        full = []
        for number, (content, picture) in enumerate(zip(pages, images), 1):
            page_file = dest / f"page-{number:02d}.md"
            page_file.write_text(f"# PDF page {number}\n\n![PDF page {number}]({picture.name})\n\n## Extracted text\n\n```text\n{content.rstrip()}\n```\n", encoding="utf-8", newline="\n")
            index.append(f"- PDF page {number}: [text and image]({lang}/{page_file.name}) · [image]({lang}/{picture.name})")
            full.append(f"===== PDF PAGE {number} =====\n\n{content.rstrip()}")
        text_path.write_text("\n\n".join(full) + "\n", encoding="utf-8", newline="\n")
        record["reports"][lang] = {"source": source.relative_to(ROOT).as_posix(), "source_sha256": sha(source), "pages": len(pages), "files": {p.relative_to(OUT).as_posix(): sha(p) for p in sorted(dest.iterdir()) if p.is_file()}}
        index.append("")
    (OUT / "README.md").write_text("\n".join(index), encoding="utf-8", newline="\n")
    (OUT / "DERIVATION.json").write_text(json.dumps(record, ensure_ascii=False, indent=2) + "\n", encoding="utf-8", newline="\n")
    print(json.dumps({lang: {"pages": item["pages"], "source_sha256": item["source_sha256"]} for lang, item in record["reports"].items()}))

if __name__ == "__main__":
    main()
