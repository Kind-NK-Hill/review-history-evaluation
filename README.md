# Review-history evaluation

This project studies the records left by an AI-assisted textbook formalization workflow. An agent writes a candidate proof in Lean, a reviewer records a judgment and comments, and the candidate may be revised and reviewed again. These repeated submissions leave a history that can be examined.

The evaluation asks what those records can tell us: what a particular check measures, how a recorded decision changes between two versions, and what happens along sequences of revisions. A recorded acceptance is the outcome of a review; it does not, by itself, establish that the intended mathematical task was solved correctly.

The implementation that produced the broader workflow is maintained in [ProbabilityTheoryFormalization](https://github.com/Kind-NK-Hill/ProbabilityTheoryFormalization). This repository holds the evaluation report and selected materials for reproducing its analysis.

## Report status

The revised English and Chinese reports are being prepared. This initial public commit contains the reproducible statistical material; the two final PDFs and their LaTeX source will be added after the report build and page checks finish. No earlier report is presented here as the forthcoming revision.

## What is available now

| Material | Purpose |
|---|---|
| [Analysis instructions](analysis/README.md) | Explain the supplied inputs and how to rerun the calculations |
| [Version-pair analysis](analysis/edge_statistics_en.md) | Describe changes in recorded decisions across selected pairs of candidate versions |
| [Revision-sequence analysis](analysis/process_statistics_en.md) | Follow selected histories from an initial recorded failure until a recorded pass or the end of the observed sequence |
| [Public input manifest](PUBLIC_INPUTS.json) | Bind the selected files to their SHA-256 hashes |

The public inputs are fixed projections of an existing review archive. They contain task identifiers, links between records, recorded outcomes, and selected evidence metadata. They do not contain the full private archive or provide an independent reference judgment of mathematical correctness.

## Reproduce the saved analyses

The saved calculations used Python 3.12.12. Install the pinned dependencies in an environment of your choice, then run from this repository:

```sh
python -m pip install -r analysis/requirements.txt
python -B analysis/edge_statistics.py --output-root recomputed/edge
python -B analysis/process_analysis.py --output-root recomputed/process
```

These commands read the bundled inputs and write to new output directories. They do not need access to the original project workspace. Input hashes are checked by the analysis scripts. The fixed seeds and dependency versions support comparison with the saved numerical results; regenerated image and PDF metadata can differ.

The statistical intervals and tests describe explicitly stated reference models. The retained histories were selected retrospectively, and grouping records by task does not establish that different tasks are independent. Results should be read with the assumptions explained in the report and analysis notes.

AI tools assisted the implementation, analysis checks, and writing. The checks recorded here are not independent human peer review.
