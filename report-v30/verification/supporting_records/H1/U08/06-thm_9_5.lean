import Mathlib
import ProbabilityTheory.chapter_09.def_9_3
import ProbabilityTheory.chapter_07.thm_7_7
import ProbabilityTheory.chapter_08.thm_8_5
import ProbabilityTheory.chapter_09.thm_9_4

/-
TASK ID: thm_9_5
TYPE: Theorem_with_Proof
SOURCE PLAN: experiment_targets
TASK CONTENT:
\begin{thmbox}{9.5}
\textbf{Inversion Formula.}
Let $X$ be a random variable on a probability space $(\Omega,\mathcal{F},P)$, and let $\phi_X(t)$ be the characteristic function of $X$. Denote the push-forward measure of $P$ by $\mu$. For $a<b$,
\[
\mu((a,b))+\frac{\mu(\{a\})}{2}+\frac{\mu(\{b\})}{2}
=\frac{1}{2\pi}\lim_{T\to\infty}
\int_{-T}^{T}\frac{e^{-ita}-e^{-itb}}{it}\phi_X(t)\,dt.
\]
\end{thmbox}

On the left-hand side of the equation in Theorem 9.5, $(a,b)$ denotes an open interval, and $\mu(\{a\})$ and $\mu(\{b\})$ are probabilities at the points $a$ and $b$, respectively. This formulation is necessary to account for possible discontinuities in the cumulative distribution function. If the cdf is continuous, then both $\mu(\{a\})$ and $\mu(\{b\})$ are zero, and $\mu((a,b))=\mu([a,b])$. The limit on the right-hand side is the Cauchy principal value of the integral, and its existence is part of the theorem.

In the proof we use the Dirichlet integral
\[
\lim_{T\to\infty}\int_0^T \frac{\sin u}{u}\,du=\frac{\pi}{2}.
\]
This limit is obtained from the Riemann integral of the function $(\sin u)/u$.

\textit{Proof}
For fixed $T$, consider
\[
I_T \coloneqq
\int_{-T}^{T}\frac{e^{-ita}-e^{-itb}}{it}\phi_X(t)\,dt
=\int_{-T}^{T}\int_{\mathbb{R}}
\frac{e^{-ita}-e^{-itb}}{it}e^{itx}\,d\mu(x)\,dt.
\]
Using Theorem 9.4, we can bound the integrand by
\[
\left\lvert
\frac{e^{-ita}-e^{-itb}}{it}e^{itx}
\right\rvert
=\left\lvert \frac{1}{t}(e^{it(b-a)}-1)\right\rvert
\leq b-a.
\]
Therefore, by Fubini theorem (Theorem 8.5),
\[
I_T=\int_{\mathbb{R}}\int_{-T}^{T}
\frac{e^{-ita}-e^{-itb}}{it}e^{itx}\,dt\,d\mu(x).
\tag{9.1}
\]

Let $f(x,T)$ denote the inner integral in (9.1). The imaginary part of the integrand is odd and the real part is even, so integration over $[-T,T]$ gives
\[
f(x,T)
=2\int_0^T \frac{1}{t}\sin(t(b-x))\,dt
-2\int_0^T \frac{1}{t}\sin(t(a-x))\,dt.
\]
Changing variables gives
\[
f(x,T)
=2\int_{(a-x)T}^{(b-x)T}\frac{\sin u}{u}\,du.
\]
There are four cases. If $a<x<b$, then $f(x,T)\to 2\pi$. If $x=a$ or $x=b$, then $f(x,T)\to \pi$. If $x<a$ or $x>b$, then $f(x,T)\to 0$. Thus
\[
\lim_{T\to\infty} f(x,T)=
\begin{cases}
2\pi, & x\in(a,b),\\
\pi, & x=a\text{ or }x=b,\\
0, & \text{otherwise}.
\end{cases}
\]
The integral $\int_0^v (\sin u)/u\,du$ converges as $v\to\infty$ and is continuous as a function of $v$. Hence $\lvert f(x,T)\rvert$ is bounded by a constant independent of $x$ and $T$. Applying the complex version of the dominated convergence theorem (Theorem 7.6), we get
\[
\lim_{T\to\infty} I_T
=2\pi\int 1_{(a,b)}(x)\,d\mu(x)
+\pi\int 1_{\{a\}}(x)\,d\mu(x)
+\pi\int 1_{\{b\}}(x)\,d\mu(x).
\]
Dividing by $2\pi$ gives the inversion formula.
\hfill $\square$
-/

-- WRITE FINAL LEAN CODE BELOW


open Filter MeasureTheory Set intervalIntegral
open scoped Topology

lemma integrable_exp_kernel {x : ℝ} (hx : 0 < x) :
    IntegrableOn (fun t : ℝ => Real.exp (-x * t)) (Ioi 0) := by
  exact integrableOn_exp_mul_Ioi (a := -x) (by linarith) 0

lemma integral_exp_kernel {x : ℝ} (hx : 0 < x) :
    (∫ t : ℝ in Ioi 0, Real.exp (-x * t)) = 1 / x := by
  rw [integral_exp_mul_Ioi (a := -x) (by linarith) 0]
  simp

lemma integrable_sin_exp_prod (T : ℝ) (_hT : 0 ≤ T) :
    Integrable (fun p : ℝ × ℝ => Real.sin p.1 * Real.exp (-p.1 * p.2))
      ((volume.restrict (Ioc 0 T)).prod (volume.restrict (Ioi 0))) := by
  let μ := volume.restrict (Ioc 0 T)
  let ν := volume.restrict (Ioi (0 : ℝ))
  have hmeas : AEStronglyMeasurable
      (fun p : ℝ × ℝ => Real.sin p.1 * Real.exp (-p.1 * p.2)) (μ.prod ν) := by
    apply Continuous.aestronglyMeasurable
    fun_prop
  rw [integrable_prod_iff hmeas]
  constructor
  · filter_upwards [ae_restrict_mem measurableSet_Ioc] with x hx
    have hx0 : 0 < x := hx.1
    exact (integrable_exp_kernel hx0).const_mul (Real.sin x)
  · have hbound : ∀ᵐ x ∂μ,
        ‖∫ t, ‖Real.sin x * Real.exp (-x * t)‖ ∂ν‖ ≤ (1 : ℝ) := by
      filter_upwards [ae_restrict_mem measurableSet_Ioc] with x hx
      have hx0 : 0 < x := hx.1
      change ‖∫ t in Ioi 0, ‖Real.sin x * Real.exp (-x * t)‖‖ ≤ 1
      simp only [Real.norm_eq_abs, abs_mul,
        abs_of_nonneg (Real.exp_pos _).le]
      rw [MeasureTheory.integral_const_mul, integral_exp_kernel hx0]
      rw [abs_of_nonneg]
      · rw [one_div, mul_inv_le_iff₀ hx0]
        simpa [abs_of_pos hx0] using (Real.abs_sin_le_abs : |Real.sin x| ≤ |x|)
      · positivity
    exact (integrable_const (1 : ℝ)).mono' (hmeas.norm.integral_prod_right') hbound

lemma sinc_integral_eq_double (T : ℝ) (hT : 0 ≤ T) :
    (∫ x in (0 : ℝ)..T, Real.sinc x) =
      ∫ t in Ioi (0 : ℝ), ∫ x in Ioc 0 T,
        Real.sin x * Real.exp (-x * t) := by
  have hf := integrable_sin_exp_prod T hT
  rw [intervalIntegral_eq_integral_uIoc, if_pos hT, one_smul, uIoc_of_le hT]
  calc
    (∫ x in Ioc 0 T, Real.sinc x) =
        ∫ x in Ioc 0 T, ∫ t in Ioi (0 : ℝ),
          Real.sin x * Real.exp (-x * t) := by
      apply MeasureTheory.integral_congr_ae
      filter_upwards [ae_restrict_mem measurableSet_Ioc] with x hx
      rw [Real.sinc_of_ne_zero hx.1.ne', MeasureTheory.integral_const_mul,
        integral_exp_kernel hx.1]
      ring
    _ = ∫ t in Ioi (0 : ℝ), ∫ x in Ioc 0 T,
          Real.sin x * Real.exp (-x * t) := by
      exact MeasureTheory.integral_integral_swap hf


lemma integral_sin_exp (t T : ℝ) :
    (∫ x in (0 : ℝ)..T, Real.sin x * Real.exp (-x * t)) =
      (1 - Real.exp (-T * t) * (Real.cos T + t * Real.sin T)) / (1 + t ^ 2) := by
  let c : ℂ := (-t : ℂ) + Complex.I
  have hc : c ≠ 0 := by
    intro h
    have := congrArg Complex.im h
    simp [c] at this
  have hint : IntervalIntegrable (fun x : ℝ => Complex.exp (c * (x : ℂ))) volume 0 T :=
    (by fun_prop : Continuous (fun x : ℝ => Complex.exp (c * (x : ℂ)))).intervalIntegrable 0 T
  calc
    (∫ x in (0 : ℝ)..T, Real.sin x * Real.exp (-x * t)) =
        ∫ x in (0 : ℝ)..T, Complex.imCLM (Complex.exp (c * (x : ℂ))) := by
      apply intervalIntegral.integral_congr
      intro x _
      simp [c, Complex.exp_im, Complex.mul_re, Complex.mul_im]
      ring
    _ = Complex.imCLM (∫ x in (0 : ℝ)..T, Complex.exp (c * (x : ℂ))) :=
      Complex.imCLM.intervalIntegral_comp_comm hint
    _ = Complex.imCLM ((Complex.exp (c * (T : ℂ)) - 1) / c) := by
      rw [integral_exp_mul_complex hc]
      simp
    _ = (1 - Real.exp (-T * t) * (Real.cos T + t * Real.sin T)) /
          (1 + t ^ 2) := by
      simp [c, Complex.div_im, Complex.normSq_apply, Complex.exp_re,
        Complex.exp_im, Complex.mul_re, Complex.mul_im]
      field_simp
      ring

lemma sinc_integral_formula (T : ℝ) (hT : 0 ≤ T) :
    (∫ x in (0 : ℝ)..T, Real.sinc x) =
      ∫ t in Ioi (0 : ℝ),
        (1 - Real.exp (-T * t) * (Real.cos T + t * Real.sin T)) / (1 + t ^ 2) := by
  rw [sinc_integral_eq_double T hT]
  apply MeasureTheory.integral_congr_ae
  filter_upwards with t
  rw [← integral_sin_exp t T, intervalIntegral_eq_integral_uIoc,
    if_pos hT, one_smul, uIoc_of_le hT]

lemma sinc_kernel_bound {T t : ℝ} (hT : 1 ≤ T) (ht : 0 < t) :
    ‖(1 - Real.exp (-T * t) * (Real.cos T + t * Real.sin T)) / (1 + t ^ 2)‖ ≤
      (1 + t ^ 2)⁻¹ + 2 * Real.exp (-t) := by
  have hd : 0 < 1 + t ^ 2 := by positivity
  have he : Real.exp (-T * t) ≤ Real.exp (-t) := by
    rw [Real.exp_le_exp]
    nlinarith
  have htrig : |Real.cos T + t * Real.sin T| ≤ 1 + t := by
    calc
      |Real.cos T + t * Real.sin T| ≤ |Real.cos T| + |t * Real.sin T| := abs_add_le _ _
      _ = |Real.cos T| + t * |Real.sin T| := by rw [abs_mul, abs_of_pos ht]
      _ ≤ 1 + t * 1 := add_le_add (Real.abs_cos_le_one T)
        (mul_le_mul_of_nonneg_left (Real.abs_sin_le_one T) ht.le)
      _ = 1 + t := by ring
  have hnum : |1 - Real.exp (-T * t) * (Real.cos T + t * Real.sin T)| ≤
      1 + Real.exp (-t) * (1 + t) := by
    calc
      |1 - Real.exp (-T * t) * (Real.cos T + t * Real.sin T)| ≤
          |(1 : ℝ)| + |Real.exp (-T * t) * (Real.cos T + t * Real.sin T)| := abs_sub _ _
      _ = 1 + Real.exp (-T * t) * |Real.cos T + t * Real.sin T| := by
        simp [abs_of_pos (Real.exp_pos _)]
      _ ≤ 1 + Real.exp (-T * t) * (1 + t) := by
        simpa [add_comm] using add_le_add_left
          (mul_le_mul_of_nonneg_left htrig (Real.exp_pos (-T * t)).le) 1
      _ ≤ 1 + Real.exp (-t) * (1 + t) := by
        simpa [add_comm] using add_le_add_left
          (mul_le_mul_of_nonneg_right he (by linarith : 0 ≤ 1 + t)) 1
  have hratio : (1 + t) / (1 + t ^ 2) ≤ 2 := by
    rw [div_le_iff₀ hd]
    nlinarith [sq_nonneg t]
  rw [Real.norm_eq_abs, abs_div, abs_of_pos hd]
  calc
    |1 - Real.exp (-T * t) * (Real.cos T + t * Real.sin T)| / (1 + t ^ 2) ≤
        (1 + Real.exp (-t) * (1 + t)) / (1 + t ^ 2) :=
      div_le_div_of_nonneg_right hnum hd.le
    _ = (1 + t ^ 2)⁻¹ + Real.exp (-t) * ((1 + t) / (1 + t ^ 2)) := by
      field_simp
    _ ≤ (1 + t ^ 2)⁻¹ + Real.exp (-t) * 2 := by
      simpa [add_comm] using add_le_add_left
        (mul_le_mul_of_nonneg_left hratio (Real.exp_pos (-t)).le) (1 + t ^ 2)⁻¹
    _ = (1 + t ^ 2)⁻¹ + 2 * Real.exp (-t) := by ring

lemma sinc_kernel_tendsto (t : ℝ) (ht : 0 < t) :
    Tendsto (fun T : ℝ =>
      (1 - Real.exp (-T * t) * (Real.cos T + t * Real.sin T)) / (1 + t ^ 2))
      atTop (nhds ((1 + t ^ 2)⁻¹)) := by
  have he : Tendsto (fun T : ℝ => Real.exp (-T * t)) atTop (nhds 0) := by
    simpa [Function.comp_def, mul_comm] using Real.tendsto_exp_atBot.comp
      (tendsto_id.const_mul_atTop_of_neg (neg_lt_zero.mpr ht))
  have hp : Tendsto (fun T : ℝ =>
      Real.exp (-T * t) * (Real.cos T + t * Real.sin T)) atTop (nhds 0) := by
    rw [tendsto_zero_iff_norm_tendsto_zero]
    have hle : ∀ T : ℝ,
        ‖Real.exp (-T * t) * (Real.cos T + t * Real.sin T)‖ ≤
          Real.exp (-T * t) * (1 + t) := by
      intro T
      rw [Real.norm_eq_abs, abs_mul, abs_of_pos (Real.exp_pos _)]
      apply mul_le_mul_of_nonneg_left _ (Real.exp_pos _).le
      calc
        |Real.cos T + t * Real.sin T| ≤ |Real.cos T| + |t * Real.sin T| :=
          abs_add_le _ _
        _ = |Real.cos T| + t * |Real.sin T| := by rw [abs_mul, abs_of_pos ht]
        _ ≤ 1 + t * 1 := add_le_add (Real.abs_cos_le_one T)
          (mul_le_mul_of_nonneg_left (Real.abs_sin_le_one T) ht.le)
        _ = 1 + t := by ring
    have hmul : Tendsto (fun T : ℝ => Real.exp (-T * t) * (1 + t))
        atTop (nhds 0) := by
      simpa only [zero_mul] using (he.mul_const (1 + t))
    exact squeeze_zero (fun _ => norm_nonneg _) hle hmul
  have hone : Tendsto (fun _ : ℝ => (1 : ℝ)) atTop (nhds 1) := tendsto_const_nhds
  simpa [one_div] using ((hone.sub hp).div_const (1 + t ^ 2))

set_option maxHeartbeats 800000 in
theorem tendsto_integral_sinc :
    Tendsto (fun T : ℝ => ∫ u in (0 : ℝ)..T, Real.sinc u)
      atTop (nhds (Real.pi / 2)) := by
  let g : ℝ → ℝ → ℝ := fun T t =>
    (1 - Real.exp (-T * t) * (Real.cos T + t * Real.sin T)) / (1 + t ^ 2)
  let b : ℝ → ℝ := fun t => (1 + t ^ 2)⁻¹ + 2 * Real.exp (-t)
  have hb : Integrable b (volume.restrict (Ioi (0 : ℝ))) := by
    apply IntegrableOn.integrable
    exact integrable_inv_one_add_sq.integrableOn.add
      ((integrableOn_exp_neg_Ioi 0).const_mul 2)
  have hmeas : ∀ᶠ T : ℝ in atTop,
      AEStronglyMeasurable (g T) (volume.restrict (Ioi (0 : ℝ))) := by
    filter_upwards with T
    apply Continuous.aestronglyMeasurable
    dsimp [g]
    apply Continuous.div₀ (by fun_prop) (by fun_prop)
    intro t
    positivity
  have hbound : ∀ᶠ T : ℝ in atTop, ∀ᵐ t ∂volume.restrict (Ioi (0 : ℝ)),
      ‖g T t‖ ≤ b t := by
    filter_upwards [eventually_ge_atTop (1 : ℝ)] with T hT
    filter_upwards [ae_restrict_mem measurableSet_Ioi] with t ht
    simpa [g, b] using sinc_kernel_bound hT ht
  have hlim : ∀ᵐ t ∂volume.restrict (Ioi (0 : ℝ)),
      Tendsto (fun T : ℝ => g T t) atTop (nhds ((1 + t ^ 2)⁻¹)) := by
    filter_upwards [ae_restrict_mem measurableSet_Ioi] with t ht
    simpa [g] using sinc_kernel_tendsto t ht
  have h := tendsto_integral_filter_of_dominated_convergence b hmeas hbound hb hlim
  have hbase : (∫ t in Ioi (0 : ℝ), (1 + t ^ 2)⁻¹) = Real.pi / 2 := by
    simpa using (integral_Ioi_inv_one_add_sq (i := (0 : ℝ)))
  rw [hbase] at h
  apply h.congr'
  filter_upwards [eventually_ge_atTop (1 : ℝ)] with T hT
  simpa [g] using (sinc_integral_formula T (by linarith)).symm

lemma integral_sinc_neg (v : ℝ) :
    (∫ u in (0 : ℝ)..(-v), Real.sinc u) =
      -(∫ u in (0 : ℝ)..v, Real.sinc u) := by
  calc
    (∫ u in (0 : ℝ)..(-v), Real.sinc u) =
        ∫ u in (0 : ℝ)..(-v), Real.sinc (-u) := by
      apply intervalIntegral.integral_congr
      intro u _
      simpa using (Real.sinc_neg u).symm
    _ = ∫ u in v..(0 : ℝ), Real.sinc u := by
      simpa using (intervalIntegral.integral_comp_neg
        (f := Real.sinc) (a := (0 : ℝ)) (b := -v))
    _ = -(∫ u in (0 : ℝ)..v, Real.sinc u) :=
      intervalIntegral.integral_symm 0 v

set_option maxHeartbeats 800000 in
theorem exists_uniform_bound_integral_sinc :
    ∃ C ≥ 0, ∀ v : ℝ, ‖∫ u in (0 : ℝ)..v, Real.sinc u‖ ≤ C := by
  let F : ℝ → ℝ := fun v => ∫ u in (0 : ℝ)..v, Real.sinc u
  let L : ℝ := Real.pi / 2
  have hevent : ∀ᶠ T : ℝ in atTop, ‖F T‖ ≤ ‖L‖ + 1 := by
    have hball := tendsto_integral_sinc
      (Metric.ball_mem_nhds (Real.pi / 2) (by positivity : (0 : ℝ) < 1))
    filter_upwards [hball] with T hT
    have hclose : ‖F T - L‖ < 1 := by
      simpa [F, L, Metric.mem_ball, dist_eq_norm] using hT
    calc
      ‖F T‖ = ‖(F T - L) + L‖ := by congr 1 <;> ring
      _ ≤ ‖F T - L‖ + ‖L‖ := norm_add_le _ _
      _ ≤ ‖L‖ + 1 := by linarith
  rcases (eventually_atTop.1 hevent) with ⟨A, hA⟩
  let C : ℝ := max (‖L‖ + 1) (max A 0)
  have hC : 0 ≤ C := le_trans (le_max_right A 0) (le_max_right _ _)
  refine ⟨C, hC, ?_⟩
  have hnonneg : ∀ v : ℝ, 0 ≤ v → ‖F v‖ ≤ C := by
    intro v hv
    by_cases hAv : A ≤ v
    · exact (hA v hAv).trans (le_max_left _ _)
    · have hbasic : ‖F v‖ ≤ 1 * |v - 0| := by
        exact intervalIntegral.norm_integral_le_of_norm_le_const
          (fun u _ => by simpa [Real.norm_eq_abs] using Real.abs_sinc_le_one u)
      calc
        ‖F v‖ ≤ 1 * |v - 0| := hbasic
        _ = v := by simp [abs_of_nonneg hv]
        _ ≤ max A 0 := le_max_of_le_left (le_of_lt (lt_of_not_ge hAv))
        _ ≤ C := le_max_right _ _
  intro v
  by_cases hv : 0 ≤ v
  · exact hnonneg v hv
  · have h := hnonneg (-v) (by linarith)
    simpa [F, integral_sinc_neg v] using h

noncomputable def sincIntervalKernel (a b T x : ℝ) : ℝ :=
  2 * ((∫ u in (0 : ℝ)..((b - x) * T), Real.sinc u) -
    ∫ u in (0 : ℝ)..((a - x) * T), Real.sinc u)

lemma tendsto_integral_sinc_atBot :
    Tendsto (fun T : ℝ => ∫ u in (0 : ℝ)..T, Real.sinc u)
      atBot (nhds (-(Real.pi / 2))) := by
  have h := tendsto_integral_sinc.comp tendsto_neg_atBot_atTop
  simpa [integral_sinc_neg] using h.neg

lemma tendsto_sincIntervalKernel {a b x : ℝ} (hab : a < b) :
    Tendsto (fun T : ℝ => sincIntervalKernel a b T x) atTop
      (nhds (if x ∈ Ioo a b then 2 * Real.pi
        else if x = a ∨ x = b then Real.pi else 0)) := by
  by_cases hax : a < x
  · by_cases hxb : x < b
    · have hb : Tendsto (fun T : ℝ => ∫ u in (0 : ℝ)..((b - x) * T), Real.sinc u)
          atTop (nhds (Real.pi / 2)) :=
        tendsto_integral_sinc.comp ((tendsto_const_mul_atTop_of_pos (sub_pos.mpr hxb)).2 tendsto_id)
      have ha : Tendsto (fun T : ℝ => ∫ u in (0 : ℝ)..((a - x) * T), Real.sinc u)
          atTop (nhds (-(Real.pi / 2))) :=
        tendsto_integral_sinc_atBot.comp
          (tendsto_id.const_mul_atTop_of_neg (sub_neg.mpr hax))
      simpa [sincIntervalKernel, hax, hxb] using
        (tendsto_const_nhds.mul (hb.sub ha) :
          Tendsto (fun T : ℝ => 2 *
            ((∫ u in (0 : ℝ)..((b - x) * T), Real.sinc u) -
             ∫ u in (0 : ℝ)..((a - x) * T), Real.sinc u)) atTop
            (nhds (2 * ((Real.pi / 2 : ℝ) - (-(Real.pi / 2) : ℝ)))))
    · have hbx : b ≤ x := le_of_not_gt hxb
      have ha : Tendsto (fun T : ℝ => ∫ u in (0 : ℝ)..((a - x) * T), Real.sinc u)
          atTop (nhds (-(Real.pi / 2))) :=
        tendsto_integral_sinc_atBot.comp
          (tendsto_id.const_mul_atTop_of_neg (sub_neg.mpr hax))
      by_cases hxeq : x = b
      · subst x
        have hlim := (tendsto_const_nhds.mul (tendsto_const_nhds.sub ha) :
            Tendsto (fun T : ℝ => 2 *
              ((0 : ℝ) - ∫ u in (0 : ℝ)..((a - b) * T), Real.sinc u)) atTop
              (nhds (2 * ((0 : ℝ) - (-(Real.pi / 2))))))
        rw [show 2 * ((0 : ℝ) - (-(Real.pi / 2))) = Real.pi by ring] at hlim
        simpa [sincIntervalKernel, hab.ne, hab.ne'] using hlim
      · have hbneg : b - x < 0 := sub_neg.mpr (lt_of_le_of_ne hbx (Ne.symm hxeq))
        have hb : Tendsto (fun T : ℝ => ∫ u in (0 : ℝ)..((b - x) * T), Real.sinc u)
            atTop (nhds (-(Real.pi / 2))) :=
          tendsto_integral_sinc_atBot.comp
            (tendsto_id.const_mul_atTop_of_neg hbneg)
        simpa [sincIntervalKernel, hax, hxb, hxeq, ne_of_gt hax] using
          (tendsto_const_nhds.mul (hb.sub ha) :
            Tendsto (fun T : ℝ => 2 *
              ((∫ u in (0 : ℝ)..((b - x) * T), Real.sinc u) -
               ∫ u in (0 : ℝ)..((a - x) * T), Real.sinc u)) atTop
              (nhds (2 * ((-(Real.pi / 2) : ℝ) - (-(Real.pi / 2))))))
  · have hxa : x ≤ a := le_of_not_gt hax
    by_cases hxeq : x = a
    · subst x
      have hb : Tendsto (fun T : ℝ => ∫ u in (0 : ℝ)..((b - a) * T), Real.sinc u)
          atTop (nhds (Real.pi / 2)) :=
        tendsto_integral_sinc.comp
          ((tendsto_const_mul_atTop_of_pos (sub_pos.mpr hab)).2 tendsto_id)
      have hlim := (tendsto_const_nhds.mul (hb.sub tendsto_const_nhds) :
          Tendsto (fun T : ℝ => 2 *
            ((∫ u in (0 : ℝ)..((b - a) * T), Real.sinc u) - (0 : ℝ))) atTop
            (nhds (2 * ((Real.pi / 2 : ℝ) - 0))))
      rw [show 2 * ((Real.pi / 2 : ℝ) - 0) = Real.pi by ring] at hlim
      simpa [sincIntervalKernel, hab.ne, hab.ne'] using hlim
    · have haxpos : 0 < a - x := sub_pos.mpr (lt_of_le_of_ne hxa (hxeq))
      have ha : Tendsto (fun T : ℝ => ∫ u in (0 : ℝ)..((a - x) * T), Real.sinc u)
          atTop (nhds (Real.pi / 2)) :=
        tendsto_integral_sinc.comp
          (((tendsto_const_mul_atTop_of_pos haxpos).2 tendsto_id))
      have hbpos : 0 < b - x := by linarith
      have hb : Tendsto (fun T : ℝ => ∫ u in (0 : ℝ)..((b - x) * T), Real.sinc u)
          atTop (nhds (Real.pi / 2)) :=
        tendsto_integral_sinc.comp
          (((tendsto_const_mul_atTop_of_pos hbpos).2 tendsto_id))
      simpa [sincIntervalKernel, hax, hxeq, hab.ne, hab.ne', ne_of_lt (lt_of_le_of_lt hxa hab)] using
        (tendsto_const_nhds.mul (hb.sub ha) :
          Tendsto (fun T : ℝ => 2 *
            ((∫ u in (0 : ℝ)..((b - x) * T), Real.sinc u) -
             ∫ u in (0 : ℝ)..((a - x) * T), Real.sinc u)) atTop
            (nhds (2 * ((Real.pi / 2 : ℝ) - (Real.pi / 2)))))

lemma exists_uniform_bound_sincIntervalKernel :
    ∃ C ≥ 0, ∀ a b T x : ℝ, ‖sincIntervalKernel a b T x‖ ≤ 4 * C := by
  rcases exists_uniform_bound_integral_sinc with ⟨C, hC, hbound⟩
  refine ⟨C, hC, fun a b T x => ?_⟩
  rw [sincIntervalKernel, norm_mul]
  norm_num
  calc
    2 * |(∫ u in (0 : ℝ)..((b - x) * T), Real.sinc u) -
        ∫ u in (0 : ℝ)..((a - x) * T), Real.sinc u| ≤
        2 * (‖∫ u in (0 : ℝ)..((b - x) * T), Real.sinc u‖ +
          ‖∫ u in (0 : ℝ)..((a - x) * T), Real.sinc u‖) := by
      gcongr
      simpa [Real.norm_eq_abs] using
        norm_sub_le (∫ u in (0 : ℝ)..((b - x) * T), Real.sinc u)
          (∫ u in (0 : ℝ)..((a - x) * T), Real.sinc u)
    _ ≤ 2 * (C + C) := by gcongr <;> apply hbound
    _ = 4 * C := by ring

noncomputable def inversionLimitKernel (a b x : ℝ) : ℝ :=
  if x ∈ Ioo a b then 2 * Real.pi
  else if x = a ∨ x = b then Real.pi else 0

set_option maxHeartbeats 800000 in
lemma tendsto_integral_sincIntervalKernel
    (μ : Measure ℝ) [IsProbabilityMeasure μ] {a b : ℝ} (hab : a < b) :
    Tendsto (fun T : ℝ => ∫ x, (sincIntervalKernel a b T x : ℂ) ∂μ) atTop
      (nhds (∫ x, (inversionLimitKernel a b x : ℂ) ∂μ)) := by
  rcases exists_uniform_bound_sincIntervalKernel with ⟨C, hC, hbound⟩
  let Y : ℝ → ℝ := fun _ => 4 * C
  have hY : Integrable Y μ := integrable_const _
  have hcontF : Continuous (fun v : ℝ => ∫ u in (0 : ℝ)..v, Real.sinc u) :=
    intervalIntegral.continuous_primitive
      (fun c d => Real.continuous_sinc.intervalIntegrable c d) 0
  have hmeas : ∀ᶠ T : ℝ in atTop,
      AEStronglyMeasurable (fun x => (sincIntervalKernel a b T x : ℂ)) μ := by
    filter_upwards with T
    have hc₁ : Continuous (fun x : ℝ => (b - x) * T) :=
      (continuous_const.sub continuous_id).mul continuous_const
    have hc₂ : Continuous (fun x : ℝ => (a - x) * T) :=
      (continuous_const.sub continuous_id).mul continuous_const
    have hr : Continuous (fun x => sincIntervalKernel a b T x) := by
      unfold sincIntervalKernel
      exact continuous_const.mul ((hcontF.comp hc₁).sub (hcontF.comp hc₂))
    exact (Complex.continuous_ofReal.comp hr).aestronglyMeasurable
  have hbound' : ∀ᶠ T : ℝ in atTop, ∀ᵐ x ∂μ,
      ‖(sincIntervalKernel a b T x : ℂ)‖ ≤ Y x := by
    filter_upwards with T
    exact ae_of_all μ fun x => by
      simpa [Y, Complex.norm_real] using hbound a b T x
  have hlim : ∀ᵐ x ∂μ, Tendsto
      (fun T : ℝ => (sincIntervalKernel a b T x : ℂ)) atTop
      (nhds (inversionLimitKernel a b x : ℂ)) := by
    filter_upwards with x
    exact Complex.continuous_ofReal.continuousAt.tendsto.comp
      (by simpa [inversionLimitKernel] using tendsto_sincIntervalKernel (x := x) hab)
  exact thm_7_DCT_filter μ
    (fun T x => (sincIntervalKernel a b T x : ℂ))
    (fun x => (inversionLimitKernel a b x : ℂ)) Y atTop
    hmeas hY hbound' hlim

lemma integral_sin_mul_div (c T : ℝ) :
    (∫ t in (0 : ℝ)..T, Real.sin (c * t) / t) =
      ∫ u in (0 : ℝ)..(c * T), Real.sinc u := by
  by_cases hc : c = 0
  · simp [hc]
  calc
    (∫ t in (0 : ℝ)..T, Real.sin (c * t) / t) =
        ∫ t in (0 : ℝ)..T, c * Real.sinc (c * t) := by
      apply intervalIntegral.integral_congr_ae
      filter_upwards [show ∀ᵐ t : ℝ ∂volume, t ≠ 0 by exact Measure.ae_ne volume 0] with t ht _
      rw [Real.sinc_of_ne_zero (mul_ne_zero hc ht)]
      field_simp
    _ = c * ∫ t in (0 : ℝ)..T, Real.sinc (c * t) := by
      rw [intervalIntegral.integral_const_mul]
    _ = ∫ u in (0 : ℝ)..(c * T), Real.sinc u := by
      simpa using intervalIntegral.mul_integral_comp_mul_left (f := Real.sinc) c

noncomputable def oscillatoryKernel (a b x t : ℝ) : ℂ :=
  ((Real.sin (t * (x - a)) - Real.sin (t * (x - b))) / t : ℝ) +
    Complex.I * ((Real.cos (t * (x - b)) - Real.cos (t * (x - a))) / t : ℝ)

lemma oscillatoryKernel_zero (a b x : ℝ) : oscillatoryKernel a b x 0 = 0 := by
  simp [oscillatoryKernel]

lemma oscillatoryKernel_add_neg {a b x t : ℝ} (ht : t ≠ 0) :
    oscillatoryKernel a b x t + oscillatoryKernel a b x (-t) =
      ((2 * (Real.sin ((b - x) * t) / t -
        Real.sin ((a - x) * t) / t) : ℝ) : ℂ) := by
  have hre :
      (Real.sin (t * (x - a)) - Real.sin (t * (x - b))) / t +
          (Real.sin ((-t) * (x - a)) - Real.sin ((-t) * (x - b))) / (-t) =
        2 * (Real.sin ((b - x) * t) / t - Real.sin ((a - x) * t) / t) := by
    rw [show (-t) * (x - a) = -(t * (x - a)) by ring,
      show (-t) * (x - b) = -(t * (x - b)) by ring,
      Real.sin_neg, Real.sin_neg]
    rw [show (b - x) * t = -(t * (x - b)) by ring,
      show (a - x) * t = -(t * (x - a)) by ring,
      Real.sin_neg, Real.sin_neg]
    field_simp [ht]
    ring
  have him :
      (Real.cos (t * (x - b)) - Real.cos (t * (x - a))) / t +
          (Real.cos ((-t) * (x - b)) - Real.cos ((-t) * (x - a))) / (-t) = 0 := by
    rw [show (-t) * (x - a) = -(t * (x - a)) by ring,
      show (-t) * (x - b) = -(t * (x - b)) by ring,
      Real.cos_neg, Real.cos_neg]
    field_simp [ht]
    ring
  apply Complex.ext
  · simpa only [oscillatoryKernel, Complex.add_re, Complex.ofReal_re, Complex.ofReal_im, Complex.mul_re,
      Complex.I_re, Complex.I_im, zero_mul, one_mul, sub_zero, add_zero] using hre
  · simp only [oscillatoryKernel, Complex.add_im, Complex.ofReal_im, Complex.mul_im,
      Complex.I_re, Complex.I_im, zero_mul, one_mul, zero_add, Complex.mul_re,
      Complex.ofReal_re]
    rw [him]

lemma intervalIntegrable_oscillatoryKernel (a b x s T : ℝ) :
    IntervalIntegrable (oscillatoryKernel a b x) volume s T := by
  rw [intervalIntegrable_iff]
  let K : ℝ := 2 * (|x - a| + |x - b|)
  have hmeas : AEStronglyMeasurable (oscillatoryKernel a b x)
      (volume.restrict (uIoc s T)) := by
    apply Measurable.aestronglyMeasurable
    unfold oscillatoryKernel
    fun_prop
  letI : IsFiniteMeasure (volume.restrict (uIoc s T)) :=
    IsFiniteMeasure.mk (by simp)
  refine MeasureTheory.Integrable.mono (integrable_const K) hmeas ?_
  filter_upwards with t
  by_cases ht : t = 0
  · subst t
    simp [oscillatoryKernel, K]
  have ht_abs : 0 < |t| := abs_pos.mpr ht
  have hr : |(Real.sin (t * (x - a)) - Real.sin (t * (x - b))) / t| ≤
      |x - a| + |x - b| := by
    rw [abs_div]
    apply (div_le_iff₀ ht_abs).2
    calc
      |Real.sin (t * (x - a)) - Real.sin (t * (x - b))| ≤
          |Real.sin (t * (x - a))| + |Real.sin (t * (x - b))| := abs_sub _ _
      _ ≤ |t * (x - a)| + |t * (x - b)| :=
        add_le_add Real.abs_sin_le_abs Real.abs_sin_le_abs
      _ = (|x - a| + |x - b|) * |t| := by
        rw [abs_mul, abs_mul]
        ring
  have hi : |(Real.cos (t * (x - b)) - Real.cos (t * (x - a))) / t| ≤
      |x - a| + |x - b| := by
    rw [abs_div]
    apply (div_le_iff₀ ht_abs).2
    calc
      |Real.cos (t * (x - b)) - Real.cos (t * (x - a))| ≤
          |t * (x - b) - t * (x - a)| := Real.abs_cos_sub_cos_le _ _
      _ ≤ |t * (x - b)| + |t * (x - a)| := abs_sub _ _
      _ = (|x - a| + |x - b|) * |t| := by
        rw [abs_mul, abs_mul]
        ring
  calc
    ‖oscillatoryKernel a b x t‖ ≤
        ‖(((Real.sin (t * (x - a)) - Real.sin (t * (x - b))) / t : ℝ) : ℂ)‖ +
        ‖Complex.I * (((Real.cos (t * (x - b)) - Real.cos (t * (x - a))) / t : ℝ) : ℂ)‖ := by
      rw [oscillatoryKernel]
      exact norm_add_le _ _
    _ = |(Real.sin (t * (x - a)) - Real.sin (t * (x - b))) / t| +
        |(Real.cos (t * (x - b)) - Real.cos (t * (x - a))) / t| := by
      simp only [Complex.norm_real, norm_mul, Complex.norm_I, one_mul, Real.norm_eq_abs]
    _ ≤ 2 * (|x - a| + |x - b|) := by linarith
    _ = ‖K‖ := by
      change 2 * (|x - a| + |x - b|) = ‖2 * (|x - a| + |x - b|)‖
      have hk : 0 ≤ 2 * (|x - a| + |x - b|) :=
        mul_nonneg (by norm_num) (add_nonneg (abs_nonneg _) (abs_nonneg _))
      rw [Real.norm_eq_abs, abs_of_nonneg hk]

lemma intervalIntegrable_sin_mul_div (c s T : ℝ) :
    IntervalIntegrable (fun t : ℝ => Real.sin (c * t) / t) volume s T := by
  by_cases hc : c = 0
  · simp [hc]
  have hgood : IntervalIntegrable (fun t : ℝ => c * Real.sinc (c * t))
      volume s T :=
    ((Real.continuous_sinc.comp (continuous_const.mul continuous_id)).const_mul c).intervalIntegrable s T
  apply hgood.congr_ae
  filter_upwards [Measure.ae_ne (volume.restrict (uIoc s T)) 0] with t ht
  rw [Real.sinc_of_ne_zero (mul_ne_zero hc ht)]
  field_simp

lemma integral_oscillatoryKernel_eq_sincIntervalKernel
    {a b x T : ℝ} (hT : 0 ≤ T) :
    (∫ t in (-T)..T, oscillatoryKernel a b x t) =
      (sincIntervalKernel a b T x : ℂ) := by
  have hleft := intervalIntegrable_oscillatoryKernel a b x (-T) 0
  have hright := intervalIntegrable_oscillatoryKernel a b x 0 T
  rw [← intervalIntegral.integral_add_adjacent_intervals
    (b := 0) hleft hright]
  have hneg := intervalIntegral.integral_comp_neg (f := oscillatoryKernel a b x)
    (a := 0) (b := T)
  simp only [neg_zero] at hneg
  rw [← hneg]
  have hrightneg : IntervalIntegrable (fun t => oscillatoryKernel a b x (-t))
      volume 0 T := by
    exact (by simpa only [neg_zero, neg_neg] using
      (IntervalIntegrable.iff_comp_neg).1 hleft.symm)
  rw [← intervalIntegral.integral_add hrightneg hright]
  let f : ℝ → ℝ := fun t => Real.sin ((b - x) * t) / t
  let g : ℝ → ℝ := fun t => Real.sin ((a - x) * t) / t
  have hf : IntervalIntegrable f volume 0 T :=
    intervalIntegrable_sin_mul_div (b - x) 0 T
  have hg : IntervalIntegrable g volume 0 T :=
    intervalIntegrable_sin_mul_div (a - x) 0 T
  have hreal : IntervalIntegrable (fun t => 2 * (f t - g t)) volume 0 T :=
    (hf.sub hg).const_mul 2
  calc
    (∫ t in (0 : ℝ)..T,
        oscillatoryKernel a b x (-t) + oscillatoryKernel a b x t) =
        ∫ t in (0 : ℝ)..T, ((2 * (f t - g t) : ℝ) : ℂ) := by
      apply intervalIntegral.integral_congr_ae
      filter_upwards [Measure.ae_ne volume 0] with t ht _
      simpa [f, g, add_comm] using oscillatoryKernel_add_neg (a := a) (b := b) (x := x) ht
    _ = ((∫ t in (0 : ℝ)..T, 2 * (f t - g t) : ℝ) : ℂ) := by
      simpa using Complex.ofRealCLM.intervalIntegral_comp_comm hreal
    _ = (sincIntervalKernel a b T x : ℂ) := by
      congr 1
      rw [intervalIntegral.integral_const_mul,
        intervalIntegral.integral_sub hf hg, integral_sin_mul_div,
        integral_sin_mul_div]
      simp [f, g, sincIntervalKernel]

lemma oscillatoryKernel_eq_exp {a b x t : ℝ} (ht : t ≠ 0) :
    oscillatoryKernel a b x t =
      (Complex.exp (((t * (x - a) : ℝ) : ℂ) * Complex.I) -
        Complex.exp (((t * (x - b) : ℝ) : ℂ) * Complex.I)) /
          (Complex.I * (t : ℂ)) := by
  rw [oscillatoryKernel, Complex.exp_ofReal_mul_I (t * (x - a)),
    Complex.exp_ofReal_mul_I (t * (x - b))]
  apply Complex.ext
  · simp only [Complex.add_re, Complex.sub_re, Complex.mul_re, Complex.div_re,
      Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im, Complex.I_mul_re, Complex.I_mul_im, Complex.mul_I_re, Complex.mul_I_im,
      zero_mul, mul_zero, add_zero, zero_add, one_mul, Complex.normSq_apply]
    field_simp [ht]
    simp only [Complex.add_re, Complex.add_im, Complex.sub_re, Complex.sub_im,
      Complex.mul_re, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im,
      Complex.I_re, Complex.I_im, zero_mul, mul_zero, add_zero, zero_add, one_mul]
    ring
  · simp only [Complex.add_im, Complex.sub_im, Complex.mul_im, Complex.div_im,
      Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im, Complex.I_mul_re, Complex.I_mul_im, Complex.mul_I_re, Complex.mul_I_im,
      zero_mul, mul_zero, add_zero, zero_add, one_mul, Complex.normSq_apply]
    field_simp [ht]
    simp only [Complex.add_re, Complex.add_im, Complex.sub_re, Complex.sub_im,
      Complex.mul_re, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im,
      Complex.I_re, Complex.I_im, zero_mul, mul_zero, add_zero, zero_add, one_mul]
    ring

noncomputable def textbookKernel (a b x t : ℝ) : ℂ :=
  (Complex.exp (-Complex.I * (t : ℂ) * (a : ℂ)) -
      Complex.exp (-Complex.I * (t : ℂ) * (b : ℂ))) /
    (Complex.I * (t : ℂ)) *
    Complex.exp (Complex.I * (t : ℂ) * (x : ℂ))

lemma textbookKernel_eq_oscillatoryKernel {a b x t : ℝ} (ht : t ≠ 0) :
    textbookKernel a b x t = oscillatoryKernel a b x t := by
  rw [oscillatoryKernel_eq_exp ht, textbookKernel]
  have hden : Complex.I * (t : ℂ) ≠ 0 := mul_ne_zero Complex.I_ne_zero (Complex.ofReal_ne_zero.mpr ht)
  field_simp [hden]
  rw [sub_mul, ← Complex.exp_add, ← Complex.exp_add]
  congr 1 <;> congr 1 <;> push_cast <;> ring

lemma textbookKernel_zero (a b x : ℝ) : textbookKernel a b x 0 = 0 := by
  simp [textbookKernel]

lemma textbookKernel_norm_le (a b x t : ℝ) :
    ‖textbookKernel a b x t‖ ≤ |b - a| := by
  by_cases ht : t = 0
  · subst t
    simp [textbookKernel]
  rw [textbookKernel, norm_mul, norm_div]
  have hexpnorm : ‖Complex.exp (Complex.I * (t : ℂ) * (x : ℂ))‖ = 1 := by
    rw [show Complex.I * (t : ℂ) * (x : ℂ) =
      Complex.I * ((t * x : ℝ) : ℂ) by push_cast; ring]
    exact Complex.norm_exp_I_mul_ofReal _
  rw [hexpnorm, mul_one]
  have hden : ‖Complex.I * (t : ℂ)‖ = |t| := by simp
  rw [hden]
  have hnum :
      ‖Complex.exp (-Complex.I * (t : ℂ) * (a : ℂ)) -
        Complex.exp (-Complex.I * (t : ℂ) * (b : ℂ))‖ ≤ |t| * |b - a| := by
    rw [show Complex.exp (-Complex.I * (t : ℂ) * (a : ℂ)) -
        Complex.exp (-Complex.I * (t : ℂ) * (b : ℂ)) =
      Complex.exp (-Complex.I * (t : ℂ) * (b : ℂ)) *
        (Complex.exp (Complex.I * ((t * (b - a) : ℝ) : ℂ)) - 1) by
          rw [mul_sub, mul_one, ← Complex.exp_add]
          congr 1
          push_cast
          ring]
    rw [norm_mul, show ‖Complex.exp (-Complex.I * (t : ℂ) * (b : ℂ))‖ = 1 by
      rw [show -Complex.I * (t : ℂ) * (b : ℂ) =
        Complex.I * ((-(t * b) : ℝ) : ℂ) by push_cast; ring]
      exact Complex.norm_exp_I_mul_ofReal _, one_mul]
    simpa [abs_mul, mul_comm] using thm_9_4 (t * (b - a))
  exact (div_le_iff₀ (abs_pos.mpr ht)).2 (by
    simpa [mul_comm] using hnum)

noncomputable def inversionIntegrand (μ : Measure ℝ) (a b t : ℝ) : ℂ :=
  (Complex.exp (-Complex.I * (t : ℂ) * (a : ℂ)) -
      Complex.exp (-Complex.I * (t : ℂ) * (b : ℂ))) /
    (Complex.I * (t : ℂ)) * characteristicFunction μ t

set_option maxHeartbeats 800000 in
lemma finite_inversion_fubini
    (μ : Measure ℝ) [IsProbabilityMeasure μ] {a b T : ℝ} (hT : 0 ≤ T) :
    (∫ t in (-T)..T, inversionIntegrand μ a b t) =
      ∫ x, (sincIntervalKernel a b T x : ℂ) ∂μ := by
  let ν := volume.restrict (uIoc (-T) T)
  letI : IsFiniteMeasure ν := IsFiniteMeasure.mk (by
    simp [ν])
  let f : ℝ → ℝ → ℂ := fun t x => textbookKernel a b x t
  have hfmeas : AEStronglyMeasurable (Function.uncurry f) (ν.prod μ) := by
    apply Measurable.aestronglyMeasurable
    dsimp [Function.uncurry, f, textbookKernel]
    fun_prop
  have hf : Integrable (Function.uncurry f) (ν.prod μ) := by
    apply (integrable_const |b - a|).mono hfmeas
    filter_upwards with p
    simpa [Function.uncurry, f, Real.norm_eq_abs] using textbookKernel_norm_le a b p.2 p.1
  calc
    (∫ t in (-T)..T, inversionIntegrand μ a b t) =
        ∫ t in (-T)..T, ∫ x, textbookKernel a b x t ∂μ := by
      apply intervalIntegral.integral_congr
      intro t _
      rw [inversionIntegrand, characteristicFunction, charFun_apply_real,
        ← MeasureTheory.integral_const_mul]
      apply MeasureTheory.integral_congr_ae
      filter_upwards with x
      congr 1
      congr 1
      rw [show t * x * Complex.I = Complex.I * (t : ℂ) * (x : ℂ) by
        push_cast
        ring]
    _ = ∫ x, (∫ t in (-T)..T, textbookKernel a b x t) ∂μ := by
      simpa [f, ν] using (intervalIntegral_integral_swap (μ := μ) hf)
    _ = ∫ x, (sincIntervalKernel a b T x : ℂ) ∂μ := by
      apply MeasureTheory.integral_congr_ae
      filter_upwards with x
      have heq := intervalIntegral.integral_congr_ae (a := -T) (b := T) <| by
        filter_upwards [Measure.ae_ne volume 0] with t ht _
        exact textbookKernel_eq_oscillatoryKernel (a := a) (b := b) (x := x) ht
      exact heq.trans (integral_oscillatoryKernel_eq_sincIntervalKernel (a := a) (b := b) (x := x) hT)

lemma integral_inversionLimitKernel
    (μ : Measure ℝ) [IsProbabilityMeasure μ] {a b : ℝ} (hab : a < b) :
    (∫ x, (inversionLimitKernel a b x : ℂ) ∂μ) =
      (2 * Real.pi : ℂ) * μ.real (Ioo a b) +
        (Real.pi : ℂ) * μ.real {a} + (Real.pi : ℂ) * μ.real {b} := by
  have hfun : (fun x : ℝ => (inversionLimitKernel a b x : ℂ)) =
      fun x =>
        (2 * Real.pi : ℂ) * (Ioo a b).indicator (fun _ : ℝ => (1 : ℂ)) x +
        (Real.pi : ℂ) * ({a} : Set ℝ).indicator (fun _ => (1 : ℂ)) x +
        (Real.pi : ℂ) * ({b} : Set ℝ).indicator (fun _ => (1 : ℂ)) x := by
    funext x
    simp only [inversionLimitKernel]
    by_cases hx : x ∈ Ioo a b
    · simp [hx, ne_of_gt hx.1, ne_of_lt hx.2]
    · by_cases hxa : x = a
      · subst x
        simp [hab.ne, hab.ne', Set.mem_Ioo]
      · by_cases hxb : x = b
        · subst x
          simp [hab.ne, hab.ne', Set.mem_Ioo]
        · simp [hx, hxa, hxb]
  have hIoo : Integrable
      ((Ioo a b).indicator (fun _ : ℝ => (1 : ℂ))) μ :=
    (integrable_const (1 : ℂ)).indicator measurableSet_Ioo
  have ha : Integrable
      (({a} : Set ℝ).indicator (fun _ : ℝ => (1 : ℂ))) μ :=
    (integrable_const (1 : ℂ)).indicator (measurableSet_singleton a)
  have hb : Integrable
      (({b} : Set ℝ).indicator (fun _ : ℝ => (1 : ℂ))) μ :=
    (integrable_const (1 : ℂ)).indicator (measurableSet_singleton b)
  rw [hfun]
  change (∫ x, ((fun x : ℝ =>
      (2 * Real.pi : ℂ) * (Ioo a b).indicator (fun _ : ℝ => (1 : ℂ)) x) +
      (fun x : ℝ =>
        (Real.pi : ℂ) * ({a} : Set ℝ).indicator (fun _ => (1 : ℂ)) x) +
      (fun x : ℝ =>
        (Real.pi : ℂ) * ({b} : Set ℝ).indicator (fun _ => (1 : ℂ)) x)) x ∂μ) = _
  rw [MeasureTheory.integral_add'
      ((hIoo.const_mul (2 * (Real.pi : ℂ))).add
        (ha.const_mul (Real.pi : ℂ)))
      (hb.const_mul (Real.pi : ℂ)),
    MeasureTheory.integral_add'
      (hIoo.const_mul (2 * (Real.pi : ℂ)))
      (ha.const_mul (Real.pi : ℂ)),
    MeasureTheory.integral_const_mul,
    MeasureTheory.integral_const_mul,
    MeasureTheory.integral_const_mul,
    MeasureTheory.integral_indicator_const (1 : ℂ) measurableSet_Ioo,
    MeasureTheory.integral_indicator_const (1 : ℂ) (measurableSet_singleton a),
    MeasureTheory.integral_indicator_const (1 : ℂ) (measurableSet_singleton b)]
  simp [Measure.real]

lemma tendsto_inversionIntegral
    (μ : Measure ℝ) [IsProbabilityMeasure μ] {a b : ℝ} (hab : a < b) :
    Tendsto (fun T : ℝ => ∫ t in (-T)..T, inversionIntegrand μ a b t) atTop
      (nhds ((2 * Real.pi : ℂ) * μ.real (Ioo a b) +
        (Real.pi : ℂ) * μ.real {a} + (Real.pi : ℂ) * μ.real {b})) := by
  have hkernel := tendsto_integral_sincIntervalKernel (μ := μ) hab
  rw [integral_inversionLimitKernel μ hab] at hkernel
  apply hkernel.congr'
  filter_upwards [eventually_ge_atTop (0 : ℝ)] with T hT
  exact (finite_inversion_fubini (a := a) (b := b) μ hT).symm

/-- The inversion formula for a probability measure on the real line. -/
theorem thm_9_5
    (μ : Measure ℝ) [IsProbabilityMeasure μ] {a b : ℝ} (hab : a < b) :
    Tendsto
      (fun T : ℝ => (1 / (2 * Real.pi) : ℂ) *
        ∫ t in (-T)..T,
          (Complex.exp (-Complex.I * (t : ℂ) * (a : ℂ)) -
              Complex.exp (-Complex.I * (t : ℂ) * (b : ℂ))) /
            (Complex.I * (t : ℂ)) * characteristicFunction μ t)
      atTop
      (nhds (((μ.real (Ioo a b) + μ.real {a} / 2 +
        μ.real {b} / 2 : ℝ) : ℂ))) := by
  have hconst : Tendsto (fun _ : ℝ => (1 / (2 * Real.pi) : ℂ)) atTop
      (nhds (1 / (2 * Real.pi) : ℂ)) := tendsto_const_nhds
  have h := hconst.mul (tendsto_inversionIntegral μ hab)
  simp only [inversionIntegrand] at h
  convert h using 1
  push_cast
  field_simp [Real.pi_ne_zero]
