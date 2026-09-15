import Mathlib
import ProbabilityTheory.chapter_07.prob_7_6
import ProbabilityTheory.common_support.tv_distance_core
import ProbabilityTheory.chapter_10.thm_10_6

open Filter MeasureTheory ProbabilityTheory
open scoped Topology ENNReal NNReal Real Complex
noncomputable section

namespace PdfConvergence

def densityProbabilityMeasure (f : ℝ → ℝ) (hf_int : Integrable f)
    (hf_nonneg : ∀ x, 0 ≤ f x) (hf_prob : ∫ x, f x = 1) : ProbabilityMeasure ℝ :=
  ⟨TVCore.densityMeasure f, TVCore.densityMeasure_isProbabilityMeasure hf_int hf_nonneg hf_prob⟩

theorem pdf_tendsto_L1 {fn : ℕ → ℝ → ℝ} {f : ℝ → ℝ}
    (hfn_meas : ∀ n, Measurable (fn n)) (hf_meas : Measurable f)
    (hfn_nonneg : ∀ n x, 0 ≤ fn n x) (hf_nonneg : ∀ x, 0 ≤ f x)
    (hfn_prob : ∀ n, ∫ x, fn n x = 1) (hf_prob : ∫ x, f x = 1)
    (hfn_int : ∀ n, Integrable (fn n)) (hf_int : Integrable f)
    (hlim : ∀ᵐ x ∂volume, Tendsto (fun n => fn n x) atTop (𝓝 (f x))) :
    Tendsto (fun n => ∫ x, |fn n x - f x|) atTop (𝓝 0) := by
  apply Scheffe.tendsto_integral_abs_sub_of_eventually_integrable
      (fun n => (hfn_meas n).aestronglyMeasurable) hf_meas.aestronglyMeasurable
      (fun n => Filter.Eventually.of_forall (hfn_nonneg n))
      (Filter.Eventually.of_forall hf_nonneg) hlim hf_int
      (Filter.Eventually.of_forall hfn_int)
  simpa [hfn_prob, hf_prob] using tendsto_const_nhds (x := (1 : ℝ))

theorem pdf_tendsto_totalVariation {fn : ℕ → ℝ → ℝ} {f : ℝ → ℝ}
    (hfn_meas : ∀ n, Measurable (fn n)) (hf_meas : Measurable f)
    (hfn_nonneg : ∀ n x, 0 ≤ fn n x) (hf_nonneg : ∀ x, 0 ≤ f x)
    (hfn_prob : ∀ n, ∫ x, fn n x = 1) (hf_prob : ∫ x, f x = 1)
    (hfn_int : ∀ n, Integrable (fn n)) (hf_int : Integrable f)
    (hlim : ∀ᵐ x ∂volume, Tendsto (fun n => fn n x) atTop (𝓝 (f x))) :
    Tendsto (fun n => totalVariationDistance (TVCore.densityMeasure (fn n))
      (TVCore.densityMeasure f)) atTop (𝓝 0) := by
  have hL1 := pdf_tendsto_L1 hfn_meas hf_meas hfn_nonneg hf_nonneg hfn_prob hf_prob
    hfn_int hf_int hlim
  have hhalf := hL1.const_mul (1 / 2 : ℝ)
  convert hhalf using 1
  ext n
  rw [TVCore.continuous_totalVariationDistance_eq_half_integral_abs
    (hfn_meas n) hf_meas (hfn_int n) hf_int (hfn_nonneg n) hf_nonneg
    (hfn_prob n) hf_prob]
  rfl
  simp

/-- The density laws themselves converge in total variation. -/
theorem pdf_measures_tendsto_totalVariation {fn : ℕ → ℝ → ℝ} {f : ℝ → ℝ}
    (hfn_meas : ∀ n, Measurable (fn n)) (hf_meas : Measurable f)
    (hfn_nonneg : ∀ n x, 0 ≤ fn n x) (hf_nonneg : ∀ x, 0 ≤ f x)
    (hfn_prob : ∀ n, ∫ x, fn n x = 1) (hf_prob : ∫ x, f x = 1)
    (hfn_int : ∀ n, Integrable (fn n)) (hf_int : Integrable f)
    (hlim : ∀ᵐ x ∂volume, Tendsto (fun n => fn n x) atTop (𝓝 (f x))) :
    MeasuresConvergeInTotalVariation (fun n => TVCore.densityMeasure (fn n))
      (TVCore.densityMeasure f) :=
  ⟨fun n => TVCore.densityMeasure_isProbabilityMeasure (hfn_int n) (hfn_nonneg n) (hfn_prob n),
    TVCore.densityMeasure_isProbabilityMeasure hf_int hf_nonneg hf_prob,
    pdf_tendsto_totalVariation hfn_meas hf_meas hfn_nonneg hf_nonneg hfn_prob hf_prob
      hfn_int hf_int hlim⟩

theorem pdf_tendsto_inDistribution {fn : ℕ → ℝ → ℝ} {f : ℝ → ℝ}
    (hfn_meas : ∀ n, Measurable (fn n)) (hf_meas : Measurable f)
    (hfn_nonneg : ∀ n x, 0 ≤ fn n x) (hf_nonneg : ∀ x, 0 ≤ f x)
    (hfn_prob : ∀ n, ∫ x, fn n x = 1) (hf_prob : ∫ x, f x = 1)
    (hfn_int : ∀ n, Integrable (fn n)) (hf_int : Integrable f)
    (hlim : ∀ᵐ x ∂volume, Tendsto (fun n => fn n x) atTop (𝓝 (f x))) :
    MeasuresConvergeInDistribution
      (fun n => densityProbabilityMeasure (fn n) (hfn_int n) (hfn_nonneg n) (hfn_prob n))
      (densityProbabilityMeasure f hf_int hf_nonneg hf_prob) := by
  apply thm_10_6
  refine ⟨fun n => TVCore.densityMeasure_isProbabilityMeasure (hfn_int n)
      (hfn_nonneg n) (hfn_prob n),
    TVCore.densityMeasure_isProbabilityMeasure hf_int hf_nonneg hf_prob, ?_⟩
  exact pdf_tendsto_totalVariation hfn_meas hf_meas hfn_nonneg hf_nonneg hfn_prob hf_prob
    hfn_int hf_int hlim


theorem pdf_randomVariables_tendsto_inDistribution
    {Ωn : ℕ → Type*} [∀ n, MeasurableSpace (Ωn n)] {Ω : Type*} [MeasurableSpace Ω]
    (μn : (n : ℕ) → Measure (Ωn n)) [∀ n, IsProbabilityMeasure (μn n)]
    (Xn : (n : ℕ) → Ωn n → ℝ) (μ : Measure Ω) [IsProbabilityMeasure μ] (X : Ω → ℝ)
    {fn : ℕ → ℝ → ℝ} {f : ℝ → ℝ}
    (hfn_meas : ∀ n, Measurable (fn n)) (hf_meas : Measurable f)
    (hfn_nonneg : ∀ n x, 0 ≤ fn n x) (hf_nonneg : ∀ x, 0 ≤ f x)
    (hfn_prob : ∀ n, ∫ x, fn n x = 1) (hf_prob : ∫ x, f x = 1)
    (hfn_int : ∀ n, Integrable (fn n)) (hf_int : Integrable f)
    (hlim : ∀ᵐ x ∂volume, Tendsto (fun n => fn n x) atTop (𝓝 (f x)))
    (hXn : ∀ n, HasLaw (Xn n) (TVCore.densityMeasure (fn n)) (μn n))
    (hX : HasLaw X (TVCore.densityMeasure f) μ) :
    RandomVariablesConvergeInDistribution μn Xn μ X := by
  refine ⟨fun n => (hXn n).aemeasurable, hX.aemeasurable, ?_⟩
  have hd := pdf_tendsto_inDistribution hfn_meas hf_meas hfn_nonneg hf_nonneg
    hfn_prob hf_prob hfn_int hf_int hlim
  unfold MeasuresConvergeInDistribution at hd
  rw [show (⟨μ.map X, Measure.isProbabilityMeasure_map hX.aemeasurable⟩ :
    ProbabilityMeasure ℝ) = densityProbabilityMeasure f hf_int hf_nonneg hf_prob by
      exact Subtype.ext hX.map_eq]
  apply hd.congr'
  filter_upwards with n
  exact Subtype.ext (hXn n).map_eq.symm
def gaussianProbabilityMeasure (m : ℝ) (v : ℝ≥0) : ProbabilityMeasure ℝ :=
  ⟨gaussianReal m v, inferInstance⟩

theorem gaussianPDFReal_pointwise_tendsto {mn : ℕ → ℝ} {vn : ℕ → ℝ≥0} {m : ℝ} {v : ℝ≥0}
    (hm : Tendsto mn atTop (𝓝 m)) (hv : Tendsto vn atTop (𝓝 v)) (hv0 : v ≠ 0) (x : ℝ) :
    Tendsto (fun n => gaussianPDFReal (mn n) (vn n) x) atTop
      (𝓝 (gaussianPDFReal m v x)) := by
  have hvR : Tendsto (fun n => (vn n : ℝ)) atTop (𝓝 (v : ℝ)) := NNReal.tendsto_coe.2 hv
  have hden : Tendsto (fun n => 2 * π * (vn n : ℝ)) atTop (𝓝 (2 * π * (v : ℝ))) :=
    (tendsto_const_nhds.mul tendsto_const_nhds).mul hvR
  have hsqrt := hden.sqrt
  have hinv := hsqrt.inv₀ (by positivity : √(2 * π * (v : ℝ)) ≠ 0)
  have hnum : Tendsto (fun n => -(x - mn n) ^ 2) atTop (𝓝 (-(x - m) ^ 2)) :=
    (tendsto_const_nhds.sub hm).pow 2 |>.neg
  have hden2 : Tendsto (fun n => 2 * (vn n : ℝ)) atTop (𝓝 (2 * (v : ℝ))) :=
    tendsto_const_nhds.mul hvR
  have hquot := hnum.div hden2 (by positivity : (2 * (v : ℝ)) ≠ 0)
  have hexp := Real.continuous_exp.continuousAt.tendsto.comp hquot
  simpa only [gaussianPDFReal, Function.comp_apply, Pi.div_apply] using hinv.mul hexp

theorem gaussian_positiveVariance_tendsto_totalVariation
    {mn : ℕ → ℝ} {vn : ℕ → ℝ≥0} {m : ℝ} {v : ℝ≥0}
    (hm : Tendsto mn atTop (𝓝 m)) (hv : Tendsto vn atTop (𝓝 v)) (hv0 : v ≠ 0) :
    Tendsto (fun n => totalVariationDistance (gaussianReal (mn n) (vn n))
      (gaussianReal m v)) atTop (𝓝 0) := by
  have hvn0 : ∀ᶠ n in atTop, vn n ≠ 0 :=
    hv (isOpen_compl_singleton.mem_nhds hv0)
  have hint : Tendsto (fun n => ∫ x, gaussianPDFReal (mn n) (vn n) x) atTop (𝓝 1) := by
    apply tendsto_const_nhds.congr'
    filter_upwards [hvn0] with n hn
    symm
    exact integral_gaussianPDFReal_eq_one _ hn
  have hL1 := Scheffe.tendsto_integral_abs_sub_of_eventually_integrable
    (fun n => (measurable_gaussianPDFReal _ _).aestronglyMeasurable)
    (measurable_gaussianPDFReal _ _).aestronglyMeasurable
    (fun n => Filter.Eventually.of_forall (gaussianPDFReal_nonneg _ _))
    (Filter.Eventually.of_forall (gaussianPDFReal_nonneg _ _))
    (Filter.Eventually.of_forall (gaussianPDFReal_pointwise_tendsto hm hv hv0))
    (integrable_gaussianPDFReal _ _) (Filter.Eventually.of_forall (fun n => integrable_gaussianPDFReal _ _))
    (by simpa [integral_gaussianPDFReal_eq_one _ hv0] using hint)
  have hhalf := hL1.const_mul (1 / 2 : ℝ)
  have hhalf0 : Tendsto (fun n => (1 / 2 : ℝ) * ∫ x, |gaussianPDFReal (mn n) (vn n) x - gaussianPDFReal m v x|) atTop (𝓝 0) := by simpa using hhalf
  apply hhalf0.congr'
  filter_upwards [hvn0] with n hn
  rw [gaussianReal_of_var_ne_zero _ hn, gaussianReal_of_var_ne_zero _ hv0]
  change (1 / 2 : ℝ) * ∫ x, |gaussianPDFReal (mn n) (vn n) x - gaussianPDFReal m v x| = totalVariationDistance (TVCore.densityMeasure (gaussianPDFReal (mn n) (vn n))) (TVCore.densityMeasure (gaussianPDFReal m v))
  rw [TVCore.continuous_totalVariationDistance_eq_half_integral_abs
    (measurable_gaussianPDFReal _ _) (measurable_gaussianPDFReal _ _)
    (integrable_gaussianPDFReal _ _) (integrable_gaussianPDFReal _ _)
    (gaussianPDFReal_nonneg _ _) (gaussianPDFReal_nonneg _ _)
    (integral_gaussianPDFReal_eq_one _ hn) (integral_gaussianPDFReal_eq_one _ hv0)]
  rfl

theorem gaussian_tendsto_inDistribution {mn : ℕ → ℝ} {vn : ℕ → ℝ≥0} {m : ℝ} {v : ℝ≥0}
    (hm : Tendsto mn atTop (𝓝 m)) (hv : Tendsto vn atTop (𝓝 v)) :
    MeasuresConvergeInDistribution (fun n => gaussianProbabilityMeasure (mn n) (vn n))
      (gaussianProbabilityMeasure m v) := by
  unfold MeasuresConvergeInDistribution
  apply ProbabilityMeasure.tendsto_iff_tendsto_charFun.2
  intro t
  change Tendsto (fun n => charFun (gaussianReal (mn n) (vn n)) t) atTop
    (𝓝 (charFun (gaussianReal m v) t))
  simp_rw [charFun_gaussianReal]
  have hmC : Tendsto (fun n => (mn n : ℂ)) atTop (𝓝 (m : ℂ)) :=
    Complex.continuous_ofReal.continuousAt.tendsto.comp hm
  have hvR : Tendsto (fun n => (vn n : ℝ)) atTop (𝓝 (v : ℝ)) := NNReal.tendsto_coe.2 hv
  have hvC : Tendsto (fun n => (vn n : ℂ)) atTop (𝓝 (v : ℂ)) :=
    Complex.continuous_ofReal.continuousAt.tendsto.comp hvR
  have ht : Tendsto (fun _ : ℕ => (t : ℂ)) atTop (𝓝 (t : ℂ)) := tendsto_const_nhds
  have hI : Tendsto (fun _ : ℕ => Complex.I) atTop (𝓝 Complex.I) := tendsto_const_nhds
  have harg := ((ht.mul hmC).mul hI).sub ((hvC.mul (ht.pow 2)).div_const 2)
  simpa using harg.cexp

/-- Positive limiting variance gives both total-variation and distribution convergence. -/
theorem gaussian_positiveVariance_tendsto_inDistribution
    {mn : ℕ → ℝ} {vn : ℕ → ℝ≥0} {m : ℝ} {v : ℝ≥0}
    (hm : Tendsto mn atTop (𝓝 m)) (hv : Tendsto vn atTop (𝓝 v)) (hv0 : v ≠ 0) :
    MeasuresConvergeInDistribution (fun n => gaussianProbabilityMeasure (mn n) (vn n))
      (gaussianProbabilityMeasure m v) :=
  thm_10_6 _ _ ⟨fun n => inferInstance, inferInstance,
    gaussian_positiveVariance_tendsto_totalVariation hm hv hv0⟩

theorem gaussian_zeroVariance_tendsto_dirac {mn : ℕ → ℝ} {vn : ℕ → ℝ≥0} {m : ℝ}
    (hm : Tendsto mn atTop (𝓝 m)) (hv : Tendsto vn atTop (𝓝 0)) :
    MeasuresConvergeInDistribution (fun n => gaussianProbabilityMeasure (mn n) (vn n))
      ⟨Measure.dirac m, inferInstance⟩ := by
  simpa [gaussianProbabilityMeasure] using gaussian_tendsto_inDistribution hm hv

end PdfConvergence
