import Mathlib
import ProbabilityTheory.chapter_07.def_7_3
import ProbabilityTheory.chapter_09.def_9_1
import ProbabilityTheory.chapter_10.def_10_2
import ProbabilityTheory.chapter_11.thm_11_2
import ProbabilityTheory.chapter_11.thm_11_4

/-
TASK ID: thm_11_5
TYPE: Theorem_with_Proof
SOURCE PLAN: experiment_targets
TASK CONTENT:
\begin{thmbox}{11.5 (Weak Law of Large Numbers (L2 Version))}
\end{thmbox}

Let .(Xi)\infty

i=1 be a sequence of pairwise uncorrelated random variables with

common mean E[Xi]= \mu and variance Va r(Xi) = \sigma2 for all i. Then

Sn/n

P

-\to \mu.

\textit{Proof} The proof is an application of Chebyshev inequality (Theorem 11.2).

Fix any \epsilon> 0 and integer n. Using the fact that Sn/n is an average of pairwise

uncorrelated random variables with common mean \mu,we have

P

(\vert\vertSn

n -\mu

\vert\vert >\epsilon

)

=P

(\vert\vertSn -n\mu

\vert\vert >n \epsilon

)

\leq Va r(Sn)

n2\epsilon2 = 1

n2\epsilon2

n\sum

i=1

Va r(Xi).

The last equality follows from Theorem 11.4.

Using Theorem 11.4, we know that .

\sumn

i=1 Va r(Xi)= n\sigma 2. Therefore, we have

P

( \vert\vert\vertSn

n -\mu

\vert\vert\vert >\epsilon

)

\leq n\sigma2

n2\epsilon2 = \sigma2

n\epsilon2 .

Asn\to\infty , the right-hand side approaches zero, which implies thatSn/n converges

in probability to \mu. This completes the proof. \hfill $\square$

The assumption of finite second moment can be relaxed to finite mean, but at the

cost of strengthening the uncorrelated assumption to independence.
-/

-- WRITE FINAL LEAN CODE BELOW

open Filter MeasureTheory ProbabilityTheory

/-- The weak law of large numbers for a sequence of pairwise uncorrelated
real-valued random variables with common mean and common finite variance. -/
theorem thm_11_5 {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω)
    [IsProbabilityMeasure P] (X : ℕ → Ω → ℝ) (μ σ2 : ℝ)
    (hX : ∀ i, FiniteAbsMoment P (X i) 2)
    (hmean : ∀ i, ∫ ω, X i ω ∂P = μ)
    (hvar : ∀ i, ProbabilityTheory.variance (X i) P = σ2)
    (huncorrelated : ∀ i j, i ≠ j → Uncorrelated P (X i) (X j)) :
    ConvergesInProbability P
      (fun n ω => (∑ i ∈ Finset.range (n + 1), X i ω) / (n + 1 : ℝ))
      (fun _ => μ) := by
  let A : ℕ → Ω → ℝ :=
    fun n ω => (∑ i ∈ Finset.range (n + 1), X i ω) / (n + 1 : ℝ)
  have hmem : ∀ i, MemLp (X i) 2 P := fun i => (hX i).memLp (by norm_num)
  have hAmeas : ∀ n, Measurable (A n) := by
    intro n
    exact (Finset.measurable_sum (Finset.range (n + 1))
      (fun i _ => (hX i).measurable)).div_const _
  have hAmem : ∀ n, MemLp (A n) 2 P := by
    intro n
    have hs : MemLp (∑ i ∈ Finset.range (n + 1), X i) 2 P :=
      memLp_finsetSum' _ (fun i _ => hmem i)
    simpa [A, div_eq_inv_mul] using hs.const_mul ((n + 1 : ℝ)⁻¹)
  have hAmean : ∀ n, ∫ ω, A n ω ∂P = μ := by
    intro n
    rw [show A n = fun ω => (∑ i ∈ Finset.range (n + 1), X i ω) /
      (n + 1 : ℝ) by rfl]
    rw [integral_div, integral_finsetSum]
    · simp_rw [hmean]
      simp only [Finset.sum_const, Finset.card_range, nsmul_eq_mul]
      field_simp
      push_cast
      ring
    · exact fun i _ => (hmem i).integrable one_le_two
  have hAvar : ∀ n, ProbabilityTheory.variance (A n) P = σ2 / (n + 1 : ℝ) := by
    intro n
    have hsum :=
      thm_11_4 (μ := P) (Finset.range (n + 1)) X
        (fun i _ => hX i) (fun i _ j _ hij => huncorrelated i j hij)
    calc
      ProbabilityTheory.variance (A n) P =
          ProbabilityTheory.variance
            (fun ω => (n + 1 : ℝ)⁻¹ * (∑ i ∈ Finset.range (n + 1), X i) ω) P := by
              congr 1
              funext ω
              simp [A, div_eq_inv_mul]
      _ = ((n + 1 : ℝ)⁻¹) ^ 2 *
          ProbabilityTheory.variance (∑ i ∈ Finset.range (n + 1), X i) P := by
            rw [ProbabilityTheory.variance_const_mul]
      _ = ((n + 1 : ℝ)⁻¹) ^ 2 *
          ∑ i ∈ Finset.range (n + 1), ProbabilityTheory.variance (X i) P := by
            rw [hsum]
      _ = σ2 / (n + 1 : ℝ) := by
            simp_rw [hvar]
            simp only [Finset.sum_const, Finset.card_range, nsmul_eq_mul]
            have hn : (n + 1 : ℝ) ≠ 0 := by positivity
            field_simp
            push_cast
            ring
  refine ⟨?_, measurable_const, ?_⟩
  · simpa [A] using hAmeas
  · intro ε hε
    have hreal :
        Tendsto (fun n => P.real (deviationEvent A (fun _ => μ) n ε))
          atTop (nhds 0) := by
      apply squeeze_zero' (Filter.Eventually.of_forall fun _ => measureReal_nonneg)
        (Filter.Eventually.of_forall ?_)
        ((tendsto_const_div_atTop_nhds_zero_nat (σ2 / ε ^ 2)).comp
          (Filter.tendsto_add_atTop_nat 1))
      intro n
      have hcheb := thm_11_2 P (A n) (hAmeas n) (hAmem n) hε
      have hsubset :
          deviationEvent A (fun _ => μ) n ε ⊆
            {ω | ε ≤ |A n ω - P[A n]|} := by
        intro ω hω
        simp only [deviationEvent, Set.mem_setOf_eq, Pi.one_apply] at hω ⊢
        rw [hAmean n]
        exact hω.le
      calc
        P.real (deviationEvent A (fun _ => μ) n ε)
            ≤ P.real {ω | ε ≤ |A n ω - P[A n]|} :=
              measureReal_mono hsubset
        _ ≤ _root_.variance P (A n)
              (FiniteAbsMoment.of_memLp (hAmeas n) (hAmem n)) / ε ^ 2 := hcheb
        _ = ProbabilityTheory.variance (A n) P / ε ^ 2 := by
              rw [_root_.variance, rthCentralMoment,
                ProbabilityTheory.centralMoment_two_eq_variance (hAmem n).aemeasurable]
        _ = (σ2 / ε ^ 2) / (n + 1 : ℝ) := by
              rw [hAvar]
              ring
        _ = ((fun k : ℕ => (σ2 / ε ^ 2) / (k : ℝ)) ∘
              fun a => a + 1) n := by
              simp
    simpa only [measureReal_def,
      ENNReal.tendsto_toReal_zero_iff (fun _ => measure_ne_top P _)] using hreal
