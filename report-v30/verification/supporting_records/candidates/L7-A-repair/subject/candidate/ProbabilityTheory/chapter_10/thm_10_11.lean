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

open Filter MeasureTheory Set

lemma piNorm_le_vectorEuclideanNorm {d : ℕ} (v : Fin d → ℝ) :
    ‖v‖ ≤ vectorEuclideanNorm v := by
  apply (pi_norm_le_iff_of_nonneg (Real.sqrt_nonneg _)).2
  intro i
  simpa [Real.norm_eq_abs, vectorEuclideanNorm] using abs_apply_le_vectorEuclideanNorm v i

theorem thm_10_11 {Ω : Type*} [MeasurableSpace Ω] {d m : ℕ}
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (f : (Fin d → ℝ) → (Fin m → ℝ)) (S : Set (Fin d → ℝ))
    (hVn : ∀ n, Measurable (Vn n)) (hV : Measurable V)
    (hf : ∀ x ∈ S, ContinuousAt f x)
    (hVS : μ (V ⁻¹' S) = 1) :
    (VectorConvergesAlmostSurely μ Vn V →
      VectorConvergesAlmostSurely μ (fun n ω => f (Vn n ω)) (fun ω => f (V ω))) ∧
    (VectorConvergesInProbability μ Vn V →
      VectorConvergesInProbability μ (fun n ω => f (Vn n ω)) (fun ω => f (V ω))) := by
  let C : Set (Fin d → ℝ) := {x | ContinuousAt f x}
  have hSC : S ⊆ C := by
    intro x hx
    exact hf x hx
  have hCmeas : MeasurableSet C := measurableSet_of_continuousAt f
  have hpreC : μ (V ⁻¹' C) = 1 := by
    apply le_antisymm
    · calc
        μ (V ⁻¹' C) ≤ μ Set.univ := measure_mono (Set.subset_univ _)
        _ = 1 := IsProbabilityMeasure.measure_univ
    · rw [← hVS]
      exact measure_mono (Set.preimage_mono hSC)
  have hpreCae : ∀ᵐ ω ∂μ, V ω ∈ C := by
    rw [ae_iff]
    change μ (V ⁻¹' C)ᶜ = 0
    have hfin : μ (V ⁻¹' C) ≠ ⊤ := by rw [hpreC]; simp
    rw [measure_compl (hCmeas.preimage hV) hfin, hpreC]
    simp [IsProbabilityMeasure.measure_univ]
  constructor
  · rintro ⟨E, hE, hE_one, hconv⟩
    have hEae : ∀ᵐ ω ∂μ, ω ∈ E := by
      rw [ae_iff]
      change μ Eᶜ = 0
      have hfin : μ E ≠ ⊤ := by rw [hE_one]; simp
      rw [measure_compl hE hfin, hE_one]
      simp [IsProbabilityMeasure.measure_univ]
    apply coordinatewiseAETendsto_to_vector μ
      (fun n ω => f (Vn n ω)) (fun ω => f (V ω))
    filter_upwards [hEae, hpreCae] with ω hωE hωC
    intro i
    have hcomp :
        Tendsto (fun n => f (Vn n ω)) atTop (nhds (f (V ω))) :=
      hωC.tendsto.comp (hconv ω hωE)
    exact (tendsto_pi_nhds.mp hcomp) i
  · intro hprob
    intro ε hε
    rw [ENNReal.tendsto_atTop_zero]
    intro η hη
    let ν : Measure (Fin d → ℝ) := μ.map V
    haveI : IsProbabilityMeasure ν :=
      Measure.isProbabilityMeasure_map hV.aemeasurable
    have hνC : ν C = 1 := by
      dsimp [ν]
      rw [Measure.map_apply hV hCmeas]
      exact hpreC
    have hhalf : η / 2 ≠ 0 := by
      exact ENNReal.div_ne_zero.mpr ⟨hη.ne', by norm_num⟩
    obtain ⟨K, hKC, hKcompact, hCK⟩ :=
      hCmeas.exists_isCompact_sdiff_lt (by rw [hνC]; simp) hhalf
    have hνCcompl : ν Cᶜ = 0 := by
      have hfin : ν C ≠ ⊤ := by rw [hνC]; simp
      rw [measure_compl hCmeas hfin, hνC]
      simp [IsProbabilityMeasure.measure_univ]
    have hKmeas : MeasurableSet K := hKcompact.measurableSet
    have hνKcompl : ν Kᶜ < η / 2 := by
      calc
        ν Kᶜ ≤ ν ((C \ K) ∪ Cᶜ) := by
          apply measure_mono
          intro x hx
          by_cases hxC : x ∈ C
          · exact Or.inl ⟨hxC, hx⟩
          · exact Or.inr hxC
        _ ≤ ν (C \ K) + ν Cᶜ := measure_union_le _ _
        _ = ν (C \ K) := by simp [hνCcompl]
        _ < η / 2 := hCK
    let ρ : ℝ := ε / ((m : ℝ) + 1)
    have hmden : 0 < (m : ℝ) + 1 := by positivity
    have hρ : 0 < ρ := div_pos hε hmden
    let r : Set ((Fin m → ℝ) × (Fin m → ℝ)) :=
      {p | dist p.1 p.2 < ρ}
    have hr : r ∈ uniformity (Fin m → ℝ) := by
      exact Metric.mem_uniformity_dist.mpr ⟨ρ, hρ, by
        intro a b hab
        exact hab⟩
    have hu := hKcompact.uniformContinuousAt_of_continuousAt f
      (fun x hx => hKC hx) hr
    obtain ⟨δ, hδ, hδsub⟩ := Metric.mem_uniformity_dist.mp hu
    have hδhalf : 0 < δ / 2 := half_pos hδ
    have hinput := hprob (δ / 2) hδhalf
    rw [ENNReal.tendsto_atTop_zero] at hinput
    obtain ⟨N, hN⟩ := hinput (η / 2) (ENNReal.div_pos hη.ne' (by norm_num))
    refine ⟨N, fun n hn => ?_⟩
    have hbadsubset :
        vectorDeviationEvent (fun n ω => f (Vn n ω)) (fun ω => f (V ω)) n ε ⊆
          (V ⁻¹' (Kᶜ)) ∪ vectorDeviationEvent Vn V n (δ / 2) := by
      intro ω hω
      by_cases hωK : V ω ∈ K
      · right
        by_contra hin
        have heuc : vectorEuclideanNorm (Vn n ω - V ω) ≤ δ / 2 := by
          change ¬ δ / 2 < vectorEuclideanNorm (Vn n ω - V ω) at hin
          exact le_of_not_gt hin
        have hdist : dist (V ω) (Vn n ω) < δ := by
          calc
            dist (V ω) (Vn n ω) = ‖Vn n ω - V ω‖ := by
              rw [dist_comm, dist_eq_norm]
            _ ≤ vectorEuclideanNorm (Vn n ω - V ω) :=
              piNorm_le_vectorEuclideanNorm _
            _ ≤ δ / 2 := heuc
            _ < δ := half_lt_self hδ
        have hpair := hδsub hdist
        have hfclose : dist (f (V ω)) (f (Vn n ω)) < ρ := hpair hωK
        have hsum :
            (∑ i : Fin m, |f (Vn n ω) i - f (V ω) i|) ≤
              (m : ℝ) * ‖f (Vn n ω) - f (V ω)‖ := by
          calc
            (∑ i : Fin m, |f (Vn n ω) i - f (V ω) i|) ≤
                ∑ _i : Fin m, ‖f (Vn n ω) - f (V ω)‖ := by
              apply Finset.sum_le_sum
              intro i hi
              simpa [Real.norm_eq_abs] using
                (norm_le_pi_norm (f (Vn n ω) - f (V ω)) i)
            _ = (m : ℝ) * ‖f (Vn n ω) - f (V ω)‖ := by simp
        have hnormlt : ‖f (Vn n ω) - f (V ω)‖ < ρ := by
          calc
            ‖f (Vn n ω) - f (V ω)‖ = ‖-(f (V ω) - f (Vn n ω))‖ := by
              congr 1
              abel
            _ = ‖f (V ω) - f (Vn n ω)‖ := norm_neg _
            _ < ρ := by simpa [dist_eq_norm] using hfclose
        have hmstrict : (m : ℝ) * ρ < ε := by
          dsimp [ρ]
          rw [← mul_div_assoc]
          apply (div_lt_iff₀ hmden).2
          have hm0 : (0 : ℝ) ≤ (m : ℝ) := Nat.cast_nonneg m
          nlinarith
        have hmul :
            (m : ℝ) * ‖f (Vn n ω) - f (V ω)‖ ≤ (m : ℝ) * ρ :=
          mul_le_mul_of_nonneg_left (le_of_lt hnormlt) (Nat.cast_nonneg m)
        have hout :
            vectorEuclideanNorm (f (Vn n ω) - f (V ω)) < ε :=
          lt_of_le_of_lt
            (vectorEuclideanNorm_le_sum_abs _)
            (lt_of_le_of_lt hsum (lt_of_le_of_lt hmul hmstrict))
        exact (not_lt_of_ge (le_of_lt hout)) hω
      · left
        exact hωK
    have hmapK : μ (V ⁻¹' (Kᶜ)) = ν Kᶜ := by
      dsimp [ν]
      rw [Measure.map_apply hV hKmeas.compl]
      simp only [Set.preimage_compl]
    calc
      μ (vectorDeviationEvent (fun n ω => f (Vn n ω)) (fun ω => f (V ω)) n ε)
          ≤ μ ((V ⁻¹' (Kᶜ)) ∪ vectorDeviationEvent Vn V n (δ / 2)) :=
        measure_mono hbadsubset
      _ ≤ μ (V ⁻¹' (Kᶜ)) + μ (vectorDeviationEvent Vn V n (δ / 2)) :=
        measure_union_le _ _
      _ ≤ η / 2 + η / 2 := add_le_add
        (by rw [hmapK]; exact le_of_lt hνKcompl) (hN n hn)
      _ = η := ENNReal.add_halves η
