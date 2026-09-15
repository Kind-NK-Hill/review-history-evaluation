import ProbabilityTheory.chapter_09.thm_9_5
import ProbabilityTheory.chapter_03.thm_3_9
import Mathlib.MeasureTheory.Measure.CharacteristicFunction.Basic
import Mathlib.MeasureTheory.Measure.Typeclasses.SFinite

open Filter MeasureTheory Set

/-- Removing the (at most countable) common discontinuity/atom set leaves the
dense endpoint set used in the textbook interval argument. -/
theorem dense_continuity_endpoints_of_countable (s₁ s₂ : Set ℝ)
    (h₁ : s₁.Countable) (h₂ : s₂.Countable) : Dense (s₁ ∪ s₂)ᶜ := by
  exact (h₁.union h₂).dense_compl ℝ

/-- Equality on all half-lines determines a probability law.  This records the
last measure-determination step of the textbook uniqueness proof. -/
theorem probabilityMeasure_eq_of_Iic_eq
    (μ ν : Measure ℝ) [IsProbabilityMeasure μ] [IsProbabilityMeasure ν]
    (h : ∀ x, μ (Iic x) = ν (Iic x)) : μ = ν :=
  thm_3_9 μ ν h

/-- Atoms of a finite real measure form a countable set. -/
noncomputable def measureAtoms (μ : Measure ℝ) : Set ℝ := {x | μ {x} ≠ 0}

theorem countable_measureAtoms (μ : Measure ℝ) [IsFiniteMeasure μ] :
    (measureAtoms μ).Countable := by
  have h := Measure.countable_meas_level_set_pos (μ := μ) (g := fun x : ℝ ↦ x) measurable_id
  simpa [measureAtoms, pos_iff_ne_zero] using h

theorem dense_common_nonatom_endpoints (μ ν : Measure ℝ)
    [IsFiniteMeasure μ] [IsFiniteMeasure ν] :
    Dense (measureAtoms μ ∪ measureAtoms ν)ᶜ :=
  dense_continuity_endpoints_of_countable _ _ (countable_measureAtoms μ)
    (countable_measureAtoms ν)

/-- The inversion formula makes the two laws agree on every open interval whose
endpoints are non-atoms of both laws. -/
theorem inversion_interval_eq_of_charFun_eq
    (μ ν : Measure ℝ) [IsFiniteMeasure μ] [IsFiniteMeasure ν]
    (h : ∀ t : ℝ, characteristicFunction μ t = characteristicFunction ν t)
    {a b : ℝ} (hab : a < b)
    (haμ : a ∉ measureAtoms μ) (hbμ : b ∉ measureAtoms μ)
    (haν : a ∉ measureAtoms ν) (hbν : b ∉ measureAtoms ν) :
    μ.real (Ioo a b) = ν.real (Ioo a b) := by
  have hma : μ {a} = 0 := not_ne_iff.mp haμ
  have hmb : μ {b} = 0 := not_ne_iff.mp hbμ
  have hna : ν {a} = 0 := not_ne_iff.mp haν
  have hnb : ν {b} = 0 := not_ne_iff.mp hbν
  let Fμ : ℝ → ℂ := fun T ↦ (2 * Real.pi : ℂ)⁻¹ * (∫ t in -T..T,
    ((Complex.exp (-(t : ℂ) * (a : ℂ) * Complex.I) -
      Complex.exp (-(t : ℂ) * (b : ℂ) * Complex.I)) / ((t : ℂ) * Complex.I)) *
      characteristicFunction μ t)
  let Fν : ℝ → ℂ := fun T ↦ (2 * Real.pi : ℂ)⁻¹ * (∫ t in -T..T,
    ((Complex.exp (-(t : ℂ) * (a : ℂ) * Complex.I) -
      Complex.exp (-(t : ℂ) * (b : ℂ) * Complex.I)) / ((t : ℂ) * Complex.I)) *
      characteristicFunction ν t)
  have heq : Fμ = Fν := by
    funext T
    unfold Fμ Fν
    congr 2
    funext t
    rw [h t]
  have hm := CharacteristicFunctionInversion.thm_9_5_normalized μ hab
  have hn := CharacteristicFunctionInversion.thm_9_5_normalized ν hab
  have hm' : Tendsto Fμ atTop (nhds ((μ.real (Ioo a b) : ℝ) : ℂ)) := by
    convert hm using 1
    simp [Measure.real, hma, hmb]
  have hn' : Tendsto Fν atTop (nhds ((ν.real (Ioo a b) : ℝ) : ℂ)) := by
    convert hn using 1
    simp [Measure.real, hna, hnb]
  rw [heq] at hm'
  exact_mod_cast tendsto_nhds_unique hm' hn'


/-- Generic measure determination: only a dense common non-atomic endpoint set,
interval equality, and equal total mass are used. No characteristic-function fact. -/
theorem dense_interval_measure_eq (μ ν : Measure ℝ) [IsFiniteMeasure μ]
    [IsFiniteMeasure ν] (D : Set ℝ) (hD : Dense D)
    (hzero : ∀ a ∈ D, μ {a} = 0 ∧ ν {a} = 0)
    (hint : ∀ a ∈ D, ∀ b ∈ D, a < b → μ (Ioo a b) = ν (Ioo a b))
    (hmass : μ univ = ν univ) : μ = ν := by
  refine ext_of_generate_finite
    {S : Set ℝ | ∃ a ∈ D, ∃ b ∈ D, a < b ∧ Ico a b = S}
    hD.borel_eq_generateFrom_Ico_mem (isPiSystem_Ico_mem D D) ?_ hmass
  rintro S ⟨a, ha, b, hb, hab, rfl⟩
  have hμ := measure_congr (Ioo_ae_eq_Ico' (b := b) (hzero a ha).1)
  have hν := measure_congr (Ioo_ae_eq_Ico' (b := b) (hzero a ha).2)
  exact hμ.symm.trans ((hint a ha b hb hab).trans hν)



/-- This caller uses only the pre-E468 public inversion interval result. -/
theorem historical_H1_composition (μ ν : Measure ℝ) [IsFiniteMeasure μ]
    [IsFiniteMeasure ν]
    (h : ∀ t : ℝ, characteristicFunction μ t = characteristicFunction ν t) : μ = ν := by
  let D : Set ℝ := (measureAtoms μ ∪ measureAtoms ν)ᶜ
  apply dense_interval_measure_eq μ ν D (dense_common_nonatom_endpoints μ ν)
  · intro a ha
    exact ⟨not_ne_iff.mp (fun haμ => ha (Or.inl haμ)),
      not_ne_iff.mp (fun haν => ha (Or.inr haν))⟩
  · intro a ha b hb hab
    have hr := inversion_interval_eq_of_charFun_eq μ ν h hab
      (fun haμ => ha (Or.inl haμ)) (fun hbμ => hb (Or.inl hbμ))
      (fun haν => ha (Or.inr haν)) (fun hbν => hb (Or.inr hbν))
    exact (ENNReal.toReal_eq_toReal_iff' (measure_ne_top μ _) (measure_ne_top ν _)).mp hr
  · have h0 := h 0
    simp only [characteristicFunction, charFun_zero] at h0
    apply (ENNReal.toReal_eq_toReal_iff' (measure_ne_top μ _) (measure_ne_top ν _)).mp
    simpa [Measure.real] using h0

#print axioms historical_H1_composition
