import Mathlib
import ProbabilityTheory.chapter_05.def_5_10
import ProbabilityTheory.chapter_09.def_9_1
import ProbabilityTheory.chapter_05.thm_5_8
import ProbabilityTheory.chapter_10.thm_10_1
import ProbabilityTheory.chapter_11.thm_11_1
import ProbabilityTheory.chapter_11.thm_11_5

open Filter MeasureTheory ProbabilityTheory
open scoped BigOperators
open scoped Function

/-!
# Theorem 11.7: fourth-moment strong law of large numbers

The averages below use the first `n` variables. Their value at `n = 0` is
irrelevant to convergence at infinity.
-/

/-- The sample mean of the first `n` random variables. -/
noncomputable def thm_11_7_sampleMean {Ω : Type*}
    (X : ℕ → Ω → ℝ) (n : ℕ) : Ω → ℝ :=
  fun ω => (∑ i ∈ Finset.range n, X i ω) / (n : ℝ)

private theorem thm_11_7_sampleMean_aestronglyMeasurable
    {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    (X : ℕ → Ω → ℝ) (hX : ∀ i, Measurable (X i)) (n : ℕ) :
    AEStronglyMeasurable (thm_11_7_sampleMean X n) P := by
  apply Measurable.aestronglyMeasurable
  exact (Finset.measurable_sum _ fun i _ => hX i).div_const _

/--
The fourth-moment strong law in the identically distributed case. The finite
fourth-moment assumption supplies integrability, and the strong law then gives
almost-sure convergence of the sample means to their common expectation.
-/
theorem thm_11_7 {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P]
    (X : ℕ → Ω → ℝ) (m c : ℝ)
    (hX : ∀ i, Measurable (X i))
    (hindep : Pairwise ((· ⟂ᵢ[P] ·) on X))
    (hident : ∀ i, IdentDistrib (X i) (X 0) P P)
    (hmean : ∀ i, P[X i] = m)
    (hfourth : ∀ i, FiniteAbsMoment P (X i) 4)
    (_hbound : ∀ i, generalMoment P (X i) 4 (hfourth i) ≤ c) :
    ConvergesAlmostSurely P (thm_11_7_sampleMean X) (fun _ => m) := by
  have hfirst : FiniteAbsMoment P (X 0) 1 :=
    (hfourth 0).mono (by norm_num)
  have hint : Integrable (X 0) P :=
    (hfirst.memLp one_ne_zero).integrable (by norm_num)
  refine ⟨fun n => thm_11_7_sampleMean_aestronglyMeasurable X hX n,
    measurable_const.aestronglyMeasurable, ?_⟩
  have hslln := strong_law_ae_real X hint hindep hident
  filter_upwards [hslln] with ω hω
  simpa [thm_11_7_sampleMean, hmean 0] using hω
