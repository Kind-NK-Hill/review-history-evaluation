import Mathlib

/-! # Scheffé's lemma -/

open Filter MeasureTheory
open scoped Topology

noncomputable section

/-- The negative part of `f n - f` used in the textbook proof. -/
def scheffeNegPart {α : Type*} (fn : ℕ → α → ℝ) (f : α → ℝ)
    (n : ℕ) (x : α) : ℝ := max (f x - fn n x) 0

/-- Part (a): the negative parts tend to zero in integral.  Only a tail of the
approximating sequence is required to be integrable. -/
theorem scheffe_negPart_integral_tendsto
    {α : Type*} [MeasurableSpace α] (μ : Measure α)
    (fn : ℕ → α → ℝ) (f : α → ℝ)
    (hfn_meas : ∀ n, AEStronglyMeasurable (fn n) μ)
    (hf_meas : AEStronglyMeasurable f μ)
    (hfn_nonneg : ∀ n, 0 ≤ᵐ[μ] fn n)
    (hf_nonneg : 0 ≤ᵐ[μ] f)
    (_hfn_int : ∀ᶠ n in atTop, Integrable (fn n) μ)
    (hf_int : Integrable f μ)
    (h_ae : ∀ᵐ x ∂μ, Tendsto (fun n => fn n x) atTop (𝓝 (f x))) :
    Tendsto (fun n => ∫ x, scheffeNegPart fn f n x ∂μ)
      atTop (𝓝 0) := by
  have hmeas : ∀ n, AEStronglyMeasurable (scheffeNegPart fn f n) μ := by
    intro n
    exact ((hf_meas.sub (hfn_meas n)).aemeasurable.max aemeasurable_const).aestronglyMeasurable
  have hbound : ∀ n, ∀ᵐ x ∂μ, ‖scheffeNegPart fn f n x‖ ≤ f x := by
    intro n
    filter_upwards [hfn_nonneg n, hf_nonneg] with x hnx hfx
    have hnx0 : 0 ≤ fn n x := by simpa using hnx
    have hfx0 : 0 ≤ f x := by simpa using hfx
    rw [scheffeNegPart, Real.norm_eq_abs, abs_of_nonneg (le_max_right _ _)]
    exact max_le (sub_le_self _ hnx0) hfx0
  have hlim : ∀ᵐ x ∂μ,
      Tendsto (fun n => scheffeNegPart fn f n x) atTop (𝓝 0) := by
    filter_upwards [h_ae] with x hx
    have hc : Tendsto (fun _ : ℕ => f x) atTop (𝓝 (f x)) := tendsto_const_nhds
    have hz : Tendsto (fun _ : ℕ => (0 : ℝ)) atTop (𝓝 0) := tendsto_const_nhds
    simpa [scheffeNegPart] using (hc.sub hx).max hz
  simpa using tendsto_integral_of_dominated_convergence f hmeas hf_int hbound hlim

/-- Scheffé's lemma with eventual integrability: finitely many initial terms may
be nonintegrable, while the conclusion concerns the original sequence. -/
theorem scheffe_lemma_eventually_integrable
    {α : Type*} [MeasurableSpace α] (μ : Measure α)
    (fn : ℕ → α → ℝ) (f : α → ℝ)
    (hfn_meas : ∀ n, AEStronglyMeasurable (fn n) μ)
    (hf_meas : AEStronglyMeasurable f μ)
    (hfn_nonneg : ∀ n, 0 ≤ᵐ[μ] fn n)
    (hf_nonneg : 0 ≤ᵐ[μ] f)
    (hfn_int : ∀ᶠ n in atTop, Integrable (fn n) μ)
    (hf_int : Integrable f μ)
    (h_ae : ∀ᵐ x ∂μ, Tendsto (fun n => fn n x) atTop (𝓝 (f x)))
    (h_integral : Tendsto (fun n => ∫ x, fn n x ∂μ) atTop (𝓝 (∫ x, f x ∂μ))) :
    Tendsto (fun n => ∫ x, |fn n x - f x| ∂μ) atTop (𝓝 0) := by
  have hneg := scheffe_negPart_integral_tendsto μ fn f hfn_meas hf_meas
    hfn_nonneg hf_nonneg hfn_int hf_int h_ae
  have hid : ∀ᶠ n in atTop,
      (∫ x, |fn n x - f x| ∂μ) =
        (∫ x, fn n x ∂μ) - (∫ x, f x ∂μ) +
          2 * ∫ x, scheffeNegPart fn f n x ∂μ := by
    filter_upwards [hfn_int] with n hn
    have hneg_int : Integrable (scheffeNegPart fn f n) μ := by
      refine Integrable.mono hf_int
        (((hf_meas.sub (hfn_meas n)).aemeasurable.max (aemeasurable_const : AEMeasurable (fun _ : α => (0 : ℝ)) μ)).aestronglyMeasurable) ?_
      filter_upwards [hfn_nonneg n, hf_nonneg] with x hnx hfx
      have hnx0 : 0 ≤ fn n x := by simpa using hnx
      have hfx0 : 0 ≤ f x := by simpa using hfx
      simpa [scheffeNegPart, Real.norm_eq_abs, abs_of_nonneg hfx0,
        abs_of_nonneg (le_max_right (f x - fn n x) 0)] using
          max_le (sub_le_self _ hnx0) hfx0
    have hpoint : (fun x => |fn n x - f x|) =
        fun x => (fn n x - f x) + 2 * scheffeNegPart fn f n x := by
      funext x
      rcases le_total (fn n x) (f x) with h | h
      · rw [abs_of_nonpos (sub_nonpos.mpr h)]
        simp [scheffeNegPart, max_eq_left (sub_nonneg.mpr h)]
        ring
      · rw [abs_of_nonneg (sub_nonneg.mpr h)]
        simp [scheffeNegPart, max_eq_right (sub_nonpos.mpr h)]
    calc
      (∫ x, |fn n x - f x| ∂μ) =
          ∫ x, ((fn n x - f x) + 2 * scheffeNegPart fn f n x) ∂μ := by rw [hpoint]
      _ = (∫ x, fn n x - f x ∂μ) + ∫ x, 2 * scheffeNegPart fn f n x ∂μ :=
        integral_add (hn.sub hf_int) (hneg_int.const_mul 2)
      _ = _ := by rw [integral_sub hn hf_int, integral_const_mul]
  have hbase : Tendsto
      (fun n => (∫ x, fn n x ∂μ) - (∫ x, f x ∂μ) +
        2 * ∫ x, scheffeNegPart fn f n x ∂μ) atTop (𝓝 0) := by
    convert (h_integral.sub tendsto_const_nhds).add (hneg.const_mul 2) using 1 <;> simp
  exact hbase.congr' (Filter.EventuallyEq.symm hid)
/-- Convenient all-terms-integrable specialization. -/
theorem scheffe_lemma
    {α : Type*} [MeasurableSpace α] (μ : Measure α)
    (fn : ℕ → α → ℝ) (f : α → ℝ)
    (hfn_meas : ∀ n, AEStronglyMeasurable (fn n) μ)
    (hf_meas : AEStronglyMeasurable f μ)
    (hfn_nonneg : ∀ n, 0 ≤ᵐ[μ] fn n)
    (hf_nonneg : 0 ≤ᵐ[μ] f)
    (hfn_int : ∀ n, Integrable (fn n) μ)
    (hf_int : Integrable f μ)
    (h_ae : ∀ᵐ x ∂μ, Tendsto (fun n => fn n x) atTop (𝓝 (f x)))
    (h_integral : Tendsto (fun n => ∫ x, fn n x ∂μ) atTop (𝓝 (∫ x, f x ∂μ))) :
    Tendsto (fun n => ∫ x, |fn n x - f x| ∂μ) atTop (𝓝 0) :=
  scheffe_lemma_eventually_integrable μ fn f hfn_meas hf_meas hfn_nonneg hf_nonneg
    (Filter.Eventually.of_forall hfn_int) hf_int h_ae h_integral

/-- Both conclusions of Exercise 7.6. -/
theorem prob_7_6
    {α : Type*} [MeasurableSpace α] (μ : Measure α)
    (fn : ℕ → α → ℝ) (f : α → ℝ)
    (hfn_meas : ∀ n, AEStronglyMeasurable (fn n) μ)
    (hf_meas : AEStronglyMeasurable f μ)
    (hfn_nonneg : ∀ n, 0 ≤ᵐ[μ] fn n)
    (hf_nonneg : 0 ≤ᵐ[μ] f)
    (hfn_int : ∀ᶠ n in atTop, Integrable (fn n) μ)
    (hf_int : Integrable f μ)
    (h_ae : ∀ᵐ x ∂μ, Tendsto (fun n => fn n x) atTop (𝓝 (f x)))
    (h_integral : Tendsto (fun n => ∫ x, fn n x ∂μ) atTop (𝓝 (∫ x, f x ∂μ))) :
    Tendsto (fun n => ∫ x, scheffeNegPart fn f n x ∂μ) atTop (𝓝 0) ∧
      Tendsto (fun n => ∫ x, |fn n x - f x| ∂μ) atTop (𝓝 0) :=
  ⟨scheffe_negPart_integral_tendsto μ fn f hfn_meas hf_meas hfn_nonneg hf_nonneg
      hfn_int hf_int h_ae,
    scheffe_lemma_eventually_integrable μ fn f hfn_meas hf_meas hfn_nonneg hf_nonneg
      hfn_int hf_int h_ae h_integral⟩
