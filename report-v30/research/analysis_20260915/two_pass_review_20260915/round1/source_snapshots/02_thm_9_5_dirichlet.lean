import Mathlib

open Filter MeasureTheory Set
open scoped Interval Topology

namespace ProbabilityTheory

/-- The primitive of `sinc` used in the Dirichlet integral. -/
noncomputable def sincPrimitive (T : ℝ) : ℝ := ∫ u in 0..T, Real.sinc u

private theorem sinc_eq_sin_div {x : ℝ} (hx : 0 < x) :
    Real.sinc x = x⁻¹ * Real.sin x := by
  rw [Real.sinc_of_ne_zero hx.ne']
  rw [div_eq_mul_inv, mul_comm]

private theorem sinc_tail_identity {a b : ℝ} (ha : 0 < a) (hab : a ≤ b) :
    (∫ x in a..b, Real.sinc x) =
      Real.cos a * a⁻¹ - Real.cos b * b⁻¹ -
        ∫ x in a..b, (-(x ^ 2)⁻¹) * (-Real.cos x) := by
  calc
    (∫ x in a..b, Real.sinc x) = ∫ x in a..b, x⁻¹ * Real.sin x := by
      apply intervalIntegral.integral_congr
      intro x hx
      exact sinc_eq_sin_div (ha.trans_le (by rw [uIcc_of_le hab] at hx; exact hx.1))
    _ = b⁻¹ * (-Real.cos b) - a⁻¹ * (-Real.cos a) -
        ∫ x in a..b, (-(x ^ 2)⁻¹) * (-Real.cos x) := by
      exact intervalIntegral.integral_mul_deriv_eq_deriv_mul
        (u := fun x : ℝ ↦ x⁻¹) (u' := fun x : ℝ ↦ -(x ^ 2)⁻¹)
        (v := -Real.cos) (v' := Real.sin)
        (fun x hx ↦ hasDerivAt_inv (ne_of_gt
          (ha.trans_le (by rw [uIcc_of_le hab] at hx; exact hx.1))))
        (fun x _ ↦ by simpa using (Real.hasDerivAt_cos x).neg)
        (((continuousOn_id.pow 2).inv₀ (fun x hx ↦ pow_ne_zero 2 <|
          ne_of_gt (ha.trans_le (by rw [uIcc_of_le hab] at hx; exact hx.1)))).neg.intervalIntegrable)
        (Real.continuous_sin.intervalIntegrable a b)
    _ = _ := by ring

theorem sinc_tail_bound {a b : ℝ} (ha : 0 < a) (hab : a ≤ b) :
    |∫ x in a..b, Real.sinc x| ≤ 3 / a := by
  rw [sinc_tail_identity ha hab]
  calc
    |Real.cos a * a⁻¹ - Real.cos b * b⁻¹ -
        ∫ x in a..b, (-(x ^ 2)⁻¹) * (-Real.cos x)|
        ≤ |Real.cos a * a⁻¹| + |Real.cos b * b⁻¹| +
            |∫ x in a..b, (-(x ^ 2)⁻¹) * (-Real.cos x)| := by
          linarith [abs_sub (Real.cos a * a⁻¹ - Real.cos b * b⁻¹)
            (∫ x in a..b, (-(x ^ 2)⁻¹) * (-Real.cos x)),
            abs_sub (Real.cos a * a⁻¹) (Real.cos b * b⁻¹)]
    _ ≤ a⁻¹ + b⁻¹ + ∫ x in a..b, (x ^ 2)⁻¹ := by
      gcongr
      · rw [abs_mul, abs_inv, abs_of_pos ha]
        simpa using mul_le_mul_of_nonneg_right (Real.abs_cos_le_one a) (inv_nonneg.mpr ha.le)
      · have hb : 0 < b := ha.trans_le hab
        rw [abs_mul, abs_inv, abs_of_pos hb]
        simpa using mul_le_mul_of_nonneg_right (Real.abs_cos_le_one b) (inv_nonneg.mpr hb.le)
      · calc
          |∫ x in a..b, (-(x ^ 2)⁻¹) * (-Real.cos x)|
              ≤ ∫ x in a..b, |(-(x ^ 2)⁻¹) * (-Real.cos x)| :=
                intervalIntegral.abs_integral_le_integral_abs hab
          _ ≤ ∫ x in a..b, (x ^ 2)⁻¹ := by
            apply intervalIntegral.integral_mono_on hab
            · exact ((((continuousOn_id.pow 2).inv₀ fun x hx ↦ pow_ne_zero 2 <|
                ne_of_gt (ha.trans_le (by rw [uIcc_of_le hab] at hx; exact hx.1))).neg.mul
                Real.continuous_cos.neg.continuousOn).abs.intervalIntegrable)
            · exact (((continuousOn_id.pow 2).inv₀ fun x hx ↦ pow_ne_zero 2 <|
                ne_of_gt (ha.trans_le (by rw [uIcc_of_le hab] at hx; exact hx.1))).intervalIntegrable)
            intro x hx
            rw [abs_mul, abs_neg, abs_neg, abs_inv, abs_sq]
            exact mul_le_of_le_one_right (inv_nonneg.mpr (sq_nonneg x))
              (Real.abs_cos_le_one x)
    _ = a⁻¹ + b⁻¹ + (a⁻¹ - b⁻¹) := by
      rw [show (∫ x in a..b, (x ^ 2)⁻¹) = a⁻¹ - b⁻¹ by
        convert integral_zpow (a := a) (b := b) (n := (-2 : ℤ))
          (Or.inr ⟨by norm_num, by
            intro h
            rw [uIcc_of_le hab] at h
            exact ha.not_ge h.1⟩) using 1 <;>
          norm_num [zpow_neg, ha.ne', (ha.trans_le hab).ne'] <;> field_simp <;> ring]
    _ = 2 / a := by field_simp; ring
    _ ≤ 3 / a := by exact div_le_div_of_nonneg_right (by norm_num) ha.le

private theorem sincPrimitive_cauchy : CauchySeq sincPrimitive := by
  change Cauchy (Filter.map sincPrimitive atTop)
  rw [Metric.cauchy_iff]
  refine ⟨inferInstance, fun ε hε ↦ ?_⟩
  obtain ⟨A, hA, hAε⟩ : ∃ A : ℝ, 0 < A ∧ 3 / A < ε := by
    refine ⟨max 1 (4 / ε), lt_of_lt_of_le zero_lt_one (le_max_left _ _), ?_⟩
    have hmax : 4 / ε ≤ max 1 (4 / ε) := le_max_right _ _
    have h4 : 0 < 4 / ε := div_pos (by norm_num) hε
    calc
      3 / max 1 (4 / ε) ≤ 3 / (4 / ε) := by gcongr
      _ = 3 * ε / 4 := by field_simp
      _ < ε := by linarith
  refine ⟨sincPrimitive '' Ici A, ?_, ?_⟩
  · change sincPrimitive ⁻¹' (sincPrimitive '' Ici A) ∈ atTop
    exact Filter.mem_of_superset (Ici_mem_atTop A) fun x hx ↦ ⟨x, hx, rfl⟩
  rintro _ ⟨a, ha, rfl⟩ _ ⟨b, hb, rfl⟩
  wlog hab : a ≤ b generalizing a b
  · simpa [dist_comm] using this b hb a ha (le_of_not_ge hab)
  rw [Real.dist_eq, sincPrimitive, sincPrimitive,
    ← intervalIntegral.integral_add_adjacent_intervals
      (Real.continuous_sinc.intervalIntegrable 0 a)
      (Real.continuous_sinc.intervalIntegrable a b)]
  simpa only [sub_add_eq_sub_sub, sub_self, zero_sub, abs_neg] using
    (sinc_tail_bound (hA.trans_le ha) hab).trans_lt
      ((div_le_div_of_nonneg_left (by norm_num) hA (show A ≤ a from ha)).trans_lt hAε)

/-- The Dirichlet primitive has a finite limit at `+∞`. -/
theorem exists_tendsto_sincPrimitive :
    ∃ L : ℝ, Tendsto sincPrimitive atTop (𝓝 L) :=
  cauchySeq_tendsto_of_complete sincPrimitive_cauchy

private theorem sinc_eq_integral_cos (x : ℝ) :
    Real.sinc x = ∫ t in 0..1, Real.cos (t * x) := by
  by_cases hx : x = 0
  · simp [hx]
  rw [Real.sinc_of_ne_zero hx]
  have h := intervalIntegral.smul_integral_comp_mul_right
    (f := Real.cos) (a := 0) (b := 1) x
  simp only [smul_eq_mul, zero_mul, one_mul, integral_cos, Real.sin_zero, sub_zero] at h
  exact (div_eq_iff hx).2 (by simpa [mul_comm] using h.symm)

private theorem integral_exp_mul_cos_Ioi {a t : ℝ} (ha : 0 < a) :
    (∫ x in Ioi 0, Real.exp (-a * x) * Real.cos (t * x)) = a / (a ^ 2 + t ^ 2) := by
  have hc : ((-a : ℂ) + t * Complex.I).re < 0 := by simpa using neg_lt_zero.mpr ha
  have hi := integrableOn_exp_mul_complex_Ioi hc 0
  calc
    (∫ x in Ioi 0, Real.exp (-a * x) * Real.cos (t * x)) =
        ∫ (x : ℝ) in Ioi 0, (Complex.exp (((-a : ℂ) + t * Complex.I) * (x : ℂ))).re := by
          apply integral_congr_ae
          filter_upwards with x
          rw [Complex.exp_re]
          simp
    _ = (∫ (x : ℝ) in Ioi 0, Complex.exp (((-a : ℂ) + t * Complex.I) * (x : ℂ))).re :=
      integral_re hi
    _ = a / (a ^ 2 + t ^ 2) := by
      rw [integral_exp_mul_complex_Ioi hc]
      simp [Complex.div_re]
      rw [Complex.normSq_apply]
      simp
      field_simp [ne_of_gt (add_pos_of_pos_of_nonneg (sq_pos_of_pos ha) (sq_nonneg t))]

private theorem integral_damped_sinc {a : ℝ} (ha : 0 < a) :
    (∫ x in Ioi 0, Real.exp (-a * x) * Real.sinc x) = Real.arctan (1 / a) := by
  let μ : Measure ℝ := volume.restrict (Ioc 0 1)
  let ν : Measure ℝ := volume.restrict (Ioi 0)
  have he : Integrable (fun x : ℝ ↦ Real.exp (-a * x)) ν := by
    change IntegrableOn (fun x : ℝ ↦ Real.exp (-a * x)) (Ioi 0)
    convert integrableOn_exp_mul_Ioi (neg_lt_zero.mpr ha) 0 using 1
  have hprod : Integrable
      (fun z : ℝ × ℝ ↦ Real.exp (-a * z.1) * Real.cos (z.2 * z.1)) (ν.prod μ) := by
    apply (he.mul_prod
      (integrableOn_const (C := (1 : ℝ)) (measure_Ioc_lt_top.ne))).mono
    · fun_prop
    filter_upwards with z
    simp only [Real.norm_eq_abs, abs_mul, Real.abs_exp, one_mul]
    simpa only [abs_one] using
      mul_le_mul_of_nonneg_left (Real.abs_cos_le_one _) (Real.exp_pos _).le
  calc
    (∫ x in Ioi 0, Real.exp (-a * x) * Real.sinc x)
        = ∫ x, ∫ t, Real.exp (-a * x) * Real.cos (t * x) ∂μ ∂ν := by
          apply integral_congr_ae
          filter_upwards with x
          rw [sinc_eq_integral_cos, intervalIntegral.integral_of_le zero_le_one,
            integral_const_mul]
    _ = ∫ t, ∫ x, Real.exp (-a * x) * Real.cos (t * x) ∂ν ∂μ :=
      integral_integral_swap hprod
    _ = ∫ t in Ioc 0 1, a / (a ^ 2 + t ^ 2) := by
      apply integral_congr_ae
      filter_upwards with t
      exact integral_exp_mul_cos_Ioi ha
    _ = Real.arctan (1 / a) := by
      rw [← intervalIntegral.integral_of_le zero_le_one, integral_div_sq_add_sq]
      simp [ha.ne', one_div]


theorem sincPrimitive_neg (T : ℝ) : sincPrimitive (-T) = -sincPrimitive T := by
  have h : (∫ x in -T..0, Real.sinc x) = ∫ x in 0..T, Real.sinc x := by
    symm
    calc
      (∫ x in 0..T, Real.sinc x) = ∫ x in 0..T, Real.sinc (-x) := by
        apply intervalIntegral.integral_congr
        intro x _
        exact (Real.sinc_neg x).symm
      _ = ∫ x in -T..0, Real.sinc x := by
        simpa using (intervalIntegral.integral_comp_neg (a := 0) (b := T) Real.sinc)
  rw [sincPrimitive, sincPrimitive, intervalIntegral.integral_symm]
  exact congrArg Neg.neg h

private theorem abs_sincPrimitive_le_four_of_nonneg {T : ℝ} (hT : 0 ≤ T) :
    |sincPrimitive T| ≤ 4 := by
  rcases le_total T 1 with hT1 | h1T
  · calc
      |sincPrimitive T| ≤ ∫ x in 0..T, |Real.sinc x| := by
        exact intervalIntegral.abs_integral_le_integral_abs hT
      _ ≤ ∫ _x in 0..T, (1 : ℝ) := by
        apply intervalIntegral.integral_mono_on hT
        · exact Real.continuous_sinc.abs.intervalIntegrable 0 T
        · exact intervalIntegrable_const
        intro x _
        exact Real.abs_sinc_le_one x
      _ = T := by simp
      _ ≤ 4 := hT1.trans (by norm_num)
  · rw [sincPrimitive, ← intervalIntegral.integral_add_adjacent_intervals
      (Real.continuous_sinc.intervalIntegrable 0 1)
      (Real.continuous_sinc.intervalIntegrable 1 T)]
    calc
      |(∫ x in 0..1, Real.sinc x) + ∫ x in 1..T, Real.sinc x| ≤
          |∫ x in 0..1, Real.sinc x| + |∫ x in 1..T, Real.sinc x| := abs_add_le _ _
      _ ≤ 1 + 3 := add_le_add
        (by
          calc
            |∫ x in 0..1, Real.sinc x| ≤ ∫ x in 0..1, |Real.sinc x| :=
              intervalIntegral.abs_integral_le_integral_abs zero_le_one
            _ ≤ ∫ _x in 0..1, (1 : ℝ) := by
              apply intervalIntegral.integral_mono_on zero_le_one
              · exact Real.continuous_sinc.abs.intervalIntegrable 0 1
              · exact intervalIntegrable_const
              intro x _
              exact Real.abs_sinc_le_one x
            _ = 1 := by simp)
        (by simpa using sinc_tail_bound zero_lt_one h1T)
      _ = 4 := by norm_num

theorem abs_sincPrimitive_le_four (T : ℝ) : |sincPrimitive T| ≤ 4 := by
  rcases le_total 0 T with hT | hT
  · exact abs_sincPrimitive_le_four_of_nonneg hT
  · rw [← abs_neg (sincPrimitive T), ← sincPrimitive_neg]
    exact abs_sincPrimitive_le_four_of_nonneg (neg_nonneg.mpr hT)

/-- The Dirichlet primitive is globally bounded, with a concrete uniform bound. -/
theorem bounded_sincPrimitive : ∃ C : ℝ, ∀ T : ℝ, |sincPrimitive T| ≤ C :=
  ⟨4, abs_sincPrimitive_le_four⟩

/-- The same global bound, stated without the auxiliary definition. -/
theorem bounded_integral_sinc :
    ∃ C : ℝ, ∀ T : ℝ, |∫ u in 0..T, Real.sinc u| ≤ C := by
  simpa [sincPrimitive] using bounded_sincPrimitive

theorem continuous_sincPrimitive : Continuous sincPrimitive := by
  rw [continuous_iff_continuousAt]
  intro x
  exact (intervalIntegral.integral_hasDerivAt_right
    (Real.continuous_sinc.intervalIntegrable 0 x)
    (Real.continuous_sinc.stronglyMeasurableAtFilter volume (𝓝 x))
    Real.continuous_sinc.continuousAt).continuousAt

private theorem integral_damped_sinc_eq_primitive {a : ℝ} (ha : 0 < a) :
    (∫ x in Ioi 0, Real.exp (-a * x) * Real.sinc x) =
      ∫ x in Ioi 0, a * Real.exp (-a * x) * sincPrimitive x := by
  have he : IntegrableOn (fun x : ℝ ↦ Real.exp (-a * x)) (Ioi 0) := by
    convert integrableOn_exp_mul_Ioi (neg_lt_zero.mpr ha) 0 using 1
  have huv' : IntegrableOn
      (fun x : ℝ ↦ Real.exp (-a * x) * Real.sinc x) (Ioi 0) := by
    change Integrable (fun x : ℝ ↦ Real.exp (-a * x) * Real.sinc x)
      (volume.restrict (Ioi 0))
    apply Integrable.mono he
    · fun_prop
    filter_upwards with x
    simp only [Real.norm_eq_abs, abs_mul, Real.abs_exp]
    exact mul_le_of_le_one_right (Real.exp_pos _).le (Real.abs_sinc_le_one x)
  have hu'v : IntegrableOn
      (fun x : ℝ ↦ (-a * Real.exp (-a * x)) * sincPrimitive x) (Ioi 0) := by
    change Integrable (fun x : ℝ ↦ (-a * Real.exp (-a * x)) * sincPrimitive x)
      (volume.restrict (Ioi 0))
    apply Integrable.mono (he.const_mul (4 * a))
    · exact ((continuous_const.mul
        (Real.continuous_exp.comp (continuous_const.mul continuous_id))).mul
          continuous_sincPrimitive).aestronglyMeasurable
    filter_upwards with x
    norm_num [Real.norm_eq_abs, abs_mul, Real.abs_exp, abs_of_pos ha]
    calc
      a * Real.exp (-(a * x)) * |sincPrimitive x| ≤
          a * Real.exp (-(a * x)) * 4 := by
        gcongr
        exact abs_sincPrimitive_le_four x
      _ = 4 * a * Real.exp (-(a * x)) := by ring
  have hzero : Tendsto
      (fun x : ℝ ↦ Real.exp (-a * x) * sincPrimitive x) (𝓝[>] 0) (𝓝 0) := by
    have hc : Continuous (fun x : ℝ ↦ Real.exp (-a * x) * sincPrimitive x) := by
      apply Continuous.mul
      · fun_prop
      · exact continuous_sincPrimitive
    have ht : Tendsto (fun x : ℝ ↦ Real.exp (-a * x) * sincPrimitive x)
        (𝓝[>] 0) (𝓝 (Real.exp (-a * 0) * sincPrimitive 0)) :=
      hc.continuousAt.tendsto.mono_left inf_le_left
    simpa [sincPrimitive] using ht
  have hinfty : Tendsto
      (fun x : ℝ ↦ Real.exp (-a * x) * sincPrimitive x) atTop (𝓝 0) := by
    rw [tendsto_zero_iff_norm_tendsto_zero]
    have ht : Tendsto (fun x : ℝ ↦ 4 * Real.exp (-a * x)) atTop (𝓝 0) := by
      convert (tendsto_const_nhds (x := (4 : ℝ))).mul
        (Real.tendsto_exp_atBot.comp
          (tendsto_id.const_mul_atTop_of_neg (neg_lt_zero.mpr ha))) using 1 <;>
        simp [Function.comp_apply]
    apply squeeze_zero (fun x ↦ norm_nonneg _) (fun x ↦ ?_) ht
    rw [Real.norm_eq_abs, abs_mul, Real.abs_exp]
    calc
      Real.exp (-a * x) * |sincPrimitive x| ≤ Real.exp (-a * x) * 4 :=
        mul_le_mul_of_nonneg_left (abs_sincPrimitive_le_four x) (Real.exp_pos _).le
      _ = 4 * Real.exp (-a * x) := by ring
  have h := integral_Ioi_mul_deriv_eq_deriv_mul
    (u := fun x : ℝ ↦ Real.exp (-a * x))
    (u' := fun x ↦ -a * Real.exp (-a * x))
    (v := sincPrimitive) (v' := Real.sinc)
    (fun x _ ↦ by
      simpa only [mul_comm] using (hasDerivAt_const_mul (-a)).exp)
    (fun x _ ↦ intervalIntegral.integral_hasDerivAt_right
      (Real.continuous_sinc.intervalIntegrable 0 x)
      (Real.continuous_sinc.stronglyMeasurableAtFilter volume (𝓝 x))
      Real.continuous_sinc.continuousAt)
    huv' hu'v hzero hinfty
  rw [show (∫ x in Ioi 0, a * Real.exp (-a * x) * sincPrimitive x) =
    -(∫ x in Ioi 0, (-a * Real.exp (-a * x)) * sincPrimitive x) by
      rw [← integral_neg]
      apply integral_congr_ae
      filter_upwards with x
      simp]
  simpa [Pi.mul_apply] using h

private theorem integral_damped_sinc_inv_eq {r : ℝ} (hr : 0 < r) :
    (∫ x in Ioi 0, Real.exp (-r⁻¹ * x) * Real.sinc x) =
      ∫ y in Ioi 0, Real.exp (-y) * sincPrimitive (r * y) := by
  rw [integral_damped_sinc_eq_primitive (inv_pos.mpr hr)]
  calc
    (∫ x in Ioi 0, r⁻¹ * Real.exp (-r⁻¹ * x) * sincPrimitive x) =
        r⁻¹ * ∫ x in Ioi 0, Real.exp (-r⁻¹ * x) * sincPrimitive x := by
          simpa only [mul_assoc] using
            (integral_const_mul (μ := volume.restrict (Ioi 0)) r⁻¹
              (fun x : ℝ ↦ Real.exp (-r⁻¹ * x) * sincPrimitive x))
    _ = r⁻¹ * ∫ x in Ioi 0,
        (fun y ↦ Real.exp (-y) * sincPrimitive (r * y)) (r⁻¹ * x) := by
          congr 1
          apply integral_congr_ae
          filter_upwards with x
          congr 2
          · ring
          · rw [← mul_assoc, mul_inv_cancel₀ hr.ne', one_mul]
    _ = r⁻¹ * (r⁻¹)⁻¹ * ∫ y in Ioi 0,
        Real.exp (-y) * sincPrimitive (r * y) := by
          have hs := integral_comp_mul_left_Ioi
            (fun y ↦ Real.exp (-y) * sincPrimitive (r * y)) 0 (inv_pos.mpr hr)
          rw [hs, smul_eq_mul]
          ring
    _ = ∫ y in Ioi 0, Real.exp (-y) * sincPrimitive (r * y) := by
      rw [inv_inv, inv_mul_cancel₀ hr.ne', one_mul]

private theorem tendsto_abel_average {L : ℝ}
    (hL : Tendsto sincPrimitive atTop (𝓝 L)) :
    Tendsto (fun r : ℝ ↦ ∫ x in Ioi 0,
      Real.exp (-x) * sincPrimitive (r * x)) atTop (𝓝 L) := by
  have he : IntegrableOn (fun x : ℝ ↦ Real.exp (-x)) (Ioi 0) :=
    integrableOn_exp_neg_Ioi 0
  have hb : Integrable (fun x : ℝ ↦ 4 * Real.exp (-x))
      (volume.restrict (Ioi 0)) := he.const_mul 4
  have ht := tendsto_integral_filter_of_dominated_convergence
    (μ := volume.restrict (Ioi 0))
    (F := fun r x : ℝ ↦ Real.exp (-x) * sincPrimitive (r * x))
    (f := fun x : ℝ ↦ Real.exp (-x) * L)
    (bound := fun x : ℝ ↦ 4 * Real.exp (-x))
    (Eventually.of_forall fun r ↦ by
      exact (Real.continuous_exp.comp continuous_neg).aestronglyMeasurable.mul
        (continuous_sincPrimitive.comp (continuous_const.mul continuous_id)).aestronglyMeasurable)
    (Eventually.of_forall fun r ↦ Eventually.of_forall fun x ↦ by
      rw [Real.norm_eq_abs, abs_mul, Real.abs_exp]
      calc
        Real.exp (-x) * |sincPrimitive (r * x)| ≤ Real.exp (-x) * 4 :=
          mul_le_mul_of_nonneg_left (abs_sincPrimitive_le_four _) (Real.exp_pos _).le
        _ = 4 * Real.exp (-x) := by ring)
    hb
    (by
      filter_upwards [self_mem_ae_restrict measurableSet_Ioi] with x hx
      exact tendsto_const_nhds.mul (hL.comp (tendsto_id.atTop_mul_const hx)))
  have heq : (∫ x in Ioi 0, Real.exp (-x) * L) = L := by
    rw [integral_mul_const, integral_exp_neg_Ioi_zero, one_mul]
  simpa only [heq] using ht

/-- The Dirichlet integral has value `π / 2`. -/
theorem tendsto_sincPrimitive : Tendsto sincPrimitive atTop (𝓝 (Real.pi / 2)) := by
  obtain ⟨L, hL⟩ := exists_tendsto_sincPrimitive
  have hD : Tendsto (fun r : ℝ ↦
      ∫ x in Ioi 0, Real.exp (-r⁻¹ * x) * Real.sinc x) atTop (𝓝 L) := by
    apply (tendsto_abel_average hL).congr'
    filter_upwards [eventually_gt_atTop 0] with r hr
    exact (integral_damped_sinc_inv_eq hr).symm
  have hArctanL : Tendsto Real.arctan atTop (𝓝 L) := by
    apply hD.congr'
    filter_upwards [eventually_gt_atTop 0] with r hr
    rw [integral_damped_sinc (inv_pos.mpr hr), one_div, inv_inv]
  have hEq : L = Real.pi / 2 :=
    tendsto_nhds_unique hArctanL (Real.tendsto_arctan_atTop.mono_right inf_le_left)
  simpa only [hEq] using hL


end ProbabilityTheory
