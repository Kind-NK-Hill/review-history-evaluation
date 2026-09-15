import Mathlib
import ProbabilityTheory.chapter_07.def_7_3
import ProbabilityTheory.chapter_09.def_9_1

open MeasureTheory ProbabilityTheory

/-- The local textbook variance agrees with Mathlib's variance for an `L²`
random variable. -/
theorem textbookVariance_eq_variance {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (X : Ω → ℝ)
    (hXm : Measurable X) (hX : MemLp X 2 P) :
    _root_.variance P X (FiniteAbsMoment.of_memLp hXm hX) =
      ProbabilityTheory.variance X P := by
  rw [_root_.variance, rthCentralMoment]
  exact ProbabilityTheory.centralMoment_two_eq_variance hX.aemeasurable

/-- Uncorrelatedness in the textbook's product-expectation sense makes the
centered cross term vanish.  This is the step which removes every off-diagonal
term in the variance expansion. -/
theorem integral_centered_mul_eq_zero_of_uncorrelated
    {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω} [IsProbabilityMeasure P]
    {X Y : Ω → ℝ} (hX : MemLp X 2 P) (hY : MemLp Y 2 P)
    (hXY : Uncorrelated P X Y) :
    ∫ ω, (X ω - P[X]) * (Y ω - P[Y]) ∂P = 0 := by
  change ProbabilityTheory.covariance X Y P = 0
  rw [ProbabilityTheory.covariance_eq_sub hX hY, sub_eq_zero]
  simpa [Uncorrelated, Pi.mul_apply] using hXY

/-- Theorem 11.4.  For a finite family of pairwise uncorrelated real random
variables with finite second moments, variance is additive. -/
theorem thm_11_4 {Ω ι : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (s : Finset ι)
    (X : ι → Ω → ℝ) (_hXm : ∀ i ∈ s, Measurable (X i))
    (hX : ∀ i ∈ s, MemLp (X i) 2 P)
    (hunc : ∀ i ∈ s, ∀ j ∈ s, i ≠ j → Uncorrelated P (X i) (X j)) :
    ProbabilityTheory.variance (fun ω => ∑ i ∈ s, X i ω) P =
      ∑ i ∈ s, ProbabilityTheory.variance (X i) P := by
  classical
  have hcov_off : ∀ i ∈ s, ∀ j ∈ s, i ≠ j →
      ProbabilityTheory.covariance (X i) (X j) P = 0 := by
    intro i hi j hj hij
    change (∫ ω, (X i ω - P[X i]) * (X j ω - P[X j]) ∂P) = 0
    exact integral_centered_mul_eq_zero_of_uncorrelated
      (hX i hi) (hX j hj) (hunc i hi j hj hij)
  rw [ProbabilityTheory.variance_fun_sum' hX]
  apply Finset.sum_congr rfl
  intro i hi
  rw [Finset.sum_eq_single i]
  · exact ProbabilityTheory.covariance_self (hX i hi).aemeasurable
  · intro j hj hji
    exact hcov_off i hi j hj (Ne.symm hji)
  · exact fun hnot => (hnot hi).elim
