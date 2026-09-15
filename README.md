# How probability proofs are completed

**An evaluation of the ProbabilityTheoryFormalization project**

Shuo Deng and Kenneth W. Shum · Technical report · September 2026

[English report](report-v30/en.pdf) · [中文正文](report-v30/zh.pdf) · [English appendix](report-v30/en-appendix.pdf) · [中文附录](report-v30/zh-appendix.pdf) · [中文项目说明](README.zh-CN.md)

An agent can finish a local proof without delivering it to the author who needs
it. Code can compile while its theorem covers a narrower problem than the task
requires. This study examines **what was proved, how completion was judged, and
whether intermediate work reached the final proof**.

**Current report: revision 30 / public v0.7.0.**
[Complete reading bundle](https://github.com/Kind-NK-Hill/review-history-evaluation/releases/tag/v0.7.0)
· [Changes and evidence](report-v30/README.md)

## What was evaluated?

Eleven probability task groups, three workflow configurations and two batches
form **66 selected primary runs**. The configurations use a prescribed workflow
(A), an author with reference material and access to assistance (B), and a
coordinator directing authors and checking services (C).

The study combines completion assessment, comparisons of elapsed time on the
same tasks, source-code checks and execution traces. The 66 runs are not 66
independent mathematical tasks. Task instructions and execution arrangements
changed between batches, and each configuration bundles several differences.

## Findings worth inspecting

- **Completion depends on available mathematics and the assigned scope.** H1's
  historical components, joined by new connecting code, change an earlier
  interpretation of what remained unproved. L6's caller supports historical
  composition, but its task sheet mixes a broader noise specification with a
  Gaussian-instantiation requirement. Saved 11/11 judgments do not certify every
  delivery under the broader reading. [H1/L6 code and saved Lean receipts](report-v30/README.md#start-with-the-evidence)
- **A completed proof can be lost at handoff.** In M2, a helper proved the
  original target but the proof was not delivered. A later helper's input did
  not contain it, and its reconstruction narrowed the target; a subsequent
  helper supplied the adopted proof. Input snapshots, source and export errors
  distinguish these stages. [M2 evidence and runtime rules](report-v30/verification/revision30/README.md)
- **Timing differences need task-level explanation.** Matched-task comparisons
  and task-removal sensitivity checks show how aggregate differences depend on
  particular tasks. Tool-feedback sequences connect elapsed work to mathematical
  changes; a configuration-wide causal advantage is not established.
  [Recompute the follow-up comparisons](report-v30/README.md#recompute-and-read-offline)

The second-batch process study includes 4,054 service calls and 179 tool-discovery
calls from 33 primary runs. Two fixed starting points per run yield 66 annotated
records. These selected, sometimes overlapping records are distinct from the
66-run comparison and do not estimate a population-wide recovery rate.

## Read, inspect, reproduce

| Purpose | Entry point |
|---|---|
| Read the conclusions and cases | [Current report and four PDFs](report-v30/README.md) |
| Follow feedback into a proof | [CDF representation repair](report-v28/examples/r2-m3-b.zh-CN.md) |
| Inspect outcomes, time and process definitions | [66 frozen assessments](report-v28/evaluation/assessment.json), [common criterion](report-v28/evaluation/policy.json), [process protocol](report-v28/process/protocol.zh-CN.md) |
| Check evidence selection and review coverage | [66 annotations](report-v28/process/semantic/adjudicated_annotations.json), [coverage record](report-v28/process/semantic/summary_provenance.json) |
| Run the underlying system | [Engineering repository and demonstration](https://github.com/Kind-NK-Hill/ProbabilityTheoryFormalization) |

Python 3.11 or later; the core analysis uses the standard library:

```text
python verify_release.py
python report-v30/recompute_followup.py
python report-v28/reproduce.py --output recomputed
```

These commands verify bundled files and recompute measurements from frozen
inputs. They do not generate new semantic judgments, call models or rerun Lean.
The H1/L6 checks are saved receipts from their documented environments. See
[reproduction scope and offline evidence preparation](report-v30/README.md#recompute-and-read-offline).

## Contributions and publication history

Shuo Deng's work includes directing requirements, coordinating AI-assisted
execution, reviewing results, questioning interpretations and requesting
corrections. AI tools assisted code, proof generation, analysis and drafting.
Kenneth W. Shum is the source textbook author and report coauthor. The study
distinguishes observed outputs and model-assisted judgments from independent
human validation.

The engineering system and this evaluation are related parts of one research
project. The study cites engineering revision
`d07f272850899b58612adf1c7dc202538503252f`; historical runs retain their own
recorded identities.

Revision 28's [report, corrections](report-v28/ERRATA.md) and
[core reproduction](report-v28/REPRODUCIBILITY.md) remain available and supply
inputs used by revision 30. The earlier [v0.5.0 study](releases/v0.5.0/README.md)
is also preserved. [Publication history](CHANGELOG.md) · [Related methods](report-v28/RELATED_WORK.md)
