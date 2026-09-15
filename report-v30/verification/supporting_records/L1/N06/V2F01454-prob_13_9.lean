import Mathlib
import ProbabilityTheory.chapter_13.def_13_7
import ProbabilityTheory.common_support.chapter13_stopping_support

/-! Problem 13.9: innovations and their partial-sum martingale. -/

open MeasureTheory
open scoped BigOperators ProbabilityTheory
noncomputable section

def prob_13_9_innovation {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) : ℕ → Ω → ℝ
  | 0 => 0
  | n + 1 => X (n + 1) - P[X (n + 1) |
      chapter13_oneIndexedNaturalFiltration X n]

@[simp] theorem prob_13_9_innovation_zero {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) :
    prob_13_9_innovation P X 0 = 0 := rfl

@[simp] theorem prob_13_9_innovation_succ {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) (n : ℕ) :
    prob_13_9_innovation P X (n + 1) =
      X (n + 1) - P[X (n + 1) |
        chapter13_oneIndexedNaturalFiltration X n] := rfl

def prob_13_9_partialSum {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) (n : ℕ) : Ω → ℝ :=
  fun ω => ∑ k ∈ Finset.range n, prob_13_9_innovation P X (k + 1) ω

@[simp] theorem prob_13_9_partialSum_zero {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) :
    prob_13_9_partialSum P X 0 = 0 := by
  rfl

theorem prob_13_9_partialSum_succ {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) (n : ℕ) :
    prob_13_9_partialSum P X (n + 1) =
      prob_13_9_partialSum P X n + prob_13_9_innovation P X (n + 1) := by
  funext ω
  simp [prob_13_9_partialSum, Finset.sum_range_succ]
  ring

theorem prob_13_9_observation_measurable_succ {Ω : Type*}
    (X : ℕ → Ω → ℝ) (n : ℕ) :
    @Measurable Ω ℝ (chapter13_oneIndexedNaturalFiltration X (n + 1)) _
      (X (n + 1)) := by
  have h := (measurable_pi_apply (Fin.last n)).comp
    (chapter13_history_measurable_self X (n + 1))
  convert h using 1
  funext ω
  rfl

theorem prob_13_9_filtration_sub_ambient {Ω : Type*}
    [𝓕 : MeasurableSpace Ω] (X : ℕ → Ω → ℝ)
    (hXmeas : ∀ n : ℕ, 1 ≤ n → Measurable (X n)) (n : ℕ) :
    chapter13_oneIndexedNaturalFiltration X n ≤ 𝓕 := by
  cases n with
  | zero => exact bot_le
  | succ n =>
      have hhist :
          @Measurable Ω (Fin (n + 1) → ℝ) 𝓕 _
            (chapter13_oneIndexedHistory X (n + 1)) := by
        exact measurable_pi_lambda _ fun k =>
          hXmeas (k.1 + 1) (Nat.succ_le_succ (Nat.zero_le k.1))
      exact hhist.comap_le

theorem prob_13_9_innovation_integrable {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ)
    (hXint : ∀ n : ℕ, 1 ≤ n → Integrable (X n) P) (n : ℕ) :
    Integrable (prob_13_9_innovation P X n) P := by
  cases n with
  | zero => simp
  | succ n =>
      exact (hXint (n + 1) (Nat.succ_le_succ (Nat.zero_le n))).sub
        integrable_condExp

theorem prob_13_9_innovation_adapted {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) :
    def_13_6_adapted (chapter13_oneIndexedNaturalFiltration X)
      (prob_13_9_innovation P X) := by
  intro n
  cases n with
  | zero =>
      change @Measurable Ω ℝ
        (chapter13_oneIndexedNaturalFiltration X 0) _ (0 : Ω → ℝ)
      exact @measurable_zero ℝ Ω Real.measurableSpace
        (chapter13_oneIndexedNaturalFiltration X 0) _
  | succ n =>
      exact (prob_13_9_observation_measurable_succ X n).sub
        (stronglyMeasurable_condExp.mono
          (chapter13_oneIndexedNaturalFiltration_mono X (Nat.le_succ n))).measurable

theorem prob_13_9_partialSum_integrable {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ)
    (hXint : ∀ n : ℕ, 1 ≤ n → Integrable (X n) P) (n : ℕ) :
    Integrable (prob_13_9_partialSum P X n) P := by
  induction n with
  | zero =>
      rw [prob_13_9_partialSum_zero]
      exact integrable_zero _ _ _
  | succ n ih =>
      rw [prob_13_9_partialSum_succ]
      exact ih.add (prob_13_9_innovation_integrable P X hXint (n + 1))

theorem prob_13_9_partialSum_adapted {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) :
    def_13_6_adapted (chapter13_oneIndexedNaturalFiltration X)
      (prob_13_9_partialSum P X) := by
  intro n
  induction n with
  | zero =>
      rw [prob_13_9_partialSum_zero]
      exact measurable_const
  | succ n ih =>
      rw [prob_13_9_partialSum_succ]
      exact
        (ih.mono (chapter13_oneIndexedNaturalFiltration_mono X (Nat.le_succ n))
          le_rfl).add
          (prob_13_9_innovation_adapted P X (n + 1))

theorem prob_13_9_condExp_innovation_succ {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (X : ℕ → Ω → ℝ)
    (hXmeas : ∀ n : ℕ, 1 ≤ n → Measurable (X n))
    (hXint : ∀ n : ℕ, 1 ≤ n → Integrable (X n) P) (n : ℕ) :
    P[prob_13_9_innovation P X (n + 1) |
        chapter13_oneIndexedNaturalFiltration X n] =ᵐ[P] 0 := by
  have hsub := prob_13_9_filtration_sub_ambient X hXmeas n
  have hint := hXint (n + 1) (Nat.succ_le_succ (Nat.zero_le n))
  rw [prob_13_9_innovation_succ]
  refine (condExp_sub hint integrable_condExp
    (chapter13_oneIndexedNaturalFiltration X n)).trans ?_
  rw [condExp_of_stronglyMeasurable hsub stronglyMeasurable_condExp
    integrable_condExp]
  exact Filter.Eventually.of_forall fun ω => sub_self _

theorem prob_13_9_martingale {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (X : ℕ → Ω → ℝ)
    (hX0 : X 0 = 0)
    (hXmeas : ∀ n : ℕ, 1 ≤ n → Measurable (X n))
    (hXint : ∀ n : ℕ, 1 ≤ n → Integrable (X n) P) :
    def_13_7 P (chapter13_oneIndexedNaturalFiltration X)
      (prob_13_9_partialSum P X) := by
  have hmeas_all : ∀ n : ℕ, Measurable (X n) := by
    intro n
    cases n with
    | zero => rw [hX0]; exact measurable_const
    | succ n => exact hXmeas (n + 1) (Nat.succ_le_succ (Nat.zero_le n))
  refine ⟨chapter13_oneIndexedNaturalFiltration_isFiltration X hmeas_all,
    prob_13_9_partialSum_integrable P X hXint,
    prob_13_9_partialSum_adapted P X, ?_⟩
  intro n
  refine ⟨inferInstance,
    chapter13_oneIndexedNaturalFiltration_sub_ambient X hmeas_all n,
    prob_13_9_partialSum_integrable P X hXint (n + 1), ?_⟩
  rw [prob_13_9_partialSum_succ]
  refine (condExp_add
    (prob_13_9_partialSum_integrable P X hXint n)
    (prob_13_9_innovation_integrable P X hXint (n + 1)) _).trans ?_
  rw [condExp_of_stronglyMeasurable
    (chapter13_oneIndexedNaturalFiltration_sub_ambient X hmeas_all n)
    ((prob_13_9_partialSum_adapted P X n).stronglyMeasurable)
    (prob_13_9_partialSum_integrable P X hXint n)]
  exact (Filter.EventuallyEq.rfl.add
    (prob_13_9_condExp_innovation_succ P X hXmeas hXint n)).trans
      (Filter.Eventually.of_forall fun ω => add_zero _)
