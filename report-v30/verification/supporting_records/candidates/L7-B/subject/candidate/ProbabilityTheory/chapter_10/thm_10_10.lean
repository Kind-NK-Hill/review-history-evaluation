import Mathlib
import ProbabilityTheory.chapter_02.prob_2_4
import ProbabilityTheory.chapter_10.def_10_6

open Filter MeasureTheory
open scoped BigOperators ENNReal

private lemma euclideanNorm_le_sum_abs {d : ℕ} (x : Fin d → ℝ) :
    vectorEuclideanNorm x ≤ ∑ i, |x i| := by
  rw [vectorEuclideanNorm]
  refine (abs_le_of_sq_le_sq' ?_ (by positivity)).2
  rw [Real.sq_sqrt (Finset.sum_nonneg fun i _ => sq_nonneg (x i))]
  simpa only [sq_abs] using
    (Finset.sum_sq_le_sq_sum_of_nonneg (fun i _ => abs_nonneg (x i)))

private lemma measure_eq_one_of_compl_eq_zero {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] {E : Set Ω}
    (hE : MeasurableSet E) (hEc : μ Eᶜ = 0) : μ E = 1 := by
  have hfin : μ Eᶜ ≠ ⊤ := by simp [hEc]
  simpa [hEc, MeasureTheory.IsProbabilityMeasure.measure_univ] using
    (MeasureTheory.measure_compl hE.compl hfin)

theorem vectorConvergesAlmostSurely_iff_coordinatewise
    {Ω : Type*} [MeasurableSpace Ω] {d : ℕ} (μ : Measure Ω)
    [IsProbabilityMeasure μ] (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (hVn : ∀ n, Measurable (Vn n)) (hV : Measurable V) :
    VectorConvergesAlmostSurely μ Vn V ↔
      ∀ i : Fin d, ConvergesAlmostSurely μ
        (fun n ω => Vn n ω i) (fun ω => V ω i) := by
  constructor
  · rintro ⟨E, hE, hEone, hconv⟩ i
    refine ⟨fun n => ((measurable_pi_iff.mp (hVn n)) i).aestronglyMeasurable,
      ((measurable_pi_iff.mp hV) i).aestronglyMeasurable, ?_⟩
    have hEc : μ Eᶜ = 0 := by
      have hfin : μ E ≠ ⊤ := by rw [hEone]; simp
      rw [MeasureTheory.measure_compl hE hfin]
      simp [hEone, MeasureTheory.IsProbabilityMeasure.measure_univ]
    refine ae_iff.2 (measure_mono_null ?_ hEc)
    intro ω hω
    change ω ∉ E
    intro hωE
    exact hω ((tendsto_pi_nhds.mp (hconv ω hωE)) i)
  · intro hcoord
    have hae : ∀ᵐ ω ∂μ, Tendsto (fun n => Vn n ω) atTop (nhds (V ω)) := by
      have hall : ∀ᵐ ω ∂μ, ∀ i : Fin d,
          Tendsto (fun n => Vn n ω i) atTop (nhds (V ω i)) :=
        ae_all_iff.mpr fun i => (hcoord i).2.2
      filter_upwards [hall] with ω hω
      exact tendsto_pi_nhds.mpr hω
    have hbad : μ {ω : Ω | ¬ Tendsto (fun n => Vn n ω) atTop (nhds (V ω))} = 0 :=
      ae_iff.1 hae
    obtain ⟨N, hsub, hNmeas, hNzero⟩ := exists_measurable_superset_of_null hbad
    refine ⟨Nᶜ, hNmeas.compl, measure_eq_one_of_compl_eq_zero μ hNmeas.compl ?_, ?_⟩
    · simpa using hNzero
    · intro ω hω
      by_contra hn
      exact hω (hsub hn)

theorem vectorConvergesInProbability_iff_coordinatewise
    {Ω : Type*} [MeasurableSpace Ω] {d : ℕ} (μ : Measure Ω)
    [IsProbabilityMeasure μ] (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (hVn : ∀ n, Measurable (Vn n)) (hV : Measurable V) :
    VectorConvergesInProbability μ Vn V ↔
      ∀ i : Fin d, ConvergesInProbability μ
        (fun n ω => Vn n ω i) (fun ω => V ω i) := by
  constructor
  · intro hv i
    refine ⟨fun n => (measurable_pi_iff.mp (hVn n)) i,
      (measurable_pi_iff.mp hV) i, ?_⟩
    intro ε hε
    refine tendsto_of_tendsto_of_tendsto_of_le_of_le tendsto_const_nhds
      (hv ε hε) (fun _ => bot_le) ?_
    intro n
    apply measure_mono
    intro ω hω
    change vectorEuclideanNorm (Vn n ω - V ω) > ε
    have hle : |Vn n ω i - V ω i| ≤ vectorEuclideanNorm (Vn n ω - V ω) := by
      rw [vectorEuclideanNorm]
      refine (Real.le_sqrt (abs_nonneg _)
        (Finset.sum_nonneg fun j _ => sq_nonneg _)).2 ?_
      simpa using Finset.single_le_sum
        (fun j _ => sq_nonneg ((Vn n ω - V ω) j)) (Finset.mem_univ i)
    exact lt_of_lt_of_le hω hle
  · intro hc ε hε
    by_cases hd : d = 0
    · subst d
      simpa [vectorDeviationEvent, vectorEuclideanNorm, not_lt_of_ge hε.le]
    · have hdpos : (0 : ℝ) < d := by exact_mod_cast Nat.pos_of_ne_zero hd
      have hdreal : (d : ℝ) ≠ 0 := ne_of_gt hdpos
      let δ : ℝ := ε / d
      have hδ : 0 < δ := div_pos hε hdpos
      have hsum : Tendsto
          (fun n => ∑ i : Fin d,
            μ (deviationEvent (fun n ω => Vn n ω i) (fun ω => V ω i) n δ))
          atTop (nhds 0) := by
        simpa using tendsto_finset_sum Finset.univ
          (fun i _ => (hc i).2.2 δ hδ)
      refine tendsto_of_tendsto_of_tendsto_of_le_of_le tendsto_const_nhds hsum
        (fun _ => bot_le) ?_
      intro n
      calc
        μ (vectorDeviationEvent Vn V n ε) ≤
            μ (⋃ i : Fin d,
              deviationEvent (fun n ω => Vn n ω i) (fun ω => V ω i) n δ) := by
          apply measure_mono
          intro ω hω
          simp only [Set.mem_iUnion, deviationEvent, Set.mem_setOf_eq]
          by_contra hall
          push_neg at hall
          have hsumle : (∑ i : Fin d, |Vn n ω i - V ω i|) ≤ ε := by
            calc
              (∑ i : Fin d, |Vn n ω i - V ω i|) ≤ ∑ _i : Fin d, δ :=
                Finset.sum_le_sum fun i _ => hall i
              _ = d * δ := by simp
              _ = ε := by dsimp [δ]; field_simp
          have hnorm := euclideanNorm_le_sum_abs
            (fun i => Vn n ω i - V ω i)
          exact (not_lt_of_ge (hnorm.trans hsumle)) hω
        _ ≤ ∑ i : Fin d,
              μ (deviationEvent (fun n ω => Vn n ω i) (fun ω => V ω i) n δ) :=
          measure_iUnion_fintype_le μ
            (fun i => deviationEvent (fun n ω => Vn n ω i) (fun ω => V ω i) n δ)

theorem thm_10_10
    {Ω : Type*} [MeasurableSpace Ω] {d : ℕ} (μ : Measure Ω)
    [IsProbabilityMeasure μ] (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (hVn : ∀ n, Measurable (Vn n)) (hV : Measurable V) :
    (VectorConvergesAlmostSurely μ Vn V ↔
      ∀ i : Fin d, ConvergesAlmostSurely μ
        (fun n ω => Vn n ω i) (fun ω => V ω i)) ∧
    (VectorConvergesInProbability μ Vn V ↔
      ∀ i : Fin d, ConvergesInProbability μ
        (fun n ω => Vn n ω i) (fun ω => V ω i)) := by
  exact ⟨vectorConvergesAlmostSurely_iff_coordinatewise μ Vn V hVn hV,
    vectorConvergesInProbability_iff_coordinatewise μ Vn V hVn hV⟩
