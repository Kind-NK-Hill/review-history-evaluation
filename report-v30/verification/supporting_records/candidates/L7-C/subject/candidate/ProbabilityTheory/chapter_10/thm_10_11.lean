import Mathlib
import ProbabilityTheory.chapter_10.thm_10_10

/-!
# Theorem 10.11

The almost-sure core needs only continuity at the almost-everywhere limit.
The complete random-vector statement separately assumes measurability of the map.
-/

open Filter MeasureTheory Set Finset

/-- The supremum norm is bounded by the explicit Euclidean norm. -/
theorem piNorm_le_vectorEuclideanNorm {d : ℕ} (v : Fin d → ℝ) :
    ‖v‖ ≤ vectorEuclideanNorm v := by
  apply (pi_norm_le_iff_of_nonneg (Real.sqrt_nonneg _)).2
  intro i
  simpa only [Real.norm_eq_abs, vectorEuclideanNorm] using
    abs_coordinate_le_vectorEuclideanNorm v i

/-- The Euclidean norm is bounded by dimension times the supremum norm. -/
theorem vectorEuclideanNorm_le_card_mul_piNorm {d : ℕ} (v : Fin d → ℝ) :
    vectorEuclideanNorm v ≤ d * ‖v‖ := by
  calc
    vectorEuclideanNorm v ≤ ∑ i : Fin d, |v i| := vectorEuclideanNorm_le_sum_abs v
    _ = ∑ i : Fin d, ‖v i‖ := by simp only [Real.norm_eq_abs]
    _ ≤ d * ‖v‖ := by
      simpa [nsmul_eq_mul] using (Pi.sum_norm_apply_le_norm v)

/-- Pass from a measurable full event to an almost-everywhere vector limit. -/
theorem vectorConvergesAlmostSurely_ae
    {Ω : Type*} [MeasurableSpace Ω] {d : ℕ} (μ : Measure Ω)
    [IsProbabilityMeasure μ] {Vn : ℕ → Ω → Fin d → ℝ} {V : Ω → Fin d → ℝ}
    (h : VectorConvergesAlmostSurely μ Vn V) :
    ∀ᵐ ω ∂μ, Tendsto (fun n => Vn n ω) atTop (nhds (V ω)) := by
  rcases h with ⟨E, hEmeas, hEone, hconv⟩
  have hEcompl : μ Eᶜ = 0 := by
    rw [measure_compl hEmeas]
    · simp [hEone, IsProbabilityMeasure.measure_univ]
    · simp [hEone]
  refine ae_iff.2 (measure_mono_null ?_ hEcompl)
  intro ω hbad
  change ω ∉ E
  intro hω
  exact hbad (hconv ω hω)

/-- Choose a measurable full event representing an almost-everywhere vector limit. -/
theorem vectorConvergesAlmostSurely_of_ae
    {Ω : Type*} [MeasurableSpace Ω] {d : ℕ} (μ : Measure Ω)
    [IsProbabilityMeasure μ] {Vn : ℕ → Ω → Fin d → ℝ} {V : Ω → Fin d → ℝ}
    (h : ∀ᵐ ω ∂μ, Tendsto (fun n => Vn n ω) atTop (nhds (V ω))) :
    VectorConvergesAlmostSurely μ Vn V := by
  have hbad :
      μ {ω | ¬ Tendsto (fun n => Vn n ω) atTop (nhds (V ω))} = 0 := ae_iff.1 h
  obtain ⟨N, hsub, hNmeas, hNnull⟩ := exists_measurable_superset_of_null hbad
  refine ⟨Nᶜ, hNmeas.compl, ?_, ?_⟩
  · calc
      μ Nᶜ = μ univ - μ N := measure_compl hNmeas (by simp [hNnull])
      _ = 1 := by simp [hNnull, IsProbabilityMeasure.measure_univ]
  · intro ω hω
    by_contra hnot
    exact hω (hsub hnot)

/-- Continuous mapping for almost-sure convergence under the original local
continuity condition, without asserting measurability of the compositions. -/
theorem vectorContinuousMapping_almostSurely_core
    {Ω : Type*} [MeasurableSpace Ω] {d m : ℕ} (μ : Measure Ω)
    [IsProbabilityMeasure μ] (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (f : (Fin d → ℝ) → (Fin m → ℝ)) (S : Set (Fin d → ℝ))
    (hcontinuous : ∀ x ∈ S, ContinuousAt f x)
    (hVS : ∀ᵐ ω ∂μ, V ω ∈ S)
    (hconv : VectorConvergesAlmostSurely μ Vn V) :
    VectorConvergesAlmostSurely μ (fun n ω => f (Vn n ω)) (fun ω => f (V ω)) := by
  apply vectorConvergesAlmostSurely_of_ae μ
  filter_upwards [vectorConvergesAlmostSurely_ae μ hconv, hVS] with ω hω hωS
  exact (hcontinuous (V ω) hωS).tendsto.comp hω

/-- Bridge Euclidean convergence in probability to convergence in measure. -/
theorem tendstoInMeasure_of_vectorConvergesInProbability
    {Ω : Type*} [MeasurableSpace Ω] {d : ℕ} (μ : Measure Ω)
    {Vn : ℕ → Ω → Fin d → ℝ} {V : Ω → Fin d → ℝ}
    (h : VectorConvergesInProbability μ Vn V) :
    TendstoInMeasure μ Vn atTop V := by
  rw [tendstoInMeasure_iff_dist]
  intro ε hε
  have heps : 0 < ε / 2 := half_pos hε
  have hsub : ∀ n, {ω | ε ≤ dist (Vn n ω) (V ω)} ⊆
      vectorDeviationEvent Vn V n (ε / 2) := by
    intro n ω hω
    change ε / 2 < vectorEuclideanNorm (Vn n ω - V ω)
    calc
      ε / 2 < ε := half_lt_self hε
      _ ≤ dist (Vn n ω) (V ω) := hω
      _ = ‖Vn n ω - V ω‖ := dist_eq_norm _ _
      _ ≤ vectorEuclideanNorm (Vn n ω - V ω) := piNorm_le_vectorEuclideanNorm _
  exact tendsto_of_tendsto_of_tendsto_of_le_of_le tendsto_const_nhds
    (h (ε / 2) heps) (fun _ => bot_le) (fun n => measure_mono (hsub n))

/-- Bridge convergence in measure to the Euclidean probability interface. -/
theorem vectorConvergesInProbability_of_tendstoInMeasure
    {Ω : Type*} [MeasurableSpace Ω] {d : ℕ} (μ : Measure Ω)
    {Vn : ℕ → Ω → Fin d → ℝ} {V : Ω → Fin d → ℝ}
    (h : TendstoInMeasure μ Vn atTop V) :
    VectorConvergesInProbability μ Vn V := by
  by_cases hd : d = 0
  · subst d
    intro ε hε
    simp [vectorDeviationEvent, vectorEuclideanNorm, not_lt_of_ge hε.le]
  · have hdpos : 0 < (d : ℝ) := by exact_mod_cast Nat.pos_of_ne_zero hd
    intro ε hε
    have hδ : 0 < ε / d := div_pos hε hdpos
    have hsub : ∀ n, vectorDeviationEvent Vn V n ε ⊆
        {ω | ε / d ≤ dist (Vn n ω) (V ω)} := by
      intro n ω hω
      have hmul : ε < d * ‖Vn n ω - V ω‖ :=
        lt_of_lt_of_le hω (vectorEuclideanNorm_le_card_mul_piNorm _)
      have hnorm : ε / d < ‖Vn n ω - V ω‖ := by
        rw [div_lt_iff₀ hdpos]
        simpa [mul_comm] using hmul
      change ε / d ≤ dist (Vn n ω) (V ω)
      simpa only [dist_eq_norm] using hnorm.le
    exact tendsto_of_tendsto_of_tendsto_of_le_of_le tendsto_const_nhds
      ((tendstoInMeasure_iff_dist.1 h) (ε / d) hδ)
      (fun _ => bot_le) (fun n => measure_mono (hsub n))

/-- Locally continuous mapping preserves convergence in probability. -/
theorem vectorContinuousMapping_inProbability
    {Ω : Type*} [MeasurableSpace Ω] {d m : ℕ} (μ : Measure Ω)
    [IsProbabilityMeasure μ] (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (f : (Fin d → ℝ) → (Fin m → ℝ)) (S : Set (Fin d → ℝ))
    (hVn : ∀ n, Measurable (Vn n)) (hf : Measurable f)
    (hcontinuous : ∀ x ∈ S, ContinuousAt f x)
    (hVS : ∀ᵐ ω ∂μ, V ω ∈ S)
    (hconv : VectorConvergesInProbability μ Vn V) :
    VectorConvergesInProbability μ (fun n ω => f (Vn n ω)) (fun ω => f (V ω)) := by
  have hin : TendstoInMeasure μ Vn atTop V :=
    tendstoInMeasure_of_vectorConvergesInProbability μ hconv
  have houtMeas : ∀ n, AEStronglyMeasurable (fun ω => f (Vn n ω)) μ :=
    fun n => (hf.comp (hVn n)).aestronglyMeasurable
  have hout : TendstoInMeasure μ (fun n ω => f (Vn n ω)) atTop
      (fun ω => f (V ω)) := by
    rw [exists_seq_tendstoInMeasure_atTop_iff houtMeas]
    intro ns hns
    obtain ⟨ns', hns', hae⟩ :=
      (exists_seq_tendstoInMeasure_atTop_iff
        (fun n => (hVn n).aestronglyMeasurable)).1 hin ns hns
    refine ⟨ns', hns', ?_⟩
    filter_upwards [hae, hVS] with ω hω hωS
    exact (hcontinuous (V ω) hωS).tendsto.comp hω
  exact vectorConvergesInProbability_of_tendstoInMeasure μ hout

/-- The corrected theorem using an almost-everywhere membership hypothesis;
all composite measurability conclusions are derived in the proof. -/
theorem thm_10_11_ae
    {Ω : Type*} [MeasurableSpace Ω] {d m : ℕ} (μ : Measure Ω)
    [IsProbabilityMeasure μ] (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (f : (Fin d → ℝ) → (Fin m → ℝ)) (S : Set (Fin d → ℝ))
    (hVn : ∀ n, Measurable (Vn n)) (hV : Measurable V) (hf : Measurable f)
    (hcontinuous : ∀ x ∈ S, ContinuousAt f x)
    (hVS : ∀ᵐ ω ∂μ, V ω ∈ S) :
    (∀ n, Measurable (fun ω => f (Vn n ω))) ∧
    Measurable (fun ω => f (V ω)) ∧
    (VectorConvergesAlmostSurely μ Vn V →
      VectorConvergesAlmostSurely μ (fun n ω => f (Vn n ω)) (fun ω => f (V ω))) ∧
    (VectorConvergesInProbability μ Vn V →
      VectorConvergesInProbability μ (fun n ω => f (Vn n ω)) (fun ω => f (V ω))) := by
  refine ⟨fun n => hf.comp (hVn n), hf.comp hV, ?_, ?_⟩
  · exact vectorContinuousMapping_almostSurely_core μ Vn V f S hcontinuous hVS
  · exact vectorContinuousMapping_inProbability μ Vn V f S hVn hf hcontinuous hVS

/-- The corrected textbook formulation with the event V⁻¹(S) explicitly
measurable and of probability one. -/
theorem thm_10_11
    {Ω : Type*} [MeasurableSpace Ω] {d m : ℕ} (μ : Measure Ω)
    [IsProbabilityMeasure μ] (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (f : (Fin d → ℝ) → (Fin m → ℝ)) (S : Set (Fin d → ℝ))
    (hVn : ∀ n, Measurable (Vn n)) (hV : Measurable V) (hf : Measurable f)
    (hcontinuous : ∀ x ∈ S, ContinuousAt f x)
    (hVSmeas : MeasurableSet {ω | V ω ∈ S}) (hVSone : μ {ω | V ω ∈ S} = 1) :
    (∀ n, Measurable (fun ω => f (Vn n ω))) ∧
    Measurable (fun ω => f (V ω)) ∧
    (VectorConvergesAlmostSurely μ Vn V →
      VectorConvergesAlmostSurely μ (fun n ω => f (Vn n ω)) (fun ω => f (V ω))) ∧
    (VectorConvergesInProbability μ Vn V →
      VectorConvergesInProbability μ (fun n ω => f (Vn n ω)) (fun ω => f (V ω))) := by
  have hcompl : μ {ω | V ω ∈ S}ᶜ = 0 := by
    rw [measure_compl hVSmeas]
    · simp [hVSone, IsProbabilityMeasure.measure_univ]
    · simp [hVSone]
  have hVS : ∀ᵐ ω ∂μ, V ω ∈ S := by
    apply ae_iff.2
    have hbadset : {ω | ¬ V ω ∈ S} = {ω | V ω ∈ S}ᶜ := by
      ext ω
      simp
    rw [hbadset]
    exact hcompl
  exact thm_10_11_ae μ Vn V f S hVn hV hf hcontinuous hVS
