import Mathlib

open MeasureTheory Set


noncomputable section

namespace Prob87


/-- The measure having the nonnegative real density `h` with respect to Lebesgue measure. -/
noncomputable def densityMeasure (h : ℝ → ℝ) : Measure ℝ :=
  volume.withDensity (fun x => ENNReal.ofReal (h x))

def densityDiff (f g : ℝ → ℝ) (x : ℝ) : ℝ := f x - g x

def densityPos (f g : ℝ → ℝ) (x : ℝ) : ℝ := max (densityDiff f g x) 0

def densityPositiveSet (f g : ℝ → ℝ) : Set ℝ := {x | 0 < densityDiff f g x}

private lemma densityPos_eq_half_abs_add {f g : ℝ → ℝ} (x : ℝ) :
    densityPos f g x = (|densityDiff f g x| + densityDiff f g x) / 2 := by
  by_cases hx : 0 ≤ densityDiff f g x
  · rw [densityPos, max_eq_left hx, abs_of_nonneg hx]
    ring
  · have hx' : densityDiff f g x < 0 := lt_of_not_ge hx
    rw [densityPos, max_eq_right (le_of_lt hx'), abs_of_neg hx']
    ring

private lemma integrable_densityPos {f g : ℝ → ℝ}
    (hf_int : Integrable f volume) (hg_int : Integrable g volume) :
    Integrable (densityPos f g) volume := by
  have hdiff : Integrable (densityDiff f g) volume := hf_int.sub hg_int
  have habs : Integrable (fun x => |densityDiff f g x|) volume := hdiff.norm
  have hadd : Integrable (fun x => |densityDiff f g x| + densityDiff f g x) volume :=
    habs.add hdiff
  rw [show densityPos f g = fun x => (|densityDiff f g x| + densityDiff f g x) / 2 by
    funext x; exact densityPos_eq_half_abs_add x]
  exact hadd.div_const 2

private lemma densityPos_integral_eq_half_abs
    {f g : ℝ → ℝ} (hf_int : Integrable f volume) (hg_int : Integrable g volume)
    (hf_prob : ∫ x, f x = 1) (hg_prob : ∫ x, g x = 1) :
    ∫ x, densityPos f g x = (1 / 2 : ℝ) * ∫ x, |densityDiff f g x| := by
  have hdiff : Integrable (densityDiff f g) volume := hf_int.sub hg_int
  have habs : Integrable (fun x => |densityDiff f g x|) volume := hdiff.norm
  calc
    ∫ x, densityPos f g x = ∫ x, (|densityDiff f g x| + densityDiff f g x) / 2 := by
      exact integral_congr_ae (Filter.Eventually.of_forall (fun x => densityPos_eq_half_abs_add x))
    _ = ((∫ x, |densityDiff f g x|) + ∫ x, densityDiff f g x) / 2 := by
      rw [MeasureTheory.integral_div 2, MeasureTheory.integral_add habs hdiff]
    _ = ((∫ x, |densityDiff f g x|) + ((∫ x, f x) - ∫ x, g x)) / 2 := by
      rw [show (∫ x, densityDiff f g x) = (∫ x, f x) - ∫ x, g x by
        exact MeasureTheory.integral_sub hf_int hg_int]
    _ = (1 / 2 : ℝ) * ∫ x, |densityDiff f g x| := by rw [hf_prob, hg_prob]; ring

private lemma densityMeasure_apply_univ_of_integral
    {h : ℝ → ℝ} (hh_int : Integrable h volume) (hh_nonneg : ∀ x, 0 ≤ h x) :
    densityMeasure h univ = ENNReal.ofReal (∫ x, h x) := by
  rw [densityMeasure, withDensity_apply' _ univ, Measure.restrict_univ]
  exact (MeasureTheory.ofReal_integral_eq_lintegral_ofReal hh_int
    (Filter.Eventually.of_forall hh_nonneg)).symm

private lemma densityMeasure_add
    {a b h : ℝ → ℝ} (ha_meas : Measurable a)
    (ha_nonneg : ∀ x, 0 ≤ a x) (hb_nonneg : ∀ x, 0 ≤ b x)
    (hab : ∀ x, a x + b x = h x) :
    densityMeasure a + densityMeasure b = densityMeasure h := by
  rw [densityMeasure, densityMeasure, densityMeasure, ← withDensity_add_left]
  · apply withDensity_congr_ae
    filter_upwards [] with x
    simp only [Pi.add_apply]
    rw [← ENNReal.ofReal_add (ha_nonneg x) (hb_nonneg x), hab x]
  · exact ha_meas.ennreal_ofReal

private lemma min_integrable {f g : ℝ → ℝ}
    (hf_int : Integrable f volume) (hg_int : Integrable g volume) :
    Integrable (fun x => min (f x) (g x)) volume := by
  have heq : (fun x => min (f x) (g x)) = fun x => f x - densityPos f g x := by
    funext x
    by_cases h : f x ≤ g x
    · simp [densityPos, densityDiff, min_eq_left h, max_eq_right (sub_nonpos.mpr h)]
    · have h' : g x ≤ f x := le_of_not_ge h
      simp [densityPos, densityDiff, min_eq_right h', max_eq_left (sub_nonneg.mpr h')]
  rw [heq]
  exact hf_int.sub (integrable_densityPos hf_int hg_int)

private lemma residualX_eq_pos (f g : ℝ → ℝ) (x : ℝ) :
    f x - min (f x) (g x) = densityPos f g x := by
  simp only [densityPos, densityDiff]
  by_cases h : f x ≤ g x
  · rw [min_eq_left h, max_eq_right (sub_nonpos.mpr h), sub_self]
  · rw [min_eq_right (le_of_not_ge h), max_eq_left]
    linarith

private lemma residualY_eq_pos (f g : ℝ → ℝ) (x : ℝ) :
    g x - min (f x) (g x) = densityPos g f x := by
  rw [min_comm]
  exact residualX_eq_pos g f x

private lemma min_add_residualX (f g : ℝ → ℝ) (x : ℝ) :
    min (f x) (g x) + (f x - min (f x) (g x)) = f x := by ring

private lemma min_add_residualY (f g : ℝ → ℝ) (x : ℝ) :
    min (f x) (g x) + (g x - min (f x) (g x)) = g x := by ring

private lemma residualX_nonneg (f g : ℝ → ℝ) (x : ℝ) :
    0 ≤ f x - min (f x) (g x) := sub_nonneg.mpr (min_le_left _ _)

private lemma residualY_nonneg (f g : ℝ → ℝ) (x : ℝ) :
    0 ≤ g x - min (f x) (g x) := sub_nonneg.mpr (min_le_right _ _)

private lemma integral_residualX
    {f g : ℝ → ℝ} (hf_int : Integrable f volume) (hg_int : Integrable g volume)
    (hf_prob : ∫ x, f x = 1) (hg_prob : ∫ x, g x = 1) :
    ∫ x, (f x - min (f x) (g x)) =
      (1 / 2 : ℝ) * ∫ x, |densityDiff f g x| := by
  rw [MeasureTheory.integral_congr_ae (Filter.Eventually.of_forall (residualX_eq_pos f g))]
  exact densityPos_integral_eq_half_abs hf_int hg_int hf_prob hg_prob

private lemma integral_residualY
    {f g : ℝ → ℝ} (hf_int : Integrable f volume) (hg_int : Integrable g volume)
    (hf_prob : ∫ x, f x = 1) (hg_prob : ∫ x, g x = 1) :
    ∫ x, (g x - min (f x) (g x)) =
      (1 / 2 : ℝ) * ∫ x, |densityDiff f g x| := by
  rw [MeasureTheory.integral_congr_ae (Filter.Eventually.of_forall (residualY_eq_pos f g))]
  rw [densityPos_integral_eq_half_abs hg_int hf_int hg_prob hf_prob]
  have habs : (∫ x, |densityDiff g f x|) = ∫ x, |densityDiff f g x| := by
    apply MeasureTheory.integral_congr_ae
    filter_upwards [] with x
    simp [densityDiff, abs_sub_comm]
  rw [habs]

private lemma integral_min
    {f g : ℝ → ℝ} (hf_int : Integrable f volume) (hg_int : Integrable g volume)
    (hf_prob : ∫ x, f x = 1) (hg_prob : ∫ x, g x = 1) :
    ∫ x, min (f x) (g x) =
      1 - (1 / 2 : ℝ) * ∫ x, |densityDiff f g x| := by
  have hr_int : Integrable (fun x => f x - min (f x) (g x)) volume :=
    hf_int.sub (min_integrable hf_int hg_int)
  have hsum := MeasureTheory.integral_add (min_integrable hf_int hg_int) hr_int
  rw [MeasureTheory.integral_congr_ae (Filter.Eventually.of_forall (min_add_residualX f g)), hf_prob,
    integral_residualX hf_int hg_int hf_prob hg_prob] at hsum
  linarith

private lemma ae_residualX_strict
    {f g : ℝ → ℝ} (hf_meas : Measurable f) (hg_meas : Measurable g) :
    ∀ᵐ x ∂densityMeasure (fun x => f x - min (f x) (g x)), g x < f x := by
  rw [densityMeasure, ae_withDensity_iff' ((hf_meas.sub (hf_meas.min hg_meas)).ennreal_ofReal.aemeasurable)]
  filter_upwards [] with x hx
  have hr : 0 < f x - min (f x) (g x) := ENNReal.ofReal_pos.mp (bot_lt_iff_ne_bot.mpr hx)
  by_contra h
  rw [min_eq_left (le_of_not_gt h)] at hr
  linarith

private lemma ae_residualY_strict
    {f g : ℝ → ℝ} (hf_meas : Measurable f) (hg_meas : Measurable g) :
    ∀ᵐ x ∂densityMeasure (fun x => g x - min (f x) (g x)), f x < g x := by
  rw [densityMeasure, ae_withDensity_iff' ((hg_meas.sub (hf_meas.min hg_meas)).ennreal_ofReal.aemeasurable)]
  filter_upwards [] with x hx
  have hr : 0 < g x - min (f x) (g x) := ENNReal.ofReal_pos.mp (bot_lt_iff_ne_bot.mpr hx)
  by_contra h
  rw [min_eq_right (le_of_not_gt h)] at hr
  linarith

/-- The endpoint-safe maximal coupling associated to two probability densities. -/

private lemma densityPositiveSet_measurable {f g : ℝ → ℝ}
    (hf_meas : Measurable f) (hg_meas : Measurable g) :
    MeasurableSet (densityPositiveSet f g) := by
  simpa [densityPositiveSet, densityDiff, sub_pos] using measurableSet_lt hg_meas hf_meas

private lemma densityMeasure_real_apply
    {f : ℝ → ℝ} (hf_int : Integrable f volume) (hf_nonneg : ∀ x, 0 ≤ f x)
    (s : Set ℝ) (hs : MeasurableSet s) :
    (densityMeasure f).real s = ∫ x in s, f x := by
  rw [densityMeasure, Measure.real_def, withDensity_apply _ hs]
  have hEq : ENNReal.ofReal (∫ x in s, f x) = ∫⁻ x in s, ENNReal.ofReal (f x) := by
    exact MeasureTheory.ofReal_integral_eq_lintegral_ofReal hf_int.restrict
      (Filter.Eventually.of_forall hf_nonneg)
  have hnonneg : 0 ≤ ∫ x in s, f x := integral_nonneg hf_nonneg
  simpa [ENNReal.toReal_ofReal hnonneg] using (congrArg ENNReal.toReal hEq).symm

private lemma densityPositiveSet_real_diff_eq_half_abs
    {f g : ℝ → ℝ} (hf_meas : Measurable f) (hg_meas : Measurable g)
    (hf_int : Integrable f volume) (hg_int : Integrable g volume)
    (hf_nonneg : ∀ x, 0 ≤ f x) (hg_nonneg : ∀ x, 0 ≤ g x)
    (hf_prob : ∫ x, f x = 1) (hg_prob : ∫ x, g x = 1) :
    (densityMeasure f).real (densityPositiveSet f g) -
      (densityMeasure g).real (densityPositiveSet f g) =
      (1 / 2 : ℝ) * ∫ x, |densityDiff f g x| := by
  let A := densityPositiveSet f g
  have hA : MeasurableSet A := densityPositiveSet_measurable hf_meas hg_meas
  rw [densityMeasure_real_apply hf_int hf_nonneg A hA,
    densityMeasure_real_apply hg_int hg_nonneg A hA,
    ← MeasureTheory.integral_sub (hf_int.restrict) (hg_int.restrict),
    ← MeasureTheory.integral_indicator hA]
  rw [show A.indicator (fun x => f x - g x) = densityPos f g by
    funext x
    by_cases hx : x ∈ A
    · have hpos : 0 < f x - g x := by simpa [A, densityPositiveSet, densityDiff] using hx
      simp [Set.indicator_of_mem hx, densityPos, densityDiff, max_eq_left hpos.le]
    · have hnonpos : f x - g x ≤ 0 := by
        simpa [A, densityPositiveSet, densityDiff] using hx
      simp [hx, densityPos, densityDiff, max_eq_right hnonpos]]
  exact densityPos_integral_eq_half_abs hf_int hg_int hf_prob hg_prob

lemma coupling_disagreement_lower_bound
    {f g : ℝ → ℝ} (hf_meas : Measurable f) (hg_meas : Measurable g)
    (hf_int : Integrable f volume) (hg_int : Integrable g volume)
    (hf_nonneg : ∀ x, 0 ≤ f x) (hg_nonneg : ∀ x, 0 ≤ g x)
    (hf_prob : ∫ x, f x = 1) (hg_prob : ∫ x, g x = 1)
    (Γ : Measure (ℝ × ℝ)) [IsProbabilityMeasure Γ]
    (hfst : Measure.map Prod.fst Γ = densityMeasure f)
    (hsnd : Measure.map Prod.snd Γ = densityMeasure g) :
    (1 / 2 : ℝ) * ∫ x, |densityDiff f g x| ≤ Γ.real {z | z.1 ≠ z.2} := by
  let A := densityPositiveSet f g
  let S : Set (ℝ × ℝ) := Prod.fst ⁻¹' A
  let T : Set (ℝ × ℝ) := Prod.snd ⁻¹' A
  let N : Set (ℝ × ℝ) := {z | z.1 ≠ z.2}
  have hA : MeasurableSet A := densityPositiveSet_measurable hf_meas hg_meas
  have hS : MeasurableSet S := measurable_fst hA
  have hT : MeasurableSet T := measurable_snd hA
  have hN : MeasurableSet N := by
    have : N = (diagonal ℝ)ᶜ := by ext z; simp [N, diagonal]
    rw [this]
    exact measurableSet_diagonal.compl
  have hsubset : S ⊆ T ∪ N := by
    intro z hz
    by_cases hzt : z ∈ T
    · exact Or.inl hzt
    · right
      intro heq
      apply hzt
      change z.2 ∈ A
      change z.1 ∈ A at hz
      rw [← heq]
      exact hz
  have hmeasure : Γ S ≤ Γ T + Γ N :=
    (measure_mono hsubset).trans (measure_union_le T N)
  have hreal : Γ.real S ≤ Γ.real T + Γ.real N := by
    rw [Measure.real_def, Measure.real_def, Measure.real_def,
      ← ENNReal.toReal_add (measure_ne_top Γ T) (measure_ne_top Γ N)]
    exact ENNReal.toReal_mono (by finiteness) hmeasure
  have hfre : (densityMeasure f).real A = Γ.real S := by
    change (densityMeasure f A).toReal = (Γ (Prod.fst ⁻¹' A)).toReal
    rw [← hfst, Measure.map_apply measurable_fst hA]
  have hgre : (densityMeasure g).real A = Γ.real T := by
    change (densityMeasure g A).toReal = (Γ (Prod.snd ⁻¹' A)).toReal
    rw [← hsnd, Measure.map_apply measurable_snd hA]
  rw [← densityPositiveSet_real_diff_eq_half_abs hf_meas hg_meas hf_int hg_int
    hf_nonneg hg_nonneg hf_prob hg_prob]
  rw [hfre, hgre]
  linarith
theorem exists_maximalCoupling
    {f g : ℝ → ℝ} (hf_meas : Measurable f) (hg_meas : Measurable g)
    (hf_int : Integrable f volume) (hg_int : Integrable g volume)
    (hf_nonneg : ∀ x, 0 ≤ f x) (hg_nonneg : ∀ x, 0 ≤ g x)
    (hf_prob : ∫ x, f x = 1) (hg_prob : ∫ x, g x = 1) :
    let p := (1 / 2 : ℝ) * ∫ x, |densityDiff f g x|
    ∃ Γ : Measure (ℝ × ℝ),
      IsProbabilityMeasure Γ ∧
      Measure.map Prod.fst Γ = densityMeasure f ∧
      Measure.map Prod.snd Γ = densityMeasure g ∧
      Γ.real {z | z.1 ≠ z.2} = p ∧
      ∀ Γ' : Measure (ℝ × ℝ), IsProbabilityMeasure Γ' →
        Measure.map Prod.fst Γ' = densityMeasure f →
        Measure.map Prod.snd Γ' = densityMeasure g →
        p ≤ Γ'.real {z | z.1 ≠ z.2} := by
  let p : ℝ := (1 / 2 : ℝ) * ∫ x, |densityDiff f g x|
  let c : ℝ → ℝ := fun x => min (f x) (g x)
  let rX : ℝ → ℝ := fun x => f x - c x
  let rY : ℝ → ℝ := fun x => g x - c x
  let C : Measure ℝ := densityMeasure c
  let RX : Measure ℝ := densityMeasure rX
  let RY : Measure ℝ := densityMeasure rY
  let D : ℝ → ℝ × ℝ := fun x => (x, x)
  let N : Set (ℝ × ℝ) := {z | z.1 ≠ z.2}
  have hc_meas : Measurable c := hf_meas.min hg_meas
  have hrX_meas : Measurable rX := hf_meas.sub hc_meas
  have hrY_meas : Measurable rY := hg_meas.sub hc_meas
  have hc_int : Integrable c volume := min_integrable hf_int hg_int
  have hrX_int : Integrable rX volume := hf_int.sub hc_int
  have hrY_int : Integrable rY volume := hg_int.sub hc_int
  have hc_nonneg : ∀ x, 0 ≤ c x := fun x => le_min (hf_nonneg x) (hg_nonneg x)
  have hrX_nonneg : ∀ x, 0 ≤ rX x := residualX_nonneg f g
  have hrY_nonneg : ∀ x, 0 ≤ rY x := residualY_nonneg f g
  have hp_nonneg : 0 ≤ p := by
    rw [show p = ∫ x, rX x by
      exact (integral_residualX hf_int hg_int hf_prob hg_prob).symm]
    exact integral_nonneg hrX_nonneg
  have hp_le_one : p ≤ 1 := by
    have hcm : 0 ≤ ∫ x, c x := integral_nonneg hc_nonneg
    rw [integral_min hf_int hg_int hf_prob hg_prob] at hcm
    change 0 ≤ 1 - p at hcm
    linarith
  have hCmass : C univ = ENNReal.ofReal (1 - p) := by
    rw [show C = densityMeasure c by rfl, densityMeasure_apply_univ_of_integral hc_int hc_nonneg]
    congr 1
    exact integral_min hf_int hg_int hf_prob hg_prob
  have hRXmass : RX univ = ENNReal.ofReal p := by
    rw [show RX = densityMeasure rX by rfl, densityMeasure_apply_univ_of_integral hrX_int hrX_nonneg]
    congr 1
    exact integral_residualX hf_int hg_int hf_prob hg_prob
  have hRYmass : RY univ = ENNReal.ofReal p := by
    rw [show RY = densityMeasure rY by rfl, densityMeasure_apply_univ_of_integral hrY_int hrY_nonneg]
    congr 1
    exact integral_residualY hf_int hg_int hf_prob hg_prob
  have hC_RX : C + RX = densityMeasure f := by
    exact densityMeasure_add hc_meas hc_nonneg hrX_nonneg
      (min_add_residualX f g)
  have hC_RY : C + RY = densityMeasure g := by
    exact densityMeasure_add hc_meas hc_nonneg hrY_nonneg
      (min_add_residualY f g)
  letI : IsFiniteMeasure C := ⟨by rw [hCmass]; exact ENNReal.ofReal_lt_top⟩
  letI : IsFiniteMeasure RX := ⟨by rw [hRXmass]; exact ENNReal.ofReal_lt_top⟩
  letI : IsFiniteMeasure RY := ⟨by rw [hRYmass]; exact ENNReal.ofReal_lt_top⟩
  have hN_meas : MeasurableSet N := by
    have heq : N = (diagonal ℝ)ᶜ := by
      ext z
      simp [N, diagonal]
    rw [heq]
    exact measurableSet_diagonal.compl
  have hdiagN : Measure.map D C N = 0 := by
    rw [Measure.map_apply (by fun_prop) hN_meas]
    simp [D, N]
  have hprodN : RX.prod RY N = RX.prod RY univ := by
    apply measure_of_measure_compl_eq_zero
    have hae : ∀ᵐ z ∂(RX.prod RY), z ∈ N := by
      apply (Measure.ae_prod_mem_iff_ae_ae_mem hN_meas).2
      filter_upwards [ae_residualX_strict hf_meas hg_meas] with x hx
      filter_upwards [ae_residualY_strict hf_meas hg_meas] with y hy
      intro hxy
      have hxy' : x = y := hxy
      subst y
      exact (hx.trans hy).false
    change (RX.prod RY) {z | z ∉ N} = 0
    exact ae_iff.mp hae
  have hoptimal : ∀ Γ' : Measure (ℝ × ℝ), IsProbabilityMeasure Γ' →
      Measure.map Prod.fst Γ' = densityMeasure f →
      Measure.map Prod.snd Γ' = densityMeasure g →
      p ≤ Γ'.real {z | z.1 ≠ z.2} := by
    intro Γ' hprob hfst hsnd
    letI : IsProbabilityMeasure Γ' := hprob
    exact coupling_disagreement_lower_bound hf_meas hg_meas hf_int hg_int
      hf_nonneg hg_nonneg hf_prob hg_prob Γ' hfst hsnd
  by_cases hp0 : p = 0
  · have hRXzero : RX = 0 := Measure.measure_univ_eq_zero.mp (by simpa [hp0] using hRXmass)
    have hRYzero : RY = 0 := Measure.measure_univ_eq_zero.mp (by simpa [hp0] using hRYmass)
    have hCP : C = densityMeasure f := by simpa [hRXzero] using hC_RX
    have hCQ : C = densityMeasure g := by simpa [hRYzero] using hC_RY
    refine ⟨Measure.map D C, ?_, ?_, ?_, ?_, hoptimal⟩
    · have hmass : C univ = 1 := by simpa [hp0] using hCmass
      refine ⟨?_⟩
      rw [Measure.map_apply (by fun_prop) MeasurableSet.univ, preimage_univ]
      exact hmass
    · rw [Measure.map_map measurable_fst (by fun_prop)]
      have hid : Prod.fst ∘ D = id := by funext x; rfl
      rw [hid, Measure.map_id]
      exact hCP
    · rw [Measure.map_map measurable_snd (by fun_prop)]
      have hid : Prod.snd ∘ D = id := by funext x; rfl
      rw [hid, Measure.map_id]
      exact hCQ
    · rw [Measure.real_def, hdiagN]
      change ENNReal.toReal 0 = p
      simp [hp0]
  · have hp_pos : 0 < p := lt_of_le_of_ne hp_nonneg (Ne.symm hp0)
    have hep0 : ENNReal.ofReal p ≠ 0 := ne_of_gt (ENNReal.ofReal_pos.mpr hp_pos)
    let Γ : Measure (ℝ × ℝ) := Measure.map D C + (ENNReal.ofReal p)⁻¹ • RX.prod RY
    refine ⟨Γ, ?_, ?_, ?_, ?_, hoptimal⟩
    · refine ⟨?_⟩
      rw [show Γ = Measure.map D C + (ENNReal.ofReal p)⁻¹ • RX.prod RY by rfl,
        Measure.add_apply, Measure.smul_apply,
        Measure.map_apply (by fun_prop) MeasurableSet.univ, preimage_univ,
        Measure.prod_apply MeasurableSet.univ]
      simp only [hCmass, hRXmass, hRYmass, preimage_univ, lintegral_const]
      rw [smul_eq_mul, ← mul_assoc,
        ENNReal.inv_mul_cancel hep0 ENNReal.ofReal_ne_top, one_mul,
        ← ENNReal.ofReal_add (sub_nonneg.mpr hp_le_one)]
      all_goals first | exact hp_nonneg | norm_num
    · rw [show Γ = Measure.map D C + (ENNReal.ofReal p)⁻¹ • RX.prod RY by rfl,
        Measure.map_add _ _ measurable_fst, Measure.map_smul,
        Measure.map_map measurable_fst (by fun_prop), Measure.map_fst_prod, hRYmass]
      simp only [smul_smul, ENNReal.inv_mul_cancel hep0 ENNReal.ofReal_ne_top, one_smul]
      have hid : Prod.fst ∘ D = id := by funext x; rfl
      rw [hid, Measure.map_id]
      exact hC_RX
    · rw [show Γ = Measure.map D C + (ENNReal.ofReal p)⁻¹ • RX.prod RY by rfl,
        Measure.map_add _ _ measurable_snd, Measure.map_smul,
        Measure.map_map measurable_snd (by fun_prop), Measure.map_snd_prod, hRXmass]
      simp only [smul_smul, ENNReal.inv_mul_cancel hep0 ENNReal.ofReal_ne_top, one_smul]
      have hid : Prod.snd ∘ D = id := by funext x; rfl
      rw [hid, Measure.map_id]
      exact hC_RY
    · rw [Measure.real_def, show Γ = Measure.map D C + (ENNReal.ofReal p)⁻¹ • RX.prod RY by rfl,
        Measure.add_apply, Measure.smul_apply, hdiagN, zero_add, hprodN,
        Measure.prod_apply MeasurableSet.univ]
      simp only [hRXmass, hRYmass, preimage_univ, lintegral_const]
      rw [smul_eq_mul, ← mul_assoc,
        ENNReal.inv_mul_cancel hep0 ENNReal.ofReal_ne_top, one_mul]
      change (ENNReal.ofReal p).toReal = p
      exact ENNReal.toReal_ofReal hp_nonneg

end Prob87


/-- Problem 8.7: two continuous densities admit a coupling attaining the least possible
disagreement probability among all couplings with the same marginals. -/
theorem prob_8_7
    {f g : ℝ → ℝ} (hf_meas : Measurable f) (hg_meas : Measurable g)
    (hf_int : Integrable f volume) (hg_int : Integrable g volume)
    (hf_nonneg : ∀ x, 0 ≤ f x) (hg_nonneg : ∀ x, 0 ≤ g x)
    (hf_prob : ∫ x, f x = 1) (hg_prob : ∫ x, g x = 1) :
    let p := (1 / 2 : ℝ) * ∫ x, |f x - g x|
    ∃ Γ : Measure (ℝ × ℝ),
      IsProbabilityMeasure Γ ∧
      Measure.map Prod.fst Γ = volume.withDensity (fun x => ENNReal.ofReal (f x)) ∧
      Measure.map Prod.snd Γ = volume.withDensity (fun x => ENNReal.ofReal (g x)) ∧
      Γ.real {z | z.1 ≠ z.2} = p ∧
      ∀ Γ' : Measure (ℝ × ℝ), IsProbabilityMeasure Γ' →
        Measure.map Prod.fst Γ' = volume.withDensity (fun x => ENNReal.ofReal (f x)) →
        Measure.map Prod.snd Γ' = volume.withDensity (fun x => ENNReal.ofReal (g x)) →
        p ≤ Γ'.real {z | z.1 ≠ z.2} := by
  simpa [Prob87.densityMeasure, Prob87.densityDiff] using
    Prob87.exists_maximalCoupling hf_meas hg_meas hf_int hg_int
      hf_nonneg hg_nonneg hf_prob hg_prob

