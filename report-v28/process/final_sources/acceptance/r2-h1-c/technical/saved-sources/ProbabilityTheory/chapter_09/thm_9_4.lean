import Mathlib.Analysis.SpecialFunctions.Trigonometric.Bounds

/-!
# Theorem 9.4

The distance from a point on the unit circle to `1` is bounded by the
absolute value of its argument.
-/

/-- For every real `x`, `|exp (i x) - 1| ≤ |x|`. -/
theorem thm_9_4 (x : ℝ) :
    ‖Complex.exp (Complex.I * (x : ℂ)) - 1‖ ≤ |x| := by
  simpa only [Real.norm_eq_abs] using
    (Real.norm_exp_I_mul_ofReal_sub_one_le (x := x))
