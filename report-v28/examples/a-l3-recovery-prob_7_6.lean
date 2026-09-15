import Mathlib

/-
TASK ID: prob_7_6
TYPE: Problem
SOURCE PLAN: experiment_targets
TASK CONTENT:
\textbf{7.6 (Scheff\'e Lemma).} Suppose $f_n$'s are nonnegative measurable functions that converge to $f$ almost everywhere as $n\to\infty$. Assume that $\int f_n\, d\mu \to \int f\, d\mu < \infty$.
\begin{enumerate}[label=(\alph*)]
    \item Show that $(f_k-f)^-$ is bounded by $f$, and hence, by the dominated convergence theorem, $\int (f_n-f)^- \to 0$.
    \item Show that $\int |f_n-f|\to 0$. (Hint: Write $|f_n-f|$ as $(f_n-f)+2(f_n-f)^-$.)
\end{enumerate}
-/

-- WRITE FINAL LEAN CODE BELOW

open Filter MeasureTheory
open scoped Topology

namespace ProbabilityTheory

theorem prob_7_6_negPart_le
    {α : Type*} [MeasurableSpace α] {μ : Measure α} {f g : α → ℝ}
    (hf_nonneg : ∀ᵐ x ∂μ, 0 ≤ f x) (hg_nonneg : ∀ᵐ x ∂μ, 0 ≤ g x) :
    ∀ᵐ x ∂μ, max (f x - g x) 0 ≤ f x := by
  filter_upwards [hf_nonneg, hg_nonneg] with x hfx hgx
  exact max_le (sub_le_self _ hgx) hfx

theorem prob_7_6_negPart_integral_tendsto_zero
    {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (fseq : ℕ → α → ℝ) (f : α → ℝ)
    (hfseq_meas : ∀ n, AEStronglyMeasurable (fseq n) μ)
    (hf_meas : AEStronglyMeasurable f μ)
    (hfseq_nonneg : ∀ n, ∀ᵐ x ∂μ, 0 ≤ fseq n x)
    (hf_nonneg : ∀ᵐ x ∂μ, 0 ≤ f x)
    (hf_integrable : Integrable f μ)
    (h_ae : ∀ᵐ x ∂μ, Tendsto (fun n => fseq n x) atTop (𝓝 (f x))) :
    Tendsto (fun n => ∫ x, max (f x - fseq n x) 0 ∂μ) atTop (𝓝 0) := by
  have hmeas : ∀ n, AEStronglyMeasurable (fun x => max (f x - fseq n x) 0) μ := by
    intro n
    fun_prop
  have hbound : ∀ n, ∀ᵐ x ∂μ, ‖max (f x - fseq n x) 0‖ ≤ f x := by
    intro n
    filter_upwards [prob_7_6_negPart_le hf_nonneg (hfseq_nonneg n)] with x hx
    rw [Real.norm_eq_abs, abs_of_nonneg (le_max_right _ _)]
    exact hx
  have hlim : ∀ᵐ x ∂μ,
      Tendsto (fun n => max (f x - fseq n x) 0) atTop (𝓝 0) := by
    filter_upwards [h_ae] with x hx
    have hc : Continuous (fun y : ℝ => max (f x - y) 0) :=
      (continuous_const.sub continuous_id).max continuous_const
    change Tendsto ((fun y : ℝ => max (f x - y) 0) ∘ fun n => fseq n x) atTop (𝓝 0)
    simpa using hc.continuousAt.tendsto.comp hx
  simpa using tendsto_integral_of_dominated_convergence f hmeas hf_integrable hbound hlim

theorem prob_7_6
    {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (fseq : ℕ → α → ℝ) (f : α → ℝ)
    (hfseq_meas : ∀ n, AEStronglyMeasurable (fseq n) μ)
    (hf_meas : AEStronglyMeasurable f μ)
    (hfseq_nonneg : ∀ n, ∀ᵐ x ∂μ, 0 ≤ fseq n x)
    (hf_nonneg : ∀ᵐ x ∂μ, 0 ≤ f x)
    (hf_integrable : Integrable f μ)
    (hfseq_eventually_integrable : ∀ᶠ n in atTop, Integrable (fseq n) μ)
    (h_ae : ∀ᵐ x ∂μ, Tendsto (fun n => fseq n x) atTop (𝓝 (f x)))
    (h_integral : Tendsto (fun n => ∫ x, fseq n x ∂μ) atTop (𝓝 (∫ x, f x ∂μ))) :
    Tendsto (fun n => ∫ x, |fseq n x - f x| ∂μ) atTop (𝓝 0) := by
  have hneg := prob_7_6_negPart_integral_tendsto_zero fseq f hfseq_meas hf_meas
    hfseq_nonneg hf_nonneg hf_integrable h_ae
  have hformula : ∀ᶠ n in atTop,
      (∫ x, |fseq n x - f x| ∂μ) =
        (∫ x, fseq n x ∂μ) - (∫ x, f x ∂μ) +
          2 * ∫ x, max (f x - fseq n x) 0 ∂μ := by
    filter_upwards [hfseq_eventually_integrable] with n hn
    have hpoint : ∀ᵐ x ∂μ,
        |fseq n x - f x| =
          (fseq n x - f x) + 2 * max (f x - fseq n x) 0 := by
      filter_upwards [hfseq_nonneg n, hf_nonneg] with x _ _
      by_cases h : f x ≤ fseq n x
      · rw [abs_of_nonneg (sub_nonneg.mpr h), max_eq_right (sub_nonpos.mpr h)]
        ring
      · have h' : fseq n x ≤ f x := le_of_not_ge h
        rw [abs_of_nonpos (sub_nonpos.mpr h'), max_eq_left (sub_nonneg.mpr h')]
        ring
    have hdiff_int : Integrable (fun x => fseq n x - f x) μ := hn.sub hf_integrable
    have hneg_int : Integrable (fun x => max (f x - fseq n x) 0) μ :=
      (hf_integrable.sub hn).pos_part
    rw [integral_congr_ae hpoint, integral_add hdiff_int (hneg_int.const_mul 2),
      integral_sub hn hf_integrable, integral_const_mul]
  have hright : Tendsto
      (fun n => (∫ x, fseq n x ∂μ) - (∫ x, f x ∂μ) +
        2 * ∫ x, max (f x - fseq n x) 0 ∂μ) atTop (𝓝 0) := by
    convert (h_integral.sub tendsto_const_nhds).add (tendsto_const_nhds.mul hneg) using 1 <;>
      ring
  rw [tendsto_congr' hformula]
  exact hright

theorem prob_7_6_of_integrable
    {α : Type*} [MeasurableSpace α] {μ : Measure α}
    (fseq : ℕ → α → ℝ) (f : α → ℝ)
    (hfseq_meas : ∀ n, AEStronglyMeasurable (fseq n) μ)
    (hf_meas : AEStronglyMeasurable f μ)
    (hfseq_nonneg : ∀ n, ∀ᵐ x ∂μ, 0 ≤ fseq n x)
    (hf_nonneg : ∀ᵐ x ∂μ, 0 ≤ f x)
    (hfseq_integrable : ∀ n, Integrable (fseq n) μ)
    (hf_integrable : Integrable f μ)
    (h_ae : ∀ᵐ x ∂μ, Tendsto (fun n => fseq n x) atTop (𝓝 (f x)))
    (h_integral : Tendsto (fun n => ∫ x, fseq n x ∂μ) atTop (𝓝 (∫ x, f x ∂μ))) :
    Tendsto (fun n => ∫ x, |fseq n x - f x| ∂μ) atTop (𝓝 0) :=
  prob_7_6 fseq f hfseq_meas hf_meas hfseq_nonneg hf_nonneg hf_integrable
    (Filter.Eventually.of_forall hfseq_integrable) h_ae h_integral

end ProbabilityTheory
