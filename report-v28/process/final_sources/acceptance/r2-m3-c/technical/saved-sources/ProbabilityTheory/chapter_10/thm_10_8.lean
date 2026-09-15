import ProbabilityTheory.chapter_10.def_10_4

open Filter MeasureTheory ProbabilityTheory Set
open scoped Topology ENNReal

noncomputable section

/-- The open unit interval used as the common sample space. -/
abbrev QuantileSample := Set.Ioo (0 : ℝ) 1

/-- Lebesgue measure on `(0,1)`, regarded as a measure on the subtype. -/
noncomputable instance : MeasureSpace QuantileSample := Measure.Subtype.measureSpace

abbrev quantileMeasure : Measure QuantileSample := volume

instance : IsProbabilityMeasure quantileMeasure := by
  constructor
  rw [quantileMeasure, Measure.Subtype.volume_univ measurableSet_Ioo.nullMeasurableSet]
  norm_num [Real.volume_Ioo]

/-- The lower generalized inverse of the cdf of a real probability law. -/
def lawQuantile (μ : ProbabilityMeasure ℝ) (u : QuantileSample) : ℝ :=
  sSup {x : ℝ | measureCdf μ x < u.1}

private lemma cdf_eq (μ : ProbabilityMeasure ℝ) :
    measureCdf μ = cdf (μ : Measure ℝ) := by
  funext x
  exact (cdf_eq_real (μ : Measure ℝ) x).symm

private lemma quantile_set_nonempty (μ : ProbabilityMeasure ℝ) (u : QuantileSample) :
    {x : ℝ | measureCdf μ x < u.1}.Nonempty := by
  rw [cdf_eq μ]
  have h := (tendsto_cdf_atBot (μ : Measure ℝ)).eventually
    (eventually_lt_nhds u.2.1)
  obtain ⟨a, ha⟩ := eventually_atBot.1 h
  exact ⟨a, ha a le_rfl⟩

private lemma quantile_set_bddAbove (μ : ProbabilityMeasure ℝ) (u : QuantileSample) :
    BddAbove {x : ℝ | measureCdf μ x < u.1} := by
  rw [cdf_eq μ]
  have h := (tendsto_cdf_atTop (μ : Measure ℝ)).eventually
    (eventually_gt_nhds u.2.2)
  obtain ⟨a, ha⟩ := eventually_atTop.1 h
  refine ⟨a, ?_⟩
  intro x hx
  by_contra hxa
  have hax : a < x := lt_of_not_ge hxa
  exact (not_lt_of_ge (ha x hax.le).le) hx

lemma lawQuantile_lt_iff (μ : ProbabilityMeasure ℝ) (u : QuantileSample) (x : ℝ) :
    lawQuantile μ u < x ↔ ∃ y < x, u.1 ≤ measureCdf μ y := by
  constructor
  · intro hqx
    obtain ⟨y, hqy, hyx⟩ := exists_between hqx
    refine ⟨y, hyx, le_of_not_gt fun hy ↦ ?_⟩
    exact (not_le_of_gt hqy) (le_csSup (quantile_set_bddAbove μ u) hy)
  · rintro ⟨y, hyx, huy⟩
    refine (csSup_le (quantile_set_nonempty μ u) fun z hz ↦ ?_).trans_lt hyx
    by_contra hyz
    have hyz' : y < z := lt_of_not_ge hyz
    exact (not_lt_of_ge huy) ((measureReal_mono (Iic_subset_Iic.2 hyz'.le)).trans_lt hz)

lemma lawQuantile_le_iff (μ : ProbabilityMeasure ℝ) (u : QuantileSample) (x : ℝ) :
    lawQuantile μ u ≤ x ↔ u.1 ≤ measureCdf μ x := by
  constructor
  · intro hqx
    by_contra hux
    have hxu : measureCdf μ x < u.1 := lt_of_not_ge hux
    have hc : ContinuousWithinAt (measureCdf μ) (Ici x) x := by
      rw [cdf_eq μ]
      exact (cdf (μ : Measure ℝ)).right_continuous x
    have he : ∀ᶠ y in 𝓝[>] x, measureCdf μ y < u.1 :=
      (hc.mono Ioi_subset_Ici_self).eventually (Iio_mem_nhds hxu)
    have hi : ∀ᶠ y in 𝓝[>] x, y ∈ Ioi x := self_mem_nhdsWithin
    obtain ⟨y, hy, hxy⟩ := (he.and hi).exists
    have hyq : y ≤ lawQuantile μ u := le_csSup (quantile_set_bddAbove μ u) hy
    exact (not_lt_of_ge hqx) (hxy.trans_le hyq)
  · intro hux
    apply csSup_le (quantile_set_nonempty μ u)
    intro y hy
    by_contra hxy
    have hxy' : x < y := lt_of_not_ge hxy
    exact (not_lt_of_ge hux)
      ((measureReal_mono (Iic_subset_Iic.2 hxy'.le)).trans_lt hy)

lemma monotone_lawQuantile (μ : ProbabilityMeasure ℝ) : Monotone (lawQuantile μ) := by
  intro u v huv
  apply csSup_le (quantile_set_nonempty μ u)
  intro x hx
  apply le_csSup (quantile_set_bddAbove μ v)
  exact hx.trans_le (show u.1 ≤ v.1 from huv)

lemma measurable_lawQuantile (μ : ProbabilityMeasure ℝ) : Measurable (lawQuantile μ) :=
  (monotone_lawQuantile μ).measurable

/-- The quantile inverse image of a lower ray has the expected Lebesgue mass. -/
lemma quantile_preimage_Iic (μ : ProbabilityMeasure ℝ) (x : ℝ) :
    quantileMeasure (lawQuantile μ ⁻¹' Iic x) = (μ : Measure ℝ) (Iic x) := by
  have hs : MeasurableSet (lawQuantile μ ⁻¹' Iic x) :=
    (measurable_lawQuantile μ) measurableSet_Iic
  rw [quantileMeasure, Measure.Subtype.volume_def,
    Measure.comap_apply Subtype.val Subtype.val_injective
      (fun _ ht ↦ measurableSet_Ioo.subtype_image ht) volume hs]
  have himage : Subtype.val '' (lawQuantile μ ⁻¹' Iic x) =
      Ioc 0 (measureCdf μ x) \ {1} := by
    ext z
    constructor
    · rintro ⟨u, hu, rfl⟩
      refine ⟨⟨u.2.1, (lawQuantile_le_iff μ u x).1 hu⟩, ?_⟩
      simpa using ne_of_lt u.2.2
    · intro hz
      have hle : measureCdf μ x ≤ 1 := by
        rw [cdf_eq μ]
        exact cdf_le_one (μ : Measure ℝ) x
      have hz_ne : z ≠ 1 := by simpa using hz.2
      have hz_lt : z < 1 := lt_of_le_of_ne (le_trans hz.1.2 hle) hz_ne
      let u : QuantileSample := ⟨z, hz.1.1, hz_lt⟩
      exact ⟨u, (lawQuantile_le_iff μ u x).2 hz.1.2, rfl⟩
  rw [himage, measure_sdiff_null (by simp), Real.volume_Ioc]
  simp only [sub_zero]
  rw [measureCdf, ← cdf_eq_real (μ : Measure ℝ) x,
    ofReal_cdf (μ : Measure ℝ) x]

/-- Every quantile has exactly the prescribed probability law. -/
theorem lawQuantile_map (μ : ProbabilityMeasure ℝ) :
    quantileMeasure.map (lawQuantile μ) = (μ : Measure ℝ) := by
  apply Measure.ext_of_Iic
  intro x
  rw [Measure.map_apply (measurable_lawQuantile μ) measurableSet_Iic]
  exact quantile_preimage_Iic μ x


/-- Cdf convergence implies quantile convergence at every continuity level
of the limiting quantile. -/
theorem lawQuantile_tendsto_of_continuousAt
    (μn : ℕ → ProbabilityMeasure ℝ) (μ : ProbabilityMeasure ℝ)
    (hconv : CdfConvergesInDistribution μn μ) (u : QuantileSample)
    (hu : ContinuousAt (lawQuantile μ) u) :
    Tendsto (fun n ↦ lawQuantile (μn n) u) atTop (𝓝 (lawQuantile μ u)) := by
  have hmono : Monotone (measureCdf μ) := by
    intro x y hxy
    exact measureReal_mono (Iic_subset_Iic.2 hxy)
  have hD : Dense {x : ℝ | ContinuousAt (measureCdf μ) x} := by
    have hc := hmono.countable_not_continuousAt
    convert hc.dense_compl ℝ using 1
    ext x
    simp
  rw [tendsto_order]
  constructor
  · intro a ha
    have he : lawQuantile μ ⁻¹' Ioi a ∈ 𝓝 u :=
      hu.eventually (Ioi_mem_nhds ha)
    obtain ⟨l, r, hulr, hlr⟩ := mem_nhds_iff_exists_Ioo_subset.mp he
    obtain ⟨v, hlv, hvu⟩ := exists_between hulr.1
    have hav : a < lawQuantile μ v := hlr ⟨hlv, hvu.trans hulr.2⟩
    obtain ⟨y, hyD, hay, hyv⟩ := hD.exists_between hav
    have hycdf : measureCdf μ y < v.1 := by
      by_contra h
      exact (not_le_of_gt hyv) ((lawQuantile_le_iff μ v y).2 (le_of_not_gt h))
    have ht := hconv y hyD
    have hev : ∀ᶠ n in atTop, measureCdf (μn n) y < u.1 :=
      ht.eventually (Iio_mem_nhds (hycdf.trans hvu))
    filter_upwards [hev] with n hn
    exact hay.trans_le (le_csSup (quantile_set_bddAbove (μn n) u) hn)
  · intro b hb
    have he : lawQuantile μ ⁻¹' Iio b ∈ 𝓝 u :=
      hu.eventually (Iio_mem_nhds hb)
    obtain ⟨l, r, hulr, hlr⟩ := mem_nhds_iff_exists_Ioo_subset.mp he
    obtain ⟨w, huw, hwr⟩ := exists_between hulr.2
    have hwb : lawQuantile μ w < b := hlr ⟨hulr.1.trans huw, hwr⟩
    obtain ⟨y, hyD, hqwy, hyb⟩ := hD.exists_between hwb
    obtain ⟨z, hzy, hwz⟩ := (lawQuantile_lt_iff μ w y).1 hqwy
    have hwy : w.1 ≤ measureCdf μ y :=
      hwz.trans (measureReal_mono (Iic_subset_Iic.2 hzy.le))
    have ht := hconv y hyD
    have hev : ∀ᶠ n in atTop, u.1 ≤ measureCdf (μn n) y :=
      (ht.eventually (Ioi_mem_nhds
        ((show u.1 < w.1 from huw).trans_le hwy))).mono
        (fun _ hn ↦ hn.le)
    filter_upwards [hev] with n hn
    exact ((lawQuantile_le_iff (μn n) u y).2 hn).trans_lt hyb

/-- The exceptional set of levels is countable. -/
theorem countable_bad_quantile_levels (μ : ProbabilityMeasure ℝ) :
    Set.Countable {u : QuantileSample | ¬ ContinuousAt (lawQuantile μ) u} :=
  (monotone_lawQuantile μ).countable_not_continuousAt

/-- Quantiles converge almost everywhere on the common open unit interval. -/
private theorem countable_quantileMeasure_zero {s : Set QuantileSample}
    (hs : s.Countable) : quantileMeasure s = 0 := by
  rw [quantileMeasure, Measure.Subtype.volume_def,
    Measure.comap_apply Subtype.val Subtype.val_injective
      (fun _ ht ↦ measurableSet_Ioo.subtype_image ht) volume hs.measurableSet]
  exact (hs.image Subtype.val).measure_zero volume

theorem lawQuantile_ae_tendsto
    (μn : ℕ → ProbabilityMeasure ℝ) (μ : ProbabilityMeasure ℝ)
    (hconv : CdfConvergesInDistribution μn μ) :
    ∀ᵐ u ∂quantileMeasure,
      Tendsto (fun n ↦ lawQuantile (μn n) u) atTop (𝓝 (lawQuantile μ u)) := by
  have hae : ∀ᵐ u ∂quantileMeasure, ContinuousAt (lawQuantile μ) u :=
    ae_iff.2 (countable_quantileMeasure_zero (countable_bad_quantile_levels μ))
  filter_upwards [hae] with u hu
  exact lawQuantile_tendsto_of_continuousAt μn μ hconv u hu

/-- Skorokhod representation for a sequence of real probability laws stated
solely from the textbook cdf convergence hypothesis. -/
theorem thm_10_8
    (μn : ℕ → ProbabilityMeasure ℝ) (μ : ProbabilityMeasure ℝ)
    (hconv : CdfConvergesInDistribution μn μ) :
    ∃ (Yn : ℕ → QuantileSample → ℝ) (Y : QuantileSample → ℝ),
      (∀ n, Measurable (Yn n)) ∧ Measurable Y ∧
      (∀ n, quantileMeasure.map (Yn n) = (μn n : Measure ℝ)) ∧
      quantileMeasure.map Y = (μ : Measure ℝ) ∧
      (∀ᵐ u ∂quantileMeasure, Tendsto (fun n ↦ Yn n u) atTop (𝓝 (Y u))) := by
  refine ⟨fun n ↦ lawQuantile (μn n), lawQuantile μ,
    fun n ↦ measurable_lawQuantile (μn n), measurable_lawQuantile μ,
    fun n ↦ lawQuantile_map (μn n), lawQuantile_map μ, ?_⟩
  exact lawQuantile_ae_tendsto μn μ hconv

/-- Random-variable form: variables initially living on unrelated probability
spaces admit the same common-space representation, preserving every law. -/
theorem thm_10_8_randomVariables
    {Ωn : ℕ → Type*} [∀ n, MeasurableSpace (Ωn n)]
    {Ω : Type*} [MeasurableSpace Ω]
    (Pₙ : (n : ℕ) → Measure (Ωn n)) [∀ n, IsProbabilityMeasure (Pₙ n)]
    (Xₙ : (n : ℕ) → Ωn n → ℝ)
    (P : Measure Ω) [IsProbabilityMeasure P] (X : Ω → ℝ)
    (hconv : RandomVariablesConvergeInDistribution Pₙ Xₙ P X) :
    ∃ (Yₙ : ℕ → QuantileSample → ℝ) (Y : QuantileSample → ℝ),
      (∀ n, Measurable (Yₙ n)) ∧ Measurable Y ∧
      (∀ n, quantileMeasure.map (Yₙ n) = (Pₙ n).map (Xₙ n)) ∧
      quantileMeasure.map Y = P.map X ∧
      (∀ᵐ u ∂quantileMeasure, Tendsto (fun n ↦ Yₙ n u) atTop (𝓝 (Y u))) := by
  obtain ⟨hXₙ, hX, hweak⟩ :=
    (randomVariablesConvergeInDistribution_iff_laws Pₙ Xₙ P X).1 hconv
  let νₙ : ℕ → ProbabilityMeasure ℝ := fun n ↦
    ⟨(Pₙ n).map (Xₙ n), Measure.isProbabilityMeasure_map (hXₙ n)⟩
  let ν : ProbabilityMeasure ℝ :=
    ⟨P.map X, Measure.isProbabilityMeasure_map hX⟩
  have hcdf : CdfConvergesInDistribution νₙ ν :=
    (measuresConvergeInDistribution_iff_cdf νₙ ν).1 hweak
  obtain ⟨Yₙ, Y, hYₙ, hY, hlawₙ, hlaw, hae⟩ := thm_10_8 νₙ ν hcdf
  refine ⟨Yₙ, Y, hYₙ, hY, ?_, ?_, hae⟩
  · intro n
    simpa [νₙ] using hlawₙ n
  · simpa [ν] using hlaw

