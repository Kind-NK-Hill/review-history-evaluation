import ProbabilityTheory.chapter_10.def_10_4
import ProbabilityTheory.chapter_03.prob_3_5

open Filter MeasureTheory ProbabilityTheory Set
open scoped Topology

noncomputable section

/-- The common probability space used in the quantile coupling. -/
abbrev unitIntervalProbabilitySpace := Set.Icc (0 : ℝ) 1

/-- Lebesgue measure on the unit interval is a probability measure. -/
theorem unitIntervalProbabilitySpace_isProbability :
    IsProbabilityMeasure (volume : Measure unitIntervalProbabilitySpace) := by
  infer_instance

/-- The lower generalized inverse of a real probability cdf. -/
def quantile (μ : ProbabilityMeasure ℝ) (u : unitIntervalProbabilitySpace) : ℝ :=
  if u.1 = 0 ∨ u.1 = 1 then 0 else
    sSup {x : ℝ | measureCdf μ x < u.1}

/-- The upper generalized inverse of a real probability cdf. -/
def upperQuantile (μ : ProbabilityMeasure ℝ) (u : unitIntervalProbabilitySpace) : ℝ :=
  if u.1 = 0 ∨ u.1 = 1 then 0 else
    sInf {x : ℝ | u.1 < measureCdf μ x}

private lemma cdf_lt_level_nonempty (μ : ProbabilityMeasure ℝ) {u : ℝ} (hu : 0 < u) :
    {x : ℝ | measureCdf μ x < u}.Nonempty := by
  have hlim : Tendsto (measureCdf μ) atBot (𝓝 0) := by
    convert tendsto_cdf_atBot (μ : Measure ℝ) using 1 <;> ext x <;> simp [measureCdf, cdf_eq_real]
  rcases (hlim.eventually (Iio_mem_nhds hu)).exists with ⟨x, hx⟩
  exact ⟨x, hx⟩

private lemma cdf_lt_level_bddAbove (μ : ProbabilityMeasure ℝ) {u : ℝ} (hu : u < 1) :
    BddAbove {x : ℝ | measureCdf μ x < u} := by
  have hlim : Tendsto (measureCdf μ) atTop (𝓝 1) := by
    convert tendsto_cdf_atTop (μ : Measure ℝ) using 1 <;> ext x <;> simp [measureCdf, cdf_eq_real]
  rcases (hlim.eventually (Ioi_mem_nhds hu)).exists with ⟨b, hb⟩
  refine ⟨b, ?_⟩
  intro x hx
  by_contra hxb
  have hbx : b ≤ x := le_of_not_ge hxb
  have hm : Monotone (measureCdf μ) := fun _ _ hxy =>
    measureReal_mono (μ := (μ : Measure ℝ)) (Iic_subset_Iic.2 hxy)
  exact (not_lt_of_ge (hb.le.trans (hm hbx))) hx

private lemma level_lt_cdf_nonempty (μ : ProbabilityMeasure ℝ) {u : ℝ} (hu : u < 1) :
    {x : ℝ | u < measureCdf μ x}.Nonempty := by
  have hlim : Tendsto (measureCdf μ) atTop (𝓝 1) := by
    convert tendsto_cdf_atTop (μ : Measure ℝ) using 1 <;> ext x <;> simp [measureCdf, cdf_eq_real]
  rcases (hlim.eventually (Ioi_mem_nhds hu)).exists with ⟨x, hx⟩
  exact ⟨x, hx⟩

private lemma level_lt_cdf_bddBelow (μ : ProbabilityMeasure ℝ) {u : ℝ} (hu : 0 < u) :
    BddBelow {x : ℝ | u < measureCdf μ x} := by
  have hlim : Tendsto (measureCdf μ) atBot (𝓝 0) := by
    convert tendsto_cdf_atBot (μ : Measure ℝ) using 1 <;> ext x <;> simp [measureCdf, cdf_eq_real]
  rcases (hlim.eventually (Iio_mem_nhds hu)).exists with ⟨b, hb⟩
  refine ⟨b, ?_⟩
  intro x hx
  by_contra hxb
  have hxb' : x < b := lt_of_not_ge hxb
  have hm : Monotone (measureCdf μ) := fun _ _ hxy =>
    measureReal_mono (μ := (μ : Measure ℝ)) (Iic_subset_Iic.2 hxy)
  exact (not_lt_of_ge ((hm hxb'.le).trans hb.le)) hx

theorem quantile_le_iff (μ : ProbabilityMeasure ℝ)
    (u : unitIntervalProbabilitySpace) (hu0 : 0 < u.1) (hu1 : u.1 < 1) (y : ℝ) :
    quantile μ u ≤ y ↔ u.1 ≤ measureCdf μ y := by
  rw [quantile, if_neg (by exact not_or_intro hu0.ne' hu1.ne)]
  constructor
  · intro hq
    by_contra hnot
    have hy : measureCdf μ y < u.1 := lt_of_not_ge hnot
    let q := sSup {x : ℝ | measureCdf μ x < u.1}
    have hqy : q ≤ y := hq
    rcases hqy.eq_or_lt with hEq | hlt
    · have hc := (cdf (μ : Measure ℝ)).right_continuous q
      have hright : ContinuousWithinAt (measureCdf μ) (Ici q) q := by
        convert hc using 1 <;> ext x <;> simp [measureCdf, cdf_eq_real]
      have hev : {z : ℝ | measureCdf μ z < u.1} ∈ 𝓝[Ici q] q :=
        hright.eventually_lt_const (hEq ▸ hy)
      rcases mem_nhdsWithin_iff_exists_mem_nhds_inter.1 hev with ⟨A, hA, hAI⟩
      rcases mem_nhds_iff_exists_Ioo_subset.1 hA with ⟨a, b, hqab, habA⟩
      rcases exists_between hqab.2 with ⟨z, hqz, hzb⟩
      have hz : measureCdf μ z < u.1 := hAI ⟨habA ⟨hqab.1.trans hqz, hzb⟩, hqz.le⟩
      have hzle : z ≤ q := le_csSup (cdf_lt_level_bddAbove μ hu1) hz
      exact (not_lt_of_ge hzle) hqz
    · have hymem : y ∈ {x : ℝ | measureCdf μ x < u.1} := hy
      have hyle : y ≤ q := le_csSup (cdf_lt_level_bddAbove μ hu1) hymem
      exact (not_lt_of_ge hyle) hlt
  · intro hy
    apply csSup_le (cdf_lt_level_nonempty μ hu0)
    intro x hx
    by_contra hxy
    have hyx : y < x := lt_of_not_ge hxy
    have hm : Monotone (measureCdf μ) := fun _ _ h =>
      measureReal_mono (μ := (μ : Measure ℝ)) (Iic_subset_Iic.2 h)
    exact (not_lt_of_ge (hy.trans (hm hyx.le))) hx

private def endpointSet : Set unitIntervalProbabilitySpace :=
  {u | u.1 = 0 ∨ u.1 = 1}

private theorem endpointSet_countable : endpointSet.Countable := by
  change (Subtype.val ⁻¹' ({0, 1} : Set ℝ)).Countable
  exact (Set.toFinite ({0, 1} : Set ℝ)).countable.preimage Subtype.val_injective

private theorem interior_quantile_rule (μ : ProbabilityMeasure ℝ) (y : ℝ) :
    ∀ u : unitIntervalProbabilitySpace, u ∉ endpointSet →
      (quantile μ u ≤ y ↔ u.1 ≤ measureCdf μ y) := by
  intro u hu
  change ¬ (u.1 = 0 ∨ u.1 = 1) at hu
  have hu0 : 0 < u.1 := lt_of_le_of_ne u.2.1 (fun h => hu (Or.inl h.symm))
  have hu1 : u.1 < 1 := lt_of_le_of_ne u.2.2 (fun h => hu (Or.inr h))
  exact quantile_le_iff μ u hu0 hu1 y

theorem measurable_quantile (μ : ProbabilityMeasure ℝ) : Measurable (quantile μ) := by
  refine measurable_of_Iic fun y => ?_
  let A : Set unitIntervalProbabilitySpace := {u | u.1 ≤ measureCdf μ y}
  have hA : MeasurableSet A := measurableSet_Iic.preimage measurable_subtype_coe
  have hE : MeasurableSet endpointSet := endpointSet_countable.measurableSet
  by_cases hy : 0 ≤ y
  · have heq : quantile μ ⁻¹' Iic y = (A ∩ endpointSetᶜ) ∪ endpointSet := by
      ext u
      by_cases hu : u ∈ endpointSet
      · have huv : u.1 = 0 ∨ u.1 = 1 := hu
        change (quantile μ u ≤ y) ↔ (u ∈ A ∧ u ∉ endpointSet) ∨ u ∈ endpointSet
        rw [quantile, if_pos huv]
        change (0 ≤ y) ↔ (u ∈ A ∧ u ∉ endpointSet) ∨ u ∈ endpointSet
        constructor
        · intro _; exact Or.inr hu
        · intro _; exact hy
      · change (quantile μ u ≤ y) ↔ (u ∈ A ∧ u ∉ endpointSet) ∨ u ∈ endpointSet
        rw [interior_quantile_rule μ y u hu]
        simp [A, hu]
    rw [heq]
    exact (hA.inter hE.compl).union hE
  · have heq : quantile μ ⁻¹' Iic y = A ∩ endpointSetᶜ := by
      ext u
      by_cases hu : u ∈ endpointSet
      · have huv : u.1 = 0 ∨ u.1 = 1 := hu
        change (quantile μ u ≤ y) ↔ u ∈ A ∧ u ∉ endpointSet
        rw [quantile, if_pos huv]
        change (0 ≤ y) ↔ u ∈ A ∧ u ∉ endpointSet
        constructor
        · exact fun h => (hy h).elim
        · exact fun h => (h.2 hu).elim
      · change (quantile μ u ≤ y) ↔ u ∈ A ∧ u ∉ endpointSet
        rw [interior_quantile_rule μ y u hu]
        simp [A, hu]
    rw [heq]
    exact hA.inter hE.compl

theorem quantile_map (μ : ProbabilityMeasure ℝ) :
    volume.map (quantile μ) = (μ : Measure ℝ) := by
  apply Measure.ext_of_Iic
  intro y
  rw [Measure.map_apply (measurable_quantile μ) measurableSet_Iic]
  let Fy : unitIntervalProbabilitySpace :=
    ⟨measureCdf μ y, measureReal_nonneg,
      measureReal_le_one⟩
  have hAE : quantile μ ⁻¹' Iic y =ᵐ[volume] Iic Fy := by
    have hnull : volume endpointSet = 0 := endpointSet_countable.measure_zero volume
    have hgood : endpointSetᶜ ∈ ae volume := compl_mem_ae_iff.2 hnull
    filter_upwards [hgood] with u hu
    change ((quantile μ u ≤ y) = (u.1 ≤ Fy.1))
    exact propext (by simpa [Fy] using interior_quantile_rule μ y u hu)
  rw [measure_congr hAE, unitInterval.volume_Iic]
  simpa [Fy, measureCdf] using ofReal_cdf (μ : Measure ℝ) y

/-- The limiting cdf has only countably many discontinuity points. -/
theorem measureCdf_discontinuities_countable (μ : ProbabilityMeasure ℝ) :
    Set.Countable {x : ℝ | ¬ ContinuousAt (measureCdf μ) x} := by
  have hm : Monotone (measureCdf μ) := fun _ _ h =>
    measureReal_mono (μ := (μ : Measure ℝ)) (Iic_subset_Iic.2 h)
  exact hm.countable_not_continuousAt

theorem quantile_le_upperQuantile (μ : ProbabilityMeasure ℝ)
    (u : unitIntervalProbabilitySpace) (hu0 : 0 < u.1) (hu1 : u.1 < 1) :
    quantile μ u ≤ upperQuantile μ u := by
  rw [quantile, upperQuantile, if_neg (not_or_intro hu0.ne' hu1.ne),
    if_neg (not_or_intro hu0.ne' hu1.ne)]
  apply csSup_le (cdf_lt_level_nonempty μ hu0)
  intro x hx
  apply le_csInf (level_lt_cdf_nonempty μ hu1)
  intro y hy
  by_contra hxy
  have hyx : y < x := lt_of_not_ge hxy
  have hm : Monotone (measureCdf μ) := fun _ _ h =>
    measureReal_mono (μ := (μ : Measure ℝ)) (Iic_subset_Iic.2 h)
  exact (not_lt_of_ge ((hm hyx.le).trans hx.le)) hy

theorem upperQuantile_le_quantile_of_lt (μ : ProbabilityMeasure ℝ)
    (u v : unitIntervalProbabilitySpace)
    (hu0 : 0 < u.1) (huv : u.1 < v.1) (hv1 : v.1 < 1) :
    upperQuantile μ u ≤ quantile μ v := by
  have hv0 : 0 < v.1 := hu0.trans huv
  have hu1 : u.1 < 1 := huv.trans hv1
  rw [upperQuantile, if_neg (not_or_intro hu0.ne' hu1.ne)]
  apply csInf_le (level_lt_cdf_bddBelow μ hu0)
  have hv : v.1 ≤ measureCdf μ (quantile μ v) :=
    (quantile_le_iff μ v hv0 hv1 (quantile μ v)).1 le_rfl
  exact huv.trans_le hv

/-- Levels at which the lower and upper generalized inverses disagree. -/
def badQuantileLevels (μ : ProbabilityMeasure ℝ) : Set unitIntervalProbabilitySpace :=
  {u | 0 < u.1 ∧ u.1 < 1 ∧ quantile μ u < upperQuantile μ u}

/-- Flat cdf levels give pairwise disjoint nonempty open gaps.  The standard
countability theorem for disjoint open sets (equivalently, choosing a rational
point in every gap) therefore makes the bad level set countable. -/
theorem badQuantileLevels_countable (μ : ProbabilityMeasure ℝ) :
    (badQuantileLevels μ).Countable := by
  apply Set.PairwiseDisjoint.countable_of_isOpen (s := fun u => Ioo (quantile μ u) (upperQuantile μ u))
  · intro u hu v hv huv
    have huvVal : u.1 ≠ v.1 := fun h => huv (Subtype.ext h)
    by_cases hlt : u.1 < v.1
    · apply Set.disjoint_left.2
      intro x hxu hxv
      have hcross := upperQuantile_le_quantile_of_lt μ u v hu.1 hlt hv.2.1
      exact (not_lt_of_ge hcross) (hxv.1.trans hxu.2)
    · have hvu : v.1 < u.1 := lt_of_le_of_ne (le_of_not_gt hlt) huvVal.symm
      apply Set.disjoint_left.2
      intro x hxu hxv
      have hcross := upperQuantile_le_quantile_of_lt μ v u hv.1 hvu hu.2.1
      exact (not_lt_of_ge hcross) (hxu.1.trans hxv.2)
  · intro u hu
    exact isOpen_Ioo
  · intro u hu
    exact ⟨(quantile μ u + upperQuantile μ u) / 2, by constructor <;> linarith [hu.2.2]⟩

/-- The bad levels, including the two endpoint conventions, have zero
Lebesgue measure on the common probability space. -/
theorem badQuantileLevels_measure_zero (μ : ProbabilityMeasure ℝ) :
    volume (badQuantileLevels μ ∪ endpointSet) = 0 := by
  exact (badQuantileLevels_countable μ).union endpointSet_countable |>.measure_zero volume

/-- Away from a null set, lower and upper quantiles coincide. -/
theorem quantile_eq_upperQuantile_ae (μ : ProbabilityMeasure ℝ) :
    ∀ᵐ u ∂(volume : Measure unitIntervalProbabilitySpace),
      quantile μ u = upperQuantile μ u := by
  rw [ae_iff]
  apply measure_mono_null (t := badQuantileLevels μ ∪ endpointSet)
  · intro u hne
    by_cases hu : u ∈ endpointSet
    · exact Or.inr hu
    · left
      have huval : ¬(u.1 = 0 ∨ u.1 = 1) := hu
      have hu0 : 0 < u.1 := lt_of_le_of_ne u.2.1 (fun h => huval (Or.inl h.symm))
      have hu1 : u.1 < 1 := lt_of_le_of_ne u.2.2 (fun h => huval (Or.inr h))
      exact ⟨hu0, hu1, lt_of_le_of_ne (quantile_le_upperQuantile μ u hu0 hu1) hne⟩
  · exact badQuantileLevels_measure_zero μ

/-- The upper quantile is measurable; it differs from the lower quantile only
on the countable set of flat levels and endpoints. -/
theorem measurable_upperQuantile (μ : ProbabilityMeasure ℝ) : Measurable (upperQuantile μ) := by
  apply (measurable_quantile μ).measurable_of_countable_ne
  apply ((badQuantileLevels_countable μ).union endpointSet_countable).mono
  intro u hne
  by_cases hu : u ∈ endpointSet
  · exact Or.inr hu
  · left
    have huval : ¬(u.1 = 0 ∨ u.1 = 1) := hu
    have hu0 : 0 < u.1 := lt_of_le_of_ne u.2.1 (fun h => huval (Or.inl h.symm))
    have hu1 : u.1 < 1 := lt_of_le_of_ne u.2.2 (fun h => huval (Or.inr h))
    exact ⟨hu0, hu1, lt_of_le_of_ne (quantile_le_upperQuantile μ u hu0 hu1) hne⟩

/-- The upper quantile has the same push-forward law as the lower quantile. -/
theorem upperQuantile_map (μ : ProbabilityMeasure ℝ) :
    volume.map (upperQuantile μ) = (μ : Measure ℝ) := by
  have hae : upperQuantile μ =ᵐ[volume] quantile μ :=
    Filter.EventuallyEq.symm (quantile_eq_upperQuantile_ae μ)
  rw [Measure.map_congr hae, quantile_map]

/-- Cdf convergence at continuity points implies almost-everywhere convergence
of the corresponding lower quantiles. -/
theorem quantile_tendsto_ae_of_cdf
    (μn : ℕ → ProbabilityMeasure ℝ) (μ : ProbabilityMeasure ℝ)
    (hconv : CdfConvergesInDistribution μn μ) :
    ∀ᵐ u ∂(volume : Measure unitIntervalProbabilitySpace),
      Tendsto (fun n => quantile (μn n) u) atTop (𝓝 (quantile μ u)) := by
  have hD : Dense {x : ℝ | ContinuousAt (measureCdf μ) x} := by
    convert (measureCdf_discontinuities_countable μ).dense_compl ℝ using 1
    ext x
    simp
  filter_upwards [quantile_eq_upperQuantile_ae μ,
    show ∀ᵐ u ∂(volume : Measure unitIntervalProbabilitySpace), u ∉ endpointSet by
      rw [ae_iff]
      simpa only [not_not, setOf_mem_eq] using endpointSet_countable.measure_zero volume] with u hqu huend
  have huval : ¬(u.1 = 0 ∨ u.1 = 1) := huend
  have hu0 : 0 < u.1 := lt_of_le_of_ne u.2.1 (fun h => huval (Or.inl h.symm))
  have hu1 : u.1 < 1 := lt_of_le_of_ne u.2.2 (fun h => huval (Or.inr h))
  apply tendsto_order.2
  constructor
  · intro a ha
    rcases hD.exists_between ha with ⟨c, hc, hac, hcq⟩
    have hFc : measureCdf μ c < u.1 := by
      by_contra hn
      have hqc : quantile μ u ≤ c :=
        (quantile_le_iff μ u hu0 hu1 c).2 (le_of_not_gt hn)
      exact (not_lt_of_ge hqc) hcq
    have hev : ∀ᶠ n in atTop, measureCdf (μn n) c < u.1 :=
      (hconv c hc).eventually_lt_const hFc
    filter_upwards [hev] with n hn
    have hnq : c < quantile (μn n) u := by
      by_contra hnc
      have huFn := (quantile_le_iff (μn n) u hu0 hu1 c).1 (le_of_not_gt hnc)
      exact (not_lt_of_ge huFn) hn
    exact hac.trans hnq
  · intro b hb
    rcases hD.exists_between hb with ⟨c, hc, hqc, hcb⟩
    have hFc : u.1 < measureCdf μ c := by
      have hInf : sInf {x : ℝ | u.1 < measureCdf μ x} < c := by
        have huqc : upperQuantile μ u < c := by rw [← hqu]; exact hqc
        unfold upperQuantile at huqc
        split at huqc
        · rename_i hend; exact (huval hend).elim
        · exact huqc
      rcases (csInf_lt_iff (level_lt_cdf_bddBelow μ hu0)
        (level_lt_cdf_nonempty μ hu1)).1 hInf with ⟨z, hz, hzc⟩
      have hm : Monotone (measureCdf μ) := fun _ _ h =>
        measureReal_mono (μ := (μ : Measure ℝ)) (Iic_subset_Iic.2 h)
      exact hz.trans_le (hm hzc.le)
    have hev : ∀ᶠ n in atTop, u.1 < measureCdf (μn n) c :=
      (hconv c hc).eventually (Ioi_mem_nhds hFc)
    filter_upwards [hev] with n hn
    have hqn : quantile (μn n) u ≤ c :=
      (quantile_le_iff (μn n) u hu0 hu1 c).2 hn.le
    exact hqn.trans_lt hcb

/-- Skorokhod representation for real random variables, realized explicitly by
lower quantiles on the unit interval. -/
theorem thm_10_8
    {Ωn : ℕ → Type*} [∀ n, MeasurableSpace (Ωn n)]
    {Ω : Type*} [MeasurableSpace Ω]
    (μn : (n : ℕ) → Measure (Ωn n)) [∀ n, IsProbabilityMeasure (μn n)]
    (Xn : (n : ℕ) → Ωn n → ℝ)
    (μ : Measure Ω) [IsProbabilityMeasure μ] (X : Ω → ℝ)
    (h : RandomVariablesConvergeInDistribution μn Xn μ X) :
    ∃ (Yn : ℕ → unitIntervalProbabilitySpace → ℝ)
      (Y : unitIntervalProbabilitySpace → ℝ),
      (∀ n, Measurable (Yn n)) ∧ Measurable Y ∧
      (∀ n, volume.map (Yn n) = (μn n).map (Xn n)) ∧
      volume.map Y = μ.map X ∧
      ∀ᵐ u ∂(volume : Measure unitIntervalProbabilitySpace),
        Tendsto (fun n => Yn n u) atTop (𝓝 (Y u)) := by
  rcases (randomVariablesConvergeInDistribution_iff_laws μn Xn μ X).1 h with
    ⟨hXn, hX, hLaw⟩
  let νn : ℕ → ProbabilityMeasure ℝ := fun n =>
    ⟨(μn n).map (Xn n), Measure.isProbabilityMeasure_map (hXn n)⟩
  let ν : ProbabilityMeasure ℝ :=
    ⟨μ.map X, Measure.isProbabilityMeasure_map hX⟩
  have hWeak : MeasuresConvergeInDistribution νn ν := hLaw
  have hCdf : CdfConvergesInDistribution νn ν :=
    (measuresConvergeInDistribution_iff_cdf νn ν).1 hWeak
  refine ⟨fun n => quantile (νn n), quantile ν,
    fun n => measurable_quantile (νn n), measurable_quantile ν, ?_, ?_,
    quantile_tendsto_ae_of_cdf νn ν hCdf⟩
  · intro n
    simpa [νn] using quantile_map (νn n)
  · simpa [ν] using quantile_map ν
