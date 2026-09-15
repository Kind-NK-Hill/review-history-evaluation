# Revision 30: reading and reproduction

[English main text](en.pdf) · [English appendix](en-appendix.pdf) · [中文正文](zh.pdf) · [中文附录](zh-appendix.pdf)

## What changed since the previous public report?

The existing chapter structure now connects matched-task time comparisons, the sufficiency of historical mathematical components, and actual delivery to the author. H1's retrospective caller changes the earlier interpretation of what mathematics was still missing. L6's historical caller strengthens evidence of pre-review composition. M2 input snapshots distinguish inaccessible prior work, a replacement losing non-identical-distribution coverage, and separate export failures.

Closing corrections disclose the internal ambiguity of the L6 task sheet, date the inherited 66-item reconciliation, and clarify the three configurations. H1's new connecting code and M2's simultaneous assumption changes are explicit. The historical labels and numeric inputs remain unchanged. This is not a new agent experiment or an independent human validation of all judgments.

## Start with the evidence

- [H1 historical caller](research/analysis_20260915/final_research_supplement_20260915/checks/H1_historical_caller.lean) and [saved compile receipt](research/analysis_20260915/final_research_supplement_20260915/checks/h1_historical_caller.json).
- [L6 task sheet](research/analysis_20260915/two_pass_review_20260915/review/additional_evidence/L6_TASK.md) and [exact-byte historical rebuild receipt](research/analysis_20260915/final_research_supplement_20260915/checks/l6_historical_rebuild_exact_bytes.json).
- [M2 selected events](research/analysis_20260915/final_research_supplement_20260915/evidence/selected_events.json), [input checks](research/analysis_20260915/final_research_supplement_20260915/evidence/M2_information_checks.json), and [export errors and runtime rules](verification/revision30/README.md).
- [Portable snapshot map](verification/revision29/PORTABLE_SNAPSHOTS.json), [L7 comparison](research/analysis_20260915/two_pass_review_20260915/round1/l7_all_files.json), [closing changes](CHANGES.zh-CN.md).

## Recompute and read offline

From the repository root with Python 3.11 or later:

```text
python verify_release.py
python report-v30/recompute_followup.py
python report-v28/reproduce.py --output recomputed
python report-v30/prepare_evidence.py --output reading-bundle
```

The new follow-up command recomputes all, single-task, and three-task removal comparisons from the frozen 33 second-batch rows, checks them against the saved results, and verifies the M2 time interval. The earlier reproduction entry point still recomputes the original outcome and process summaries. Neither command generates new semantic judgments, executes logged commands, calls models, or reruns Lean.

The reading-bundle command copies selected report files to a new directory and restores the 183 MB event file from the previously published compressed archive. This file exceeds GitHub's regular Git file limit and is not duplicated uncompressed in Git. Open `reading-bundle/evidence.html`; the release ZIP already contains the restored file. Other original absolute locators in historical records identify private archives, not public download links. Full original environments, private review conversations and external full papers are excluded.

The four PDFs match the final local Revision 30 bytes. Their generated LaTeX sources are in `latex/`; Tectonic and the fonts named in each preamble are needed to rebuild them. Changing fonts can change pagination. Existing H1/L6 saved Lean receipts document the frozen environment; the public package does not claim to contain a fresh-build environment for every proof.

Authors: Shuo Deng and Kenneth W. Shum. Workflow engineering, formalization and evaluation were performed with AI assistance. Source and review records distinguish automated execution from human validation.
