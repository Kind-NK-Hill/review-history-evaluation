# Review histories in textbook formalization — version 0.5.0

The report explains how a textbook formalization workflow produces review evidence, how retrospective selection turns that evidence into analysis units, and what the resulting measurements and statistics establish. It assumes calculus, probability, linear algebra, and basic statistical inference. Recorded acceptance remains distinct from mathematical task conformity.

Read [the English report](output/pdf/review_evaluation_en.pdf) or [中文版报告](output/pdf/review_evaluation_zh.pdf). Both are independent PDFs compiled from LaTeX. The public project is [review-history-evaluation](https://github.com/Kind-NK-Hill/review-history-evaluation).

## Source layout

- `latex/en/main.tex`, `latex/zh/main.tex`: the two source entries; chapter files and bibliography sit beside them.
- `latex/figures/`: unchanged figures supplied with the report; no experiment is needed to compile.
- `analysis/`: selected, unchanged statistical scripts, frozen inputs, saved results, and requirements. These paths also map to the public repository's `analysis/` directory.
- `evidence/history/`: historical classification descriptions, aggregate tables, and exact source excerpts.
- `evidence/workflow/`: retained historical workflow documentation; not a claim that the entire archive followed one uniform implementation.
- `evidence/SOURCE_MAP.json`: relative source-to-copy mapping and hashes.
- `reviews/`: content, organization, and visual checks for this edition.
- `DELIVERY.json`: final source/PDF hashes, page counts, checks, and package scope.

The full preceding evidence archive is preserved separately. This writing package does not claim to carry all raw historical Lean executions, witness logs, or the complete operational database. The appendix identifies that boundary. No production state or earlier release was edited.

## Compile both reports

Requirements: Python 3.10 or later for the build wrapper, Tectonic (tested with 0.16.9), and its ordinary LaTeX resources. The Chinese edition requires the installed fonts **SimSun, SimHei, KaiTi, and Microsoft YaHei**. These are referenced by font name, not by machine-specific paths, and are not redistributed. A non-Windows environment must supply these fonts or explicitly adapt the font settings in `latex/zh/preamble.tex`; such a font change may change pagination. Only the documented Windows font configuration has been layout-checked.

From this directory:

```text
python -B build_reports.py
```

This defaults to cached TeX resources. On a fresh Tectonic installation, allow ordinary resource downloads:

```text
python -B build_reports.py --online
```

Use `--language en` or `--language zh` to build one edition. The wrapper resolves inputs relative to its own location, writes raw build logs under `qa/build/`, and places the final PDFs under `output/pdf/`. It invokes actual LaTeX through Tectonic; it does not substitute a Markdown or image-based PDF generator. Build logs contain local execution paths and are not necessary for portable compilation. The portable delivery record retains build outcome, engine, input hashes, and PDF hashes without those paths.

## Optional statistical recomputation

The frozen results are already supplied. Report compilation does not run these commands. To recompute the existing statistical projections in a separate directory, use Python 3.12.12 and the versions in `analysis/requirements.txt`:

```text
python -m pip install -r analysis/requirements.txt
python -B analysis/edge_statistics.py --output-root recomputed/edge
python -B analysis/process_analysis.py --output-root recomputed/process
```

Each script uses its adjacent frozen inputs and verifies their hashes. Do not use the optional full-archive freezing modes for portable reproduction; they require the original research workspace. The saved inputs are sufficient for the specified analyses, but do not independently validate the original labels or record-selection mechanism.

## PDF inspection

Install Poppler, `pypdf`, and `pdfplumber`. Put `pdftoppm` on `PATH`, or set `PDFTOPPM` to its executable location, then run:

```text
python -B qa_reports.py
```

This renders every page and records text and trim checks. Visual inspection of those renders remains necessary. The delivered version includes its page-by-page review record. Rebuilding may change PDF timestamps and bytes; compare the supplied manifest before rebuilding if exact delivered bytes matter.

## 本版重组说明

以第 0.3.0 版便于查找定义的章节层级为基础，保留第 0.4.0 版直接的行文。开篇交代形式化、审核、修改及留档用途；第二节逐项解释记录、连接、片段和分析步骤，补齐 2,645、465/367、262、230/182 与 329 的关系。读者已知基础记号和统计知识，因此移除相应入门讲解，保留实际计算、数学论证与适用假设。旧版、冻结统计结果及实验边界保持不变。

源稿包可以整体解压后按上述命令构建，正文中的来源路径与包内目录一致。

重新构建之前，运行 `python -B verify_manifest.py` 可核对交付文件的 SHA-256。`MANIFEST.json` 不包含自身及压缩包，压缩包的哈希单独记录在包外的 `ARCHIVE.json` 中。`reviews/final_visual_review.md` 说明逐页检查方式及范围。
