import Mathlib
import ProbabilityTheory.chapter_09.def_9_3

/-
TASK ID: thm_9_4
TYPE: Theorem_with_Proof
SOURCE PLAN: experiment_targets
TASK CONTENT:
\begin{thmbox}{9.4}
\[
\lvert e^{ix}-1\rvert\leq \lvert x\rvert
\]
for all $x\in\mathbb{R}$.
\end{thmbox}

\textit{Proof}
For fixed $x>0$, we have
\[
\int_0^x e^{iu}\,du
=\left[\frac{e^{iu}}{i}\right]_0^x
=\frac{e^{ix}-1}{i}.
\]
Hence, by the triangle inequality,
\[
\lvert e^{ix}-1\rvert\leq \int_0^x \lvert e^{iu}\rvert\,du=x.
\]
For negative $x$, we can write
\[
\lvert e^{ix}-1\rvert
=\lvert e^{ix}\rvert\lvert 1-e^{i(-x)}\rvert
=\lvert e^{i(-x)}-1\rvert
\leq -x.
\]
Therefore $\lvert e^{ix}-1\rvert\leq \lvert x\rvert$ for all $x\in\mathbb{R}$.
\hfill $\square$
-/

-- WRITE FINAL LEAN CODE BELOW

/-- For every real `x`, the point `exp (i x)` on the unit circle is at most
`|x|` away from `1`. -/
theorem thm_9_4 (x : ℝ) :
    ‖Complex.exp (Complex.I * (x : ℂ)) - 1‖ ≤ |x| := by
  rw [Complex.norm_exp_I_mul_ofReal_sub_one]
  calc
    ‖(2 : ℝ) * Real.sin (x / 2)‖ = 2 * |Real.sin (x / 2)| := by simp [Real.norm_eq_abs]
    _ ≤ 2 * |x / 2| := mul_le_mul_of_nonneg_left Real.abs_sin_le_abs (by norm_num)
    _ = |x| := by rw [abs_div]; norm_num; ring
