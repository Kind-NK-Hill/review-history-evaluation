# Reproduce the published measurements

From the repository root, with Python 3.10 or later:

```text
python verify_release.py
python report-v28/reproduce.py --output recomputed
python report-v28/test_reproduce.py
```

Use a new or empty output directory. All analysis output is written there; the source publication is left unchanged. Expect roughly 300 MB of working space after decompression. No Python package installation, Docker or model access is needed for these commands.

## Inputs and outputs

| Measurement | Included input | Recomputed output |
|---|---|---|
| 66 deliveries, completion counts and six elapsed-time medians | `evaluation/assessment.json`; common policy and reasons | `outcomes_and_time.json`, `task_results.csv`, `TABLES.md` |
| Recorded second-batch endpoint arithmetic | `evaluation/second_batch_timing.json` | `verification.json` |
| 4,233 paired events: 4,054 service calls and 179 discovery calls | `process/extraction/events.jsonl.gz` | `process/analysis/summary.json`, `run_summary.json`, event features and same-file sequences |
| Command-lookup failures and tool-argument errors | Actual returns in the paired events | `process/analysis/environment_summary.json`, `protocol_errors.json` |
| Two selected starts per run; 66 records and final-source links | `process/semantic/annotations_*.json`, review addendum and bundled final sources | `process/semantic/summary.json`, `source_checks.json`, `validation.json` |
| Static parameter preflight | Saved calls, prototype and pure validation guards extracted from the four included bridge files | `process/interventions/argument_replay/summary.json` |

The program compares the regenerated core summaries with the frozen results and verifies the 38 included source hashes. It rejects missing or duplicate task rows, invalid times and changed outcomes without a recorded reason. Review provenance distinguishes 44 second-agent checks from 22 lead-investigator checks; all were nonblind.

## What each check establishes

**Recomputing saved measurements** checks aggregation, event classification, source mapping and static argument handling. It retains the semantic judgments and common-outcome policy rather than generating new mathematical verdicts. The original workspace-dependent reconciliation program is not presented as portable; the public entry point explicitly aggregates its frozen, reasoned assessment rows.

**Inspecting mathematical evidence** is supported by the included policy, changed-decision reasons, two caller proofs and their saved receipts, selected final sources and process records. Fresh Lean validation of all 66 deliveries requires the appropriate complete subject bundles and environment; those are not all contained here. The [engine demonstration](https://github.com/Kind-NK-Hill/ProbabilityTheoryFormalization/blob/d07f272850899b58612adf1c7dc202538503252f/docs/workflow_demo.md) is a separate runnable engineering example.

**Rerunning agents** requires new model calls, tools, inputs and budgets. It is not part of these commands. Logged shell commands remain data and are never executed. Parameter replay executes only the included pure argument-validation guards, without launching the bridge or its backend.

The event archive contains paired request/return records with stable IDs and original locators. It is not the complete set of original session files, so reconstructing session mirroring and event deduplication from scratch still requires the original archive. The selected record endpoints vary; their classifications are not a general recovery-rate estimate. [Process definitions](process/protocol.zh-CN.md) · [clarifications](ERRATA.md).

## Reading the evidence

- [CDF representation repair](examples/r2-m3-b.zh-CN.md) links six preserved events to the final support file.
- [Three-term integral trial](examples/r2-l6-b.zh-CN.md) links seven events and distinguishes the trial from the completed specialized proof.
- [A-L3 original/recovery comparison](examples/a-l3-window-check.json) checks the source followed by both selected records.
- `process/source_bundle_manifest.json` maps historical locators to included source files. The public validator always uses those files, even if the original publisher's paths happen to exist.
- The [manuscript evidence directory](manuscript/evidence/README.md) retains selected historical documentation and indexes. Some source locators identify material outside this public selection; use the declared public-input map rather than treating every historical locator as a downloadable file.

## PDF sources

The four supplied PDFs and Markdown manuscripts are unchanged revision-28 artifacts. Generated LaTeX is provided in `latex/zh`, `latex/en`, `latex/zh-appendix` and `latex/en-appendix`. With Tectonic and the named fonts installed, enter one of those directories and run `tectonic -X compile main.tex`.

The original typesetting configuration uses Windows fonts named in each `preamble.tex`; a machine without those fonts must provide suitable licensed fonts or adapt that configuration, which can change pagination. The core-table reproduction does not build PDFs. `verify_release.py` checks the delivered bytes.

## Earlier historical analyses

The preceding study and its frozen statistical programs remain under [releases/v0.5.0](../releases/v0.5.0/README.md). Their inputs and results belong to that publication. This release does not claim that rerunning those programs recreates every later historical statistic in revision 28.
