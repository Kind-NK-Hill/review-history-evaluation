import Mathlib

open MeasureTheory Set

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

#print axioms dense_interval_measure_eq
