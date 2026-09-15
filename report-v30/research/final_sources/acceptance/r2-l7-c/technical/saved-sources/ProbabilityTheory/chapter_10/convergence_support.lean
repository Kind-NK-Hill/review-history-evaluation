import Mathlib
import ProbabilityTheory.chapter_10.coordinate_convergence_support

open Filter MeasureTheory
open scoped BigOperators ENNReal Topology

/-- The textbook strict-deviation definition for real random variables agrees
with Mathlib convergence in measure on a probability space. -/
theorem convergesInProbability_iff_tendstoInMeasure
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    (Xn : ℕ → Ω → ℝ) (X : Ω → ℝ)
    (hXn : ∀ n, Measurable (Xn n)) (hX : Measurable X) :
    ConvergesInProbability μ Xn X ↔ TendstoInMeasure μ Xn atTop X := by
  constructor
  · intro h
    rw [tendstoInMeasure_iff_dist]
    intro ε hε
    have hsub : ∀ n, {ω | ε ≤ dist (Xn n ω) (X ω)} ⊆ deviationEvent Xn X n (ε / 2) := by
      intro n ω hω
      change ε ≤ |Xn n ω - X ω| at hω
      change ε / 2 < |Xn n ω - X ω|
      linarith
    exact tendsto_of_tendsto_of_tendsto_of_le_of_le tendsto_const_nhds
      (h.2.2 (ε / 2) (by linarith)) (fun _ ↦ bot_le) (fun n ↦ measure_mono (hsub n))
  · intro h
    refine ⟨hXn, hX, ?_⟩
    intro ε hε
    have ht := (tendstoInMeasure_iff_dist.mp h) ε hε
    have hsub : ∀ n, deviationEvent Xn X n ε ⊆ {ω | ε ≤ dist (Xn n ω) (X ω)} := by
      intro n ω hω
      change ε < |Xn n ω - X ω| at hω
      change ε ≤ |Xn n ω - X ω|
      exact hω.le
    exact tendsto_of_tendsto_of_tendsto_of_le_of_le tendsto_const_nhds ht
      (fun _ ↦ bot_le) (fun n ↦ measure_mono (hsub n))

/-- Convergence in measure into a finite product is coordinatewise. -/
theorem tendstoInMeasure_pi_iff
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    {d : ℕ} (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ) :
    TendstoInMeasure μ Vn atTop V ↔
      ∀ i : Fin d, TendstoInMeasure μ (fun n ω ↦ Vn n ω i) atTop (fun ω ↦ V ω i) := by
  constructor
  · intro h i
    rw [tendstoInMeasure_iff_norm] at h ⊢
    intro ε hε
    have hsub : ∀ n, {ω | ε ≤ ‖Vn n ω i - V ω i‖} ⊆
        {ω | ε ≤ ‖Vn n ω - V ω‖} := by
      intro n ω hω
      exact hω.trans (norm_le_pi_norm (Vn n ω - V ω) i)
    exact tendsto_of_tendsto_of_tendsto_of_le_of_le tendsto_const_nhds (h ε hε)
      (fun _ ↦ bot_le) (fun n ↦ measure_mono (hsub n))
  · intro h
    rw [tendstoInMeasure_iff_norm]
    intro ε hε
    by_cases hd : d = 0
    · subst d
      have hempty : ∀ n, {ω | ε ≤ ‖Vn n ω - V ω‖} = ∅ := by
        intro n
        ext ω
        simp only [Set.mem_setOf_eq, Set.mem_empty_iff_false, iff_false, not_le]
        have hz : Vn n ω - V ω = 0 := Subsingleton.elim _ _
        rw [hz, norm_zero]
        exact hε
      simp_rw [hempty, measure_empty]
      exact tendsto_const_nhds
    · letI : Nonempty (Fin d) := ⟨⟨0, Nat.pos_of_ne_zero hd⟩⟩
      let δ := ε / 2
      have hδ : 0 < δ := by dsimp [δ]; linarith
      have hsub : ∀ n, {ω | ε ≤ ‖Vn n ω - V ω‖} ⊆
          ⋃ i : Fin d, {ω | δ ≤ ‖Vn n ω i - V ω i‖} := by
        intro n ω hω
        simp only [Set.mem_iUnion, Set.mem_setOf_eq]
        by_contra hall
        push Not at hall
        have hle : ‖Vn n ω - V ω‖ ≤ δ := by
          rw [pi_norm_le_iff_of_nonempty]
          intro i
          exact (hall i).le
        change ε ≤ ‖Vn n ω - V ω‖ at hω
        dsimp [δ] at hle
        linarith
      have hsum : Tendsto
          (fun n ↦ ∑ i : Fin d, μ {ω | δ ≤ ‖Vn n ω i - V ω i‖})
          atTop (nhds 0) := by
        simpa using tendsto_finsetSum Finset.univ fun i _ ↦
          (tendstoInMeasure_iff_norm.mp (h i)) δ hδ
      refine tendsto_of_tendsto_of_tendsto_of_le_of_le tendsto_const_nhds hsum
        (fun _ ↦ bot_le) ?_
      intro n
      exact (measure_mono (hsub n)).trans (measure_iUnion_fintype_le μ _)

/-- Bridge from the book's Euclidean-event vector definition to convergence in
measure for the (topologically equivalent) finite product norm. -/
theorem vectorConvergesInProbability_iff_tendstoInMeasure
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    {d : ℕ} (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (hVn : ∀ n, Measurable (Vn n)) (hV : Measurable V) :
    VectorConvergesInProbability μ Vn V ↔ TendstoInMeasure μ Vn atTop V := by
  rw [vectorConvergesInProbability_iff_coordinatewise μ Vn V hVn hV,
    tendstoInMeasure_pi_iff]
  constructor <;> intro h i
  · exact (convergesInProbability_iff_tendstoInMeasure μ _ _
      (fun n ↦ (measurable_pi_iff.mp (hVn n)) i) ((measurable_pi_iff.mp hV) i)).mp (h i)
  · exact (convergesInProbability_iff_tendstoInMeasure μ _ _
      (fun n ↦ (measurable_pi_iff.mp (hVn n)) i) ((measurable_pi_iff.mp hV) i)).mpr (h i)

/-- Continuous mapping theorem for convergence in measure when continuity is
required only at the almost-everywhere values of the limit. -/
theorem tendstoInMeasure_comp_of_continuousAt_ae
    {Ω E F : Type*} [MeasurableSpace Ω] [PseudoMetricSpace E] [PseudoMetricSpace F]
    (μ : Measure Ω) [IsFiniteMeasure μ] (Un : ℕ → Ω → E) (U : Ω → E) (f : E → F)
    (hcomp : ∀ n, AEStronglyMeasurable (f ∘ Un n) μ)
    (hconv : TendstoInMeasure μ Un atTop U)
    (hcont : ∀ᵐ ω ∂μ, ContinuousAt f (U ω)) :
    TendstoInMeasure μ (fun n ↦ f ∘ Un n) atTop (f ∘ U) := by
  rw [exists_seq_tendstoInMeasure_atTop_iff hcomp]
  intro ns hns
  obtain ⟨ns', hns', hae⟩ := (hconv.comp hns.tendsto_atTop).exists_seq_tendsto_ae
  refine ⟨ns', hns', ?_⟩
  filter_upwards [hae, hcont] with ω hlim hc
  exact hc.tendsto.comp hlim
