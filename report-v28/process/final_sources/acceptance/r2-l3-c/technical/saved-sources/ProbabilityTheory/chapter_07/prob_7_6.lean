import Mathlib
open Filter MeasureTheory
open scoped Topology
noncomputable section
namespace Scheffe
variable {α : Type*} [MeasurableSpace α] {μ : Measure α}
def negativePart (fn : ℕ → α → ℝ) (f : α → ℝ) (n : ℕ) (x : α) : ℝ := max (f x - fn n x) 0
theorem negativePart_le {fn : ℕ → α → ℝ} {f : α → ℝ}
    (hfn_nonneg : ∀ n, 0 ≤ᵐ[μ] fn n) (hf_nonneg : 0 ≤ᵐ[μ] f) (n : ℕ) :
    negativePart fn f n ≤ᵐ[μ] f := by
  filter_upwards [hfn_nonneg n, hf_nonneg] with x hnx hx
  exact max_le (sub_le_self _ hnx) hx
theorem negativePart_tendsto_ae {fn : ℕ → α → ℝ} {f : α → ℝ}
    (hfn_lim : ∀ᵐ x ∂μ, Tendsto (fun n => fn n x) atTop (𝓝 (f x))) :
    ∀ᵐ x ∂μ, Tendsto (fun n => negativePart fn f n x) atTop (𝓝 0) := by
  filter_upwards [hfn_lim] with x hx
  have hsub : Tendsto (fun n => f x - fn n x) atTop (𝓝 0) := by
    have hc : Tendsto (fun _ : ℕ => f x) atTop (𝓝 (f x)) := tendsto_const_nhds
    simpa using hc.sub hx
  have hz : Tendsto (fun _ : ℕ => (0 : ℝ)) atTop (𝓝 0) := tendsto_const_nhds
  simpa [negativePart] using hsub.max hz
theorem tendsto_integral_negativePart {fn : ℕ → α → ℝ} {f : α → ℝ}
    (hfn_meas : ∀ n, AEStronglyMeasurable (fn n) μ) (hf_meas : AEStronglyMeasurable f μ)
    (hfn_nonneg : ∀ n, 0 ≤ᵐ[μ] fn n) (hf_nonneg : 0 ≤ᵐ[μ] f)
    (hfn_lim : ∀ᵐ x ∂μ, Tendsto (fun n => fn n x) atTop (𝓝 (f x))) (hf_int : Integrable f μ) :
    Tendsto (fun n => ∫ x, negativePart fn f n x ∂μ) atTop (𝓝 0) := by
  have hmeas (n : ℕ) : AEStronglyMeasurable (negativePart fn f n) μ :=
    (hf_meas.sub (hfn_meas n)).sup aestronglyMeasurable_const
  have hnorm (n : ℕ) : ∀ᵐ x ∂μ, ‖negativePart fn f n x‖ ≤ f x := by
    filter_upwards [negativePart_le hfn_nonneg hf_nonneg n] with x hx
    have hzero : 0 ≤ negativePart fn f n x := le_max_right _ _
    simpa [Real.norm_eq_abs, abs_of_nonneg hzero] using hx
  simpa using tendsto_integral_of_dominated_convergence f hmeas hf_int hnorm
    (negativePart_tendsto_ae hfn_lim)
theorem abs_sub_eq_sub_add_two_negativePart (fn : ℕ → α → ℝ) (f : α → ℝ) (n : ℕ) (x : α) :
    |fn n x - f x| = (fn n x - f x) + 2 * negativePart fn f n x := by
  simp only [negativePart]
  by_cases h : 0 ≤ fn n x - f x
  · rw [abs_of_nonneg h, max_eq_right (by linarith)]
    ring
  · have h' : fn n x - f x < 0 := lt_of_not_ge h
    rw [abs_of_neg h', max_eq_left]
    · ring
    · linarith
theorem tendsto_integral_abs_sub_of_eventually_integrable {fn : ℕ → α → ℝ} {f : α → ℝ}
    (hfn_meas : ∀ n, AEStronglyMeasurable (fn n) μ) (hf_meas : AEStronglyMeasurable f μ)
    (hfn_nonneg : ∀ n, 0 ≤ᵐ[μ] fn n) (hf_nonneg : 0 ≤ᵐ[μ] f)
    (hfn_lim : ∀ᵐ x ∂μ, Tendsto (fun n => fn n x) atTop (𝓝 (f x)))
    (hf_int : Integrable f μ) (hfn_int : ∀ᶠ n in atTop, Integrable (fn n) μ)
    (hint : Tendsto (fun n => ∫ x, fn n x ∂μ) atTop (𝓝 (∫ x, f x ∂μ))) :
    Tendsto (fun n => ∫ x, |fn n x - f x| ∂μ) atTop (𝓝 0) := by
  have hneg := tendsto_integral_negativePart hfn_meas hf_meas hfn_nonneg hf_nonneg hfn_lim hf_int
  have hdiff : Tendsto (fun n => (∫ x, fn n x ∂μ) - ∫ x, f x ∂μ) atTop (𝓝 0) := by
    have hc : Tendsto (fun _ : ℕ => ∫ x, f x ∂μ) atTop (𝓝 (∫ x, f x ∂μ)) := tendsto_const_nhds
    simpa using hint.sub hc
  have hsum : Tendsto (fun n => ((∫ x, fn n x ∂μ) - ∫ x, f x ∂μ) +
      2 * ∫ x, negativePart fn f n x ∂μ) atTop (𝓝 0) := by
    simpa using hdiff.add (hneg.const_mul 2)
  apply hsum.congr'
  filter_upwards [hfn_int] with n hn
  have hneg_int : Integrable (negativePart fn f n) μ := by
    refine Integrable.mono' hf_int ((hf_meas.sub (hfn_meas n)).sup aestronglyMeasurable_const) ?_
    filter_upwards [negativePart_le hfn_nonneg hf_nonneg n] with x hx
    have hzero : 0 ≤ negativePart fn f n x := le_max_right _ _
    have hfx : 0 ≤ f x := hzero.trans hx
    simpa [Real.norm_eq_abs, abs_of_nonneg hzero, abs_of_nonneg hfx] using hx
  symm
  calc
    ∫ x, |fn n x - f x| ∂μ = ∫ x, ((fn n x - f x) + 2 * negativePart fn f n x) ∂μ := by
      exact integral_congr_ae (Filter.Eventually.of_forall (abs_sub_eq_sub_add_two_negativePart fn f n))
    _ = (∫ x, fn n x ∂μ) - ∫ x, f x ∂μ + 2 * ∫ x, negativePart fn f n x ∂μ := by
      have hadd := integral_add (hn.sub hf_int) (hneg_int.const_mul 2)
      simp only [Pi.sub_apply] at hadd
      rw [integral_sub hn hf_int, integral_const_mul] at hadd
      simpa only [Pi.sub_apply, Pi.smul_apply, smul_eq_mul] using hadd
end Scheffe
