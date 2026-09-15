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
open scoped ENNReal

/-- Theorem 11.5 (weak law of large numbers, L2 version).  With natural-number
indexing, the `n`-th average below contains the first `n + 1` variables. -/
theorem thm_11_5 {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (X : ℕ → Ω → ℝ) (μ σ2 : ℝ)
    (hXm : ∀ i, Measurable (X i)) (hX : ∀ i, MemLp (X i) 2 P)
    (hmean : ∀ i, P[X i] = μ)
    (hvar : ∀ i, ProbabilityTheory.variance (X i) P = σ2)
    (huncorr : ∀ i j, i ≠ j → Uncorrelated P (X i) (X j)) :
    ConvergesInProbability P
      (fun n ω => (∑ i : Fin (n + 1), X i ω) / (n + 1 : ℝ))
      (fun _ => μ) := by
  let A : ℕ → Ω → ℝ :=
    fun n ω => (∑ i : Fin (n + 1), X i ω) / (n + 1 : ℝ)
  have hA_meas : ∀ n, Measurable (A n) := by
    intro n
    dsimp [A]
    fun_prop
  have hA_memLp : ∀ n, MemLp (A n) 2 P := by
    intro n
    have hsum : MemLp (fun ω => ∑ i : Fin (n + 1), X i ω) 2 P := by
      simpa using memLp_finsetSum Finset.univ
        (f := fun i : Fin (n + 1) => X i) (fun i _ => hX i)
    simpa [A, div_eq_mul_inv] using hsum.mul_const ((n + 1 : ℝ)⁻¹)
  have hA_mean : ∀ n, P[A n] = μ := by
    intro n
    have hn : (n + 1 : ℝ) ≠ 0 := by positivity
    rw [show A n = fun ω => (∑ i : Fin (n + 1), X i ω) / (n + 1 : ℝ) by rfl]
    rw [integral_div]
    rw [integral_finsetSum Finset.univ (f := fun i : Fin (n + 1) => X i)
      (fun i _ => (hX i).integrable (by norm_num))]
    simp [hmean, hn]
  have hA_var : ∀ n, ProbabilityTheory.variance (A n) P = σ2 / (n + 1 : ℝ) := by
    intro n
    have hn : (n + 1 : ℝ) ≠ 0 := by positivity
    have hsum := thm_11_4 P (fun i : Fin (n + 1) => X i)
      (fun i => hX i) (fun i j hij => huncorr i j (Fin.val_ne_of_ne hij))
    calc
      ProbabilityTheory.variance (A n) P =
          ((n + 1 : ℝ)⁻¹) ^ 2 *
            ProbabilityTheory.variance (fun ω => ∑ i : Fin (n + 1), X i ω) P := by
        simpa [A, div_eq_mul_inv, Pi.smul_apply, smul_eq_mul, mul_comm] using
          (ProbabilityTheory.variance_const_mul ((n + 1 : ℝ)⁻¹)
            (fun ω => ∑ i : Fin (n + 1), X i ω) P)
      _ = ((n + 1 : ℝ)⁻¹) ^ 2 * ∑ i : Fin (n + 1),
            ProbabilityTheory.variance (X i) P := by rw [hsum]
      _ = σ2 / (n + 1 : ℝ) := by
        simp only [hvar, Finset.sum_const, nsmul_eq_mul, Finset.card_univ,
          Fintype.card_fin, Nat.cast_add, Nat.cast_one]
        field_simp
  refine ⟨?_, measurable_const, ?_⟩
  · simpa [A] using hA_meas
  · intro ε hε
    rw [← ENNReal.tendsto_toReal_zero_iff (fun n => measure_ne_top P _)]
    apply squeeze_zero
    · intro n
      exact measureReal_nonneg
    · intro n
      have hlocal_var :
          _root_.variance P (A n) (FiniteAbsMoment.of_memLp (hA_meas n) (hA_memLp n)) =
            ProbabilityTheory.variance (A n) P := by
        rw [_root_.variance, rthCentralMoment]
        exact ProbabilityTheory.centralMoment_two_eq_variance (hA_memLp n).aemeasurable
      have hcheb := thm_11_2 P (A n) (hA_meas n) (hA_memLp n) hε
      have hsubset :
          deviationEvent A (fun _ => μ) n ε ⊆
            {ω | ε ≤ |A n ω - P[A n]|} := by
        intro ω hω
        rw [hA_mean n]
        exact le_of_lt (by simpa [deviationEvent] using hω)
      calc
        P.real (deviationEvent A (fun _ => μ) n ε)
            ≤ P.real {ω | ε ≤ |A n ω - P[A n]|} :=
              measureReal_mono hsubset
        _ ≤ _root_.variance P (A n)
              (FiniteAbsMoment.of_memLp (hA_meas n) (hA_memLp n)) / ε ^ 2 := hcheb
        _ = (σ2 / (n + 1 : ℝ)) / ε ^ 2 := by rw [hlocal_var, hA_var]
    · have htop : Tendsto (fun n : ℕ => (n + 1 : ℝ)) atTop atTop := by
        convert (tendsto_natCast_atTop_atTop (R := ℝ)).comp
          (tendsto_add_atTop_nat 1) using 1
        funext n
        simp [Function.comp_apply, Nat.cast_add, Nat.cast_one]
      have hdiv : Tendsto (fun n : ℕ => σ2 / (n + 1 : ℝ)) atTop (nhds 0) :=
        tendsto_const_nhds.div_atTop htop
      simpa using hdiv.div_const (ε ^ 2)
