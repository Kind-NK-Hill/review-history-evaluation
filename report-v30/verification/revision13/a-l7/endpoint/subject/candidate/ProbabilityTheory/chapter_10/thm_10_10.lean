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


open Filter MeasureTheory
open scoped BigOperators

/-- Every coordinate absolute value is bounded by the Euclidean norm. -/
lemma coordinate_abs_le_vectorEuclideanNorm {d : ℕ} (v : Fin d → ℝ) (i : Fin d) :
    |v i| ≤ vectorEuclideanNorm v := by
  unfold vectorEuclideanNorm
  rw [← Real.sqrt_sq_eq_abs]
  exact Real.sqrt_le_sqrt
    (Finset.single_le_sum (fun j _ => sq_nonneg (v j)) (Finset.mem_univ i))

/-- If all coordinates are bounded by `δ`, the Euclidean norm is bounded by
`sqrt d * δ`. -/
lemma vectorEuclideanNorm_le_sqrt_card_mul_of_coordinate_le {d : ℕ}
    (v : Fin d → ℝ) (δ : ℝ) (hδ : 0 ≤ δ) (h : ∀ i, |v i| ≤ δ) :
    vectorEuclideanNorm v ≤ Real.sqrt d * δ := by
  unfold vectorEuclideanNorm
  rw [Real.sqrt_le_iff]
  constructor
  · positivity
  · calc
      ∑ i : Fin d, (v i) ^ 2 ≤ ∑ _i : Fin d, δ ^ 2 := by
        apply Finset.sum_le_sum
        intro i _
        simpa [sq_abs] using (sq_le_sq₀ (abs_nonneg (v i)) hδ).2 (h i)
      _ = (d : ℝ) * δ ^ 2 := by simp
      _ = (Real.sqrt d * δ) ^ 2 := by
        rw [mul_pow, Real.sq_sqrt (Nat.cast_nonneg d)]

private lemma vectorDeviationEvent_subset_iUnion_coordinateDeviationEvent
    {Ω : Type*} {d : ℕ} (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (n : ℕ) {ε : ℝ} (hε : 0 < ε) (hd : d ≠ 0) :
    vectorDeviationEvent Vn V n ε ⊆
      ⋃ i : Fin d, deviationEvent (fun k ω => Vn k ω i) (fun ω => V ω i) n
        (ε / Real.sqrt d) := by
  intro ω hω
  have hsqrt : 0 < Real.sqrt d :=
    Real.sqrt_pos.2 (Nat.cast_pos.2 (Nat.pos_of_ne_zero hd))
  by_contra hnot
  have hall : ∀ i : Fin d, |Vn n ω i - V ω i| ≤ ε / Real.sqrt d := by
    intro i
    by_contra hi
    apply hnot
    simp only [Set.mem_iUnion, deviationEvent, Set.mem_setOf_eq]
    exact ⟨i, lt_of_not_ge hi⟩
  have hnorm := vectorEuclideanNorm_le_sqrt_card_mul_of_coordinate_le
    (Vn n ω - V ω) (ε / Real.sqrt d) (le_of_lt (div_pos hε hsqrt)) (by
      intro i
      simpa using hall i)
  have hsqrt_ne : Real.sqrt (d : ℝ) ≠ 0 := ne_of_gt hsqrt
  have heq : Real.sqrt d * (ε / Real.sqrt d) = ε := by field_simp
  rw [heq] at hnorm
  exact (not_lt_of_ge hnorm) hω

private lemma coordinateDeviationEvent_subset_vectorDeviationEvent
    {Ω : Type*} {d : ℕ} (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (n : ℕ) (i : Fin d) (ε : ℝ) :
    deviationEvent (fun k ω => Vn k ω i) (fun ω => V ω i) n ε ⊆
      vectorDeviationEvent Vn V n ε := by
  intro ω hω
  exact lt_of_lt_of_le hω (by
    simpa using coordinate_abs_le_vectorEuclideanNorm (Vn n ω - V ω) i)

/-- Coordinatewise almost-everywhere convergence gives vector almost-sure
convergence.  This direction is purely about convergence and does not require
global measurability of the vector-valued maps. -/
theorem vectorConvergesAlmostSurely_of_coordinatewise
    {Ω : Type*} [MeasurableSpace Ω] {d : ℕ} (μ : Measure Ω)
    [IsProbabilityMeasure μ] (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (hcoord : ∀ i : Fin d, ∀ᵐ ω ∂μ,
      Tendsto (fun n => Vn n ω i) atTop (nhds (V ω i))) :
    VectorConvergesAlmostSurely μ Vn V := by
  have hae : ∀ᵐ ω ∂μ, ∀ i : Fin d,
      Tendsto (fun n => Vn n ω i) atTop (nhds (V ω i)) :=
    ae_all_iff.mpr hcoord
  have hbad : μ {ω : Ω | ¬ ∀ i : Fin d,
      Tendsto (fun n => Vn n ω i) atTop (nhds (V ω i))} = 0 := ae_iff.1 hae
  obtain ⟨N, hsub, hNmeas, hNnull⟩ := exists_measurable_superset_of_null hbad
  refine ⟨Nᶜ, hNmeas.compl, ?_, ?_⟩
  · have hfin : μ N ≠ ⊤ := by rw [hNnull]; simp
    rw [MeasureTheory.measure_compl hNmeas hfin]
    simp [hNnull, MeasureTheory.IsProbabilityMeasure.measure_univ]
  · intro ω hω
    apply tendsto_pi_nhds.mpr
    intro i
    by_contra hfail
    exact hω (hsub (by
      show ¬ ∀ j : Fin d, Tendsto (fun n => Vn n ω j) atTop (nhds (V ω j))
      intro hall
      exact hfail (hall i)))

/-- Coordinatewise decay of deviation-event probabilities gives vector
convergence in probability.  No global measurability of `Vn` or `V` is needed. -/
theorem vectorConvergesInProbability_of_coordinatewise
    {Ω : Type*} [MeasurableSpace Ω] {d : ℕ} (μ : Measure Ω)
    [IsProbabilityMeasure μ] (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (hcoord : ∀ i : Fin d, ∀ ε : ℝ, 0 < ε →
      Tendsto (fun n => μ (deviationEvent (fun k ω => Vn k ω i)
        (fun ω => V ω i) n ε)) atTop (nhds 0)) :
    VectorConvergesInProbability μ Vn V := by
  intro ε hε
  by_cases hd : d = 0
  · subst d
    have hzero :
        (fun n => μ (vectorDeviationEvent Vn V n ε)) = fun _ : ℕ => 0 := by
      funext n
      have hempty : vectorDeviationEvent Vn V n ε = (∅ : Set Ω) := by
        ext ω
        simp [vectorDeviationEvent, vectorEuclideanNorm,
          not_lt_of_ge (le_of_lt hε)]
      simp [hempty]
    rw [hzero]
    exact tendsto_const_nhds
  · have hsqrt : 0 < Real.sqrt d :=
      Real.sqrt_pos.2 (Nat.cast_pos.2 (Nat.pos_of_ne_zero hd))
    have hδ : 0 < ε / Real.sqrt d := div_pos hε hsqrt
    have hsum : Tendsto
        (fun n => ∑ i : Fin d,
          μ (deviationEvent (fun k ω => Vn k ω i) (fun ω => V ω i) n
            (ε / Real.sqrt d))) atTop (nhds 0) := by
      simpa using tendsto_finsetSum Finset.univ (fun i _ => hcoord i _ hδ)
    refine tendsto_of_tendsto_of_tendsto_of_le_of_le tendsto_const_nhds hsum
      (fun _ => bot_le) (fun n => ?_)
    calc
      μ (vectorDeviationEvent Vn V n ε) ≤
          μ (⋃ i : Fin d, deviationEvent (fun k ω => Vn k ω i)
            (fun ω => V ω i) n (ε / Real.sqrt d)) :=
        measure_mono (vectorDeviationEvent_subset_iUnion_coordinateDeviationEvent
          Vn V n hε hd)
      _ ≤ ∑' i : Fin d, μ (deviationEvent (fun k ω => Vn k ω i)
            (fun ω => V ω i) n (ε / Real.sqrt d)) := measure_iUnion_le _
      _ = ∑ i : Fin d, μ (deviationEvent (fun k ω => Vn k ω i)
            (fun ω => V ω i) n (ε / Real.sqrt d)) := tsum_fintype _

/-- Textbook Theorem 10.10: finite real random vectors converge almost surely,
respectively in probability, exactly when every coordinate does. -/
theorem thm_10_10 {Ω : Type*} [MeasurableSpace Ω] {d : ℕ} (μ : Measure Ω)
    [IsProbabilityMeasure μ] (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (hVn : ∀ n, Measurable (Vn n)) (hV : Measurable V) :
    (VectorConvergesAlmostSurely μ Vn V ↔
      ∀ i : Fin d, ConvergesAlmostSurely μ
        (fun n ω => Vn n ω i) (fun ω => V ω i)) ∧
    (VectorConvergesInProbability μ Vn V ↔
      ∀ i : Fin d, ConvergesInProbability μ
        (fun n ω => Vn n ω i) (fun ω => V ω i)) := by
  constructor
  · constructor
    · rintro ⟨E, hEmeas, hEone, hconv⟩ i
      apply (convergesAlmostSurelyOnEvent_iff μ
        (fun n ω => Vn n ω i) (fun ω => V ω i)).1
      refine ⟨fun n => (measurable_pi_iff.mp (hVn n) i).aestronglyMeasurable,
        (measurable_pi_iff.mp hV i).aestronglyMeasurable, E, hEmeas, ?_, ?_⟩
      · have hfin : μ E ≠ ⊤ := by rw [hEone]; simp
        rw [MeasureTheory.measure_compl hEmeas hfin]
        simp [hEone, MeasureTheory.IsProbabilityMeasure.measure_univ]
      · intro ω hω
        exact (hconv ω hω).apply_nhds i
    · intro hcoord
      exact vectorConvergesAlmostSurely_of_coordinatewise μ Vn V
        (fun i => (hcoord i).2.2)
  · constructor
    · intro hvec i
      refine ⟨fun n => measurable_pi_iff.mp (hVn n) i,
        measurable_pi_iff.mp hV i, ?_⟩
      intro ε hε
      refine tendsto_of_tendsto_of_tendsto_of_le_of_le tendsto_const_nhds
        (hvec ε hε) (fun _ => bot_le) (fun n => ?_)
      exact measure_mono
        (coordinateDeviationEvent_subset_vectorDeviationEvent Vn V n i ε)
    · intro hcoord
      exact vectorConvergesInProbability_of_coordinatewise μ Vn V
        (fun i => (hcoord i).2.2)
