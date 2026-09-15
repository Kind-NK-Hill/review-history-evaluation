import Mathlib
import ProbabilityTheory.chapter_05.def_5_10
import ProbabilityTheory.chapter_09.def_9_1
import ProbabilityTheory.chapter_05.thm_5_8
import ProbabilityTheory.chapter_10.thm_10_1
import ProbabilityTheory.chapter_11.thm_11_1
import ProbabilityTheory.chapter_11.thm_11_5

open Filter MeasureTheory ProbabilityTheory Set
open scoped BigOperators ENNReal Topology
noncomputable section

/-- A cofinal positive-index subsequence determines the full sequence; this is
used to pass from the textbook positive sample sizes to the complete Lean index. -/
lemma thm_11_7_subsequence_to_full {α : Type*} [TopologicalSpace α]
    (u : ℕ → α) (a : α)
    (h : Tendsto (fun n => u (n + 1)) atTop (𝓝 a)) : Tendsto u atTop (𝓝 a) := by
  exact (tendsto_add_atTop_iff_nat 1).mp h

def thm_11_7_center (X : ℕ → Ω → ℝ) (m : ℝ) (i : ℕ) : Ω → ℝ := fun ω => X i ω - m

def thm_11_7_partialSum (Y : ℕ → Ω → ℝ) (n : ℕ) : Ω → ℝ :=
  ∑ i ∈ Finset.range n, Y i

def thm_11_7_sampleMean (X : ℕ → Ω → ℝ) (n : ℕ) : Ω → ℝ :=
  fun ω => (∑ i ∈ Finset.range (n + 1), X i ω) / (n + 1 : ℝ)

private lemma integrable_pow_of_memLp_four {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsFiniteMeasure P] {f : Ω → ℝ} (hf : MemLp f 4 P) (k : ℕ) (hk : k ≤ 4) :
    Integrable (fun ω => f ω ^ k) P := by
  have hfk : MemLp f k P := hf.mono_exponent (by exact_mod_cast hk)
  have hm : AEStronglyMeasurable (fun ω => f ω ^ k) P := hf.1.pow k
  have hn : Integrable (fun ω => ‖f ω ^ k‖) P := by
    simpa [Real.norm_eq_abs, abs_pow] using hfk.integrable_norm_pow'
  exact (integrable_norm_iff hm).mp hn

private lemma partialSum_measurable {Ω : Type*} [MeasurableSpace Ω]
    (Y : ℕ → Ω → ℝ) (hY : ∀ i, Measurable (Y i)) (n : ℕ) :
    Measurable (thm_11_7_partialSum Y n) := by
  unfold thm_11_7_partialSum
  fun_prop

private lemma partialSum_memLp_four {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} (Y : ℕ → Ω → ℝ) (hY : ∀ i, MemLp (Y i) 4 P) (n : ℕ) :
    MemLp (thm_11_7_partialSum Y n) 4 P := by
  unfold thm_11_7_partialSum
  exact memLp_finsetSum' (Finset.range n) (fun i _ => hY i)

lemma thm_11_7_center_independent {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} (X : ℕ → Ω → ℝ) (m : ℝ) (hX : iIndepFun X P) :
    iIndepFun (thm_11_7_center X m) P := by
  exact hX.comp (fun _ x => x - m) (fun _ => measurable_id.sub_const m)

lemma thm_11_7_center_finite {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (X : ℕ → Ω → ℝ) (m : ℝ)
    (hX4 : ∀ i, FiniteAbsMoment P (X i) 4) (i : ℕ) :
    FiniteAbsMoment P (thm_11_7_center X m i) 4 := by
  exact FiniteAbsMoment.of_memLp ((hX4 i).1.sub measurable_const)
    ((hX4 i).memLp (by norm_num) |>.sub (memLp_const m))

lemma thm_11_7_center_fourth_bound {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (X : ℕ → Ω → ℝ) (m c : ℝ)
    (hX4 : ∀ i, FiniteAbsMoment P (X i) 4)
    (hmom : ∀ i, ∫ ω, X i ω ^ 4 ∂P ≤ c) (i : ℕ) :
    (∫ ω, thm_11_7_center X m i ω ^ 4 ∂P) ≤ 8 * (c + |m| ^ 4) := by
  have hc := hX4 i
  have hfin := thm_11_7_center_finite P X m hX4 i
  have hdom : ∀ ω, (X i ω - m) ^ 4 ≤ 8 * (X i ω ^ 4 + |m| ^ 4) := by
    intro ω
    have h := abs_sub (X i ω) m
    have hp : |X i ω - m| ^ 4 ≤ (|X i ω| + |m|) ^ 4 := pow_le_pow_left₀ (abs_nonneg _) h 4
    have hadd := add_pow_le (abs_nonneg (X i ω)) (abs_nonneg m) 4
    calc
      (X i ω - m) ^ 4 = |X i ω - m| ^ 4 := by
        rw [← abs_pow, abs_of_nonneg (by positivity : 0 ≤ (X i ω - m) ^ 4)]
      _ ≤ (|X i ω| + |m|) ^ 4 := hp
      _ ≤ 8 * (X i ω ^ 4 + |m| ^ 4) := by
        norm_num at hadd ⊢
        simpa only [← abs_pow, abs_of_nonneg (by positivity : 0 ≤ X i ω ^ 4)] using hadd
  calc
    ∫ ω, thm_11_7_center X m i ω ^ 4 ∂P
        ≤ ∫ ω, 8 * (X i ω ^ 4 + |m| ^ 4) ∂P := by
          apply integral_mono
          · exact integrable_pow_of_memLp_four (hfin.memLp (by norm_num)) 4 le_rfl
          · exact ((integrable_pow_of_memLp_four (hc.memLp (by norm_num)) 4 le_rfl).add
              (integrable_const _)).const_mul 8
          · exact hdom
    _ = 8 * ((∫ ω, X i ω ^ 4 ∂P) + |m| ^ 4) := by
          rw [integral_const_mul, integral_add, integral_const,
            measureReal_univ_eq_one, one_smul]
          exact integrable_pow_of_memLp_four (hc.memLp (by norm_num)) 4 le_rfl
          exact integrable_const _
    _ ≤ 8 * (c + |m| ^ 4) := by gcongr; exact hmom i

private lemma second_moment_bound {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (Y : ℕ → Ω → ℝ)
    (hYm : ∀ i, Measurable (Y i)) (hYfin : ∀ i, FiniteAbsMoment P (Y i) 4)
    (hYzero : ∀ i, ∫ ω, Y i ω ∂P = 0) (hInd : iIndepFun Y P)
    (D : ℝ) (hY4 : ∀ i, ∫ ω, Y i ω ^ 4 ∂P ≤ D) (n : ℕ) :
    ∫ ω, thm_11_7_partialSum Y n ω ^ 2 ∂P ≤ (n : ℝ) * (D + 1) := by
  induction n with
  | zero => simp [thm_11_7_partialSum]
  | succ n ih =>
      let S := thm_11_7_partialSum Y n
      have hSm : Measurable S := partialSum_measurable Y hYm n
      have hS4 := partialSum_memLp_four Y (fun i => (hYfin i).memLp (by norm_num)) n
      change MemLp S 4 P at hS4
      have hYn4 := (hYfin n).memLp (by norm_num)
      have hSY : IndepFun S (Y n) P := by
        change (∑ j ∈ Finset.range n, Y j) ⟂ᵢ[P] Y n
        exact hInd.indepFun_finset_sum_of_notMem hYm (by simp)
      have hcross : ∫ ω, S ω * Y n ω ∂P = 0 := by
        simpa only [Pi.mul_apply, hYzero n, mul_zero] using
          hSY.integral_mul_eq_mul_integral hSm.aestronglyMeasurable (hYm n).aestronglyMeasurable
      have hY2 : ∫ ω, Y n ω ^ 2 ∂P ≤ D + 1 := by
        calc
          ∫ ω, Y n ω ^ 2 ∂P ≤ ∫ ω, Y n ω ^ 4 + 1 ∂P := by
            apply integral_mono
            · exact integrable_pow_of_memLp_four hYn4 2 (by norm_num)
            · exact (integrable_pow_of_memLp_four hYn4 4 le_rfl).add (integrable_const _)
            · intro ω; nlinarith [sq_nonneg (Y n ω ^ 2 - 1)]
          _ = (∫ ω, Y n ω ^ 4 ∂P) + 1 := by
            rw [integral_add, integral_const, measureReal_univ_eq_one, one_smul]
            exact integrable_pow_of_memLp_four hYn4 4 le_rfl
            exact integrable_const _
          _ ≤ D + 1 := by linarith [hY4 n]
      have hexpand :
          (∫ ω, thm_11_7_partialSum Y (n + 1) ω ^ 2 ∂P) =
            (∫ ω, S ω ^ 2 ∂P) + 2 * (∫ ω, S ω * Y n ω ∂P) +
              (∫ ω, Y n ω ^ 2 ∂P) := by
        simp only [thm_11_7_partialSum, Finset.sum_range_succ]
        change (∫ ω, (S ω + Y n ω) ^ 2 ∂P) = _
        rw [show (fun ω => (S ω + Y n ω) ^ 2) =
            (fun ω => S ω ^ 2 + 2 * (S ω * Y n ω) + Y n ω ^ 2) by funext ω; ring]
        have hS2 : MemLp S 2 P := hS4.mono_exponent (by norm_num)
        have hY2m : MemLp (Y n) 2 P := hYn4.mono_exponent (by norm_num)
        have eS2 := integrable_pow_of_memLp_four hS4 2 (by norm_num)
        have eY2 := integrable_pow_of_memLp_four hYn4 2 (by norm_num)
        have eC := (hS2.integrable_mul hY2m).const_mul 2
        have eC' : Integrable (fun ω => 2 * (S ω * Y n ω)) P := by
          simpa only [Pi.mul_apply] using eC
        have ho := integral_add (eS2.add eC') eY2
        have hi := integral_add eS2 eC'
        have hc := integral_const_mul (μ := P) 2 (fun ω => S ω * Y n ω)
        calc
          _ = (∫ ω, S ω ^ 2 + 2 * (S ω * Y n ω) ∂P) + ∫ ω, Y n ω ^ 2 ∂P := by
            simpa only [Pi.add_apply] using ho
          _ = ((∫ ω, S ω ^ 2 ∂P) + ∫ ω, 2 * (S ω * Y n ω) ∂P) +
                ∫ ω, Y n ω ^ 2 ∂P := by rw [hi]
          _ = _ := by rw [hc]
      rw [hexpand, hcross]
      push_cast
      nlinarith

private lemma fourth_moment_bound {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (Y : ℕ → Ω → ℝ)
    (hYm : ∀ i, Measurable (Y i)) (hYfin : ∀ i, FiniteAbsMoment P (Y i) 4)
    (hYzero : ∀ i, ∫ ω, Y i ω ∂P = 0) (hInd : iIndepFun Y P)
    (D : ℝ) (hD : 0 ≤ D) (hY4 : ∀ i, ∫ ω, Y i ω ^ 4 ∂P ≤ D) (n : ℕ) :
    ∫ ω, thm_11_7_partialSum Y n ω ^ 4 ∂P ≤
      (n : ℝ) * D + 3 * (n : ℝ) * ((n : ℝ) - 1) * (D + 1) ^ 2 := by
  induction n with
  | zero => simp [thm_11_7_partialSum]
  | succ n ih =>
      let S := thm_11_7_partialSum Y n
      have hSm := partialSum_measurable Y hYm n
      have hS4 := partialSum_memLp_four Y (fun i => (hYfin i).memLp (by norm_num)) n
      change MemLp S 4 P at hS4
      have hYn4 := (hYfin n).memLp (by norm_num)
      have hSY : IndepFun S (Y n) P := by
        change (∑ j ∈ Finset.range n, Y j) ⟂ᵢ[P] Y n
        exact hInd.indepFun_finset_sum_of_notMem hYm (by simp)
      have factor (a b : ℕ) :
          ∫ ω, S ω ^ a * Y n ω ^ b ∂P =
            (∫ ω, S ω ^ a ∂P) * (∫ ω, Y n ω ^ b ∂P) := by
        simpa [Function.comp_def, Pi.mul_apply] using
          (hSY.comp (measurable_id.pow_const a) (measurable_id.pow_const b)).integral_mul_eq_mul_integral
            (hSm.pow_const a).aestronglyMeasurable ((hYm n).pow_const b).aestronglyMeasurable
      have hexpand :
          (∫ ω, thm_11_7_partialSum Y (n + 1) ω ^ 4 ∂P) =
            (∫ ω, S ω ^ 4 ∂P) + 4 * (∫ ω, S ω ^ 3 * Y n ω ∂P) +
            6 * (∫ ω, S ω ^ 2 * Y n ω ^ 2 ∂P) +
            4 * (∫ ω, S ω * Y n ω ^ 3 ∂P) + (∫ ω, Y n ω ^ 4 ∂P) := by
        simp only [thm_11_7_partialSum, Finset.sum_range_succ]
        change (∫ ω, (S ω + Y n ω) ^ 4 ∂P) = _
        rw [show (fun ω => (S ω + Y n ω) ^ 4) = (fun ω =>
            S ω ^ 4 + 4 * (S ω ^ 3 * Y n ω) + 6 * (S ω ^ 2 * Y n ω ^ 2) +
              4 * (S ω * Y n ω ^ 3) + Y n ω ^ 4) by funext ω; ring]
        have eS4 := integrable_pow_of_memLp_four hS4 4 le_rfl
        have eY4 := integrable_pow_of_memLp_four hYn4 4 le_rfl
        have e31 : Integrable (fun ω => S ω ^ 3 * Y n ω) P := by
          apply (eS4.add eY4).mono' ((hSm.pow_const 3).mul (hYm n) |>.aestronglyMeasurable)
          filter_upwards with ω
          change ‖S ω ^ 3 * Y n ω‖ ≤ S ω ^ 4 + Y n ω ^ 4
          have hSa : S ω ^ 4 = |S ω| ^ 4 := by rw [← abs_pow, abs_of_nonneg (by positivity)]
          have hYa : Y n ω ^ 4 = |Y n ω| ^ 4 := by rw [← abs_pow, abs_of_nonneg (by positivity)]
          rw [hSa, hYa]
          simp only [Real.norm_eq_abs, abs_mul, abs_pow]
          change |S ω| ^ 3 * |Y n ω| ≤ |S ω| ^ 4 + |Y n ω| ^ 4
          have hz : 0 ≤ (|S ω| - |Y n ω|) ^ 2 *
              (3 * |S ω| ^ 2 + 2 * |S ω| * |Y n ω| + |Y n ω| ^ 2) := by positivity
          nlinarith
        have e22 : Integrable (fun ω => S ω ^ 2 * Y n ω ^ 2) P := by
          apply (eS4.add eY4).mono' ((hSm.pow_const 2).mul ((hYm n).pow_const 2) |>.aestronglyMeasurable)
          filter_upwards with ω
          change ‖S ω ^ 2 * Y n ω ^ 2‖ ≤ S ω ^ 4 + Y n ω ^ 4
          have hSa : S ω ^ 4 = |S ω| ^ 4 := by rw [← abs_pow, abs_of_nonneg (by positivity)]
          have hYa : Y n ω ^ 4 = |Y n ω| ^ 4 := by rw [← abs_pow, abs_of_nonneg (by positivity)]
          rw [hSa, hYa]
          simp only [Real.norm_eq_abs, abs_mul, abs_pow]
          change |S ω| ^ 2 * |Y n ω| ^ 2 ≤ |S ω| ^ 4 + |Y n ω| ^ 4
          nlinarith [sq_nonneg (|S ω| ^ 2 - |Y n ω| ^ 2)]
        have e13 : Integrable (fun ω => S ω * Y n ω ^ 3) P := by
          apply (eS4.add eY4).mono' (hSm.mul ((hYm n).pow_const 3) |>.aestronglyMeasurable)
          filter_upwards with ω
          change ‖S ω * Y n ω ^ 3‖ ≤ S ω ^ 4 + Y n ω ^ 4
          have hSa : S ω ^ 4 = |S ω| ^ 4 := by rw [← abs_pow, abs_of_nonneg (by positivity)]
          have hYa : Y n ω ^ 4 = |Y n ω| ^ 4 := by rw [← abs_pow, abs_of_nonneg (by positivity)]
          rw [hSa, hYa]
          simp only [Real.norm_eq_abs, abs_mul, abs_pow]
          change |S ω| * |Y n ω| ^ 3 ≤ |S ω| ^ 4 + |Y n ω| ^ 4
          have hz : 0 ≤ (|Y n ω| - |S ω|) ^ 2 *
              (3 * |Y n ω| ^ 2 + 2 * |Y n ω| * |S ω| + |S ω| ^ 2) := by positivity
          nlinarith
        have e31c := e31.const_mul 4
        have e22c := e22.const_mul 6
        have e13c := e13.const_mul 4
        have h1 := integral_add eS4 e31c
        have h2 := integral_add (eS4.add e31c) e22c
        have h3 := integral_add ((eS4.add e31c).add e22c) e13c
        have h4 := integral_add (((eS4.add e31c).add e22c).add e13c) eY4
        have c31 := integral_const_mul (μ := P) 4 (fun ω => S ω ^ 3 * Y n ω)
        have c22 := integral_const_mul (μ := P) 6 (fun ω => S ω ^ 2 * Y n ω ^ 2)
        have c13 := integral_const_mul (μ := P) 4 (fun ω => S ω * Y n ω ^ 3)
        calc
          _ = (∫ ω, S ω ^ 4 + 4 * (S ω ^ 3 * Y n ω) +
                6 * (S ω ^ 2 * Y n ω ^ 2) + 4 * (S ω * Y n ω ^ 3) ∂P) +
                ∫ ω, Y n ω ^ 4 ∂P := by simpa only [Pi.add_apply] using h4
          _ = ((∫ ω, S ω ^ 4 + 4 * (S ω ^ 3 * Y n ω) +
                6 * (S ω ^ 2 * Y n ω ^ 2) ∂P) +
                ∫ ω, 4 * (S ω * Y n ω ^ 3) ∂P) + ∫ ω, Y n ω ^ 4 ∂P := by exact congrArg (fun z => z + ∫ ω, Y n ω ^ 4 ∂P) h3
          _ = (((∫ ω, S ω ^ 4 + 4 * (S ω ^ 3 * Y n ω) ∂P) +
                ∫ ω, 6 * (S ω ^ 2 * Y n ω ^ 2) ∂P) +
                ∫ ω, 4 * (S ω * Y n ω ^ 3) ∂P) + ∫ ω, Y n ω ^ 4 ∂P := by exact congrArg (fun z => z + (∫ ω, 4 * (S ω * Y n ω ^ 3) ∂P) + ∫ ω, Y n ω ^ 4 ∂P) h2
          _ = _ := by rw [show (∫ ω, S ω ^ 4 + 4 * (S ω ^ 3 * Y n ω) ∂P) =
              (∫ ω, S ω ^ 4 ∂P) + ∫ ω, 4 * (S ω ^ 3 * Y n ω) ∂P by
                simpa only [Pi.add_apply] using h1, c31, c22, c13]
      have hSzero : ∫ ω, S ω ∂P = 0 := by
        dsimp [S, thm_11_7_partialSum]
        have hs := integral_finsetSum (Finset.range n) (fun i _ => ((hYfin i).memLp (by norm_num)).integrable (by norm_num))
        simpa only [Finset.sum_apply, hYzero, Finset.sum_const_zero] using hs
      have f31 := factor 3 1
      simp only [pow_one] at f31
      have f13 := factor 1 3
      simp only [pow_one] at f13
      rw [hexpand, f31, hYzero n, mul_zero, factor 2 2, f13, hSzero, zero_mul, mul_zero]
      have h2 := second_moment_bound P Y hYm hYfin hYzero hInd D hY4 n
      have hY2 : ∫ ω, Y n ω ^ 2 ∂P ≤ D + 1 := by
        calc
          ∫ ω, Y n ω ^ 2 ∂P ≤ ∫ ω, Y n ω ^ 4 + 1 ∂P := by
            apply integral_mono
            · exact integrable_pow_of_memLp_four hYn4 2 (by norm_num)
            · exact (integrable_pow_of_memLp_four hYn4 4 le_rfl).add (integrable_const _)
            · intro ω; nlinarith [sq_nonneg (Y n ω ^ 2 - 1)]
          _ = (∫ ω, Y n ω ^ 4 ∂P) + 1 := by
            rw [integral_add, integral_const, measureReal_univ_eq_one, one_smul]
            exact integrable_pow_of_memLp_four hYn4 4 le_rfl
            exact integrable_const _
          _ ≤ D + 1 := by linarith [hY4 n]
      have hS2nonneg : 0 ≤ ∫ ω, S ω ^ 2 ∂P := integral_nonneg (fun _ => sq_nonneg _)
      have hY2nonneg : 0 ≤ ∫ ω, Y n ω ^ 2 ∂P := integral_nonneg (fun _ => sq_nonneg _)
      have hB : 0 ≤ D + 1 := by linarith
      have hprod : (∫ ω, S ω ^ 2 ∂P) * (∫ ω, Y n ω ^ 2 ∂P) ≤
          (n : ℝ) * (D + 1) ^ 2 := by nlinarith
      push_cast at *
      nlinarith [hY4 n, hprod]

private lemma centered_tail_bound {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (Y : ℕ → Ω → ℝ)
    (hYm : ∀ i, Measurable (Y i)) (hYfin : ∀ i, FiniteAbsMoment P (Y i) 4)
    (hYzero : ∀ i, ∫ ω, Y i ω ∂P = 0) (hInd : iIndepFun Y P)
    (D : ℝ) (hD : 0 ≤ D) (hY4 : ∀ i, ∫ ω, Y i ω ^ 4 ∂P ≤ D)
    (ε : ℝ) (hε : 0 < ε) (n : ℕ) :
    P {ω | |thm_11_7_partialSum Y (n + 1) ω / (n + 1 : ℝ)| > ε} ≤
      ENNReal.ofReal ((D + 3 * (D + 1) ^ 2) /
        (((n + 1 : ℕ) : ℝ) ^ 2 * ε ^ 4)) := by
  let N : ℝ := (n + 1 : ℕ)
  let S := thm_11_7_partialSum Y (n + 1)
  let A : Set Ω := {ω | |S ω / N| > ε}
  let B : Set Ω := {ω | (N * ε) ^ 4 ≤ S ω ^ 4}
  have hN : 0 < N := by dsimp [N]; positivity
  have hsub : A ⊆ B := by
    intro ω hω
    simp only [A, B, Set.mem_setOf_eq] at hω ⊢
    rw [abs_div, abs_of_pos hN] at hω
    have habs : N * ε < |S ω| := (lt_div_iff₀' hN).mp hω
    have hp := pow_le_pow_left₀ (mul_nonneg hN.le hε.le) habs.le 4
    have hsabs : S ω ^ 4 = |S ω| ^ 4 := by rw [← abs_pow, abs_of_nonneg (by positivity)]
    rw [hsabs]
    exact hp
  have hSint : Integrable (fun ω => S ω ^ 4) P :=
    integrable_pow_of_memLp_four
      (partialSum_memLp_four Y (fun i => (hYfin i).memLp (by norm_num)) (n + 1)) 4 le_rfl
  have hmarkov : (N * ε) ^ 4 * P.real B ≤ ∫ ω, S ω ^ 4 ∂P :=
    mul_meas_ge_le_integral_of_nonneg (ae_of_all _ fun _ => by positivity) hSint _
  have hmom := fourth_moment_bound P Y hYm hYfin hYzero hInd D hD hY4 (n + 1)
  have hcoarse : ∫ ω, S ω ^ 4 ∂P ≤ (D + 3 * (D + 1) ^ 2) * N ^ 2 := by
    dsimp [S, N] at hmom ⊢
    push_cast at hmom ⊢
    nlinarith [sq_nonneg (n : ℝ), sq_nonneg (D + 1)]
  have hrealB : P.real B ≤ (D + 3 * (D + 1) ^ 2) / (N ^ 2 * ε ^ 4) := by
    calc
      P.real B ≤ (∫ ω, S ω ^ 4 ∂P) / (N * ε) ^ 4 :=
        (le_div_iff₀' (by positivity : 0 < (N * ε) ^ 4)).2 hmarkov
      _ ≤ ((D + 3 * (D + 1) ^ 2) * N ^ 2) / (N * ε) ^ 4 :=
        div_le_div_of_nonneg_right hcoarse (by positivity)
      _ = _ := by field_simp
  have hrealA : P.real A ≤ (D + 3 * (D + 1) ^ 2) / (N ^ 2 * ε ^ 4) :=
    (measureReal_mono hsub).trans hrealB
  have hout : P A ≤ ENNReal.ofReal ((D + 3 * (D + 1) ^ 2) / (N ^ 2 * ε ^ 4)) := by
    rw [← ENNReal.ofReal_toReal (measure_ne_top P A)]
    exact ENNReal.ofReal_le_ofReal hrealA
  simpa [A, S, N, Nat.cast_add, Nat.cast_one] using hout

private lemma centered_averages_converge {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) [IsProbabilityMeasure P] (Y : ℕ → Ω → ℝ)
    (hYm : ∀ i, Measurable (Y i)) (hYfin : ∀ i, FiniteAbsMoment P (Y i) 4)
    (hYzero : ∀ i, ∫ ω, Y i ω ∂P = 0) (hInd : iIndepFun Y P)
    (D : ℝ) (hD : 0 ≤ D) (hY4 : ∀ i, ∫ ω, Y i ω ^ 4 ∂P ≤ D) :
    ConvergesAlmostSurely P
      (fun n ω => thm_11_7_partialSum Y (n + 1) ω / (n + 1 : ℝ)) (fun _ => 0) := by
  apply (thm_10_1 P _ _).2
  refine ⟨fun n => ((partialSum_measurable Y hYm (n + 1)).div_const _).aestronglyMeasurable,
    measurable_const.aestronglyMeasurable, ?_⟩
  intro ε hε
  let A : ℕ → Set Ω := fun n =>
    {ω | |thm_11_7_partialSum Y (n + 1) ω / (n + 1 : ℝ)| > ε}
  let K := D + 3 * (D + 1) ^ 2
  have hs : Summable (fun n : ℕ => K / (((n : ℝ) + 1) ^ 2 * ε ^ 4)) := by
    have hp : Summable (fun n : ℕ => 1 / ((n : ℝ) + 1) ^ 2) := by
      simpa [abs_of_nonneg (by positivity : ∀ n : ℕ, 0 ≤ (n : ℝ) + 1)] using
        (Real.summable_one_div_nat_add_rpow 1 2).2 (by norm_num)
    apply (hp.mul_left (K / ε ^ 4)).congr
    intro n
    field_simp
  have htsum : (∑' n, P (A n)) ≠ ∞ := by
    apply ne_top_of_le_ne_top hs.tsum_ofReal_ne_top
    apply ENNReal.tsum_le_tsum
    intro n
    simpa [A, K, Nat.cast_add, Nat.cast_one, add_comm] using
      centered_tail_bound P Y hYm hYfin hYzero hInd D hD hY4 ε hε n
  simpa [deviationInfinitelyOften, almostSureDeviationEvent, A] using thm_5_8 P A htsum

theorem thm_11_7 {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω)
    [IsProbabilityMeasure P] (X : ℕ → Ω → ℝ) (m c : ℝ)
    (hX4 : ∀ i, FiniteAbsMoment P (X i) 4)
    (hInd : iIndepFun X P) (hmean : ∀ i, ∫ ω, X i ω ∂P = m)
    (hmom : ∀ i, ∫ ω, X i ω ^ 4 ∂P ≤ c) :
    ConvergesAlmostSurely P (thm_11_7_sampleMean X) (fun _ => m) := by
  let Y := thm_11_7_center X m
  let D := 8 * (c + |m| ^ 4)
  have hYm : ∀ i, Measurable (Y i) := fun i => (hX4 i).1.sub measurable_const
  have hYfin : ∀ i, FiniteAbsMoment P (Y i) 4 :=
    fun i => thm_11_7_center_finite P X m hX4 i
  have hYzero : ∀ i, ∫ ω, Y i ω ∂P = 0 := by
    intro i
    rw [show Y i = fun ω => X i ω - m by rfl, integral_sub,
      integral_const, measureReal_univ_eq_one, one_smul, hmean i, sub_self]
    exact ((hX4 i).memLp (by norm_num)).integrable (by norm_num)
    exact integrable_const _
  have hYind : iIndepFun Y P := thm_11_7_center_independent X m hInd
  have hY4 : ∀ i, ∫ ω, Y i ω ^ 4 ∂P ≤ D :=
    fun i => thm_11_7_center_fourth_bound P X m c hX4 hmom i
  have hD : 0 ≤ D := by
    have hc : 0 ≤ c := le_trans (integral_nonneg fun ω => by positivity) (hmom 0)
    dsimp [D]
    positivity
  have hconv := centered_averages_converge P Y hYm hYfin hYzero hYind D hD hY4
  refine ⟨fun n => ?_, measurable_const.aestronglyMeasurable, ?_⟩
  · exact ((Finset.measurable_sum (Finset.range (n + 1)) fun i _ => (hX4 i).1).div_const _).aestronglyMeasurable
  · filter_upwards [hconv.2.2] with ω hω
    have heq : ∀ n, thm_11_7_sampleMean X n ω =
        thm_11_7_partialSum Y (n + 1) ω / (n + 1 : ℝ) + m := by
      intro n
      simp only [thm_11_7_sampleMean, Y, thm_11_7_partialSum, thm_11_7_center,
        Finset.sum_apply]
      change (∑ i ∈ Finset.range (n + 1), X i ω) / (n + 1 : ℝ) =
        (∑ i ∈ Finset.range (n + 1), (X i ω - m)) / (n + 1 : ℝ) + m
      rw [Finset.sum_sub_distrib]
      simp [Finset.card_range]
      field_simp
      ring
    simpa only [heq, zero_add] using hω.add_const m
