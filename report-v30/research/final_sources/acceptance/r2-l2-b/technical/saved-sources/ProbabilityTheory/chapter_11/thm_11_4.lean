import Mathlib
import ProbabilityTheory.chapter_07.def_7_3
import ProbabilityTheory.chapter_09.def_9_1

open MeasureTheory ProbabilityTheory

lemma finiteAbsMoment_fintypeSum {Ω ι : Type*} [MeasurableSpace Ω] [Fintype ι]
    (P : Measure Ω) [IsProbabilityMeasure P] (X : ι → Ω → ℝ)
    (hXm : ∀ i, Measurable (X i)) (hX : ∀ i, MemLp (X i) 2 P) :
    FiniteAbsMoment P (fun ω ↦ ∑ i, X i ω) 2 := by
  apply FiniteAbsMoment.of_memLp
  · fun_prop
  · convert memLp_finsetSum' Finset.univ (fun i _ ↦ hX i) using 1
    ext ω
    simp
    norm_num

theorem thm_11_4 {Ω ι : Type*} [MeasurableSpace Ω] [Fintype ι]
    (P : Measure Ω) [IsProbabilityMeasure P] (X : ι → Ω → ℝ)
    (hXm : ∀ i, Measurable (X i)) (hX : ∀ i, MemLp (X i) 2 P)
    (hunc : ∀ i j, i ≠ j → Uncorrelated P (X i) (X j)) :
    _root_.variance P (fun ω ↦ ∑ i, X i ω)
        (finiteAbsMoment_fintypeSum P X hXm hX) =
      ∑ i, _root_.variance P (X i) (FiniteAbsMoment.of_memLp (hXm i) (hX i)) := by
  classical
  have hsum : MemLp (fun ω ↦ ∑ i, X i ω) 2 P := by
    convert memLp_finsetSum' Finset.univ (fun i _ ↦ hX i) using 1
    ext ω
    simp
  have hcov (i j : ι) : ProbabilityTheory.covariance (X i) (X j) P =
        if i = j then ProbabilityTheory.variance (X i) P else 0 := by
    split_ifs with hij
    · subst j
      exact ProbabilityTheory.covariance_self (hX i).aemeasurable
    · exact (covariance_zero_iff_uncorrelated (hX i) (hX j)).2 (hunc i j hij)
  rw [_root_.variance, rthCentralMoment,
    ProbabilityTheory.centralMoment_two_eq_variance hsum.aemeasurable]
  rw [ProbabilityTheory.variance_fun_sum hX]
  simp_rw [hcov]
  simp only [Finset.sum_ite_eq, Finset.mem_univ, if_true]
  apply Finset.sum_congr rfl
  intro i _
  rw [_root_.variance, rthCentralMoment,
    ProbabilityTheory.centralMoment_two_eq_variance (hX i).aemeasurable]
