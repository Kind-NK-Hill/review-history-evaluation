# Exploratory paired statistics for recorded pass decisions

## Material Passport

- Origin Skill: academic-research-suite / experiment-agent
- Origin Mode: run + validate
- Origin Date: 2026-09-06
- Verification Status: ANALYZED
- Version Label: edge_statistics_v0_2_0

This analysis estimates change in **recorded pass decisions** within the fixed historical candidate-change edge set. It does not estimate mathematical improvement, reviewer accuracy, or the causal benefit of repair. A paired t-statistic is computable once the outcome and task-level pairing are defined; its inferential assumptions remain unverified.

The three routes below were specified before numerical effect estimation in this session. They are exploratory, not a prospective preregistration. All declared estimates and all three two-sided reference tests are reported; no route was chosen by its p-value.

## Outcome, units and estimands

For each observed endpoint, A=1 if the stored verdict is `pass`; A=0 for the explicit stored labels `fail`, `inconclusive`, or `partial`. The zero means only that a pass was not recorded. Unknown or missing labels are never converted to zero: the script stops on an unrecognized label. The four original categories and the nondecisive flows remain separately reported.

For task t with n_t selected edges, d_t = mean_e(A_after,e − A_before,e). The task-equal estimand is mean_t(d_t); the edge-equal estimand is sum_t(n_t d_t) / sum_t(n_t). The former gives each represented task equal weight; the latter gives long observed task histories more weight. Both are exact descriptions of the enumerated historical set. They are not first-to-last task success rates or causal treatment effects.

## All declared results

All changes and interval endpoints are percentage points. Intervals are conditional 95% task-cluster percentile bootstrap references, not uncertainty about the already enumerated historical values.

| Route | Edges / tasks | Task-equal change | Cluster interval | Edge-equal change | Cluster interval |
|---|---:|---:|---|---:|---|
| All candidate-change edges | 465 / 250 | 57.09 | [51.84, 62.45] | 45.16 | [38.63, 52.12] |
| Both endpoints pass/fail | 440 / 236 | 55.73 | [50.15, 61.21] | 44.09 | [37.36, 51.18] |
| High-confidence edges | 367 / 207 | 76.93 | [71.89, 81.73] | 59.95 | [50.44, 70.10] |

| Route | Task-level before → after | t (df) | Two-sided p, unadjusted |
|---|---:|---:|---:|
| All candidate-change edges | 29.16% → 86.25% | 20.97607 (249) | 5.87064e-57 |
| Both endpoints pass/fail | 31.59% → 87.32% | 19.71760 (235) | 1.00342e-51 |
| High-confidence edges | 6.92% → 83.85% | 30.52385 (206) | 2.21124e-78 |

The complete edge set has 118/465 recorded passes before and 328/465 after, a net difference of 210. Task differences are negative for 1 tasks, zero for 67, and positive for 182; their standard deviation is 0.430341. This is not a zero-variance degeneracy, but the differences are bounded and discrete, so an exact normal-theory t distribution is not justified literally.

The two sensitivity routes change the included edges, represented tasks, and target population. Their similarity or difference is not fixed-cohort robustness. Restricting to pass/fail conditions on both observed decisions and can itself select cases. The high-confidence role is inherited from a rule that includes the presence of prior structured findings; it is not an independently validated repair label.

A descriptive selection check added after the primary estimates shows why this distinction matters: earlier passes occur on 21/367 high-confidence edges but 97/98 medium-confidence edges. Medium-confidence edges alone have task-equal change -11.73 percentage points and edge-equal change -10.20 percentage points. These subgroup descriptions add no t-test or interval. The classification rule does not directly use the verdict, but its prior-findings condition is strongly associated with the earlier-label composition. The larger high-confidence estimate cannot be presented as stronger repair benefit or higher statistical reliability.

## Why not a t-test on 465 pairs?

There are 930 endpoint occurrences but only 783 unique endpoint records; 147 endpoints occur in two edges. The selected graph contains 318 maximal chains. Along a chain, the sum of successive indicator differences telescopes to the final minus initial indicator. Here the sums agree at 210. Consequently, treating the 465 edges as independent paired observations would ignore direct endpoint reuse and within-task dependence.

The 250 task aggregates provide the pairing used here. 103 tasks have multiple edges; the median is 1.0, the maximum is 26, and the five largest tasks contribute 14.41% of edges. The task-cluster bootstrap resamples entire task histories, so shared endpoints and all selected edges within a task stay together. This handles the declared within-task grouping but does not establish independence between tasks.

The 783 endpoint records correspond to 730 unique candidate identities; unique event identifiers therefore do not imply distinct candidates or independently executed reviews. Within a chain, dividing its net change by its edge count also dilutes the same terminal change in a longer chain. Some tasks contain multiple disjoint selected chains, so replacing their edge summaries with one earliest-to-latest difference would change the estimand.

For the reference null E(d_t)=0, the statistic is t = mean(d_t)/(sd(d_t)/sqrt(T)), with T−1 reference degrees of freedom. It is computed as a paired t-test of task-specific after and before means, not an independent two-sample t-test. Equal before/after variances are not required for this paired test. Exact Student-t calibration would require independent identically distributed normal differences; the observed bounded discrete differences instead allow, at best, a large-task-sample approximation under independence and suitable exchangeability. No normality-screening test was used to select a preferred analysis. Formula and SciPy implementation: [SciPy paired t-test documentation](https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.ttest_rel.html).

The intervals and p-values concern a hypothetical population of exchangeable tasks drawn through the same history and edge-selection mechanism. Actual task independence, representativeness, and transportability to future tasks were not established. The three p-values are unadjusted exploratory references, not three confirmatory discoveries; no familywise significance claim is made. Percentile intervals are pointwise, conditional, and do not correct selection or cross-task dependence. [SciPy bootstrap documentation](https://docs.scipy.org/doc/scipy/reference/generated/scipy.stats.bootstrap.html) describes the resampling principle; this script implements task-cluster sampling explicitly.

## Complete original-label transition table

Rows are earlier labels and columns later labels. `inconclusive` and `partial` are nondecisive categories here; they are not mathematical truth labels.

| Before / after | pass | fail | inconclusive | partial |
|---|---:|---:|---:|---:|
| pass | 105 | 12 | 1 | 0 |
| fail | 206 | 117 | 5 | 1 |
| inconclusive | 16 | 0 | 1 | 0 |
| partial | 1 | 0 | 0 | 0 |

25 edges have at least one nondecisive endpoint. Earlier/later nondecisive occurrences are 18/8; 17 edges move from a nondecisive result to pass and 1 move from pass to a nondecisive result. Thus the primary net difference includes changed decision availability as well as fail/pass transitions. The pass/fail-only route excludes these edges explicitly.

## Limits that the calculations cannot remove

This is a selected retrospective edge set, not a random sample of all tasks, all review attempts, or all possible modifications. Continued review, stopping after pass, prior findings, and recorded role classification shape inclusion. Before/after ordering is inherited from the registered adjacency proxy; this projection does not establish review-completion timestamps. No calendar-time or rule-version effect is estimated. The recorded source-review contract differs on 45 edges and task-content fields differ on 2; equal or different fields alone do not establish fixed conditions or changed goals. Other contemporaneous inputs and dependency versions can also change.

Task aggregation and cluster resampling do not control task difficulty, feedback-driven selection, reviewer configuration, rule changes, calendar effects, shared dependencies, or shared review batches. Cross-task dependency blocks are not available in this projection, so no block-robust inference is claimed. Regression to the mean, selective continuation, and real candidate improvement are possible explanations not distinguished here; no control group or independent correctness outcome identifies their contributions.

Among the 783 unique endpoint records, check-scope self-reports are {"explicit_not_reviewed": 1, "explicit_reviewability_block": 1, "unknown_check_extent": 781}. The 781 unknown extents are not imputed as completed or failed checks; all independent-execution statuses remain `not_checked_in_this_projection`. The 451 edges without case assessment remain semantically unassessed. A small p-value for recorded-decision change cannot fill these evidence gaps.

## Reproduction and audit

Run `python -B edge_statistics.py --input-root inputs/edge --output-root .` in this directory; both arguments are optional with those defaults. The portable inputs are minimal frozen field projections, not copies of complete historical records. The script checks their manifest hashes, fixes NumPy PCG64 seed sequences [20260906, route_index], uses 20,000 task-cluster draws per route and NumPy's linear 2.5%/97.5% quantiles, and writes only the result JSON and Chinese/English Markdown to the selected output directory. It requires already-installed NumPy and SciPy; no package installation or long-running experiment is involved. Original full-source hashes are recorded at freezing; a portable run verifies the frozen projections and does not claim to reopen unavailable full originals. Absolute source paths are confined to the separate local source manifest, which is not a runtime input.

Mechanical checks cover unique edge/endpoint keys, exact joins, task and candidate bindings, agreement between projected and raw verdict fields, absence of unknown label recoding, input/result hash registration, mean-difference identities, agreement of the t formula and SciPy, graph coverage, and chain telescoping. These checks verify record processing, not semantic validity or task independence. Source SHA-256 values and per-task sufficient statistics are in `edge_statistics.json`. The script itself is also hashed. Software: Python 3.12.12, NumPy 1.26.4, SciPy 1.13.1.

The statistical fallacy review covers all 11 ARS categories: aggregate/subgroup conflation (no Simpson explanation claimed); ecological inference (estimand remains task or edge mean); selection/Berkson mechanisms (selected history); collider conditioning (decisive-only selection); base-rate neglect (both endpoint pass rates shown); regression to the mean (possible, unseparated); survivorship (continuation and stopping selected); multiple searching (all three tests disclosed); analytic flexibility (session-declared, not preregistered); association/causation (no causal estimate); reverse direction (prior feedback drives subsequent action and time order is a proxy). Coverage is an interpretation checklist, not empirical certification that every bias is absent.
