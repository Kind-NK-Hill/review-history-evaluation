import Mathlib

/-
TASK ID: def_9_1
TYPE: Definition
SOURCE PLAN: chapter9-moments-mgf
TASK CONTENT:
\begin{defbox}{9.1}
For an integer $r \geq 1$, the $r$-th moment of $X$ is defined as the expectation $\mathbb{E}[X^r]$. The $r$-th central moment is defined by $\mathbb{E}[(X-\mathbb{E}[X])^r]$. In particular, the second central moment is commonly called the variance of $X$; the square root of variance is called the standard deviation.

The third central moment measures the asymmetry of the probability distribution. The skewness of a random variable is defined as the third central moment normalized by the cube of the standard deviation $\sigma$,
\[
\frac{\mathbb{E}[(X-\mathbb{E}[X])^3]}{\sigma^3}.
\]
The analogous quantity of order $4$ is called the kurtosis,
\[
\frac{\mathbb{E}[(X-\mathbb{E}[X])^4]}{\sigma^4}.
\]
It measures the tailedness of the probability distribution.
\end{defbox}
-/

-- WRITE FINAL LEAN CODE BELOW

open MeasureTheory ProbabilityTheory

/-- Measurability together with finiteness of the absolute moment of order `r`. -/
def FiniteAbsMoment {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) (r : ℕ) : Prop :=
  Measurable X ∧ Integrable (fun ω => |X ω| ^ r) μ

namespace FiniteAbsMoment

theorem measurable {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    {X : Ω → ℝ} {r : ℕ} (hX : FiniteAbsMoment μ X r) :
    Measurable X :=
  hX.1

theorem integrable_abs_pow {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    {X : Ω → ℝ} {r : ℕ} (hX : FiniteAbsMoment μ X r) :
    Integrable (fun ω => |X ω| ^ r) μ :=
  hX.2

/-- An `L^r` random variable with an everywhere-measurable representative has
the corresponding finite absolute moment, including at order zero. -/
theorem of_memLp {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {X : Ω → ℝ} {r : ℕ}
    (hXm : Measurable X) (hX : MemLp X r μ) :
    FiniteAbsMoment μ X r := by
  refine ⟨hXm, ?_⟩
  simpa [Real.norm_eq_abs] using hX.integrable_norm_pow'

/-- On a probability space, finiteness of a higher absolute moment implies
finiteness of every lower absolute moment. -/
theorem mono {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {X : Ω → ℝ} {r s : ℕ}
    (hX : FiniteAbsMoment μ X s) (hrs : r ≤ s) :
    FiniteAbsMoment μ X r := by
  refine ⟨hX.1, ?_⟩
  simpa [Real.norm_eq_abs] using
    integrable_norm_pow_of_le hX.1.aestronglyMeasurable hrs
      (by simpa [Real.norm_eq_abs] using hX.2)

/-- A positive finite absolute moment places the variable in the matching
`L^r` space. -/
theorem memLp {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {X : Ω → ℝ} {r : ℕ}
    (hX : FiniteAbsMoment μ X r) (hr : r ≠ 0) :
    MemLp X r μ := by
  rw [← integrable_norm_rpow_iff hX.1.aestronglyMeasurable
    (by exact_mod_cast hr) (by simp)]
  simpa [Real.norm_eq_abs] using hX.2

/-- A positive finite absolute moment also makes the corresponding centered
absolute moment finite. -/
theorem centered {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
    [IsProbabilityMeasure μ] {X : Ω → ℝ} {r : ℕ}
    (hX : FiniteAbsMoment μ X r) (hr : 1 ≤ r) :
    FiniteAbsMoment μ (fun ω => X ω - ∫ x, X x ∂μ) r := by
  have hX_mem : MemLp X r μ := hX.memLp (Nat.ne_of_gt hr)
  have hcenter_mem :
      MemLp (fun ω => X ω - ∫ x, X x ∂μ) r μ :=
    hX_mem.sub (memLp_const (μ := μ) (∫ x, X x ∂μ))
  exact of_memLp (hX.1.sub measurable_const) hcenter_mem

end FiniteAbsMoment

/-- The unrestricted mathematical moment operator.  Order zero is intentional:
downstream even-moment formulas use it when `2 * k = 0`. -/
noncomputable def generalMoment {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] (X : Ω → ℝ) (r : ℕ)
    (_hX : FiniteAbsMoment μ X r) : ℝ :=
  moment X r μ

abbrev PositiveOrder := {r : ℕ // 1 ≤ r}

abbrev positiveOrderOne : PositiveOrder := ⟨1, by norm_num⟩
abbrev positiveOrderTwo : PositiveOrder := ⟨2, by norm_num⟩
abbrev positiveOrderThree : PositiveOrder := ⟨3, by norm_num⟩
abbrev positiveOrderFour : PositiveOrder := ⟨4, by norm_num⟩

noncomputable def rthMoment {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] (X : Ω → ℝ)
    (r : PositiveOrder) (hX : FiniteAbsMoment μ X r.1) : ℝ :=
  generalMoment μ X r.1 hX

noncomputable def rthCentralMoment {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] (X : Ω → ℝ)
    (r : PositiveOrder) (_hX : FiniteAbsMoment μ X r.1) : ℝ :=
  centralMoment X r.1 μ

noncomputable def variance {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] (X : Ω → ℝ)
    (hX : FiniteAbsMoment μ X 2) : ℝ :=
  rthCentralMoment μ X positiveOrderTwo hX

noncomputable def standardDeviation {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] (X : Ω → ℝ)
    (hX : FiniteAbsMoment μ X 2) : ℝ :=
  Real.sqrt (variance μ X hX)

noncomputable def skewness {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] (X : Ω → ℝ)
    (hX2 : FiniteAbsMoment μ X 2) (hX3 : FiniteAbsMoment μ X 3)
    (_hvar : 0 < variance μ X hX2) : ℝ :=
  rthCentralMoment μ X positiveOrderThree hX3 /
    standardDeviation μ X hX2 ^ 3

noncomputable def kurtosis {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] (X : Ω → ℝ)
    (hX2 : FiniteAbsMoment μ X 2) (hX4 : FiniteAbsMoment μ X 4)
    (_hvar : 0 < variance μ X hX2) : ℝ :=
  rthCentralMoment μ X positiveOrderFour hX4 /
    standardDeviation μ X hX2 ^ 4

noncomputable def def_9_1 {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) [IsProbabilityMeasure μ] (X : Ω → ℝ)
    (r : PositiveOrder) (hX : FiniteAbsMoment μ X r.1) : ℝ × ℝ :=
  (rthMoment μ X r hX, rthCentralMoment μ X r hX)
