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

/-- Theorem 11.4: the variance of a finite sum of pairwise uncorrelated
real-valued random variables is the sum of their variances. -/
theorem thm_11_4 {Ω ι : Type*} [MeasurableSpace Ω] [Fintype ι]
    (P : Measure Ω) [IsProbabilityMeasure P] (X : ι → Ω → ℝ)
    (hX : ∀ i, MemLp (X i) 2 P)
    (huncorr : ∀ i j, i ≠ j → Uncorrelated P (X i) (X j)) :
    ProbabilityTheory.variance (fun ω => ∑ i, X i ω) P =
      ∑ i, ProbabilityTheory.variance (X i) P := by
  classical
  have hcov_zero : ∀ i j, i ≠ j → covariance (X i) (X j) P = 0 := by
    intro i j hij
    rw [covariance_eq_sub (hX i) (hX j), sub_eq_zero]
    simpa [Uncorrelated, Pi.mul_apply] using huncorr i j hij
  rw [variance_fun_sum hX]
  apply Finset.sum_congr rfl
  intro i _
  rw [Fintype.sum_eq_single i]
  · exact covariance_self (hX i).aemeasurable
  · intro j hji
    exact hcov_zero i j (Ne.symm hji)
