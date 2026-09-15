import ProbabilityTheory.chapter_07.prob_7_6
open Filter MeasureTheory
open scoped Topology
noncomputable section

-- Caller check: general order-limit and measurability facts discharge redundant parameters.
theorem check_scheffe {α : Type*} [MeasurableSpace α] {μ : Measure α}
    {fn : ℕ → α → ℝ} {f : α → ℝ}
    (hm : ∀ n, AEStronglyMeasurable (fn n) μ)
    (hn : ∀ n, 0 ≤ᵐ[μ] fn n)
    (hl : ∀ᵐ x ∂μ, Tendsto (fun n => fn n x) atTop (𝓝 (f x)))
    (hi : Integrable f μ) (he : ∀ᶠ n in atTop, Integrable (fn n) μ)
    (ht : Tendsto (fun n => ∫ x, fn n x ∂μ) atTop (𝓝 (∫ x, f x ∂μ))) :
    Tendsto (fun n => ∫ x, |fn n x - f x| ∂μ) atTop (𝓝 0) := by
  have hf : 0 ≤ᵐ[μ] f := by
    filter_upwards [ae_all_iff.2 hn, hl] with x hx hlim
    exact ge_of_tendsto' hlim hx
  exact Scheffe.tendsto_integral_abs_sub_of_eventually_integrable
    hm hi.aestronglyMeasurable hn hf hl hi he ht

#print axioms check_scheffe
