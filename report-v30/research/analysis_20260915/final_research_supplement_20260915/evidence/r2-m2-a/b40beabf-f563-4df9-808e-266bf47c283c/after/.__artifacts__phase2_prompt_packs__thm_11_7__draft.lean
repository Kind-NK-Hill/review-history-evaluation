import Mathlib
import ProbabilityTheory.chapter_05.def_5_10
import ProbabilityTheory.chapter_09.def_9_1
import ProbabilityTheory.chapter_05.thm_5_8
import ProbabilityTheory.chapter_10.thm_10_1
import ProbabilityTheory.chapter_11.thm_11_1
import ProbabilityTheory.chapter_11.thm_11_5

/-
TASK ID: thm_11_7
TYPE: Theorem_with_Proof
SOURCE PLAN: experiment_targets
TASK CONTENT:
\begin{thmbox}{11.7 (4th-moment Strong Law of Large Numbers)}
\end{thmbox}

Suppose Xi ,f o r i\geq 1 , are independent random variables with mean \mu and

E[X4

i ]\leq c< \infty for all i Then Sn

n \to \mu almost surely.

\textit{Proof} Without loss of generality, we assume that \mu= 0 . (We can consider Yi =

Xi -\mu if the mean of Xi is not zero.)

The expectation of S4

n can be expanded as

E[S4

n]= E[(X1 +X 2 +\cdot\cdot\cdot+ Xn)4]

=E

[ n\sum

i=1

X4

i +3

\sum

i/=j

X2

i X2

j +4

\sum

i/=j

XiX3

j

+6

\sum

i,j,k

i,j,kdistinct

XiXj X2

k +

\sum

i,j,k,\ell

i,j,k,\elldistinct

XiXj XkX\ell

]

We analyze the terms one by one. For distinct indices i , j , k , and \ell,we have

E[XiXj XkX\ell]= E[XiXj X2

k]= E[XiX3

j ]= 0,

by the assumption that X1,...,X n are independent. The fourth-power terms are

bounded byE[\sumn

i=1 X4

i ]\leq nc becauseE[X4

i ]\leq c.

Fori/=j , by Cauchy-Schwarz inequality,

E[X2

i X2

j ]\leq

\sqrt

E[X4

i ]E[X4

j ]\leq \sqrt c\cdot c = c.

Hence,

3E

[ \sum

i/=j

X2

i X2

j

]

\leq3 n(n- 1 )c

This givesE[S4

n]\leq nc+ 3 n(n- 1 )c. We now fix any \epsilon> 0,

P

( \vertSn\vert

n >\epsilon

)

=P(S 4

n >n 4\epsilon4)\leq nc+ 3 n(n- 1 )c

n4\epsilon4 \leq 3n2c+ nc - 3 nc

n4\epsilon4 \leq 3c

n2\epsilon4 .

Because

\infty\sum

n=1

P

( \vertSn\vert

n >\epsilon

)

\leq

\infty\sum

n=1

3c

n2\epsilon4 <\infty ,

we can apply the first Borel-Cantelli lemma (Theorem 5.8) to conclude that the

event .{\vertSn\vert/n > \epsilon io. } has probability 0. Therefore, by Theorem 10.1, Sn/n

converges to 0 almost surely. \hfill $\square$

Note that Theorem 11.7 does not assume that the random variables Xi are

identically distributed, but it requires that the 4th moments are uniformly bounded.

We state below a stronger version the strong law that assumes finite mean and

pairwise independence.
-/

-- WRITE FINAL LEAN CODE BELOW


open Filter MeasureTheory ProbabilityTheory Set
open scoped BigOperators ENNReal Topology

noncomputable section

/-- The centered variables used in the source reduction to mean zero. -/
def thm_11_7_center (X : ℕ → Ω → ℝ) (m : ℝ) (i : ℕ) : Ω → ℝ :=
  fun ω => X i ω - m

/-- The partial sum of the first `n` centered variables. -/
def thm_11_7_centeredSum (X : ℕ → Ω → ℝ) (m : ℝ) (n : ℕ) : Ω → ℝ :=
  fun ω => ∑ i ∈ Finset.range n, thm_11_7_center X m i ω

/-- The sample mean, with the harmless value `0` at index zero. -/
def thm_11_7_sampleMean (X : ℕ → Ω → ℝ) (n : ℕ) : Ω → ℝ :=
  fun ω => (∑ i ∈ Finset.range n, X i ω) / (n : ℝ)

private lemma thm_11_7_abs_pow_four (x : ℝ) : |x| ^ 4 = x ^ 4 := by
  rw [← abs_pow, abs_of_nonneg (by positivity : 0 ≤ x ^ 4)]

private lemma thm_11_7_pow_four_add_bound (a b : ℝ) :
    (a + b) ^ 4 ≤ 8 * (a ^ 4 + b ^ 4) := by
  nlinarith [sq_nonneg (a - b), sq_nonneg (a ^ 2 - b ^ 2),
    sq_nonneg (a ^ 2 + b ^ 2 - (a + b) ^ 2 / 2)]

private lemma thm_11_7_integrable_monomial
    {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω} [IsFiniteMeasure P] {f g : Ω → ℝ}
    (hf : MemLp f 4 P) (hg : MemLp g 4 P) {a b : ℕ} (hab : a + b = 4) :
    Integrable (fun ω => f ω ^ a * g ω ^ b) P := by
  have hf4 : Integrable (fun ω => |f ω| ^ 4) P := by
    simpa [Real.norm_eq_abs] using hf.integrable_norm_pow'
  have hg4 : Integrable (fun ω => |g ω| ^ 4) P := by
    simpa [Real.norm_eq_abs] using hg.integrable_norm_pow'
  refine ((hf4.add hg4).const_mul 8).mono'
    ((hf.1.pow a).mul (hg.1.pow b)) ?_
  filter_upwards with ω
  rw [Real.norm_eq_abs, abs_mul, abs_pow, abs_pow]
  calc
    |f ω| ^ a * |g ω| ^ b
        ≤ (|f ω| + |g ω|) ^ a * (|f ω| + |g ω|) ^ b := by
          have hf_le : |f ω| ≤ |f ω| + |g ω| := le_add_of_nonneg_right (abs_nonneg _)
          have hg_le : |g ω| ≤ |f ω| + |g ω| := le_add_of_nonneg_left (abs_nonneg _)
          gcongr
    _ = (|f ω| + |g ω|) ^ 4 := by rw [← pow_add, hab]
    _ ≤ 8 * (|f ω| ^ 4 + |g ω| ^ 4) :=
      thm_11_7_pow_four_add_bound _ _

/-- The raw fourth-moment assumption actually supplies the centered fourth
moment needed in the source proof.  This is proved, not added as a premise. -/
theorem thm_11_7_centered_fourth_moment_bound
    {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    {Z : Ω → ℝ} {m c : ℝ} (hZ : FiniteAbsMoment P Z 4)
    (hmean : P[Z] = m) (hraw : P[fun ω => Z ω ^ 4] ≤ c) :
    P[fun ω => (Z ω - m) ^ 4] ≤ 16 * c := by
  have hZi : Integrable Z P :=
    ((hZ.memLp (by norm_num : 4 ≠ 0)).mono_exponent
      (by norm_num : (1 : ℝ≥0∞) ≤ 4)).integrable (by norm_num)
  have habsi : Integrable (fun ω => |Z ω|) P := hZi.abs
  have hpowi : Integrable (fun ω => |Z ω| ^ 4) P := hZ.2
  have hjensen : (∫ ω, |Z ω| ∂P) ^ 4 ≤ ∫ ω, |Z ω| ^ 4 ∂P := by
    simpa only [Function.comp_apply] using
      (convexOn_pow (𝕜 := ℝ) 4).map_integral_le
        (continuousOn_pow 4) isClosed_Ici
        (Filter.Eventually.of_forall fun ω => abs_nonneg (Z ω)) habsi hpowi
  have hmabs : |m| ≤ ∫ ω, |Z ω| ∂P := by
    rw [← hmean]
    exact abs_integral_le_integral_abs
  have hmean4 : m ^ 4 ≤ c := by
    have hnonneg : 0 ≤ ∫ ω, |Z ω| ∂P := integral_nonneg (fun _ => abs_nonneg _)
    have hm4 : |m| ^ 4 ≤ (∫ ω, |Z ω| ∂P) ^ 4 :=
      pow_le_pow_left₀ (abs_nonneg _) hmabs 4
    have hrawabs : (∫ ω, |Z ω| ^ 4 ∂P) = P[fun ω => Z ω ^ 4] := by
      apply integral_congr_ae
      filter_upwards with ω
      rw [← abs_pow, abs_of_nonneg (by positivity : 0 ≤ Z ω ^ 4)]
    have := hm4.trans (hjensen.trans (hrawabs.trans_le hraw))
    simpa [← abs_pow, abs_of_nonneg (by positivity : 0 ≤ m ^ 4)] using this
  have hcenter : FiniteAbsMoment P (fun ω => Z ω - P[Z]) 4 := hZ.centered (by norm_num)
  have hcenteri : Integrable (fun ω => (Z ω - m) ^ 4) P := by
    have := hcenter.2
    rw [hmean] at this
    exact this.congr (Filter.Eventually.of_forall fun ω => by
      simp only [Function.comp_apply]
      exact thm_11_7_abs_pow_four (Z ω - m))
  have hdom : ∀ ω, (Z ω - m) ^ 4 ≤ 8 * (Z ω ^ 4 + m ^ 4) := by
    intro ω
    have h := thm_11_7_pow_four_add_bound (Z ω) (-m)
    convert h using 1 <;> ring
  have hZ4i : Integrable (fun ω => Z ω ^ 4) P := hpowi.congr
    (Filter.Eventually.of_forall fun ω => thm_11_7_abs_pow_four (Z ω))
  have hdomi : Integrable (fun ω => 8 * (Z ω ^ 4 + m ^ 4)) P :=
    (hZ4i.add (integrable_const (m ^ 4))).const_mul 8
  calc
    P[fun ω => (Z ω - m) ^ 4]
        ≤ P[fun ω => 8 * (Z ω ^ 4 + m ^ 4)] :=
      integral_mono (f := fun ω => (Z ω - m) ^ 4)
        (g := fun ω => 8 * (Z ω ^ 4 + m ^ 4)) hcenteri hdomi hdom
    _ = 8 * (P[fun ω => Z ω ^ 4] + m ^ 4) := by
      rw [integral_const_mul, integral_add hZ4i (integrable_const (m ^ 4)), integral_const]
      simp
    _ ≤ 8 * (c + c) := by gcongr
    _ = 16 * c := by ring

/-- Centering preserves mutual independence. -/
theorem thm_11_7_centered_independent
    {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    {X : ℕ → Ω → ℝ} {m : ℝ} (hX : ∀ i, Measurable (X i))
    (hindep : iIndepFun X P) : iIndepFun (fun i => thm_11_7_center X m i) P := by
  change iIndepFun (fun i ω => X i ω - m) P
  convert hindep.comp (fun _ x => x - m)
    (fun _ => measurable_id.sub measurable_const) using 1 <;> rfl

private theorem thm_11_7_fourth_add_of_indep
    {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω} [IsFiniteMeasure P]
    {S Y : Ω → ℝ} (hSm : Measurable S) (hYm : Measurable Y)
    (hS4 : MemLp S 4 P) (hY4 : MemLp Y 4 P) (hind : IndepFun S Y P)
    (hS0 : P[S] = 0) (hY0 : P[Y] = 0) :
    P[fun ω => (S ω + Y ω) ^ 4] =
      P[fun ω => S ω ^ 4] +
        6 * P[fun ω => S ω ^ 2] * P[fun ω => Y ω ^ 2] +
          P[fun ω => Y ω ^ 4] := by
  have hS4i : Integrable (fun ω => S ω ^ 4) P := hS4.integrable_norm_pow'.congr
    (Filter.Eventually.of_forall fun ω => by
      simpa [Real.norm_eq_abs] using thm_11_7_abs_pow_four (S ω))
  have hY4i : Integrable (fun ω => Y ω ^ 4) P := hY4.integrable_norm_pow'.congr
    (Filter.Eventually.of_forall fun ω => by
      simpa [Real.norm_eq_abs] using thm_11_7_abs_pow_four (Y ω))
  have h31 := thm_11_7_integrable_monomial hS4 hY4 (a := 3) (b := 1) (by norm_num)
  have h22 := thm_11_7_integrable_monomial hS4 hY4 (a := 2) (b := 2) (by norm_num)
  have h13 := thm_11_7_integrable_monomial hS4 hY4 (a := 1) (b := 3) (by norm_num)
  have hi31 : P[fun ω => S ω ^ 3 * Y ω] = 0 := by
    have hi := (hind.comp (φ := fun x : ℝ => x ^ 3) (ψ := fun x : ℝ => x)
      (measurable_id.pow_const 3) measurable_id).integral_mul_eq_mul_integral
      (hSm.pow_const 3).aestronglyMeasurable hYm.aestronglyMeasurable
    simpa [Pi.mul_apply, Function.comp_def, hY0] using hi
  have hi13 : P[fun ω => S ω * Y ω ^ 3] = 0 := by
    have hi := (hind.comp (φ := fun x : ℝ => x) (ψ := fun x : ℝ => x ^ 3)
      measurable_id (measurable_id.pow_const 3)).integral_mul_eq_mul_integral
      hSm.aestronglyMeasurable (hYm.pow_const 3).aestronglyMeasurable
    simpa [Pi.mul_apply, Function.comp_def, hS0] using hi
  have hi22 : P[fun ω => S ω ^ 2 * Y ω ^ 2] =
      P[fun ω => S ω ^ 2] * P[fun ω => Y ω ^ 2] := by
    have hi := (hind.comp (φ := fun x : ℝ => x ^ 2) (ψ := fun x : ℝ => x ^ 2)
      (measurable_id.pow_const 2) (measurable_id.pow_const 2)).integral_mul_eq_mul_integral
      (hSm.pow_const 2).aestronglyMeasurable (hYm.pow_const 2).aestronglyMeasurable
    simpa [Pi.mul_apply, Function.comp_def] using hi
  have hexpand : (fun ω => (S ω + Y ω) ^ 4) = fun ω =>
      S ω ^ 4 + 4 * (S ω ^ 3 * Y ω) + 6 * (S ω ^ 2 * Y ω ^ 2) +
        4 * (S ω * Y ω ^ 3) + Y ω ^ 4 := by
    funext ω
    ring
  have h31' : Integrable (fun ω => 4 * (S ω ^ 3 * Y ω)) P := by
    simpa using h31.const_mul 4
  have h22' : Integrable (fun ω => 6 * (S ω ^ 2 * Y ω ^ 2)) P := h22.const_mul 6
  have h13' : Integrable (fun ω => 4 * (S ω * Y ω ^ 3)) P := by
    simpa using h13.const_mul 4
  have hA : Integrable (fun ω => S ω ^ 4 + 4 * (S ω ^ 3 * Y ω)) P := hS4i.add h31'
  have hB : Integrable (fun ω => S ω ^ 4 + 4 * (S ω ^ 3 * Y ω) +
      6 * (S ω ^ 2 * Y ω ^ 2)) P := hA.add h22'
  have hC : Integrable (fun ω => S ω ^ 4 + 4 * (S ω ^ 3 * Y ω) +
      6 * (S ω ^ 2 * Y ω ^ 2) + 4 * (S ω * Y ω ^ 3)) P := hB.add h13'
  have e1 := integral_add hS4i h31'
  have e2 := integral_add hA h22'
  have e3 := integral_add hB h13'
  have e4 := integral_add hC hY4i
  rw [hexpand, e4, e3, e2, e1]
  simp only [integral_const_mul, hi31, hi13, hi22]
  ring

private theorem thm_11_7_second_add_of_indep
    {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω} [IsFiniteMeasure P]
    {S Y : Ω → ℝ} (hSm : Measurable S) (hYm : Measurable Y)
    (hS2 : MemLp S 2 P) (hY2 : MemLp Y 2 P) (hind : IndepFun S Y P)
    (hS0 : P[S] = 0) (hY0 : P[Y] = 0) :
    P[fun ω => (S ω + Y ω) ^ 2] =
      P[fun ω => S ω ^ 2] + P[fun ω => Y ω ^ 2] := by
  have hSi := hS2.integrable_sq
  have hYi := hY2.integrable_sq
  have hSY := hS2.integrable_mul hY2
  have hi : P[fun ω => S ω * Y ω] = 0 := by
    have := hind.integral_mul_eq_mul_integral hSm.aestronglyMeasurable hYm.aestronglyMeasurable
    simpa [Pi.mul_apply, hS0, hY0] using this
  have hexpand : (fun ω => (S ω + Y ω) ^ 2) =
      fun ω => S ω ^ 2 + 2 * (S ω * Y ω) + Y ω ^ 2 := by
    funext ω; ring
  have hSY' : Integrable (fun ω => 2 * (S ω * Y ω)) P := by
    simpa [Pi.mul_apply] using hSY.const_mul 2
  have hA : Integrable (fun ω => S ω ^ 2 + 2 * (S ω * Y ω)) P := hSi.add hSY'
  have e1 := integral_add hSi hSY'
  have e2 := integral_add hA hYi
  rw [hexpand, e2, e1]
  simp [integral_const_mul, hi]

/-- Finite-sum fourth-moment estimate obtained from the fourth-power expansion;
odd mixed terms disappear by zero means and independence. -/
theorem thm_11_7_centeredSum_fourth_bound
    {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    (Y : ℕ → Ω → ℝ) (M B : ℝ)
    (hYm : ∀ i, Measurable (Y i)) (hY4 : ∀ i, MemLp (Y i) 4 P)
    (hindep : iIndepFun Y P) (hmean : ∀ i, P[Y i] = 0)
    (hfourth : ∀ i, P[fun ω => Y i ω ^ 4] ≤ M)
    (hsecond : ∀ i, P[fun ω => Y i ω ^ 2] ≤ B)
    (hM : 0 ≤ M) (hB : 0 ≤ B) (n : ℕ) :
    P[fun ω => (∑ i ∈ Finset.range n, Y i ω) ^ 4] ≤
      (n : ℝ) * M + 3 * (n : ℝ) ^ 2 * B ^ 2 := by
  have hsum_mem : ∀ k, MemLp (fun ω => ∑ i ∈ Finset.range k, Y i ω) 4 P := fun k =>
    memLp_finset_sum (Finset.range k) (fun i _ => hY4 i)
  have hsum_meas : ∀ k, Measurable (fun ω => ∑ i ∈ Finset.range k, Y i ω) := fun k =>
    Finset.measurable_sum _ (fun i _ => hYm i)
  have hsum_mean : ∀ k, P[fun ω => ∑ i ∈ Finset.range k, Y i ω] = 0 := by
    intro k
    rw [integral_finset_sum]
    · simp [hmean]
    · intro i hi
      exact ((hY4 i).mono_exponent (by norm_num : (1 : ℝ≥0∞) ≤ 4)).integrable
        (by norm_num)
  have hsecond_sum : ∀ k : ℕ,
      P[fun ω => (∑ i ∈ Finset.range k, Y i ω) ^ 2] ≤ (k : ℝ) * B := by
    intro k
    induction k with
    | zero => simp
    | succ k ih =>
        have hind : (fun ω => ∑ i ∈ Finset.range k, Y i ω) ⟂ᵢ[P] Y k := by
          convert hindep.indepFun_finsetSum_of_notMem hYm (s := Finset.range k)
            (i := k) (by simp) using 1 <;> ext ω <;> simp
        have heq := thm_11_7_second_add_of_indep (P := P)
          (hsum_meas k) (hYm k)
          ((hsum_mem k).mono_exponent (by norm_num : (2 : ℝ≥0∞) ≤ 4))
          ((hY4 k).mono_exponent (by norm_num : (2 : ℝ≥0∞) ≤ 4)) hind
          (hsum_mean k) (hmean k)
        simp_rw [Finset.sum_range_succ]
        rw [heq]
        have hkcast : ((k + 1 : ℕ) : ℝ) = (k : ℝ) + 1 := by norm_num
        rw [hkcast]
        linarith [hsecond k]
  induction n with
  | zero => simp
  | succ n ih =>
      have hind : (fun ω => ∑ i ∈ Finset.range n, Y i ω) ⟂ᵢ[P] Y n := by
        convert hindep.indepFun_finsetSum_of_notMem hYm (s := Finset.range n)
          (i := n) (by simp) using 1 <;> ext ω <;> simp
      have heq := thm_11_7_fourth_add_of_indep (P := P)
        (hsum_meas n) (hYm n) (hsum_mem n) (hY4 n) hind (hsum_mean n) (hmean n)
      simp_rw [Finset.sum_range_succ]
      rw [heq]
      have hn : 0 ≤ (n : ℝ) := Nat.cast_nonneg n
      have hs2nonneg : 0 ≤ P[fun ω => (∑ i ∈ Finset.range n, Y i ω) ^ 2] :=
        integral_nonneg (fun _ => sq_nonneg _)
      have hy2nonneg : 0 ≤ P[fun ω => Y n ω ^ 2] := integral_nonneg (fun _ => sq_nonneg _)
      have hprod : P[fun ω => (∑ i ∈ Finset.range n, Y i ω) ^ 2] *
          P[fun ω => Y n ω ^ 2] ≤ ((n : ℝ) * B) * B :=
        mul_le_mul (hsecond_sum n) (hsecond n) hy2nonneg (mul_nonneg hn hB)
      have hncast : ((n + 1 : ℕ) : ℝ) = (n : ℝ) + 1 := by norm_num
      rw [hncast]
      nlinarith [hfourth n, hprod, sq_nonneg B]

/-- Fourth-moment Markov bound for a positive-length centered average. -/
theorem thm_11_7_deviation_bound
    {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    (Y : ℕ → Ω → ℝ) (M B : ℝ)
    (hYm : ∀ i, Measurable (Y i)) (hY4 : ∀ i, MemLp (Y i) 4 P)
    (hindep : iIndepFun Y P) (hmean : ∀ i, P[Y i] = 0)
    (hfourth : ∀ i, P[fun ω => Y i ω ^ 4] ≤ M)
    (hsecond : ∀ i, P[fun ω => Y i ω ^ 2] ≤ B)
    (hM : 0 ≤ M) (hB : 0 ≤ B) {N : ℕ} (hN : 0 < N)
    {ε : ℝ} (hε : 0 < ε) :
    P {ω | |(∑ i ∈ Finset.range N, Y i ω) / (N : ℝ)| > ε} ≤
      ENNReal.ofReal ((M + 3 * B ^ 2) / ((N : ℝ) ^ 2 * ε ^ 4)) := by
  let S : Ω → ℝ := fun ω => ∑ i ∈ Finset.range N, Y i ω
  let t : ℝ := (N : ℝ) ^ 4 * ε ^ 4
  let E : Set Ω := {ω | t ≤ S ω ^ 4}
  have hNm : Measurable S := Finset.measurable_sum _ (fun i _ => hYm i)
  have hN4 : MemLp S 4 P := memLp_finset_sum _ (fun i _ => hY4 i)
  have hS4i : Integrable (fun ω => S ω ^ 4) P := hN4.integrable_norm_pow'.congr
    (Filter.Eventually.of_forall fun ω => by
      simpa [S, Real.norm_eq_abs] using thm_11_7_abs_pow_four (S ω))
  have ht : 0 < t := mul_pos (pow_pos (Nat.cast_pos.2 hN) 4) (pow_pos hε 4)
  have hsubset : {ω | |S ω / (N : ℝ)| > ε} ⊆ E := by
    intro ω hω
    dsimp [E, t] at hω ⊢
    have hNc : 0 < (N : ℝ) := Nat.cast_pos.2 hN
    have habs : |S ω| > (N : ℝ) * ε := by
      rw [abs_div, abs_of_pos hNc] at hω
      exact (lt_div_iff₀' hNc).mp hω
    have hp : ((N : ℝ) * ε) ^ 4 ≤ |S ω| ^ 4 :=
      (pow_lt_pow_left₀ habs (mul_nonneg hNc.le hε.le)
        (by norm_num : 4 ≠ 0)).le
    simpa [thm_11_7_abs_pow_four, mul_pow] using hp
  have hmarkov : P.real E ≤ P[fun ω => S ω ^ 4] / t := by
    apply (le_div_iff₀' ht).2
    simpa [E] using mul_meas_ge_le_integral_of_nonneg
      (μ := P) (f := fun ω => S ω ^ 4)
      (Filter.Eventually.of_forall fun _ => by positivity) hS4i t
  have hmoment := thm_11_7_centeredSum_fourth_bound P Y M B hYm hY4 hindep
    hmean hfourth hsecond hM hB N
  have hNge : (1 : ℝ) ≤ N := by exact_mod_cast hN
  have hrough : P[fun ω => S ω ^ 4] ≤ (N : ℝ) ^ 2 * (M + 3 * B ^ 2) := by
    dsimp [S]
    calc
      _ ≤ (N : ℝ) * M + 3 * (N : ℝ) ^ 2 * B ^ 2 := hmoment
      _ ≤ (N : ℝ) ^ 2 * (M + 3 * B ^ 2) := by
        nlinarith [mul_nonneg (Nat.cast_nonneg N) hM]
  have hreal : P.real E ≤ (M + 3 * B ^ 2) / ((N : ℝ) ^ 2 * ε ^ 4) := by
    calc
      P.real E ≤ P[fun ω => S ω ^ 4] / t := hmarkov
      _ ≤ ((N : ℝ) ^ 2 * (M + 3 * B ^ 2)) / t :=
        div_le_div_of_nonneg_right hrough ht.le
      _ = (M + 3 * B ^ 2) / ((N : ℝ) ^ 2 * ε ^ 4) := by
        dsimp [t]
        field_simp [ne_of_gt (Nat.cast_pos.2 hN), ne_of_gt hε]
  have hrhs : 0 ≤ (M + 3 * B ^ 2) / ((N : ℝ) ^ 2 * ε ^ 4) := by positivity
  apply (measure_mono hsubset).trans
  apply (ENNReal.toReal_le_toReal (measure_ne_top P E) ENNReal.ofReal_ne_top).mp
  rw [ENNReal.toReal_ofReal hrhs]
  simpa [measureReal_def] using hreal

/-- **Theorem 11.7 (fourth-moment strong law).**  The variables are mutually
independent and have a common finite mean, but are not assumed identically
distributed.  A uniform bound on their raw fourth moments implies almost-sure
convergence of the sample means. -/
theorem thm_11_7
    {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    (X : ℕ → Ω → ℝ) (m c : ℝ)
    (hX : ∀ i, FiniteAbsMoment P (X i) 4)
    (hindep : iIndepFun X P) (hmean : ∀ i, P[X i] = m)
    (hraw : ∀ i, P[fun ω => X i ω ^ 4] ≤ c) :
    ConvergesAlmostSurely P (thm_11_7_sampleMean X) (fun _ => m) := by
  let Y : ℕ → Ω → ℝ := fun i => thm_11_7_center X m i
  let M : ℝ := 16 * c
  let B : ℝ := 1 + M
  have hXm : ∀ i, Measurable (X i) := fun i => (hX i).1
  have hc : 0 ≤ c := by
    have h0 : 0 ≤ P[fun ω => X 0 ω ^ 4] := integral_nonneg (fun _ => by positivity)
    exact h0.trans (hraw 0)
  have hM : 0 ≤ M := by dsimp [M]; positivity
  have hB : 0 ≤ B := by dsimp [B]; positivity
  have hYm : ∀ i, Measurable (Y i) := fun i => (hXm i).sub measurable_const
  have hYfinite : ∀ i, FiniteAbsMoment P (Y i) 4 := by
    intro i
    have hi := (hX i).centered (by norm_num : 1 ≤ 4)
    rw [hmean i] at hi
    exact hi
  have hY4 : ∀ i, MemLp (Y i) 4 P := fun i => (hYfinite i).memLp (by norm_num)
  have hYindep : iIndepFun Y P := by
    exact thm_11_7_centered_independent hXm hindep
  have hYmean : ∀ i, P[Y i] = 0 := by
    intro i
    have hXi : Integrable (X i) P :=
      (((hX i).memLp (by norm_num : 4 ≠ 0)).mono_exponent
        (by norm_num : (1 : ℝ≥0∞) ≤ 4)).integrable (by norm_num)
    dsimp [Y, thm_11_7_center]
    rw [integral_sub hXi (integrable_const m), hmean i, integral_const]
    simp
  have hYfourth : ∀ i, P[fun ω => Y i ω ^ 4] ≤ M := by
    intro i
    exact thm_11_7_centered_fourth_moment_bound P (hX i) (hmean i) (hraw i)
  have hYsecond : ∀ i, P[fun ω => Y i ω ^ 2] ≤ B := by
    intro i
    have h2 : Integrable (fun ω => Y i ω ^ 2) P :=
      ((hY4 i).mono_exponent (by norm_num : (2 : ℝ≥0∞) ≤ 4)).integrable_sq
    have h4 : Integrable (fun ω => Y i ω ^ 4) P := (hY4 i).integrable_norm_pow'.congr
      (Filter.Eventually.of_forall fun ω => by
        simpa [Real.norm_eq_abs] using thm_11_7_abs_pow_four (Y i ω))
    have hmono : (∫ ω, Y i ω ^ 2 ∂P) ≤ ∫ ω, (1 : ℝ) + Y i ω ^ 4 ∂P := by
      apply integral_mono (f := fun ω => Y i ω ^ 2)
        (g := fun ω => (1 : ℝ) + Y i ω ^ 4) h2 ((integrable_const 1).add h4)
      intro ω
      nlinarith [sq_nonneg (Y i ω ^ 2 - 1)]
    have heq : (∫ ω, (1 : ℝ) + Y i ω ^ 4 ∂P) =
        1 + ∫ ω, Y i ω ^ 4 ∂P := by
      have e := integral_add (integrable_const (μ := P) (1 : ℝ)) h4
      simpa using e
    show (∫ ω, Y i ω ^ 2 ∂P) ≤ B
    calc
      (∫ ω, Y i ω ^ 2 ∂P) ≤ ∫ ω, (1 : ℝ) + Y i ω ^ 4 ∂P := hmono
      _ = 1 + ∫ ω, Y i ω ^ 4 ∂P := heq
      _ ≤ 1 + M := by linarith [hYfourth i]
      _ = B := rfl
  have hsample_meas : ∀ n, AEStronglyMeasurable (thm_11_7_sampleMean X n) P := by
    intro n
    exact ((Finset.measurable_sum _ (fun i _ => hXm i)).div_const (n : ℝ)).aestronglyMeasurable
  refine (thm_10_1 P (thm_11_7_sampleMean X) (fun _ => m)).2
    ⟨hsample_meas, measurable_const.aestronglyMeasurable, ?_⟩
  intro ε hε
  let A : ℕ → Set Ω := fun n => almostSureDeviationEvent
    (thm_11_7_sampleMean X) (fun _ => m) n ε
  let K : ℝ := M + 3 * B ^ 2
  have hK : 0 ≤ K := by dsimp [K]; positivity
  have htail : ∀ n : ℕ, P (A (n + 1)) ≤
      ENNReal.ofReal (K / (((n : ℝ) + 1) ^ 2 * ε ^ 4)) := by
    intro n
    have hb := thm_11_7_deviation_bound P Y M B hYm hY4 hYindep hYmean
      hYfourth hYsecond hM hB (N := n + 1) (by omega) hε
    have hevent : A (n + 1) =
        {ω | |(∑ i ∈ Finset.range (n + 1), Y i ω) / ((n + 1 : ℕ) : ℝ)| > ε} := by
      ext ω
      simp only [A, almostSureDeviationEvent, thm_11_7_sampleMean, Y,
        thm_11_7_center, Set.mem_setOf_eq]
      rw [Finset.sum_sub_distrib]
      simp [Finset.sum_const, Nat.cast_add, Nat.cast_one]
      field_simp
    rw [hevent]
    simpa [K, Nat.cast_add, Nat.cast_one] using hb
  have hp : Summable (fun n : ℕ => 1 / (n : ℝ) ^ 2) :=
    Real.summable_one_div_nat_pow.mpr (by norm_num)
  have hpshift : Summable (fun n : ℕ => 1 / (((n : ℝ) + 1) ^ 2)) := by
    simpa [Nat.cast_add, Nat.cast_one] using (summable_nat_add_iff 1).2 hp
  have hreal : Summable (fun n : ℕ => K / (((n : ℝ) + 1) ^ 2 * ε ^ 4)) := by
    have := hpshift.mul_left (K / ε ^ 4)
    simpa [div_eq_mul_inv, mul_assoc, mul_left_comm, mul_comm] using this
  have hseries : (∑' n, P (A n)) ≠ ∞ := by
    have hbound : ∀ n, P (A n) ≤ ENNReal.ofReal
        (if n = 0 then 1 else K / ((n : ℝ) ^ 2 * ε ^ 4)) := by
      intro n
      cases n with
      | zero =>
          simp only [if_pos]
          calc
            P (A 0) ≤ P Set.univ := measure_mono (Set.subset_univ _)
            _ = 1 := measure_univ
            _ = ENNReal.ofReal 1 := by simp
      | succ n => simpa [Nat.cast_add, Nat.cast_one] using htail n
    have hreal' : Summable (fun n : ℕ => if n = 0 then 1 else
        K / ((n : ℝ) ^ 2 * ε ^ 4)) := by
      apply (summable_nat_add_iff 1).mp
      simpa [Nat.cast_add, Nat.cast_one] using hreal
    exact ne_top_of_le_ne_top hreal'.tsum_ofReal_ne_top
      (ENNReal.tsum_le_tsum hbound)
  have hbc : P (limsup A atTop) = 0 := thm_5_8 P A hseries
  simpa [deviationInfinitelyOften, A] using hbc
