import Mathlib.Tactic
import Mathlib.MeasureTheory.Measure.Prod
import ProbabilityTheory.chapter_08.thm_8_6
open MeasureTheory Set
open TVCore
noncomputable section
namespace MaximumCoupling

def common (f g : ℝ → ℝ) (x : ℝ) := min (f x) (g x)
def leftRest (f g : ℝ → ℝ) (x : ℝ) := f x - common f g x
def rightRest (f g : ℝ → ℝ) (x : ℝ) := g x - common f g x
def mass (f g : ℝ → ℝ) := ∫ x, leftRest f g x
def diagonal (x : ℝ) : ℝ × ℝ := (x,x)
def mismatch : Set (ℝ × ℝ) := {z | z.1 ≠ z.2}
def coupling (f g : ℝ → ℝ) : Measure (ℝ × ℝ) :=
  if mass f g = 0 then Measure.map diagonal (densityMeasure f) else
    Measure.map diagonal (densityMeasure (common f g)) +
      (ENNReal.ofReal (mass f g))⁻¹ •
        ((densityMeasure (leftRest f g)).prod (densityMeasure (rightRest f g)))

lemma measurable_diagonal : Measurable diagonal := by unfold diagonal; fun_prop
lemma measurable_mismatch : MeasurableSet mismatch := by
  unfold mismatch
  rw [show {z : ℝ × ℝ | z.1 ≠ z.2} = {z | z.1 - z.2 ≠ 0} by ext z; simp [sub_ne_zero]]
  exact (measurableSet_singleton 0).compl.preimage (measurable_fst.sub measurable_snd)
lemma common_measurable {f g : ℝ → ℝ} (hf : Measurable f) (hg : Measurable g) : Measurable (common f g) := hf.min hg
lemma leftRest_eq_pos (f g : ℝ → ℝ) : leftRest f g = densityPos f g := by
  funext x; simp only [leftRest, common, densityPos, densityDiff]
  rcases le_total (f x) (g x) with h | h
  · rw [min_eq_left h, max_eq_right] <;> linarith
  · rw [min_eq_right h, max_eq_left] <;> linarith
lemma rightRest_eq_pos (f g : ℝ → ℝ) : rightRest f g = densityPos g f := by
  funext x; simp only [rightRest, common, densityPos, densityDiff]
  rcases le_total (f x) (g x) with h | h
  · rw [min_eq_left h, max_eq_left] <;> linarith
  · rw [min_eq_right h, max_eq_right] <;> linarith
lemma common_add_leftRest (f g : ℝ → ℝ) : (fun x => common f g x + leftRest f g x) = f := by funext x; simp [common,leftRest]
lemma common_add_rightRest (f g : ℝ → ℝ) : (fun x => common f g x + rightRest f g x) = g := by funext x; simp [common,rightRest]
lemma leftRest_integrable {f g : ℝ → ℝ} (hf : Integrable f volume) (hg : Integrable g volume) : Integrable (leftRest f g) volume := by rw [leftRest_eq_pos]; exact integrable_densityPos hf hg
lemma rightRest_integrable {f g : ℝ → ℝ} (hf : Integrable f volume) (hg : Integrable g volume) : Integrable (rightRest f g) volume := by rw [rightRest_eq_pos]; exact integrable_densityPos hg hf
lemma common_integrable {f g : ℝ → ℝ} (hf : Integrable f volume) (hg : Integrable g volume) : Integrable (common f g) volume := by
  have h := hf.sub (leftRest_integrable hf hg); convert h using 1; funext x; simp [leftRest,common]
lemma leftRest_nonneg (f g : ℝ → ℝ) (x : ℝ) : 0 ≤ leftRest f g x := by rw [leftRest_eq_pos]; exact le_max_right _ _
lemma rightRest_nonneg (f g : ℝ → ℝ) (x : ℝ) : 0 ≤ rightRest f g x := by rw [rightRest_eq_pos]; exact le_max_right _ _
lemma common_nonneg {f g : ℝ → ℝ} (hf : ∀ x, 0 ≤ f x) (hg : ∀ x, 0 ≤ g x) (x : ℝ) : 0 ≤ common f g x := by simp [common,hf x,hg x]
lemma rightRest_integral_eq_mass {f g : ℝ → ℝ} (hf : Integrable f volume) (hg : Integrable g volume) (hf_prob : ∫ x, f x = 1) (hg_prob : ∫ x, g x = 1) : ∫ x, rightRest f g x = mass f g := by
  have hL := integral_add (common_integrable hf hg) (leftRest_integrable hf hg)
  have hR := integral_add (common_integrable hf hg) (rightRest_integrable hf hg)
  rw [common_add_leftRest, hf_prob] at hL; rw [common_add_rightRest, hg_prob] at hR
  simp only [mass]; linarith
lemma common_integral_eq_one_sub_mass {f g : ℝ → ℝ} (hf : Integrable f volume) (hg : Integrable g volume) (hf_prob : ∫ x, f x = 1) : ∫ x, common f g x = 1 - mass f g := by
  have h := integral_add (common_integrable hf hg) (leftRest_integrable hf hg)
  rw [common_add_leftRest, hf_prob] at h; simp only [mass]; linarith
lemma mass_nonneg {f g : ℝ → ℝ} : 0 ≤ mass f g := integral_nonneg (leftRest_nonneg f g)
lemma mass_eq_tv {f g : ℝ → ℝ} (hf : Integrable f volume) (hg : Integrable g volume) (hf_prob : ∫ x, f x = 1) (hg_prob : ∫ x, g x = 1) : mass f g = (1/2:ℝ) * ∫ x, |densityDiff f g x| := by simp only [mass,leftRest_eq_pos]; exact densityPos_integral_eq_half_abs hf hg hf_prob hg_prob
lemma leftRest_measurable {f g : ℝ → ℝ} (hf : Measurable f) (hg : Measurable g) : Measurable (leftRest f g) := by rw [leftRest_eq_pos]; exact (densityDiff_measurable hf hg).max measurable_const
lemma rightRest_measurable {f g : ℝ → ℝ} (hf : Measurable f) (hg : Measurable g) : Measurable (rightRest f g) := by rw [rightRest_eq_pos]; exact (densityDiff_measurable hg hf).max measurable_const
lemma densityMeasure_add {a b : ℝ → ℝ} (ha : Measurable a) (hb : Measurable b) (ha0 : ∀ x, 0 ≤ a x) (hb0 : ∀ x, 0 ≤ b x) : densityMeasure (fun x => a x + b x) = densityMeasure a + densityMeasure b := by
  simp only [densityMeasure]
  rw [show (fun x => ENNReal.ofReal (a x + b x)) = (fun x => ENNReal.ofReal (a x) + ENNReal.ofReal (b x)) by funext x; exact ENNReal.ofReal_add (ha0 x) (hb0 x)]
  exact withDensity_add_right _ (ENNReal.measurable_ofReal.comp hb)
lemma densityMeasure_f_decomp {f g : ℝ → ℝ} (hf : Measurable f) (hg : Measurable g) (hf0 : ∀ x, 0 ≤ f x) (hg0 : ∀ x, 0 ≤ g x) : densityMeasure f = densityMeasure (common f g) + densityMeasure (leftRest f g) := by
  rw [← densityMeasure_add (common_measurable hf hg) (leftRest_measurable hf hg) (common_nonneg hf0 hg0) (leftRest_nonneg f g), common_add_leftRest]
lemma densityMeasure_g_decomp {f g : ℝ → ℝ} (hf : Measurable f) (hg : Measurable g) (hf0 : ∀ x, 0 ≤ f x) (hg0 : ∀ x, 0 ≤ g x) : densityMeasure g = densityMeasure (common f g) + densityMeasure (rightRest f g) := by
  rw [← densityMeasure_add (common_measurable hf hg) (rightRest_measurable hf hg) (common_nonneg hf0 hg0) (rightRest_nonneg f g), common_add_rightRest]
end MaximumCoupling

namespace MaximumCoupling
lemma densityMeasure_univ_eq_ofReal_integral {a : ℝ → ℝ} (ha : Integrable a volume)
    (ha0 : ∀ x, 0 ≤ a x) : densityMeasure a univ = ENNReal.ofReal (∫ x, a x) := by
  rw [densityMeasure, withDensity_apply' _ univ, Measure.restrict_univ]
  exact (ofReal_integral_eq_lintegral_ofReal ha (Filter.Eventually.of_forall ha0)).symm

lemma leftRest_measure_univ {f g : ℝ → ℝ} (hf : Integrable f volume) (hg : Integrable g volume) :
    densityMeasure (leftRest f g) univ = ENNReal.ofReal (mass f g) := by
  rw [densityMeasure_univ_eq_ofReal_integral (leftRest_integrable hf hg) (leftRest_nonneg f g)]
  rfl
lemma rightRest_measure_univ {f g : ℝ → ℝ} (hf : Integrable f volume) (hg : Integrable g volume)
    (hf_prob : ∫ x, f x = 1) (hg_prob : ∫ x, g x = 1) :
    densityMeasure (rightRest f g) univ = ENNReal.ofReal (mass f g) := by
  rw [densityMeasure_univ_eq_ofReal_integral (rightRest_integrable hf hg) (rightRest_nonneg f g),
    rightRest_integral_eq_mass hf hg hf_prob hg_prob]

lemma map_diagonal_fst (μ : Measure ℝ) : Measure.map Prod.fst (Measure.map diagonal μ) = μ := by
  rw [Measure.map_map measurable_fst measurable_diagonal, show Prod.fst ∘ diagonal = id by funext x; rfl, Measure.map_id]
lemma map_diagonal_snd (μ : Measure ℝ) : Measure.map Prod.snd (Measure.map diagonal μ) = μ := by
  rw [Measure.map_map measurable_snd measurable_diagonal, show Prod.snd ∘ diagonal = id by funext x; rfl, Measure.map_id]

lemma mass_ofReal_ne_zero {f g : ℝ → ℝ} (hp : mass f g ≠ 0) : ENNReal.ofReal (mass f g) ≠ 0 := by
  rw [ne_eq, ENNReal.ofReal_eq_zero, not_le]
  exact lt_of_le_of_ne mass_nonneg (Ne.symm hp)

lemma coupling_fst {f g : ℝ → ℝ} (hf : Measurable f) (hg : Measurable g)
    (hfi : Integrable f volume) (hgi : Integrable g volume)
    (hf0 : ∀ x, 0 ≤ f x) (hg0 : ∀ x, 0 ≤ g x)
    (hfp : ∫ x, f x = 1) (hgp : ∫ x, g x = 1) :
    Measure.map Prod.fst (coupling f g) = densityMeasure f := by
  by_cases hp : mass f g = 0
  · simp [coupling, hp, map_diagonal_fst]
  · letI : IsFiniteMeasure (densityMeasure (rightRest f g)) := IsFiniteMeasure.mk (by rw [rightRest_measure_univ hfi hgi hfp hgp]; exact ENNReal.ofReal_lt_top)
    letI : IsFiniteMeasure (densityMeasure (leftRest f g)) := IsFiniteMeasure.mk (by rw [leftRest_measure_univ hfi hgi]; exact ENNReal.ofReal_lt_top)
    rw [coupling, if_neg hp, Measure.map_add _ _ measurable_fst, map_diagonal_fst,
      Measure.map_smul, Measure.map_fst_prod, rightRest_measure_univ hfi hgi hfp hgp,
      smul_smul, ENNReal.inv_mul_cancel (mass_ofReal_ne_zero hp) (ENNReal.ofReal_ne_top), one_smul]
    exact (densityMeasure_f_decomp hf hg hf0 hg0).symm

lemma coupling_snd {f g : ℝ → ℝ} (hf : Measurable f) (hg : Measurable g)
    (hfi : Integrable f volume) (hgi : Integrable g volume)
    (hf0 : ∀ x, 0 ≤ f x) (hg0 : ∀ x, 0 ≤ g x)
    (hfp : ∫ x, f x = 1) (hgp : ∫ x, g x = 1) :
    Measure.map Prod.snd (coupling f g) = densityMeasure g := by
  by_cases hp : mass f g = 0
  · rw [coupling, if_pos hp, map_diagonal_snd]
    have hzero : ∫ x, densityPos f g x = 0 := by simpa [mass, leftRest_eq_pos] using hp
    have hae : densityPos f g =ᵐ[volume] 0 :=
      (MeasureTheory.integral_eq_zero_iff_of_nonneg_ae
        (Filter.Eventually.of_forall fun x => le_max_right _ _)
        (integrable_densityPos hfi hgi)).mp hzero
    have hle : f ≤ᵐ[volume] g := by
      filter_upwards [hae] with x hx
      have hd : f x - g x ≤ 0 := by simp only [Pi.zero_apply, densityPos, densityDiff] at hx; rw [← hx]; exact le_max_left _ _
      linarith
    have hfg : f =ᵐ[volume] g :=
      (MeasureTheory.integral_eq_iff_of_ae_le hfi hgi hle).mp (hfp.trans hgp.symm)
    simp only [densityMeasure]
    exact withDensity_congr_ae (hfg.fun_comp fun x => ENNReal.ofReal x)
  · letI : IsFiniteMeasure (densityMeasure (leftRest f g)) := IsFiniteMeasure.mk (by rw [leftRest_measure_univ hfi hgi]; exact ENNReal.ofReal_lt_top)
    letI : IsFiniteMeasure (densityMeasure (rightRest f g)) := IsFiniteMeasure.mk (by rw [rightRest_measure_univ hfi hgi hfp hgp]; exact ENNReal.ofReal_lt_top)
    rw [coupling, if_neg hp, Measure.map_add _ _ measurable_snd, map_diagonal_snd,
      Measure.map_smul, Measure.map_snd_prod, leftRest_measure_univ hfi hgi,
      smul_smul, ENNReal.inv_mul_cancel (mass_ofReal_ne_zero hp) (ENNReal.ofReal_ne_top), one_smul]
    exact (densityMeasure_g_decomp hf hg hf0 hg0).symm
end MaximumCoupling

namespace MaximumCoupling
lemma prod_match_zero (μ ν : Measure ℝ) [SFinite ν] [NoAtoms ν] :
    μ.prod ν mismatchᶜ = 0 := by
  rw [Measure.measure_prod_null measurable_mismatch.compl]
  filter_upwards [] with x
  rw [show Prod.mk x ⁻¹' mismatchᶜ = {x} by ext y; simp [mismatch, eq_comm]]
  exact measure_singleton x

lemma prod_mismatch_eq_univ (μ ν : Measure ℝ) [SFinite ν] [NoAtoms ν] :
    μ.prod ν mismatch = μ.prod ν univ := by
  have h := measure_add_measure_compl (μ := μ.prod ν) measurable_mismatch
  rw [prod_match_zero] at h
  simpa using h

lemma diagonal_mismatch_zero (μ : Measure ℝ) : Measure.map diagonal μ mismatch = 0 := by
  rw [Measure.map_apply measurable_diagonal measurable_mismatch]
  simp [mismatch, diagonal]

lemma coupling_apply_mismatch {f g : ℝ → ℝ} (hfi : Integrable f volume)
    (hgi : Integrable g volume) (hfp : ∫ x, f x = 1) (hgp : ∫ x, g x = 1) :
    coupling f g mismatch = ENNReal.ofReal (mass f g) := by
  by_cases hp : mass f g = 0
  · rw [coupling, if_pos hp, diagonal_mismatch_zero, hp, ENNReal.ofReal_zero]
  · letI : IsFiniteMeasure (densityMeasure (rightRest f g)) :=
      IsFiniteMeasure.mk (by rw [rightRest_measure_univ hfi hgi hfp hgp]; exact ENNReal.ofReal_lt_top)
    letI : NoAtoms (densityMeasure (rightRest f g)) := by unfold densityMeasure; infer_instance
    rw [coupling, if_neg hp, Measure.add_apply _ _ mismatch,
      diagonal_mismatch_zero, zero_add, Measure.smul_apply _ _ mismatch, prod_mismatch_eq_univ,
      show (univ : Set (ℝ × ℝ)) = univ ×ˢ univ by simp, Measure.prod_prod,
      leftRest_measure_univ hfi hgi, rightRest_measure_univ hfi hgi hfp hgp]
    simp only [smul_eq_mul]
    rw [ENNReal.inv_mul_cancel_left (mass_ofReal_ne_zero hp) ENNReal.ofReal_ne_top]

lemma coupling_real_mismatch {f g : ℝ → ℝ} (hfi : Integrable f volume)
    (hgi : Integrable g volume) (hfp : ∫ x, f x = 1) (hgp : ∫ x, g x = 1) :
    (coupling f g).real mismatch = mass f g := by
  rw [Measure.real_def, coupling_apply_mismatch hfi hgi hfp hgp,
    ENNReal.toReal_ofReal mass_nonneg]

lemma coupling_isProbabilityMeasure {f g : ℝ → ℝ} (hf : Measurable f) (hg : Measurable g)
    (hfi : Integrable f volume) (hgi : Integrable g volume)
    (hf0 : ∀ x, 0 ≤ f x) (hg0 : ∀ x, 0 ≤ g x)
    (hfp : ∫ x, f x = 1) (hgp : ∫ x, g x = 1) :
    IsProbabilityMeasure (coupling f g) := by
  refine ⟨?_⟩
  have h := congrArg (fun μ : Measure ℝ => μ univ)
    (coupling_fst hf hg hfi hgi hf0 hg0 hfp hgp)
  rw [Measure.map_apply measurable_fst MeasurableSet.univ,
    preimage_univ, densityMeasure_apply_univ hfi hf0 hfp] at h
  exact h

lemma coupling_real_mismatch_eq_tv {f g : ℝ → ℝ} (hf : Measurable f) (hg : Measurable g)
    (hfi : Integrable f volume) (hgi : Integrable g volume)
    (hf0 : ∀ x, 0 ≤ f x) (hg0 : ∀ x, 0 ≤ g x)
    (hfp : ∫ x, f x = 1) (hgp : ∫ x, g x = 1) :
    (coupling f g).real mismatch =
      totalVariationDistance (densityMeasure f) (densityMeasure g) := by
  rw [coupling_real_mismatch hfi hgi hfp hgp,
    mass_eq_tv hfi hgi hfp hgp,
    ← thm_8_6_continuous hf hg hfi hgi hf0 hg0 hfp hgp]

lemma coupling_of_mass_zero {f g : ℝ → ℝ} (h : mass f g = 0) :
    coupling f g = Measure.map diagonal (densityMeasure f) := by simp [coupling, h]

lemma coupling_of_mass_one {f g : ℝ → ℝ} (h : mass f g = 1) :
    coupling f g = Measure.map diagonal (densityMeasure (common f g)) +
      (densityMeasure (leftRest f g)).prod (densityMeasure (rightRest f g)) := by
  rw [coupling, if_neg (by linarith : mass f g ≠ 0), h]
  norm_num

/-- Continuous maximum coupling: existence, probability mass, both marginals, and exact mismatch. -/
theorem prob_8_7
    {f g : ℝ → ℝ} (hf : Measurable f) (hg : Measurable g)
    (hfi : Integrable f volume) (hgi : Integrable g volume)
    (hf0 : ∀ x, 0 ≤ f x) (hg0 : ∀ x, 0 ≤ g x)
    (hfp : ∫ x, f x = 1) (hgp : ∫ x, g x = 1) :
    ∃ κ : Measure (ℝ × ℝ), IsProbabilityMeasure κ ∧
      Measure.map Prod.fst κ = densityMeasure f ∧
      Measure.map Prod.snd κ = densityMeasure g ∧
      κ.real mismatch = totalVariationDistance (densityMeasure f) (densityMeasure g) := by
  refine ⟨coupling f g, coupling_isProbabilityMeasure hf hg hfi hgi hf0 hg0 hfp hgp,
    coupling_fst hf hg hfi hgi hf0 hg0 hfp hgp,
    coupling_snd hf hg hfi hgi hf0 hg0 hfp hgp, ?_⟩
  exact coupling_real_mismatch_eq_tv hf hg hfi hgi hf0 hg0 hfp hgp
end MaximumCoupling

/-- Exported statement of Problem 8.7. -/
theorem prob_8_7
    {f g : ℝ → ℝ} (hf : Measurable f) (hg : Measurable g)
    (hfi : Integrable f volume) (hgi : Integrable g volume)
    (hf0 : ∀ x, 0 ≤ f x) (hg0 : ∀ x, 0 ≤ g x)
    (hfp : ∫ x, f x = 1) (hgp : ∫ x, g x = 1) :
    ∃ κ : Measure (ℝ × ℝ), IsProbabilityMeasure κ ∧
      Measure.map Prod.fst κ = densityMeasure f ∧
      Measure.map Prod.snd κ = densityMeasure g ∧
      κ.real MaximumCoupling.mismatch =
        totalVariationDistance (densityMeasure f) (densityMeasure g) :=
  MaximumCoupling.prob_8_7 hf hg hfi hgi hf0 hg0 hfp hgp

namespace MaximumCoupling

/-- The common part, normalized to a probability measure when it has positive mass.
At the degenerate endpoint `mass f g = 1`, use the probability density `f` as a fallback. -/
def commonLaw (f g : ℝ → ℝ) : Measure ℝ :=
  if mass f g = 1 then densityMeasure f else
    (ENNReal.ofReal (1 - mass f g))⁻¹ • densityMeasure (common f g)

/-- The part of `f` left after removing the common density, normalized to a probability
measure. If this part has zero mass, use the probability density `f` as a fallback. -/
def leftLaw (f g : ℝ → ℝ) : Measure ℝ :=
  if mass f g = 0 then densityMeasure f else
    (ENNReal.ofReal (mass f g))⁻¹ • densityMeasure (leftRest f g)

/-- The part of `g` left after removing the common density, normalized to a probability
measure. If this part has zero mass, use the probability density `g` as a fallback. -/
def rightLaw (f g : ℝ → ℝ) : Measure ℝ :=
  if mass f g = 0 then densityMeasure g else
    (ENNReal.ofReal (mass f g))⁻¹ • densityMeasure (rightRest f g)

lemma mass_le_one {f g : ℝ → ℝ} (hfi : Integrable f volume) (hgi : Integrable g volume)
    (hf0 : ∀ x, 0 ≤ f x) (hg0 : ∀ x, 0 ≤ g x) (hfp : ∫ x, f x = 1) :
    mass f g ≤ 1 := by
  have hcommon : 0 ≤ ∫ x, common f g x := integral_nonneg (common_nonneg hf0 hg0)
  rw [common_integral_eq_one_sub_mass hfi hgi hfp] at hcommon
  linarith

lemma common_measure_univ {f g : ℝ → ℝ} (hfi : Integrable f volume)
    (hgi : Integrable g volume) (hf0 : ∀ x, 0 ≤ f x) (hg0 : ∀ x, 0 ≤ g x)
    (hfp : ∫ x, f x = 1) :
    densityMeasure (common f g) univ = ENNReal.ofReal (1 - mass f g) := by
  rw [densityMeasure_univ_eq_ofReal_integral (common_integrable hfi hgi)
    (common_nonneg hf0 hg0), common_integral_eq_one_sub_mass hfi hgi hfp]

@[simp] lemma commonLaw_of_mass_one {f g : ℝ → ℝ} (h : mass f g = 1) :
    commonLaw f g = densityMeasure f := by
  simp [commonLaw, h]

lemma commonLaw_of_mass_ne_one {f g : ℝ → ℝ} (h : mass f g ≠ 1) :
    commonLaw f g =
      (ENNReal.ofReal (1 - mass f g))⁻¹ • densityMeasure (common f g) := by
  simp [commonLaw, h]

@[simp] lemma leftLaw_of_mass_zero {f g : ℝ → ℝ} (h : mass f g = 0) :
    leftLaw f g = densityMeasure f := by
  simp [leftLaw, h]

lemma leftLaw_of_mass_ne_zero {f g : ℝ → ℝ} (h : mass f g ≠ 0) :
    leftLaw f g =
      (ENNReal.ofReal (mass f g))⁻¹ • densityMeasure (leftRest f g) := by
  simp [leftLaw, h]

@[simp] lemma rightLaw_of_mass_zero {f g : ℝ → ℝ} (h : mass f g = 0) :
    rightLaw f g = densityMeasure g := by
  simp [rightLaw, h]

lemma rightLaw_of_mass_ne_zero {f g : ℝ → ℝ} (h : mass f g ≠ 0) :
    rightLaw f g =
      (ENNReal.ofReal (mass f g))⁻¹ • densityMeasure (rightRest f g) := by
  simp [rightLaw, h]

lemma commonLaw_isProbabilityMeasure {f g : ℝ → ℝ}
    (hfi : Integrable f volume) (hgi : Integrable g volume)
    (hf0 : ∀ x, 0 ≤ f x) (hg0 : ∀ x, 0 ≤ g x)
    (hfp : ∫ x, f x = 1) : IsProbabilityMeasure (commonLaw f g) := by
  refine ⟨?_⟩
  by_cases h : mass f g = 1
  · rw [commonLaw_of_mass_one h, densityMeasure_apply_univ hfi hf0 hfp]
  · rw [commonLaw_of_mass_ne_one h, Measure.smul_apply, common_measure_univ hfi hgi hf0 hg0 hfp]
    simp only [smul_eq_mul]
    apply ENNReal.inv_mul_cancel
    · rw [ne_eq, ENNReal.ofReal_eq_zero, not_le]
      have hm := mass_le_one hfi hgi hf0 hg0 hfp
      have hlt : mass f g < 1 := lt_of_le_of_ne hm h
      linarith
    · exact ENNReal.ofReal_ne_top

lemma leftLaw_isProbabilityMeasure {f g : ℝ → ℝ}
    (hfi : Integrable f volume) (hgi : Integrable g volume)
    (hf0 : ∀ x, 0 ≤ f x) (hfp : ∫ x, f x = 1) :
    IsProbabilityMeasure (leftLaw f g) := by
  refine ⟨?_⟩
  by_cases h : mass f g = 0
  · rw [leftLaw_of_mass_zero h, densityMeasure_apply_univ hfi hf0 hfp]
  · rw [leftLaw_of_mass_ne_zero h, Measure.smul_apply, leftRest_measure_univ hfi hgi]
    simp only [smul_eq_mul]
    exact ENNReal.inv_mul_cancel (mass_ofReal_ne_zero h) ENNReal.ofReal_ne_top

lemma rightLaw_isProbabilityMeasure {f g : ℝ → ℝ}
    (hfi : Integrable f volume) (hgi : Integrable g volume)
    (hg0 : ∀ x, 0 ≤ g x) (hfp : ∫ x, f x = 1) (hgp : ∫ x, g x = 1) :
    IsProbabilityMeasure (rightLaw f g) := by
  refine ⟨?_⟩
  by_cases h : mass f g = 0
  · rw [rightLaw_of_mass_zero h, densityMeasure_apply_univ hgi hg0 hgp]
  · rw [rightLaw_of_mass_ne_zero h, Measure.smul_apply,
      rightRest_measure_univ hfi hgi hfp hgp]
    simp only [smul_eq_mul]
    exact ENNReal.inv_mul_cancel (mass_ofReal_ne_zero h) ENNReal.ofReal_ne_top

end MaximumCoupling
