# Reproducing the two historical analyses

The analyses use the same underlying project history but ask different questions. Their counts describe different units and must not be added into a single sample size.

## Candidate-version pairs

`inputs/edge/edge_view.jsonl` contains 465 selected links between earlier and later reviews, covering 250 tasks. `review_events.jsonl` supplies the 783 distinct endpoint records used by those links. An endpoint can be shared by two links.

`edge_statistics.py` turns a recorded `pass` into 1 and each explicit `fail`, `inconclusive`, or `partial` label into 0. It compares the later and earlier values. It reports both an average across links and an average that first averages within each task, then gives each task equal weight. These are changes in recorded acceptance, not scores of mathematical correctness.

## Continuous revision histories

`inputs/process/episodes.json` contains 262 fixed sequences made from 367 links classified as high-confidence candidate revisions. Consecutive links were joined only when they share the same review-record endpoint. Of these sequences, 230 start with a recorded failure and cover 182 tasks.

`process_analysis.py` follows those failure-origin sequences to their first recorded pass or their observed end. This gives 329 observed steps, 206 within-sequence passes, and 24 sequences ending before a recorded pass. An observed end does not mean that the task could never pass later.

The high-confidence label comes from a classification rule: the next reviewed object is a changed candidate and the earlier review contains a structured finding, after the rule's earlier role checks. It is not a probability or a validation that the revision fixed the mathematics.

## Files and commands

The JSON manifests under each input directory record projection hashes and original source hashes. Full source archives and local source-location manifests are not required by the normal calculation commands and are not included here.

From the repository root:

```sh
python -m pip install -r analysis/requirements.txt
python -B analysis/edge_statistics.py --output-root recomputed/edge
python -B analysis/process_analysis.py --output-root recomputed/process
```

Saved outputs are beside the scripts. The scripts preserve task groupings during resampling. Their assumptions do not remove retrospective selection, establish independence between tasks, or supply missing judgments of semantic correctness. Reproducing a number verifies the calculation on these supplied inputs, not the truth of every original review.
