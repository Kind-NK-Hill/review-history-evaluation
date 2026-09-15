import Mathlib.Tactic
import Mathlib.MeasureTheory.Measure.Prod
import ProbabilityTheory.chapter_08.def_8_5

/-! # Couplings and the universal total-variation lower bound -/

open MeasureTheory Set

noncomputable section

namespace CouplingCore

variable {α : Type*} [MeasurableSpace α]

/-- A measure on the product is a coupling when its coordinate marginals are the given measures. -/
def IsCoupling (γ : Measure (α × α)) (P Q : Measure α) : Prop :=
  Measure.map Prod.fst γ = P ∧ Measure.map Prod.snd γ = Q

/-- The event on which the two coordinates of a coupling disagree. -/
def mismatchSet [MeasurableEq α] : Set (α × α) := (diagonal α)ᶜ

/-- A coupling is automatically a probability measure as soon as its first marginal is one. -/
lemma isProbabilityMeasure_of_isCoupling_left
    (γ : Measure (α × α)) (P Q : Measure α) [IsProbabilityMeasure P]
    (hγ : IsCoupling γ P Q) : IsProbabilityMeasure γ := by
  constructor
  calc
    γ univ = Measure.map Prod.fst γ univ := by
      rw [Measure.map_apply measurable_fst MeasurableSet.univ]
      rfl
    _ = P univ := by rw [hγ.1]
    _ = 1 := measure_univ

lemma measurableSet_mismatchSet [MeasurableEq α] : MeasurableSet (mismatchSet (α := α)) := by
  exact measurableSet_diagonal.compl

lemma coupling_event_difference_le_mismatch [MeasurableEq α]
    (γ : Measure (α × α)) [IsFiniteMeasure γ]
    (P Q : Measure α) (hγ : IsCoupling γ P Q)
    (A : Set α) (hA : MeasurableSet A) :
    |P.real A - Q.real A| ≤ γ.real (mismatchSet (α := α)) := by
  have hfst : P A = γ (Prod.fst ⁻¹' A) := by
    rw [← hγ.1, Measure.map_apply measurable_fst hA]
  have hsnd : Q A = γ (Prod.snd ⁻¹' A) := by
    rw [← hγ.2, Measure.map_apply measurable_snd hA]
  have hsub₁ : Prod.fst ⁻¹' A ⊆ Prod.snd ⁻¹' A ∪ mismatchSet (α := α) := by
    rintro ⟨x, y⟩ hx
    by_cases hy : y ∈ A
    · exact Or.inl hy
    · exact Or.inr (by
        simp only [mismatchSet, mem_compl_iff, mem_diagonal_iff]
        intro hxy
        exact hy (hxy ▸ hx))
  have hsub₂ : Prod.snd ⁻¹' A ⊆ Prod.fst ⁻¹' A ∪ mismatchSet (α := α) := by
    rintro ⟨x, y⟩ hy
    by_cases hx : x ∈ A
    · exact Or.inl hx
    · exact Or.inr (by
        simp only [mismatchSet, mem_compl_iff, mem_diagonal_iff]
        intro hxy
        exact hx (hxy ▸ hy))
  have hle₁ : P.real A ≤ Q.real A + γ.real (mismatchSet (α := α)) := by
    rw [Measure.real_def, Measure.real_def, Measure.real_def, hfst, hsnd]
    rw [← ENNReal.toReal_add (measure_ne_top γ _) (measure_ne_top γ _)]
    exact ENNReal.toReal_mono (ENNReal.add_ne_top.2 ⟨measure_ne_top γ _, measure_ne_top γ _⟩) <|
      (measure_mono hsub₁).trans (measure_union_le _ _)
  have hle₂ : Q.real A ≤ P.real A + γ.real (mismatchSet (α := α)) := by
    rw [Measure.real_def, Measure.real_def, Measure.real_def, hfst, hsnd]
    rw [← ENNReal.toReal_add (measure_ne_top γ _) (measure_ne_top γ _)]
    exact ENNReal.toReal_mono (ENNReal.add_ne_top.2 ⟨measure_ne_top γ _, measure_ne_top γ _⟩) <|
      (measure_mono hsub₂).trans (measure_union_le _ _)
  rw [abs_le]
  constructor <;> linarith

/-- Every coupling has mismatch probability at least the total variation distance. -/
theorem totalVariationDistance_le_coupling_mismatch [MeasurableEq α]
    (γ : Measure (α × α)) [IsFiniteMeasure γ]
    (P Q : Measure α) (hγ : IsCoupling γ P Q) :
    totalVariationDistance P Q ≤ γ.real (mismatchSet (α := α)) := by
  unfold totalVariationDistance
  apply csSup_le
  · refine ⟨0, ?_⟩
    exact ⟨∅, MeasurableSet.empty, by simp [Measure.real_def]⟩
  · rintro d ⟨A, hA, rfl⟩
    exact coupling_event_difference_le_mismatch γ P Q hγ A hA

end CouplingCore
