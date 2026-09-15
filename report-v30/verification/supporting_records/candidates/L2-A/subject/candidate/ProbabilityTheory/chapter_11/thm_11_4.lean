import Mathlib
import ProbabilityTheory.chapter_07.def_7_3
import ProbabilityTheory.chapter_09.def_9_1

/-
TASK ID: thm_11_4
TYPE: Theorem_with_Proof
SOURCE PLAN: experiment_targets
TASK CONTENT:
\begin{thmbox}{11.4}
\end{thmbox}

IfX1,X 2,...,X n are pairwise uncorrelated, then

Va r(X1 + X2 +\cdot\cdot\cdot+ Xn) =

n\sum

i=1

Va r(Xi).

\textit{Proof} Without loss of generality, suppose the random variables X1,...,X n have

zero mean. (We can consider the centered random variable Yn = Xn - E[Xn]

otherwise.)

Using the definition of variance and the linearity of expectation, we have

Va r(X1 + X2 +\cdot\cdot\cdot+ Xn) = E

[

X2

1 + X2

2 +\cdot\cdot\cdot+ X2

n + 2

\sum

i<j

XiXj

]

=

n\sum

i=1

E[X2

i ].

The assumption of pairwise uncorrelatedness guarantees that the cross-terms

E[XiXj ] are zero for i /=j Therefore, we have

Va r(X1 + X2 +\cdot\cdot\cdot+ Xn) =

n\sum

i=1

E[X2

i ]=

n\sum

i=1

Va r(Xi).

\hfill $\square$

We will present two versions of weak law of large numbers. The first one

assumes that the random variables are pairwise uncorrelated with the same mean

and variance. Note that the random variables need not be identically distributed, and

they need not be independent.
-/

-- WRITE FINAL LEAN CODE BELOW

open MeasureTheory ProbabilityTheory

/-- For a finite pairwise-uncorrelated family with finite second moments, the
variance of the sum is the sum of the variances. -/
theorem thm_11_4 {Ω ι : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] (s : Finset ι) (X : ι → Ω → ℝ)
    (hX : ∀ i ∈ s, FiniteAbsMoment μ (X i) 2)
    (huncorrelated : ∀ i ∈ s, ∀ j ∈ s, i ≠ j → Uncorrelated μ (X i) (X j)) :
    ProbabilityTheory.variance (∑ i ∈ s, X i) μ =
      ∑ i ∈ s, ProbabilityTheory.variance (X i) μ := by
  classical
  have hmem : ∀ i ∈ s, MemLp (X i) 2 μ := fun i hi =>
    (hX i hi).memLp (by norm_num)
  rw [ProbabilityTheory.variance_sum' hmem]
  refine Finset.sum_congr rfl fun i hi => ?_
  rw [Finset.sum_eq_single i]
  · exact ProbabilityTheory.covariance_self (hmem i hi).aemeasurable
  · intro j hj hji
    have hij : i ≠ j := Ne.symm hji
    exact (covariance_zero_iff_uncorrelated (hmem i hi) (hmem j hj)).2
      (huncorrelated i hi j hj hij)
  · exact fun hnot => (hnot hi).elim
