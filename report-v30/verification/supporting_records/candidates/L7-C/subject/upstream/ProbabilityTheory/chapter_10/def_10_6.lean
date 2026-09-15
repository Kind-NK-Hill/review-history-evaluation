import Mathlib
import ProbabilityTheory.chapter_10.def_10_1
import ProbabilityTheory.chapter_10.def_10_2
import ProbabilityTheory.chapter_10.thm_10_9

/-
TASK ID: def_10_6
TYPE: Definition
SOURCE PLAN: chapter10-random-vectors
TASK CONTENT:
\begin{defbox}{10.6}
Let $(\Omega,\mathcal{F},P)$ denote a probability space, and let $V_n(\omega)$ be a sequence of $d$-dimensional random vectors defined on $\Omega$. The sequence of random vectors $V_n(\omega)$ is said to converge almost surely to $V(\omega)$ if there is an event $E$ with $P(E)=1$ such that
\[
\lim_{n\to\infty}V_n(\omega)=V(\omega)
\]
for all $\omega\in E$.

We say that $V_n(\omega)$ converges in probability to $V(\omega)$ if for all $\epsilon>0$, the probability
\[
P(\{\omega:\lVert V_n(\omega)-V(\omega)\rVert>\epsilon\})
\]
approaches zero as $n\to\infty$.
\end{defbox}
-/

-- WRITE FINAL LEAN CODE BELOW

open Filter MeasureTheory

/-- Almost sure convergence of random vectors, in the textbook event-of-probability
one form. -/
def VectorConvergesAlmostSurely {Ω : Type*} [MeasurableSpace Ω] {d : ℕ} (μ : Measure Ω)
    (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ) : Prop :=
  ∃ E : Set Ω, MeasurableSet E ∧ μ E = 1 ∧
    ∀ ω ∈ E, Tendsto (fun n : ℕ => Vn n ω) atTop (nhds (V ω))

/-- The event that the `n`-th random vector is more than `ε` away from its
candidate limit in Euclidean norm.  The explicit square-sum formula is used
because the default norm on the raw function type `Fin d → ℝ` is the sup norm,
not the Euclidean norm. -/
noncomputable def vectorEuclideanNorm {d : ℕ} (v : Fin d → ℝ) : ℝ :=
  Real.sqrt (∑ i : Fin d, (v i) ^ 2)

/-- The event that the `n`-th random vector is more than `ε` away from its
candidate limit in Euclidean norm. -/
def vectorDeviationEvent {Ω : Type*} {d : ℕ} (Vn : ℕ → Ω → Fin d → ℝ)
    (V : Ω → Fin d → ℝ) (n : ℕ) (ε : ℝ) : Set Ω :=
  {ω : Ω | vectorEuclideanNorm (Vn n ω - V ω) > ε}

/-- Convergence in probability for random vectors, using the Euclidean norm. -/
def VectorConvergesInProbability {Ω : Type*} [MeasurableSpace Ω] {d : ℕ} (μ : Measure Ω)
    (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ) : Prop :=
  ∀ ε : ℝ, 0 < ε →
    Tendsto (fun n : ℕ => μ (vectorDeviationEvent Vn V n ε)) atTop (nhds 0)

/-- Exported definition for Definition 10.6. -/
def def_10_6 :=
  (@VectorConvergesAlmostSurely, @VectorConvergesInProbability)
