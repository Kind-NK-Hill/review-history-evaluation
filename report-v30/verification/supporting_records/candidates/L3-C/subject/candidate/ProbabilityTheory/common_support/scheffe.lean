import Mathlib

/-! # Problem 7.6: Scheffé's lemma -/

open Filter MeasureTheory
open scoped Topology

noncomputable section

/-- The negative part `(g-f)⁻ = max (f-g) 0` is bounded by `f`. -/
theorem prob_7_6_negativePart_le
    {α : Type*} [MeasurableSpace α] {f g : α → ℝ}
    (hf : ∀ x, 0 ≤ f x) (hg : ∀ x, 0 ≤ g x) (x : α) :
    max (f x - g x) 0 ≤ f x := by
  exact max_le (sub_le_self _ (hg x)) (hf x)

/-- Part (a): the explicitly controlled negative part has integral tending to zero. -/
theorem prob_7_6_negativePart_integral_tendsto
    {α : Type*} [MeasurableSpace α] (μ : Measure α)
    (fn : ℕ → α → ℝ) (f : α → ℝ)
    (hfn_meas : ∀ n, Measurable (fn n))
    (hf_meas : Measurable f)
    (hfn_nonneg : ∀ n x, 0 ≤ fn n x)
    (hf_nonneg : ∀ x, 0 ≤ f x)
    (hf_int : Integrable f μ)
    (hconv : ∀ᵐ x ∂μ, Tendsto (fun n => fn n x) atTop (𝓝 (f x))) :
    Tendsto (fun n => ∫ x, max (f x - fn n x) 0 ∂μ) atTop (𝓝 0) := by
  have hmeas : ∀ n, AEStronglyMeasurable (fun x => max (f x - fn n x) 0) μ := by
    intro n
    exact ((hf_meas.sub (hfn_meas n)).max measurable_const).aestronglyMeasurable
  have hbound : ∀ n, ∀ᵐ x ∂μ, ‖max (f x - fn n x) 0‖ ≤ f x := by
    intro n
    filter_upwards [] with x
    rw [Real.norm_eq_abs, abs_of_nonneg (le_max_right _ _)]
    exact prob_7_6_negativePart_le hf_nonneg (hfn_nonneg n) x
  have hlim : ∀ᵐ x ∂μ,
      Tendsto (fun n => max (f x - fn n x) 0) atTop (𝓝 0) := by
    filter_upwards [hconv] with x hx
    have hs : Tendsto (fun n => f x - fn n x) atTop (𝓝 0) := by
      simpa using hx.const_sub (f x)
    simpa using hs.max (tendsto_const_nhds : Tendsto (fun _ : ℕ => (0 : ℝ)) atTop (𝓝 0))
  simpa using tendsto_integral_of_dominated_convergence f hmeas hf_int hbound hlim

/-- Part (b). Eventual integrability is the permitted tail condition and is not
an `L¹`-convergence assumption. -/
theorem prob_7_6_scheffe
    {α : Type*} [MeasurableSpace α] (μ : Measure α)
    (fn : ℕ → α → ℝ) (f : α → ℝ)
    (hfn_meas : ∀ n, Measurable (fn n))
    (hf_meas : Measurable f)
    (hfn_nonneg : ∀ n x, 0 ≤ fn n x)
    (hf_nonneg : ∀ x, 0 ≤ f x)
    (hf_int : Integrable f μ)
    (hfn_int : ∀ᶠ n in atTop, Integrable (fn n) μ)
    (hconv : ∀ᵐ x ∂μ, Tendsto (fun n => fn n x) atTop (𝓝 (f x)))
    (hint : Tendsto (fun n => ∫ x, fn n x ∂μ) atTop (𝓝 (∫ x, f x ∂μ))) :
    Tendsto (fun n => ∫ x, |fn n x - f x| ∂μ) atTop (𝓝 0) := by
  have hneg := prob_7_6_negativePart_integral_tendsto μ fn f hfn_meas hf_meas
    hfn_nonneg hf_nonneg hf_int hconv
  have halgebra : ∀ᶠ n in atTop,
      (∫ x, |fn n x - f x| ∂μ) =
        (∫ x, fn n x ∂μ) - (∫ x, f x ∂μ) +
          2 * ∫ x, max (f x - fn n x) 0 ∂μ := by
    filter_upwards [hfn_int] with n hn
    have hdiff : Integrable (fun x => fn n x - f x) μ := hn.sub hf_int
    have hneg_int : Integrable (fun x => max (f x - fn n x) 0) μ := by
      refine Integrable.mono hf_int ?_ ?_
      · exact ((hf_meas.sub (hfn_meas n)).max measurable_const).aestronglyMeasurable
      · filter_upwards [] with x
        rw [Real.norm_eq_abs, abs_of_nonneg (le_max_right _ _), Real.norm_eq_abs,
          abs_of_nonneg (hf_nonneg x)]
        exact prob_7_6_negativePart_le hf_nonneg (hfn_nonneg n) x
    calc
      (∫ x, |fn n x - f x| ∂μ) =
          ∫ x, ((fn n x - f x) + 2 * max (f x - fn n x) 0) ∂μ := by
            refine integral_congr_ae (ae_of_all _ fun x => ?_)
            dsimp
            by_cases h : 0 ≤ fn n x - f x
            · rw [abs_of_nonneg h, max_eq_right (by linarith)]
              ring
            · rw [abs_of_neg (lt_of_not_ge h), max_eq_left (by linarith)]
              ring
      _ = (∫ x, (fn n x - f x) ∂μ) +
            ∫ x, 2 * max (f x - fn n x) 0 ∂μ := by
            rw [integral_add hdiff (hneg_int.const_mul 2)]
      _ = (∫ x, fn n x ∂μ) - (∫ x, f x ∂μ) +
            2 * ∫ x, max (f x - fn n x) 0 ∂μ := by
            rw [integral_sub hn hf_int, integral_const_mul]
  have hright : Tendsto
      (fun n => (∫ x, fn n x ∂μ) - (∫ x, f x ∂μ) +
        2 * ∫ x, max (f x - fn n x) 0 ∂μ) atTop (𝓝 0) := by
    convert (hint.sub tendsto_const_nhds).add (hneg.const_mul 2) using 1 <;> ring
  apply hright.congr'
  filter_upwards [halgebra] with n hn
  exact hn.symm
