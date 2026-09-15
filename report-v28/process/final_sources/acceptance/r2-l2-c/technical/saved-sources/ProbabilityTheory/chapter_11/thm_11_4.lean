import Mathlib
import ProbabilityTheory.chapter_07.def_7_3
import ProbabilityTheory.chapter_09.def_9_1

/-!
# Theorem 11.4: variance of a finite sum of pairwise uncorrelated variables

The cross-term lemma below deliberately starts from the textbook definition
`Uncorrelated P X Y`, namely `E[XY] = E[X] E[Y]`. Thus the vanishing of the
centered product is proved rather than supplied as an additional hypothesis.
-/

open MeasureTheory ProbabilityTheory

/-- Uncorrelated square-integrable variables have zero centered cross integral. -/
theorem centered_cross_integral_eq_zero {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (X Y : Ω → ℝ)
    (hX : MemLp X 2 P) (hY : MemLp Y 2 P) (hXY : Uncorrelated P X Y) :
    ∫ ω, (X ω - P[X]) * (Y ω - P[Y]) ∂P = 0 := by
  change ProbabilityTheory.covariance X Y P = 0
  rw [ProbabilityTheory.covariance_eq_sub hX hY, sub_eq_zero]
  exact hXY

/-- The binary variance identity after deriving that its centered cross term vanishes. -/
theorem variance_add_of_uncorrelated {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (X Y : Ω → ℝ)
    (hX : MemLp X 2 P) (hY : MemLp Y 2 P) (hXY : Uncorrelated P X Y) :
    ProbabilityTheory.variance (X + Y) P =
      ProbabilityTheory.variance X P + ProbabilityTheory.variance Y P := by
  have hcross := centered_cross_integral_eq_zero P X Y hX hY hXY
  have hvar := ProbabilityTheory.variance_add hX hY
  change ProbabilityTheory.covariance X Y P = 0 at hcross
  rw [hvar, hcross]
  ring

/--
Theorem 11.4. For every finite index set, the variance of a sum of pairwise
uncorrelated, square-integrable real random variables is the sum of their
variances. The theorem uses the textbook `FiniteAbsMoment`-indexed variance.
-/
theorem thm_11_4 {Ω ι : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (X : ι → Ω → ℝ) (s : Finset ι)
    (hXm : ∀ i, Measurable (X i))
    (hX : ∀ i, MemLp (X i) 2 P)
    (hpair : ∀ i j, i ≠ j → Uncorrelated P (X i) (X j)) :
    _root_.variance P (∑ i ∈ s, X i)
        (FiniteAbsMoment.of_memLp
          (by fun_prop)
          (memLp_finsetSum' s fun i _ => hX i)) =
      ∑ i ∈ s,
        _root_.variance P (X i) (FiniteAbsMoment.of_memLp (hXm i) (hX i)) := by
  classical
  have hvariance (Z : Ω → ℝ) (hZm : Measurable Z) (hZ : MemLp Z 2 P) :
      _root_.variance P Z (FiniteAbsMoment.of_memLp hZm hZ) =
        ProbabilityTheory.variance Z P := by
    rw [_root_.variance, rthCentralMoment]
    exact ProbabilityTheory.centralMoment_two_eq_variance hZ.aemeasurable
  rw [hvariance (∑ i ∈ s, X i) (by fun_prop)
    (memLp_finsetSum' s fun i _ => hX i)]
  simp_rw [hvariance (X _) (hXm _) (hX _)]
  induction s using Finset.induction_on with
  | empty => simp
  | @insert a s ha ih =>
      have hsum : MemLp (∑ i ∈ s, X i) 2 P :=
        memLp_finsetSum' s fun i _ => hX i
      have hcov_each :
          ∀ i ∈ s, ProbabilityTheory.covariance (X i) (X a) P = 0 := by
        intro i hi
        have hia : i ≠ a := fun h => ha (h ▸ hi)
        have hcenter := centered_cross_integral_eq_zero P (X i) (X a)
          (hX i) (hX a) (hpair i a hia)
        exact hcenter
      have hcov_sum :
          ProbabilityTheory.covariance (∑ i ∈ s, X i) (X a) P = 0 := by
        rw [ProbabilityTheory.covariance_sum_left'
          (fun i _ => hX i) (hX a)]
        exact Finset.sum_eq_zero fun i hi => hcov_each i hi
      have hsum_uncorr : Uncorrelated P (∑ i ∈ s, X i) (X a) := by
        rw [← covariance_zero_iff_uncorrelated hsum (hX a)]
        exact hcov_sum
      have hadd := variance_add_of_uncorrelated P (∑ i ∈ s, X i) (X a)
        hsum (hX a) hsum_uncorr
      calc
        ProbabilityTheory.variance (∑ i ∈ insert a s, X i) P =
            ProbabilityTheory.variance ((∑ i ∈ s, X i) + X a) P := by
              congr 1
              ext ω
              simp [ha, add_comm]
        _ = ProbabilityTheory.variance (∑ i ∈ s, X i) P +
              ProbabilityTheory.variance (X a) P := hadd
        _ = (∑ i ∈ s, ProbabilityTheory.variance (X i) P) +
              ProbabilityTheory.variance (X a) P := by rw [ih]
        _ = ∑ i ∈ insert a s, ProbabilityTheory.variance (X i) P := by
              simp [ha, add_comm]

/-- The same finite-sum conclusion in Mathlib's proof-irrelevant variance notation. -/
theorem variance_finset_sum_of_pairwise_uncorrelated
    {Ω ι : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (X : ι → Ω → ℝ) (s : Finset ι)
    (hXm : ∀ i, Measurable (X i))
    (hX : ∀ i, MemLp (X i) 2 P)
    (hpair : ∀ i j, i ≠ j → Uncorrelated P (X i) (X j)) :
    ProbabilityTheory.variance (∑ i ∈ s, X i) P =
      ∑ i ∈ s, ProbabilityTheory.variance (X i) P := by
  classical
  have h := thm_11_4 P X s hXm hX hpair
  have hvariance (Z : Ω → ℝ) (hZm : Measurable Z) (hZ : MemLp Z 2 P) :
      _root_.variance P Z (FiniteAbsMoment.of_memLp hZm hZ) =
        ProbabilityTheory.variance Z P := by
    rw [_root_.variance, rthCentralMoment]
    exact ProbabilityTheory.centralMoment_two_eq_variance hZ.aemeasurable
  rw [hvariance (∑ i ∈ s, X i) (by fun_prop)
    (memLp_finsetSum' s fun i _ => hX i)] at h
  simpa only [hvariance (X _) (hXm _) (hX _)] using h
