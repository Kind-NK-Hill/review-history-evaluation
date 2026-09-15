import Mathlib
open Filter MeasureTheory
open scoped Topology

noncomputable section

/-- The negative part of `f n - f`, written in the form used in Scheffé's lemma. -/
def prob_7_6_negPart {α : Type*} (fseq : ℕ → α → ℝ) (f : α → ℝ)
    (n : ℕ) (x : α) : ℝ :=
  max (f x - fseq n x) 0

/-- Nonnegativity of `f_n` makes the negative part of `f_n-f` bounded by `f`. -/
theorem prob_7_6_negPart_le {α : Type*} {fseq : ℕ → α → ℝ} {f : α → ℝ}
    (hfseq_nonneg : ∀ n x, 0 ≤ fseq n x) (hf_nonneg : ∀ x, 0 ≤ f x) :
    ∀ n x, ‖prob_7_6_negPart fseq f n x‖ ≤ f x := by
  intro n x
  rw [Real.norm_eq_abs, abs_of_nonneg (le_max_right _ _)]
  exact max_le (sub_le_self _ (hfseq_nonneg n x)) (hf_nonneg x)

/-- Part (a), including the dominated-convergence conclusion for negative parts. -/
theorem prob_7_6_negPart_integral_tendsto
    {α : Type*} [MeasurableSpace α] (μ : Measure α)
    {fseq : ℕ → α → ℝ} {f : α → ℝ}
    (hfseq_meas : ∀ n, Measurable (fseq n)) (hf_meas : Measurable f)
    (hfseq_nonneg : ∀ n x, 0 ≤ fseq n x) (hf_nonneg : ∀ x, 0 ≤ f x)
    (hf_int : Integrable f μ)
    (hconv : ∀ᵐ x ∂μ, Tendsto (fun n => fseq n x) atTop (𝓝 (f x))) :
    Tendsto (fun n => ∫ x, prob_7_6_negPart fseq f n x ∂μ)
      atTop (𝓝 0) := by
  have hmeas : ∀ n, AEStronglyMeasurable (prob_7_6_negPart fseq f n) μ := by
    intro n
    exact ((hf_meas.sub (hfseq_meas n)).max measurable_const).aestronglyMeasurable
  have hbound : ∀ n, ∀ᵐ x ∂μ, ‖prob_7_6_negPart fseq f n x‖ ≤ f x := by
    intro n
    exact Filter.Eventually.of_forall (prob_7_6_negPart_le hfseq_nonneg hf_nonneg n)
  have hlim : ∀ᵐ x ∂μ,
      Tendsto (fun n => prob_7_6_negPart fseq f n x) atTop (𝓝 0) := by
    filter_upwards [hconv] with x hx
    simpa [prob_7_6_negPart] using
      ((tendsto_const_nhds :
        Tendsto (fun _ : ℕ => f x) atTop (𝓝 (f x))).sub hx).max (tendsto_const_nhds :
        Tendsto (fun _ : ℕ => (0 : ℝ)) atTop (𝓝 0))
  simpa using
    (tendsto_integral_of_dominated_convergence f hmeas hf_int hbound hlim)

private lemma prob_7_6_abs_sub_identity (a b : ℝ) :
    |a - b| = (a - b) + 2 * max (b - a) 0 := by
  by_cases h : b ≤ a
  · rw [abs_of_nonneg (sub_nonneg.mpr h), max_eq_right (sub_nonpos.mpr h)]
    ring
  · have h' : a < b := lt_of_not_ge h
    rw [abs_of_neg (sub_neg.mpr h'), max_eq_left (sub_nonneg.mpr h'.le)]
    ring

/-- Scheffé's lemma. The integrability hypotheses encode the finite-integral
assumptions; no `L¹` convergence is assumed. -/
theorem prob_7_6
    {α : Type*} [MeasurableSpace α] (μ : Measure α)
    {fseq : ℕ → α → ℝ} {f : α → ℝ}
    (hfseq_meas : ∀ n, Measurable (fseq n)) (hf_meas : Measurable f)
    (hfseq_nonneg : ∀ n x, 0 ≤ fseq n x) (hf_nonneg : ∀ x, 0 ≤ f x)
    (hfseq_int : ∀ n, Integrable (fseq n) μ) (hf_int : Integrable f μ)
    (hconv : ∀ᵐ x ∂μ, Tendsto (fun n => fseq n x) atTop (𝓝 (f x)))
    (hintegral : Tendsto (fun n => ∫ x, fseq n x ∂μ) atTop (𝓝 (∫ x, f x ∂μ))) :
    Tendsto (fun n => ∫ x, |fseq n x - f x| ∂μ) atTop (𝓝 0) := by
  have hneg := prob_7_6_negPart_integral_tendsto μ hfseq_meas hf_meas
    hfseq_nonneg hf_nonneg hf_int hconv
  have hformula : ∀ n,
      (∫ x, |fseq n x - f x| ∂μ) =
        (∫ x, fseq n x ∂μ) - (∫ x, f x ∂μ) +
          2 * ∫ x, prob_7_6_negPart fseq f n x ∂μ := by
    intro n
    have hneg_int : Integrable (prob_7_6_negPart fseq f n) μ := by
      apply hf_int.mono'
      · exact ((hf_meas.sub (hfseq_meas n)).max measurable_const).aestronglyMeasurable
      · exact Filter.Eventually.of_forall
          (prob_7_6_negPart_le hfseq_nonneg hf_nonneg n)
    have hdiff_int : Integrable (fun x => fseq n x - f x) μ :=
      (hfseq_int n).sub hf_int
    calc
      (∫ x, |fseq n x - f x| ∂μ) =
          ∫ x, ((fseq n x - f x) + 2 * prob_7_6_negPart fseq f n x) ∂μ := by
            apply integral_congr_ae
            filter_upwards with x
            exact prob_7_6_abs_sub_identity (fseq n x) (f x)
      _ = (∫ x, fseq n x - f x ∂μ) +
          ∫ x, 2 * prob_7_6_negPart fseq f n x ∂μ := by
            rw [integral_add hdiff_int (hneg_int.const_mul 2)]
      _ = (∫ x, fseq n x ∂μ) - (∫ x, f x ∂μ) +
          2 * ∫ x, prob_7_6_negPart fseq f n x ∂μ := by
            rw [integral_sub (hfseq_int n) hf_int, integral_const_mul]
  have hconst : Tendsto (fun _ : ℕ => ∫ x, f x ∂μ) atTop (𝓝 (∫ x, f x ∂μ)) :=
    tendsto_const_nhds
  have hmain := (hintegral.sub hconst).add (hneg.const_mul 2)
  have heq :
      (fun n => ∫ x, |fseq n x - f x| ∂μ) =
        (fun n => (∫ x, fseq n x ∂μ) - (∫ x, f x ∂μ) +
          2 * ∫ x, prob_7_6_negPart fseq f n x ∂μ) :=
    funext hformula
  rw [heq]
  simpa only [sub_self, zero_add, mul_zero] using hmain
