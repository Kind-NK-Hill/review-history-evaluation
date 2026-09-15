import Mathlib
import ProbabilityTheory.chapter_10.def_10_2
import ProbabilityTheory.chapter_11.thm_11_2
import ProbabilityTheory.chapter_11.thm_11_4

open Filter MeasureTheory ProbabilityTheory

/-- The average of the first `n` terms.  `Finset.range n` is the zero-based
reindexing of the textbook indices `1, ..., n`. -/
noncomputable def sampleAverage {Ω : Type*} (X : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) : ℝ :=
  (∑ i ∈ Finset.range n, X i ω) / (n : ℝ)

/-- The first `n` variables with a common mean have sample-average mean `μ`
(for the only relevant case `n > 0`). -/
theorem integral_sampleAverage {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (X : ℕ → Ω → ℝ) (μ : ℝ)
    (hX : ∀ i, MemLp (X i) 2 P) (hmean : ∀ i, ∫ ω, X i ω ∂P = μ)
    {n : ℕ} (hn : 0 < n) :
    ∫ ω, sampleAverage X n ω ∂P = μ := by
  rw [show (fun ω => sampleAverage X n ω) =
      (fun ω => (∑ i ∈ Finset.range n, X i ω) / (n : ℝ)) by rfl]
  rw [integral_div]
  rw [integral_finsetSum]
  · simp_rw [hmean]
    simp [hn.ne']
  · intro i hi
    exact (hX i).integrable one_le_two

/-- Under the hypotheses of Theorem 11.5, the sample-average variance is
exactly `σ²/n`. -/
theorem variance_sampleAverage {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (X : ℕ → Ω → ℝ)
    (σ2 : ℝ) (hXm : ∀ i, Measurable (X i))
    (hX : ∀ i, MemLp (X i) 2 P)
    (hunc : ∀ i j, i ≠ j → Uncorrelated P (X i) (X j))
    (hvar : ∀ i, ProbabilityTheory.variance (X i) P = σ2)
    {n : ℕ} (hn : 0 < n) :
    ProbabilityTheory.variance (sampleAverage X n) P = σ2 / (n : ℝ) := by
  have havg : sampleAverage X n =
      fun ω => (1 / (n : ℝ)) * (∑ i ∈ Finset.range n, X i ω) := by
    funext ω
    simp [sampleAverage, div_eq_mul_inv, mul_comm]
  rw [havg, ProbabilityTheory.variance_const_mul]
  rw [thm_11_4 P (Finset.range n) X
    (fun i _ => hXm i) (fun i _ => hX i)
    (fun i _ j _ hij => hunc i j hij)]
  simp_rw [hvar]
  simp
  field_simp

/-- The actual Chebyshev estimate used in the weak law. -/
theorem sampleAverage_tail_bound {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (X : ℕ → Ω → ℝ)
    (μ σ2 ε : ℝ) (hXm : ∀ i, Measurable (X i))
    (hX : ∀ i, MemLp (X i) 2 P)
    (hunc : ∀ i j, i ≠ j → Uncorrelated P (X i) (X j))
    (hmean : ∀ i, ∫ ω, X i ω ∂P = μ)
    (hvar : ∀ i, _root_.variance P (X i)
      (FiniteAbsMoment.of_memLp (hXm i) (hX i)) = σ2)
    (hε : 0 < ε) {n : ℕ} (hn : 0 < n) :
    P (deviationEvent (sampleAverage X) (fun _ => μ) n ε) ≤
      ENNReal.ofReal (σ2 / ((n : ℝ) * ε ^ 2)) := by
  have hvar_math : ∀ i, ProbabilityTheory.variance (X i) P = σ2 := by
    intro i
    rw [← textbookVariance_eq_variance P (X i) (hXm i) (hX i)]
    exact hvar i
  have havg_mem : MemLp (sampleAverage X n) 2 P := by
    rw [show sampleAverage X n = fun ω =>
      (∑ i ∈ Finset.range n, X i ω) * (1 / (n : ℝ)) by
        funext ω
        simp [sampleAverage, div_eq_mul_inv]]
    simpa only [Finset.sum_apply] using
      (memLp_finsetSum' (Finset.range n) (fun i _ => hX i)).mul_const (1 / (n : ℝ))
  have havg_meas : Measurable (sampleAverage X n) := by
    exact (Finset.measurable_sum (Finset.range n)
      (fun i _ => hXm i)).div_const n
  have hE : ∫ ω, sampleAverage X n ω ∂P = μ :=
    integral_sampleAverage P X μ hX hmean hn
  have hsubset : deviationEvent (sampleAverage X) (fun _ => μ) n ε ⊆
      {ω | ε ≤ |sampleAverage X n ω - P[sampleAverage X n]|} := by
    intro ω hω
    rw [hE]
    change ε < |sampleAverage X n ω - μ| at hω
    exact le_of_lt hω
  have hreal :
      P.real (deviationEvent (sampleAverage X) (fun _ => μ) n ε) ≤
        _root_.variance P (sampleAverage X n)
          (FiniteAbsMoment.of_memLp havg_meas havg_mem) / ε ^ 2 := by
    calc
      P.real (deviationEvent (sampleAverage X) (fun _ => μ) n ε)
          ≤ P.real {ω | ε ≤ |sampleAverage X n ω - P[sampleAverage X n]|} :=
        measureReal_mono hsubset
      _ ≤ _root_.variance P (sampleAverage X n)
          (FiniteAbsMoment.of_memLp havg_meas havg_mem) / ε ^ 2 :=
        thm_11_2 P (sampleAverage X n) havg_meas havg_mem hε
  have henn := ENNReal.ofReal_le_ofReal hreal
  rw [ofReal_measureReal] at henn
  calc
    P (deviationEvent (sampleAverage X) (fun _ => μ) n ε)
        ≤ ENNReal.ofReal (_root_.variance P (sampleAverage X n)
          (FiniteAbsMoment.of_memLp havg_meas havg_mem) / ε ^ 2) := henn
    _ = ENNReal.ofReal (σ2 / ((n : ℝ) * ε ^ 2)) := by
      rw [textbookVariance_eq_variance P (sampleAverage X n) havg_meas havg_mem]
      rw [variance_sampleAverage P X σ2 hXm hX hunc hvar_math hn]
      congr 1
      field_simp

/-- Theorem 11.5 (weak law of large numbers, `L²` version).  Pairwise
uncorrelated variables with common mean and common finite variance have sample
averages converging in probability to that mean. -/
theorem thm_11_5 {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (X : ℕ → Ω → ℝ)
    (μ σ2 : ℝ) (hXm : ∀ i, Measurable (X i))
    (hX : ∀ i, MemLp (X i) 2 P)
    (hunc : ∀ i j, i ≠ j → Uncorrelated P (X i) (X j))
    (hmean : ∀ i, ∫ ω, X i ω ∂P = μ)
    (hvar : ∀ i, _root_.variance P (X i)
      (FiniteAbsMoment.of_memLp (hXm i) (hX i)) = σ2) :
    ConvergesInProbability P (sampleAverage X) (fun _ => μ) := by
  refine ⟨?_, measurable_const, ?_⟩
  · intro n
    exact (Finset.measurable_sum (Finset.range n) (fun i _ => hXm i)).div_const n
  · intro ε hε
    have hbound : Tendsto
        (fun n : ℕ => ENNReal.ofReal (σ2 / ε ^ 2 * (1 / (n : ℝ))))
        atTop (nhds 0) := by
      simpa using ENNReal.tendsto_ofReal
        (tendsto_one_div_atTop_nhds_zero_nat.const_mul (σ2 / ε ^ 2))
    apply tendsto_of_tendsto_of_tendsto_of_le_of_le' tendsto_const_nhds hbound
    · exact Eventually.of_forall fun n => bot_le
    · filter_upwards [eventually_ge_atTop (1 : ℕ)] with n hn
      have hnpos : 0 < n := Nat.zero_lt_of_lt hn
      refine (sampleAverage_tail_bound P X μ σ2 ε hXm hX hunc hmean hvar hε hnpos).trans_eq ?_
      congr 1
      field_simp
