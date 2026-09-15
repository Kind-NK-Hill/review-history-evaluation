import ProbabilityTheory.chapter_10.def_10_4

open Filter MeasureTheory ProbabilityTheory Set
open scoped Topology
open scoped unitInterval

noncomputable section

/-- The lower quantile associated with a probability law. -/
def cdfQuantile (μ : ProbabilityMeasure ℝ) (u : ℝ) : ℝ :=
  sSup {x : ℝ | measureCdf μ x < u}

namespace CdfQuantile

variable (μ : ProbabilityMeasure ℝ)

private lemma cdf_eq (x : ℝ) :
    measureCdf μ x = ProbabilityTheory.cdf (μ : Measure ℝ) x := by
  exact (ProbabilityTheory.cdf_eq_real (μ : Measure ℝ) x).symm

lemma tendsto_atBot : Tendsto (measureCdf μ) atBot (𝓝 0) := by
  rw [show measureCdf μ = (fun x => ProbabilityTheory.cdf (μ : Measure ℝ) x) by
    funext x; exact cdf_eq μ x]
  exact ProbabilityTheory.tendsto_cdf_atBot (μ : Measure ℝ)

lemma tendsto_atTop : Tendsto (measureCdf μ) atTop (𝓝 1) := by
  rw [show measureCdf μ = (fun x => ProbabilityTheory.cdf (μ : Measure ℝ) x) by
    funext x; exact cdf_eq μ x]
  exact ProbabilityTheory.tendsto_cdf_atTop (μ : Measure ℝ)

lemma monotone : Monotone (measureCdf μ) := by
  rw [show measureCdf μ = (fun x => ProbabilityTheory.cdf (μ : Measure ℝ) x) by
    funext x; exact cdf_eq μ x]
  exact ProbabilityTheory.monotone_cdf (μ : Measure ℝ)

lemma rightContinuous (x : ℝ) :
    ContinuousWithinAt (measureCdf μ) (Ici x) x := by
  rw [show measureCdf μ = (fun y => ProbabilityTheory.cdf (μ : Measure ℝ) y) by
    funext y; exact cdf_eq μ y]
  exact (ProbabilityTheory.cdf (μ : Measure ℝ)).right_continuous x

lemma lowerSet_nonempty {u : ℝ} (hu : 0 < u) :
    {x : ℝ | measureCdf μ x < u}.Nonempty := by
  have he : ∀ᶠ x in atBot, measureCdf μ x < u :=
    (tendsto_atBot μ).eventually (Iio_mem_nhds hu)
  exact Filter.Eventually.exists he

lemma lowerSet_bddAbove {u : ℝ} (hu : u < 1) :
    BddAbove {x : ℝ | measureCdf μ x < u} := by
  have he : ∀ᶠ x in atTop, u < measureCdf μ x :=
    (tendsto_atTop μ).eventually (Ioi_mem_nhds hu)
  rcases Filter.Eventually.exists he with ⟨a, ha⟩
  refine ⟨a, ?_⟩
  intro x hx
  change measureCdf μ x < u at hx
  by_contra hxa
  have hax : a ≤ x := le_of_not_ge hxa
  exact (not_lt_of_ge ((monotone μ) hax)) (lt_trans hx ha)

/-- The central inverse comparison, valid away from the null endpoints. -/
theorem quantile_le_iff {u x : ℝ} (hu0 : 0 < u) (hu1 : u < 1) :
    cdfQuantile μ u ≤ x ↔ u ≤ measureCdf μ x := by
  let S : Set ℝ := {y : ℝ | measureCdf μ y < u}
  have hSne : S.Nonempty := lowerSet_nonempty μ hu0
  have hSbdd : BddAbove S := lowerSet_bddAbove μ hu1
  constructor
  · intro hqx
    have hright : Tendsto (measureCdf μ) (𝓝[>] x) (𝓝 (measureCdf μ x)) :=
      (rightContinuous μ x).mono Ioi_subset_Ici_self
    have hconst : Tendsto (fun _ : ℝ => u) (𝓝[>] x) (𝓝 u) := tendsto_const_nhds
    refine le_of_tendsto_of_tendsto (b := 𝓝[>] x) hconst hright ?_
    filter_upwards [self_mem_nhdsWithin] with y hy
    by_contra hnot
    have hyS : y ∈ S := by
      change measureCdf μ y < u
      exact lt_of_not_ge hnot
    have hyle : y ≤ sSup S := le_csSup hSbdd hyS
    exact (not_lt_of_ge (hyle.trans hqx)) hy
  · intro hux
    change sSup S ≤ x
    refine csSup_le hSne ?_
    intro y hyS
    change measureCdf μ y < u at hyS
    by_contra hyx
    have hxy : x ≤ y := le_of_not_ge hyx
    exact (not_lt_of_ge (hux.trans ((monotone μ) hxy))) hyS

theorem le_quantile_of_cdf_lt {u x : ℝ} (hu1 : u < 1)
    (hx : measureCdf μ x < u) : x ≤ cdfQuantile μ u := by
  exact le_csSup (lowerSet_bddAbove μ hu1) hx

theorem quantile_monoOn : MonotoneOn (cdfQuantile μ) (Ioo 0 1) := by
  intro u hu v hv huv
  by_cases huv' : u = v
  · simpa [huv']
  · have huv_strict : u < v := lt_of_le_of_ne huv huv'
    refine csSup_le (lowerSet_nonempty μ hu.1) ?_
    intro y hy
    change measureCdf μ y < u at hy
    exact le_csSup (lowerSet_bddAbove μ hv.2) (lt_trans hy huv_strict)

/-- The lower quantile is measurable up to the two null endpoints of the unit interval. -/
theorem aemeasurable_unitInterval :
    AEMeasurable (fun u : I => cdfQuantile μ (u : ℝ)) volume := by
  have hreal :
      AEMeasurable (cdfQuantile μ) (volume.restrict (Icc (0 : ℝ) 1)) := by
    rw [← restrict_Ioo_eq_restrict_Icc]
    exact aemeasurable_restrict_of_monotoneOn measurableSet_Ioo
      (quantile_monoOn μ)
  have hsub :=
    (aemeasurable_restrict_iff_comap_subtype measurableSet_Icc).1 hreal
  simpa [unitInterval.volume_def, Function.comp_def] using hsub


section Convergence

variable {μ : ProbabilityMeasure ℝ} {μn : ℕ → ProbabilityMeasure ℝ}

/-- A strict cdf inequality gives the eventual lower quantile bound. -/
theorem eventually_le_quantile
    (hconv : CdfConvergesInDistribution μn μ) {u x : ℝ}
    (hu1 : u < 1) (hxcont : ContinuousAt (measureCdf μ) x)
    (hx : measureCdf μ x < u) :
    ∀ᶠ n in atTop, x ≤ cdfQuantile (μn n) u := by
  have he : ∀ᶠ n in atTop, measureCdf (μn n) x < u :=
    (hconv x hxcont).eventually (Iio_mem_nhds hx)
  filter_upwards [he] with n hn
  exact le_quantile_of_cdf_lt (μn n) hu1 hn

/-- A strict reverse cdf inequality gives the eventual upper quantile bound. -/
theorem eventually_quantile_le
    (hconv : CdfConvergesInDistribution μn μ) {u x : ℝ}
    (hu0 : 0 < u) (hu1 : u < 1)
    (hxcont : ContinuousAt (measureCdf μ) x)
    (hx : u < measureCdf μ x) :
    ∀ᶠ n in atTop, cdfQuantile (μn n) u ≤ x := by
  have he : ∀ᶠ n in atTop, u < measureCdf (μn n) x :=
    (hconv x hxcont).eventually (Ioi_mem_nhds hx)
  filter_upwards [he] with n hn
  exact quantile_le_iff (μn n) hu0 hu1 |>.2 hn.le

end Convergence

end CdfQuantile

namespace CdfQuantile

variable {μ : ProbabilityMeasure ℝ} {μn : ℕ → ProbabilityMeasure ℝ}

private lemma exists_lt_mem_of_mem_nhds {u : ℝ} {s : Set ℝ} (hs : s ∈ 𝓝 u) :
    ∃ v ∈ s, v < u := by
  rcases mem_nhds_iff_exists_Ioo_subset.mp hs with ⟨a, b, hab, hsub⟩
  refine ⟨(a + u) / 2, hsub ?_, by linarith [hab.1]⟩
  constructor <;> linarith [hab.1, hab.2]

private lemma exists_mem_gt_of_mem_nhds {u : ℝ} {s : Set ℝ} (hs : s ∈ 𝓝 u) :
    ∃ v ∈ s, u < v := by
  rcases mem_nhds_iff_exists_Ioo_subset.mp hs with ⟨a, b, hab, hsub⟩
  refine ⟨(u + b) / 2, hsub ?_, by linarith [hab.2]⟩
  constructor <;> linarith [hab.1, hab.2]

/-- At every relative continuity level of the limiting quantile in `(0,1)`,
cdf convergence implies pointwise convergence of lower quantiles. -/
theorem tendsto_quantile_of_continuousWithinAt
    (hconv : CdfConvergesInDistribution μn μ) {u : ℝ}
    (hu : u ∈ Ioo (0 : ℝ) 1)
    (hq : ContinuousWithinAt (cdfQuantile μ) (Ioo (0 : ℝ) 1) u) :
    Tendsto (fun n => cdfQuantile (μn n) u) atTop (𝓝 (cdfQuantile μ u)) := by
  have hq' : ContinuousAt (cdfQuantile μ) u :=
    hq.continuousAt (Ioo_mem_nhds hu.1 hu.2)
  have hmonoF : Monotone (measureCdf μ) := monotone μ
  have hbadF : Set.Countable {x : ℝ | ¬ ContinuousAt (measureCdf μ) x} :=
    hmonoF.countable_not_continuousAt
  have hD : Dense {x : ℝ | ContinuousAt (measureCdf μ) x} := by
    convert hbadF.dense_compl ℝ using 1
    ext x
    simp
  rw [tendsto_order]
  constructor
  · intro a ha
    have hnear : {v : ℝ | a < cdfQuantile μ v} ∩ Ioo (0 : ℝ) 1 ∈ 𝓝 u :=
      inter_mem (hq'.eventually (Ioi_mem_nhds ha)) (Ioo_mem_nhds hu.1 hu.2)
    rcases exists_lt_mem_of_mem_nhds hnear with ⟨v, hv, hvu⟩
    have hav : a < cdfQuantile μ v := hv.1
    rcases hD.exists_between hav with ⟨x, hxcont, hax, hxq⟩
    have hFxv : measureCdf μ x < v := by
      by_contra h
      have hvFx : v ≤ measureCdf μ x := le_of_not_gt h
      have hqxle := (quantile_le_iff μ hv.2.1 hv.2.2).2 hvFx
      exact (not_le_of_gt hxq) hqxle
    have hFxu : measureCdf μ x < u := hFxv.trans hvu
    filter_upwards [eventually_le_quantile hconv hu.2 hxcont hFxu] with n hn
    exact hax.trans_le hn
  · intro b hb
    have hnear : {v : ℝ | cdfQuantile μ v < b} ∩ Ioo (0 : ℝ) 1 ∈ 𝓝 u :=
      inter_mem (hq'.eventually (Iio_mem_nhds hb)) (Ioo_mem_nhds hu.1 hu.2)
    rcases exists_mem_gt_of_mem_nhds hnear with ⟨v, hv, huv⟩
    have hqvb : cdfQuantile μ v < b := hv.1
    rcases hD.exists_between hqvb with ⟨x, hxcont, hqx, hxb⟩
    have hvFx : v ≤ measureCdf μ x :=
      (quantile_le_iff μ hv.2.1 hv.2.2).1 hqx.le
    have huFx : u < measureCdf μ x := huv.trans_le hvFx
    filter_upwards [eventually_quantile_le hconv hu.1 hu.2 hxcont huFx] with n hn
    exact hn.trans_lt hxb

/-- The exceptional levels for quantile convergence are countable. -/
theorem countable_badQuantileLevels :
    Set.Countable {u : ℝ | u ∈ Ioo (0 : ℝ) 1 ∧
      ¬ ContinuousWithinAt (cdfQuantile μ) (Ioo (0 : ℝ) 1) u} :=
  (quantile_monoOn μ).countable_not_continuousWithinAt

end CdfQuantile

/-- Almost every point of the unit interval is an interior point. -/
theorem ae_unitInterval_mem_Ioo :
    ∀ᵐ u : I ∂volume, (u : ℝ) ∈ Ioo (0 : ℝ) 1 := by
  rw [ae_iff]
  apply Set.Countable.measure_zero
  apply Set.Finite.countable
  refine ({(0 : I), (1 : I)} : Set I).toFinite.subset ?_
  intro u hu
  simp only [mem_setOf_eq, mem_Ioo, not_and_or, not_lt, mem_insert_iff, mem_singleton_iff] at hu ⊢
  rcases hu with hu | hu
  · left
    apply Subtype.ext
    exact le_antisymm hu u.property.1
  · right
    apply Subtype.ext
    exact le_antisymm u.property.2 hu

namespace CdfQuantile

variable (μ : ProbabilityMeasure ℝ)

lemma cdf_nonneg (x : ℝ) : 0 ≤ measureCdf μ x := by
  simpa [measureCdf, ProbabilityTheory.cdf_eq_real] using
    ProbabilityTheory.cdf_nonneg (μ : Measure ℝ) x

lemma cdf_le_one (x : ℝ) : measureCdf μ x ≤ 1 := by
  simpa [measureCdf, ProbabilityTheory.cdf_eq_real] using
    ProbabilityTheory.cdf_le_one (μ : Measure ℝ) x

/-- The exact inverse-image comparison holds almost everywhere on the unit
interval; the only omitted points are `0` and `1`. -/
theorem ae_quantile_le_iff (x : ℝ) :
    ∀ᵐ u : I ∂volume,
      cdfQuantile μ (u : ℝ) ≤ x ↔ (u : ℝ) ≤ measureCdf μ x := by
  filter_upwards [ae_unitInterval_mem_Ioo] with u hu
  exact quantile_le_iff μ hu.1 hu.2

/-- The raw lower quantile pushes unit-interval volume forward to its law. -/
theorem map_quantile_eq :
    volume.map (fun u : I => cdfQuantile μ (u : ℝ)) = (μ : Measure ℝ) := by
  apply Measure.ext_of_Iic
  intro x
  rw [Measure.map_apply_of_aemeasurable (aemeasurable_unitInterval μ) measurableSet_Iic]
  let p : I := ⟨measureCdf μ x, cdf_nonneg μ x, cdf_le_one μ x⟩
  have hae :
      (fun u : I => cdfQuantile μ (u : ℝ)) ⁻¹' Iic x =ᵐ[volume] Iic p := by
    filter_upwards [ae_quantile_le_iff μ x] with u hu
    change (cdfQuantile μ (u : ℝ) ≤ x) = (u ≤ p)
    apply propext
    constructor
    · intro h
      change (u : ℝ) ≤ (p : ℝ)
      simpa [p] using hu.mp h
    · intro h
      change (u : ℝ) ≤ (p : ℝ) at h
      exact hu.mpr (by simpa [p] using h)
  rw [measure_congr hae, unitInterval.volume_Iic]
  exact ofReal_measureReal (measure_ne_top (μ : Measure ℝ) (Iic x))

/-- A measurable representative of the lower quantile. -/
noncomputable def measurableQuantile : I → ℝ :=
  (aemeasurable_unitInterval μ).mk (fun u : I => cdfQuantile μ (u : ℝ))

theorem measurable_measurableQuantile : Measurable (measurableQuantile μ) :=
  (aemeasurable_unitInterval μ).measurable_mk

theorem ae_eq_measurableQuantile :
    (fun u : I => cdfQuantile μ (u : ℝ)) =ᵐ[volume] measurableQuantile μ :=
  (aemeasurable_unitInterval μ).ae_eq_mk

theorem map_measurableQuantile_eq :
    volume.map (measurableQuantile μ) = (μ : Measure ℝ) := by
  rw [← map_quantile_eq μ]
  exact Measure.map_congr (ae_eq_measurableQuantile μ).symm

variable {μ : ProbabilityMeasure ℝ} {μn : ℕ → ProbabilityMeasure ℝ}

/-- Cdf convergence gives almost-everywhere convergence of the raw lower
quantiles on the unit interval. -/
theorem ae_tendsto_quantile (hconv : CdfConvergesInDistribution μn μ) :
    ∀ᵐ u : I ∂volume,
      Tendsto (fun n => cdfQuantile (μn n) (u : ℝ)) atTop
        (𝓝 (cdfQuantile μ (u : ℝ))) := by
  let B : Set ℝ := {u : ℝ | u ∈ Ioo (0 : ℝ) 1 ∧
    ¬ ContinuousWithinAt (cdfQuantile μ) (Ioo (0 : ℝ) 1) u}
  have hBc : B.Countable := countable_badQuantileLevels (μ := μ)
  have hnotB : ∀ᵐ u : I ∂volume, (u : ℝ) ∉ B := by
    rw [ae_iff]
    simp only [not_not]
    change volume ((fun u : I => (u : ℝ)) ⁻¹' B) = 0
    exact (hBc.preimage Subtype.val_injective).measure_zero volume
  filter_upwards [ae_unitInterval_mem_Ioo, hnotB] with u hu hBu
  apply tendsto_quantile_of_continuousWithinAt hconv hu
  exact not_not.mp (fun hn => hBu ⟨hu, hn⟩)

end CdfQuantile

namespace CdfQuantile

variable {μ : ProbabilityMeasure ℝ} {μn : ℕ → ProbabilityMeasure ℝ}

/-- The measurable quantile representatives converge almost everywhere. -/
theorem ae_tendsto_measurableQuantile
    (hconv : CdfConvergesInDistribution μn μ) :
    ∀ᵐ u : I ∂volume,
      Tendsto (fun n => measurableQuantile (μn n) u) atTop
        (𝓝 (measurableQuantile μ u)) := by
  have hn : ∀ᵐ u : I ∂volume, ∀ n,
      cdfQuantile (μn n) (u : ℝ) = measurableQuantile (μn n) u := by
    rw [ae_all_iff]
    intro n
    exact ae_eq_measurableQuantile (μn n)
  filter_upwards [ae_tendsto_quantile hconv, hn, ae_eq_measurableQuantile μ]
      with u hraw hns hlim
  rw [← hlim]
  exact hraw.congr' (Filter.Eventually.of_forall hns)

end CdfQuantile
