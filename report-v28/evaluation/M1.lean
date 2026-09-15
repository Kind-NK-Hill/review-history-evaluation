import ProbabilityTheory.chapter_13.thm_13_18
open Filter MeasureTheory
open scoped Topology
noncomputable section

-- Caller check: assemble the supplied representation and expectation results.
theorem check_optional_stopping {Ω : Type*} [𝓕 : MeasurableSpace Ω]
    {P : Measure Ω} {𝓕n : ℕ → MeasurableSpace Ω} {X : ℕ → Ω → ℝ}
    {T : Ω → WithTop ℕ} (hM : def_13_7 P 𝓕n X) (hT : def_13_8 𝓕n T)
    (hc : (∃ C : ℕ, ∀ᵐ ω ∂P, T ω ≤ (C : WithTop ℕ)) ∨
      (∃ K : ℝ, (∀ᵐ ω ∂P, T ω ≠ ⊤) ∧ ∀ n, ∀ᵐ ω ∂P, |X n ω| ≤ K) ∨
      (∃ c : ℝ, thm_13_18_expectedTimeFinite P T ∧
        ∀ n, ∀ᵐ ω ∂P, |X (n + 1) ω - X n ω| ≤ c)) :
    ∃ Z : Ω → ℝ, thm_13_18_isStoppedValue P X T Z ∧
      (∫ ω, Z ω ∂P) = ∫ ω, X 0 ω ∂P := by
  have hfinite : ∀ᵐ ω ∂P, T ω ≠ ⊤ := by
    rcases hc with ⟨C, hC⟩ | ⟨K, hf, hb⟩ | ⟨c, hET, hi⟩
    · filter_upwards [hC] with ω hω ht
      simpa [ht] using hω
    · exact hf
    · have hm : Measurable (fun ω => thm_13_18_timeENN (T ω)) :=
        (measurable_of_countable thm_13_18_timeENN).comp (def_13_8_measurable hT)
      filter_upwards [ae_lt_top hm hET] with ω hω ht
      simp [ht, thm_13_18_timeENN] at hω
  obtain ⟨Z, hZ⟩ := thm_13_18_exists_stoppedValue X T hfinite
  exact ⟨Z, hZ, thm_13_18 hM hT hZ hc⟩

#print axioms check_optional_stopping
