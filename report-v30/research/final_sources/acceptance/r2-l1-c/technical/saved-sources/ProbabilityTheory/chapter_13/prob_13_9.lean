import Mathlib
import ProbabilityTheory.chapter_13.def_13_7
import ProbabilityTheory.common_support.chapter13_stopping_support

/-!
# Problem 13.9

This module defines the innovation process and its partial sums, then proves the
concrete martingale conclusion from the source assumptions.
-/

open MeasureTheory
open scoped BigOperators ProbabilityTheory
noncomputable section

def prob_13_9_innovation {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) : ℕ → Ω → ℝ
  | 0 => 0
  | n + 1 => X (n + 1) - P[X (n + 1) | chapter13_oneIndexedNaturalFiltration X n]

def prob_13_9_partialSum {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) (n : ℕ) : Ω → ℝ :=
  ∑ k ∈ Finset.range n, prob_13_9_innovation P X (k + 1)

@[simp] theorem prob_13_9_innovation_zero {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) : prob_13_9_innovation P X 0 = 0 := rfl

@[simp] theorem prob_13_9_innovation_succ {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) (n : ℕ) :
    prob_13_9_innovation P X (n + 1) = X (n + 1) -
      P[X (n + 1) | chapter13_oneIndexedNaturalFiltration X n] := rfl

@[simp] theorem prob_13_9_partialSum_zero {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) : prob_13_9_partialSum P X 0 = 0 := by
  simp [prob_13_9_partialSum]

theorem prob_13_9_partialSum_succ {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) (n : ℕ) :
    prob_13_9_partialSum P X (n + 1) = prob_13_9_partialSum P X n +
      prob_13_9_innovation P X (n + 1) := by
  rw [prob_13_9_partialSum, Finset.sum_range_succ]
  rfl

theorem prob_13_9_measurable_all {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    (X : ℕ → Ω → ℝ) (hX0 : X 0 = 0)
    (hXmeas : ∀ n : ℕ, 1 ≤ n → Measurable (X n)) : ∀ n, Measurable (X n) := by
  intro n
  cases n with
  | zero => rw [hX0]; exact measurable_const
  | succ n => exact hXmeas (n + 1) (Nat.succ_le_succ (Nat.zero_le n))

theorem prob_13_9_observation_measurable_natural {Ω : Type*}
    (X : ℕ → Ω → ℝ) (n : ℕ) :
    @Measurable Ω ℝ (chapter13_oneIndexedNaturalFiltration X (n + 1)) _ (X (n + 1)) := by
  have heq : X (n + 1) = (fun f : Fin (n + 1) → ℝ => f (Fin.last n)) ∘
      chapter13_oneIndexedHistory X (n + 1) := by
    funext ω
    simp [chapter13_oneIndexedHistory]
  rw [heq]
  exact (measurable_pi_apply (Fin.last n)).comp
    (chapter13_history_measurable_self X (n + 1))

theorem prob_13_9_innovation_integrable {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (X : ℕ → Ω → ℝ)
    (hXint : ∀ n, 1 ≤ n → Integrable (X n) P) :
    ∀ n, Integrable (prob_13_9_innovation P X n) P := by
  intro n
  cases n with
  | zero => simp
  | succ n => exact (hXint (n + 1) (Nat.succ_le_succ (Nat.zero_le n))).sub integrable_condExp

theorem prob_13_9_innovation_adapted {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) :
    def_13_6_adapted (chapter13_oneIndexedNaturalFiltration X) (prob_13_9_innovation P X) := by
  intro n
  cases n with
  | zero => exact measurable_const
  | succ n =>
      exact (prob_13_9_observation_measurable_natural X n).sub
        (stronglyMeasurable_condExp.mono
          (chapter13_oneIndexedNaturalFiltration_mono X (Nat.le_succ n))).measurable

theorem prob_13_9_partialSum_integrable {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (X : ℕ → Ω → ℝ)
    (hXint : ∀ n, 1 ≤ n → Integrable (X n) P) :
    ∀ n, Integrable (prob_13_9_partialSum P X n) P := by
  intro n
  rw [prob_13_9_partialSum]
  apply integrable_finsetSum'
  intro k hk
  exact prob_13_9_innovation_integrable P X hXint (k + 1)

theorem prob_13_9_partialSum_adapted {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    (P : Measure Ω) (X : ℕ → Ω → ℝ) :
    def_13_6_adapted (chapter13_oneIndexedNaturalFiltration X) (prob_13_9_partialSum P X) := by
  intro n
  induction n with
  | zero => exact measurable_const
  | succ n ih =>
      rw [prob_13_9_partialSum_succ]
      exact (ih.mono (chapter13_oneIndexedNaturalFiltration_mono X (Nat.le_succ n))
        le_rfl).add
        (prob_13_9_innovation_adapted P X (n + 1))

theorem prob_13_9_innovation_condExp_zero {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (X : ℕ → Ω → ℝ)
    (hXmeas : ∀ n, Measurable (X n))
    (hXint : ∀ n, 1 ≤ n → Integrable (X n) P) (n : ℕ) :
    P[prob_13_9_innovation P X (n + 1) | chapter13_oneIndexedNaturalFiltration X n] =ᵐ[P] 0 := by
  have hsub : chapter13_oneIndexedNaturalFiltration X n ≤ 𝓕 :=
    chapter13_oneIndexedNaturalFiltration_sub_ambient (𝓕 := 𝓕) X hXmeas n
  have hint := hXint (n + 1) (Nat.succ_le_succ (Nat.zero_le n))
  calc
    P[prob_13_9_innovation P X (n + 1) | chapter13_oneIndexedNaturalFiltration X n]
        =ᵐ[P] P[X (n + 1) | chapter13_oneIndexedNaturalFiltration X n] -
          P[P[X (n + 1) | chapter13_oneIndexedNaturalFiltration X n] |
            chapter13_oneIndexedNaturalFiltration X n] :=
          condExp_sub hint integrable_condExp _
    _ =ᵐ[P] P[X (n + 1) | chapter13_oneIndexedNaturalFiltration X n] -
        P[X (n + 1) | chapter13_oneIndexedNaturalFiltration X n] :=
          Filter.EventuallyEq.sub Filter.EventuallyEq.rfl
            (condExp_condExp_of_le le_rfl hsub)
    _ =ᵐ[P] 0 := Filter.Eventually.of_forall fun _ => sub_self _

theorem prob_13_9_oneStepCondition {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (X : ℕ → Ω → ℝ)
    (hXmeas : ∀ n, Measurable (X n))
    (hXint : ∀ n, 1 ≤ n → Integrable (X n) P) :
    def_13_7_oneStepCondition P (chapter13_oneIndexedNaturalFiltration X)
      (prob_13_9_partialSum P X) := by
  intro n
  have hsub : chapter13_oneIndexedNaturalFiltration X n ≤ 𝓕 :=
    chapter13_oneIndexedNaturalFiltration_sub_ambient (𝓕 := 𝓕) X hXmeas n
  have hSint := prob_13_9_partialSum_integrable P X hXint n
  have hYint := prob_13_9_innovation_integrable P X hXint (n + 1)
  refine ⟨inferInstance, hsub, ?_, ?_⟩
  · rw [prob_13_9_partialSum_succ]
    exact hSint.add hYint
  · rw [prob_13_9_partialSum_succ]
    calc
      P[prob_13_9_partialSum P X n + prob_13_9_innovation P X (n + 1) |
          chapter13_oneIndexedNaturalFiltration X n]
          =ᵐ[P] P[prob_13_9_partialSum P X n | chapter13_oneIndexedNaturalFiltration X n] +
            P[prob_13_9_innovation P X (n + 1) |
              chapter13_oneIndexedNaturalFiltration X n] := condExp_add hSint hYint _
      _ =ᵐ[P] prob_13_9_partialSum P X n + 0 :=
        (Filter.EventuallyEq.of_eq (condExp_of_stronglyMeasurable hsub
          (prob_13_9_partialSum_adapted P X n).stronglyMeasurable hSint)).add
          (prob_13_9_innovation_condExp_zero P X hXmeas hXint n)
      _ =ᵐ[P] prob_13_9_partialSum P X n := Filter.Eventually.of_forall fun _ => add_zero _

theorem prob_13_9 {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (X : ℕ → Ω → ℝ)
    (hX0 : X 0 = 0) (hXmeas : ∀ n, 1 ≤ n → Measurable (X n))
    (hXint : ∀ n, 1 ≤ n → Integrable (X n) P) :
    def_13_7 P (chapter13_oneIndexedNaturalFiltration X) (prob_13_9_partialSum P X) := by
  have hXmeasAll := prob_13_9_measurable_all X hX0 hXmeas
  exact ⟨chapter13_oneIndexedNaturalFiltration_isFiltration X hXmeasAll,
    prob_13_9_partialSum_integrable P X hXint, prob_13_9_partialSum_adapted P X,
    prob_13_9_oneStepCondition P X hXmeasAll hXint⟩
