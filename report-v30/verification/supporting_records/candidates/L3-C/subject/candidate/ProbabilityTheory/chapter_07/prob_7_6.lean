import ProbabilityTheory.common_support.scheffe
import ProbabilityTheory.chapter_10.ex_10_3_2

/-!
# Problem 7.6 and the complete Scheffé/density-convergence contract

This is the public delivery entry for the complete two-target contract.  The
proofs of the three Scheffé declarations live in the cycle-free shared module
`ProbabilityTheory.common_support.scheffe`; importing this entry exposes those
proofs together with every application required by Example 10.3.2.

Contract map:

* Negative-part control: `prob_7_6_negativePart_le` proves
  `max (f - fₙ) 0 ≤ f`.
* Negative-part integral convergence: `prob_7_6_negativePart_integral_tendsto`.
* Scheffé `L¹` convergence from the integral-difference identity:
  `prob_7_6_scheffe`.
* General density convergence in total variation and in distribution:
  `ex_10_3_2_density_convergence`.
* Positive limiting Gaussian variance: pointwise density convergence is
  `ex_10_3_2_gaussianPDFReal_tendsto`, total-variation convergence is
  `ex_10_3_2_gaussian_positiveVariance_totalVariation`, and the bundled result
  including convergence in distribution is
  `ex_10_3_2_gaussian_positiveVariance`.
* Arbitrary nonnegative Gaussian variance converges in distribution by
  `ex_10_3_2_gaussian_convergesInDistribution`; at limiting variance zero,
  `ex_10_3_2_gaussian_zeroVariance_convergesTo_dirac` identifies the limit as
  the Dirac mass at the limiting mean and makes no total-variation claim.
-/
