# How probability proofs are completed

**Agent evaluation through mathematical outcomes, tool trajectories, and review evidence.**

An agent can finish a local proof without delivering it to the author who needs it. A program can compile while its public theorem omits part of the assigned mathematical problem. This study follows these gaps in a probability-textbook formalization project, connecting tool feedback and code changes to the proofs that were actually delivered and used.

**Read the report:** [English](report-v28/en.pdf) · [中文](report-v28/zh.pdf) · [English appendix](report-v28/en-appendix.pdf) · [中文附录](report-v28/zh-appendix.pdf). This public release preserves report revision 28 and includes [corrections and reading notes](report-v28/ERRATA.md).

**Try the analysis:** [reproduce the core tables](report-v28/REPRODUCIBILITY.md) · [inspect a feedback-to-proof sequence](report-v28/examples/r2-m3-b.zh-CN.md) · [read the source text](report-v28/manuscript/report.en.md) · [中文项目说明](README.zh-CN.md).

## What was evaluated?

Eleven task groups were run under three configurations in two batches: a prescribed workflow (A), an author with reference material and access to assistance (B), and a coordinator directing authors and checking services (C). The study examines completed mathematics, elapsed effort, and how information and intermediate work reached the final proof.

| Batch | A: completed groups | B: completed groups | C: completed groups |
|---|---:|---:|---:|
| First | 10 / 11 | 10 / 11 | 11 / 11 |
| Second | 11 / 11 | 11 / 11 | 11 / 11 |

These are the delivered outcomes under the documented common mathematical criterion. Three second-batch decisions were corrected after checking the supplied code and its callers; that reassessment did not generate new solutions. The batches changed task instructions and execution arrangements, and the configurations bundle several differences. The report therefore gives results within each batch rather than estimating a causal benefit of one component.

The process study contains **4,054 service calls**, plus **179 tool-discovery calls**, from the 33 original second-batch runs. It follows two fixed starting points per run, yielding 66 annotated records. Selected sequences show how function representations were adapted, how support code reached later proofs, and how locally checked work could fail to reach its intended recipient. These records describe selected processes, not a population-wide recovery rate.

## Inspect the work

| Question | Entry point |
|---|---|
| What did the agents complete, and how much time did they use? | [66 frozen assessment rows and reasons](report-v28/evaluation/assessment.json), [common criterion](report-v28/evaluation/policy.json), [recomputed tables](report-v28/results/TABLES.md) |
| What changed after tool feedback? | [CDF representation repair](report-v28/examples/r2-m3-b.zh-CN.md), [an unresolved generic trial and a completed task-specific proof](report-v28/examples/r2-l6-b.zh-CN.md) |
| How were the process records defined and checked? | [Selection protocol](report-v28/process/protocol.zh-CN.md), [66 records](report-v28/process/semantic/adjudicated_annotations.json), [review coverage](report-v28/process/semantic/summary_provenance.json) |
| Can the measurements be recomputed? | [Python entry point and exact scope](report-v28/REPRODUCIBILITY.md), [saved verification](report-v28/results/verification.json) |
| How does the underlying system work? | [Engineering repository](https://github.com/Kind-NK-Hill/ProbabilityTheoryFormalization), [workflow demonstration at the cited commit](https://github.com/Kind-NK-Hill/ProbabilityTheoryFormalization/blob/d07f272850899b58612adf1c7dc202538503252f/docs/workflow_demo.md) |

## Recompute

Python 3.10 or later; the core study uses the standard library. From this repository:

```text
python verify_release.py
python report-v28/reproduce.py --output recomputed
```

The second command writes all generated files to a new directory. It recomputes outcome and time tables from frozen assessments, classifies saved tool events, summarizes annotations, checks the 38 included final sources, and runs static parameter checks. It does not execute commands found in the logs or call a model. [Reproduction details](report-v28/REPRODUCIBILITY.md) distinguish these checks from rerunning mathematical acceptance or an experiment.

## Project and publication history

The engineering repository contains the workflow, Lean corpus, tests and operational demonstrations. This repository contains the study and its public analysis inputs. The cited public engineering revision is `d07f272850899b58612adf1c7dc202538503252f`; historical experiments retain their own recorded identities and should not be read as executions of one uniform current implementation.

Report authors: **Shuo Deng and Kenneth W. Shum**. Shuo Deng's work covers workflow engineering, formalization and the evaluation study, with AI assistance. The report and source records distinguish observed outputs from human validation; code and documentation are not presented as wholly handwritten.

The preceding **0.5.0** publication is preserved, with its original file bytes and relative layout, under [releases/v0.5.0](releases/v0.5.0/README.md). Its reports and statistical programs remain usable for that earlier study. See [publication changes](CHANGELOG.md) and [related methods](report-v28/RELATED_WORK.md).
