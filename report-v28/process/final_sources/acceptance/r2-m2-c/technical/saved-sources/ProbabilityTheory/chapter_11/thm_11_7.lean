/-
Copyright (c) 2026 Probability Theory Formalization contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Probability Theory Formalization contributors
-/

import Mathlib
import ProbabilityTheory.chapter_05.thm_5_8
import ProbabilityTheory.chapter_10.thm_10_1
import ProbabilityTheory.chapter_10.thm_10_3

/-! # The fourth-moment strong law of large numbers

This file formalizes Theorem 11.7 directly from uniformly bounded raw fourth moments. -/

open Filter MeasureTheory ProbabilityTheory Set
open scoped BigOperators ENNReal Topology

/-- The centered partial sum of the first `n` variables. -/
noncomputable def thm_11_7_centeredSum {Ω : Type*}
    (X : ℕ → Ω → ℝ) (m : ℝ) (n : ℕ) : Ω → ℝ :=
  fun ω => ∑ i ∈ Finset.range n, (X i ω - m)

/-- The sample mean at index `n`; it averages the first `n + 1` variables. -/
noncomputable def thm_11_7_sampleMean {Ω : Type*}
    (X : ℕ → Ω → ℝ) (n : ℕ) : Ω → ℝ :=
  fun ω => (∑ i ∈ Finset.range (n + 1), X i ω) / (n + 1 : ℝ)

/-- Centering preserves mutual independence. -/
theorem thm_11_7_centered_iIndepFun {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} {X : ℕ → Ω → ℝ} (m : ℝ)
    (h_indep : iIndepFun X P) :
    iIndepFun (fun i ω => X i ω - m) P := by
  have h := h_indep.comp (fun _ : ℕ => fun x : ℝ => x - m)
    (fun _ : ℕ => measurable_id.sub_const m)
  simpa [Function.comp_def] using h

/-- The original (uncentered) fourth-moment assumption gives the required
centered fourth moment bound `8 * (c + m^4)`. -/
theorem thm_11_7_centered_fourth_moment {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] {X : Ω → ℝ} (m c : ℝ)
    (hX : MemLp X 4 P) (hraw : (∫ ω, X ω ^ 4 ∂P) ≤ c) :
    MemLp (fun ω => X ω - m) 4 P ∧
      (∫ ω, (X ω - m) ^ 4 ∂P) ≤ 8 * (c + m ^ 4) := by
  have hcenter : MemLp (fun ω => X ω - m) 4 P := by
    change MemLp (X - fun _ : Ω => m) 4 P
    exact hX.sub (memLp_const m)
  refine ⟨hcenter, ?_⟩
  have hX4 : Integrable (fun ω => X ω ^ 4) P := by
    refine (hX.integrable_norm_pow' (p := 4)).congr ?_
    filter_upwards with ω
    rw [Real.norm_eq_abs, ← abs_pow, abs_of_nonneg (by positivity : 0 ≤ X ω ^ 4)]
  have hdom : ∀ ω, (X ω - m) ^ 4 ≤ 8 * (X ω ^ 4 + m ^ 4) := by
    intro ω
    have ha : |X ω - m| ≤ |X ω| + |m| := abs_sub _ _
    have hp := pow_le_pow_left₀ (abs_nonneg _) ha 4
    calc
      (X ω - m) ^ 4 = |X ω - m| ^ 4 := by
        rw [← abs_pow, abs_of_nonneg (Even.pow_nonneg (by decide) (X ω - m))]
      _ ≤ (|X ω| + |m|) ^ 4 := hp
      _ ≤ 8 * (|X ω| ^ 4 + |m| ^ 4) := by
        nlinarith [sq_nonneg (|X ω| - |m|), sq_nonneg (|X ω| ^ 2 - |m| ^ 2)]
      _ = 8 * (X ω ^ 4 + m ^ 4) := by
        rw [← abs_pow, ← abs_pow, abs_of_nonneg (Even.pow_nonneg (by decide) (X ω)),
          abs_of_nonneg (Even.pow_nonneg (by decide) m)]
  have hrhs : Integrable (fun ω => 8 * (X ω ^ 4 + m ^ 4)) P := by
    fun_prop
  calc
    (∫ ω, (X ω - m) ^ 4 ∂P) ≤ ∫ ω, 8 * (X ω ^ 4 + m ^ 4) ∂P := by
      have hleft : Integrable (fun ω => (X ω - m) ^ 4) P := by
        refine (hcenter.integrable_norm_pow' (p := 4)).congr ?_
        filter_upwards with ω
        rw [Real.norm_eq_abs, ← abs_pow,
          abs_of_nonneg (by positivity : 0 ≤ (X ω - m) ^ 4)]
      apply integral_mono hleft hrhs
      intro ω
      exact hdom ω
    _ = 8 * ((∫ ω, X ω ^ 4 ∂P) + m ^ 4) := by
      rw [integral_const_mul, integral_add hX4 (integrable_const _), integral_const]
      simp
    _ ≤ 8 * (c + m ^ 4) := by linarith

private lemma thm_11_7_abs_pow_three_mul_le (x y : ℝ) :
    |x ^ 3 * y| ≤ |x| ^ 4 + |y| ^ 4 := by
  rw [abs_mul, abs_pow]
  by_cases h : |x| ≤ |y|
  · calc
      |x| ^ 3 * |y| ≤ |y| ^ 3 * |y| := by gcongr
      _ ≤ |x| ^ 4 + |y| ^ 4 := by nlinarith [pow_nonneg (abs_nonneg x) 4]
  · have hyx : |y| ≤ |x| := le_of_not_ge h
    calc
      |x| ^ 3 * |y| ≤ |x| ^ 3 * |x| := by gcongr
      _ ≤ |x| ^ 4 + |y| ^ 4 := by nlinarith [pow_nonneg (abs_nonneg y) 4]

private lemma thm_11_7_abs_mul_pow_three_le (x y : ℝ) :
    |x * y ^ 3| ≤ |x| ^ 4 + |y| ^ 4 := by
  simpa [mul_comm, add_comm] using thm_11_7_abs_pow_three_mul_le y x

private lemma thm_11_7_abs_sq_mul_sq_le (x y : ℝ) :
    |x ^ 2 * y ^ 2| ≤ |x| ^ 4 + |y| ^ 4 := by
  rw [abs_mul, abs_pow, abs_pow]
  by_cases h : |x| ≤ |y|
  · calc
      |x| ^ 2 * |y| ^ 2 ≤ |y| ^ 2 * |y| ^ 2 := by gcongr
      _ ≤ |x| ^ 4 + |y| ^ 4 := by nlinarith [pow_nonneg (abs_nonneg x) 4]
  · have hyx : |y| ≤ |x| := le_of_not_ge h
    calc
      |x| ^ 2 * |y| ^ 2 ≤ |x| ^ 2 * |x| ^ 2 := by gcongr
      _ ≤ |x| ^ 4 + |y| ^ 4 := by nlinarith [pow_nonneg (abs_nonneg y) 4]

private theorem thm_11_7_fourth_integral_add
    {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    {S Y : Ω → ℝ} (hSm : Measurable S) (hYm : Measurable Y)
    (hS : MemLp S 4 P) (hY : MemLp Y 4 P) (hSY : IndepFun S Y P)
    (hSmean : P[S] = 0) (hYmean : P[Y] = 0) :
    (∫ ω, (S ω + Y ω) ^ 4 ∂P) =
      (∫ ω, S ω ^ 4 ∂P) +
        6 * (∫ ω, S ω ^ 2 ∂P) * (∫ ω, Y ω ^ 2 ∂P) +
          (∫ ω, Y ω ^ 4 ∂P) := by
  have hS4 : Integrable (fun ω => S ω ^ 4) P := by
    refine (hS.integrable_norm_pow' (p := 4)).congr ?_
    filter_upwards with ω
    rw [Real.norm_eq_abs, ← abs_pow,
      abs_of_nonneg (Even.pow_nonneg (by decide) (S ω))]
  have hY4 : Integrable (fun ω => Y ω ^ 4) P := by
    refine (hY.integrable_norm_pow' (p := 4)).congr ?_
    filter_upwards with ω
    rw [Real.norm_eq_abs, ← abs_pow,
      abs_of_nonneg (Even.pow_nonneg (by decide) (Y ω))]
  have hdom : Integrable (fun ω => |S ω| ^ 4 + |Y ω| ^ 4) P := by
    have hSa : Integrable (fun ω => |S ω| ^ 4) P := by
      simpa [Real.norm_eq_abs] using hS.integrable_norm_pow' (p := 4)
    have hYa : Integrable (fun ω => |Y ω| ^ 4) P := by
      simpa [Real.norm_eq_abs] using hY.integrable_norm_pow' (p := 4)
    exact hSa.add hYa
  have hi31 : Integrable (fun ω => S ω ^ 3 * Y ω) P :=
    hdom.mono (by fun_prop) (Filter.Eventually.of_forall fun ω => by
      have hn : 0 ≤ |S ω| ^ 4 + |Y ω| ^ 4 :=
        add_nonneg (pow_nonneg (abs_nonneg _) 4) (pow_nonneg (abs_nonneg _) 4)
      rw [Real.norm_eq_abs, Real.norm_eq_abs, abs_of_nonneg hn]
      exact
        thm_11_7_abs_pow_three_mul_le (S ω) (Y ω))
  have hi13 : Integrable (fun ω => S ω * Y ω ^ 3) P :=
    hdom.mono (by fun_prop) (Filter.Eventually.of_forall fun ω => by
      have hn : 0 ≤ |S ω| ^ 4 + |Y ω| ^ 4 :=
        add_nonneg (pow_nonneg (abs_nonneg _) 4) (pow_nonneg (abs_nonneg _) 4)
      rw [Real.norm_eq_abs, Real.norm_eq_abs, abs_of_nonneg hn]
      exact
        thm_11_7_abs_mul_pow_three_le (S ω) (Y ω))
  have hi22 : Integrable (fun ω => S ω ^ 2 * Y ω ^ 2) P :=
    hdom.mono (by fun_prop) (Filter.Eventually.of_forall fun ω => by
      have hn : 0 ≤ |S ω| ^ 4 + |Y ω| ^ 4 :=
        add_nonneg (pow_nonneg (abs_nonneg _) 4) (pow_nonneg (abs_nonneg _) 4)
      rw [Real.norm_eq_abs, Real.norm_eq_abs, abs_of_nonneg hn]
      exact
        thm_11_7_abs_sq_mul_sq_le (S ω) (Y ω))
  have hS3Y : (∫ ω, S ω ^ 3 * Y ω ∂P) = 0 := by
    have hi := (hSY.comp (measurable_id.pow_const 3) measurable_id).integral_fun_mul_eq_mul_integral
      (hSm.pow_const 3).aestronglyMeasurable hYm.aestronglyMeasurable
    simpa [Function.comp_def, hYmean] using hi
  have hSY3 : (∫ ω, S ω * Y ω ^ 3 ∂P) = 0 := by
    have hi := (hSY.comp measurable_id (measurable_id.pow_const 3)).integral_fun_mul_eq_mul_integral
      hSm.aestronglyMeasurable (hYm.pow_const 3).aestronglyMeasurable
    simpa [Function.comp_def, hSmean] using hi
  have hS2Y2 : (∫ ω, S ω ^ 2 * Y ω ^ 2 ∂P) =
      (∫ ω, S ω ^ 2 ∂P) * (∫ ω, Y ω ^ 2 ∂P) := by
    have hi := (hSY.comp (measurable_id.pow_const 2) (measurable_id.pow_const 2)).integral_fun_mul_eq_mul_integral
      (hSm.pow_const 2).aestronglyMeasurable (hYm.pow_const 2).aestronglyMeasurable
    simpa [Function.comp_def] using hi
  have hexpand : (fun ω => (S ω + Y ω) ^ 4) =
      fun ω => S ω ^ 4 + 4 * (S ω ^ 3 * Y ω) +
        6 * (S ω ^ 2 * Y ω ^ 2) + 4 * (S ω * Y ω ^ 3) + Y ω ^ 4 := by
    funext ω
    ring
  rw [hexpand]
  have hA1 : Integrable (fun ω => S ω ^ 4 + 4 * (S ω ^ 3 * Y ω)) P := by
    have hc : Integrable (fun ω => 4 * (S ω ^ 3 * Y ω)) P := hi31.const_mul 4
    exact hS4.add hc
  have hA2 : Integrable (fun ω => S ω ^ 4 + 4 * (S ω ^ 3 * Y ω) +
      6 * (S ω ^ 2 * Y ω ^ 2)) P := by
    have hc : Integrable (fun ω => 6 * (S ω ^ 2 * Y ω ^ 2)) P := hi22.const_mul 6
    exact hA1.add hc
  have hA3 : Integrable (fun ω => S ω ^ 4 + 4 * (S ω ^ 3 * Y ω) +
      6 * (S ω ^ 2 * Y ω ^ 2) + 4 * (S ω * Y ω ^ 3)) P := by
    have hc : Integrable (fun ω => 4 * (S ω * Y ω ^ 3)) P := hi13.const_mul 4
    exact hA2.add hc
  rw [integral_add hA3 hY4, integral_add hA2 (hi13.const_mul 4),
    integral_add hA1 (hi22.const_mul 6), integral_add hS4 (hi31.const_mul 4),
    integral_const_mul, integral_const_mul, integral_const_mul,
    hS3Y, hSY3, hS2Y2]
  ring

private theorem thm_11_7_second_integral_add
    {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    {S Y : Ω → ℝ} (hSm : Measurable S) (hYm : Measurable Y)
    (hS : MemLp S 4 P) (hY : MemLp Y 4 P) (hSY : IndepFun S Y P)
    (hSmean : P[S] = 0) (hYmean : P[Y] = 0) :
    (∫ ω, (S ω + Y ω) ^ 2 ∂P) =
      (∫ ω, S ω ^ 2 ∂P) + (∫ ω, Y ω ^ 2 ∂P) := by
  have hS2 : MemLp S 2 P := hS.mono_exponent (by norm_num)
  have hY2 : MemLp Y 2 P := hY.mono_exponent (by norm_num)
  have hcross : Integrable (fun ω => S ω * Y ω) P := by
    change Integrable (S * Y) P
    exact hS2.integrable_mul hY2
  have hcross0 : (∫ ω, S ω * Y ω ∂P) = 0 := by
    have hi := hSY.integral_fun_mul_eq_mul_integral
      hSm.aestronglyMeasurable hYm.aestronglyMeasurable
    simpa [hSmean, hYmean] using hi
  have hSsq : Integrable (fun ω => S ω ^ 2) P := by
    convert hS2.integrable_mul hS2 using 1
    ext ω
    simp [pow_two, Pi.mul_apply]
  have hYsq : Integrable (fun ω => Y ω ^ 2) P := by
    convert hY2.integrable_mul hY2 using 1
    ext ω
    simp [pow_two, Pi.mul_apply]
  have hexpand : (fun ω => (S ω + Y ω) ^ 2) =
      fun ω => S ω ^ 2 + 2 * (S ω * Y ω) + Y ω ^ 2 := by
    funext ω
    ring
  rw [hexpand]
  have hA : Integrable (fun ω => S ω ^ 2 + 2 * (S ω * Y ω)) P := by
    have hc : Integrable (fun ω => 2 * (S ω * Y ω)) P := hcross.const_mul 2
    exact hSsq.add hc
  rw [integral_add hA hYsq, integral_add hSsq (hcross.const_mul 2),
    integral_const_mul, hcross0]
  ring

private theorem thm_11_7_centeredSum_measurable {Ω : Type*} [MeasurableSpace Ω]
    (Y : ℕ → Ω → ℝ) (hYm : ∀ i, Measurable (Y i)) (n : ℕ) :
    Measurable (thm_11_7_centeredSum Y 0 n) := by
  unfold thm_11_7_centeredSum
  exact Finset.measurable_sum _ fun i _ => (hYm i).sub_const 0

private theorem thm_11_7_centeredSum_memLp {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (Y : ℕ → Ω → ℝ) (hY : ∀ i, MemLp (Y i) 4 P) (n : ℕ) :
    MemLp (thm_11_7_centeredSum Y 0 n) 4 P := by
  unfold thm_11_7_centeredSum
  convert memLp_finsetSum (Finset.range n) (fun i _ => hY i) using 1
  ext ω
  simp

private theorem thm_11_7_centeredSum_mean_zero {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (Y : ℕ → Ω → ℝ)
    (hY : ∀ i, MemLp (Y i) 4 P) (hmean : ∀ i, P[Y i] = 0) (n : ℕ) :
    P[thm_11_7_centeredSum Y 0 n] = 0 := by
  unfold thm_11_7_centeredSum
  rw [integral_finsetSum]
  · simp [hmean]
  · intro i hi
    refine ((hY i).integrable (by norm_num)).congr ?_
    filter_upwards with ω
    simp

private theorem thm_11_7_second_moment_le {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] {Y : Ω → ℝ}
    (hY : MemLp Y 4 P) {C : ℝ} (h4 : (∫ ω, Y ω ^ 4 ∂P) ≤ C) :
    (∫ ω, Y ω ^ 2 ∂P) ≤ (C + 1) / 2 := by
  have hY2 : Integrable (fun ω => Y ω ^ 2) P := by
    have h2 : MemLp Y 2 P := hY.mono_exponent (by norm_num)
    convert h2.integrable_mul h2 using 1
    ext ω
    simp [pow_two, Pi.mul_apply]
  have hY4 : Integrable (fun ω => Y ω ^ 4) P := by
    refine (hY.integrable_norm_pow' (p := 4)).congr ?_
    filter_upwards with ω
    rw [Real.norm_eq_abs, ← abs_pow,
      abs_of_nonneg (Even.pow_nonneg (by decide) (Y ω))]
  have hpoint : ∀ ω, Y ω ^ 2 ≤ (Y ω ^ 4 + 1) / 2 := by
    intro ω
    nlinarith [sq_nonneg (Y ω ^ 2 - 1)]
  calc
    (∫ ω, Y ω ^ 2 ∂P) ≤ ∫ ω, (Y ω ^ 4 + 1) / 2 ∂P := by
      apply integral_mono hY2
      · exact (hY4.add (integrable_const 1)).div_const 2
      · exact hpoint
    _ = ((∫ ω, Y ω ^ 4 ∂P) + 1) / 2 := by
      rw [integral_div, integral_add hY4 (integrable_const 1), integral_const]
      simp
    _ ≤ (C + 1) / 2 := by linarith

/-- Finite-sum moment estimate.  Its proof is a simultaneous induction.  At
each successor the preceding sum is independent of the new variable; the
displayed second- and fourth-power expansion lemmas above remove both odd
terms and factor the `S²Y²` term. -/
theorem thm_11_7_centered_partial_sum_moments
    {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    (Y : ℕ → Ω → ℝ) (C : ℝ)
    (hYm : ∀ i, Measurable (Y i)) (hY : ∀ i, MemLp (Y i) 4 P)
    (h_indep : iIndepFun Y P) (hmean : ∀ i, P[Y i] = 0)
    (hC : 0 ≤ C) (h4 : ∀ i, (∫ ω, Y i ω ^ 4 ∂P) ≤ C) :
    ∀ n : ℕ,
      (∫ ω, thm_11_7_centeredSum Y 0 n ω ^ 2 ∂P) ≤
          (n : ℝ) * ((C + 1) / 2) ∧
      (∫ ω, thm_11_7_centeredSum Y 0 n ω ^ 4 ∂P) ≤
          (C + 3 * ((C + 1) / 2) ^ 2) * (n : ℝ) ^ 2 := by
  let D : ℝ := (C + 1) / 2
  let K : ℝ := C + 3 * D ^ 2
  have hD : 0 ≤ D := by dsimp [D]; linarith
  have hK_C : C ≤ K := by dsimp [K]; nlinarith [sq_nonneg D]
  have hK_D : 3 * D ^ 2 ≤ K := by dsimp [K]; linarith
  intro n
  induction n with
  | zero =>
      simp [thm_11_7_centeredSum]
  | succ n ih =>
      let S : Ω → ℝ := thm_11_7_centeredSum Y 0 n
      let Z : Ω → ℝ := Y n
      have hSm : Measurable S := thm_11_7_centeredSum_measurable Y hYm n
      have hZm : Measurable Z := hYm n
      have hS4 : MemLp S 4 P := thm_11_7_centeredSum_memLp P Y hY n
      have hZ4 : MemLp Z 4 P := hY n
      have hSZ : IndepFun S Z P := by
        have hi := h_indep.indepFun_finsetSum_of_notMem hYm
          (by simp : n ∉ Finset.range n)
        have heq : S = ∑ j ∈ Finset.range n, Y j := by
          funext ω
          simp [S, thm_11_7_centeredSum]
        rw [heq]
        exact hi
      have hSmean : P[S] = 0 := thm_11_7_centeredSum_mean_zero P Y hY hmean n
      have hZmean : P[Z] = 0 := hmean n
      have hZ2 : (∫ ω, Z ω ^ 2 ∂P) ≤ D := by
        exact thm_11_7_second_moment_le P hZ4 (h4 n)
      have hZ2_nonneg : 0 ≤ ∫ ω, Z ω ^ 2 ∂P := integral_nonneg fun _ => sq_nonneg _
      have hS2_nonneg : 0 ≤ ∫ ω, S ω ^ 2 ∂P := integral_nonneg fun _ => sq_nonneg _
      have hsecond_eq :
          (∫ ω, thm_11_7_centeredSum Y 0 (n + 1) ω ^ 2 ∂P) =
            (∫ ω, S ω ^ 2 ∂P) + ∫ ω, Z ω ^ 2 ∂P := by
        have h := thm_11_7_second_integral_add P hSm hZm hS4 hZ4 hSZ hSmean hZmean
        simpa [S, Z, thm_11_7_centeredSum, Finset.sum_range_succ] using h
      have hfourth_eq :
          (∫ ω, thm_11_7_centeredSum Y 0 (n + 1) ω ^ 4 ∂P) =
            (∫ ω, S ω ^ 4 ∂P) +
              6 * (∫ ω, S ω ^ 2 ∂P) * (∫ ω, Z ω ^ 2 ∂P) +
                (∫ ω, Z ω ^ 4 ∂P) := by
        have h := thm_11_7_fourth_integral_add P hSm hZm hS4 hZ4 hSZ hSmean hZmean
        simpa [S, Z, thm_11_7_centeredSum, Finset.sum_range_succ] using h
      constructor
      · rw [hsecond_eq]
        change _ ≤ ((n + 1 : ℕ) : ℝ) * D
        have hi2 := ih.1
        change (∫ ω, S ω ^ 2 ∂P) ≤ (n : ℝ) * D at hi2
        norm_num [Nat.cast_add, Nat.cast_one]
        linarith
      · rw [hfourth_eq]
        change _ ≤ K * ((n + 1 : ℕ) : ℝ) ^ 2
        have hi2 := ih.1
        have hi4 := ih.2
        change (∫ ω, S ω ^ 2 ∂P) ≤ (n : ℝ) * D at hi2
        change (∫ ω, S ω ^ 4 ∂P) ≤ K * (n : ℝ) ^ 2 at hi4
        have hmix :
            (∫ ω, S ω ^ 2 ∂P) * (∫ ω, Z ω ^ 2 ∂P) ≤
              (n : ℝ) * D ^ 2 := by
          calc
            _ ≤ ((n : ℝ) * D) * D := mul_le_mul hi2 hZ2 hZ2_nonneg (mul_nonneg (Nat.cast_nonneg _) hD)
            _ = (n : ℝ) * D ^ 2 := by ring
        have hZ4le := h4 n
        change (∫ ω, Z ω ^ 4 ∂P) ≤ C at hZ4le
        norm_num [Nat.cast_add, Nat.cast_one]
        have hn : (0 : ℝ) ≤ n := Nat.cast_nonneg n
        have hscale : (n : ℝ) * (3 * D ^ 2) ≤ (n : ℝ) * K :=
          mul_le_mul_of_nonneg_left hK_D hn
        have h6 : 6 * ((∫ ω, S ω ^ 2 ∂P) * (∫ ω, Z ω ^ 2 ∂P)) ≤
            2 * (n : ℝ) * K := by nlinarith
        nlinarith

/-- Centered average of the first `n + 1` terms. -/
noncomputable def thm_11_7_centeredAverage {Ω : Type*}
    (Y : ℕ → Ω → ℝ) (n : ℕ) : Ω → ℝ :=
  fun ω => thm_11_7_centeredSum Y 0 (n + 1) ω / (n + 1 : ℝ)

private theorem thm_11_7_centeredAverage_measurable {Ω : Type*} [MeasurableSpace Ω]
    (Y : ℕ → Ω → ℝ) (hYm : ∀ i, Measurable (Y i)) (n : ℕ) :
    Measurable (thm_11_7_centeredAverage Y n) := by
  exact (thm_11_7_centeredSum_measurable Y hYm (n + 1)).div_const _

/-- Fourth-moment Markov bound for every member of the full sequence of
centered averages. -/
theorem thm_11_7_centered_tail_bound
    {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    (Y : ℕ → Ω → ℝ) (C : ℝ)
    (hYm : ∀ i, Measurable (Y i)) (hY : ∀ i, MemLp (Y i) 4 P)
    (h_indep : iIndepFun Y P) (hmean : ∀ i, P[Y i] = 0)
    (hC : 0 ≤ C) (h4 : ∀ i, (∫ ω, Y i ω ^ 4 ∂P) ≤ C)
    {ε : ℝ} (hε : 0 < ε) (n : ℕ) :
    P (almostSureDeviationEvent (fun n => thm_11_7_centeredAverage Y n)
        (fun _ => 0) n ε) ≤
      ENNReal.ofReal
        ((C + 3 * ((C + 1) / 2) ^ 2) / (ε ^ 4 * (n + 1 : ℝ) ^ 2)) := by
  let S : Ω → ℝ := thm_11_7_centeredSum Y 0 (n + 1)
  let K : ℝ := C + 3 * ((C + 1) / 2) ^ 2
  let N : ℝ := n + 1
  have hN : 0 < N := by dsimp [N]; positivity
  have hK : 0 ≤ K := by dsimp [K]; positivity
  have hS4mem : MemLp S 4 P := thm_11_7_centeredSum_memLp P Y hY (n + 1)
  have hSint : Integrable (fun ω => S ω ^ 4) P := by
    refine (hS4mem.integrable_norm_pow' (p := 4)).congr ?_
    filter_upwards with ω
    rw [Real.norm_eq_abs, ← abs_pow,
      abs_of_nonneg (Even.pow_nonneg (by decide) (S ω))]
  have hthreshold : 0 < (ε * N) ^ 4 := by positivity
  have hmarkov := thm_10_3 P (fun ω => S ω ^ 4)
    (Filter.Eventually.of_forall fun ω => Even.pow_nonneg (by decide) (S ω))
    hSint hthreshold
  let A : Set Ω := almostSureDeviationEvent
    (fun n => thm_11_7_centeredAverage Y n) (fun _ => 0) n ε
  let B : Set Ω := {ω | (ε * N) ^ 4 ≤ S ω ^ 4}
  have hAB : A ⊆ B := by
    intro ω hω
    have havg : ε < |S ω / N| := by
      simpa [A, S, N, almostSureDeviationEvent, thm_11_7_centeredAverage] using hω
    have habs : ε * N < |S ω| := by
      rw [abs_div, abs_of_pos hN] at havg
      exact (lt_div_iff₀ hN).mp havg
    have hp := pow_le_pow_left₀ (mul_nonneg hε.le hN.le) habs.le 4
    have heven : |S ω| ^ 4 = S ω ^ 4 := by
      rw [← abs_pow, abs_of_nonneg (Even.pow_nonneg (by decide) (S ω))]
    exact hp.trans_eq heven
  have hreal : P.real A ≤ K / (ε ^ 4 * N ^ 2) := by
    have hm : P.real A ≤ P.real B := measureReal_mono hAB
    calc
      P.real A ≤ P.real B := hm
      _ ≤ (∫ ω, S ω ^ 4 ∂P) / (ε * N) ^ 4 := by simpa [B] using hmarkov
      _ ≤ (K * N ^ 2) / (ε * N) ^ 4 := by
        have hmom : (∫ ω, S ω ^ 4 ∂P) ≤ K * N ^ 2 := by
          simpa [S, K, N, Nat.cast_add, Nat.cast_one] using
            (thm_11_7_centered_partial_sum_moments P Y C hYm hY h_indep hmean hC h4 (n + 1)).2
        exact div_le_div_of_nonneg_right hmom hthreshold.le
      _ = K / (ε ^ 4 * N ^ 2) := by field_simp [hε.ne', hN.ne']
  have hmeasure : P A = ENNReal.ofReal (P.real A) := by
    rw [measureReal_def, ENNReal.ofReal_toReal (measure_ne_top P A)]
  rw [hmeasure]
  exact ENNReal.ofReal_le_ofReal <| by simpa [K, N] using hreal

/-- Centered fourth-moment strong law.  Tail probabilities are summable for
the full sequence, so no subsequence interpolation is needed. -/
theorem thm_11_7_centered
    {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    (Y : ℕ → Ω → ℝ) (C : ℝ)
    (hYm : ∀ i, Measurable (Y i)) (hY : ∀ i, MemLp (Y i) 4 P)
    (h_indep : iIndepFun Y P) (hmean : ∀ i, P[Y i] = 0)
    (hC : 0 ≤ C) (h4 : ∀ i, (∫ ω, Y i ω ^ 4 ∂P) ≤ C) :
    ConvergesAlmostSurely P (fun n => thm_11_7_centeredAverage Y n) (fun _ => 0) := by
  apply (thm_10_1 P _ _).2
  refine ⟨fun n => (thm_11_7_centeredAverage_measurable Y hYm n).aestronglyMeasurable,
    measurable_const.aestronglyMeasurable, ?_⟩
  intro ε hε
  let K : ℝ := C + 3 * ((C + 1) / 2) ^ 2
  let A : ℕ → Set Ω := fun n => almostSureDeviationEvent
    (fun n => thm_11_7_centeredAverage Y n) (fun _ => 0) n ε
  let b : ℕ → ℝ := fun n => K / (ε ^ 4 * (n + 1 : ℝ) ^ 2)
  have hK : 0 ≤ K := by dsimp [K]; positivity
  have hb_nonneg : ∀ n, 0 ≤ b n := by
    intro n
    dsimp [b]
    positivity
  have hbase : Summable (fun n : ℕ => (n : ℝ) ^ (-2 : ℤ)) := by
    simpa using (Real.summable_nat_rpow.mpr (by norm_num : (-2 : ℝ) < -1))
  have hshift : Summable (fun n : ℕ => ((n + 1 : ℕ) : ℝ) ^ (-2 : ℤ)) :=
    (summable_nat_add_iff 1).2 hbase
  have hb : Summable b := by
    have hs := hshift.mul_left (K / ε ^ 4)
    refine hs.congr fun n => ?_
    dsimp [b]
    rw [zpow_neg]
    norm_num
    field_simp
  have hb_tsum : (∑' n, ENNReal.ofReal (b n)) ≠ ∞ := by
    rw [← ENNReal.ofReal_tsum_of_nonneg hb_nonneg hb]
    exact ENNReal.ofReal_ne_top
  have hA_tsum : (∑' n, P (A n)) ≠ ∞ := by
    apply ne_top_of_le_ne_top hb_tsum
    apply ENNReal.tsum_le_tsum
    intro n
    simpa [A, b, K] using
      thm_11_7_centered_tail_bound P Y C hYm hY h_indep hmean hC h4 hε n
  simpa [deviationInfinitelyOften, A] using thm_5_8 P A hA_tsum

/-- **Theorem 11.7 (fourth-moment strong law of large numbers).**

The assumptions are the source's uncentered assumptions: mutually independent
real random variables, common mean `m`, membership in `L⁴`, and the uniform raw
bound `E[Xᵢ⁴] ≤ c`.  No identical-distribution assumption is made. -/
theorem thm_11_7
    {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω) [IsProbabilityMeasure P]
    (X : ℕ → Ω → ℝ) (m c : ℝ)
    (hXm : ∀ i, Measurable (X i)) (hX : ∀ i, MemLp (X i) 4 P)
    (h_indep : iIndepFun X P) (hmean : ∀ i, P[X i] = m)
    (hraw : ∀ i, (∫ ω, X i ω ^ 4 ∂P) ≤ c) :
    ConvergesAlmostSurely P (fun n => thm_11_7_sampleMean X n) (fun _ => m) := by
  let Y : ℕ → Ω → ℝ := fun i ω => X i ω - m
  let C : ℝ := 8 * (c + m ^ 4)
  have hc : 0 ≤ c := by
    have hnonneg : 0 ≤ ∫ ω, X 0 ω ^ 4 ∂P :=
      integral_nonneg fun _ => Even.pow_nonneg (by decide) _
    exact hnonneg.trans (hraw 0)
  have hC : 0 ≤ C := by dsimp [C]; positivity
  have hYm : ∀ i, Measurable (Y i) := fun i => (hXm i).sub_const m
  have hY : ∀ i, MemLp (Y i) 4 P := by
    intro i
    exact (thm_11_7_centered_fourth_moment P m c (hX i) (hraw i)).1
  have hY4 : ∀ i, (∫ ω, Y i ω ^ 4 ∂P) ≤ C := by
    intro i
    exact (thm_11_7_centered_fourth_moment P m c (hX i) (hraw i)).2
  have hYmean : ∀ i, P[Y i] = 0 := by
    intro i
    have hXi : Integrable (X i) P := (hX i).integrable (by norm_num)
    dsimp [Y]
    rw [integral_sub hXi (integrable_const m), hmean i, integral_const]
    simp
  have hYindep : iIndepFun Y P := by
    simpa [Y] using thm_11_7_centered_iIndepFun m h_indep
  have hcentered :
      ConvergesAlmostSurely P (fun n => thm_11_7_centeredAverage Y n) (fun _ => 0) :=
    thm_11_7_centered P Y C hYm hY hYindep hYmean hC hY4
  refine ⟨?_, measurable_const.aestronglyMeasurable, ?_⟩
  · intro n
    unfold thm_11_7_sampleMean
    exact ((Finset.measurable_sum (Finset.range (n + 1)) fun i _ => hXm i).div_const _).aestronglyMeasurable
  · filter_upwards [hcentered.2.2] with ω hω
    have heq : ∀ n, thm_11_7_sampleMean X n ω =
        thm_11_7_centeredAverage Y n ω + m := by
      intro n
      have hN : (n + 1 : ℝ) ≠ 0 := by positivity
      simp only [thm_11_7_sampleMean, thm_11_7_centeredAverage,
        thm_11_7_centeredSum, Y]
      rw [Finset.sum_sub_distrib]
      simp
      field_simp
      ring
    have hadd : Tendsto (fun n => thm_11_7_centeredAverage Y n ω + m)
        atTop (nhds (0 + m)) := hω.add tendsto_const_nhds
    simpa only [heq, zero_add] using hadd
