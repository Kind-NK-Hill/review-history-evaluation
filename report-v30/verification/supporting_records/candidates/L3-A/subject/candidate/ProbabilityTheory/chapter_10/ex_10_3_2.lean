import Mathlib
import ProbabilityTheory.chapter_10.def_10_4
import ProbabilityTheory.chapter_10.def_10_5
import ProbabilityTheory.chapter_07.prob_7_6
import ProbabilityTheory.chapter_08.prob_8_7
import ProbabilityTheory.chapter_10.thm_10_6

open Filter MeasureTheory ProbabilityTheory Topology
open scoped ENNReal NNReal Topology

noncomputable section

/-- The probability law having the real density `f`. -/
def ex_10_3_2_densityLaw (f : ℝ → ℝ) (hf : IsProbabilityDensity f) :
    ProbabilityMeasure ℝ :=
  ⟨TVCore.densityMeasure f,
    TVCore.densityMeasure_isProbabilityMeasure
      (integrable_of_integral_eq_one hf.integral_eq_one)
      hf.nonneg hf.integral_eq_one⟩

theorem ex_10_3_2_l1
    (f : ℕ → ℝ → ℝ) (g : ℝ → ℝ)
    (hf : ∀ n, IsProbabilityDensity (f n))
    (hg : IsProbabilityDensity g)
    (hfg : ∀ᵐ x ∂volume, Tendsto (fun n => f n x) atTop (𝓝 (g x))) :
    Tendsto (fun n => ∫ x, |f n x - g x|) atTop (𝓝 0) := by
  apply prob_7_6 f g
  · exact fun n => (hf n).measurable
  · exact fun n => (hf n).nonneg
  · exact fun n => integrable_of_integral_eq_one (hf n).integral_eq_one
  · exact integrable_of_integral_eq_one hg.integral_eq_one
  · exact hfg
  · simpa only [(hf _).integral_eq_one, hg.integral_eq_one] using
      (tendsto_const_nhds : Tendsto (fun _ : ℕ => (1 : ℝ)) atTop (𝓝 1))

theorem ex_10_3_2_totalVariation
    (f : ℕ → ℝ → ℝ) (g : ℝ → ℝ)
    (hf : ∀ n, IsProbabilityDensity (f n))
    (hg : IsProbabilityDensity g)
    (hfg : ∀ᵐ x ∂volume, Tendsto (fun n => f n x) atTop (𝓝 (g x))) :
    MeasuresConvergeInTotalVariation
      (fun n => (ex_10_3_2_densityLaw (f n) (hf n) : Measure ℝ))
      (ex_10_3_2_densityLaw g hg : Measure ℝ) := by
  let hfi : ∀ n, Integrable (f n) volume :=
    fun n => integrable_of_integral_eq_one (hf n).integral_eq_one
  let hgi : Integrable g volume :=
    integrable_of_integral_eq_one hg.integral_eq_one
  refine ⟨fun n => (ex_10_3_2_densityLaw (f n) (hf n)).property,
    (ex_10_3_2_densityLaw g hg).property, ?_⟩
  have hL1 := ex_10_3_2_l1 f g hf hg hfg
  have heq : (fun n =>
      letI := (ex_10_3_2_densityLaw (f n) (hf n)).property
      letI := (ex_10_3_2_densityLaw g hg).property
      totalVariationDistance
        (ex_10_3_2_densityLaw (f n) (hf n) : Measure ℝ)
        (ex_10_3_2_densityLaw g hg : Measure ℝ)) =
      fun n => (1 / 2 : ℝ) * ∫ x, |f n x - g x| := by
    funext n
    change totalVariationDistance (TVCore.densityMeasure (f n))
      (TVCore.densityMeasure g) = _
    simpa [TVCore.densityDiff] using
      (TVCore.continuous_totalVariationDistance_eq_half_integral_abs
        (hf n).measurable hg.measurable (hfi n) hgi
        (hf n).nonneg hg.nonneg (hf n).integral_eq_one hg.integral_eq_one)
  rw [heq]
  simpa using (tendsto_const_nhds.mul hL1)

theorem ex_10_3_2
    (f : ℕ → ℝ → ℝ) (g : ℝ → ℝ)
    (hf : ∀ n, IsProbabilityDensity (f n))
    (hg : IsProbabilityDensity g)
    (hfg : ∀ᵐ x ∂volume, Tendsto (fun n => f n x) atTop (𝓝 (g x))) :
    MeasuresConvergeInDistribution
      (fun n => ex_10_3_2_densityLaw (f n) (hf n))
      (ex_10_3_2_densityLaw g hg) := by
  apply thm_10_6
  exact ex_10_3_2_totalVariation f g hf hg hfg

theorem ex_10_3_2_gaussianPDF_tendsto
    (m : ℕ → ℝ) (v : ℕ → ℝ≥0) (m₀ : ℝ) (v₀ : ℝ≥0)
    (hm : Tendsto m atTop (𝓝 m₀)) (hv : Tendsto v atTop (𝓝 v₀))
    (hv₀ : v₀ ≠ 0) (x : ℝ) :
    Tendsto (fun n => gaussianPDFReal (m n) (v n) x) atTop
      (𝓝 (gaussianPDFReal m₀ v₀ x)) := by
  unfold gaussianPDFReal
  have hvcoe : Tendsto (fun n => (v n : ℝ)) atTop (𝓝 (v₀ : ℝ)) := NNReal.tendsto_coe.2 hv
  have hprod : Tendsto (fun n => (2 : ℝ) * Real.pi * (v n : ℝ)) atTop
      (𝓝 ((2 : ℝ) * Real.pi * (v₀ : ℝ))) :=
    (tendsto_const_nhds.mul tendsto_const_nhds).mul hvcoe
  have hsqrt : Tendsto (fun n => √((2 : ℝ) * Real.pi * (v n : ℝ))) atTop
      (𝓝 (√((2 : ℝ) * Real.pi * (v₀ : ℝ)))) := hprod.sqrt
  have hsqrt_ne : √(2 * Real.pi * (v₀ : ℝ)) ≠ 0 := by
    positivity
  have hinv := hsqrt.inv₀ hsqrt_ne
  have hsub : Tendsto (fun n => x - m n) atTop (𝓝 (x - m₀)) :=
    tendsto_const_nhds.sub hm
  have hnum : Tendsto (fun n => -(x - m n) ^ 2) atTop
      (𝓝 (-(x - m₀) ^ 2)) := (hsub.pow 2).neg
  have hden : Tendsto (fun n => (2 : ℝ) * (v n : ℝ)) atTop
      (𝓝 ((2 : ℝ) * (v₀ : ℝ))) := tendsto_const_nhds.mul hvcoe
  have hden_ne : (2 : ℝ) * (v₀ : ℝ) ≠ 0 := by
    positivity
  have hquot := hnum.div hden hden_ne
  exact hinv.mul (Real.continuous_exp.continuousAt.tendsto.comp hquot)


/-- When the limiting variance is positive, Gaussian laws converge in total
variation by the density argument above. Initial zero variances are harmless,
since convergence to a positive variance makes them eventually nonzero. -/
theorem ex_10_3_2_gaussian_totalVariation
    (m : ℕ → ℝ) (v : ℕ → ℝ≥0) (m₀ : ℝ) (v₀ : ℝ≥0)
    (hm : Tendsto m atTop (nhds m₀)) (hv : Tendsto v atTop (nhds v₀))
    (hv₀ : v₀ ≠ 0) :
    MeasuresConvergeInTotalVariation
      (fun n => gaussianReal (m n) (v n)) (gaussianReal m₀ v₀) := by
  let f : ℕ → ℝ → ℝ := fun n =>
    if v n = 0 then gaussianPDFReal m₀ v₀ else gaussianPDFReal (m n) (v n)
  let g : ℝ → ℝ := gaussianPDFReal m₀ v₀
  have hf : ∀ n, IsProbabilityDensity (f n) := by
    intro n
    by_cases hn : v n = 0
    · simp only [f, hn, if_pos]
      exact ⟨measurable_gaussianPDFReal _ _, gaussianPDFReal_nonneg _ _,
        integral_gaussianPDFReal_eq_one _ hv₀⟩
    · simp only [f, hn, if_neg]
      exact ⟨measurable_gaussianPDFReal _ _, gaussianPDFReal_nonneg _ _,
        integral_gaussianPDFReal_eq_one _ hn⟩
  have hg : IsProbabilityDensity g :=
    ⟨measurable_gaussianPDFReal _ _, gaussianPDFReal_nonneg _ _,
      integral_gaussianPDFReal_eq_one _ hv₀⟩
  have hev : ∀ᶠ n in atTop, v n ≠ 0 :=
    (eventually_ne_nhds hv₀).filter_mono hv
  have hfg : ∀ᵐ x ∂volume, Tendsto (fun n => f n x) atTop (nhds (g x)) := by
    filter_upwards with x
    apply (ex_10_3_2_gaussianPDF_tendsto m v m₀ v₀ hm hv hv₀ x).congr'
    filter_upwards [hev] with n hn
    simp [f, g, hn]
  rcases ex_10_3_2_totalVariation f g hf hg hfg with ⟨hPf, hPg, hlim⟩
  refine ⟨fun n => inferInstance, inferInstance, ?_⟩
  have htarget : TVCore.densityMeasure g = gaussianReal m₀ v₀ := by
    rw [TVCore.densityMeasure, gaussianReal_of_var_ne_zero _ hv₀]
    exact withDensity_congr_ae (Filter.Eventually.of_forall fun x =>
      congr_fun (gaussianPDF_def m₀ v₀).symm x)
  apply hlim.congr'
  filter_upwards [hev] with n hn
  change totalVariationDistance (TVCore.densityMeasure (f n))
      (TVCore.densityMeasure g) =
    totalVariationDistance (gaussianReal (m n) (v n))
      (gaussianReal m₀ v₀)
  have hnmeasure : TVCore.densityMeasure (f n) = gaussianReal (m n) (v n) := by
    rw [TVCore.densityMeasure, gaussianReal_of_var_ne_zero _ hn]
    simp only [f, hn, if_neg]
    exact withDensity_congr_ae (Filter.Eventually.of_forall fun x =>
      congr_fun (gaussianPDF_def (m n) (v n)).symm x)
  rw [hnmeasure, htarget]

theorem ex_10_3_2_gaussian_distribution
    (m : ℕ → ℝ) (v : ℕ → ℝ≥0) (m₀ : ℝ) (v₀ : ℝ≥0)
    (hm : Tendsto m atTop (𝓝 m₀)) (hv : Tendsto v atTop (𝓝 v₀)) :
    MeasuresConvergeInDistribution
      (fun n => ⟨gaussianReal (m n) (v n), inferInstance⟩)
      ⟨gaussianReal m₀ v₀, inferInstance⟩ := by
  apply ProbabilityMeasure.tendsto_iff_tendsto_charFun.2
  intro t
  change Tendsto (fun n => charFun (gaussianReal (m n) (v n)) t) atTop
    (𝓝 (charFun (gaussianReal m₀ v₀) t))
  simp only [charFun_gaussianReal]
  have hmC : Tendsto (fun n => (m n : ℂ)) atTop (𝓝 (m₀ : ℂ)) :=
    Complex.continuous_ofReal.continuousAt.tendsto.comp hm
  have hvC : Tendsto (fun n => ((v n : ℝ) : ℂ)) atTop (𝓝 ((v₀ : ℝ) : ℂ)) :=
    Complex.continuous_ofReal.continuousAt.tendsto.comp (NNReal.tendsto_coe.2 hv)
  apply Complex.continuous_exp.continuousAt.tendsto.comp
  exact ((tendsto_const_nhds.mul hmC).mul tendsto_const_nhds).sub
    ((hvC.mul tendsto_const_nhds).div_const 2)

theorem ex_10_3_2_gaussian_zero_variance
    (m : ℕ → ℝ) (v : ℕ → ℝ≥0) (m₀ : ℝ)
    (hm : Tendsto m atTop (𝓝 m₀)) (hv : Tendsto v atTop (𝓝 0)) :
    MeasuresConvergeInDistribution
      (fun n => ⟨gaussianReal (m n) (v n), inferInstance⟩)
      ⟨Measure.dirac m₀, inferInstance⟩ := by
  simpa using ex_10_3_2_gaussian_distribution m v m₀ 0 hm hv
