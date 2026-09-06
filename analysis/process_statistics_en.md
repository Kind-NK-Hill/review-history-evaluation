# Recorded-review process analysis (post-hoc exploratory)

## Question and endpoint

In the fixed 262-chain high-confidence graph, 230 chains from 182 tasks start with a recorded failure. Reconstructing their paths up to the first recorded pass gives 329 risk rows, 206 within-chain passes, and 24 chains ending before a recorded pass. A step is a transition between submitted candidate versions, not an internal edit, an API call, or wall-clock time.

We ask when a first recorded pass occurs within this original chain. Ending the chain without a pass is a terminal process outcome for this definition, not a claim of irreparable failure. A chain exit records the boundary of the fixed high-confidence graph; it does not establish that work on the task ceased. Later same-task passes outside the chain are not appended. For a different target—the hypothetical time to pass if editing continued—these exits remain potentially informative censoring, and its survival curve is not identified here.

## Model and reference inference

For task s, episode e and observed at-risk step j, let Y_sej indicate that the next recorded review is pass. Fit

    logit E[Y_sej | observed risk row, L_j] = alpha + beta L_j,
    L_j = 1{j >= 2}.

We used binomial generalized estimating equations with working independence and a robust task-cluster sandwich covariance. This is a marginal contrast between two observed risk-row groups. Clustering changes covariance estimation; it does not adjust for task difficulty, eliminate selection into later steps, or establish independent task clusters. Shared requirements, dependencies, models and collection batches may link tasks. No population sampling design or confirmatory preregistration is available. All p-values and intervals below are reference-model summaries under an independent exchangeable task-cluster interpretation.

The two-column design has rank 2; fitted mean parameters equal the log-odds of the two empirical rates. An independent cluster-score sandwich reconstruction agrees with the covariance (maximum absolute discrepancy 2.5e-16). This model is estimable; possible separation in richer fixed-effect models is not a reason to reject this fit.

## Results

The first-step rate was 167/230 = 72.61%, compared with 39/99 = 39.39% at later observed steps. Whole-task resampling (20,000 draws, seed 20260906) gave respective 95% percentile intervals [66.40, 78.60]% and [24.84, 65.71]%. The later-minus-first difference was -33.21 percentage points; its interval was [-48.39, -7.49] percentage points.

The later-step coefficient was beta = -1.405642 (robust SE 0.413295), giving an odds ratio of 0.2452, Wald 95% interval [0.1091, 0.5512], and nominal two-sided p = 0.0006712. This quantifies heterogeneity of recorded-pass rates across observed process positions. It does not show that another edit reduces success, identify a within-task effect, or establish a difficulty mechanism.

A common recorded-pass probability across observed risk rows is a simple working benchmark. Maximizing the independent-Bernoulli working likelihood gives 206/329 = 0.626140; this is not a full joint-likelihood maximum under unspecified within-task dependence. In the two-regime model beta = 0 equates only the first and later marginal means. Full-history constant conditional hazard is a stronger assumption. The comparison is a coarse observed-association diagnostic, not a test of constant hazard given every past history, latent task homogeneity, or causal diminishing returns.

For a first-pass stopping time T, the at-risk indicator I(T >= j) is predictable with respect to the natural past-outcome history; T itself need not be predictable. Such outcome stopping does not by itself invalidate a constant conditional-hazard model. The historical graph classifier uses candidate and record information, so its post-hoc selected risk set does not automatically satisfy the observation assumptions of the mathematical proposition. The proposition and this marginal fit have distinct roles.

## Explicit process exits

The finite-history within-chain pass fraction is 206/230 = 89.57%; the complementary 24/230 = 10.43% terminate without a within-chain pass. Mean observed length to either terminal outcome is 329/230 = 1.4304 submitted-version transitions. It is not expected edits until eventual success. Whole-task reference intervals are [85.40, 93.53]% for the within-chain pass fraction and [1.2271, 1.6955] for observed length.

At each step n_j = d_j + c_j + n_(j+1), where d is a pass and c an observed chain exit. Cumulative within-chain pass incidence is sum(d_k, k<=j)/230; cumulative exit incidence is sum(c_k, k<=j)/230. These finite-cohort quantities require no independent-censoring assumption: exit is part of the endpoint, not an imputed pass or failure.

| Step | At risk | Recorded passes | Chain exits | Continue |
|---|---:|---:|---:|---:|
| 1 | 230 | 167 | 18 | 45 |
| 2 | 45 | 29 | 4 | 12 |
| 3 | 12 | 1 | 0 | 11 |
| 4 | 11 | 5 | 0 | 6 |
| 5 | 6 | 2 | 1 | 3 |
| 6 | 3 | 0 | 0 | 3 |
| 7 | 3 | 0 | 0 | 3 |
| 8 | 3 | 0 | 0 | 3 |
| 9 | 3 | 0 | 0 | 3 |
| 10 | 3 | 0 | 0 | 3 |
| 11 | 3 | 1 | 0 | 2 |
| 12 | 2 | 1 | 0 | 1 |
| 13 | 1 | 0 | 0 | 1 |
| 14 | 1 | 0 | 0 | 1 |
| 15 | 1 | 0 | 0 | 1 |
| 16 | 1 | 0 | 0 | 1 |
| 17 | 1 | 0 | 1 | 0 |

## Selection diagnostic and sensitivity

There are 39 tasks contributing later risk rows. Restricting first steps to those tasks gives 12/61 passes. However, these 61 first steps comprise 45 episodes that actually continue (0/45 first-step passes, by construction of stopping at first pass) and 16 other episodes (12/16 first-step passes). The apparent reversal from selecting tasks with later observations is not a demonstrated within-task improvement or an established Simpson's-paradox mechanism. Later-step availability is a future-dependent selection variable.

Across leave-one-task-out reconstructions, the later-minus-first difference ranges from -36.07 to -23.57 percentage points and the odds ratio from 0.2156 to 0.3593. This bounded influence check does not verify cross-task independence or remove archive selection.

Adding medium-confidence edges reconnects processes and changes the fail-origin cohort. That is a different-cohort sensitivity analysis, not fixed-cohort robustness. We retain the original high-confidence cohort.

## Reproduction and sources

Run python process_analysis.py --output-root recomputed from the analysis directory. Default input is the bundled minimal inputs/process/episodes.json, checked against its manifest. The --input-root option accepts another directory with the same frozen schema. Frozen paths were checked against the read-only stage-six graph and stage-seven summary/risk rows; source hashes were unchanged. This consistency check does not certify the inferred graph roles or semantic correctness.

The [statsmodels GEE documentation](https://www.statsmodels.org/stable/gee.html) specifies within-cluster correlation and between-cluster independence. The accompanying mathematical insert gives stopped-process equations and assumptions. These standard methods sharpen an auditable process question; no new statistical estimator is claimed.
