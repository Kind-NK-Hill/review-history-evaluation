import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.Analysis.SpecialFunctions.ImproperIntegrals
import Mathlib.MeasureTheory.Integral.IntervalIntegral.IntegrationByParts

open Filter MeasureTheory Set
open scoped Interval Topology

namespace DirichletIntegral

/-- The continuous extension of `sin x / x` at the origin. -/
noncomputable def primitive (T : ℝ) : ℝ :=
  ∫ u in 0..T, Real.sinc u

lemma integrand_eq_sinc :
    (fun u : ℝ ↦ if u = 0 then 1 else Real.sin u / u) = Real.sinc := by
  rfl

lemma continuous_primitive : Continuous primitive := by
  unfold primitive
  fun_prop

lemma primitive_sub (a b : ℝ) :
    primitive b - primitive a = ∫ u in a..b, Real.sinc u := by
  simp only [primitive]
  rw [← intervalIntegral.integral_add_adjacent_intervals (b := a)
    (Real.continuous_sinc.intervalIntegrable 0 a)
    (Real.continuous_sinc.intervalIntegrable a b)]
  ring

lemma primitive_neg (T : ℝ) : primitive (-T) = -primitive T := by
  unfold primitive
  have h : (∫ x in 0..T, Real.sinc (-x)) = ∫ x in -T..0, Real.sinc x :=
    by simpa using (intervalIntegral.integral_comp_neg (a := 0) (b := T) Real.sinc)
  simp only [Real.sinc_neg] at h
  calc
    (∫ u in 0..-T, Real.sinc u) = -(∫ u in -T..0, Real.sinc u) :=
      intervalIntegral.integral_symm (-T) 0
    _ = -(∫ u in 0..T, Real.sinc u) := congrArg Neg.neg h.symm

private lemma sinc_tail_identity {a b : ℝ} (ha : 0 < a) (hab : a ≤ b) :
    (∫ x in a..b, Real.sinc x) =
      Real.cos a / a - Real.cos b / b - ∫ x in a..b, Real.cos x / x ^ 2 := by
  have hx0 : ∀ x ∈ uIcc a b, x ≠ 0 := by
    intro x hx
    have hxI : x ∈ Icc a b := by simpa [uIcc_of_le hab] using hx
    have hax : a ≤ x := hxI.1
    exact ne_of_gt (lt_of_lt_of_le ha hax)
  have hu : ∀ x ∈ uIcc a b,
      HasDerivAt (fun y : ℝ ↦ y⁻¹) (-x⁻¹ ^ 2) x := by
    intro x hx
    simpa using (hasDerivAt_inv (hx0 x hx))
  have hv : ∀ x ∈ uIcc a b,
      HasDerivAt (fun y : ℝ ↦ -Real.cos y) (Real.sin x) x := by
    intro x _
    simpa using (Real.hasDerivAt_cos x).const_sub 0
  have hparts := intervalIntegral.integral_mul_deriv_eq_deriv_mul hu hv
    ((ContinuousOn.neg ((continuousOn_id.inv₀ hx0).pow 2)).intervalIntegrable)
    (Real.continuous_sin.intervalIntegrable a b)
  rw [show (∫ x in a..b, Real.sinc x) = ∫ x in a..b, x⁻¹ * Real.sin x by
    apply intervalIntegral.integral_congr
    intro x hx
    rw [Real.sinc_of_ne_zero (hx0 x (by simpa [uIcc_of_le hab] using hx))]
    ring]
  rw [hparts]
  congr 1
  · ring
  · apply intervalIntegral.integral_congr
    intro x hx
    have hne := hx0 x (by simpa [uIcc_of_le hab] using hx)
    ring

lemma sinc_tail_bound {a b : ℝ} (ha : 0 < a) (hab : a ≤ b) :
    |∫ x in a..b, Real.sinc x| ≤ 3 / a := by
  have hb : 0 < b := lt_of_lt_of_le ha hab
  have hx0 : ∀ x ∈ uIcc a b, x ≠ 0 := by
    intro x hx
    have hxI : x ∈ Icc a b := by simpa [uIcc_of_le hab] using hx
    exact ne_of_gt (lt_of_lt_of_le ha hxI.1)
  have hpow : (∫ x in a..b, 1 / x ^ 2) = 1 / a - 1 / b := by
    calc
      (∫ x in a..b, 1 / x ^ 2) = ∫ x in a..b, x ^ (-2 : ℤ) := by
        apply intervalIntegral.integral_congr
        intro x hx
        have hne := hx0 x (by simpa [uIcc_of_le hab] using hx)
        norm_num [zpow_neg, zpow_two, hne, inv_pow]
        ring
      _ = (b ^ ((-2 : ℤ) + 1) - a ^ ((-2 : ℤ) + 1)) / ((-2 : ℤ) + 1) := by
        apply integral_zpow
        right
        constructor
        · norm_num
        · rw [uIcc_of_le hab]
          intro h
          exact (not_lt_of_ge h.1) ha
      _ = 1 / a - 1 / b := by
        norm_num [zpow_neg, ha.ne', hb.ne']
        field_simp
        ring
  have hcos : |∫ x in a..b, Real.cos x / x ^ 2| ≤ 1 / a - 1 / b := by
    calc
      |∫ x in a..b, Real.cos x / x ^ 2|
          ≤ ∫ x in a..b, |Real.cos x / x ^ 2| :=
            intervalIntegral.abs_integral_le_integral_abs hab
      _ ≤ ∫ x in a..b, 1 / x ^ 2 := by
        apply intervalIntegral.integral_mono_on hab
          (((Real.continuous_cos.continuousOn.div (continuousOn_id.pow 2)
            (fun x hx ↦ pow_ne_zero 2 (hx0 x hx))).abs).intervalIntegrable)
          ((continuousOn_const.div (continuousOn_id.pow 2)
            (fun x hx ↦ pow_ne_zero 2 (hx0 x hx))).intervalIntegrable)
        intro x hx
        have hxpos : 0 < x := lt_of_lt_of_le ha hx.1
        change |Real.cos x / x ^ 2| ≤ 1 / x ^ 2
        rw [abs_div, abs_pow, abs_of_pos hxpos]
        exact div_le_div_of_nonneg_right (Real.abs_cos_le_one x) (sq_nonneg x)
      _ = 1 / a - 1 / b := hpow
  rw [sinc_tail_identity ha hab]
  calc
    |Real.cos a / a - Real.cos b / b - ∫ x in a..b, Real.cos x / x ^ 2|
        ≤ |Real.cos a / a| + |Real.cos b / b| +
            |∫ x in a..b, Real.cos x / x ^ 2| := by
          grw [abs_sub, abs_sub]
    _ ≤ 1 / a + 1 / b + (1 / a - 1 / b) := by
      gcongr
      · simpa [abs_div, abs_of_pos ha] using
          (div_le_div_of_nonneg_right (Real.abs_cos_le_one a) ha.le)
      · simpa [abs_div, abs_of_pos hb] using
          (div_le_div_of_nonneg_right (Real.abs_cos_le_one b) hb.le)
    _ = 2 / a := by ring
    _ ≤ 3 / a := by
      apply div_le_div_of_nonneg_right (by norm_num) ha.le


/-- The Dirichlet truncations converge to some real number.  Identifying this
number with `π / 2` is the remaining Abelian (or Fourier inversion) step. -/
theorem exists_tendsto_primitive :
    ∃ L : ℝ, Tendsto primitive atTop (nhds L) := by
  rw [← cauchy_map_iff_exists_tendsto]
  rw [Metric.cauchy_iff]
  constructor
  · exact Filter.map_neBot
  · intro ε hε
    let A : ℝ := max 1 (3 / ε + 1)
    let s : Set ℝ := {z | ∃ x ≥ A, primitive x = z}
    refine ⟨s, ?_, ?_⟩
    · rw [Filter.mem_map]
      filter_upwards [eventually_ge_atTop A] with x hx
      exact ⟨x, hx, rfl⟩
    · intro x hx y hy
      rcases hx with ⟨X, hX, rfl⟩
      rcases hy with ⟨Y, hY, rfl⟩
      have hAX : 3 / ε + 1 ≤ X := le_trans (le_max_right _ _) hX
      have hAY : 3 / ε + 1 ≤ Y := le_trans (le_max_right _ _) hY
      have hXpos : 0 < X := lt_of_lt_of_le (by positivity : 0 < (1 : ℝ))
        (le_trans (le_max_left _ _) hX)
      have hYpos : 0 < Y := lt_of_lt_of_le (by positivity : 0 < (1 : ℝ))
        (le_trans (le_max_left _ _) hY)
      have hsmallX : 3 / X < ε := by
        rw [div_lt_iff₀ hXpos]
        have heq : 3 / ε * ε = 3 := by field_simp
        nlinarith
      have hsmallY : 3 / Y < ε := by
        rw [div_lt_iff₀ hYpos]
        have heq : 3 / ε * ε = 3 := by field_simp
        nlinarith
      rcases le_total X Y with hXY | hYX
      · rw [Real.dist_eq, abs_sub_comm, primitive_sub]
        exact lt_of_le_of_lt (sinc_tail_bound hXpos hXY) hsmallX
      · rw [Real.dist_eq, primitive_sub]
        exact lt_of_le_of_lt (sinc_tail_bound hYpos hYX) hsmallY


/-- Cauchy convergence in the notation of the requested integral. -/
theorem exists_tendsto_dirichlet_integral :
    ∃ L : ℝ, Tendsto
      (fun T : ℝ ↦ ∫ u in 0..T, if u = 0 then 1 else Real.sin u / u)
      atTop (nhds L) := by
  change ∃ L : ℝ, Tendsto primitive atTop (nhds L)
  exact exists_tendsto_primitive

private lemma abs_primitive_le_abs (T : ℝ) : |primitive T| ≤ |T| := by
  unfold primitive
  simpa using intervalIntegral.norm_integral_le_of_norm_le_const
    (f := Real.sinc) (a := 0) (b := T) (C := 1) (fun x _ ↦ Real.abs_sinc_le_one x)

private lemma abs_primitive_le_four_of_one_le {T : ℝ} (hT : 1 ≤ T) :
    |primitive T| ≤ 4 := by
  have hone : |primitive 1| ≤ 1 := by
    simpa using abs_primitive_le_abs 1
  have htail : |primitive T - primitive 1| ≤ 3 := by
    rw [primitive_sub]
    simpa using sinc_tail_bound (a := (1 : ℝ)) (b := T) (by norm_num) hT
  calc
    |primitive T| = |primitive 1 + (primitive T - primitive 1)| := by ring_nf
    _ ≤ |primitive 1| + |primitive T - primitive 1| := abs_add_le _ _
    _ ≤ 1 + 3 := add_le_add hone htail
    _ = 4 := by norm_num

/-- The truncated Dirichlet integral is uniformly bounded on the whole real
line.  The explicit constant is deliberately non-optimal. -/
theorem primitive_uniformly_bounded : ∀ T : ℝ, |primitive T| ≤ 4 := by
  intro T
  by_cases hpos : 1 ≤ T
  · exact abs_primitive_le_four_of_one_le hpos
  by_cases hneg : T ≤ -1
  · rw [← abs_neg (primitive T), ← primitive_neg]
    exact abs_primitive_le_four_of_one_le (by linarith)
  · exact (abs_primitive_le_abs T).trans (by rw [abs_le]; constructor <;> linarith)

/-- Uniform boundedness in exactly the removable-singularity notation used in
Dirichlet's integral. -/
theorem dirichlet_integral_uniformly_bounded :
    ∀ T : ℝ, |∫ u in 0..T, if u = 0 then 1 else Real.sin u / u| ≤ 4 := by
  simpa [integrand_eq_sinc, primitive] using primitive_uniformly_bounded

private lemma hasDerivAt_primitive (x : ℝ) :
    HasDerivAt primitive (Real.sinc x) x := by
  unfold primitive
  exact intervalIntegral.integral_hasDerivAt_right
    (Real.continuous_sinc.intervalIntegrable 0 x)
    (Real.continuous_sinc.stronglyMeasurableAtFilter volume (𝓝 x))
    Real.continuous_sinc.continuousAt

private lemma integral_cos_eq_sinc (x : ℝ) :
    (∫ t in 0..1, Real.cos (x * t)) = Real.sinc x := by
  by_cases hx : x = 0
  · simp [hx]
  rw [Real.sinc_of_ne_zero hx]
  apply (eq_div_iff hx).2
  calc
    (∫ t in 0..1, Real.cos (x * t)) * x =
        x * ∫ t in 0..1, Real.cos (x * t) := by ring
    _ = ∫ u in x * 0..x * 1, Real.cos u := by
      simpa using (intervalIntegral.integral_comp_mul_deriv (f := Real.cos)
        (a := 0) (b := 1) x)
    _ = Real.sin x := by simp

private lemma integral_exp_neg_mul_cos_Ioi {a : ℝ} (ha : 0 < a) (t : ℝ) :
    (∫ x in Ioi 0, Real.exp (-a * x) * Real.cos (t * x)) =
      a / (a ^ 2 + t ^ 2) := by
  let z : ℂ := -(a : ℂ) + (t : ℂ) * Complex.I
  have hz : z.re < 0 := by simp [z, ha]
  have hi := integrableOn_exp_mul_complex_Ioi hz 0
  have he := integral_exp_mul_complex_Ioi hz 0
  have hre :
      (∫ (x : ℝ) in Ioi 0, (Complex.exp (z * x)).re) =
        (-Complex.exp (z * 0) / z).re := by
    calc
      _ = (∫ (x : ℝ) in Ioi 0, Complex.exp (z * x)).re := integral_re hi
      _ = _ := congrArg Complex.re he
  have hexp (x : ℝ) :
      (Complex.exp (z * x)).re =
        Real.exp (-a * x) * Real.cos (t * x) := by
    simp [z, Complex.exp_re]
  rw [show (fun x : ℝ ↦ Real.exp (-a * x) * Real.cos (t * x)) =
      (fun x : ℝ ↦ (Complex.exp (z * x)).re) by funext x; exact (hexp x).symm]
  rw [hre]
  simp [z, Complex.div_re, Complex.normSq_apply]
  ring

private lemma damped_sinc_eq_arctan_inv {a : ℝ} (ha : 0 < a) :
    (∫ x in Ioi 0, Real.exp (-a * x) * Real.sinc x) =
      Real.arctan a⁻¹ := by
  have hexp : IntegrableOn (fun x : ℝ ↦ Real.exp (-a * x)) (Ioi 0) := by
    simpa only [neg_mul] using
      (integrableOn_exp_mul_Ioi (a := -a) (by linarith) 0)
  have hone : Integrable (fun _ : ℝ ↦ (1 : ℝ))
      (volume.restrict (uIoc (0 : ℝ) 1)) := by
    exact integrableOn_const (by simp)
  have hprod : Integrable
      (Function.uncurry fun t x : ℝ ↦
        Real.exp (-a * x) * Real.cos (t * x))
      ((volume.restrict (uIoc (0 : ℝ) 1)).prod
        (volume.restrict (Ioi 0))) := by
    refine Integrable.mono' (hone.mul_prod hexp) (by fun_prop) ?_
    filter_upwards with p
    rcases p with ⟨t, x⟩
    simp only [Function.uncurry_apply_pair, Real.norm_eq_abs, abs_mul, one_mul]
    rw [abs_of_pos (Real.exp_pos _)]
    exact mul_le_of_le_one_right (Real.exp_pos _).le (Real.abs_cos_le_one _)
  calc
    (∫ x in Ioi 0, Real.exp (-a * x) * Real.sinc x) =
        ∫ x in Ioi 0, ∫ t in 0..1,
          Real.exp (-a * x) * Real.cos (t * x) := by
      apply setIntegral_congr_fun measurableSet_Ioi
      intro x _
      calc
        Real.exp (-a * x) * Real.sinc x =
            Real.exp (-a * x) * (∫ t in 0..1, Real.cos (x * t)) := by
          rw [integral_cos_eq_sinc]
        _ = ∫ t in 0..1, Real.exp (-a * x) * Real.cos (t * x) := by
          rw [intervalIntegral.integral_const_mul]
          congr 1
          apply intervalIntegral.integral_congr
          intro t _
          simp [mul_comm]
    _ = ∫ t in 0..1, ∫ x in Ioi 0,
          Real.exp (-a * x) * Real.cos (t * x) :=
      (intervalIntegral_integral_swap hprod).symm
    _ = ∫ t in 0..1, a / (a ^ 2 + t ^ 2) := by
      apply intervalIntegral.integral_congr
      intro t _
      exact integral_exp_neg_mul_cos_Ioi ha t
    _ = Real.arctan a⁻¹ := by
      simpa [ha.ne'] using
        (integral_div_sq_add_sq (a := 0) (b := 1) (c := a))

private lemma damped_sinc_eq_primitive {a : ℝ} (ha : 0 < a) :
    (∫ x in Ioi 0, Real.exp (-a * x) * Real.sinc x) =
      a * ∫ x in Ioi 0, Real.exp (-a * x) * primitive x := by
  have hexp : IntegrableOn (fun x : ℝ ↦ Real.exp (-a * x)) (Ioi 0) := by
    simpa only [neg_mul] using
      (integrableOn_exp_mul_Ioi (a := -a) (by linarith) 0)
  have hsinc : IntegrableOn
      (fun x : ℝ ↦ Real.exp (-a * x) * Real.sinc x) (Ioi 0) := by
    refine Integrable.mono' hexp (by fun_prop) ?_
    filter_upwards with x
    simp only [Real.norm_eq_abs, abs_mul]
    rw [abs_of_pos (Real.exp_pos _)]
    exact mul_le_of_le_one_right (Real.exp_pos _).le (Real.abs_sinc_le_one x)
  have hprim : IntegrableOn
      (fun x : ℝ ↦ (-a * Real.exp (-a * x)) * primitive x) (Ioi 0) := by
    refine Integrable.mono' (hexp.const_mul (4 * a))
      (((continuous_const.mul (Real.continuous_exp.comp (by fun_prop))).mul
        continuous_primitive).aestronglyMeasurable) ?_
    filter_upwards with x
    simp only [Real.norm_eq_abs, abs_mul]
    rw [abs_neg, abs_of_pos ha, abs_of_pos (Real.exp_pos _)]
    have hp := primitive_uniformly_bounded x
    calc
      a * Real.exp (-a * x) * |primitive x|
          ≤ a * Real.exp (-a * x) * 4 := by gcongr
      _ = 4 * a * Real.exp (-a * x) := by ring
  have hzero : Tendsto
      ((fun x : ℝ ↦ Real.exp (-a * x)) * primitive)
      (𝓝[>] 0) (𝓝 0) := by
    change Tendsto (fun x : ℝ ↦ Real.exp (-a * x) * primitive x) (𝓝[>] 0) (𝓝 0)
    have h : Tendsto (fun x : ℝ ↦ Real.exp (-a * x) * primitive x)
        (𝓝 0) (𝓝 (Real.exp (-a * 0) * primitive 0)) :=
      ((Real.continuous_exp.comp (by fun_prop)).mul continuous_primitive).tendsto 0
    have h' := h.mono_left (show (𝓝[>] (0 : ℝ)) ≤ 𝓝 0 from inf_le_left)
    simpa [primitive] using h'
  have hinfty : Tendsto
      ((fun x : ℝ ↦ Real.exp (-a * x)) * primitive) atTop (𝓝 0) := by
    change Tendsto (fun x : ℝ ↦ Real.exp (-a * x) * primitive x) atTop (𝓝 0)
    refine squeeze_zero_norm' (a := fun x : ℝ ↦ 4 * Real.exp (-a * x)) ?_ ?_
    · filter_upwards with x
      simp only [Real.norm_eq_abs, abs_mul]
      rw [abs_of_pos (Real.exp_pos _)]
      exact (mul_le_mul_of_nonneg_left (primitive_uniformly_bounded x)
        (Real.exp_pos _).le).trans_eq (by ring)
    · have he : Tendsto (fun x : ℝ ↦ Real.exp (-a * x)) atTop (𝓝 0) :=
        Real.tendsto_exp_atBot.comp
          (tendsto_id.const_mul_atTop_of_neg (neg_lt_zero.mpr ha))
      simpa using he.const_mul 4
  have hparts := integral_Ioi_mul_deriv_eq_deriv_mul
    (a := 0)
    (u := fun x : ℝ ↦ Real.exp (-a * x))
    (u' := fun x : ℝ ↦ -a * Real.exp (-a * x))
    (v := primitive) (v' := Real.sinc)
    (a' := 0) (b' := 0)
    (fun x _ ↦ by
      have hx : HasDerivAt (fun y : ℝ ↦ -a * y) (-a) x := by
        simpa only [id_eq, mul_one] using (hasDerivAt_id x).const_mul (-a)
      convert (Real.hasDerivAt_exp (-a * x)).comp x hx using 1
      · ext y
        simp
      · ring)
    (fun x _ ↦ hasDerivAt_primitive x) hsinc hprim hzero hinfty
  have hparts' :
      (∫ x in Ioi 0, Real.exp (-a * x) * Real.sinc x) =
        -(∫ x in Ioi 0, (-a * Real.exp (-a * x)) * primitive x) := by
    simpa only [sub_zero, zero_sub, neg_zero] using hparts
  rw [hparts']
  calc
    -(∫ x in Ioi 0, (-a * Real.exp (-a * x)) * primitive x) =
        ∫ x in Ioi 0, a * (Real.exp (-a * x) * primitive x) := by
      rw [← integral_neg]
      apply integral_congr_ae
      filter_upwards with x
      ring
    _ = a * ∫ x in Ioi 0, Real.exp (-a * x) * primitive x := by
      rw [integral_const_mul]

private lemma scaled_primitive_integral {b : ℝ} (hb : 0 < b) :
    (∫ x in Ioi 0, Real.exp (-x) * primitive (b * x)) = Real.arctan b := by
  let g : ℝ → ℝ := fun y ↦ Real.exp (-b⁻¹ * y) * primitive y
  have hcv := integral_comp_mul_left_Ioi g 0 hb
  have hrewrite : (fun x : ℝ ↦ g (b * x)) =
      (fun x : ℝ ↦ Real.exp (-x) * primitive (b * x)) := by
    funext x
    simp [g, hb.ne']
  have hd := damped_sinc_eq_primitive (inv_pos.mpr hb)
  calc
    (∫ x in Ioi 0, Real.exp (-x) * primitive (b * x)) =
        ∫ x in Ioi 0, g (b * x) := by rw [hrewrite]
    _ = b⁻¹ * ∫ y in Ioi 0, g y := by simpa using hcv
    _ = ∫ y in Ioi 0, Real.exp (-b⁻¹ * y) * Real.sinc y := by
      simpa [g] using hd.symm
    _ = Real.arctan (b⁻¹)⁻¹ := damped_sinc_eq_arctan_inv (inv_pos.mpr hb)
    _ = Real.arctan b := by rw [inv_inv]

/-- The Dirichlet integral has its classical value. -/
theorem tendsto_primitive : Tendsto primitive atTop (nhds (Real.pi / 2)) := by
  rcases exists_tendsto_primitive with ⟨L, hL⟩
  let b : ℕ → ℝ := fun n ↦ (n : ℝ) + 1
  let F : ℕ → ℝ → ℝ := fun n x ↦ Real.exp (-x) * primitive (b n * x)
  have hbpos (n : ℕ) : 0 < b n := by
    dsimp [b]
    positivity
  have hbtop : Tendsto b atTop atTop := by
    simpa [b] using
      (tendsto_atTop_add_const_right atTop 1 tendsto_natCast_atTop_atTop)
  have hbound : Integrable (fun x : ℝ ↦ 4 * Real.exp (-x))
      (volume.restrict (Ioi 0)) := by
    exact (integrableOn_exp_neg_Ioi 0).const_mul 4
  have hDCT : Tendsto (fun n ↦ ∫ x in Ioi 0, F n x) atTop (𝓝 L) := by
    have h := tendsto_integral_of_dominated_convergence
      (μ := volume.restrict (Ioi 0))
      (F := F) (f := fun x : ℝ ↦ Real.exp (-x) * L)
      (fun x : ℝ ↦ 4 * Real.exp (-x))
      (fun n ↦ ((Real.continuous_exp.comp (by fun_prop)).mul
        (continuous_primitive.comp (by fun_prop))).aestronglyMeasurable)
      hbound
      (fun n ↦ by
        filter_upwards with x
        simp only [F, Real.norm_eq_abs, abs_mul]
        rw [abs_of_pos (Real.exp_pos _)]
        exact (mul_le_mul_of_nonneg_left (primitive_uniformly_bounded (b n * x))
          (Real.exp_pos _).le).trans_eq (by ring))
      (by
        filter_upwards [ae_restrict_mem measurableSet_Ioi] with x hx
        have hbx : Tendsto (fun n ↦ b n * x) atTop atTop :=
          hbtop.atTop_mul_const hx
        have he : Tendsto (fun _ : ℕ ↦ Real.exp (-x)) atTop
            (𝓝 (Real.exp (-x))) := tendsto_const_nhds
        change Tendsto (fun n ↦ Real.exp (-x) * primitive (b n * x)) atTop
          (𝓝 (Real.exp (-x) * L))
        convert he.mul (hL.comp hbx) using 1 <;> simp)
    have hInt :
        (∫ x in Ioi 0, Real.exp (-x) * L) = L := by
      calc
        (∫ x in Ioi 0, Real.exp (-x) * L) =
            ∫ x in Ioi 0, L * Real.exp (-x) := by
          apply integral_congr_ae
          filter_upwards with x
          ring
        _ = L * ∫ x in Ioi 0, Real.exp (-x) := by rw [integral_const_mul]
        _ = L := by rw [integral_exp_neg_Ioi_zero, mul_one]
    rw [hInt] at h
    exact h
  have hpi : Tendsto (fun n ↦ ∫ x in Ioi 0, F n x) atTop
      (𝓝 (Real.pi / 2)) := by
    have harctan : Tendsto (fun n ↦ Real.arctan (b n)) atTop
        (𝓝 (Real.pi / 2)) :=
      (tendsto_nhds_of_tendsto_nhdsWithin Real.tendsto_arctan_atTop).comp hbtop
    convert harctan using 1
    funext n
    exact scaled_primitive_integral (hbpos n)
  have hLval : L = Real.pi / 2 := tendsto_nhds_unique hDCT hpi
  simpa [hLval] using hL

end DirichletIntegral
