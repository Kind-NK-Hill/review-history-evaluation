import Mathlib
import ProbabilityTheory.chapter_07.prob_7_6
import ProbabilityTheory.chapter_08.prob_8_7
import ProbabilityTheory.chapter_10.thm_10_6
import ProbabilityTheory.chapter_14.thm_14_4
import ProbabilityTheory.common_support.tv_distance_core

open Filter MeasureTheory ProbabilityTheory
open scoped Topology NNReal ENNReal
open TVCore

noncomputable section

/-- The probability law built from a Lebesgue density. -/
def ex_10_3_2_densityLaw (f : ℝ → ℝ) (hf : IsProbabilityDensity f) :
    ProbabilityMeasure ℝ :=
  ⟨densityMeasure f, densityMeasure_isProbabilityMeasure
    (integrable_of_integral_eq_one hf.integral_eq_one) hf.nonneg hf.integral_eq_one⟩

/-- Scheffé applied to probability densities: almost-everywhere pointwise convergence
implies convergence in `L¹`. -/
theorem ex_10_3_2_density_L1
    {fseq : ℕ → ℝ → ℝ} {f : ℝ → ℝ}
    (hfseq : ∀ n, IsProbabilityDensity (fseq n))
    (hf : IsProbabilityDensity f)
    (hconv : ∀ᵐ x ∂volume, Tendsto (fun n => fseq n x) atTop (𝓝 (f x))) :
    Tendsto (fun n => ∫ x, |fseq n x - f x|) atTop (𝓝 0) := by
  apply prob_7_6 volume (fun n => (hfseq n).measurable) hf.measurable
    (fun n => (hfseq n).nonneg) hf.nonneg
    (fun n => integrable_of_integral_eq_one (hfseq n).integral_eq_one)
    (integrable_of_integral_eq_one hf.integral_eq_one) hconv
  convert (tendsto_const_nhds :
    Tendsto (fun _ : ℕ => (1 : ℝ)) atTop (𝓝 1)) using 1
  · ext n
    exact (hfseq n).integral_eq_one
  · rw [hf.integral_eq_one]

/-- The total-variation distance of the density laws tends to zero. -/
theorem ex_10_3_2_density_totalVariation
    {fseq : ℕ → ℝ → ℝ} {f : ℝ → ℝ}
    (hfseq : ∀ n, IsProbabilityDensity (fseq n))
    (hf : IsProbabilityDensity f)
    (hconv : ∀ᵐ x ∂volume, Tendsto (fun n => fseq n x) atTop (𝓝 (f x))) :
    thm_14_4_totalVariationConvergence
      (fun n => ex_10_3_2_densityLaw (fseq n) (hfseq n))
      (ex_10_3_2_densityLaw f hf) := by
  have hL1 := ex_10_3_2_density_L1 hfseq hf hconv
  rw [thm_14_4_totalVariationConvergence]
  have heq : ∀ n,
      totalVariationDistance
          ((ex_10_3_2_densityLaw (fseq n) (hfseq n) : ProbabilityMeasure ℝ) : Measure ℝ)
          ((ex_10_3_2_densityLaw f hf : ProbabilityMeasure ℝ) : Measure ℝ) =
        (1 / 2 : ℝ) * ∫ x, |fseq n x - f x| := by
    intro n
    simpa [ex_10_3_2_densityLaw, densityDiff] using
      continuous_totalVariationDistance_eq_half_integral_abs
        (hfseq n).measurable hf.measurable
        (integrable_of_integral_eq_one (hfseq n).integral_eq_one)
        (integrable_of_integral_eq_one hf.integral_eq_one)
        (hfseq n).nonneg hf.nonneg
        (hfseq n).integral_eq_one hf.integral_eq_one
  have hhalf : Tendsto (fun n => (1 / 2 : ℝ) * ∫ x, |fseq n x - f x|)
      atTop (𝓝 0) := by
    simpa using hL1.const_mul (1 / 2 : ℝ)
  exact hhalf.congr' (Filter.Eventually.of_forall fun n => (heq n).symm)

/-- Consequently the density laws converge weakly (hence in distribution). -/
theorem ex_10_3_2_density_weakConvergence
    {fseq : ℕ → ℝ → ℝ} {f : ℝ → ℝ}
    (hfseq : ∀ n, IsProbabilityDensity (fseq n))
    (hf : IsProbabilityDensity f)
    (hconv : ∀ᵐ x ∂volume, Tendsto (fun n => fseq n x) atTop (𝓝 (f x))) :
    def_14_1
      (fun n => ex_10_3_2_densityLaw (fseq n) (hfseq n))
      (ex_10_3_2_densityLaw f hf) :=
  thm_14_4 _ _ (ex_10_3_2_density_totalVariation hfseq hf hconv)

/-- Chapter 10 formulation: convergence of pdfs implies convergence in distribution.
The first conjunct records explicitly that the asserted limit is a probability density. -/
theorem ex_10_3_2
    {fseq : ℕ → ℝ → ℝ} {f : ℝ → ℝ}
    (hfseq : ∀ n, IsProbabilityDensity (fseq n))
    (hf : IsProbabilityDensity f)
    (hconv : ∀ᵐ x ∂volume, Tendsto (fun n => fseq n x) atTop (𝓝 (f x))) :
    IsProbabilityDensity f ∧
      MeasuresConvergeInDistribution
        (fun n => ex_10_3_2_densityLaw (fseq n) (hfseq n))
        (ex_10_3_2_densityLaw f hf) := by
  refine ⟨hf, ?_⟩
  exact thm_10_6_weak_to_distribution_bridge _ _
    (ex_10_3_2_density_weakConvergence hfseq hf hconv)

/-- The Gaussian law, including the degenerate zero-variance case. -/
def ex_10_3_2_gaussianLaw (m : ℝ) (v : ℝ≥0) : ProbabilityMeasure ℝ :=
  ⟨gaussianReal m v, inferInstance⟩

lemma ex_10_3_2_gaussian_isProbabilityDensity (m : ℝ) {v : ℝ≥0} (hv : v ≠ 0) :
    IsProbabilityDensity (gaussianPDFReal m v) where
  measurable := measurable_gaussianPDFReal m v
  nonneg := gaussianPDFReal_nonneg m v
  integral_eq_one := integral_gaussianPDFReal_eq_one m hv

lemma ex_10_3_2_gaussianPDFReal_tendsto
    {mseq : ℕ → ℝ} {m : ℝ} {vseq : ℕ → ℝ≥0} {v : ℝ≥0}
    (hm : Tendsto mseq atTop (𝓝 m)) (hv : Tendsto vseq atTop (𝓝 v))
    (hv0 : v ≠ 0) (x : ℝ) :
    Tendsto (fun n => gaussianPDFReal (mseq n) (vseq n) x)
      atTop (𝓝 (gaussianPDFReal m v x)) := by
  have hp : Tendsto (fun n => (mseq n, vseq n)) atTop (𝓝 (m, v)) :=
    hm.prodMk_nhds hv
  apply (show ContinuousAt (fun p : ℝ × ℝ≥0 => gaussianPDFReal p.1 p.2 x) (m, v) by
    unfold gaussianPDFReal
    fun_prop (disch := positivity)).tendsto.comp hp

lemma ex_10_3_2_densityLaw_gaussian_eq
    (m : ℝ) {v : ℝ≥0} (hv : v ≠ 0) :
    ex_10_3_2_densityLaw (gaussianPDFReal m v)
        (ex_10_3_2_gaussian_isProbabilityDensity m hv) =
      ex_10_3_2_gaussianLaw m v := by
  apply Subtype.ext
  simp only [ex_10_3_2_densityLaw, ex_10_3_2_gaussianLaw]
  rw [gaussianReal_of_var_ne_zero m hv]
  rfl

/-- Positive limiting variance: Gaussian laws converge in total variation. -/
theorem ex_10_3_2_gaussian_positive_totalVariation
    {mseq : ℕ → ℝ} {m : ℝ} {vseq : ℕ → ℝ≥0} {v : ℝ≥0}
    (hm : Tendsto mseq atTop (𝓝 m)) (hv : Tendsto vseq atTop (𝓝 v))
    (hvseq0 : ∀ n, vseq n ≠ 0) (hv0 : v ≠ 0) :
    thm_14_4_totalVariationConvergence
      (fun n => ex_10_3_2_gaussianLaw (mseq n) (vseq n))
      (ex_10_3_2_gaussianLaw m v) := by
  let fseq : ℕ → ℝ → ℝ := fun n => gaussianPDFReal (mseq n) (vseq n)
  let f : ℝ → ℝ := gaussianPDFReal m v
  have hpdfseq : ∀ n, IsProbabilityDensity (fseq n) :=
    fun n => ex_10_3_2_gaussian_isProbabilityDensity _ (hvseq0 n)
  have hpdf : IsProbabilityDensity f :=
    ex_10_3_2_gaussian_isProbabilityDensity _ hv0
  have hpoint : ∀ᵐ x ∂volume, Tendsto (fun n => fseq n x) atTop (𝓝 (f x)) :=
    Filter.Eventually.of_forall fun x =>
      ex_10_3_2_gaussianPDFReal_tendsto hm hv hv0 x
  have htv := ex_10_3_2_density_totalVariation hpdfseq hpdf hpoint
  rw [thm_14_4_totalVariationConvergence] at htv ⊢
  apply htv.congr'
  filter_upwards with n
  dsimp only [fseq, f] at *
  rw [ex_10_3_2_densityLaw_gaussian_eq _ (hvseq0 n),

    ex_10_3_2_densityLaw_gaussian_eq _ hv0]
/-- Positive limiting variance: the corresponding normal laws converge in distribution. -/
theorem ex_10_3_2_gaussian_positive_distribution
    {mseq : ℕ → ℝ} {m : ℝ} {vseq : ℕ → ℝ≥0} {v : ℝ≥0}
    (hm : Tendsto mseq atTop (𝓝 m)) (hv : Tendsto vseq atTop (𝓝 v))
    (hvseq0 : ∀ n, vseq n ≠ 0) (hv0 : v ≠ 0) :
    MeasuresConvergeInDistribution
      (fun n => ex_10_3_2_gaussianLaw (mseq n) (vseq n))
      (ex_10_3_2_gaussianLaw m v) :=
  thm_10_6_weak_to_distribution_bridge _ _
    (thm_14_4 _ _ (ex_10_3_2_gaussian_positive_totalVariation hm hv hvseq0 hv0))
/-- Gaussian laws depend weakly continuously on both mean and variance.
This characteristic-function proof also covers variance zero. -/
theorem ex_10_3_2_gaussian_weakConvergence
    {mseq : ℕ → ℝ} {m : ℝ} {vseq : ℕ → ℝ≥0} {v : ℝ≥0}
    (hm : Tendsto mseq atTop (𝓝 m)) (hv : Tendsto vseq atTop (𝓝 v)) :
    def_14_1
      (fun n => ex_10_3_2_gaussianLaw (mseq n) (vseq n))
      (ex_10_3_2_gaussianLaw m v) := by
  rw [def_14_1_iff_tendsto, ProbabilityMeasure.tendsto_iff_tendsto_charFun]
  intro t
  simp only [ex_10_3_2_gaussianLaw, ProbabilityMeasure.coe_mk,
    charFun_gaussianReal]
  have hmC : Tendsto (fun n => (mseq n : ℂ)) atTop (𝓝 (m : ℂ)) :=
    (Complex.continuous_ofReal.tendsto m).comp hm
  have hvR : Tendsto (fun n => (vseq n : ℝ)) atTop (𝓝 (v : ℝ)) :=
    (NNReal.continuous_coe.tendsto v).comp hv
  have hvC : Tendsto (fun n => ((vseq n : ℝ) : ℂ)) atTop (𝓝 ((v : ℝ) : ℂ)) :=
    (Complex.continuous_ofReal.tendsto (v : ℝ)).comp hvR
  have harg :
      Tendsto
        (fun n => (t : ℂ) * (mseq n : ℂ) * Complex.I -
          ((vseq n : ℝ) : ℂ) * (t : ℂ) ^ 2 / 2)
        atTop
        (𝓝 ((t : ℂ) * (m : ℂ) * Complex.I -
          ((v : ℝ) : ℂ) * (t : ℂ) ^ 2 / 2)) := by
    exact ((hmC.const_mul (t : ℂ)).mul_const Complex.I).sub
      ((hvC.mul_const ((t : ℂ) ^ 2)).div_const 2)
  exact Complex.continuous_exp.continuousAt.tendsto.comp harg

/-- If the variances tend to zero, the Gaussian laws converge in distribution
to the point mass at the limiting mean. -/
theorem ex_10_3_2_gaussian_zero_distribution
    {mseq : ℕ → ℝ} {m : ℝ} {vseq : ℕ → ℝ≥0}
    (hm : Tendsto mseq atTop (𝓝 m)) (hv : Tendsto vseq atTop (𝓝 0)) :
    MeasuresConvergeInDistribution
      (fun n => ex_10_3_2_gaussianLaw (mseq n) (vseq n))
      (ex_10_3_2_gaussianLaw m 0) :=
  thm_10_6_weak_to_distribution_bridge _ _
    (ex_10_3_2_gaussian_weakConvergence hm hv)


lemma ex_10_3_2_gaussian_dirac_totalVariation_ge_one
    (m₁ m : ℝ) {v : ℝ≥0} (hv : v ≠ 0) :
    1 ≤ totalVariationDistance (gaussianReal m₁ v) (gaussianReal m 0) := by
  letI : NoAtoms (gaussianReal m₁ v) := noAtoms_gaussianReal hv
  have hb := ex_10_3_1_totalVariationDistance_event_bound
    (gaussianReal m₁ v) (gaussianReal m 0) ({m} : Set ℝ) (measurableSet_singleton m)
  simpa [gaussianReal_zero_var, Measure.real_def] using hb

/-- With every approximating variance nonzero, convergence to a point mass is
not convergence in total variation (the distance is always at least one). -/
theorem ex_10_3_2_gaussian_zero_not_totalVariation
    {mseq : ℕ → ℝ} {m : ℝ} {vseq : ℕ → ℝ≥0}
    (hvseq0 : ∀ n, vseq n ≠ 0) :
    ¬ thm_14_4_totalVariationConvergence
      (fun n => ex_10_3_2_gaussianLaw (mseq n) (vseq n))
      (ex_10_3_2_gaussianLaw m 0) := by
  intro htv
  rw [thm_14_4_totalVariationConvergence] at htv
  have hlt : ∀ᶠ n : ℕ in atTop,
      totalVariationDistance
        ((ex_10_3_2_gaussianLaw (mseq n) (vseq n) : ProbabilityMeasure ℝ) : Measure ℝ)
        ((ex_10_3_2_gaussianLaw m 0 : ProbabilityMeasure ℝ) : Measure ℝ) < (1 / 2 : ℝ) :=
    htv (Iio_mem_nhds (by norm_num : (0 : ℝ) < 1 / 2))
  have hge : ∀ᶠ n : ℕ in atTop,
      (1 : ℝ) ≤ totalVariationDistance
        ((ex_10_3_2_gaussianLaw (mseq n) (vseq n) : ProbabilityMeasure ℝ) : Measure ℝ)
        ((ex_10_3_2_gaussianLaw m 0 : ProbabilityMeasure ℝ) : Measure ℝ) := by
    filter_upwards with n
    exact ex_10_3_2_gaussian_dirac_totalVariation_ge_one
      (mseq n) m (hvseq0 n)
  rcases (hlt.and hge).exists with ⟨n, hnlt, hnge⟩
  linarith

/-- Complete zero-variance statement: weak/distributional convergence holds,
whereas total-variation convergence fails for genuinely nondegenerate approximants. -/
theorem ex_10_3_2_gaussian_zero_complete
    {mseq : ℕ → ℝ} {m : ℝ} {vseq : ℕ → ℝ≥0}
    (hm : Tendsto mseq atTop (𝓝 m)) (hv : Tendsto vseq atTop (𝓝 0))
    (hvseq0 : ∀ n, vseq n ≠ 0) :
    MeasuresConvergeInDistribution
        (fun n => ex_10_3_2_gaussianLaw (mseq n) (vseq n))
        (ex_10_3_2_gaussianLaw m 0) ∧
      ¬ thm_14_4_totalVariationConvergence
        (fun n => ex_10_3_2_gaussianLaw (mseq n) (vseq n))
        (ex_10_3_2_gaussianLaw m 0) :=
  ⟨ex_10_3_2_gaussian_zero_distribution hm hv,
    ex_10_3_2_gaussian_zero_not_totalVariation hvseq0⟩

/-- Positive limiting variance, without any global nondegeneracy premise on
the approximating sequence: convergence itself makes the variances eventually nonzero. -/
theorem ex_10_3_2_gaussian_positive_totalVariation_general
    {mseq : ℕ → ℝ} {m : ℝ} {vseq : ℕ → ℝ≥0} {v : ℝ≥0}
    (hm : Tendsto mseq atTop (𝓝 m)) (hv : Tendsto vseq atTop (𝓝 v))
    (hv0 : v ≠ 0) :
    thm_14_4_totalVariationConvergence
      (fun n => ex_10_3_2_gaussianLaw (mseq n) (vseq n))
      (ex_10_3_2_gaussianLaw m v) := by
  have hne : ∀ᶠ n : ℕ in atTop, vseq n ≠ 0 := hv.eventually_ne hv0
  have hpoint : ∀ᵐ x ∂volume,
      Tendsto (fun n => gaussianPDFReal (mseq n) (vseq n) x)
        atTop (𝓝 (gaussianPDFReal m v x)) :=
    Filter.Eventually.of_forall fun x =>
      ex_10_3_2_gaussianPDFReal_tendsto hm hv hv0 x
  have hint : Tendsto (fun n => ∫ x, gaussianPDFReal (mseq n) (vseq n) x)
      atTop (𝓝 (∫ x, gaussianPDFReal m v x)) := by
    have hc : Tendsto (fun _ : ℕ => (1 : ℝ)) atTop (𝓝 1) := tendsto_const_nhds
    rw [integral_gaussianPDFReal_eq_one _ hv0]
    apply hc.congr'
    filter_upwards [hne] with n hn
    rw [integral_gaussianPDFReal_eq_one _ hn]
  have hL1 : Tendsto
      (fun n => ∫ x, |gaussianPDFReal (mseq n) (vseq n) x -
        gaussianPDFReal m v x|) atTop (𝓝 0) := by
    exact prob_7_6 volume
      (fun n => measurable_gaussianPDFReal _ _) (measurable_gaussianPDFReal _ _)
      (fun n => gaussianPDFReal_nonneg _ _) (gaussianPDFReal_nonneg _ _)
      (fun n => integrable_gaussianPDFReal _ _) (integrable_gaussianPDFReal _ _)
      hpoint hint
  rw [thm_14_4_totalVariationConvergence]
  have hhalf : Tendsto
      (fun n => (1 / 2 : ℝ) * ∫ x,
        |gaussianPDFReal (mseq n) (vseq n) x - gaussianPDFReal m v x|)
      atTop (𝓝 0) := by
    simpa using hL1.const_mul (1 / 2 : ℝ)
  apply hhalf.congr'
  filter_upwards [hne] with n hn
  rw [← ex_10_3_2_densityLaw_gaussian_eq _ hn,
    ← ex_10_3_2_densityLaw_gaussian_eq _ hv0]
  simpa [ex_10_3_2_densityLaw, densityDiff] using
    (continuous_totalVariationDistance_eq_half_integral_abs
      (measurable_gaussianPDFReal (mseq n) (vseq n))
      (measurable_gaussianPDFReal m v)
      (integrable_gaussianPDFReal (mseq n) (vseq n))
      (integrable_gaussianPDFReal m v)
      (gaussianPDFReal_nonneg (mseq n) (vseq n))
      (gaussianPDFReal_nonneg m v)
      (integral_gaussianPDFReal_eq_one _ hn)
      (integral_gaussianPDFReal_eq_one _ hv0)).symm

/-- Positive-variance normal parameter convergence in the exact distributional form. -/
theorem ex_10_3_2_gaussian_positive_distribution_general
    {mseq : ℕ → ℝ} {m : ℝ} {vseq : ℕ → ℝ≥0} {v : ℝ≥0}
    (hm : Tendsto mseq atTop (𝓝 m)) (hv : Tendsto vseq atTop (𝓝 v))
    (hv0 : v ≠ 0) :
    MeasuresConvergeInDistribution
      (fun n => ex_10_3_2_gaussianLaw (mseq n) (vseq n))
      (ex_10_3_2_gaussianLaw m v) :=
  thm_10_6_weak_to_distribution_bridge _ _
    (thm_14_4 _ _
      (ex_10_3_2_gaussian_positive_totalVariation_general hm hv hv0))
