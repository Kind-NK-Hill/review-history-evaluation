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

open Filter MeasureTheory Topology

noncomputable section

variable {α : Type*} [MeasurableSpace α] {μ : Measure α}

/-- The negative part of `u - v`, in elementary real-valued form. -/
def prob_7_6_negPart (u v : α → ℝ) (x : α) : ℝ := max (v x - u x) 0

/-- The pointwise estimate used in part (a). Its hypotheses are facts at the
current point, not extra assumptions on the limit function. -/
lemma prob_7_6_negPart_le (u v : α → ℝ) (x : α)
    (hu : 0 ≤ u x) (hv : 0 ≤ v x) :
    prob_7_6_negPart u v x ≤ v x := by
  simp only [prob_7_6_negPart, max_le_iff]
  exact ⟨sub_le_self _ hu, hv⟩

/-- Part (a): the limit is first proved nonnegative almost everywhere; then
dominated convergence sends the negative-part integrals to zero. -/
theorem prob_7_6_negPart_integral_tendsto
    (f : ℕ → α → ℝ) (g : α → ℝ)
    (hf_meas : ∀ n, Measurable (f n))
    (hf_nonneg : ∀ n x, 0 ≤ f n x)
    (hg_int : Integrable g μ)
    (hfg : ∀ᵐ x ∂μ, Tendsto (fun n => f n x) atTop (𝓝 (g x))) :
    Tendsto (fun n => ∫ x, prob_7_6_negPart (f n) g x ∂μ) atTop (𝓝 0) := by
  have hg_nonneg_ae : ∀ᵐ x ∂μ, 0 ≤ g x := by
    filter_upwards [hfg] with x hx
    exact ge_of_tendsto' hx (fun n => hf_nonneg n x)
  have hneg_meas : ∀ n,
      AEStronglyMeasurable (fun x => prob_7_6_negPart (f n) g x) μ := by
    intro n
    change AEStronglyMeasurable ((g - f n) ⊔ fun _ => 0) μ
    exact
      (hg_int.aestronglyMeasurable.sub (hf_meas n).aestronglyMeasurable).sup
        aestronglyMeasurable_const
  have hDCT := tendsto_integral_of_dominated_convergence (μ := μ) g
    hneg_meas hg_int
    (fun n => by
      filter_upwards [hg_nonneg_ae] with x hgx
      rw [Real.norm_eq_abs, abs_of_nonneg (le_max_right _ _)]
      exact prob_7_6_negPart_le (f n) g x (hf_nonneg n x) hgx)
    (by
      filter_upwards [hfg] with x hx
      simpa [prob_7_6_negPart] using
        (tendsto_const_nhds.sub hx).max
          (tendsto_const_nhds : Tendsto (fun _ : ℕ => (0 : ℝ)) atTop (𝓝 0)))
  simpa [prob_7_6_negPart] using hDCT

/-- Scheffé's lemma. Integrability expresses the source's finite-integral
condition; no L1 convergence, nonnegativity of the limit, or measurability of
the limit is assumed. The latter two AE facts are derived internally. -/
theorem prob_7_6
    (f : ℕ → α → ℝ) (g : α → ℝ)
    (hf_meas : ∀ n, Measurable (f n))
    (hf_nonneg : ∀ n x, 0 ≤ f n x)
    (hf_int : ∀ n, Integrable (f n) μ) (hg_int : Integrable g μ)
    (hfg : ∀ᵐ x ∂μ, Tendsto (fun n => f n x) atTop (𝓝 (g x)))
    (hint : Tendsto (fun n => ∫ x, f n x ∂μ) atTop (𝓝 (∫ x, g x ∂μ))) :
    Tendsto (fun n => ∫ x, |f n x - g x| ∂μ) atTop (𝓝 0) := by
  have hg_nonneg_ae : ∀ᵐ x ∂μ, 0 ≤ g x := by
    filter_upwards [hfg] with x hx
    exact ge_of_tendsto' hx (fun n => hf_nonneg n x)
  have hneg := prob_7_6_negPart_integral_tendsto f g hf_meas
    hf_nonneg hg_int hfg
  have heq : (fun n => ∫ x, |f n x - g x| ∂μ) =
      fun n => (∫ x, f n x ∂μ) - (∫ x, g x ∂μ) +
        2 * ∫ x, prob_7_6_negPart (f n) g x ∂μ := by
    funext n
    have hneg_meas :
        AEStronglyMeasurable (fun x => prob_7_6_negPart (f n) g x) μ := by
      change AEStronglyMeasurable ((g - f n) ⊔ fun _ => 0) μ
      exact
        (hg_int.aestronglyMeasurable.sub (hf_meas n).aestronglyMeasurable).sup
          aestronglyMeasurable_const
    have hneg_int : Integrable (fun x => prob_7_6_negPart (f n) g x) μ :=
      hg_int.mono' hneg_meas (by
        filter_upwards [hg_nonneg_ae] with x hgx
        rw [Real.norm_eq_abs, abs_of_nonneg (le_max_right _ _)]
        exact prob_7_6_negPart_le (f n) g x (hf_nonneg n x) hgx)
    calc
      (∫ x, |f n x - g x| ∂μ) =
          ∫ x, (f n x - g x) + 2 * prob_7_6_negPart (f n) g x ∂μ := by
        apply integral_congr_ae
        filter_upwards with x
        dsimp [prob_7_6_negPart]
        by_cases h : g x ≤ f n x
        · rw [max_eq_right]
          · simp [abs_of_nonneg (sub_nonneg.mpr h)]
          · exact sub_nonpos.mpr h
        · rw [max_eq_left]
          · simp [abs_of_nonpos (sub_nonpos.mpr (le_of_not_ge h))]
            ring
          · exact sub_nonneg.mpr (le_of_not_ge h)
      _ = (∫ x, f n x - g x ∂μ) +
          ∫ x, 2 * prob_7_6_negPart (f n) g x ∂μ :=
        integral_add ((hf_int n).sub hg_int) (hneg_int.const_mul 2)
      _ = (∫ x, f n x ∂μ) - (∫ x, g x ∂μ) +
          2 * ∫ x, prob_7_6_negPart (f n) g x ∂μ := by
        rw [integral_sub (hf_int n) hg_int, integral_const_mul]
  rw [heq]
  convert (hint.sub tendsto_const_nhds).add
    (tendsto_const_nhds.mul hneg) using 1 <;> ring
