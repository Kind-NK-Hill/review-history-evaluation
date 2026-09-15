import Mathlib
import ProbabilityTheory.chapter_10.def_10_1
import ProbabilityTheory.chapter_10.def_10_2
import ProbabilityTheory.chapter_10.def_10_6

open Filter MeasureTheory
open scoped BigOperators

lemma coordinate_abs_le_vectorEuclideanNorm {d : ℕ} (x : Fin d → ℝ) (i : Fin d) :
    |x i| ≤ vectorEuclideanNorm x := by
  rw [vectorEuclideanNorm, Real.le_sqrt (abs_nonneg _) (Finset.sum_nonneg fun _ _ => sq_nonneg _)]
  rw [sq_abs]
  exact Finset.single_le_sum (fun j _ => sq_nonneg (x j)) (Finset.mem_univ i)

/-- Almost-sure convergence of finite-dimensional random vectors is equivalent
coordinatewise.  Measurability is stated explicitly because the vector
convergence definition only records its full-probability convergence event. -/
theorem vectorConvergesAlmostSurely_iff_coordinatewise
    {Ω : Type*} [MeasurableSpace Ω] {d : ℕ} (μ : Measure Ω) [IsProbabilityMeasure μ]
    (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (hVn : ∀ n, Measurable (Vn n)) (hV : Measurable V) :
    VectorConvergesAlmostSurely μ Vn V ↔
      ∀ i : Fin d,
        ConvergesAlmostSurely μ (fun n ω => Vn n ω i) (fun ω => V ω i) := by
  constructor
  · rintro ⟨E, hEmeas, hEone, hconv⟩ i
    refine ⟨fun n => ((measurable_pi_iff.1 (hVn n)) i).aestronglyMeasurable,
      ((measurable_pi_iff.1 hV) i).aestronglyMeasurable, ?_⟩
    have hEc : μ Eᶜ = 0 := by
      rw [measure_compl hEmeas (measure_ne_top μ E)]
      simp [hEone, IsProbabilityMeasure.measure_univ]
    have haeE : ∀ᵐ ω ∂μ, ω ∈ E := by
      apply ae_iff.2
      change μ Eᶜ = 0
      exact hEc
    filter_upwards [haeE] with ω hω
    exact (tendsto_pi_nhds.1 (hconv ω hω)) i
  · intro hcoord
    have hforall : ∀ᵐ ω ∂μ, ∀ i : Fin d,
        Tendsto (fun n => Vn n ω i) atTop (nhds (V ω i)) :=
      ae_all_iff.2 (fun i => (hcoord i).2.2)
    have hae : ∀ᵐ ω ∂μ, Tendsto (fun n => Vn n ω) atTop (nhds (V ω)) :=
      hforall.mono fun ω hω => tendsto_pi_nhds.2 (hω)
    have hbad : μ {ω : Ω | ¬ Tendsto (fun n => Vn n ω) atTop (nhds (V ω))} = 0 :=
      ae_iff.1 hae
    obtain ⟨N, hsub, hNmeas, hNnull⟩ := exists_measurable_superset_of_null hbad
    refine ⟨Nᶜ, hNmeas.compl, ?_, ?_⟩
    · rw [measure_compl hNmeas (measure_ne_top μ N)]
      simp [hNnull, IsProbabilityMeasure.measure_univ]
    · intro ω hω
      by_contra hnot
      exact hω (hsub hnot)

/-- Convergence in probability of finite-dimensional random vectors (for the
explicit Euclidean norm of Definition 10.6) is equivalent coordinatewise. -/
theorem vectorConvergesInProbability_iff_coordinatewise
    {Ω : Type*} [MeasurableSpace Ω] {d : ℕ} (μ : Measure Ω) [IsProbabilityMeasure μ]
    (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (hVn : ∀ n, Measurable (Vn n)) (hV : Measurable V) :
    VectorConvergesInProbability μ Vn V ↔
      ∀ i : Fin d,
        ConvergesInProbability μ (fun n ω => Vn n ω i) (fun ω => V ω i) := by
  constructor
  · intro hvec i
    refine ⟨fun n => (measurable_pi_iff.1 (hVn n)) i, (measurable_pi_iff.1 hV) i, ?_⟩
    intro ε hε
    apply tendsto_of_tendsto_of_tendsto_of_le_of_le' tendsto_const_nhds (hvec ε hε)
    · exact Filter.Eventually.of_forall fun n => bot_le
    · exact Filter.Eventually.of_forall fun n => measure_mono (by
        intro ω hω
        exact lt_of_lt_of_le hω (coordinate_abs_le_vectorEuclideanNorm (Vn n ω - V ω) i))
  · intro hcoord ε hε
    by_cases hd0 : d = 0
    · subst d
      simp [vectorDeviationEvent, vectorEuclideanNorm, not_lt_of_ge hε.le]
    have hd : 0 < d := Nat.pos_of_ne_zero hd0
    have hdR : 0 < (d : ℝ) := by exact_mod_cast hd
    have hsqrt : 0 < Real.sqrt (d : ℝ) := Real.sqrt_pos.2 hdR
    let δ : ℝ := ε / Real.sqrt (d : ℝ)
    have hδ : 0 < δ := div_pos hε hsqrt
    let A : ℕ → Fin d → Set Ω := fun n i =>
      deviationEvent (fun n ω => Vn n ω i) (fun ω => V ω i) n δ
    have hsub : ∀ n, vectorDeviationEvent Vn V n ε ⊆ ⋃ i ∈ Finset.univ, A n i := by
      intro n ω hω
      by_contra hnot
      have hle : ∀ i : Fin d, |Vn n ω i - V ω i| ≤ δ := by
        intro i
        have hi : ω ∉ A n i := by
          intro hi
          apply hnot
          simp only [Set.mem_iUnion, Finset.mem_univ, exists_const]
          exact ⟨i, hi⟩
        exact le_of_not_gt hi
      have hsum : ∑ i : Fin d, (Vn n ω i - V ω i) ^ 2 ≤ ε ^ 2 := by
        calc
          ∑ i : Fin d, (Vn n ω i - V ω i) ^ 2
              ≤ ∑ _i : Fin d, δ ^ 2 := by
                apply Finset.sum_le_sum
                intro i hi
                rw [← sq_abs]
                exact (sq_le_sq₀ (abs_nonneg _) hδ.le).2 (hle i)
          _ = (d : ℝ) * δ ^ 2 := by simp
          _ = ε ^ 2 := by
            dsimp [δ]
            field_simp [ne_of_gt hsqrt]
            rw [Real.sq_sqrt hdR.le]
      have hnorm : vectorEuclideanNorm (Vn n ω - V ω) ≤ ε := by
        rw [vectorEuclideanNorm, Real.sqrt_le_iff]
        refine ⟨hε.le, ?_⟩
        simpa only [Pi.sub_apply] using hsum
      exact (not_le_of_gt hω) hnorm
    have hsum_tendsto :
        Tendsto (fun n => ∑ i : Fin d, μ (A n i)) atTop (nhds 0) := by
      simpa only [Finset.sum_const_zero] using
        (tendsto_finsetSum Finset.univ (fun i _ => (hcoord i).2.2 δ hδ))
    apply tendsto_of_tendsto_of_tendsto_of_le_of_le' tendsto_const_nhds hsum_tendsto
    · exact Filter.Eventually.of_forall fun n => bot_le
    · exact Filter.Eventually.of_forall fun n =>
        (measure_mono (hsub n)).trans (measure_biUnion_finset_le Finset.univ (A n))

/-- Textbook Theorem 10.10: both almost-sure convergence and convergence in
probability of finite-dimensional random vectors are coordinatewise. -/
theorem thm_10_10
    {Ω : Type*} [MeasurableSpace Ω] {d : ℕ} (μ : Measure Ω) [IsProbabilityMeasure μ]
    (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (hVn : ∀ n, Measurable (Vn n)) (hV : Measurable V) :
    (VectorConvergesAlmostSurely μ Vn V ↔
      ∀ i : Fin d,
        ConvergesAlmostSurely μ (fun n ω => Vn n ω i) (fun ω => V ω i)) ∧
    (VectorConvergesInProbability μ Vn V ↔
      ∀ i : Fin d,
        ConvergesInProbability μ (fun n ω => Vn n ω i) (fun ω => V ω i)) := by
  exact ⟨vectorConvergesAlmostSurely_iff_coordinatewise μ Vn V hVn hV,
    vectorConvergesInProbability_iff_coordinatewise μ Vn V hVn hV⟩
