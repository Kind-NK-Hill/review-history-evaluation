import ProbabilityTheory.chapter_08.def_8_5
import ProbabilityTheory.common_support.ch8_discrete_pmf_core
import Mathlib

open MeasureTheory Set Real
open scoped BigOperators ENNReal

noncomputable section

namespace Theorem8_6

variable {Ω : Type*} [MeasurableSpace Ω]

private lemma integral_indicator_le_posPart (μ : Measure Ω) {h : Ω → ℝ}
    (hh : Integrable h μ) (A : Set Ω) (hA : MeasurableSet A) :
    ∫ x, A.indicator h x ∂μ ≤ ∫ x, max (h x) 0 ∂μ := by
  apply integral_mono
  · exact hh.indicator hA
  · exact hh.pos_part
  · intro x
    by_cases hx : x ∈ A
    · simp [indicator_of_mem hx, le_max_left]
    · simp [indicator_of_notMem hx, le_max_right]

private lemma posPart_eq_half_abs {μ : Measure Ω} {h : Ω → ℝ}
    (hh : Integrable h μ) (hzero : ∫ x, h x ∂μ = 0) :
    ∫ x, max (h x) 0 ∂μ = (1 / 2 : ℝ) * ∫ x, |h x| ∂μ := by
  have hp : Integrable (fun x => max (h x) 0) μ := hh.pos_part
  have hn : Integrable (fun x => max (-h x) 0) μ := hh.neg_part
  have hsub : (fun x => max (h x) 0 - max (-h x) 0) = h := by
    funext x
    by_cases hx : 0 ≤ h x <;> simp [hx, max_eq_left, max_eq_right]
  have hadd : (fun x => max (h x) 0 + max (-h x) 0) = fun x => |h x| := by
    funext x
    by_cases hx : 0 ≤ h x <;> simp [hx, abs_of_nonneg, abs_of_neg, max_eq_left, max_eq_right]
  have heq : (∫ x, max (h x) 0 ∂μ) = ∫ x, max (-h x) 0 ∂μ := by
    have hz := hzero
    rw [← hsub, integral_sub hp hn] at hz
    linarith
  rw [← hadd, integral_add hp hn, heq]
  ring

/-- Analytic core of both the density and discrete proofs. -/
theorem totalVariationDistance_eq_half_integral_abs_of_eventDifference
    (P Q : Measure Ω) (μ : Measure Ω) (h : Ω → ℝ)
    (hhm : Measurable h) (hh : Integrable h μ)
    (hzero : ∫ x, h x ∂μ = 0)
    (hmass : ∀ A : Set Ω, MeasurableSet A →
      P.real A - Q.real A = ∫ x in A, h x ∂μ) :
    totalVariationDistance P Q = (1 / 2 : ℝ) * ∫ x, |h x| ∂μ := by
  let C : ℝ := (1 / 2 : ℝ) * ∫ x, |h x| ∂μ
  have hC : C = ∫ x, max (h x) 0 ∂μ :=
    (posPart_eq_half_abs hh hzero).symm
  have hub : ∀ d ∈ {d : ℝ | ∃ A : Set Ω, MeasurableSet A ∧
      d = |P.real A - Q.real A|}, d ≤ C := by
    rintro d ⟨A, hA, rfl⟩
    rw [hmass A hA, abs_le, hC]
    constructor
    · have hneg : - ∫ x in A, h x ∂μ ≤ ∫ x, max (h x) 0 ∂μ := by
        calc
          - ∫ x in A, h x ∂μ = ∫ x in A, -h x ∂μ := by rw [integral_neg]
          _ ≤ ∫ x, max (-h x) 0 ∂μ := by
            rw [← integral_indicator hA]
            exact integral_indicator_le_posPart μ hh.neg A hA
          _ = ∫ x, max (h x) 0 ∂μ := by
            have hp := posPart_eq_half_abs hh hzero
            have hzneg : ∫ x, -h x ∂μ = 0 := by rw [integral_neg, hzero, neg_zero]
            have hn := posPart_eq_half_abs hh.neg hzneg
            calc
              ∫ x, max (-h x) 0 ∂μ = (1 / 2 : ℝ) * ∫ x, |h x| ∂μ := by
                convert hn using 1 <;> simp
              _ = ∫ x, max (h x) 0 ∂μ := hp.symm
      linarith
    · rw [← integral_indicator hA]
      exact integral_indicator_le_posPart μ hh A hA
  have hupper : totalVariationDistance P Q ≤ C := by
    unfold totalVariationDistance
    exact csSup_le ⟨0, ∅, MeasurableSet.empty, by simp⟩ hub
  let Aplus : Set Ω := {x | 0 ≤ h x}
  have hAplus : MeasurableSet Aplus := hhm measurableSet_Ici
  have hAeq : ∫ x in Aplus, h x ∂μ = ∫ x, max (h x) 0 ∂μ := by
    rw [← integral_indicator hAplus]
    congr 1
    funext x
    by_cases hx : 0 ≤ h x
    · simp [Aplus, hx]
    · simp [Aplus, hx, le_of_not_ge hx]
  have hattain : |P.real Aplus - Q.real Aplus| = C := by
    rw [hmass Aplus hAplus, hAeq, ← hC, abs_of_nonneg]
    rw [hC]
    exact integral_nonneg fun x => le_max_right (h x) 0
  have hlower : C ≤ totalVariationDistance P Q := by
    unfold totalVariationDistance
    rw [← hattain]
    apply le_csSup
    · refine ⟨C, ?_⟩
      exact fun d hd => hub d hd
    · exact ⟨Aplus, hAplus, rfl⟩
  exact le_antisymm hupper hlower


/-- The countable discrete specialization, directly from the event supremum. -/
theorem totalVariationDistance_pmf_eq_half_tsum
    {α : Type*} [MeasurableSpace α] [Countable α] [MeasurableSingletonClass α]
    (p q : PMF α) :
    totalVariationDistance p.toMeasure q.toMeasure =
      (1 / 2 : ℝ) * ∑' n, |(p n).toReal - (q n).toReal| := by
  let pr : α → ℝ := fun n => (p n).toReal
  let qr : α → ℝ := fun n => (q n).toReal
  have hp : Summable pr := by
    exact ENNReal.summable_toReal p.tsum_coe_ne_top
  have hq : Summable qr := by
    exact ENNReal.summable_toReal q.tsum_coe_ne_top
  have hsum_p : ∑' n, pr n = 1 := by
    rw [← ENNReal.tsum_toReal_eq]
    · simp [pr]
    · intro n
      exact p.apply_ne_top n
  have hsum_q : ∑' n, qr n = 1 := by
    rw [← ENNReal.tsum_toReal_eq]
    · simp [qr]
    · intro n
      exact q.apply_ne_top n
  have hh : Integrable (fun n => pr n - qr n) Measure.count := by
    rw [integrable_count_iff]
    exact (hp.sub hq).norm
  have hzero : ∫ n, (pr n - qr n) ∂Measure.count = 0 := by
    rw [integral_countable hh]
    simp only [Measure.real_def, Measure.count_singleton, ENNReal.toReal_one, one_smul]
    rw [Summable.tsum_sub hp hq, hsum_p, hsum_q, sub_self]
  have hmass : ∀ A : Set α, MeasurableSet A →
      p.toMeasure.real A - q.toMeasure.real A =
        ∫ n in A, (pr n - qr n) ∂Measure.count := by
    intro A hA
    rw [Measure.real_def, Measure.real_def, PMF.toMeasure_apply p hA,
      PMF.toMeasure_apply q hA]
    rw [ENNReal.tsum_toReal_eq, ENNReal.tsum_toReal_eq]
    · rw [← integral_indicator hA, integral_countable (hh.indicator hA)]
      simp only [Measure.real_def, Measure.count_singleton, ENNReal.toReal_one, one_smul]
      have hpind : ∑' n, (A.indicator (fun n => p n) n).toReal =
          ∑' n, A.indicator pr n := by
        apply tsum_congr
        intro n
        by_cases hn : n ∈ A <;> simp [pr, hn]
      have hqind : ∑' n, (A.indicator (fun n => q n) n).toReal =
          ∑' n, A.indicator qr n := by
        apply tsum_congr
        intro n
        by_cases hn : n ∈ A <;> simp [qr, hn]
      rw [hpind, hqind, ← Summable.tsum_sub (hp.indicator A) (hq.indicator A)]
      apply tsum_congr
      intro n
      by_cases hn : n ∈ A <;> simp [pr, qr, hn]
    · intro n
      by_cases hn : n ∈ A
      · simpa [hn] using q.apply_ne_top n
      · simp [hn]
    · intro n
      by_cases hn : n ∈ A
      · simpa [hn] using p.apply_ne_top n
      · simp [hn]
  have hcore := totalVariationDistance_eq_half_integral_abs_of_eventDifference
      p.toMeasure q.toMeasure Measure.count (fun n => pr n - qr n)
      (measurable_of_countable _) hh hzero hmass
  rw [integral_countable hh.abs] at hcore
  simpa only [Measure.real_def, Measure.count_singleton, ENNReal.toReal_one, one_smul,
    pr, qr] using hcore


/-- Common dominating measure specialization.  Densities are ENNReal-valued,
while the displayed formula uses their finite real values. -/
theorem totalVariationDistance_withDensity_eq_half_integral_abs
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) (f g : Ω → ENNReal)
    (hfm : Measurable f) (hgm : Measurable g)
    (hftop : ∀ x, f x ≠ ∞) (hgtop : ∀ x, g x ≠ ∞)
    (hfi : Integrable (fun x => (f x).toReal) μ)
    (hgi : Integrable (fun x => (g x).toReal) μ)
    (hf_one : ∫ x, (f x).toReal ∂μ = 1)
    (hg_one : ∫ x, (g x).toReal ∂μ = 1) :
    totalVariationDistance (μ.withDensity f) (μ.withDensity g) =
      (1 / 2 : ℝ) * ∫ x, |(f x).toReal - (g x).toReal| ∂μ := by
  let h : Ω → ℝ := fun x => (f x).toReal - (g x).toReal
  have hhm : Measurable h := hfm.ennreal_toReal.sub hgm.ennreal_toReal
  have hh : Integrable h μ := hfi.sub hgi
  have hzero : ∫ x, h x ∂μ = 0 := by
    rw [show h = (fun x => (f x).toReal - (g x).toReal) by rfl,
      integral_sub hfi hgi, hf_one, hg_one, sub_self]
  have hmass : ∀ A : Set Ω, MeasurableSet A →
      (μ.withDensity f).real A - (μ.withDensity g).real A = ∫ x in A, h x ∂μ := by
    intro A hA
    rw [Measure.real_def, Measure.real_def, withDensity_apply f hA,
      withDensity_apply g hA]
    have hfr : (∫⁻ x in A, f x ∂μ).toReal = ∫ x in A, (f x).toReal ∂μ := by
      symm
      apply integral_toReal hfm.aemeasurable.restrict
      exact Filter.Eventually.of_forall fun x => (lt_top_iff_ne_top).2 (hftop x)
    have hgr : (∫⁻ x in A, g x ∂μ).toReal = ∫ x in A, (g x).toReal ∂μ := by
      symm
      apply integral_toReal hgm.aemeasurable.restrict
      exact Filter.Eventually.of_forall fun x => (lt_top_iff_ne_top).2 (hgtop x)
    rw [hfr, hgr, show h = (fun x => (f x).toReal - (g x).toReal) by rfl,
      integral_sub hfi.integrableOn hgi.integrableOn]
  exact totalVariationDistance_eq_half_integral_abs_of_eventDifference
    (μ.withDensity f) (μ.withDensity g) μ h hhm hh hzero hmass


/-- Textbook-facing real-density form of the common dominating measure formula.
No continuity assumption is needed beyond measurability and integrability. -/
theorem thm_8_6_density
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) (f g : Ω → ℝ)
    (hfm : Measurable f) (hgm : Measurable g)
    (hfnn : ∀ x, 0 ≤ f x) (hgnn : ∀ x, 0 ≤ g x)
    (hfi : Integrable f μ) (hgi : Integrable g μ)
    (hf_one : ∫ x, f x ∂μ = 1) (hg_one : ∫ x, g x ∂μ = 1) :
    totalVariationDistance
        (μ.withDensity (fun x => ENNReal.ofReal (f x)))
        (μ.withDensity (fun x => ENNReal.ofReal (g x))) =
      (1 / 2 : ℝ) * ∫ x, |f x - g x| ∂μ := by
  have hftr : (fun x => (ENNReal.ofReal (f x)).toReal) = f := by
    funext x
    exact ENNReal.toReal_ofReal (hfnn x)
  have hgtr : (fun x => (ENNReal.ofReal (g x)).toReal) = g := by
    funext x
    exact ENNReal.toReal_ofReal (hgnn x)
  have hcore := totalVariationDistance_withDensity_eq_half_integral_abs μ
    (fun x => ENNReal.ofReal (f x)) (fun x => ENNReal.ofReal (g x))
    hfm.ennreal_ofReal hgm.ennreal_ofReal
    (fun x => by simp) (fun x => by simp)
    (by rw [hftr]; exact hfi) (by rw [hgtr]; exact hgi)
    (by rw [hftr]; exact hf_one) (by rw [hgtr]; exact hg_one)
  rw [hcore]
  congr 2
  funext x
  rw [ENNReal.toReal_ofReal (hfnn x), ENNReal.toReal_ofReal (hgnn x)]


open Ch8DiscretePMFCore

lemma summable_Poi (lam : NNReal) : Summable (Poi (lam : ℝ)) := by
  rw [← poissonPMF_toReal_eq_Poi]
  exact ENNReal.summable_toReal (ProbabilityTheory.poissonPMF lam).tsum_coe_ne_top

lemma tsum_Poi (lam : NNReal) : ∑' k, Poi (lam : ℝ) k = 1 := by
  rw [← poissonPMF_toReal_eq_Poi, ← ENNReal.tsum_toReal_eq]
  · simp
  · exact (ProbabilityTheory.poissonPMF lam).apply_ne_top

/-- The corrected Poisson tail appearing in Example 8.4.3. -/
lemma tsum_Poi_nat_add_two (lam : NNReal) :
    ∑' k : ℕ, Poi (lam : ℝ) (k + 2) =
      1 - Real.exp (-(lam : ℝ)) - (lam : ℝ) * Real.exp (-(lam : ℝ)) := by
  have hs := (summable_Poi lam).sum_add_tsum_nat_add 2
  rw [tsum_Poi lam] at hs
  norm_num [Finset.sum_range_succ, Poi] at hs ⊢
  linarith


lemma summable_Ber (lam : NNReal) (hlam : lam ≤ 1) : Summable (Ber (lam : ℝ)) := by
  rw [← bernoulliNatPMF_toReal_eq_Ber lam hlam]
  exact ENNReal.summable_toReal (bernoulliNatPMF lam hlam).tsum_coe_ne_top

lemma tsum_abs_Ber_sub_Poi (lam : NNReal) (hlam : lam ≤ 1) :
    ∑' k : ℕ, |Ber (lam : ℝ) k - Poi (lam : ℝ) k| =
      2 * (lam : ℝ) * (1 - Real.exp (-(lam : ℝ))) := by
  have hlam0 : 0 ≤ (lam : ℝ) := lam.coe_nonneg
  have hexp_le : Real.exp (-(lam : ℝ)) ≤ 1 := by
    exact (Real.exp_le_one_iff).2 (neg_nonpos.mpr hlam0)
  have hzero_sign : 1 - (lam : ℝ) - Real.exp (-(lam : ℝ)) ≤ 0 := by
    have he := Real.add_one_le_exp (-(lam : ℝ))
    linarith
  have hone_sign : 0 ≤ (lam : ℝ) - Real.exp (-(lam : ℝ)) * (lam : ℝ) := by
    nlinarith
  have hd : Summable (fun k => |Ber (lam : ℝ) k - Poi (lam : ℝ) k|) :=
    (summable_Ber lam hlam).sub (summable_Poi lam) |>.abs
  have hs := hd.sum_add_tsum_nat_add 2
  have htail : ∑' k : ℕ, |Ber (lam : ℝ) (k + 2) - Poi (lam : ℝ) (k + 2)| =
      ∑' k : ℕ, Poi (lam : ℝ) (k + 2) := by
    apply tsum_congr
    intro k
    have hpnonneg : 0 ≤ Poi (lam : ℝ) (k + 2) := by
      unfold Poi
      positivity
    simp [Ber, hpnonneg]
  rw [htail, tsum_Poi_nat_add_two lam] at hs
  norm_num [Finset.sum_range_succ, Ber, Poi, abs_of_nonpos hzero_sign,
    abs_of_nonneg hone_sign] at hs ⊢
  ring_nf at hs ⊢
  linarith

/-- Bernoulli--Poisson total variation, including both endpoints `lam = 0,1`. -/
theorem totalVariationDistance_bernoulliNat_poisson (lam : NNReal) (hlam : lam ≤ 1) :
    totalVariationDistance (bernoulliNatPMF lam hlam).toMeasure
        (ProbabilityTheory.poissonPMF lam).toMeasure =
      (lam : ℝ) * (1 - Real.exp (-(lam : ℝ))) := by
  rw [totalVariationDistance_pmf_eq_half_tsum]
  have hber := bernoulliNatPMF_toReal_eq_Ber lam hlam
  have hpoi := poissonPMF_toReal_eq_Poi lam
  simp_rw [congrFun hber, congrFun hpoi]
  rw [tsum_abs_Ber_sub_Poi lam hlam]
  ring


end Theorem8_6
