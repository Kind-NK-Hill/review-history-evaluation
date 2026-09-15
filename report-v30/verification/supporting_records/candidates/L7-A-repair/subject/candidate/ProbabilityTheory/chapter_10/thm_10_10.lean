import Mathlib
import ProbabilityTheory.chapter_10.def_10_6
import ProbabilityTheory.chapter_10.def_10_1
import ProbabilityTheory.chapter_10.def_10_2
import ProbabilityTheory.chapter_02.prob_2_4

/-
TASK ID: thm_10_10
TYPE: Theorem_with_Proof
SOURCE PLAN: experiment_targets
TASK CONTENT:
\begin{thmbox}{10.10}
Let $(\Omega,\mathcal{F},P)$ be a probability space. For $n=1,2,3,\ldots$, let
\[
V_n(\omega)=(X_{n1}(\omega),X_{n2}(\omega),\ldots,X_{nd}(\omega))
\]
be a $d$-dimensional random vector, and let
\[
V(\omega)=(X_1(\omega),X_2(\omega),\ldots,X_d(\omega))
\]
be another $d$-dimensional random vector. Then:
\begin{enumerate}
\item $V_n\xrightarrow{\mathrm{a.s.}}V$ if and only if $X_{ni}\xrightarrow{\mathrm{a.s.}}X_i$ for all $i=1,\ldots,d$.
\item $V_n\xrightarrow{P}V$ if and only if $X_{ni}\xrightarrow{P}X_i$ for all $i=1,\ldots,d$.
\end{enumerate}
\end{thmbox}

\textit{Proof}
For part (a), suppose the component functions converge a.s. That is, for each $i=1,2,\ldots,d$, we can find an event $E_i$ with $P(E_i)=1$ such that
\[
X_{ni}(\omega)\xrightarrow{\mathrm{a.s.}}X_i(\omega)
\]
for $\omega\in E_i$. Then in $\bigcap_{i=1}^{d}E_i$, we have the convergence of random vector,
\[
\lim_{n\to\infty}V_n(\omega)=V(\omega)
\qquad\text{for }\omega\in\bigcap_{i=1}^{d}E_i.
\]
The proof is finished by noting that $P(\bigcap_{i=1}^{d}E_i)=1$.

Conversely, suppose $V_n\xrightarrow{\mathrm{a.s.}}V$. There is a set $E$ with probability $1$ such that $V_n(\omega)\to V(\omega)$ for $\omega\in E$. Each component of $V_n(\omega)$ converges to the corresponding component of $V$ for $\omega\in E$.

For part (b), assume that each component of $V_n$ converges in probability to the corresponding component of $V$. For any $\omega\in\Omega$,
\[
\lvert X_{ni}(\omega)-X_i(\omega)\rvert\leq \frac{\epsilon}{\sqrt{d}}
\text{ for all } i
\quad\Longrightarrow\quad
\lVert V_n(\omega)-V(\omega)\rVert\leq \epsilon.
\]
We thus have the following set inclusion:
\[
\{\omega:\lVert V_n-V\rVert>\epsilon\}
\subseteq
\bigcup_{i=1}^{d}
\left\{\omega:\lvert X_{ni}-X_i\rvert>\frac{\epsilon}{\sqrt{d}}\right\}.
\]
Taking probability of both sides, we get $P(\lVert V_n-V\rVert>\epsilon)\to 0$ as $n\to\infty$, which follows from the union bound (Exercise 2.4).

Conversely, assume that $V_n$ converges to $V$ in probability as a sequence of random vectors. Consider the $i$-th component of $V_n$. Since
\[
\lvert X_{ni}(\omega)-X_i(\omega)\rvert
\leq
\lVert V_n(\omega)-V(\omega)\rVert,
\]
we have
\[
\{\omega:\lvert X_{ni}(\omega)-X_i(\omega)\rvert>\epsilon\}
\subseteq
\{\omega:\lVert V_n(\omega)-V(\omega)\rVert>\epsilon\}.
\]
Hence, for any $\epsilon>0$,
\[
V_n\xrightarrow{P}V
\quad\Longrightarrow\quad
P(\lVert V_n(\omega)-V(\omega)\rVert>\epsilon)\to 0
\]
as $n\to\infty$, which implies
\[
P(\lvert X_{ni}(\omega)-X_i(\omega)\rvert>\epsilon)\to 0
\]
as $n\to\infty$. By the definition of convergence in probability, $X_{ni}$ converges to $X_i$ in probability for all $i$.
\hfill $\square$
-/

-- WRITE FINAL LEAN CODE BELOW

open Filter MeasureTheory Set Finset

lemma abs_apply_le_vectorEuclideanNorm {d : ℕ} (v : Fin d → ℝ) (i : Fin d) :
    |v i| ≤ vectorEuclideanNorm v := by
  unfold vectorEuclideanNorm
  have hi : (v i) ^ 2 ≤ ∑ j : Fin d, (v j) ^ 2 := by
    exact Finset.single_le_sum (fun j _ => sq_nonneg (v j)) (Finset.mem_univ i)
  rw [← Real.sqrt_sq_eq_abs (v i)]
  exact Real.sqrt_le_sqrt hi

lemma vectorEuclideanNorm_le_sum_abs {d : ℕ} (v : Fin d → ℝ) :
    vectorEuclideanNorm v ≤ ∑ i : Fin d, |v i| := by
  unfold vectorEuclideanNorm
  apply (Real.sqrt_le_iff).2
  constructor
  · exact Finset.sum_nonneg fun i _ => abs_nonneg (v i)
  · simpa only [sq_abs] using
      (Finset.sum_sq_le_sq_sum_of_nonneg
        (s := (Finset.univ : Finset (Fin d)))
        (f := fun i => |v i|) (fun i _ => abs_nonneg (v i)))


theorem coordinatewiseAETendsto_to_vector {Ω : Type*} [MeasurableSpace Ω] {d : ℕ}
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (hcoord : ∀ᵐ ω ∂μ, ∀ i : Fin d,
      Tendsto (fun n => Vn n ω i) atTop (nhds (V ω i))) :
    VectorConvergesAlmostSurely μ Vn V := by
  have hvec : ∀ᵐ ω ∂μ,
      Tendsto (fun n => Vn n ω) atTop (nhds (V ω)) := by
    filter_upwards [hcoord] with ω hω
    exact tendsto_pi_nhds.mpr hω
  have hbad : μ {ω : Ω |
      ¬ Tendsto (fun n => Vn n ω) atTop (nhds (V ω))} = 0 := ae_iff.mp hvec
  obtain ⟨N, hsub, hNmeas, hNnull⟩ :=
    exists_measurable_superset_of_null hbad
  refine ⟨Nᶜ, hNmeas.compl, ?_, ?_⟩
  · have hfin : μ N ≠ ⊤ := by simp [hNnull]
    rw [measure_compl hNmeas hfin, hNnull]
    simp [IsProbabilityMeasure.measure_univ]
  · intro ω hω
    by_contra hw
    exact hω (hsub hw)

theorem coordinatewiseAlmostSurely_to_vector {Ω : Type*} [MeasurableSpace Ω] {d : ℕ}
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (hcoord : ∀ i : Fin d,
      ConvergesAlmostSurely μ (fun n ω => Vn n ω i) (fun ω => V ω i)) :
    VectorConvergesAlmostSurely μ Vn V := by
  apply coordinatewiseAETendsto_to_vector μ Vn V
  rw [MeasureTheory.ae_all_iff]
  intro i
  exact (hcoord i).2.2

theorem coordinatewiseDeviationTendsto_to_vector
    {Ω : Type*} [MeasurableSpace Ω] {d : ℕ}
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (hcoord : ∀ i : Fin d, ∀ ε : ℝ, 0 < ε →
      Tendsto
        (fun n => μ (deviationEvent (fun k ω => Vn k ω i) (fun ω => V ω i) n ε))
        atTop (nhds 0)) :
    VectorConvergesInProbability μ Vn V := by
  intro ε hε
  let δ : ℝ := ε / ((d : ℝ) + 1)
  have hden : 0 < (d : ℝ) + 1 := by positivity
  have hδ : 0 < δ := div_pos hε hden
  let A : Fin d → ℕ → Set Ω := fun i n =>
    deviationEvent (fun k ω => Vn k ω i) (fun ω => V ω i) n δ
  have hsubset : ∀ n, vectorDeviationEvent Vn V n ε ⊆ ⋃ i : Fin d, A i n := by
    intro n ω hω
    by_contra hall
    simp only [mem_iUnion, not_exists] at hall
    have hle : ∀ i : Fin d, |Vn n ω i - V ω i| ≤ δ := by
      intro i
      have hi := hall i
      change ¬ δ < |Vn n ω i - V ω i| at hi
      exact le_of_not_gt hi
    have hsum : (∑ i : Fin d, |Vn n ω i - V ω i|) ≤ (d : ℝ) * δ := by
      calc
        (∑ i : Fin d, |Vn n ω i - V ω i|) ≤ ∑ _i : Fin d, δ :=
          Finset.sum_le_sum fun i _ => hle i
        _ = (d : ℝ) * δ := by simp
    have hstrict : (d : ℝ) * δ < ε := by
      dsimp [δ]
      rw [← mul_div_assoc]
      apply (div_lt_iff₀ hden).2
      have hd : (0 : ℝ) ≤ (d : ℝ) := Nat.cast_nonneg d
      nlinarith
    have hnorm : vectorEuclideanNorm (Vn n ω - V ω) < ε :=
      lt_of_le_of_lt
        (by simpa using vectorEuclideanNorm_le_sum_abs (Vn n ω - V ω))
        (lt_of_le_of_lt hsum hstrict)
    exact (not_lt_of_ge (le_of_lt hnorm)) hω
  have hmeasure : ∀ n,
      μ (vectorDeviationEvent Vn V n ε) ≤ ∑ i : Fin d, μ (A i n) := by
    intro n
    calc
      μ (vectorDeviationEvent Vn V n ε) ≤ μ (⋃ i : Fin d, A i n) :=
        measure_mono (hsubset n)
      _ ≤ ∑ i : Fin d, μ (A i n) := by
        simpa only [tsum_fintype] using
          (measure_iUnion_le (fun i : Fin d => A i n) :
            μ (⋃ i : Fin d, A i n) ≤ ∑' i : Fin d, μ (A i n))
  have hsum_tendsto :
      Tendsto (fun n => ∑ i : Fin d, μ (A i n)) atTop (nhds 0) := by
    simpa [A, δ] using
      (tendsto_finset_sum (Finset.univ : Finset (Fin d))
        (fun i _ => hcoord i δ hδ))
  exact tendsto_of_tendsto_of_tendsto_of_le_of_le
    tendsto_const_nhds hsum_tendsto
    (fun _ => bot_le) hmeasure

theorem coordinatewiseInProbability_to_vector
    {Ω : Type*} [MeasurableSpace Ω] {d : ℕ}
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (hcoord : ∀ i : Fin d,
      ConvergesInProbability μ (fun n ω => Vn n ω i) (fun ω => V ω i)) :
    VectorConvergesInProbability μ Vn V := by
  exact coordinatewiseDeviationTendsto_to_vector μ Vn V
    (fun i ε hε => (hcoord i).2.2 ε hε)

theorem thm_10_10 {Ω : Type*} [MeasurableSpace Ω] {d : ℕ}
    (μ : Measure Ω) [IsProbabilityMeasure μ]
    (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (hVn : ∀ n, Measurable (Vn n)) (hV : Measurable V) :
    (VectorConvergesAlmostSurely μ Vn V ↔
        ∀ i : Fin d,
          ConvergesAlmostSurely μ (fun n ω => Vn n ω i) (fun ω => V ω i)) ∧
      (VectorConvergesInProbability μ Vn V ↔
        ∀ i : Fin d,
          ConvergesInProbability μ (fun n ω => Vn n ω i) (fun ω => V ω i)) := by
  constructor
  · constructor
    · rintro ⟨E, hE, hE_one, hconv⟩ i
      refine ⟨fun n => ((measurable_pi_iff.mp (hVn n)) i).aestronglyMeasurable,
        ((measurable_pi_iff.mp hV) i).aestronglyMeasurable, ?_⟩
      have hfin : μ E ≠ ⊤ := by rw [hE_one]; simp
      have hEc : μ Eᶜ = 0 := by
        rw [measure_compl hE hfin]
        simp [hE_one, IsProbabilityMeasure.measure_univ]
      have haeE : ∀ᵐ ω ∂μ, ω ∈ E := by
        rw [ae_iff]
        change μ Eᶜ = 0
        exact hEc
      filter_upwards [haeE] with ω hω
      exact (tendsto_pi_nhds.mp (hconv ω hω)) i
    · intro hcoord
      exact coordinatewiseAlmostSurely_to_vector μ Vn V hcoord
  · constructor
    · intro hvec i
      refine ⟨fun n => (measurable_pi_iff.mp (hVn n)) i, (measurable_pi_iff.mp hV) i, ?_⟩
      intro ε hε
      have hsub : ∀ n,
          deviationEvent (fun n ω => Vn n ω i) (fun ω => V ω i) n ε ⊆
            vectorDeviationEvent Vn V n ε := by
        intro n ω hω
        change ε < |Vn n ω i - V ω i| at hω
        change ε < vectorEuclideanNorm (Vn n ω - V ω)
        exact lt_of_lt_of_le hω (by
          simpa using abs_apply_le_vectorEuclideanNorm (Vn n ω - V ω) i)
      exact tendsto_of_tendsto_of_tendsto_of_le_of_le
        tendsto_const_nhds (hvec ε hε)
        (fun _ => bot_le) (fun n => measure_mono (hsub n))
    · intro hcoord
      exact coordinatewiseInProbability_to_vector μ Vn V hcoord
