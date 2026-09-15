import ProbabilityTheory.chapter_08.def_8_5
import ProbabilityTheory.common_support.ch8_discrete_pmf_core
import Mathlib

open Real MeasureTheory Set
open scoped BigOperators ENNReal NNReal

noncomputable section

/-- The analytic heart of Theorem 8.6. The event `{0 ≤ h}` attains the supremum. -/
theorem sSup_abs_setIntegral_eq_half_integral_abs
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) (h : Ω → ℝ)
    (hhm : Measurable h) (hhi : Integrable h μ) (hzero : ∫ x, h x ∂μ = 0) :
    sSup {d : ℝ | ∃ A : Set Ω, MeasurableSet A ∧ d = |∫ x in A, h x ∂μ|} =
      (1 / 2 : ℝ) * ∫ x, |h x| ∂μ := by
  let S : Set Ω := {x | 0 ≤ h x}
  have hS : MeasurableSet S := measurableSet_le measurable_const hhm
  have hsplit (A : Set Ω) (hA : MeasurableSet A) :
      ∫ x in A, h x ∂μ + ∫ x in Aᶜ, h x ∂μ = 0 := by
    simpa [hzero] using integral_add_compl hA hhi
  have hbound (A : Set Ω) (hA : MeasurableSet A) :
      |∫ x in A, h x ∂μ| ≤ (1 / 2 : ℝ) * ∫ x, |h x| ∂μ := by
    have ha : |∫ x in A, h x ∂μ| ≤ ∫ x in A, |h x| ∂μ :=
      abs_integral_le_integral_abs
    have hac : |∫ x in Aᶜ, h x ∂μ| ≤ ∫ x in Aᶜ, |h x| ∂μ :=
      abs_integral_le_integral_abs
    have habsSplit := integral_add_compl hA hhi.abs
    have hneg : ∫ x in Aᶜ, h x ∂μ = -(∫ x in A, h x ∂μ) := by
      linarith [hsplit A hA]
    rw [hneg, abs_neg] at hac
    linarith
  have hSabs : ∫ x in S, |h x| ∂μ = ∫ x in S, h x ∂μ := by
    apply setIntegral_congr_fun hS
    intro x hx
    exact abs_of_nonneg hx
  have hScabs : ∫ x in Sᶜ, |h x| ∂μ = -(∫ x in Sᶜ, h x ∂μ) := by
    rw [← integral_neg]
    apply setIntegral_congr_fun hS.compl
    intro x hx
    exact abs_of_nonpos (le_of_not_ge hx)
  have hpos : 0 ≤ ∫ x in S, h x ∂μ := by
    rw [← integral_indicator hS]
    apply integral_nonneg
    intro x
    by_cases hx : x ∈ S
    · have hxS := hx
      change 0 ≤ h x at hx
      simp [Set.indicator, hxS, hx]
    · simp [Set.indicator, hx]
  have hattain : |∫ x in S, h x ∂μ| = (1 / 2 : ℝ) * ∫ x, |h x| ∂μ := by
    have habsSplit := integral_add_compl hS hhi.abs
    have hzSplit := hsplit S hS
    rw [abs_of_nonneg hpos]
    linarith [hSabs, hScabs]
  apply le_antisymm
  · apply csSup_le
    · exact ⟨0, ∅, MeasurableSet.empty, by simp⟩
    · intro d hd
      rcases hd with ⟨A, hA, rfl⟩
      exact hbound A hA
  · apply le_csSup
    · rw [bddAbove_def]
      exact ⟨(1 / 2 : ℝ) * ∫ x, |h x| ∂μ, fun d hd => by
        rcases hd with ⟨A, hA, rfl⟩
        exact hbound A hA⟩
    · exact ⟨S, hS, hattain.symm⟩

/-- Total variation for two real densities represented by set integrals. -/
theorem totalVariationDistance_eq_half_integral_abs_of_densities
    {Ω : Type*} [MeasurableSpace Ω] (P Q μ : Measure Ω) (f g : Ω → ℝ)
    [IsProbabilityMeasure P] [IsProbabilityMeasure Q]
    (hfm : Measurable f) (hgm : Measurable g)
    (hfi : Integrable f μ) (hgi : Integrable g μ)
    (hP : ∀ A : Set Ω, MeasurableSet A → P.real A = ∫ x in A, f x ∂μ)
    (hQ : ∀ A : Set Ω, MeasurableSet A → Q.real A = ∫ x in A, g x ∂μ) :
    totalVariationDistance P Q = (1 / 2 : ℝ) * ∫ x, |f x - g x| ∂μ := by
  have hzero : ∫ x, (f x - g x) ∂μ = 0 := by
    rw [integral_sub hfi hgi]
    have hp := hP univ MeasurableSet.univ
    have hq := hQ univ MeasurableSet.univ
    simp only [setIntegral_univ, probReal_univ] at hp hq
    linarith
  unfold totalVariationDistance
  have heq :
      {d : ℝ | ∃ A : Set Ω, MeasurableSet A ∧ d = |P.real A - Q.real A|} =
      {d : ℝ | ∃ A : Set Ω, MeasurableSet A ∧ d = |∫ x in A, f x - g x ∂μ|} := by
    ext d
    constructor <;> rintro ⟨A, hA, rfl⟩
    · refine ⟨A, hA, ?_⟩
      rw [hP A hA, hQ A hA, integral_sub hfi.integrableOn hgi.integrableOn]
    · refine ⟨A, hA, ?_⟩
      rw [hP A hA, hQ A hA, integral_sub hfi.integrableOn hgi.integrableOn]
  rw [heq]
  exact sSup_abs_setIntegral_eq_half_integral_abs μ (fun x => f x - g x)
    (hfm.sub hgm) (hfi.sub hgi) hzero


private lemma withDensity_ofReal_real_apply
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) (f : Ω → ℝ)
    (hfi : Integrable f μ) (hfn : ∀ x, 0 ≤ f x) {A : Set Ω} (hA : MeasurableSet A) :
    (μ.withDensity fun x => ENNReal.ofReal (f x)).real A = ∫ x in A, f x ∂μ := by
  rw [measureReal_def, withDensity_apply _ hA,
    ← ofReal_integral_eq_lintegral_ofReal hfi.integrableOn]
  · rw [ENNReal.toReal_ofReal]
    exact integral_nonneg fun x => hfn x
  · exact Filter.Eventually.of_forall fun x => hfn x

/-- The common-dominating-measure version of the half-integral formula.  In particular,
setting `Ω = ℝ` and `μ = volume` gives the usual formula for real probability densities. -/
theorem totalVariationDistance_withDensity_eq_half_integral_abs
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) (f g : Ω → ℝ)
    (hfm : Measurable f) (hgm : Measurable g)
    (hfi : Integrable f μ) (hgi : Integrable g μ)
    (hfn : ∀ x, 0 ≤ f x) (hgn : ∀ x, 0 ≤ g x)
    (hf_one : ∫ x, f x ∂μ = 1) (hg_one : ∫ x, g x ∂μ = 1) :
    totalVariationDistance
        (μ.withDensity fun x => ENNReal.ofReal (f x))
        (μ.withDensity fun x => ENNReal.ofReal (g x)) =
      (1 / 2 : ℝ) * ∫ x, |f x - g x| ∂μ := by
  let P := μ.withDensity fun x => ENNReal.ofReal (f x)
  let Q := μ.withDensity fun x => ENNReal.ofReal (g x)
  letI : IsProbabilityMeasure P := ⟨by
    change (μ.withDensity fun x => ENNReal.ofReal (f x)) univ = 1
    rw [withDensity_apply _ MeasurableSet.univ, Measure.restrict_univ,
      ← ofReal_integral_eq_lintegral_ofReal hfi]
    · simp [hf_one]
    · exact Filter.Eventually.of_forall hfn⟩
  letI : IsProbabilityMeasure Q := ⟨by
    change (μ.withDensity fun x => ENNReal.ofReal (g x)) univ = 1
    rw [withDensity_apply _ MeasurableSet.univ, Measure.restrict_univ,
      ← ofReal_integral_eq_lintegral_ofReal hgi]
    · simp [hg_one]
    · exact Filter.Eventually.of_forall hgn⟩
  exact totalVariationDistance_eq_half_integral_abs_of_densities P Q μ f g
    hfm hgm hfi hgi
    (fun A hA => withDensity_ofReal_real_apply μ f hfi hfn hA)
    (fun A hA => withDensity_ofReal_real_apply μ g hgi hgn hA)


private lemma pmf_toReal_integrable_count
    {Ω : Type*} [MeasurableSpace Ω] [MeasurableSingletonClass Ω] (p : PMF Ω) :
    Integrable (fun x => (p x).toReal) Measure.count := by
  rw [integrable_count_iff]
  have hs : Summable (fun x => (p x).toReal) :=
    ENNReal.summable_toReal p.tsum_coe_ne_top
  simpa only [Real.norm_eq_abs, abs_of_nonneg ENNReal.toReal_nonneg] using hs

private lemma integral_pmf_toReal_count_eq_one
    {Ω : Type*} [MeasurableSpace Ω] [MeasurableSingletonClass Ω] [Countable Ω]
    (p : PMF Ω) : ∫ x, (p x).toReal ∂Measure.count = 1 := by
  rw [integral_countable (pmf_toReal_integrable_count p)]
  simp only [Measure.real]
  simp
  rw [← ENNReal.tsum_toReal_eq (fun x => p.apply_ne_top x), p.tsum_coe]
  norm_num

private lemma count_withDensity_pmf_toReal
    {Ω : Type*} [MeasurableSpace Ω] [MeasurableSingletonClass Ω] [Countable Ω]
    (p : PMF Ω) :
    Measure.count.withDensity (fun x => ENNReal.ofReal (p x).toReal) = p.toMeasure := by
  apply Measure.ext_of_singleton
  intro x
  rw [PMF.toMeasure_apply_singleton p x (measurableSet_singleton x)]
  simp [withDensity_apply, p.apply_ne_top]

/-- Theorem 8.6 on an arbitrary countable measurable space with measurable singletons. -/
theorem totalVariationDistance_pmf_eq_half_tsum
    {Ω : Type*} [MeasurableSpace Ω] [MeasurableSingletonClass Ω] [Countable Ω]
    (p q : PMF Ω) :
    totalVariationDistance p.toMeasure q.toMeasure =
      (1 / 2 : ℝ) * ∑' x, |(p x).toReal - (q x).toReal| := by
  let f : Ω → ℝ := fun x => (p x).toReal
  let g : Ω → ℝ := fun x => (q x).toReal
  have hfi : Integrable f Measure.count := pmf_toReal_integrable_count p
  have hgi : Integrable g Measure.count := pmf_toReal_integrable_count q
  have h := totalVariationDistance_withDensity_eq_half_integral_abs
    Measure.count f g (measurable_of_countable f) (measurable_of_countable g) hfi hgi
    (fun x => ENNReal.toReal_nonneg) (fun x => ENNReal.toReal_nonneg)
    (integral_pmf_toReal_count_eq_one p) (integral_pmf_toReal_count_eq_one q)
  rw [count_withDensity_pmf_toReal p, count_withDensity_pmf_toReal q] at h
  have habsi : Integrable (fun x => |f x - g x|) Measure.count := (hfi.sub hgi).abs
  rw [integral_countable habsi] at h
  simpa [f, g] using h

/-- The natural-number probability-measure statement appearing in Theorem 8.6. -/
theorem thm_8_6_discrete (P Q : Measure ℕ)
    [IsProbabilityMeasure P] [IsProbabilityMeasure Q] :
    totalVariationDistance P Q =
      (1 / 2 : ℝ) * ∑' i : ℕ, |P.real {i} - Q.real {i}| := by
  have hp : P.toPMF.toMeasure = P := by
    apply Measure.ext_of_singleton
    intro i
    rw [PMF.toMeasure_apply_singleton _ i (measurableSet_singleton i), Measure.toPMF_apply]
  have hq : Q.toPMF.toMeasure = Q := by
    apply Measure.ext_of_singleton
    intro i
    rw [PMF.toMeasure_apply_singleton _ i (measurableSet_singleton i), Measure.toPMF_apply]
  simpa [hp, hq, Measure.toPMF_apply, measureReal_def] using
    (totalVariationDistance_pmf_eq_half_tsum P.toPMF Q.toPMF)

/-- The real-line density formula from Theorem 8.6 (Lebesgue measure is `volume`). -/
theorem thm_8_6_continuous (f g : ℝ → ℝ)
    (hfm : Measurable f) (hgm : Measurable g)
    (hfi : Integrable f) (hgi : Integrable g)
    (hfn : ∀ x, 0 ≤ f x) (hgn : ∀ x, 0 ≤ g x)
    (hf_one : ∫ x, f x = 1) (hg_one : ∫ x, g x = 1) :
    totalVariationDistance
        (volume.withDensity fun x => ENNReal.ofReal (f x))
        (volume.withDensity fun x => ENNReal.ofReal (g x)) =
      (1 / 2 : ℝ) * ∫ x, |f x - g x| :=
  totalVariationDistance_withDensity_eq_half_integral_abs volume f g
    hfm hgm hfi hgi hfn hgn hf_one hg_one
