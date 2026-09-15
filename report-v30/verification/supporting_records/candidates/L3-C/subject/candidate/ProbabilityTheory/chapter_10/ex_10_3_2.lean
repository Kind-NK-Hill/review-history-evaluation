import ProbabilityTheory.common_support.scheffe
import ProbabilityTheory.chapter_14.thm_14_4
import Mathlib.Probability.Distributions.Gaussian.Real
import Mathlib.MeasureTheory.Measure.LevyConvergence

/-! # Example 10.3.2: density convergence, total variation, and Gaussian laws -/

open Filter MeasureTheory ProbabilityTheory
open scoped Topology NNReal

noncomputable section

/-- A probability law constructed from a real Lebesgue density. -/
def ex_10_3_2_densityLaw (f : ℝ → ℝ) (hf_int : Integrable f volume)
    (hf_nonneg : ∀ x, 0 ≤ f x) (hf_prob : ∫ x, f x = 1) : ProbabilityMeasure ℝ :=
  show { μ : Measure ℝ // IsProbabilityMeasure μ } from
    ⟨thm_14_4_densityMeasure volume f,
      thm_14_4_densityMeasure_isProbabilityMeasure hf_int hf_nonneg hf_prob⟩

/-- A Gaussian probability law, including variance zero. -/
def ex_10_3_2_gaussianLaw (m : ℝ) (v : ℝ≥0) : ProbabilityMeasure ℝ :=
  show { μ : Measure ℝ // IsProbabilityMeasure μ } from
    ⟨gaussianReal m v, inferInstance⟩

/-- The general density conclusion in the source example: a.e. convergence of
probability densities implies total-variation convergence and convergence in
distribution in Mathlib's probability-measure topology. -/
theorem ex_10_3_2_density_convergence
    (fn : ℕ → ℝ → ℝ) (f : ℝ → ℝ)
    (hfn_meas : ∀ n, Measurable (fn n)) (hf_meas : Measurable f)
    (hfn_int : ∀ n, Integrable (fn n) volume) (hf_int : Integrable f volume)
    (hfn_nonneg : ∀ n x, 0 ≤ fn n x) (hf_nonneg : ∀ x, 0 ≤ f x)
    (hfn_prob : ∀ n, ∫ x, fn n x = 1) (hf_prob : ∫ x, f x = 1)
    (hconv : ∀ᵐ x ∂volume, Tendsto (fun n => fn n x) atTop (𝓝 (f x))) :
    Tendsto (fun n => totalVariationDistance
        (ex_10_3_2_densityLaw (fn n) (hfn_int n) (hfn_nonneg n) (hfn_prob n) : Measure ℝ)
        (ex_10_3_2_densityLaw f hf_int hf_nonneg hf_prob : Measure ℝ))
      atTop (𝓝 0) ∧
    MeasuresConvergeInDistribution
      (fun n => ex_10_3_2_densityLaw (fn n) (hfn_int n) (hfn_nonneg n) (hfn_prob n))
      (ex_10_3_2_densityLaw f hf_int hf_nonneg hf_prob) := by
  have hl1 : Tendsto (fun n => ∫ x, |fn n x - f x|) atTop (𝓝 0) := by
    apply prob_7_6_scheffe volume fn f hfn_meas hf_meas hfn_nonneg hf_nonneg hf_int
    · exact Eventually.of_forall hfn_int
    · exact hconv
    · simpa [hfn_prob, hf_prob]
  have htv : Tendsto (fun n => totalVariationDistance
        (ex_10_3_2_densityLaw (fn n) (hfn_int n) (hfn_nonneg n) (hfn_prob n) : Measure ℝ)
        (ex_10_3_2_densityLaw f hf_int hf_nonneg hf_prob : Measure ℝ))
      atTop (𝓝 0) := by
    have hformula : ∀ n, totalVariationDistance
        (ex_10_3_2_densityLaw (fn n) (hfn_int n) (hfn_nonneg n) (hfn_prob n) : Measure ℝ)
        (ex_10_3_2_densityLaw f hf_int hf_nonneg hf_prob : Measure ℝ) =
        (1 / 2 : ℝ) * ∫ x, |fn n x - f x| := by
      intro n
      exact thm_14_4_totalVariationDistance_withDensity_eq_half_integral_abs
        volume (hfn_meas n) hf_meas (hfn_int n) hf_int (hfn_nonneg n) hf_nonneg
        (hfn_prob n) hf_prob
    convert hl1.const_mul (1 / 2 : ℝ) using 1
    · ext n
      exact hformula n
    · ring
  refine ⟨htv, ?_⟩
  unfold MeasuresConvergeInDistribution
  exact def_14_1_iff_tendsto.mp (thm_14_4 _ _ htv)

/-- Pointwise convergence of Gaussian densities when the limiting variance is
strictly positive. -/
theorem ex_10_3_2_gaussianPDFReal_tendsto
    (m : ℕ → ℝ) (v : ℕ → ℝ≥0) (M : ℝ) (V : ℝ≥0)
    (hm : Tendsto m atTop (𝓝 M)) (hv : Tendsto v atTop (𝓝 V)) (hV : V ≠ 0)
    (x : ℝ) :
    Tendsto (fun n => gaussianPDFReal (m n) (v n) x) atTop
      (𝓝 (gaussianPDFReal M V x)) := by
  have hc : ContinuousAt
      (fun p : ℝ × ℝ≥0 => gaussianPDFReal p.1 p.2 x) (M, V) := by
    unfold gaussianPDFReal
    apply ContinuousAt.mul
    · apply ContinuousAt.inv₀
      · fun_prop
      · have hp : (0 : ℝ) < V := NNReal.coe_pos.mpr (pos_iff_ne_zero.mpr hV)
        positivity
    · apply Real.continuous_exp.continuousAt.comp
      apply ContinuousAt.div
      · fun_prop
      · exact (NNReal.continuous_coe.continuousAt.comp continuousAt_snd).const_mul 2
      · have hp : (0 : ℝ) < V := NNReal.coe_pos.mpr (pos_iff_ne_zero.mpr hV)
        positivity
  exact hc.tendsto.comp (hm.prodMk_nhds hv)

/-- Gaussian laws are weakly continuous in mean and nonnegative variance.  In
particular this covers the degenerate limit `V = 0`, whose law is `dirac M`. -/
theorem ex_10_3_2_gaussian_convergesInDistribution
    (m : ℕ → ℝ) (v : ℕ → ℝ≥0) (M : ℝ) (V : ℝ≥0)
    (hm : Tendsto m atTop (𝓝 M)) (hv : Tendsto v atTop (𝓝 V)) :
    MeasuresConvergeInDistribution
      (fun n => ex_10_3_2_gaussianLaw (m n) (v n))
      (ex_10_3_2_gaussianLaw M V) := by
  unfold MeasuresConvergeInDistribution
  refine ProbabilityMeasure.tendsto_iff_tendsto_charFun.2 fun t => ?_
  change Tendsto (fun n => charFun (gaussianReal (m n) (v n)) t) atTop
    (𝓝 (charFun (gaussianReal M V) t))
  simp_rw [charFun_gaussianReal]
  have hmC : Tendsto (fun n => (m n : ℂ)) atTop (𝓝 (M : ℂ)) :=
    Complex.continuous_ofReal.continuousAt.tendsto.comp hm
  have hvR : Tendsto (fun n => (v n : ℝ)) atTop (𝓝 (V : ℝ)) :=
    NNReal.tendsto_coe.mpr hv
  have hvC : Tendsto (fun n => ((v n : ℝ) : ℂ)) atTop (𝓝 ((V : ℝ) : ℂ)) :=
    Complex.continuous_ofReal.continuousAt.tendsto.comp hvR
  apply Complex.continuous_exp.continuousAt.tendsto.comp
  exact (((tendsto_const_nhds.mul hmC).mul tendsto_const_nhds).sub
    ((hvC.mul tendsto_const_nhds).div_const 2))

/-- At variance zero the preceding theorem is precisely convergence to the
Dirac mass at the limiting mean.  No total-variation claim is made. -/
theorem ex_10_3_2_gaussian_zeroVariance_convergesTo_dirac
    (m : ℕ → ℝ) (v : ℕ → ℝ≥0) (M : ℝ)
    (hm : Tendsto m atTop (𝓝 M)) (hv : Tendsto v atTop (𝓝 0)) :
    MeasuresConvergeInDistribution
      (fun n => ex_10_3_2_gaussianLaw (m n) (v n))
      (show ProbabilityMeasure ℝ from
        ⟨Measure.dirac M, by rw [← gaussianReal_zero_var M]; infer_instance⟩) := by
  simpa [ex_10_3_2_gaussianLaw, gaussianReal_zero_var] using
    ex_10_3_2_gaussian_convergesInDistribution m v M 0 hm hv

/-- For positive limiting variance, Gaussian laws converge in total variation;
together with the pointwise-density theorem and the general weak theorem this
delivers the nondegenerate case of the source example. -/
theorem ex_10_3_2_gaussian_positiveVariance_totalVariation
    (m : ℕ → ℝ) (v : ℕ → ℝ≥0) (M : ℝ) (V : ℝ≥0)
    (hm : Tendsto m atTop (𝓝 M)) (hv : Tendsto v atTop (𝓝 V)) (hV : V ≠ 0) :
    Tendsto (fun n => totalVariationDistance
        (gaussianReal (m n) (v n)) (gaussianReal M V)) atTop (𝓝 0) := by
  have hv_ne : ∀ᶠ n in atTop, v n ≠ 0 := hv.eventually_ne hV
  have hpoint : ∀ᵐ x ∂volume,
      Tendsto (fun n => gaussianPDFReal (m n) (v n) x) atTop
        (𝓝 (gaussianPDFReal M V x)) :=
    ae_of_all _ (ex_10_3_2_gaussianPDFReal_tendsto m v M V hm hv hV)
  have hint : Tendsto
      (fun n => ∫ x, gaussianPDFReal (m n) (v n) x) atTop
      (𝓝 (∫ x, gaussianPDFReal M V x)) := by
    rw [integral_gaussianPDFReal_eq_one M hV]
    apply tendsto_const_nhds.congr'
    filter_upwards [hv_ne] with n hn
    exact (integral_gaussianPDFReal_eq_one (m n) hn).symm
  have hl1 : Tendsto
      (fun n => ∫ x, |gaussianPDFReal (m n) (v n) x - gaussianPDFReal M V x|)
      atTop (𝓝 0) := by
    apply prob_7_6_scheffe volume
      (fun n => gaussianPDFReal (m n) (v n)) (gaussianPDFReal M V)
      (fun n => measurable_gaussianPDFReal _ _) (measurable_gaussianPDFReal _ _)
      (fun n => gaussianPDFReal_nonneg _ _) (gaussianPDFReal_nonneg _ _)
      (integrable_gaussianPDFReal _ _)
      (Eventually.of_forall fun n => integrable_gaussianPDFReal _ _) hpoint hint
  have hhalf : Tendsto (fun n => (1 / 2 : ℝ) * ∫ x, |gaussianPDFReal (m n) (v n) x - gaussianPDFReal M V x|) atTop (𝓝 0) := by
    simpa using hl1.const_mul (1 / 2 : ℝ)
  apply hhalf.congr'
  filter_upwards [hv_ne] with n hn
  rw [gaussianReal_of_var_ne_zero _ hn, gaussianReal_of_var_ne_zero _ hV]
  exact (thm_14_4_totalVariationDistance_withDensity_eq_half_integral_abs
    volume (measurable_gaussianPDFReal _ _) (measurable_gaussianPDFReal _ _)
    (integrable_gaussianPDFReal _ _) (integrable_gaussianPDFReal _ _)
    (gaussianPDFReal_nonneg _ _) (gaussianPDFReal_nonneg _ _)
    (integral_gaussianPDFReal_eq_one _ hn)
    (integral_gaussianPDFReal_eq_one _ hV)).symm

/-- Bundled nondegenerate Gaussian conclusion: pointwise density convergence,
total-variation convergence, and convergence in distribution. -/
theorem ex_10_3_2_gaussian_positiveVariance
    (m : ℕ → ℝ) (v : ℕ → ℝ≥0) (M : ℝ) (V : ℝ≥0)
    (hm : Tendsto m atTop (𝓝 M)) (hv : Tendsto v atTop (𝓝 V)) (hV : V ≠ 0) :
    (∀ x : ℝ, Tendsto (fun n => gaussianPDFReal (m n) (v n) x) atTop
      (𝓝 (gaussianPDFReal M V x))) ∧
    Tendsto (fun n => totalVariationDistance
      (gaussianReal (m n) (v n)) (gaussianReal M V)) atTop (𝓝 0) ∧
    MeasuresConvergeInDistribution
      (fun n => ex_10_3_2_gaussianLaw (m n) (v n))
      (ex_10_3_2_gaussianLaw M V) := by
  exact ⟨ex_10_3_2_gaussianPDFReal_tendsto m v M V hm hv hV,
    ex_10_3_2_gaussian_positiveVariance_totalVariation m v M V hm hv hV,
    ex_10_3_2_gaussian_convergesInDistribution m v M V hm hv⟩
