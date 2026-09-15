import Mathlib

open Filter MeasureTheory ProbabilityTheory Set
open scoped BigOperators ENNReal

namespace Thm117Support

private lemma abs_fourth (x : ℝ) : |x| ^ 4 = x ^ 4 := by
  calc
    |x| ^ 4 = (|x| ^ 2) ^ 2 := by ring
    _ = (x ^ 2) ^ 2 := by rw [sq_abs]
    _ = x ^ 4 := by ring

lemma iIndepFun_center {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    (X : ℕ → Ω → ℝ) (m : ℝ) (hX : iIndepFun X P) :
    iIndepFun (fun i ω => X i ω - m) P := by
  have h := hX.comp (fun (_ : ℕ) => fun x : ℝ => x - m)
    (fun _ => measurable_id.sub_const m)
  simpa [Function.comp_def] using h

private lemma integrable_fourth {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    [IsFiniteMeasure P] {X : Ω → ℝ} (hX : MemLp X 4 P) :
    Integrable (fun ω => (X ω) ^ 4) P := by
  simpa [Real.norm_eq_abs, abs_fourth] using hX.integrable_norm_pow'

lemma mean_pow_four_le {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω)
    [IsProbabilityMeasure P] {X : Ω → ℝ} (hX : MemLp X 4 P) :
    (P[X]) ^ 4 ≤ ∫ ω, (X ω) ^ 4 ∂P := by
  have hX1 : Integrable X P :=
    (hX.mono_exponent (by norm_num : (1 : ℝ≥0∞) ≤ 4)).integrable (by norm_num)
  have hX4 : Integrable (fun ω => (X ω) ^ 4) P := integrable_fourth hX
  simpa [Function.comp_def] using
    (show Even 4 from even_iff_two_dvd.mpr (by norm_num)).convexOn_pow.map_integral_le
      (continuous_pow 4).continuousOn isClosed_univ
      (Filter.Eventually.of_forall fun _ => mem_univ _) hX1 hX4

lemma centered_fourth_moment_le {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω)
    [IsProbabilityMeasure P] {X : Ω → ℝ} (hX : MemLp X 4 P) {c : ℝ}
    (h4 : (∫ ω, (X ω) ^ 4 ∂P) ≤ c) :
    (∫ ω, (X ω - P[X]) ^ 4 ∂P) ≤ 16 * c := by
  have hX4 : Integrable (fun ω => (X ω) ^ 4) P := integrable_fourth hX
  have hm4 : (P[X]) ^ 4 ≤ c := (mean_pow_four_le P hX).trans h4
  have hcenter : MemLp (fun ω => X ω - P[X]) 4 P := by
    change MemLp (X - fun _ => P[X]) 4 P
    exact hX.sub (memLp_const P[X])
  have hcenter4 : Integrable (fun ω => (X ω - P[X]) ^ 4) P :=
    integrable_fourth hcenter
  have hconst4 : Integrable (fun _ : Ω => (P[X]) ^ 4) P := integrable_const _
  have hmajor : Integrable (fun ω => 8 * ((X ω) ^ 4 + (P[X]) ^ 4)) P := by
    exact (hX4.add hconst4).const_mul 8
  calc
    (∫ ω, (X ω - P[X]) ^ 4 ∂P)
        ≤ ∫ ω, 8 * ((X ω) ^ 4 + (P[X]) ^ 4) ∂P := by
          apply integral_mono hcenter4 hmajor
          intro ω
          calc
            (X ω - P[X]) ^ 4 = |X ω - P[X]| ^ 4 := (abs_fourth _).symm
            _ ≤ (|X ω| + |P[X]|) ^ 4 :=
              pow_le_pow_left₀ (abs_nonneg _) (abs_sub _ _) 4
            _ ≤ 8 * (|X ω| ^ 4 + |P[X]| ^ 4) := by
              have h := add_pow_le (abs_nonneg (X ω)) (abs_nonneg P[X]) 4
              norm_num only [Nat.reduceSub, Nat.cast_ofNat] at h
              exact h
            _ = 8 * ((X ω) ^ 4 + (P[X]) ^ 4) := by
              rw [abs_fourth, abs_fourth]
    _ = 8 * ((∫ ω, (X ω) ^ 4 ∂P) + (P[X]) ^ 4) := by
          rw [integral_const_mul, integral_add hX4 hconst4]
          simp
    _ ≤ 16 * c := by nlinarith


noncomputable def prefixSum {Ω : Type*} (Y : ℕ → Ω → ℝ) (n : ℕ) : Ω → ℝ :=
  fun ω => ∑ i ∈ Finset.range n, Y i ω

lemma indepFun_prefixSum_next {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    (Y : ℕ → Ω → ℝ) (hYm : ∀ i, Measurable (Y i)) (hY : iIndepFun Y P)
    (n : ℕ) : prefixSum Y n ⟂ᵢ[P] Y n := by
  have hblocks := hY.indepFun_finset (Finset.range n) {n} (by simp) hYm
  have hsum : Measurable (fun z : {i // i ∈ Finset.range n} → ℝ => ∑ i, z i) :=
    Finset.measurable_sum Finset.univ (fun i _ => measurable_pi_apply i)
  have hpick : Measurable (fun z : {i // i ∈ ({n} : Finset ℕ)} → ℝ =>
      z ⟨n, Finset.mem_singleton_self n⟩) :=
    measurable_pi_apply (⟨n, Finset.mem_singleton_self n⟩ : {i // i ∈ ({n} : Finset ℕ)})
  have hcomp := hblocks.comp hsum hpick
  convert hcomp using 1
  · ext ω
    rw [prefixSum, ← Finset.sum_attach]
    simp [Function.comp_def]
  · ext ω
    rfl
lemma prefixSum_mean_zero {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    (Y : ℕ → Ω → ℝ) (hYint : ∀ i, Integrable (Y i) P)
    (hmean : ∀ i, P[Y i] = 0) (n : ℕ) : P[prefixSum Y n] = 0 := by
  change (∫ ω, ∑ i ∈ Finset.range n, Y i ω ∂P) = 0
  rw [integral_finset_sum]
  · simp [hmean]
  · intro i _
    exact hYint i


lemma integral_cube_mul_eq_zero_of_indep {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} {A B : Ω → ℝ} (hA : Measurable A) (hB : Measurable B)
    (hAB : A ⟂ᵢ[P] B) (hB0 : P[B] = 0) :
    (∫ ω, A ω ^ 3 * B ω ∂P) = 0 := by
  have hi := (hAB.comp (measurable_id.pow_const 3) measurable_id).integral_fun_mul_eq_mul_integral
    (hA.pow_const 3).aestronglyMeasurable hB.aestronglyMeasurable
  simp only [Function.comp_apply, id_eq] at hi
  rw [hi]
  simpa using congrArg (fun z : ℝ => (∫ ω, A ω ^ 3 ∂P) * z) hB0

lemma integral_mul_cube_eq_zero_of_indep {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} {A B : Ω → ℝ} (hA : Measurable A) (hB : Measurable B)
    (hAB : A ⟂ᵢ[P] B) (hA0 : P[A] = 0) :
    (∫ ω, A ω * B ω ^ 3 ∂P) = 0 := by
  have hi := (hAB.comp measurable_id (measurable_id.pow_const 3)).integral_fun_mul_eq_mul_integral
    hA.aestronglyMeasurable (hB.pow_const 3).aestronglyMeasurable
  simp only [Function.comp_apply, id_eq] at hi
  rw [hi, hA0, zero_mul]

lemma integral_sq_mul_sq_of_indep {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} {A B : Ω → ℝ} (hA : Measurable A) (hB : Measurable B)
    (hAB : A ⟂ᵢ[P] B) :
    (∫ ω, A ω ^ 2 * B ω ^ 2 ∂P) =
      (∫ ω, A ω ^ 2 ∂P) * ∫ ω, B ω ^ 2 ∂P := by
  exact (hAB.comp (measurable_id.pow_const 2) (measurable_id.pow_const 2)).integral_fun_mul_eq_mul_integral
    (hA.pow_const 2).aestronglyMeasurable (hB.pow_const 2).aestronglyMeasurable

lemma prefixSum_succ {Ω : Type*} (Y : ℕ → Ω → ℝ) (n : ℕ) :
    prefixSum Y (n + 1) = fun ω => prefixSum Y n ω + Y n ω := by
  ext ω
  exact Finset.sum_range_succ _ _

lemma prefixSum_measurable {Ω : Type*} [MeasurableSpace Ω]
    (Y : ℕ → Ω → ℝ) (hYm : ∀ i, Measurable (Y i)) (n : ℕ) :
    Measurable (prefixSum Y n) := by
  exact Finset.measurable_sum (Finset.range n) (fun i _ => hYm i)

lemma prefixSum_memLp {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    (Y : ℕ → Ω → ℝ) (hY : ∀ i, MemLp (Y i) 4 P) (n : ℕ) :
    MemLp (prefixSum Y n) 4 P := by
  exact memLp_finset_sum (Finset.range n) (fun i _ => hY i)

private lemma integrable_mixed {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    [IsFiniteMeasure P] {A B : Ω → ℝ} (hA : Measurable A) (hB : Measurable B)
    (hA4 : MemLp A 4 P) (hB4 : MemLp B 4 P) (a b : ℕ) (hab : a + b = 4) :
    Integrable (fun ω => A ω ^ a * B ω ^ b) P := by
  have hmajor : Integrable (fun ω => 8 * (A ω ^ 4 + B ω ^ 4)) P :=
    ((integrable_fourth hA4).add (integrable_fourth hB4)).const_mul 8
  apply hmajor.mono' (hA.pow_const a |>.mul (hB.pow_const b)).aestronglyMeasurable
  filter_upwards [] with ω
  rw [Real.norm_eq_abs, abs_mul, abs_pow, abs_pow]
  calc
    |A ω| ^ a * |B ω| ^ b
        ≤ (|A ω| + |B ω|) ^ a * (|A ω| + |B ω|) ^ b := by
          exact mul_le_mul
            (pow_le_pow_left₀ (abs_nonneg _) (le_add_of_nonneg_right (abs_nonneg _)) a)
            (pow_le_pow_left₀ (abs_nonneg _) (le_add_of_nonneg_left (abs_nonneg _)) b)
            (pow_nonneg (abs_nonneg _) b) (pow_nonneg (add_nonneg (abs_nonneg _) (abs_nonneg _)) a)
    _ = (|A ω| + |B ω|) ^ 4 := by rw [← pow_add, hab]
    _ ≤ 8 * (|A ω| ^ 4 + |B ω| ^ 4) := by
          have h := add_pow_le (abs_nonneg (A ω)) (abs_nonneg (B ω)) 4
          norm_num only [Nat.reduceSub, Nat.cast_ofNat] at h
          exact h
    _ = 8 * (A ω ^ 4 + B ω ^ 4) := by rw [abs_fourth, abs_fourth]

/-- Exact recursive fourth-power expansion: independence and zero means kill
the two odd mixed terms. -/
lemma prefixSum_fourth_succ {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω)
    [IsProbabilityMeasure P] (Y : ℕ → Ω → ℝ)
    (hYm : ∀ i, Measurable (Y i)) (hY4 : ∀ i, MemLp (Y i) 4 P)
    (hindep : iIndepFun Y P) (hmean : ∀ i, P[Y i] = 0) (n : ℕ) :
    (∫ ω, prefixSum Y (n + 1) ω ^ 4 ∂P) =
      (∫ ω, prefixSum Y n ω ^ 4 ∂P) +
        6 * (∫ ω, prefixSum Y n ω ^ 2 ∂P) * (∫ ω, Y n ω ^ 2 ∂P) +
        ∫ ω, Y n ω ^ 4 ∂P := by
  let S := prefixSum Y n
  let Z := Y n
  have hSm : Measurable S := prefixSum_measurable Y hYm n
  have hZm : Measurable Z := hYm n
  have hS4 : MemLp S 4 P := prefixSum_memLp Y hY4 n
  have hZ4 : MemLp Z 4 P := hY4 n
  have hSZ : S ⟂ᵢ[P] Z := indepFun_prefixSum_next Y hYm hindep n
  have hS0 : P[S] = 0 := prefixSum_mean_zero Y
    (fun i => (hY4 i).integrable (by norm_num)) hmean n
  have hZ0 : P[Z] = 0 := hmean n
  have h31 := integrable_mixed hSm hZm hS4 hZ4 3 1 (by norm_num)
  have h22 := integrable_mixed hSm hZm hS4 hZ4 2 2 (by norm_num)
  have h13 := integrable_mixed hSm hZm hS4 hZ4 1 3 (by norm_num)
  have hS4i := integrable_fourth hS4
  have hZ4i := integrable_fourth hZ4
  rw [prefixSum_succ]
  change (∫ ω, (S ω + Z ω) ^ 4 ∂P) = _
  have h31c : Integrable (fun ω => 4 * (S ω ^ 3 * Z ω)) P := by
    simpa using h31.const_mul 4
  have h22c : Integrable (fun ω => 6 * (S ω ^ 2 * Z ω ^ 2)) P := h22.const_mul 6
  have h13c : Integrable (fun ω => 4 * (S ω * Z ω ^ 3)) P := by
    simpa using h13.const_mul 4
  have hexpand : (fun ω => (S ω + Z ω) ^ 4) = fun ω =>
      S ω ^ 4 + 4 * (S ω ^ 3 * Z ω) + 6 * (S ω ^ 2 * Z ω ^ 2) +
        4 * (S ω * Z ω ^ 3) + Z ω ^ 4 := by
    funext ω
    ring
  rw [hexpand]
  change (∫ ω, ((((S ω ^ 4 + 4 * (S ω ^ 3 * Z ω)) +
    6 * (S ω ^ 2 * Z ω ^ 2)) + 4 * (S ω * Z ω ^ 3)) + Z ω ^ 4) ∂P) = _
  have hi1 := integral_add hS4i h31c
  have hi2 := integral_add (hS4i.add h31c) h22c
  have hi3 := integral_add ((hS4i.add h31c).add h22c) h13c
  have hi4 := integral_add (((hS4i.add h31c).add h22c).add h13c) hZ4i
  simp only [Pi.add_apply] at hi1 hi2 hi3 hi4
  rw [hi4, hi3, hi2, hi1]
  rw [integral_const_mul, integral_const_mul, integral_const_mul]
  rw [integral_cube_mul_eq_zero_of_indep hSm hZm hSZ hZ0,
    integral_mul_cube_eq_zero_of_indep hSm hZm hSZ hS0,
    integral_sq_mul_sq_of_indep hSm hZm hSZ]
  dsimp [S, Z]
  ring


private lemma integrable_square {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    [IsFiniteMeasure P] {X : Ω → ℝ} (hX : MemLp X 4 P) :
    Integrable (fun ω => X ω ^ 2) P := by
  have h := (hX.mono_exponent (by norm_num : (2 : ℝ≥0∞) ≤ 4)).integrable_norm_pow'
  simpa [Real.norm_eq_abs, sq_abs] using h

/-- Cauchy--Schwarz/Jensen in the precise form used for the square-pair terms. -/
lemma square_integral_sq_le_fourth {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω)
    [IsProbabilityMeasure P] {X : Ω → ℝ} (hX : MemLp X 4 P) :
    (∫ ω, X ω ^ 2 ∂P) ^ 2 ≤ ∫ ω, X ω ^ 4 ∂P := by
  have h2 := integrable_square hX
  have h4 := integrable_fourth hX
  have h4' : Integrable (fun ω => (X ω ^ 2) ^ 2) P := by
    convert h4 using 1
    funext ω
    ring
  have h := (show Even 2 from even_iff_two_dvd.mpr (by norm_num)).convexOn_pow.map_integral_le
    (continuous_pow 2).continuousOn isClosed_univ
    (Filter.Eventually.of_forall fun _ => mem_univ _) h2 h4'
  calc
    (∫ ω, X ω ^ 2 ∂P) ^ 2 ≤ ∫ ω, (X ω ^ 2) ^ 2 ∂P := h
    _ = ∫ ω, X ω ^ 4 ∂P := by
      apply integral_congr_ae
      filter_upwards [] with ω
      ring

lemma second_moment_product_le {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω)
    [IsProbabilityMeasure P] {A B : Ω → ℝ} (hA : MemLp A 4 P) (hB : MemLp B 4 P)
    {C : ℝ} (hA4 : (∫ ω, A ω ^ 4 ∂P) ≤ C) (hB4 : (∫ ω, B ω ^ 4 ∂P) ≤ C) :
    (∫ ω, A ω ^ 2 ∂P) * (∫ ω, B ω ^ 2 ∂P) ≤ C := by
  have ha0 : 0 ≤ ∫ ω, A ω ^ 2 ∂P := integral_nonneg fun _ => sq_nonneg _
  have hb0 : 0 ≤ ∫ ω, B ω ^ 2 ∂P := integral_nonneg fun _ => sq_nonneg _
  have ha := (square_integral_sq_le_fourth P hA).trans hA4
  have hb := (square_integral_sq_le_fourth P hB).trans hB4
  nlinarith [sq_nonneg ((∫ ω, A ω ^ 2 ∂P) - ∫ ω, B ω ^ 2 ∂P)]

lemma prefixSum_second_succ {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω)
    [IsProbabilityMeasure P] (Y : ℕ → Ω → ℝ)
    (hYm : ∀ i, Measurable (Y i)) (hY4 : ∀ i, MemLp (Y i) 4 P)
    (hindep : iIndepFun Y P) (hmean : ∀ i, P[Y i] = 0) (n : ℕ) :
    (∫ ω, prefixSum Y (n + 1) ω ^ 2 ∂P) =
      (∫ ω, prefixSum Y n ω ^ 2 ∂P) + ∫ ω, Y n ω ^ 2 ∂P := by
  let S := prefixSum Y n
  let Z := Y n
  have hSm : Measurable S := prefixSum_measurable Y hYm n
  have hZm : Measurable Z := hYm n
  have hS4 : MemLp S 4 P := prefixSum_memLp Y hY4 n
  have hZ4 : MemLp Z 4 P := hY4 n
  have hS2 := integrable_square hS4
  have hZ2 := integrable_square hZ4
  have hSZint : Integrable (fun ω => S ω * Z ω) P := by
    have hs : MemLp S 2 P := hS4.mono_exponent (by norm_num)
    have hz : MemLp Z 2 P := hZ4.mono_exponent (by norm_num)
    change Integrable (S * Z) P
    exact hs.integrable_mul hz
  have hSZ : S ⟂ᵢ[P] Z := indepFun_prefixSum_next Y hYm hindep n
  have hS0 : P[S] = 0 := prefixSum_mean_zero Y
    (fun i => (hY4 i).integrable (by norm_num)) hmean n
  have hprod : (∫ ω, S ω * Z ω ∂P) = 0 := by
    have hi := hSZ.integral_fun_mul_eq_mul_integral
      hSm.aestronglyMeasurable hZm.aestronglyMeasurable
    rw [hi, hS0, zero_mul]
  rw [prefixSum_succ]
  change (∫ ω, (S ω + Z ω) ^ 2 ∂P) = _
  have he : (fun ω => (S ω + Z ω) ^ 2) = fun ω =>
      (S ω ^ 2 + 2 * (S ω * Z ω)) + Z ω ^ 2 := by funext ω; ring
  rw [he]
  have hcross : Integrable (fun ω => 2 * (S ω * Z ω)) P := hSZint.const_mul 2
  have hi1 := integral_add hS2 hcross
  have hi2 := integral_add (hS2.add hcross) hZ2
  simp only [Pi.add_apply] at hi1 hi2
  rw [hi2, hi1, integral_const_mul, hprod]
  dsimp [S, Z]
  ring

lemma prefixSum_second_eq_sum {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω)
    [IsProbabilityMeasure P] (Y : ℕ → Ω → ℝ)
    (hYm : ∀ i, Measurable (Y i)) (hY4 : ∀ i, MemLp (Y i) 4 P)
    (hindep : iIndepFun Y P) (hmean : ∀ i, P[Y i] = 0) (n : ℕ) :
    (∫ ω, prefixSum Y n ω ^ 2 ∂P) = ∑ i ∈ Finset.range n, ∫ ω, Y i ω ^ 2 ∂P := by
  induction n with
  | zero => simp [prefixSum]
  | succ n ih =>
      rw [prefixSum_second_succ P Y hYm hY4 hindep hmean n, ih,
        Finset.sum_range_succ]

/-- The finite centered partial sum has fourth moment at most `3 C n²`. -/
lemma prefixSum_fourth_le {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω)
    [IsProbabilityMeasure P] (Y : ℕ → Ω → ℝ)
    (hYm : ∀ i, Measurable (Y i)) (hY4 : ∀ i, MemLp (Y i) 4 P)
    (hindep : iIndepFun Y P) (hmean : ∀ i, P[Y i] = 0)
    {C : ℝ} (hC : 0 ≤ C) (hbound : ∀ i, (∫ ω, Y i ω ^ 4 ∂P) ≤ C) (n : ℕ) :
    (∫ ω, prefixSum Y n ω ^ 4 ∂P) ≤ 3 * C * (n : ℝ) ^ 2 := by
  induction n with
  | zero => simp [prefixSum, hC]
  | succ n ih =>
      rw [prefixSum_fourth_succ P Y hYm hY4 hindep hmean n]
      rw [prefixSum_second_eq_sum P Y hYm hY4 hindep hmean n]
      have hpairs :
          (∑ i ∈ Finset.range n, ∫ ω, Y i ω ^ 2 ∂P) * (∫ ω, Y n ω ^ 2 ∂P)
            ≤ (n : ℝ) * C := by
        rw [Finset.sum_mul]
        calc
          ∑ i ∈ Finset.range n,
              (∫ ω, Y i ω ^ 2 ∂P) * (∫ ω, Y n ω ^ 2 ∂P)
              ≤ ∑ _i ∈ Finset.range n, C := by
                exact Finset.sum_le_sum fun i _ =>
                  second_moment_product_le P (hY4 i) (hY4 n) (hbound i) (hbound n)
          _ = (n : ℝ) * C := by simp
      have hn0 : (0 : ℝ) ≤ n := Nat.cast_nonneg n
      have hn4 := hbound n
      norm_num [Nat.cast_add, Nat.cast_one]
      nlinarith

/-- The centered average, indexed so that every denominator is nonzero. -/
noncomputable def centeredAverage {Ω : Type*} (Y : ℕ → Ω → ℝ) (n : ℕ) : Ω → ℝ :=
  fun ω => (((n : ℝ) + 1)⁻¹) * prefixSum Y (n + 1) ω

/-- Fourth-moment Markov bound for every integer, in measure-valued form. -/
lemma centeredAverage_tail_bound {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω)
    [IsProbabilityMeasure P] (Y : ℕ → Ω → ℝ)
    (hYm : ∀ i, Measurable (Y i)) (hY4 : ∀ i, MemLp (Y i) 4 P)
    (hindep : iIndepFun Y P) (hmean : ∀ i, P[Y i] = 0)
    {C : ℝ} (hC : 0 ≤ C) (hbound : ∀ i, (∫ ω, Y i ω ^ 4 ∂P) ≤ C)
    {ε : ℝ} (hε : 0 < ε) (n : ℕ) :
    P {ω | ε < |centeredAverage Y n ω|} ≤
      ENNReal.ofReal (3 * C / (((n : ℝ) + 1) ^ 2 * ε ^ 4)) := by
  let S := prefixSum Y (n + 1)
  let t : ℝ := (((n : ℝ) + 1) * ε) ^ 4
  have hn : 0 < (n : ℝ) + 1 := by positivity
  have ht : 0 < t := pow_pos (mul_pos hn hε) _
  have hSint : Integrable (fun ω => S ω ^ 4) P :=
    integrable_fourth (prefixSum_memLp Y hY4 (n + 1))
  have hnonneg : 0 ≤ᵐ[P] fun ω => S ω ^ 4 :=
    Filter.Eventually.of_forall fun _ => by positivity
  have hmarkov := mul_meas_ge_le_integral_of_nonneg hnonneg hSint t
  have hsub : {ω | ε < |centeredAverage Y n ω|} ⊆ {ω | t ≤ S ω ^ 4} := by
    intro ω hω
    have hsabs : ((n : ℝ) + 1) * ε < |S ω| := by
      dsimp [centeredAverage] at hω
      rw [abs_mul, abs_inv, abs_of_pos hn] at hω
      have hinv : ((n : ℝ) + 1)⁻¹ > 0 := inv_pos.mpr hn
      nlinarith [inv_mul_cancel₀ hn.ne']
    dsimp [t]
    exact calc
      (((n : ℝ) + 1) * ε) ^ 4 ≤ |S ω| ^ 4 := pow_le_pow_left₀ (by positivity) hsabs.le 4
      _ = S ω ^ 4 := abs_fourth _
  have hrealmono : P.real {ω | ε < |centeredAverage Y n ω|} ≤
      P.real {ω | t ≤ S ω ^ 4} := measureReal_mono hsub
  have hmoment : (∫ ω, S ω ^ 4 ∂P) ≤ 3 * C * ((n : ℝ) + 1) ^ 2 := by
    simpa [S, Nat.cast_add, Nat.cast_one] using
      prefixSum_fourth_le P Y hYm hY4 hindep hmean hC hbound (n + 1)
  have hreal : P.real {ω | ε < |centeredAverage Y n ω|} ≤
      3 * C / (((n : ℝ) + 1) ^ 2 * ε ^ 4) := by
    have hm := hmarkov
    have hm' : t * P.real {ω | ε < |centeredAverage Y n ω|} ≤
        ∫ ω, S ω ^ 4 ∂P := (mul_le_mul_of_nonneg_left hrealmono ht.le).trans hm
    dsimp [t] at hm'
    rw [mul_pow] at hm'
    have he4 : 0 < ε ^ 4 := pow_pos hε _
    apply (le_div_iff₀ (mul_pos (sq_pos_of_pos hn) he4)).2
    apply (mul_le_mul_iff_left₀ (sq_pos_of_pos hn)).mp
    calc
      (P.real {ω | ε < |centeredAverage Y n ω|} * (((n : ℝ) + 1) ^ 2 * ε ^ 4)) *
          ((n : ℝ) + 1) ^ 2
          = ((n : ℝ) + 1) ^ 4 * ε ^ 4 *
              P.real {ω | ε < |centeredAverage Y n ω|} := by ring
      _ ≤ ∫ ω, S ω ^ 4 ∂P := hm'
      _ ≤ 3 * C * ((n : ℝ) + 1) ^ 2 := hmoment
      _ = (3 * C) * ((n : ℝ) + 1) ^ 2 := by ring
  rw [← ENNReal.ofReal_toReal (measure_ne_top P _)]
  exact ENNReal.ofReal_le_ofReal hreal

/-- The fourth-moment tail estimates form a summable ENNReal series. -/
lemma centeredAverage_deviation_tsum_ne_top {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (Y : ℕ → Ω → ℝ)
    (hYm : ∀ i, Measurable (Y i)) (hY4 : ∀ i, MemLp (Y i) 4 P)
    (hindep : iIndepFun Y P) (hmean : ∀ i, P[Y i] = 0)
    {C : ℝ} (hC : 0 ≤ C) (hbound : ∀ i, (∫ ω, Y i ω ^ 4 ∂P) ≤ C)
    {ε : ℝ} (hε : 0 < ε) :
    (∑' n, P {ω | ε < |centeredAverage Y n ω|}) ≠ ∞ := by
  let g : ℕ → NNReal := fun n => ⟨3 * C / (((n : ℝ) + 1) ^ 2 * ε ^ 4), by positivity⟩
  have hp : Summable (fun n : ℕ => 1 / (((n : ℝ) + 1) ^ 2)) := by
    have h0 : Summable (fun n : ℕ => 1 / (n : ℝ) ^ 2) :=
      Real.summable_one_div_nat_pow.mpr (by norm_num)
    simpa [Nat.cast_add, Nat.cast_one] using (summable_nat_add_iff 1).2 h0
  have hr : Summable (fun n : ℕ => 3 * C / (((n : ℝ) + 1) ^ 2 * ε ^ 4)) := by
    have hh := hp.mul_left (3 * C / ε ^ 4)
    exact hh.congr (fun n => by
      have hn : (n : ℝ) + 1 ≠ 0 := by positivity
      have he : ε ^ 4 ≠ 0 := pow_ne_zero _ hε.ne'
      field_simp)
  have hg : Summable g := by
    apply NNReal.summable_coe.mp
    change Summable (fun n => (g n : ℝ))
    exact hr.congr (fun n => (NNReal.coe_mk _ _).symm)
  apply ne_top_of_le_ne_top (ENNReal.tsum_coe_ne_top_iff_summable.mpr hg)
  apply ENNReal.tsum_le_tsum
  intro n
  calc
    P {ω | ε < |centeredAverage Y n ω|}
        ≤ ENNReal.ofReal (3 * C / (((n : ℝ) + 1) ^ 2 * ε ^ 4)) :=
          centeredAverage_tail_bound P Y hYm hY4 hindep hmean hC hbound hε n
    _ = (g n : ℝ≥0∞) := by
      rw [ENNReal.ofReal_eq_coe_nnreal (by positivity)]
      exact congrArg (fun z : NNReal => (z : ℝ≥0∞)) (Subtype.ext (by rfl))
end Thm117Support
