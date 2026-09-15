import Mathlib
import ProbabilityTheory.chapter_10.def_10_6

open Filter MeasureTheory
open scoped BigOperators ENNReal Topology

/-- Every coordinate is bounded by the Euclidean norm. -/
theorem abs_coordinate_le_vectorEuclideanNorm {d : ℕ} (v : Fin d → ℝ) (i : Fin d) :
    |v i| ≤ vectorEuclideanNorm v := by
  rw [vectorEuclideanNorm]
  have hsum : 0 ≤ ∑ j : Fin d, (v j) ^ 2 := Finset.sum_nonneg fun _ _ ↦ sq_nonneg _
  have hi : (v i) ^ 2 ≤ ∑ j : Fin d, (v j) ^ 2 :=
    Finset.single_le_sum (fun j _ ↦ sq_nonneg (v j)) (Finset.mem_univ i)
  have hsqrt : (Real.sqrt (∑ j : Fin d, (v j) ^ 2)) ^ 2 =
      ∑ j : Fin d, (v j) ^ 2 := Real.sq_sqrt hsum
  have habs : |v i| ^ 2 = (v i) ^ 2 := sq_abs (v i)
  nlinarith [abs_nonneg (v i), Real.sqrt_nonneg (∑ j : Fin d, (v j) ^ 2)]

/-- Coordinate bounds imply the Euclidean bound; this includes dimension zero. -/
theorem vectorEuclideanNorm_le_of_forall_abs_le {d : ℕ} (v : Fin d → ℝ)
    {ε : ℝ} (hε : 0 ≤ ε)
    (hcoord : ∀ i : Fin d, |v i| ≤ ε / Real.sqrt d) :
    vectorEuclideanNorm v ≤ ε := by
  by_cases hd : d = 0
  · subst d
    simpa [vectorEuclideanNorm] using hε
  · have hdpos_nat : 0 < d := Nat.pos_of_ne_zero hd
    have hdpos : (0 : ℝ) < d := by exact_mod_cast hdpos_nat
    have hsqrt_pos : 0 < Real.sqrt (d : ℝ) := Real.sqrt_pos.2 hdpos
    have hsqrt_sq : (Real.sqrt (d : ℝ)) ^ 2 = d := Real.sq_sqrt hdpos.le
    have hterm : ∀ i : Fin d, (v i) ^ 2 ≤ (ε / Real.sqrt (d : ℝ)) ^ 2 := by
      intro i
      have hq : 0 ≤ ε / Real.sqrt (d : ℝ) := div_nonneg hε hsqrt_pos.le
      nlinarith [hcoord i, abs_nonneg (v i), sq_abs (v i)]
    have hsum : (∑ i : Fin d, (v i) ^ 2) ≤
        ∑ _i : Fin d, (ε / Real.sqrt (d : ℝ)) ^ 2 :=
      Finset.sum_le_sum fun i _ ↦ hterm i
    have hsum_nonneg : 0 ≤ ∑ i : Fin d, (v i) ^ 2 :=
      Finset.sum_nonneg fun _ _ ↦ sq_nonneg _
    have hconst : (∑ _i : Fin d, (ε / Real.sqrt (d : ℝ)) ^ 2) = ε ^ 2 := by
      rw [Finset.sum_const, Finset.card_univ, Fintype.card_fin]
      simp only [nsmul_eq_mul]
      field_simp
      nlinarith
    rw [vectorEuclideanNorm]
    have hsqrt_sum_sq := Real.sq_sqrt hsum_nonneg
    have hsqrt_nonneg := Real.sqrt_nonneg (∑ i : Fin d, (v i) ^ 2)
    rw [hconst] at hsum
    nlinarith

/-- Almost-sure vector convergence iff coordinatewise almost-sure convergence. -/
theorem vectorConvergesAlmostSurely_iff_coordinatewise
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    {d : ℕ} (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (hVn : ∀ n, Measurable (Vn n)) (hV : Measurable V) :
    VectorConvergesAlmostSurely μ Vn V ↔
      ∀ i : Fin d, ConvergesAlmostSurely μ
        (fun n ω ↦ Vn n ω i) (fun ω ↦ V ω i) := by
  constructor
  · rintro ⟨E, hEmeas, hEone, hEconv⟩ i
    refine ⟨fun n ↦ ((measurable_pi_iff.mp (hVn n)) i).aestronglyMeasurable,
      ((measurable_pi_iff.mp hV) i).aestronglyMeasurable, ?_⟩
    have hEc : μ Eᶜ = 0 := by
      rw [measure_compl hEmeas (by simp [hEone])]
      simp [hEone, IsProbabilityMeasure.measure_univ]
    filter_upwards [ae_iff.2 hEc] with ω hω
    exact (tendsto_pi_nhds.1 (hEconv ω (by simpa using hω))) i
  · intro hcoord
    have hae_coord : ∀ᵐ ω ∂μ, ∀ i : Fin d,
        Tendsto (fun n ↦ Vn n ω i) atTop (nhds (V ω i)) :=
      ae_all_iff.2 fun i ↦ (hcoord i).2.2
    have hae_vec : ∀ᵐ ω ∂μ,
        Tendsto (fun n ↦ Vn n ω) atTop (nhds (V ω)) := by
      filter_upwards [hae_coord] with ω hω
      exact tendsto_pi_nhds.2 hω
    have hbad : μ {ω : Ω | ¬ Tendsto (fun n ↦ Vn n ω) atTop (nhds (V ω))} = 0 :=
      ae_iff.1 hae_vec
    obtain ⟨N, hsub, hNmeas, hNnull⟩ := exists_measurable_superset_of_null hbad
    refine ⟨Nᶜ, hNmeas.compl, ?_, ?_⟩
    · rw [measure_compl hNmeas (by simp [hNnull])]
      simp [hNnull, IsProbabilityMeasure.measure_univ]
    · intro ω hω
      by_contra hnot
      exact hω (hsub hnot)

/-- In-probability vector convergence iff coordinatewise convergence. -/
theorem vectorConvergesInProbability_iff_coordinatewise
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    {d : ℕ} (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (hVn : ∀ n, Measurable (Vn n)) (hV : Measurable V) :
    VectorConvergesInProbability μ Vn V ↔
      ∀ i : Fin d, ConvergesInProbability μ
        (fun n ω ↦ Vn n ω i) (fun ω ↦ V ω i) := by
  constructor
  · intro hvec i
    refine ⟨fun n ↦ (measurable_pi_iff.mp (hVn n)) i, (measurable_pi_iff.mp hV) i, ?_⟩
    intro ε hε
    have hsub : ∀ n,
        deviationEvent (fun n ω ↦ Vn n ω i) (fun ω ↦ V ω i) n ε ⊆
          vectorDeviationEvent Vn V n ε := by
      intro n ω hω
      exact lt_of_lt_of_le hω (abs_coordinate_le_vectorEuclideanNorm (Vn n ω - V ω) i)
    exact tendsto_of_tendsto_of_tendsto_of_le_of_le tendsto_const_nhds (hvec ε hε)
      (fun _ ↦ bot_le) (fun n ↦ measure_mono (hsub n))
  · intro hcoord ε hε
    by_cases hd : d = 0
    · subst d
      have hempty : ∀ n, vectorDeviationEvent Vn V n ε = ∅ := by
        intro n
        ext ω
        simp [vectorDeviationEvent, vectorEuclideanNorm, not_lt_of_ge hε.le]
      simp_rw [hempty, measure_empty]
      exact tendsto_const_nhds
    · have hdpos_nat : 0 < d := Nat.pos_of_ne_zero hd
      have hdpos : (0 : ℝ) < d := by exact_mod_cast hdpos_nat
      let δ : ℝ := ε / Real.sqrt d
      have hδ : 0 < δ := div_pos hε (Real.sqrt_pos.2 hdpos)
      have hsub : ∀ n, vectorDeviationEvent Vn V n ε ⊆
          ⋃ i : Fin d, deviationEvent
            (fun n ω ↦ Vn n ω i) (fun ω ↦ V ω i) n δ := by
        intro n ω hω
        simp only [Set.mem_iUnion, deviationEvent, Set.mem_setOf_eq]
        by_contra hall
        push Not at hall
        have hle : ∀ i : Fin d, |(Vn n ω - V ω) i| ≤ δ := by
          intro i
          simpa using hall i
        exact (not_le_of_gt hω) (vectorEuclideanNorm_le_of_forall_abs_le
          (Vn n ω - V ω) hε.le hle)
      have hsum_tendsto : Tendsto
          (fun n ↦ ∑ i : Fin d,
            μ (deviationEvent (fun n ω ↦ Vn n ω i) (fun ω ↦ V ω i) n δ))
          atTop (nhds 0) := by
        simpa using tendsto_finsetSum Finset.univ fun i _ ↦ (hcoord i).2.2 δ hδ
      refine tendsto_of_tendsto_of_tendsto_of_le_of_le tendsto_const_nhds hsum_tendsto
        (fun _ ↦ bot_le) ?_
      intro n
      exact (measure_mono (hsub n)).trans (measure_iUnion_fintype_le μ _)

/-- Textbook Theorem 10.10, exposing both equivalences. -/
theorem thm_10_10
    {Ω : Type*} [MeasurableSpace Ω] (μ : Measure Ω) [IsProbabilityMeasure μ]
    {d : ℕ} (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (hVn : ∀ n, Measurable (Vn n)) (hV : Measurable V) :
    (VectorConvergesAlmostSurely μ Vn V ↔
      ∀ i : Fin d, ConvergesAlmostSurely μ
        (fun n ω ↦ Vn n ω i) (fun ω ↦ V ω i)) ∧
    (VectorConvergesInProbability μ Vn V ↔
      ∀ i : Fin d, ConvergesInProbability μ
        (fun n ω ↦ Vn n ω i) (fun ω ↦ V ω i)) :=
  ⟨vectorConvergesAlmostSurely_iff_coordinatewise μ Vn V hVn hV,
    vectorConvergesInProbability_iff_coordinatewise μ Vn V hVn hV⟩
