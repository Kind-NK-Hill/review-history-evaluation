import Mathlib

open MeasureTheory Set Filter
open scoped Interval Topology

noncomputable local instance : NormedSpace ℝ ℝ := NormedAlgebra.toNormedSpace ℝ
noncomputable def dirichletPrimitive (T : ℝ) : ℝ :=
  ∫ u in 0..T, Real.sinc u

lemma sinc_eq_integral_cos (u : ℝ) :
    Real.sinc u = ∫ r in 0..1, Real.cos (r * u) := by
  by_cases hu : u = 0
  · simp [hu]
  rw [Real.sinc_of_ne_zero hu]
  have hscale := intervalIntegral.smul_integral_comp_mul_right
    (fun v : ℝ => Real.cos v) u (a := 0) (b := 1)
  simp only [zero_mul, one_mul, smul_eq_mul] at hscale
  rw [integral_cos, Real.sin_zero, sub_zero] at hscale
  rw [← hscale]
  field_simp

lemma integrableOn_damped_cos_product {ε : ℝ} (hε : 0 < ε) :
    Integrable (fun z : ℝ × ℝ => Real.exp (-ε * z.1) * Real.cos (z.2 * z.1))
      ((volume.restrict (Ioi 0)).prod (volume.restrict (Ioc 0 1))) := by
  have hexp : IntegrableOn (fun u : ℝ => Real.exp (-ε * u)) (Ioi 0) := by
    exact integrableOn_exp_mul_Ioi (by linarith) 0
  have hbase : Integrable (fun z : ℝ × ℝ => Real.exp (-ε * z.1))
      ((volume.restrict (Ioi 0)).prod (volume.restrict (Ioc 0 1))) := by
    have hfin : IsFiniteMeasure (volume.restrict (Ioc (0 : ℝ) 1)) := ⟨by simp⟩
    letI := hfin
    simpa using hexp.mul_prod (integrable_const (μ := volume.restrict (Ioc (0 : ℝ) 1)) (1 : ℝ))
  refine hbase.mono ?_ ?_
  · fun_prop
  · filter_upwards with z
    rw [norm_mul, Real.norm_eq_abs, Real.norm_eq_abs,
      abs_of_pos (Real.exp_pos _)]
    simpa only [mul_one] using
      mul_le_mul_of_nonneg_left (Real.abs_cos_le_one (z.2 * z.1)) (Real.exp_pos _).le

lemma integral_Ioi_damped_cos {ε r : ℝ} (hε : 0 < ε) :
    (∫ u in Ioi 0, Real.exp (-ε * u) * Real.cos (r * u)) =
      ε / (ε ^ 2 + r ^ 2) := by
  let c : ℂ := (-ε : ℝ) + (r : ℂ) * Complex.I
  have hc : c.re < 0 := by simp [c, hε]
  have hint : IntegrableOn (fun u : ℝ => Complex.exp (c * (u : ℂ))) (Ioi 0) :=
    integrableOn_exp_mul_complex_Ioi hc 0
  have hpoint : (fun u : ℝ => Real.exp (-ε * u) * Real.cos (r * u)) =
      fun u : ℝ => (Complex.exp (c * (u : ℂ))).re := by
    funext u
    rw [Complex.exp_re]
    simp [c]
  calc
    (∫ u : ℝ in Ioi 0, Real.exp (-ε * u) * Real.cos (r * u))
        = ∫ u : ℝ in Ioi 0, (Complex.exp (c * (u : ℂ))).re := by rw [hpoint]
    _ = (∫ u : ℝ in Ioi 0, Complex.exp (c * (u : ℂ))).re := integral_re hint
    _ = (-1 / c).re := by
          rw [integral_exp_mul_complex_Ioi hc 0]
          simp
    _ = ε / (ε ^ 2 + r ^ 2) := by
          have hden : ε ^ 2 + r ^ 2 ≠ 0 := by positivity
          simp [c, Complex.div_re, Complex.normSq]
          field_simp [hden]

lemma integral_Ioi_damped_sinc {ε : ℝ} (hε : 0 < ε) :
    (∫ u in Ioi 0, Real.exp (-ε * u) * Real.sinc u) =
      Real.arctan (1 / ε) := by
  have hswap := integral_integral_swap
    (f := fun u r : ℝ => Real.exp (-ε * u) * Real.cos (r * u))
    (integrableOn_damped_cos_product hε)
  have h01 : (0 : ℝ) ≤ 1 := by norm_num
  have hrepl :
      (∫ u in Ioi 0, Real.exp (-ε * u) * Real.sinc u) =
        ∫ u in Ioi 0, ∫ r in 0..1,
          Real.exp (-ε * u) * Real.cos (r * u) := by
    apply integral_congr_ae
    filter_upwards with u
    rw [intervalIntegral.integral_const_mul, ← sinc_eq_integral_cos]
  rw [hrepl]
  simp_rw [intervalIntegral.integral_of_le h01]
  calc
    (∫ u in Ioi 0, ∫ r in Ioc 0 1,
        Real.exp (-ε * u) * Real.cos (r * u)) =
      ∫ r in Ioc 0 1, ∫ u in Ioi 0,
        Real.exp (-ε * u) * Real.cos (r * u) := hswap
    _ = ∫ r in Ioc 0 1, ε / (ε ^ 2 + r ^ 2) := by
      apply integral_congr_ae
      filter_upwards with r
      exact integral_Ioi_damped_cos hε
    _ = Real.arctan (1 / ε) := by
      rw [← intervalIntegral.integral_of_le h01]
      simp_rw [show (fun r : ℝ => ε / (ε ^ 2 + r ^ 2)) =
          fun r => (1 / ε) * (1 + (r / ε) ^ 2)⁻¹ by
            funext r
            field_simp]
      rw [intervalIntegral.integral_const_mul]
      have hcomp := intervalIntegral.integral_comp_div
        (fun r : ℝ => (1 + r ^ 2)⁻¹) hε.ne' (a := 0) (b := 1)
      simp only [Function.comp_apply, zero_div, one_div, smul_eq_mul] at hcomp
      rw [hcomp, integral_inv_one_add_sq]
      field_simp [hε.ne']
      simp

noncomputable def dampWeight (ε u : ℝ) : ℝ := Real.exp (-ε * u) / u

noncomputable def dampWeightDeriv (ε u : ℝ) : ℝ :=
  -Real.exp (-ε * u) * (ε / u + 1 / u ^ 2)

lemma hasDerivAt_dampWeight {ε u : ℝ} (hu : u ≠ 0) :
    HasDerivAt (dampWeight ε) (dampWeightDeriv ε u) u := by
  have he : HasDerivAt (fun x : ℝ => Real.exp (-ε * x))
      (-ε * Real.exp (-ε * u)) u := by
    convert (((hasDerivAt_const u (-ε)).mul (hasDerivAt_id u)).exp) using 1
    all_goals first | apply Subsingleton.elim | ext y; simp | simp; ring
  have h := he.div (hasDerivAt_id u) hu
  convert h using 1
  all_goals first
    | apply Subsingleton.elim
    | ext y; rfl
    | unfold dampWeightDeriv; simp only [id_eq]; field_simp; ring

lemma dampWeight_nonneg {ε u : ℝ} (hε : 0 ≤ ε) (hu : 0 < u) :
    0 ≤ dampWeight ε u := by
  exact div_nonneg (Real.exp_pos _).le hu.le

lemma dampWeightDeriv_nonpos {ε u : ℝ} (hε : 0 ≤ ε) (hu : 0 < u) :
    dampWeightDeriv ε u ≤ 0 := by
  unfold dampWeightDeriv
  have h : 0 ≤ ε / u + 1 / u ^ 2 := by positivity
  exact mul_nonpos_of_nonpos_of_nonneg (neg_nonpos.mpr (Real.exp_pos _).le) h

lemma dampWeight_le_inv {ε u : ℝ} (hε : 0 ≤ ε) (hu : 0 < u) :
    dampWeight ε u ≤ 1 / u := by
  unfold dampWeight
  gcongr
  exact Real.exp_le_one_iff.mpr
    (mul_nonpos_of_nonpos_of_nonneg (neg_nonpos.mpr hε) hu.le)

lemma damped_sinc_interval_eq {ε A B : ℝ} (hA : 0 < A) (hAB : A ≤ B) :
    (∫ u in A..B, Real.exp (-ε * u) * Real.sinc u) =
      dampWeight ε A * Real.cos A - dampWeight ε B * Real.cos B +
        ∫ u in A..B, dampWeightDeriv ε u * Real.cos u := by
  have hrewrite : ∀ u ∈ uIcc A B,
      Real.exp (-ε * u) * Real.sinc u = dampWeight ε u * Real.sin u := by
    intro u hu
    rw [uIcc_of_le hAB] at hu
    have hu_pos : 0 < u := lt_of_lt_of_le hA hu.1
    rw [Real.sinc_of_ne_zero hu_pos.ne']
    unfold dampWeight
    field_simp
  rw [intervalIntegral.integral_congr hrewrite]
  let p : ℝ → ℝ := fun u => dampWeight ε u * (-Real.cos u)
  let pd : ℝ → ℝ := fun u =>
    dampWeightDeriv ε u * (-Real.cos u) + dampWeight ε u * Real.sin u
  have hpderiv : ∀ u ∈ Ioo (min A B) (max A B),
      HasDerivWithinAt p (pd u) (Ioi u) u := by
    intro u hu
    have hu_pos : 0 < u := by rw [min_eq_left hAB] at hu; exact hA.trans_le hu.1.le
    have hd : HasDerivWithinAt
        (dampWeight ε * fun y : ℝ => -Real.cos y)
        (dampWeightDeriv ε u * (-Real.cos u) + dampWeight ε u * Real.sin u)
        (Ioi u) u := by
      convert ((hasDerivAt_dampWeight (ε := ε) hu_pos.ne').mul
        ((hasDerivAt_id u).cos.neg)).hasDerivWithinAt using 1
      all_goals first | apply Subsingleton.elim | ext y; simp | simp
    convert hd using 1
    all_goals first
      | apply Subsingleton.elim
      | ext y; simp [p, pd]
      | simp [p, pd]
  have hpcont : ContinuousOn p (uIcc A B) := by
    intro u hu
    rw [uIcc_of_le hAB] at hu
    have hu_pos : 0 < u := hA.trans_le hu.1
    apply ContinuousAt.continuousWithinAt
    unfold p dampWeight
    fun_prop (disch := exact hu_pos.ne')
  have hpdcont : ContinuousOn pd (uIcc A B) := by
    intro u hu
    rw [uIcc_of_le hAB] at hu
    have hu_pos : 0 < u := hA.trans_le hu.1
    apply ContinuousAt.continuousWithinAt
    unfold pd dampWeight dampWeightDeriv
    fun_prop (disch := first | exact hu_pos.ne' | exact pow_ne_zero 2 hu_pos.ne')
  have hftc := intervalIntegral.integral_eq_sub_of_hasDeriv_right hpcont hpderiv
    hpdcont.intervalIntegrable
  unfold pd p at hftc
  have hi1 : IntervalIntegrable
      (fun u => dampWeightDeriv ε u * (-Real.cos u)) volume A B := by
    apply ContinuousOn.intervalIntegrable
    intro u hu
    rw [uIcc_of_le hAB] at hu
    have hu_pos : 0 < u := hA.trans_le hu.1
    apply ContinuousAt.continuousWithinAt
    unfold dampWeightDeriv
    fun_prop (disch := first | exact hu_pos.ne' | exact pow_ne_zero 2 hu_pos.ne')
  have hi2 : IntervalIntegrable
      (fun u => dampWeight ε u * Real.sin u) volume A B := by
    apply ContinuousOn.intervalIntegrable
    intro u hu
    rw [uIcc_of_le hAB] at hu
    have hu_pos : 0 < u := hA.trans_le hu.1
    apply ContinuousAt.continuousWithinAt
    unfold dampWeight
    fun_prop (disch := exact hu_pos.ne')
  rw [intervalIntegral.integral_add hi1 hi2] at hftc
  have hneg : (∫ u in A..B, dampWeightDeriv ε u * (-Real.cos u)) =
      -(∫ u in A..B, dampWeightDeriv ε u * Real.cos u) := by
    rw [← intervalIntegral.integral_neg]
    apply intervalIntegral.integral_congr
    intro u _
    ring
  rw [hneg] at hftc
  linarith

lemma integral_neg_dampWeightDeriv {ε A B : ℝ} (hA : 0 < A) (hAB : A ≤ B) :
    (∫ u in A..B, -dampWeightDeriv ε u) = dampWeight ε A - dampWeight ε B := by
  have hd : ∀ u ∈ uIcc A B,
      HasDerivAt (dampWeight ε) (dampWeightDeriv ε u) u := by
    intro u hu
    rw [uIcc_of_le hAB] at hu
    exact hasDerivAt_dampWeight (ne_of_gt (hA.trans_le hu.1))
  have hi : IntervalIntegrable (dampWeightDeriv ε) volume A B := by
    apply ContinuousOn.intervalIntegrable
    intro u hu
    rw [uIcc_of_le hAB] at hu
    have hu_pos : 0 < u := hA.trans_le hu.1
    apply ContinuousAt.continuousWithinAt
    unfold dampWeightDeriv
    fun_prop (disch := first | exact hu_pos.ne' | exact pow_ne_zero 2 hu_pos.ne')
  rw [intervalIntegral.integral_neg]
  rw [intervalIntegral.integral_eq_sub_of_hasDerivAt hd hi]
  ring

lemma damped_sinc_tail_bound {ε A B : ℝ} (hε : 0 ≤ ε) (hA : 0 < A) (hAB : A ≤ B) :
    |∫ u in A..B, Real.exp (-ε * u) * Real.sinc u| ≤ 2 / A := by
  rw [damped_sinc_interval_eq hA hAB]
  have hderiv_int :
      |∫ u in A..B, dampWeightDeriv ε u * Real.cos u| ≤
        dampWeight ε A - dampWeight ε B := by
    calc
      |∫ u in A..B, dampWeightDeriv ε u * Real.cos u|
          ≤ ∫ u in A..B, -dampWeightDeriv ε u := by
        rw [← Real.norm_eq_abs]
        apply intervalIntegral.norm_integral_le_of_norm_le hAB
        · filter_upwards with u hu
          have hu_pos : 0 < u := hA.trans hu.1
          rw [Real.norm_eq_abs, abs_mul,
            abs_of_nonpos (dampWeightDeriv_nonpos hε hu_pos)]
          calc
            -dampWeightDeriv ε u * |Real.cos u|
                ≤ -dampWeightDeriv ε u * 1 :=
              mul_le_mul_of_nonneg_left (Real.abs_cos_le_one _)
                (neg_nonneg.mpr (dampWeightDeriv_nonpos hε hu_pos))
            _ = -dampWeightDeriv ε u := by ring
        · apply ContinuousOn.intervalIntegrable
          intro u hu
          rw [uIcc_of_le hAB] at hu
          have hu_pos : 0 < u := hA.trans_le hu.1
          apply ContinuousAt.continuousWithinAt
          unfold dampWeightDeriv
          fun_prop (disch := first | exact hu_pos.ne' | exact pow_ne_zero 2 hu_pos.ne')
      _ = dampWeight ε A - dampWeight ε B := integral_neg_dampWeightDeriv hA hAB
  have hgA : 0 ≤ dampWeight ε A := dampWeight_nonneg hε hA
  have hgB : 0 ≤ dampWeight ε B := dampWeight_nonneg hε (hA.trans_le hAB)
  have hcosA : |dampWeight ε A * Real.cos A| ≤ dampWeight ε A := by
    rw [abs_mul, abs_of_nonneg hgA]
    simpa only [mul_one] using mul_le_mul_of_nonneg_left (Real.abs_cos_le_one A) hgA
  have hcosB : |dampWeight ε B * Real.cos B| ≤ dampWeight ε B := by
    rw [abs_mul, abs_of_nonneg hgB]
    simpa only [mul_one] using mul_le_mul_of_nonneg_left (Real.abs_cos_le_one B) hgB
  calc
    |dampWeight ε A * Real.cos A - dampWeight ε B * Real.cos B +
        ∫ u in A..B, dampWeightDeriv ε u * Real.cos u|
        ≤ |dampWeight ε A * Real.cos A| + |dampWeight ε B * Real.cos B| +
            |∫ u in A..B, dampWeightDeriv ε u * Real.cos u| := by
          calc
            _ ≤ |dampWeight ε A * Real.cos A - dampWeight ε B * Real.cos B| +
                |∫ u in A..B, dampWeightDeriv ε u * Real.cos u| := abs_add_le _ _
            _ ≤ _ := add_le_add
              (abs_sub (dampWeight ε A * Real.cos A)
                (dampWeight ε B * Real.cos B)) (le_refl _)
    _ ≤ dampWeight ε A + dampWeight ε B +
          (dampWeight ε A - dampWeight ε B) := by gcongr
    _ = 2 * dampWeight ε A := by ring
    _ ≤ 2 * (1 / A) := by gcongr; exact dampWeight_le_inv hε hA
    _ = 2 / A := by ring

lemma integrableOn_damped_sinc {ε : ℝ} (hε : 0 < ε) :
    IntegrableOn (fun u : ℝ => Real.exp (-ε * u) * Real.sinc u) (Ioi 0) := by
  have hexp : IntegrableOn (fun u : ℝ => Real.exp (-ε * u)) (Ioi 0) :=
    integrableOn_exp_mul_Ioi (by linarith) 0
  change Integrable (fun u : ℝ => Real.exp (-ε * u) * Real.sinc u)
    (volume.restrict (Ioi 0))
  refine MeasureTheory.Integrable.mono (μ := volume.restrict (Ioi 0))
    (g := fun u : ℝ => Real.exp (-ε * u)) (f := fun u : ℝ =>
      Real.exp (-ε * u) * Real.sinc u) hexp ?_ ?_
  · fun_prop
  · filter_upwards with u
    rw [norm_mul]
    calc
      ‖Real.exp (-ε * u)‖ * ‖Real.sinc u‖ ≤ ‖Real.exp (-ε * u)‖ * 1 := by
        gcongr
        simpa only [Real.norm_eq_abs] using Real.abs_sinc_le_one u
      _ = ‖Real.exp (-ε * u)‖ := by ring

lemma damped_sinc_Ioi_tail_bound {ε A : ℝ} (hε : 0 < ε) (hA : 0 < A) :
    |∫ u in Ioi A, Real.exp (-ε * u) * Real.sinc u| ≤ 2 / A := by
  have hintA : IntegrableOn (fun u : ℝ => Real.exp (-ε * u) * Real.sinc u) (Ioi A) :=
    (integrableOn_damped_sinc hε).mono_set (Ioi_subset_Ioi hA.le)
  have ht := MeasureTheory.intervalIntegral_tendsto_integral_Ioi A hintA tendsto_id
  have habs := (continuous_abs.continuousAt.tendsto.comp ht)
  apply le_of_tendsto habs
  filter_upwards [eventually_ge_atTop A] with B hAB
  exact damped_sinc_tail_bound hε.le hA hAB

lemma damped_sinc_split {ε T : ℝ} (hε : 0 < ε) (hT : 0 ≤ T) :
    (∫ u in Ioi 0, Real.exp (-ε * u) * Real.sinc u) =
      (∫ u in 0..T, Real.exp (-ε * u) * Real.sinc u) +
        ∫ u in Ioi T, Real.exp (-ε * u) * Real.sinc u := by
  let f : ℝ → ℝ := fun u => Real.exp (-ε * u) * Real.sinc u
  have hint : IntegrableOn f (Ioi 0) := integrableOn_damped_sinc hε
  have hint1 : IntegrableOn f (Ioc 0 T) := hint.mono_set Ioc_subset_Ioi_self
  have hint2 : IntegrableOn f (Ioi T) := hint.mono_set (Ioi_subset_Ioi hT)
  have hu := setIntegral_union (Ioc_disjoint_Ioi (le_refl T)) measurableSet_Ioi hint1 hint2
  rw [Ioc_union_Ioi_eq_Ioi hT] at hu
  simpa [f, intervalIntegral.integral_of_le hT] using hu

lemma abs_one_sub_exp_neg_le {v : ℝ} (hv : 0 ≤ v) :
    |1 - Real.exp (-v)| ≤ v := by
  rw [abs_of_nonneg (sub_nonneg.mpr (Real.exp_le_one_iff.mpr (neg_nonpos.mpr hv)))]
  linarith [Real.one_sub_le_exp_neg v]

lemma dirichlet_finite_damping_error {ε T : ℝ} (hε : 0 ≤ ε) (hT : 0 ≤ T) :
    |dirichletPrimitive T -
      ∫ u in 0..T, Real.exp (-ε * u) * Real.sinc u| ≤ ε * T ^ 2 / 2 := by
  have hs : IntervalIntegrable Real.sinc volume 0 T := Real.continuous_sinc.intervalIntegrable _ _
  have hd : IntervalIntegrable (fun u : ℝ => Real.exp (-ε * u) * Real.sinc u)
      volume 0 T := (by fun_prop : Continuous
        (fun u : ℝ => Real.exp (-ε * u) * Real.sinc u)).intervalIntegrable 0 T
  rw [dirichletPrimitive, ← intervalIntegral.integral_sub hs hd]
  rw [← Real.norm_eq_abs]
  calc
    ‖∫ u in 0..T, Real.sinc u - Real.exp (-ε * u) * Real.sinc u‖
        ≤ ∫ u in 0..T, ε * u := by
      apply intervalIntegral.norm_integral_le_of_norm_le hT
      · filter_upwards with u hu
        rw [Real.norm_eq_abs, show Real.sinc u - Real.exp (-ε * u) * Real.sinc u =
          (1 - Real.exp (-ε * u)) * Real.sinc u by ring]
        have hu0 : 0 ≤ u := hu.1.le
        rw [abs_mul, abs_of_nonneg
          (sub_nonneg.mpr (Real.exp_le_one_iff.mpr
            (mul_nonpos_of_nonpos_of_nonneg (neg_nonpos.mpr hε) hu0)))]
        calc
          (1 - Real.exp (-ε * u)) * |Real.sinc u|
              ≤ (ε * u) * |Real.sinc u| := by
                gcongr
                have hh := abs_one_sub_exp_neg_le (mul_nonneg hε hu0)
                rw [abs_of_nonneg (sub_nonneg.mpr (Real.exp_le_one_iff.mpr
                  (neg_nonpos.mpr (mul_nonneg hε hu0))))] at hh
                simpa only [neg_mul] using hh
          _ ≤ (ε * u) * 1 := by
                gcongr
                exact Real.abs_sinc_le_one u
          _ = ε * u := by ring
      · exact (by fun_prop : Continuous (fun u : ℝ => ε * u)).intervalIntegrable 0 T
    _ = ε * T ^ 2 / 2 := by
      rw [intervalIntegral.integral_const_mul, integral_id]
      ring

lemma dirichlet_damped_approx {T : ℝ} (hT : 1 ≤ T) :
    |dirichletPrimitive T - Real.arctan (T ^ 3)| ≤ 5 / (2 * T) := by
  let ε : ℝ := T⁻¹ ^ 3
  have hTpos : 0 < T := lt_of_lt_of_le zero_lt_one hT
  have hε : 0 < ε := by positivity
  have hsplit := damped_sinc_split hε hTpos.le
  have hvalue := integral_Ioi_damped_sinc hε
  have hfinite := dirichlet_finite_damping_error hε.le hTpos.le
  have htail := damped_sinc_Ioi_tail_bound hε hTpos
  have harctan : Real.arctan (1 / ε) = Real.arctan (T ^ 3) := by
    congr 1
    dsimp [ε]
    field_simp
  rw [hvalue, harctan] at hsplit
  have heq : dirichletPrimitive T - Real.arctan (T ^ 3) =
      (dirichletPrimitive T -
        ∫ u in 0..T, Real.exp (-ε * u) * Real.sinc u) -
          ∫ u in Ioi T, Real.exp (-ε * u) * Real.sinc u := by linarith
  rw [heq]
  calc
    |(dirichletPrimitive T -
        ∫ u in 0..T, Real.exp (-ε * u) * Real.sinc u) -
          ∫ u in Ioi T, Real.exp (-ε * u) * Real.sinc u|
        ≤ |dirichletPrimitive T -
            ∫ u in 0..T, Real.exp (-ε * u) * Real.sinc u| +
              |∫ u in Ioi T, Real.exp (-ε * u) * Real.sinc u| := abs_sub _ _
    _ ≤ ε * T ^ 2 / 2 + 2 / T := add_le_add hfinite htail
    _ = 5 / (2 * T) := by
      dsimp [ε]
      field_simp
      ring

/-- Dirichlet's integral, in the exact form needed by inversion. -/
theorem tendsto_dirichletPrimitive_atTop :
    Tendsto dirichletPrimitive atTop (𝓝 (Real.pi / 2)) := by
  have herr : Tendsto
      (fun T : ℝ => |dirichletPrimitive T - Real.arctan (T ^ 3)|)
      atTop (𝓝 0) := by
    apply squeeze_zero'
    · exact Eventually.of_forall (fun _ => abs_nonneg _)
    · filter_upwards [eventually_ge_atTop (1 : ℝ)] with T hT
      exact dirichlet_damped_approx hT
    · have hden : Tendsto (fun T : ℝ => 2 * T) atTop atTop := by
        simpa [mul_comm] using tendsto_id.atTop_mul_const (by norm_num : (0 : ℝ) < 2)
      simpa using tendsto_const_nhds.div_atTop hden
  have hdiff : Tendsto
      (fun T : ℝ => dirichletPrimitive T - Real.arctan (T ^ 3))
      atTop (𝓝 0) := by
    rw [tendsto_zero_iff_norm_tendsto_zero]
    simpa only [Real.norm_eq_abs] using herr
  have hpow : Tendsto (fun T : ℝ => T ^ 3) atTop atTop :=
    tendsto_pow_atTop (by norm_num)
  have hatan : Tendsto (fun T : ℝ => Real.arctan (T ^ 3)) atTop
      (𝓝 (Real.pi / 2)) :=
    tendsto_nhds_of_tendsto_nhdsWithin (Real.tendsto_arctan_atTop.comp hpow)
  convert hdiff.add hatan using 1 <;> simp

lemma dirichletPrimitive_neg (T : ℝ) :
    dirichletPrimitive (-T) = -dirichletPrimitive T := by
  unfold dirichletPrimitive
  rw [intervalIntegral.integral_symm]
  have h := intervalIntegral.integral_comp_neg Real.sinc (a := 0) (b := T)
  simp only [neg_zero, Real.sinc_neg] at h
  rw [← h]

lemma abs_arctan_le_pi_div_two (x : ℝ) : |Real.arctan x| ≤ Real.pi / 2 := by
  rw [abs_le]
  exact ⟨(Real.neg_pi_div_two_lt_arctan x).le, (Real.arctan_lt_pi_div_two x).le⟩

lemma abs_dirichletPrimitive_le_of_one_le {T : ℝ} (hT : 1 ≤ T) :
    |dirichletPrimitive T| ≤ Real.pi / 2 + 5 / 2 := by
  calc
    |dirichletPrimitive T| ≤
        |dirichletPrimitive T - Real.arctan (T ^ 3)| +
          |Real.arctan (T ^ 3)| := by
            nth_rw 1 [← sub_add_cancel (dirichletPrimitive T) (Real.arctan (T ^ 3))]
            exact abs_add_le _ _
    _ ≤ 5 / (2 * T) + Real.pi / 2 := by
          gcongr
          · exact dirichlet_damped_approx hT
          · exact abs_arctan_le_pi_div_two _
    _ ≤ Real.pi / 2 + 5 / 2 := by
          have hTpos : 0 < T := zero_lt_one.trans_le hT
          have : 5 / (2 * T) ≤ 5 / 2 := by
            rw [div_le_div_iff₀ (by positivity) (by positivity)]
            nlinarith
          linarith

lemma abs_dirichletPrimitive_le_one {T : ℝ} (hT0 : 0 ≤ T) (hT1 : T ≤ 1) :
    |dirichletPrimitive T| ≤ 1 := by
  unfold dirichletPrimitive
  rw [← Real.norm_eq_abs]
  calc
    ‖∫ u in 0..T, Real.sinc u‖ ≤ ∫ _u in 0..T, (1 : ℝ) := by
      apply intervalIntegral.norm_integral_le_of_norm_le hT0
      · exact Eventually.of_forall fun u _ => by
          simpa only [Real.norm_eq_abs] using Real.abs_sinc_le_one u
      · exact intervalIntegrable_const
    _ = T := by simp
    _ ≤ 1 := hT1

/-- A numerical global bound, independent of the endpoint. -/
theorem abs_dirichletPrimitive_le (T : ℝ) :
    |dirichletPrimitive T| ≤ Real.pi / 2 + 5 / 2 := by
  by_cases hpos : 0 ≤ T
  · by_cases hT : 1 ≤ T
    · exact abs_dirichletPrimitive_le_of_one_le hT
    · exact (abs_dirichletPrimitive_le_one hpos (le_of_not_ge hT)).trans (by
        have hp := Real.pi_pos
        linarith)
  · have hneg0 : 0 ≤ -T := by linarith
    rw [← abs_neg, ← dirichletPrimitive_neg]
    by_cases hT : 1 ≤ -T
    · exact abs_dirichletPrimitive_le_of_one_le hT
    · exact (abs_dirichletPrimitive_le_one hneg0 (le_of_not_ge hT)).trans (by
        have hp := Real.pi_pos
        linarith)
