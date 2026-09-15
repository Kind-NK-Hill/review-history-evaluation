import Mathlib
import ProbabilityTheory.chapter_02.prob_2_4
import ProbabilityTheory.chapter_10.def_10_6
import ProbabilityTheory.chapter_10.thm_10_9

/-!
# Theorem 10.10

For finite-dimensional real random vectors, almost-sure convergence and
convergence in probability are equivalent to their coordinatewise versions.
The proof records both Euclidean-coordinate estimates explicitly.
-/

open Filter MeasureTheory Set Finset

/-- Every coordinate is bounded by the Euclidean norm. -/
theorem abs_coordinate_le_vectorEuclideanNorm {d : ℕ} (v : Fin d → ℝ) (i : Fin d) :
    |v i| ≤ vectorEuclideanNorm v := by
  unfold vectorEuclideanNorm
  apply Real.le_sqrt_of_sq_le
  rw [sq_abs]
  exact single_le_sum (fun j _ => sq_nonneg (v j)) (mem_univ i)

/-- The Euclidean norm is bounded by the sum of the coordinate absolute values. -/
theorem vectorEuclideanNorm_le_sum_abs {d : ℕ} (v : Fin d → ℝ) :
    vectorEuclideanNorm v ≤ ∑ i : Fin d, |v i| := by
  unfold vectorEuclideanNorm
  calc
    Real.sqrt (∑ i : Fin d, (v i) ^ 2) ≤ Real.sqrt ((∑ i : Fin d, |v i|) ^ 2) := by
      apply Real.sqrt_le_sqrt
      simpa only [sq_abs] using
        (sum_sq_le_sq_sum_of_nonneg (s := (univ : Finset (Fin d)))
          (f := fun i : Fin d => |v i|) (fun _ _ => abs_nonneg _))
    _ = ∑ i : Fin d, |v i| := Real.sqrt_sq (sum_nonneg fun _ _ => abs_nonneg _)

/-- Almost-sure vector convergence is equivalent to coordinatewise convergence. -/
theorem vectorConvergesAlmostSurely_iff_coordinatewise
    {Ω : Type*} [MeasurableSpace Ω] {d : ℕ} (μ : Measure Ω)
    [IsProbabilityMeasure μ] (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (hVn : ∀ n : ℕ, Measurable (Vn n)) (hV : Measurable V) :
    VectorConvergesAlmostSurely μ Vn V ↔
      ∀ i : Fin d, ConvergesAlmostSurely μ (fun n ω => Vn n ω i) (fun ω => V ω i) := by
  constructor
  · rintro ⟨E, hEmeas, hEone, hEconv⟩ i
    apply (convergesAlmostSurely_iff_exists_measure_one_event μ
      (fun n ω => Vn n ω i) (fun ω => V ω i)).2
    refine ⟨fun n => ((coordinatewiseMeasurable_iff_vectorMeasurable (Vn n)).1
      (hVn n) i).aestronglyMeasurable,
      ((coordinatewiseMeasurable_iff_vectorMeasurable V).1 hV i).aestronglyMeasurable,
      E, hEmeas, hEone, ?_⟩
    intro ω hω
    exact (continuous_apply i).continuousAt.tendsto.comp (hEconv ω hω)
  · intro hcoord
    have hcoordEvent : ∀ i : Fin d, ∃ E : Set Ω, MeasurableSet E ∧ μ E = 1 ∧
        ∀ ω ∈ E, Tendsto (fun n : ℕ => Vn n ω i) atTop (nhds (V ω i)) := by
      intro i
      exact (convergesAlmostSurely_iff_exists_measure_one_event μ
        (fun n ω => Vn n ω i) (fun ω => V ω i)).1 (hcoord i) |>.2.2
    classical
    let E : Fin d → Set Ω := fun i => Classical.choose (hcoordEvent i)
    have hEmeas : ∀ i, MeasurableSet (E i) := fun i =>
      (Classical.choose_spec (hcoordEvent i)).1
    have hEone : ∀ i, μ (E i) = 1 := fun i =>
      (Classical.choose_spec (hcoordEvent i)).2.1
    have hEcompl : ∀ i, μ (E i)ᶜ = 0 := by
      intro i
      rw [measure_compl (hEmeas i)]
      · simp [hEone i, IsProbabilityMeasure.measure_univ]
      · simp [hEone i]
    refine ⟨⋂ i, E i, MeasurableSet.iInter hEmeas, ?_, ?_⟩
    · have hnull : μ (⋃ i, (E i)ᶜ) = 0 := measure_iUnion_null hEcompl
      have hinterCompl : (⋂ i, E i)ᶜ = ⋃ i, (E i)ᶜ := by
        ext
        simp
      have hcompl : μ (⋂ i, E i)ᶜ = 0 := by rw [hinterCompl]; exact hnull
      calc
        μ (⋂ i, E i) = μ (⋂ i, E i)ᶜᶜ := by rw [compl_compl]
        _ = μ univ - μ (⋂ i, E i)ᶜ :=
          measure_compl (MeasurableSet.iInter hEmeas).compl (by simp)
        _ = 1 := by rw [hinterCompl, hnull]; simp [IsProbabilityMeasure.measure_univ]
    · intro ω hω
      apply tendsto_pi_nhds.2
      intro i
      exact (Classical.choose_spec (hcoordEvent i)).2.2 ω (mem_iInter.1 hω i)

/-- Vector convergence in probability is equivalent to coordinatewise convergence. -/
theorem vectorConvergesInProbability_iff_coordinatewise
    {Ω : Type*} [MeasurableSpace Ω] {d : ℕ} (μ : Measure Ω)
    [IsProbabilityMeasure μ] (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (hVn : ∀ n : ℕ, Measurable (Vn n)) (hV : Measurable V) :
    VectorConvergesInProbability μ Vn V ↔
      ∀ i : Fin d, ConvergesInProbability μ (fun n ω => Vn n ω i) (fun ω => V ω i) := by
  constructor
  · intro hvec i
    refine ⟨fun n => (coordinatewiseMeasurable_iff_vectorMeasurable (Vn n)).1
      (hVn n) i, (coordinatewiseMeasurable_iff_vectorMeasurable V).1 hV i, ?_⟩
    intro ε hε
    have hsub : ∀ n, deviationEvent (fun n ω => Vn n ω i) (fun ω => V ω i) n ε ⊆
          vectorDeviationEvent Vn V n ε := by
      intro n ω hω
      exact lt_of_lt_of_le hω
        (by simpa using abs_coordinate_le_vectorEuclideanNorm (Vn n ω - V ω) i)
    exact tendsto_of_tendsto_of_tendsto_of_le_of_le tendsto_const_nhds
      (hvec ε hε) (fun _ => bot_le) (fun n => measure_mono (hsub n))
  · intro hcoord
    by_cases hd : d = 0
    · subst d
      intro ε hε
      simp [vectorDeviationEvent, vectorEuclideanNorm, not_lt_of_ge hε.le]
    · have hdpos : 0 < (d : ℝ) := by exact_mod_cast Nat.pos_of_ne_zero hd
      intro ε hε
      let δ : ℝ := ε / d
      have hδ : 0 < δ := div_pos hε hdpos
      let A : Fin d → ℕ → Set Ω := fun i n =>
        deviationEvent (fun n ω => Vn n ω i) (fun ω => V ω i) n δ
      have hAmeas : ∀ i n, MeasurableSet (A i n) := by
        intro i n
        exact (((coordinatewiseMeasurable_iff_vectorMeasurable (Vn n)).1 (hVn n) i).sub
          ((coordinatewiseMeasurable_iff_vectorMeasurable V).1 hV i)).abs measurableSet_Ioi
      have hsubset : ∀ n, vectorDeviationEvent Vn V n ε ⊆ ⋃ i, A i n := by
        intro n ω hω
        by_contra hnot
        have hall : ∀ i : Fin d, |Vn n ω i - V ω i| ≤ δ := by
          intro i
          have hi : ω ∉ A i n := by
            intro hi
            exact hnot (mem_iUnion.2 ⟨i, hi⟩)
          exact le_of_not_gt hi
        have hsum : ∑ i : Fin d, |Vn n ω i - V ω i| ≤ ε := by
          calc
            ∑ i : Fin d, |Vn n ω i - V ω i| ≤ ∑ _i : Fin d, δ :=
              sum_le_sum fun i _ => hall i
            _ = d * δ := by simp
            _ = ε := by
              dsimp [δ]
              exact mul_div_cancel₀ ε (by exact_mod_cast hd)
        have hnorm : vectorEuclideanNorm (Vn n ω - V ω) ≤ ε :=
          (vectorEuclideanNorm_le_sum_abs (Vn n ω - V ω)).trans (by simpa using hsum)
        exact (not_le_of_gt hω) hnorm
      have hbound : ∀ n,
          μ (vectorDeviationEvent Vn V n ε) ≤ ∑ i : Fin d, μ (A i n) := by
        intro n
        refine (measure_mono (hsubset n)).trans ?_
        simpa using
          (prob_2_4_finset_union_bound μ (univ : Finset (Fin d))
            (fun i => A i n) (fun i => hAmeas i n))
      have hsumlim : Tendsto (fun n => ∑ i : Fin d, μ (A i n)) atTop (nhds 0) := by
        simpa only [Finset.sum_const_zero] using
          (tendsto_finsetSum (univ : Finset (Fin d)) fun i _ => (hcoord i).2.2 δ hδ)
      exact tendsto_of_tendsto_of_tendsto_of_le_of_le tendsto_const_nhds hsumlim
        (fun _ => bot_le) hbound

/-- The two equivalences comprising textbook Theorem 10.10. -/
theorem thm_10_10
    {Ω : Type*} [MeasurableSpace Ω] {d : ℕ} (μ : Measure Ω)
    [IsProbabilityMeasure μ] (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (hVn : ∀ n : ℕ, Measurable (Vn n)) (hV : Measurable V) :
    (VectorConvergesAlmostSurely μ Vn V ↔
      ∀ i : Fin d, ConvergesAlmostSurely μ (fun n ω => Vn n ω i) (fun ω => V ω i)) ∧
    (VectorConvergesInProbability μ Vn V ↔
      ∀ i : Fin d, ConvergesInProbability μ (fun n ω => Vn n ω i) (fun ω => V ω i)) := by
  exact ⟨vectorConvergesAlmostSurely_iff_coordinatewise μ Vn V hVn hV,
    vectorConvergesInProbability_iff_coordinatewise μ Vn V hVn hV⟩
