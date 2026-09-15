import Mathlib

/-
TASK ID: prob_12_5
TYPE: Problem
SOURCE PLAN: experiment_targets
TASK CONTENT:
\textbf{12.5.} We model the temperature in a forest by a random variable X. Suppose that

the mean \mu and the variance \sigma2

0 are known. The temperature is measured by a

sensor. The output of the sensor Y 1 = X + N1 is corrupted by Gaussian noise

N1 N( 0,\sigma 2

1 )Assume that N1 and X are independent, and the variance \sigma2

1 is

known.

(a) We can estimate X by \alpha(Y1 - \mu)+\mu. Find the optimal choice of constant \alpha that

minimizes the mean-squared error E[(X - \mu - \alpha(Y1 - \mu))2].

(b) We install another temperature sensor. The measurement of the second sensor is

Y2 = X + N2, where N2 N(0,\sigma 2

2 )Assume X, N1, and N2 are independent,

and the variance \sigma 2

2 is known. Find the optimal values of \alpha and \beta that minimize

E[(X - \mu - \alpha(Y1 - \mu) - \beta(Y2 - \mu))2].
-/

-- WRITE FINAL LEAN CODE BELOW

-- patch transport check

open MeasureTheory ProbabilityTheory

noncomputable def oneSensorMSE {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X N : Ω → ℝ) (μ α : ℝ) : ℝ :=
  ∫ ω, (X ω - (μ + α * (X ω + N ω - μ))) ^ 2 ∂P

noncomputable def twoSensorMSE {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X N₁ N₂ : Ω → ℝ) (μ α β : ℝ) : ℝ :=
  ∫ ω, (X ω - (μ + α * (X ω + N₁ ω - μ) +
    β * (X ω + N₂ ω - μ))) ^ 2 ∂P

lemma integral_sq_linear_combination {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} {A B : Ω → ℝ} (hA : MemLp A 2 P) (hB : MemLp B 2 P)
    (c d : ℝ) :
    ∫ ω, (c * A ω + d * B ω) ^ 2 ∂P =
      c ^ 2 * ∫ ω, A ω ^ 2 ∂P + d ^ 2 * ∫ ω, B ω ^ 2 ∂P +
        (2 * c * d) * ∫ ω, A ω * B ω ∂P := by
  have hA2 := hA.integrable_sq
  have hB2 := hB.integrable_sq
  have hAB : Integrable (fun ω => A ω * B ω) P := by
    change Integrable (A * B) P
    exact hA.integrable_mul hB
  calc
    _ = ∫ ω, c ^ 2 * A ω ^ 2 + d ^ 2 * B ω ^ 2 +
          (2 * c * d) * (A ω * B ω) ∂P := by
      apply integral_congr_ae
      filter_upwards [] with ω
      ring
    _ = _ := by
      have hfg := integral_add (hA2.const_mul (c^2)) (hB2.const_mul (d^2))
      have hsum := integral_add ((hA2.const_mul (c^2)).add (hB2.const_mul (d^2)))
        (hAB.const_mul (2*c*d))
      simp only [Pi.add_apply, Pi.mul_apply, integral_const_mul] at hfg hsum
      rw [hsum, hfg]

def threeSources {Ω : Type*} (X N₁ N₂ : Ω → ℝ) : Fin 3 → Ω → ℝ := ![X, N₁, N₂]

/-- Problem 12.5, including derivation of noise moments, cross-term cancellation,
the two quadratic errors, global minimizers, and zero-denominator boundaries. -/
theorem prob_12_5 {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω)
    [IsProbabilityMeasure P] (X N₁ N₂ : Ω → ℝ) (μ s0 s1 s2 : ℝ)
    (hσ₀ : 0 ≤ s0) (hσ₁ : 0 ≤ s1) (hσ₂ : 0 ≤ s2)
    (hX : MemLp X 2 P) (hXmean : ∫ ω, X ω ∂P = μ)
    (hXvar : Var[X; P] = s0)
    (hN₁ : HasLaw N₁ (gaussianReal 0 ⟨s1, hσ₁⟩) P)
    (hN₂ : HasLaw N₂ (gaussianReal 0 ⟨s2, hσ₂⟩) P)
    (hindep : iIndepFun (threeSources X N₁ N₂) P) :
    (∫ ω, N₁ ω ∂P = 0) ∧ (∫ ω, N₂ ω ∂P = 0) ∧
    Var[N₁; P] = s1 ∧ Var[N₂; P] = s2 ∧
    (∫ ω, (X ω - μ) * N₁ ω ∂P = 0) ∧
    (∫ ω, (X ω - μ) * N₂ ω ∂P = 0) ∧
    (∫ ω, N₁ ω * N₂ ω ∂P = 0) ∧
    (∀ α, oneSensorMSE P X N₁ μ α = s0 * (1 - α)^2 + s1 * α^2) ∧
    (0 < s0 + s1 → ∀ α, oneSensorMSE P X N₁ μ (s0/(s0+s1)) ≤
      oneSensorMSE P X N₁ μ α) ∧
    (s0 + s1 = 0 → ∀ α, oneSensorMSE P X N₁ μ α = 0) ∧
    (∀ α β, twoSensorMSE P X N₁ N₂ μ α β =
      s0*(1-α-β)^2 + s1*α^2 + s2*β^2) ∧
    (0 < s0*s1 + s0*s2 + s1*s2 → ∀ α β,
      twoSensorMSE P X N₁ N₂ μ
        (s0*s2/(s0*s1+s0*s2+s1*s2))
        (s0*s1/(s0*s1+s0*s2+s1*s2)) ≤
      twoSensorMSE P X N₁ N₂ μ α β) ∧
    (s0*s1 + s0*s2 + s1*s2 = 0 →
      ∃ α β, twoSensorMSE P X N₁ N₂ μ α β = 0) := by
  have m1 : ∫ ω, N₁ ω ∂P = 0 := by rw [hN₁.integral_eq]; exact integral_id_gaussianReal
  have m2 : ∫ ω, N₂ ω ∂P = 0 := by rw [hN₂.integral_eq]; exact integral_id_gaussianReal
  have v1 : Var[N₁; P] = s1 := by rw [hN₁.variance_eq, variance_id_gaussianReal]; rfl
  have v2 : Var[N₂; P] = s2 := by rw [hN₂.variance_eq, variance_id_gaussianReal]; rfl
  have l1 : MemLp N₁ 2 P := by
    rw [← Function.id_comp N₁,
      ← memLp_map_measure_iff aestronglyMeasurable_id hN₁.aemeasurable, hN₁.map_eq]
    exact memLp_id_gaussianReal' 2 (by simp)
  have l2 : MemLp N₂ 2 P := by
    rw [← Function.id_comp N₂,
      ← memLp_map_measure_iff aestronglyMeasurable_id hN₂.aemeasurable, hN₂.map_eq]
    exact memLp_id_gaussianReal' 2 (by simp)
  let A : Ω → ℝ := fun ω => X ω - μ
  have lA : MemLp A 2 P := hX.sub (memLp_const μ)
  have mA : ∫ ω, A ω ∂P = 0 := by
    rw [show A = fun ω => X ω - μ by rfl,
      integral_sub (hX.integrable (by norm_num)) (integrable_const μ)]
    simp [hXmean]
  have qA : ∫ ω, A ω ^ 2 ∂P = s0 := by
    rw [← hXvar, variance_eq_integral hX.aemeasurable, hXmean]
  have q1 : ∫ ω, N₁ ω ^ 2 ∂P = s1 := by
    rw [← v1, variance_of_integral_eq_zero hN₁.aemeasurable m1]
  have q2 : ∫ ω, N₂ ω ^ 2 ∂P = s2 := by
    rw [← v2, variance_of_integral_eq_zero hN₂.aemeasurable m2]
  have xi1 : X ⟂ᵢ[P] N₁ := by
    simpa [threeSources] using hindep.indepFun (i := (0 : Fin 3)) (j := (1 : Fin 3)) (by decide)
  have xi2 : X ⟂ᵢ[P] N₂ := by
    simpa [threeSources] using hindep.indepFun (i := (0 : Fin 3)) (j := (2 : Fin 3)) (by decide)
  have i12 : N₁ ⟂ᵢ[P] N₂ := by
    simpa [threeSources] using hindep.indepFun (i := (1 : Fin 3)) (j := (2 : Fin 3)) (by decide)
  have ai1 : A ⟂ᵢ[P] N₁ := by
    simpa [A, Function.comp_def] using xi1.comp (measurable_id.sub measurable_const) measurable_id
  have ai2 : A ⟂ᵢ[P] N₂ := by
    simpa [A, Function.comp_def] using xi2.comp (measurable_id.sub measurable_const) measurable_id
  have c1 : ∫ ω, A ω * N₁ ω ∂P = 0 := by
    rw [ai1.integral_fun_mul_eq_mul_integral lA.aestronglyMeasurable l1.aestronglyMeasurable,
      mA, m1, zero_mul]
  have c2 : ∫ ω, A ω * N₂ ω ∂P = 0 := by
    rw [ai2.integral_fun_mul_eq_mul_integral lA.aestronglyMeasurable l2.aestronglyMeasurable,
      mA, m2, zero_mul]
  have c12 : ∫ ω, N₁ ω * N₂ ω ∂P = 0 := by
    rw [i12.integral_fun_mul_eq_mul_integral l1.aestronglyMeasurable l2.aestronglyMeasurable,
      m1, m2, zero_mul]
  have one : ∀ α, oneSensorMSE P X N₁ μ α = s0*(1-α)^2 + s1*α^2 := by
    intro α
    rw [oneSensorMSE]
    calc
      _ = ∫ ω, ((1-α)*A ω + (-α)*N₁ ω)^2 ∂P := by
        apply integral_congr_ae
        filter_upwards [] with ω
        simp only [A]
        congr 1
        ring
      _ = _ := by rw [integral_sq_linear_combination lA l1, qA, q1, c1]; ring
  have two : ∀ α β, twoSensorMSE P X N₁ N₂ μ α β =
      s0*(1-α-β)^2 + s1*α^2 + s2*β^2 := by
    intro α β
    rw [twoSensorMSE]
    have lC : MemLp (fun ω => (1-α-β)*A ω + (-α)*N₁ ω) 2 P :=
      (lA.const_mul _).add (l1.const_mul _)
    have cC : ∫ ω, (((1-α-β)*A ω + (-α)*N₁ ω)*N₂ ω) ∂P = 0 := by
      calc
        _ = ∫ ω, (1-α-β)*(A ω*N₂ ω) + (-α)*(N₁ ω*N₂ ω) ∂P := by
          apply integral_congr_ae
          filter_upwards [] with ω
          ring
        _ = (1-α-β)*(∫ ω, A ω*N₂ ω ∂P) + (-α)*(∫ ω, N₁ ω*N₂ ω ∂P) := by
          have hs := integral_add ((lA.integrable_mul l2).const_mul (1-α-β))
            ((l1.integrable_mul l2).const_mul (-α))
          simpa only [Pi.add_apply, Pi.mul_apply, integral_const_mul] using hs
        _ = 0 := by rw [c2, c12]; ring
    calc
      _ = ∫ ω, (((1-α-β)*A ω + (-α)*N₁ ω) + (-β)*N₂ ω)^2 ∂P := by
        apply integral_congr_ae
        filter_upwards [] with ω
        simp only [A]
        congr 1
        ring
      _ = _ := by
        have hout := integral_sq_linear_combination lC l2 1 (-β)
        simp only [one_mul, one_pow] at hout
        rw [hout, integral_sq_linear_combination lA l1, qA, q1, q2, c1, cC]
        ring
  refine ⟨m1, m2, v1, v2, ?_, ?_, c12, one, ?_, ?_, two, ?_, ?_⟩
  · simpa [A] using c1
  · simpa [A] using c2
  · intro hd α
    rw [one, one]
    have hn := sq_nonneg ((s0+s1)*α-s0)
    field_simp [ne_of_gt hd]
    nlinarith
  · intro hd α
    have z0 : s0 = 0 := by nlinarith
    have z1 : s1 = 0 := by nlinarith
    rw [one, z0, z1]
    ring
  · intro hd α β
    let D := s0*s1 + s0*s2 + s1*s2
    let a := s0*s2/D
    let b := s0*s1/D
    have hnD : D ≠ 0 := ne_of_gt hd
    have hs1 : s0*(1-a-b) = s1*a := by
      dsimp [a, b]
      field_simp [hnD]
      dsimp [D]
      ring
    have hs2 : s0*(1-a-b) = s2*b := by
      dsimp [a, b]
      field_simp [hnD]
      dsimp [D]
      ring
    rw [two, two]
    change s0*(1-a-b)^2 + s1*a^2 + s2*b^2 ≤ _
    have hdiff :
        s0*(1-α-β)^2 + s1*α^2 + s2*β^2 -
          (s0*(1-a-b)^2 + s1*a^2 + s2*b^2) =
        s0*((α-a)+(β-b))^2 + s1*(α-a)^2 + s2*(β-b)^2 := by
      linear_combination -2*(α-a)*hs1 - 2*(β-b)*hs2
    nlinarith [hdiff, mul_nonneg hσ₀ (sq_nonneg ((α-a)+(β-b))),
      mul_nonneg hσ₁ (sq_nonneg (α-a)), mul_nonneg hσ₂ (sq_nonneg (β-b))]
  · intro hd
    have hp01 : 0 ≤ s0*s1 := mul_nonneg hσ₀ hσ₁
    have hp02 : 0 ≤ s0*s2 := mul_nonneg hσ₀ hσ₂
    have hp12 : 0 ≤ s1*s2 := mul_nonneg hσ₁ hσ₂
    have p01 : s0*s1 = 0 := by linarith
    have p02 : s0*s2 = 0 := by linarith
    by_cases z0 : s0 = 0
    · exact ⟨0, 0, by rw [two, z0]; simp⟩
    · have z1 : s1 = 0 := (mul_eq_zero.mp p01).resolve_left z0
      have z2 : s2 = 0 := (mul_eq_zero.mp p02).resolve_left z0
      exact ⟨1, 0, by rw [two, z1, z2]; ring⟩
