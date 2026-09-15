import ProbabilityTheory.chapter_13.def_13_7
import ProbabilityTheory.common_support.chapter13_stopping_support

open MeasureTheory
open scoped BigOperators ProbabilityTheory
noncomputable section

@[reducible] def prob_13_9_filtration {Ω : Type*} (X : ℕ → Ω → ℝ) :
    ℕ → MeasurableSpace Ω := chapter13_oneIndexedNaturalFiltration X

/-- `Y₀ = 0`; `Yₙ = Xₙ - E[Xₙ | 𝓕ₙ₋₁]` for positive `n`. -/
def prob_13_9_innovation {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) : ℕ → Ω → ℝ
  | 0 => 0
  | n + 1 => X (n + 1) - P[X (n + 1) | prob_13_9_filtration X n]

/-- `Sₙ = ∑_{k=1}^n Yₖ`. -/
def prob_13_9_partialSum {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) (n : ℕ) : Ω → ℝ :=
  ∑ k ∈ Finset.range n, prob_13_9_innovation P X (k + 1)

@[simp] theorem prob_13_9_partialSum_zero {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) : prob_13_9_partialSum P X 0 = 0 := by
  simp [prob_13_9_partialSum]

theorem prob_13_9_partialSum_succ {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) (n : ℕ) :
    prob_13_9_partialSum P X (n + 1) =
      prob_13_9_partialSum P X n + prob_13_9_innovation P X (n + 1) := by
  simp [prob_13_9_partialSum, Finset.sum_range_succ]

theorem prob_13_9_observation_measurable {Ω : Type*}
    (X : ℕ → Ω → ℝ) (n : ℕ) :
    @Measurable Ω ℝ (prob_13_9_filtration X (n + 1)) _ (X (n + 1)) := by
  let last : Fin (n + 1) := ⟨n, Nat.lt_succ_self n⟩
  have h := (measurable_pi_apply last).comp
    (chapter13_history_measurable_self X (n + 1))
  have heq : (fun ω => chapter13_oneIndexedHistory X (n + 1) ω last) = X (n + 1) := by
    funext ω
    simp [chapter13_oneIndexedHistory, last]
  rw [← heq]
  exact h

theorem prob_13_9_innovation_integrable
    {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω) (X : ℕ → Ω → ℝ)
    (hXint : ∀ n, 1 ≤ n → Integrable (X n) P) :
    ∀ n, Integrable (prob_13_9_innovation P X n) P := by
  intro n; cases n with
  | zero => simp [prob_13_9_innovation]
  | succ n =>
    exact (hXint (n + 1) (Nat.succ_le_succ (Nat.zero_le n))).sub integrable_condExp

theorem prob_13_9_innovation_adapted
    {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω) (X : ℕ → Ω → ℝ) :
    def_13_6_adapted (prob_13_9_filtration X) (prob_13_9_innovation P X) := by
  intro n; cases n with
  | zero =>
    change @Measurable Ω ℝ (⊥ : MeasurableSpace Ω) _ (0 : Ω → ℝ)
    exact @measurable_const ℝ Ω _ (⊥ : MeasurableSpace Ω) 0
  | succ n =>
    apply Measurable.sub (prob_13_9_observation_measurable X n)
    have hc : @Measurable Ω ℝ (prob_13_9_filtration X n) _
        (P[X (n + 1) | prob_13_9_filtration X n]) := stronglyMeasurable_condExp.measurable
    exact hc.mono
      (chapter13_oneIndexedNaturalFiltration_mono X (Nat.le_succ n)) le_rfl

private theorem prob_13_9_measurable_all
    {Ω : Type*} [𝓕 : MeasurableSpace Ω] (X : ℕ → Ω → ℝ) (hXzero : X 0 = 0)
    (hXmeas : ∀ n, 1 ≤ n → @Measurable Ω ℝ 𝓕 _ (X n)) :
    ∀ n, @Measurable Ω ℝ 𝓕 _ (X n) := by
  intro n; cases n with
  | zero => rw [hXzero]; exact measurable_zero
  | succ n => exact hXmeas (n + 1) (Nat.succ_le_succ (Nat.zero_le n))

theorem prob_13_9_innovation_condExp_zero
    {Ω : Type*} [𝓕 : MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    (X : ℕ → Ω → ℝ) (hXzero : X 0 = 0)
    (hXmeas : ∀ n, 1 ≤ n → @Measurable Ω ℝ 𝓕 _ (X n))
    (hXint : ∀ n, 1 ≤ n → Integrable (X n) P) (n : ℕ) :
    P[prob_13_9_innovation P X (n + 1) | prob_13_9_filtration X n] =ᵐ[P]
      (0 : Ω → ℝ) := by
  have hsub : prob_13_9_filtration X n ≤ 𝓕 :=
    chapter13_oneIndexedNaturalFiltration_sub_ambient X
      (prob_13_9_measurable_all X hXzero hXmeas) n
  have hXi := hXint (n + 1) (Nat.succ_le_succ (Nat.zero_le n))
  calc
    P[prob_13_9_innovation P X (n + 1) | prob_13_9_filtration X n]
        =ᵐ[P] P[X (n + 1) | prob_13_9_filtration X n] -
          P[P[X (n + 1) | prob_13_9_filtration X n] | prob_13_9_filtration X n] := by
      simpa [prob_13_9_innovation] using
        (condExp_sub hXi (integrable_condExp :
          Integrable (P[X (n + 1) | prob_13_9_filtration X n]) P)
          (prob_13_9_filtration X n))
    _ = (0 : Ω → ℝ) := by
      rw [condExp_of_stronglyMeasurable hsub stronglyMeasurable_condExp
        (integrable_condExp : Integrable
          (P[X (n + 1) | prob_13_9_filtration X n]) P)]
      simp

theorem prob_13_9_partialSum_integrable
    {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω) (X : ℕ → Ω → ℝ)
    (hXint : ∀ n, 1 ≤ n → Integrable (X n) P) :
    ∀ n, Integrable (prob_13_9_partialSum P X n) P := by
  intro n
  exact integrable_finsetSum' _ fun k _ =>
    prob_13_9_innovation_integrable P X hXint (k + 1)

theorem prob_13_9_partialSum_adapted
    {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω) (X : ℕ → Ω → ℝ) :
    def_13_6_adapted (prob_13_9_filtration X) (prob_13_9_partialSum P X) := by
  intro n
  rw [prob_13_9_partialSum]
  have hm : @Measurable Ω ℝ (prob_13_9_filtration X n) _
      (fun ω => ∑ k ∈ Finset.range n, prob_13_9_innovation P X (k + 1) ω) := by
    apply Finset.measurable_sum (Finset.range n)
    intro k hk
    exact (prob_13_9_innovation_adapted P X (k + 1)).mono
      (chapter13_oneIndexedNaturalFiltration_mono X
        (Nat.succ_le_iff.mpr (Finset.mem_range.mp hk))) le_rfl
  simpa only [Finset.sum_fn] using hm

theorem prob_13_9_partialSum_condExp_succ
    {Ω : Type*} [𝓕 : MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    (X : ℕ → Ω → ℝ) (hXzero : X 0 = 0)
    (hXmeas : ∀ n, 1 ≤ n → @Measurable Ω ℝ 𝓕 _ (X n))
    (hXint : ∀ n, 1 ≤ n → Integrable (X n) P) (n : ℕ) :
    P[prob_13_9_partialSum P X (n + 1) | prob_13_9_filtration X n] =ᵐ[P]
      prob_13_9_partialSum P X n := by
  have hSnint := prob_13_9_partialSum_integrable P X hXint n
  have hYnint := prob_13_9_innovation_integrable P X hXint (n + 1)
  have hsub : prob_13_9_filtration X n ≤ 𝓕 :=
    chapter13_oneIndexedNaturalFiltration_sub_ambient X
      (prob_13_9_measurable_all X hXzero hXmeas) n
  calc
    P[prob_13_9_partialSum P X (n + 1) | prob_13_9_filtration X n]
        =ᵐ[P] P[prob_13_9_partialSum P X n | prob_13_9_filtration X n] +
          P[prob_13_9_innovation P X (n + 1) | prob_13_9_filtration X n] := by
      rw [prob_13_9_partialSum_succ]
      exact condExp_add hSnint hYnint _
    _ =ᵐ[P] prob_13_9_partialSum P X n + (0 : Ω → ℝ) := by
      rw [condExp_of_stronglyMeasurable hsub
        (prob_13_9_partialSum_adapted P X n).stronglyMeasurable hSnint]
      filter_upwards
        [prob_13_9_innovation_condExp_zero P X hXzero hXmeas hXint n] with ω hω
      simp [hω]
    _ = prob_13_9_partialSum P X n := by simp

/-- Problem 13.9, directly from the original observation hypotheses. -/
theorem prob_13_9
    {Ω : Type*} [𝓕 : MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    (X : ℕ → Ω → ℝ) (hXzero : X 0 = 0)
    (hXmeas : ∀ n, 1 ≤ n → @Measurable Ω ℝ 𝓕 _ (X n))
    (hXint : ∀ n, 1 ≤ n → Integrable (X n) P) :
    def_13_7 P (prob_13_9_filtration X) (prob_13_9_partialSum P X) := by
  have hXmeas_all := prob_13_9_measurable_all X hXzero hXmeas
  refine ⟨chapter13_oneIndexedNaturalFiltration_isFiltration X hXmeas_all,
    prob_13_9_partialSum_integrable P X hXint,
    prob_13_9_partialSum_adapted P X, ?_⟩
  intro n
  exact
    { isProbabilityMeasure := inferInstance
      sub_ambient := chapter13_oneIndexedNaturalFiltration_sub_ambient X hXmeas_all n
      integrable := prob_13_9_partialSum_integrable P X hXint (n + 1)
      condExp_eq := prob_13_9_partialSum_condExp_succ P X hXzero hXmeas hXint n }
