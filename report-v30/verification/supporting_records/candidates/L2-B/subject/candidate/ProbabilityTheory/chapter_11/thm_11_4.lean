import ProbabilityTheory.chapter_07.def_7_3
import ProbabilityTheory.chapter_09.def_9_1

open MeasureTheory ProbabilityTheory

namespace Theorem11_4

lemma memLp_finset_sum {Ω ι : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} (s : Finset ι) (X : ι → Ω → ℝ)
    (hX : ∀ i ∈ s, MemLp (X i) 2 P) :
    MemLp (fun ω => ∑ i ∈ s, X i ω) 2 P := by
  classical
  induction s using Finset.induction_on with
  | empty => simpa using (MemLp.zero : MemLp (fun _ : Ω => (0 : ℝ)) 2 P)
  | @insert a s ha ih =>
      have hs := ih (fun i hi => hX i (Finset.mem_insert_of_mem hi))
      have ha' := hX a (Finset.mem_insert_self a s)
      convert ha'.add hs using 1
      ext ω
      simp [Finset.sum_insert ha]

lemma measurable_finset_sum {Ω ι : Type*} [MeasurableSpace Ω]
    (s : Finset ι) (X : ι → Ω → ℝ)
    (hX : ∀ i ∈ s, Measurable (X i)) :
    Measurable (fun ω => ∑ i ∈ s, X i ω) := by
  classical
  induction s using Finset.induction_on with
  | empty => simpa using (measurable_const : Measurable (fun _ : Ω => (0 : ℝ)))
  | @insert a s ha ih =>
      simpa [Finset.sum_insert ha] using
        (hX a (Finset.mem_insert_self a s)).add
          (ih (fun i hi => hX i (Finset.mem_insert_of_mem hi)))

/-- The integral of a centered cross term vanishes.  This is the precise
place where the textbook definition of uncorrelatedness is used. -/
lemma integral_centered_mul_eq_zero {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P] {X Y : Ω → ℝ}
    (hX : MemLp X 2 P) (hY : MemLp Y 2 P)
    (hXY : Uncorrelated P X Y) :
    ∫ ω, (X ω - P[X]) * (Y ω - P[Y]) ∂P = 0 := by
  have hcov : ProbabilityTheory.covariance X Y P = 0 := by
    rw [ProbabilityTheory.covariance_eq_sub hX hY]
    exact sub_eq_zero.mpr hXY
  exact hcov

private lemma local_variance_eq_integral {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (X : Ω → ℝ)
    (hXm : Measurable X) (hX : MemLp X 2 P) :
    _root_.variance P X (FiniteAbsMoment.of_memLp hXm hX) =
      ∫ ω, (X ω - P[X]) ^ 2 ∂P := by
  rw [_root_.variance, rthCentralMoment]
  rw [ProbabilityTheory.centralMoment_two_eq_variance hX.aemeasurable]
  rw [ProbabilityTheory.variance_eq_integral hX.aemeasurable]

/-- **Theorem 11.4.**  The variance of a finite sum of pairwise uncorrelated
real random variables is the sum of their variances. -/
theorem thm_11_4 {Ω ι : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] [Fintype ι]
    (X : ι → Ω → ℝ) (hXm : ∀ i, Measurable (X i))
    (hX : ∀ i, MemLp (X i) 2 P)
    (huncorr : ∀ i j, i ≠ j → Uncorrelated P (X i) (X j)) :
    _root_.variance P (fun ω => ∑ i, X i ω)
        (FiniteAbsMoment.of_memLp
          (by classical exact measurable_finset_sum Finset.univ X (by simpa using hXm))
          (by classical exact memLp_finset_sum Finset.univ X (by simpa using hX))) =
      ∑ i, _root_.variance P (X i) (FiniteAbsMoment.of_memLp (hXm i) (hX i)) := by
  classical
  let Y : ι → Ω → ℝ := fun i ω => X i ω - P[X i]
  have hY : ∀ i, MemLp (Y i) 2 P := fun i =>
    (hX i).sub (memLp_const (P[X i]))
  have hYprod : ∀ i j, Integrable (fun ω => Y i ω * Y j ω) P := by
    intro i j
    change Integrable (Y i * Y j) P
    exact (hY i).integrable_mul (hY j)
  have hsum_centered :
      (fun ω => (∑ i, X i ω) - P[fun ω => ∑ i, X i ω]) =
        (fun ω => ∑ i, Y i ω) := by
    funext ω
    rw [integral_finset_sum Finset.univ (fun i _ => (hX i).integrable (by norm_num))]
    simp only [Y]
    rw [← Finset.sum_sub_distrib]
  have hsquare :
      (fun ω => (∑ i, Y i ω) ^ 2) =
        (fun ω => ∑ i, ∑ j, Y i ω * Y j ω) := by
    funext ω
    simp only [pow_two, Finset.sum_mul, Finset.mul_sum]
    rw [Finset.sum_comm]
  have hcross : ∀ i j, i ≠ j → ∫ ω, Y i ω * Y j ω ∂P = 0 := by
    intro i j hij
    exact integral_centered_mul_eq_zero (hX i) (hX j) (huncorr i j hij)
  have hdouble :
      (∑ i, ∑ j, ∫ ω, Y i ω * Y j ω ∂P) =
        ∑ i, ∫ ω, (Y i ω) ^ 2 ∂P := by
    apply Finset.sum_congr rfl
    intro i hi
    rw [Finset.sum_eq_single i]
    · congr 1
      funext ω
      simp [pow_two]
    · intro j hj hji
      exact hcross i j hji.symm
    · simp
  rw [local_variance_eq_integral P (fun ω => ∑ i, X i ω)
    (measurable_finset_sum Finset.univ X (by simpa using hXm))
    (memLp_finset_sum Finset.univ X (by simpa using hX))]
  calc
    (∫ ω, ((∑ i, X i ω) - P[fun ω => ∑ i, X i ω]) ^ 2 ∂P) =
        ∫ ω, (∑ i, Y i ω) ^ 2 ∂P := by
          apply integral_congr_ae
          filter_upwards [] with ω
          rw [← congrFun hsum_centered ω]
    _ = ∫ ω, ∑ i, ∑ j, Y i ω * Y j ω ∂P := by rw [hsquare]
    _ = ∑ i, ∑ j, ∫ ω, Y i ω * Y j ω ∂P := by
      rw [integral_finset_sum Finset.univ]
      · simp_rw [integral_finset_sum Finset.univ (fun j _ => hYprod _ j)]
      · intro i hi
        exact integrable_finset_sum Finset.univ (fun j _ => hYprod i j)
    _ = ∑ i, ∫ ω, (Y i ω) ^ 2 ∂P := hdouble
    _ = ∑ i, _root_.variance P (X i)
          (FiniteAbsMoment.of_memLp (hXm i) (hX i)) := by
      apply Finset.sum_congr rfl
      intro i hi
      rw [local_variance_eq_integral P (X i) (hXm i) (hX i)]

end Theorem11_4

export Theorem11_4 (thm_11_4)
