import Mathlib
import ProbabilityTheory.chapter_10.thm_10_10

open Filter MeasureTheory
open scoped ENNReal

private lemma tendstoInMeasure_iff_measure_dist_gt
    {Ω E : Type*} [MeasurableSpace Ω] [PseudoMetricSpace E]
    (μ : Measure Ω) (Fn : ℕ → Ω → E) (F : Ω → E) :
    TendstoInMeasure μ Fn atTop F ↔
      ∀ ε : ℝ, 0 < ε →
        Tendsto (fun n => μ {ω | dist (Fn n ω) (F ω) > ε}) atTop (nhds 0) := by
  constructor
  · intro h ε hε
    have h' := (tendstoInMeasure_iff_dist.mp h) ε hε
    refine tendsto_of_tendsto_of_tendsto_of_le_of_le tendsto_const_nhds h'
      (fun _ => bot_le) ?_
    intro n
    apply measure_mono
    intro ω hω
    change ε ≤ dist (Fn n ω) (F ω)
    exact le_of_lt hω
  · intro h
    rw [tendstoInMeasure_iff_dist]
    intro ε hε
    have h' := h (ε / 2) (half_pos hε)
    refine tendsto_of_tendsto_of_tendsto_of_le_of_le tendsto_const_nhds h'
      (fun _ => bot_le) ?_
    intro n
    apply measure_mono
    intro ω hω
    exact lt_of_lt_of_le (half_lt_self hε) hω

noncomputable def vectorToEuclidean {d : ℕ} (v : Fin d → ℝ) :
    WithLp 2 (Fin d → ℝ) := WithLp.toLp 2 v

@[simp] private lemma vectorToEuclidean_ofEuclidean {d : ℕ}
    (x : WithLp 2 (Fin d → ℝ)) :
    vectorToEuclidean (fun i => x i) = x := by
  ext i
  rfl

private lemma vectorProbability_iff_tendstoInMeasure
    {Ω : Type*} [MeasurableSpace Ω] {d : ℕ} (μ : Measure Ω)
    (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ) :
    VectorConvergesInProbability μ Vn V ↔
      TendstoInMeasure μ
        (fun n ω => vectorToEuclidean (Vn n ω)) atTop
        (fun ω => vectorToEuclidean (V ω)) := by
  rw [tendstoInMeasure_iff_measure_dist_gt]
  simp only [VectorConvergesInProbability, vectorDeviationEvent]
  congr! 4 with ε hε n
  apply congrArg μ
  ext ω
  simp only [Set.mem_setOf_eq, vectorToEuclidean, EuclideanSpace.dist_eq,
    Real.dist_eq, sq_abs, vectorEuclideanNorm, Pi.sub_apply]

private lemma measure_one_ae_mem
    {Ω E : Type*} [MeasurableSpace Ω] [MeasurableSpace E]
    (μ : Measure Ω) [IsProbabilityMeasure μ] (G : Ω → E) (S : Set E)
    (hG : Measurable G) (hS : MeasurableSet S) (hone : μ (G ⁻¹' S) = 1) :
    ∀ᵐ ω ∂μ, G ω ∈ S := by
  apply ae_iff.2
  have hpre : MeasurableSet (G ⁻¹' S) := hS.preimage hG
  have hfin : μ (G ⁻¹' S) ≠ ⊤ := by rw [hone]; simp
  have hc : μ (G ⁻¹' S)ᶜ = 0 := by
    rw [MeasureTheory.measure_compl hpre hfin]
    simp [hone, MeasureTheory.IsProbabilityMeasure.measure_univ]
  rw [show {ω | G ω ∉ S} = (G ⁻¹' S)ᶜ by ext ω; simp]
  exact hc

private lemma vectorAE_of_event
    {Ω : Type*} [MeasurableSpace Ω] {d : ℕ} (μ : Measure Ω)
    [IsProbabilityMeasure μ] (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (h : VectorConvergesAlmostSurely μ Vn V) :
    ∀ᵐ ω ∂μ, Tendsto (fun n => Vn n ω) atTop (nhds (V ω)) := by
  rcases h with ⟨E, hE, hone, hconv⟩
  have hmem : ∀ᵐ ω ∂μ, ω ∈ E :=
    measure_one_ae_mem μ id E measurable_id hE (by simpa using hone)
  filter_upwards [hmem] with ω hω
  exact hconv ω hω

private lemma vectorAE_to_event
    {Ω : Type*} [MeasurableSpace Ω] {d : ℕ} (μ : Measure Ω)
    [IsProbabilityMeasure μ] (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (h : ∀ᵐ ω ∂μ, Tendsto (fun n => Vn n ω) atTop (nhds (V ω))) :
    VectorConvergesAlmostSurely μ Vn V := by
  have hbad : μ {ω | ¬ Tendsto (fun n => Vn n ω) atTop (nhds (V ω))} = 0 :=
    ae_iff.1 h
  obtain ⟨N, hsub, hNm, hN0⟩ := exists_measurable_superset_of_null hbad
  have hone : μ Nᶜ = 1 := by
    have hfin : μ N ≠ ⊤ := by rw [hN0]; simp
    rw [MeasureTheory.measure_compl hNm hfin]
    simp [hN0, MeasureTheory.IsProbabilityMeasure.measure_univ]
  refine ⟨Nᶜ, hNm.compl, hone, ?_⟩
  intro ω hω
  by_contra hn
  exact hω (hsub hn)

/-- Continuous mapping theorem for almost-sure convergence.  Continuity is
required only at points of `S`; global measurability of `f` is used to derive,
rather than assume, measurability of both composite random vectors. -/
theorem continuousMapping_almostSurely
    {Ω : Type*} [MeasurableSpace Ω] {d m : ℕ} (μ : Measure Ω)
    [IsProbabilityMeasure μ]
    (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (f : WithLp 2 (Fin d → ℝ) → WithLp 2 (Fin m → ℝ))
    (S : Set (WithLp 2 (Fin d → ℝ)))
    (hVn : ∀ n, Measurable (Vn n)) (hV : Measurable V)
    (hfmeas : Measurable f) (hS : MeasurableSet S)
    (hcont : ∀ x ∈ S, ContinuousAt f x)
    (hVS : μ ((fun ω => vectorToEuclidean (V ω)) ⁻¹' S) = 1)
    (hconv : VectorConvergesAlmostSurely μ Vn V) :
    (∀ n, Measurable (fun ω i => f (vectorToEuclidean (Vn n ω)) i)) ∧
      Measurable (fun ω i => f (vectorToEuclidean (V ω)) i) ∧
      VectorConvergesAlmostSurely μ
        (fun n ω i => f (vectorToEuclidean (Vn n ω)) i)
        (fun ω i => f (vectorToEuclidean (V ω)) i) := by
  have hVnE : ∀ n, Measurable (fun ω => vectorToEuclidean (Vn n ω)) :=
    fun n => by
      change Measurable (WithLp.toLp 2 ∘ Vn n)
      exact (PiLp.continuous_toLp (p := (2 : ℝ≥0∞)) (fun _ : Fin d => ℝ)).measurable.comp (hVn n)
  have hVE : Measurable (fun ω => vectorToEuclidean (V ω)) :=
    (PiLp.continuous_toLp (p := (2 : ℝ≥0∞)) (fun _ : Fin d => ℝ)).measurable.comp hV
  have hFn : ∀ n, Measurable (fun ω i => f (vectorToEuclidean (Vn n ω)) i) :=
    fun n => Measurable.comp (WithLp.measurable_ofLp (p := (2 : ℝ≥0∞)) (∀ _ : Fin m, ℝ)) (hfmeas.comp (hVnE n))
  have hF : Measurable (fun ω i => f (vectorToEuclidean (V ω)) i) :=
    Measurable.comp (WithLp.measurable_ofLp (p := (2 : ℝ≥0∞)) (∀ _ : Fin m, ℝ)) (hfmeas.comp hVE)
  refine ⟨hFn, hF, vectorAE_to_event μ _ _ ?_⟩
  have haeV := vectorAE_of_event μ Vn V hconv
  have haeS := measure_one_ae_mem μ (fun ω => vectorToEuclidean (V ω)) S hVE hS hVS
  filter_upwards [haeV, haeS] with ω hω hωS
  have hωE : Tendsto (fun n => vectorToEuclidean (Vn n ω)) atTop
      (nhds (vectorToEuclidean (V ω))) :=
    (PiLp.continuous_toLp (p := (2 : ℝ≥0∞)) (fun _ : Fin d => ℝ)).tendsto (V ω) |>.comp hω
  have hfω := (hcont _ hωS).tendsto.comp hωE
  exact (PiLp.continuous_ofLp (p := (2 : ℝ≥0∞)) (fun _ : Fin m => ℝ)).tendsto (f (vectorToEuclidean (V ω))) |>.comp hfω

/-- Continuous mapping theorem for convergence in probability, with the same
local continuity and full-measure hypotheses. -/
theorem continuousMapping_inProbability
    {Ω : Type*} [MeasurableSpace Ω] {d m : ℕ} (μ : Measure Ω)
    [IsProbabilityMeasure μ]
    (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (f : WithLp 2 (Fin d → ℝ) → WithLp 2 (Fin m → ℝ))
    (S : Set (WithLp 2 (Fin d → ℝ)))
    (hVn : ∀ n, Measurable (Vn n)) (hV : Measurable V)
    (hfmeas : Measurable f) (hS : MeasurableSet S)
    (hcont : ∀ x ∈ S, ContinuousAt f x)
    (hVS : μ ((fun ω => vectorToEuclidean (V ω)) ⁻¹' S) = 1)
    (hconv : VectorConvergesInProbability μ Vn V) :
    (∀ n, Measurable (fun ω i => f (vectorToEuclidean (Vn n ω)) i)) ∧
      Measurable (fun ω i => f (vectorToEuclidean (V ω)) i) ∧
      VectorConvergesInProbability μ
        (fun n ω i => f (vectorToEuclidean (Vn n ω)) i)
        (fun ω i => f (vectorToEuclidean (V ω)) i) := by
  have hVnE : ∀ n, Measurable (fun ω => vectorToEuclidean (Vn n ω)) :=
    fun n => by
      change Measurable (WithLp.toLp 2 ∘ Vn n)
      exact (PiLp.continuous_toLp (p := (2 : ℝ≥0∞)) (fun _ : Fin d => ℝ)).measurable.comp (hVn n)
  have hVE : Measurable (fun ω => vectorToEuclidean (V ω)) :=
    (PiLp.continuous_toLp (p := (2 : ℝ≥0∞)) (fun _ : Fin d => ℝ)).measurable.comp hV
  have hFnE : ∀ n, Measurable (fun ω => f (vectorToEuclidean (Vn n ω))) :=
    fun n => hfmeas.comp (hVnE n)
  have hFn : ∀ n, Measurable (fun ω i => f (vectorToEuclidean (Vn n ω)) i) :=
    fun n => Measurable.comp (WithLp.measurable_ofLp (p := (2 : ℝ≥0∞)) (∀ _ : Fin m, ℝ)) (hFnE n)
  have hF : Measurable (fun ω i => f (vectorToEuclidean (V ω)) i) :=
    Measurable.comp (WithLp.measurable_ofLp (p := (2 : ℝ≥0∞)) (∀ _ : Fin m, ℝ)) (hfmeas.comp hVE)
  refine ⟨hFn, hF, vectorProbability_iff_tendstoInMeasure μ _ _ |>.2 ?_⟩
  simp only [vectorToEuclidean_ofEuclidean]
  rw [exists_seq_tendstoInMeasure_atTop_iff
    (fun n => (hFnE n).aestronglyMeasurable)]
  intro ns hns
  have hin := (vectorProbability_iff_tendstoInMeasure μ Vn V).1 hconv
  obtain ⟨ns', hns', hae⟩ := (hin.comp hns.tendsto_atTop).exists_seq_tendsto_ae
  refine ⟨ns', hns', ?_⟩
  have haeS := measure_one_ae_mem μ (fun ω => vectorToEuclidean (V ω)) S hVE hS hVS
  filter_upwards [hae, haeS] with ω hω hωS
  exact (hcont _ hωS).tendsto.comp hω

/-- Textbook Theorem 10.11, bundling its almost-sure and in-probability parts. -/
theorem thm_10_11
    {Ω : Type*} [MeasurableSpace Ω] {d m : ℕ} (μ : Measure Ω)
    [IsProbabilityMeasure μ]
    (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (f : WithLp 2 (Fin d → ℝ) → WithLp 2 (Fin m → ℝ))
    (S : Set (WithLp 2 (Fin d → ℝ)))
    (hVn : ∀ n, Measurable (Vn n)) (hV : Measurable V)
    (hfmeas : Measurable f) (hS : MeasurableSet S)
    (hcont : ∀ x ∈ S, ContinuousAt f x)
    (hVS : μ ((fun ω => vectorToEuclidean (V ω)) ⁻¹' S) = 1) :
    (VectorConvergesAlmostSurely μ Vn V →
      VectorConvergesAlmostSurely μ
        (fun n ω i => f (vectorToEuclidean (Vn n ω)) i)
        (fun ω i => f (vectorToEuclidean (V ω)) i)) ∧
    (VectorConvergesInProbability μ Vn V →
      VectorConvergesInProbability μ
        (fun n ω i => f (vectorToEuclidean (Vn n ω)) i)
        (fun ω i => f (vectorToEuclidean (V ω)) i)) := by
  constructor
  · intro h
    exact (continuousMapping_almostSurely μ Vn V f S hVn hV hfmeas hS hcont hVS h).2.2
  · intro h
    exact (continuousMapping_inProbability μ Vn V f S hVn hV hfmeas hS hcont hVS h).2.2
