import Mathlib
import ProbabilityTheory.chapter_10.def_10_4
import ProbabilityTheory.chapter_10.def_10_5
import ProbabilityTheory.chapter_14.thm_14_4

/-
TASK ID: thm_10_6
TYPE: Theorem_Statement
SOURCE PLAN: chapter10-distribution-total-variation
TASK CONTENT:
\begin{thmbox}{10.6}
If a sequence of probability distributions converges in total variation, then it converges in distribution.
\end{thmbox}

We defer the proof to Chap. 14 after the introduction to weak convergence (see Theorem 14.4).
-/

-- WRITE FINAL LEAN CODE BELOW

open Filter MeasureTheory ProbabilityTheory Set
open scoped Topology

noncomputable section

/-- At a continuity point of a real cdf, the corresponding law has no atom.
This is the cdf-side form of the source phrase `P({a}) = 0`, restated here
because this pack's declared Chapter 14 dependency is Theorem 14.4. -/
theorem thm_10_6_atom_zero_of_cdf_continuous
    (μ : ProbabilityMeasure ℝ) {x : ℝ}
    (hcont : ContinuousAt (fun y : ℝ => measureCdf μ y) x) :
    (μ : Measure ℝ) {x} = 0 :=
  measure_singleton_eq_zero_of_measureCdf_continuousAt μ hcont

/-- The Chapter 14 weak-convergence-to-cdf bridge, specialized to probability
measures on `ℝ`. -/
theorem thm_10_6_weak_to_distribution_bridge
    (Pseq : ℕ → ProbabilityMeasure ℝ) (P : ProbabilityMeasure ℝ)
    (hWeak : def_14_1 Pseq P) :
    MeasuresConvergeInDistribution Pseq P := by
  exact (def_14_1_iff_tendsto).1 hWeak

/-- The deferred Theorem 14.4 step: total variation convergence of probability
measures implies weak convergence. -/
theorem thm_10_6_weakConvergence
    (Pseq : ℕ → ProbabilityMeasure ℝ) (P : ProbabilityMeasure ℝ)
    (hTV :
      MeasuresConvergeInTotalVariation
        (fun n : ℕ => (Pseq n : Measure ℝ)) (P : Measure ℝ)) :
    def_14_1 Pseq P := by
  rw [MeasuresConvergeInTotalVariation] at hTV
  rcases hTV with ⟨hPn, hP, hlim⟩
  letI (n : ℕ) : IsProbabilityMeasure (Pseq n : Measure ℝ) := hPn n
  letI : IsProbabilityMeasure (P : Measure ℝ) := hP
  have hTV14 : thm_14_4_totalVariationConvergence Pseq P := by
    simpa [thm_14_4_totalVariationConvergence] using hlim
  exact thm_14_4 Pseq P hTV14

/-- Theorem 10.6: if a sequence of probability distributions converges in
total variation, then it converges in distribution.  The proof is the exact
deferred route named in the textbook: Theorem 14.4 gives weak convergence, and
the Chapter 14 weak/distribution bridge translates that conclusion back to the
Chapter 10 cdf definition. -/
theorem thm_10_6
    (Pseq : ℕ → ProbabilityMeasure ℝ) (P : ProbabilityMeasure ℝ)
    (hTV :
      MeasuresConvergeInTotalVariation
        (fun n : ℕ => (Pseq n : Measure ℝ)) (P : Measure ℝ)) :
    MeasuresConvergeInDistribution Pseq P :=
  thm_10_6_weak_to_distribution_bridge Pseq P
    (thm_10_6_weakConvergence Pseq P hTV)
