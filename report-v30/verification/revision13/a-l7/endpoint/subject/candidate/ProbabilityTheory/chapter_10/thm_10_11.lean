import Mathlib
import ProbabilityTheory.chapter_10.thm_10_10
import ProbabilityTheory.chapter_10.def_10_1
import ProbabilityTheory.chapter_10.def_10_2
import ProbabilityTheory.chapter_10.def_10_6

/-
TASK ID: thm_10_11
TYPE: Theorem_with_Proof
SOURCE PLAN: experiment_targets
TASK CONTENT:
\begin{thmbox}{10.11}
Let $(\Omega,\mathcal{F},P)$ be a probability space, let $V$ be a $d$-dimensional random vector, and let $(V_n)_{n=1}^{\infty}$ be a sequence of $d$-dimensional random vectors. Suppose $f:\mathbb{R}^d\to\mathbb{R}^m$ is a function that is continuous on a set $S_f\subseteq\mathbb{R}^d$ with $P(V\in S_f)=1$. Then:
\begin{enumerate}
\item $V_n\xrightarrow{\mathrm{a.s.}}V$ implies $f(V_n)\xrightarrow{\mathrm{a.s.}}f(V)$.
\item $V_n\xrightarrow{P}V$ implies $f(V_n)\xrightarrow{P}f(V)$.
\end{enumerate}
\end{thmbox}

\textit{Proof}
We let $f_k$ be the $k$-th component of the function $f$, for $k=1,2,\ldots,m$.

For part (a), by Theorem 10.10, it is sufficient to show that for each component function $f_k$ of $f$, we have
\[
f_k(V_n)\xrightarrow{\mathrm{a.s.}}f_k(V).
\]
From the hypotheses in the theorem, there exists a set $B$ with probability $1$ such that $V_n(\omega)\to V(\omega)$ for all $\omega\in B$. Let $A$ be the pre-image $V^{-1}(S_f)$. The set $A$ has probability $1$ by assumption. Hence, in $A\cap B$, we have
\[
\lim_{n\to\infty}V_n(\omega)=V(\omega),
\]
and
\[
\lim_{n\to\infty}f_k(V_n(\omega))=f_k(V(\omega)),
\]
by the continuity of $f_k$. Therefore $f_k(V_n)$ converges to $f_k(V)$ for all $\omega$ in $A\cap B$, which has probability $1$.

For part (b), by Theorem 10.10, it is sufficient to show that for each component function $f_k$ of $f$, we have $f_k(V_n)$ converging to $f_k(V)$ in probability. In the following we fix an index $k$.

Let $\delta$ and $\epsilon$ be positive real numbers. Consider the set
\[
A_{\delta,\epsilon}\coloneqq
\{v\in\mathbb{R}^d:\exists w\in\mathbb{R}^d
\text{ such that }\lVert w-v\rVert<\delta
\text{ and }
\lVert f_k(w)-f_k(v)\rVert>\epsilon\}.
\]
For each vector $v$ that is not in $A_{\delta,\epsilon}$, we cannot find any vector $w$ that satisfies $\lVert w-v\rVert<\delta$ and $\lVert f_k(w)-f_k(v)\rVert>\epsilon$ simultaneously. In set notation, we can express it as
\[
\{\omega:\lVert f_k(V_n(\omega))-f_k(V(\omega))\rVert>\epsilon\}
\subseteq
\{\omega:V(\omega)\in A_{\delta,\epsilon}\}
\cup
\{\omega:\lVert V_n(\omega)-V(\omega)\rVert\geq\delta\}.
\]
Take $\delta=1/j$ for positive integer $j$. By the continuity of $f$, and hence of the component function $f_k$, the set $A_{1/j,\epsilon}\cap S_f$ decreases to $\emptyset$ as $j$ tends to infinity. By the upper semi-continuous property of measure, we obtain
\[
P(\{\omega:V(\omega)\in A_{1/j,\epsilon}\})
=
P(\{\omega:V(\omega)\in A_{1/j,\epsilon}\cap S_f\})
\to 0
\]
as $j\to\infty$.

For an arbitrarily small $\epsilon_1>0$, we can find a sufficiently large $M$ such that
\[
P(\{\omega:V(\omega)\in A_{1/\ell,\epsilon}\})\leq \epsilon_1/2
\]
for all $\ell\geq M$.

Since it is assumed that $V_n\to V$ in probability, we can find a sufficiently large $N$ such that
\[
P(\{\lVert V_\ell(\omega)-V(\omega)\rVert\geq\delta\})\leq \epsilon_1/2
\]
for all $\ell\geq N$. This yields
\[
P(\{\lVert f_k(V_\ell(\omega))-f_k(V(\omega))\rVert>\epsilon\})
\leq \epsilon_1/2+\epsilon_1/2=\epsilon_1
\]
for all $\ell\geq \max(M,N)$. As $\epsilon_1$ is arbitrary, the probability
\[
P(\lVert f_k(V_\ell)-f_k(V)\rVert>\epsilon)
\]
converges to $0$ as $\ell\to\infty$.
\hfill $\square$
-/

-- WRITE FINAL LEAN CODE BELOW


open Filter MeasureTheory
open scoped BigOperators ENNReal

/-- Euclidean vector convergence in probability gives Mathlib convergence in
measure after putting the Euclidean norm on the finite product. -/
private lemma vectorConvergesInProbability_tendstoInMeasure_euclidean
    {Ω : Type*} [MeasurableSpace Ω] {d : ℕ} (μ : Measure Ω)
    (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (h : VectorConvergesInProbability μ Vn V) :
    TendstoInMeasure μ
      (fun n ω => (WithLp.toLp 2 (Vn n ω) : EuclideanSpace ℝ (Fin d))) atTop
      (fun ω => (WithLp.toLp 2 (V ω) : EuclideanSpace ℝ (Fin d))) := by
  rw [tendstoInMeasure_iff_norm]
  intro ε hε
  have hsmall := h (ε / 2) (half_pos hε)
  refine tendsto_of_tendsto_of_tendsto_of_le_of_le tendsto_const_nhds hsmall
    (fun _ => bot_le) (fun n => measure_mono ?_)
  intro ω hω
  have hnorm :
      ‖(WithLp.toLp 2 (Vn n ω) : EuclideanSpace ℝ (Fin d)) -
        WithLp.toLp 2 (V ω)‖ = vectorEuclideanNorm (Vn n ω - V ω) := by
    simp [EuclideanSpace.norm_eq, vectorEuclideanNorm, Real.norm_eq_abs, sq_abs]
  change ε ≤ ‖(WithLp.toLp 2 (Vn n ω) : EuclideanSpace ℝ (Fin d)) -
    WithLp.toLp 2 (V ω)‖ at hω
  change vectorEuclideanNorm (Vn n ω - V ω) > ε / 2
  rw [hnorm] at hω
  exact lt_of_lt_of_le (half_lt_self hε) hω

/-- The scalar continuous-mapping step.  Every subsequence has a further input
subsequence converging almost everywhere; continuity at the almost-everywhere
limit then gives the corresponding output-coordinate convergence. -/
private lemma continuousAt_ae_coordinate_tendstoInMeasure
    {Ω : Type*} [MeasurableSpace Ω] {d m : ℕ} (μ : Measure Ω)
    [IsProbabilityMeasure μ]
    (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (f : (Fin d → ℝ) → Fin m → ℝ)
    (hcompVn : ∀ n, Measurable (fun ω => f (Vn n ω)))
    (hcont : ∀ᵐ ω ∂μ, ContinuousAt f (V ω))
    (hprob : VectorConvergesInProbability μ Vn V) (k : Fin m) :
    TendstoInMeasure μ (fun n ω => f (Vn n ω) k) atTop
      (fun ω => f (V ω) k) := by
  apply (exists_seq_tendstoInMeasure_atTop_iff
    (fun n => (measurable_pi_iff.mp (hcompVn n) k).aestronglyMeasurable)).2
  intro ns hns
  obtain ⟨ns', hns', hae⟩ :=
    ((vectorConvergesInProbability_tendstoInMeasure_euclidean μ Vn V hprob).comp
      hns.tendsto_atTop).exists_seq_tendsto_ae
  refine ⟨ns', hns', ?_⟩
  filter_upwards [hae, hcont] with ω hlim hc
  have hraw : Tendsto (fun i => Vn (ns (ns' i)) ω) atTop (nhds (V ω)) := by
    have h :=
      (PiLp.continuous_ofLp 2 (fun _ : Fin d => ℝ)).continuousAt.tendsto.comp hlim
    rw [show (fun i => Vn (ns (ns' i)) ω) = WithLp.ofLp ∘
        (fun i => (WithLp.toLp 2 (Vn (ns (ns' i)) ω) :
          EuclideanSpace ℝ (Fin d))) by
      funext i
      simp]
    rw [show V ω = (WithLp.toLp 2 (V ω) : EuclideanSpace ℝ (Fin d)).ofLp by simp]
    exact h
  exact (hc.tendsto.comp hraw).apply_nhds k

/-- The mathematically corrected form of textbook Theorem 10.11 (the
continuous mapping theorem).  The source phrase “continuous on `S`” must mean
ambient continuity at every point of `S`, as its proof applies `f` to sequences
that may approach `S` from outside.  It cannot mean Mathlib's relative
`ContinuousOn f S`; that reading is false already for `S = {0}` and a function
discontinuous when approaching zero from outside `S`.

The interface therefore states the intended condition explicitly as
`∀ x ∈ S, ContinuousAt f x`.  It also makes the random-vector contract
explicit: `f`, `Vn n`, and `V` are Borel measurable, while `V` belongs to `S`
almost everywhere via the measurable full-probability event.  Measurability of
the composites is proved below from these data and is not assumed.  The
probability part uses the equivalent subsequence characterization of
convergence in measure, avoiding any extra measurability assumption for the
textbook's projected bad-center sets. -/
theorem thm_10_11 {Ω : Type*} [MeasurableSpace Ω] {d m : ℕ} (μ : Measure Ω)
    [IsProbabilityMeasure μ]
    (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (hVn : ∀ n, Measurable (Vn n)) (hV : Measurable V)
    (f : (Fin d → ℝ) → Fin m → ℝ) (hf : Measurable f)
    (S : Set (Fin d → ℝ)) (hEvent : MeasurableSet (V ⁻¹' S))
    (hSfull : μ (V ⁻¹' S) = 1) (hcont : ∀ x ∈ S, ContinuousAt f x) :
    (VectorConvergesAlmostSurely μ Vn V →
      VectorConvergesAlmostSurely μ (fun n ω => f (Vn n ω))
        (fun ω => f (V ω))) ∧
    (VectorConvergesInProbability μ Vn V →
      VectorConvergesInProbability μ (fun n ω => f (Vn n ω))
        (fun ω => f (V ω))) := by
  have hfin : μ (V ⁻¹' S) ≠ ⊤ := by rw [hSfull]; simp
  have hcompl : μ (V ⁻¹' S)ᶜ = 0 := by
    rw [MeasureTheory.measure_compl hEvent hfin]
    simp [hSfull, MeasureTheory.IsProbabilityMeasure.measure_univ]
  have haeS : ∀ᵐ ω ∂μ, V ω ∈ S := by
    change V ⁻¹' S ∈ ae μ
    exact mem_ae_iff.2 hcompl
  have hcompVn : ∀ n, Measurable (fun ω => f (Vn n ω)) :=
    fun n => hf.comp (hVn n)
  have hcompV : Measurable (fun ω => f (V ω)) := hf.comp hV
  constructor
  · rintro ⟨E, hE, hEone, hconv⟩
    have hEfin : μ E ≠ ⊤ := by rw [hEone]; simp
    have hEcompl : μ Eᶜ = 0 := by
      rw [MeasureTheory.measure_compl hE hEfin]
      simp [hEone, MeasureTheory.IsProbabilityMeasure.measure_univ]
    have haeE : ∀ᵐ ω ∂μ, ω ∈ E := mem_ae_iff.2 hEcompl
    apply vectorConvergesAlmostSurely_of_coordinatewise μ
      (fun n ω => f (Vn n ω)) (fun ω => f (V ω))
    intro k
    filter_upwards [haeE, haeS] with ω hωE hωS
    exact ((hcont (V ω) hωS).tendsto.comp (hconv ω hωE)).apply_nhds k
  · intro hprob
    apply vectorConvergesInProbability_of_coordinatewise μ
      (fun n ω => f (Vn n ω)) (fun ω => f (V ω))
    intro k ε hε
    have hout := continuousAt_ae_coordinate_tendstoInMeasure μ Vn V f hcompVn
      (haeS.mono (fun ω hω => hcont (V ω) hω)) hprob k
    have hmeasure := (tendstoInMeasure_iff_norm.mp hout) ε hε
    refine tendsto_of_tendsto_of_tendsto_of_le_of_le tendsto_const_nhds hmeasure
      (fun _ => bot_le) (fun n => measure_mono ?_)
    intro ω hω
    change |f (Vn n ω) k - f (V ω) k| > ε at hω
    change ε ≤ ‖f (Vn n ω) k - f (V ω) k‖
    simpa [Real.norm_eq_abs] using le_of_lt hω
