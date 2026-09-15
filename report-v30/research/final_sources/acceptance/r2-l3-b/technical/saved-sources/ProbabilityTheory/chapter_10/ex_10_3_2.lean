import Mathlib
import ProbabilityTheory.chapter_07.prob_7_6
import ProbabilityTheory.chapter_08.prob_8_7
import ProbabilityTheory.chapter_10.def_10_4
import ProbabilityTheory.chapter_14.thm_14_4

/-! # Convergence of densities and Gaussian laws -/

open Filter MeasureTheory ProbabilityTheory Set
open TVCore
open scoped Topology NNReal ENNReal

noncomputable section

/-- The probability measure represented by a real probability density. -/
def densityProbabilityMeasure (f : ℝ → ℝ) (hf : IsProbabilityDensity f) :
    ProbabilityMeasure ℝ :=
  ⟨TVCore.densityMeasure f, prob_8_7_density_isProbabilityMeasure hf⟩

/-- Almost-everywhere convergence of probability densities implies `L¹`
convergence.  The limiting function is explicitly required to remain a density. -/
theorem ex_10_3_2_density_L1
    (fn : ℕ → ℝ → ℝ) (f : ℝ → ℝ)
    (hfn : ∀ n, IsProbabilityDensity (fn n))
    (hf : IsProbabilityDensity f)
    (hae : ∀ᵐ x ∂volume, Tendsto (fun n => fn n x) atTop (𝓝 (f x))) :
    Tendsto (fun n => ∫ x, |fn n x - f x|) atTop (𝓝 0) := by
  apply scheffe_lemma volume fn f
  · exact fun n => (hfn n).measurable.aestronglyMeasurable
  · exact hf.measurable.aestronglyMeasurable
  · exact fun n => ae_of_all _ (hfn n).nonneg
  · exact ae_of_all _ hf.nonneg
  · exact fun n => integrable_of_integral_eq_one (hfn n).integral_eq_one
  · exact integrable_of_integral_eq_one hf.integral_eq_one
  · exact hae
  · simpa only [(hfn _).integral_eq_one, hf.integral_eq_one] using
      (tendsto_const_nhds : Tendsto (fun _ : ℕ => (1 : ℝ)) atTop (𝓝 1))

/-- Density convergence implies convergence in total variation. -/
theorem ex_10_3_2_density_totalVariation
    (fn : ℕ → ℝ → ℝ) (f : ℝ → ℝ)
    (hfn : ∀ n, IsProbabilityDensity (fn n))
    (hf : IsProbabilityDensity f)
    (hae : ∀ᵐ x ∂volume, Tendsto (fun n => fn n x) atTop (𝓝 (f x))) :
    thm_14_4_totalVariationConvergence
      (fun n => densityProbabilityMeasure (fn n) (hfn n))
      (densityProbabilityMeasure f hf) := by
  have hL1 := ex_10_3_2_density_L1 fn f hfn hf hae
  have heq : ∀ n,
      totalVariationDistance
          (densityProbabilityMeasure (fn n) (hfn n) : Measure ℝ)
          (densityProbabilityMeasure f hf : Measure ℝ) =
        (1 / 2 : ℝ) * ∫ x, |fn n x - f x| := by
    intro n
    simpa [densityProbabilityMeasure, TVCore.densityDiff] using
      TVCore.continuous_totalVariationDistance_eq_half_integral_abs
        (hfn n).measurable hf.measurable
        (integrable_of_integral_eq_one (hfn n).integral_eq_one)
        (integrable_of_integral_eq_one hf.integral_eq_one)
        (hfn n).nonneg hf.nonneg (hfn n).integral_eq_one hf.integral_eq_one
  unfold thm_14_4_totalVariationConvergence
  rw [tendsto_congr' (Filter.Eventually.of_forall heq)]
  simpa using hL1.const_mul (1 / 2 : ℝ)

/-- Hence the corresponding laws converge weakly (and therefore in
 distribution). -/
theorem ex_10_3_2_density_weakConvergence
    (fn : ℕ → ℝ → ℝ) (f : ℝ → ℝ)
    (hfn : ∀ n, IsProbabilityDensity (fn n))
    (hf : IsProbabilityDensity f)
    (hae : ∀ᵐ x ∂volume, Tendsto (fun n => fn n x) atTop (𝓝 (f x))) :
    def_14_1 (fun n => densityProbabilityMeasure (fn n) (hfn n))
      (densityProbabilityMeasure f hf) :=
  thm_14_4 _ _ (ex_10_3_2_density_totalVariation fn f hfn hf hae)

/-- Law-first formulation of the preceding distributional convergence. -/
theorem ex_10_3_2_density_convergenceInDistribution
    (fn : ℕ → ℝ → ℝ) (f : ℝ → ℝ)
    (hfn : ∀ n, IsProbabilityDensity (fn n))
    (hf : IsProbabilityDensity f)
    (hae : ∀ᵐ x ∂volume, Tendsto (fun n => fn n x) atTop (𝓝 (f x))) :
    MeasuresConvergeInDistribution
      (fun n => densityProbabilityMeasure (fn n) (hfn n))
      (densityProbabilityMeasure f hf) := by
  unfold MeasuresConvergeInDistribution
  exact def_14_1_iff_tendsto.mp
    (ex_10_3_2_density_weakConvergence fn f hfn hf hae)

/-- Gaussian laws, including the degenerate variance-zero law. -/
def gaussianProbabilityMeasure (m : ℝ) (v : ℝ≥0) : ProbabilityMeasure ℝ :=
  ⟨gaussianReal m v, inferInstance⟩

/-- At a positive limiting variance, convergence of the two parameters gives
pointwise convergence of the Gaussian densities. -/
theorem gaussianPDFReal_tendsto_of_parameters
    (mn : ℕ → ℝ) (m : ℝ) (vn : ℕ → ℝ≥0) (v : ℝ≥0)
    (hm : Tendsto mn atTop (𝓝 m)) (hv : Tendsto vn atTop (𝓝 v))
    (hv0 : v ≠ 0) (x : ℝ) :
    Tendsto (fun n => gaussianPDFReal (mn n) (vn n) x) atTop
      (𝓝 (gaussianPDFReal m v x)) := by
  have hvR : Tendsto (fun n => (vn n : ℝ)) atTop (𝓝 (v : ℝ)) := NNReal.tendsto_coe.2 hv
  have hvpos : 0 < v := bot_lt_iff_ne_bot.mpr hv0
  have hpos : 0 < (v : ℝ) := NNReal.coe_pos.2 hvpos
  have hsqrt : √(2 * Real.pi * (v : ℝ)) ≠ 0 := by positivity
  unfold gaussianPDFReal
  exact (((tendsto_const_nhds.mul tendsto_const_nhds).mul hvR).sqrt.inv₀ hsqrt).mul
    (((tendsto_const_nhds.sub hm).pow 2).neg.div
      (tendsto_const_nhds.mul hvR) (by positivity)).rexp

/-- Positive-variance Gaussian parameter convergence gives `L¹` convergence of
pdfs, even if finitely many approximating variances are zero. -/
theorem ex_10_3_2_gaussian_L1_of_posVariance
    (mn : ℕ → ℝ) (m : ℝ) (vn : ℕ → ℝ≥0) (v : ℝ≥0)
    (hm : Tendsto mn atTop (𝓝 m)) (hv : Tendsto vn atTop (𝓝 v))
    (hv0 : v ≠ 0) :
    Tendsto (fun n => ∫ x, |gaussianPDFReal (mn n) (vn n) x -
      gaussianPDFReal m v x|) atTop (𝓝 0) := by
  have hvpos : 0 < v := bot_lt_iff_ne_bot.mpr hv0
  have hv_ne : ∀ᶠ n in atTop, vn n ≠ 0 := by
    filter_upwards [hv (Ioi_mem_nhds hvpos)] with n hn
    exact ne_of_gt hn
  apply scheffe_lemma_eventually_integrable volume
      (fun n => gaussianPDFReal (mn n) (vn n)) (gaussianPDFReal m v)
  · exact fun n => (measurable_gaussianPDFReal _ _).aestronglyMeasurable
  · exact (measurable_gaussianPDFReal _ _).aestronglyMeasurable
  · exact fun n => ae_of_all _ (gaussianPDFReal_nonneg _ _)
  · exact ae_of_all _ (gaussianPDFReal_nonneg _ _)
  · exact Filter.Eventually.of_forall fun n => integrable_gaussianPDFReal _ _
  · exact integrable_gaussianPDFReal _ _
  · exact ae_of_all _ fun x => gaussianPDFReal_tendsto_of_parameters mn m vn v hm hv hv0 x
  · rw [tendsto_congr' (hv_ne.mono fun n hn =>
      integral_gaussianPDFReal_eq_one (mn n) hn)]
    simpa [integral_gaussianPDFReal_eq_one m hv0] using
      (tendsto_const_nhds : Tendsto (fun _ : ℕ => (1 : ℝ)) atTop (𝓝 1))

/-- With positive limiting variance, Gaussian laws converge in total variation. -/
theorem ex_10_3_2_gaussian_totalVariation_of_posVariance
    (mn : ℕ → ℝ) (m : ℝ) (vn : ℕ → ℝ≥0) (v : ℝ≥0)
    (hm : Tendsto mn atTop (𝓝 m)) (hv : Tendsto vn atTop (𝓝 v))
    (hv0 : v ≠ 0) :
    thm_14_4_totalVariationConvergence
      (fun n => gaussianProbabilityMeasure (mn n) (vn n))
      (gaussianProbabilityMeasure m v) := by
  have hvpos : 0 < v := bot_lt_iff_ne_bot.mpr hv0
  have hv_ne : ∀ᶠ n in atTop, vn n ≠ 0 := by
    filter_upwards [hv (Ioi_mem_nhds hvpos)] with n hn
    exact ne_of_gt hn
  have hL1 := ex_10_3_2_gaussian_L1_of_posVariance mn m vn v hm hv hv0
  unfold thm_14_4_totalVariationConvergence
  have heq : ∀ᶠ n in atTop,
      totalVariationDistance
          (gaussianProbabilityMeasure (mn n) (vn n) : Measure ℝ)
          (gaussianProbabilityMeasure m v : Measure ℝ) =
        (1 / 2 : ℝ) * ∫ x, |gaussianPDFReal (mn n) (vn n) x -
          gaussianPDFReal m v x| := by
    filter_upwards [hv_ne] with n hn
    rw [show (gaussianProbabilityMeasure (mn n) (vn n) : Measure ℝ) =
        TVCore.densityMeasure (gaussianPDFReal (mn n) (vn n)) by
          change gaussianReal (mn n) (vn n) = _
          rw [gaussianReal_of_var_ne_zero _ hn, TVCore.densityMeasure, gaussianPDF_def],
      show (gaussianProbabilityMeasure m v : Measure ℝ) =
        TVCore.densityMeasure (gaussianPDFReal m v) by
          change gaussianReal m v = _
          rw [gaussianReal_of_var_ne_zero _ hv0, TVCore.densityMeasure, gaussianPDF_def],
      TVCore.continuous_totalVariationDistance_eq_half_integral_abs
        (measurable_gaussianPDFReal _ _) (measurable_gaussianPDFReal _ _)
        (integrable_gaussianPDFReal _ _) (integrable_gaussianPDFReal _ _)
        (gaussianPDFReal_nonneg _ _) (gaussianPDFReal_nonneg _ _)
        (integral_gaussianPDFReal_eq_one _ hn) (integral_gaussianPDFReal_eq_one _ hv0)]
    rfl
  rw [tendsto_congr' heq]
  simpa using hL1.const_mul (1 / 2 : ℝ)
/-- Gaussian laws depend weakly continuously on mean and variance.  This covers
both positive variance and the boundary `v = 0`, where the limit is a point mass. -/
theorem ex_10_3_2_gaussian_convergenceInDistribution
    (mn : ℕ → ℝ) (m : ℝ) (vn : ℕ → ℝ≥0) (v : ℝ≥0)
    (hm : Tendsto mn atTop (𝓝 m)) (hv : Tendsto vn atTop (𝓝 v)) :
    MeasuresConvergeInDistribution
      (fun n => gaussianProbabilityMeasure (mn n) (vn n))
      (gaussianProbabilityMeasure m v) := by
  unfold MeasuresConvergeInDistribution
  refine ProbabilityMeasure.tendsto_iff_tendsto_charFun.2 ?_
  intro t
  change Tendsto (fun n => charFun (gaussianReal (mn n) (vn n)) t) atTop
    (𝓝 (charFun (gaussianReal m v) t))
  simp_rw [charFun_gaussianReal]
  have hvR : Tendsto (fun n => (vn n : ℝ)) atTop (𝓝 (v : ℝ)) := NNReal.tendsto_coe.2 hv
  have hmC : Tendsto (fun n => (mn n : ℂ)) atTop (𝓝 (m : ℂ)) :=
    (Complex.continuous_ofReal.tendsto m).comp hm
  have hvC : Tendsto (fun n => ((vn n : ℝ) : ℂ)) atTop (𝓝 ((v : ℝ) : ℂ)) :=
    (Complex.continuous_ofReal.tendsto (v : ℝ)).comp hvR
  exact ((hmC.const_mul (t : ℂ)).mul_const Complex.I).sub
    ((hvC.mul_const ((t : ℂ) ^ 2)).div_const 2) |>.cexp

/-- At variance zero the Gaussian law is the Dirac point mass; only weak /
distributional convergence is asserted. -/
theorem ex_10_3_2_gaussian_zeroVariance_boundary
    (mn : ℕ → ℝ) (m : ℝ) (vn : ℕ → ℝ≥0)
    (hm : Tendsto mn atTop (𝓝 m)) (hv : Tendsto vn atTop (𝓝 0)) :
    MeasuresConvergeInDistribution
      (fun n => gaussianProbabilityMeasure (mn n) (vn n))
      ⟨Measure.dirac m, inferInstance⟩ := by
  simpa [gaussianProbabilityMeasure, gaussianReal_zero_var] using
    ex_10_3_2_gaussian_convergenceInDistribution mn m vn 0 hm hv


/-- If every approximating variance is positive while the limit variance is
zero, total-variation convergence to the point mass is impossible. -/
theorem ex_10_3_2_gaussian_zeroVariance_not_totalVariation
    (mn : ℕ → ℝ) (m : ℝ) (vn : ℕ → ℝ≥0)
    (hvn : ∀ᶠ n in atTop, vn n ≠ 0) :
    ¬ thm_14_4_totalVariationConvergence
      (fun n => gaussianProbabilityMeasure (mn n) (vn n))
      ⟨Measure.dirac m, inferInstance⟩ := by
  intro htv
  unfold thm_14_4_totalVariationConvergence at htv
  have hlt : ∀ᶠ n in atTop,
      totalVariationDistance
        (gaussianProbabilityMeasure (mn n) (vn n) : Measure ℝ)
        (Measure.dirac m) < (1 / 2 : ℝ) :=
    htv (Iio_mem_nhds (by norm_num))
  have hge : ∀ᶠ n in atTop, (1 : ℝ) ≤
      totalVariationDistance
        (gaussianProbabilityMeasure (mn n) (vn n) : Measure ℝ)
        (Measure.dirac m) := by
    filter_upwards [hvn] with n hn
    letI : NoAtoms (gaussianReal (mn n) (vn n)) := noAtoms_gaussianReal hn
    have hb := ex_10_3_1_totalVariationDistance_event_bound
      (gaussianReal (mn n) (vn n)) (Measure.dirac m) {m} (measurableSet_singleton m)
    simpa [gaussianProbabilityMeasure, Measure.real_def] using hb
  rcases (hlt.and hge).exists with ⟨n, hnlt, hnge⟩
  linarith
/-- Bundled delivery of Example 10.3.2's general density conclusions. -/
theorem ex_10_3_2
    (fn : ℕ → ℝ → ℝ) (f : ℝ → ℝ)
    (hfn : ∀ n, IsProbabilityDensity (fn n))
    (hf : IsProbabilityDensity f)
    (hae : ∀ᵐ x ∂volume, Tendsto (fun n => fn n x) atTop (𝓝 (f x))) :
    thm_14_4_totalVariationConvergence
        (fun n => densityProbabilityMeasure (fn n) (hfn n))
        (densityProbabilityMeasure f hf) ∧
      MeasuresConvergeInDistribution
        (fun n => densityProbabilityMeasure (fn n) (hfn n))
        (densityProbabilityMeasure f hf) :=
  ⟨ex_10_3_2_density_totalVariation fn f hfn hf hae,
    ex_10_3_2_density_convergenceInDistribution fn f hfn hf hae⟩
