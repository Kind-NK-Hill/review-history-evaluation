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

lemma vectorEuclideanNorm_le_of_coordinate_le {d : ℕ} {v : Fin d → ℝ} {ε : ℝ}
    (hε : 0 ≤ ε) (hcoord : ∀ i : Fin d, |v i| ≤ ε / Real.sqrt d) :
    vectorEuclideanNorm v ≤ ε := by
  by_cases hd : d = 0
  · subst d
    simpa [vectorEuclideanNorm] using hε
  · have hdpos : 0 < (d : ℝ) := by exact_mod_cast (Nat.pos_of_ne_zero hd)
    have hsqrtpos : 0 < Real.sqrt (d : ℝ) := Real.sqrt_pos.2 hdpos
    rw [vectorEuclideanNorm, Real.sqrt_le_iff]
    refine ⟨hε, ?_⟩
    calc
      ∑ i : Fin d, (v i) ^ 2
          ≤ ∑ _i : Fin d, (ε / Real.sqrt (d : ℝ)) ^ 2 := by
              apply Finset.sum_le_sum
              intro i hi
              simpa [sq_abs] using
                ((sq_le_sq₀ (abs_nonneg (v i)) (by positivity)).2 (hcoord i))
      _ = (d : ℝ) * (ε / Real.sqrt (d : ℝ)) ^ 2 := by simp
      _ = ε ^ 2 := by
        field_simp
        nlinarith [Real.sq_sqrt (le_of_lt hdpos)]

theorem thm_10_10 {Ω : Type*} [MeasurableSpace Ω] {d : ℕ} (μ : Measure Ω)
    [IsProbabilityMeasure μ] (Vn : ℕ → Ω → Fin d → ℝ) (V : Ω → Fin d → ℝ)
    (hVn : ∀ n : ℕ, Measurable (Vn n)) (hV : Measurable V) :
    (VectorConvergesAlmostSurely μ Vn V ↔
      ∀ i : Fin d, ConvergesAlmostSurely μ (fun n ω => Vn n ω i) (fun ω => V ω i)) ∧
    (VectorConvergesInProbability μ Vn V ↔
      ∀ i : Fin d, ConvergesInProbability μ (fun n ω => Vn n ω i) (fun ω => V ω i)) := by
  constructor
  · constructor
    · rintro ⟨E, hEmeas, hEone, hEconv⟩
      have hEcompl : μ Eᶜ = 0 := by
        have hfin : μ E ≠ ⊤ := by rw [hEone]; simp
        rw [MeasureTheory.measure_compl hEmeas hfin]
        simp [hEone, MeasureTheory.IsProbabilityMeasure.measure_univ]
      have hae : ∀ᵐ ω ∂μ, Tendsto (fun n => Vn n ω) atTop (nhds (V ω)) := by
        rw [ae_iff]
        apply MeasureTheory.measure_mono_null _ hEcompl
        intro ω hbad
        change ω ∉ E
        intro hω
        exact hbad (hEconv ω hω)
      intro i
      refine ⟨fun n => ((coordinatewiseMeasurable_iff_vectorMeasurable (Vn n)).1 (hVn n) i).aestronglyMeasurable,
        ((coordinatewiseMeasurable_iff_vectorMeasurable V).1 hV i).aestronglyMeasurable, ?_⟩
      filter_upwards [hae] with ω hω
      exact tendsto_pi_nhds.1 hω i
    · intro hcoord
      have haeCoord :
          ∀ᵐ ω ∂μ, ∀ i : Fin d,
            Tendsto (fun n => Vn n ω i) atTop (nhds (V ω i)) :=
        MeasureTheory.ae_all_iff.2 (fun i => (hcoord i).2.2)
      have haeVec : ∀ᵐ ω ∂μ, Tendsto (fun n => Vn n ω) atTop (nhds (V ω)) := by
        filter_upwards [haeCoord] with ω hω
        exact tendsto_pi_nhds.2 hω
      have hbad : μ {ω : Ω | ¬ Tendsto (fun n => Vn n ω) atTop (nhds (V ω))} = 0 :=
        ae_iff.1 haeVec
      obtain ⟨N, hbadN, hNmeas, hNnull⟩ := exists_measurable_superset_of_null hbad
      refine ⟨Nᶜ, hNmeas.compl, ?_, ?_⟩
      · have hfin : μ N ≠ ⊤ := by rw [hNnull]; simp
        rw [MeasureTheory.measure_compl hNmeas hfin]
        simp [hNnull, MeasureTheory.IsProbabilityMeasure.measure_univ]
      · intro ω hω
        by_contra hωbad
        exact hω (hbadN hωbad)
  · constructor
    · intro hvec i
      refine ⟨fun n => (coordinatewiseMeasurable_iff_vectorMeasurable (Vn n)).1 (hVn n) i,
        (coordinatewiseMeasurable_iff_vectorMeasurable V).1 hV i, ?_⟩
      intro ε hε
      have hsubset : ∀ n,
          deviationEvent (fun n ω => Vn n ω i) (fun ω => V ω i) n ε ⊆
            vectorDeviationEvent Vn V n ε := by
        intro n ω hω
        change |Vn n ω i - V ω i| > ε at hω
        change vectorEuclideanNorm (Vn n ω - V ω) > ε
        have hle : |Vn n ω i - V ω i| ≤ vectorEuclideanNorm (Vn n ω - V ω) := by
          rw [vectorEuclideanNorm, ← Real.sqrt_sq_eq_abs (Vn n ω i - V ω i)]
          apply Real.sqrt_le_sqrt
          apply Finset.single_le_sum (fun j _ => sq_nonneg ((Vn n ω - V ω) j))
          simp
        exact lt_of_lt_of_le hω hle
      apply tendsto_of_tendsto_of_tendsto_of_le_of_le
        (show Tendsto (fun _n : ℕ => (0 : ENNReal)) atTop (nhds 0) from tendsto_const_nhds)
        (hvec ε hε)
      · intro n
        exact bot_le
      · intro n
        exact MeasureTheory.measure_mono (hsubset n)
    · intro hcoord
      intro ε hε
      by_cases hd : d = 0
      · subst d
        have hevent : ∀ n, vectorDeviationEvent Vn V n ε = ∅ := by
          intro n
          ext ω
          simp [vectorDeviationEvent, vectorEuclideanNorm, not_lt_of_ge (le_of_lt hε)]
        simpa [hevent] using
          (show Tendsto (fun _n : ℕ => (0 : ENNReal)) atTop (nhds 0) from tendsto_const_nhds)
      · let δ : ℝ := ε / Real.sqrt (d : ℝ)
        have hdpos : 0 < (d : ℝ) := by exact_mod_cast (Nat.pos_of_ne_zero hd)
        have hδ : 0 < δ := div_pos hε (Real.sqrt_pos.2 hdpos)
        let A : Fin d → ℕ → Set Ω := fun i n =>
          deviationEvent (fun n ω => Vn n ω i) (fun ω => V ω i) n δ
        have hAmeas : ∀ i n, MeasurableSet (A i n) := by
          intro i n
          exact measurableSet_lt measurable_const (((hcoord i).1 n).sub (hcoord i).2.1 |>.abs)
        have hsubset : ∀ n, vectorDeviationEvent Vn V n ε ⊆ ⋃ i : Fin d, A i n := by
          intro n ω hω
          by_contra hnot
          have hall : ∀ i : Fin d, |(Vn n ω - V ω) i| ≤ δ := by
            intro i
            simp only [Set.mem_iUnion, not_exists] at hnot
            have hi := hnot i
            change ¬ |Vn n ω i - V ω i| > δ at hi
            simpa using le_of_not_gt hi
          have hnorm := vectorEuclideanNorm_le_of_coordinate_le (le_of_lt hε) hall
          exact (not_lt_of_ge hnorm) hω
        have hsum : Tendsto (fun n => ∑ i : Fin d, μ (A i n)) atTop (nhds 0) := by
          simpa using tendsto_finset_sum (Finset.univ : Finset (Fin d))
            (fun i _hi => (hcoord i).2.2 δ hδ)
        apply tendsto_of_tendsto_of_tendsto_of_le_of_le
          (show Tendsto (fun _n : ℕ => (0 : ENNReal)) atTop (nhds 0) from tendsto_const_nhds)
          hsum
        · intro n
          exact bot_le
        · intro n
          calc
            μ (vectorDeviationEvent Vn V n ε) ≤ μ (⋃ i : Fin d, A i n) :=
              MeasureTheory.measure_mono (hsubset n)
            _ ≤ ∑ i : Fin d, μ (A i n) := by
              simpa using MeasureTheory.measure_biUnion_finset_le
                (Finset.univ : Finset (Fin d)) (fun i => A i n)
