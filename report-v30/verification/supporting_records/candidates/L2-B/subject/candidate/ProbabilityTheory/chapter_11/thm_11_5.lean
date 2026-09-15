import ProbabilityTheory.chapter_10.def_10_2
import ProbabilityTheory.chapter_11.thm_11_2
import ProbabilityTheory.chapter_11.thm_11_4

open Filter MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace Theorem11_5

private lemma measurable_range_sum {Ω : Type*} [MeasurableSpace Ω]
    (X : ℕ → Ω → ℝ) (hX : ∀ i, Measurable (X i)) (n : ℕ) :
    Measurable (fun ω => ∑ i ∈ Finset.range n, X i ω) := by
  induction n with
  | zero => simp
  | succ n ih =>
      simpa [Finset.sum_range_succ] using ih.add (hX n)

private lemma memLp_range_sum {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} (X : ℕ → Ω → ℝ) (hX : ∀ i, MemLp (X i) 2 P) (n : ℕ) :
    MemLp (fun ω => ∑ i ∈ Finset.range n, X i ω) 2 P := by
  induction n with
  | zero => simpa using (MemLp.zero : MemLp (fun _ : Ω => (0 : ℝ)) 2 P)
  | succ n ih =>
      convert ih.add (hX n) using 1
      ext ω
      simp [Finset.sum_range_succ, add_comm]

/-- **Theorem 11.5 (weak law of large numbers, L2 version).**
Pairwise uncorrelated variables with a common mean and finite common variance
have sample averages converging in probability to that mean. -/
theorem thm_11_5 {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P]
    (X : ℕ → Ω → ℝ) (μ σ2 : ℝ)
    (hXm : ∀ i, Measurable (X i))
    (hX : ∀ i, MemLp (X i) 2 P)
    (hmean : ∀ i, P[X i] = μ)
    (hvar : ∀ i,
      _root_.variance P (X i) (FiniteAbsMoment.of_memLp (hXm i) (hX i)) = σ2)
    (huncorr : ∀ i j, i ≠ j → Uncorrelated P (X i) (X j)) :
    ConvergesInProbability P
      (fun n ω => (∑ i ∈ Finset.range n, X i ω) / (n : ℝ))
      (fun _ => μ) := by
  let S : ℕ → Ω → ℝ := fun n ω => ∑ i ∈ Finset.range n, X i ω
  let A : ℕ → Ω → ℝ := fun n ω => S n ω / (n : ℝ)
  have hSm : ∀ n, Measurable (S n) := fun n => measurable_range_sum X hXm n
  have hSLp : ∀ n, MemLp (S n) 2 P := fun n => memLp_range_sum X hX n
  have hAm : ∀ n, Measurable (A n) := fun n => (hSm n).div_const _
  change ConvergesInProbability P A (fun _ => μ)
  rw [ConvergesInProbability]
  refine ⟨hAm, measurable_const, ?_⟩
  intro ε hε
  have htail : ∀ n, 0 < n →
      P.real (deviationEvent A (fun _ => μ) n ε) ≤
        σ2 / ((n : ℝ) * ε ^ 2) := by
    intro n hn
    classical
    let I := {i // i ∈ Finset.range n}
    let T : Ω → ℝ := fun ω => ∑ i : I, X i.1 ω
    have hTm : Measurable T :=
      Theorem11_4.measurable_finset_sum Finset.univ (fun i : I => X i.1)
        (by intro i hi; exact hXm i.1)
    have hTLp : MemLp T 2 P :=
      Theorem11_4.memLp_finset_sum Finset.univ (fun i : I => X i.1)
        (by intro i hi; exact hX i.1)
    have hTS : ∀ ω, T ω = S n ω := by
      intro ω
      dsimp [T, S]
      exact (Finset.sum_subtype (Finset.range n) (fun i => Iff.rfl) (fun i => X i ω)).symm
    have hET : P[T] = (n : ℝ) * μ := by
      dsimp [T]
      rw [integral_finset_sum Finset.univ
        (fun i _ => (hX i.1).integrable (by norm_num))]
      simp_rw [hmean]
      simp [I]
    have hvT :
        _root_.variance P T (FiniteAbsMoment.of_memLp hTm hTLp) =
          (n : ℝ) * σ2 := by
      have hv := thm_11_4 P (fun i : I => X i.1)
        (fun i => hXm i.1) (fun i => hX i.1)
        (fun i j hij => huncorr i.1 j.1 (fun h => hij (Subtype.ext h)))
      rw [hv]
      simp_rw [hvar]
      simp [I]
    have hnR : 0 < (n : ℝ) := by exact_mod_cast hn
    have hnε : 0 < (n : ℝ) * ε := mul_pos hnR hε
    have hcheb := thm_11_2 P T hTm hTLp hnε
    have hsub :
        deviationEvent A (fun _ => μ) n ε ⊆
          {ω | (n : ℝ) * ε ≤ |T ω - P[T]|} := by
      intro ω hω
      change ε < |S n ω / (n : ℝ) - μ| at hω
      rw [← hTS ω] at hω
      rw [hET]
      have hid : T ω / (n : ℝ) - μ =
          (T ω - (n : ℝ) * μ) / (n : ℝ) := by
        field_simp
      rw [hid, abs_div, abs_of_pos hnR] at hω
      change (n : ℝ) * ε ≤ |T ω - (n : ℝ) * μ|
      simpa [mul_comm] using le_of_lt ((lt_div_iff₀ hnR).mp hω)
    calc
      P.real (deviationEvent A (fun _ => μ) n ε)
          ≤ P.real {ω | (n : ℝ) * ε ≤ |T ω - P[T]|} :=
        measureReal_mono hsub
      _ ≤ _root_.variance P T (FiniteAbsMoment.of_memLp hTm hTLp) /
              ((n : ℝ) * ε) ^ 2 := hcheb
      _ = σ2 / ((n : ℝ) * ε ^ 2) := by
        rw [hvT]
        field_simp
  have hupper :
      Tendsto (fun n : ℕ => σ2 / ((n : ℝ) * ε ^ 2)) atTop (nhds 0) := by
    have hbase : Tendsto (fun n : ℕ => σ2 / (n : ℝ)) atTop (nhds 0) :=
      tendsto_const_nhds.div_atTop tendsto_natCast_atTop_atTop
    convert hbase.div_const (ε ^ 2) using 1
    · funext n
      ring
    · simp
  have hreal :
      Tendsto (fun n => P.real (deviationEvent A (fun _ => μ) n ε))
        atTop (nhds 0) := by
    apply squeeze_zero'
    · exact Filter.Eventually.of_forall (fun n => measureReal_nonneg)
    · filter_upwards [eventually_atTop.2 ⟨1, fun n hn => hn⟩] with n hn
      exact htail n (Nat.zero_lt_of_lt hn)
    · exact hupper
  apply (ENNReal.tendsto_toReal_iff
    (fun n => measure_ne_top P (deviationEvent A (fun _ => μ) n ε))
    (by simp)).mp
  simpa [measureReal_def] using hreal

end Theorem11_5

export Theorem11_5 (thm_11_5)
