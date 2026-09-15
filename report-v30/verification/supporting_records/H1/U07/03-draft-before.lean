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
