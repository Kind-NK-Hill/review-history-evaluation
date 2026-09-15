import Mathlib
import ProbabilityTheory.chapter_12.def_12_2
import ProbabilityTheory.chapter_12.thm_12_1
import ProbabilityTheory.chapter_12.thm_12_5

/-! # Problem 12.5: one- and two-sensor linear MMSE -/

open MeasureTheory ProbabilityTheory
noncomputable section

def sensorMSE1 {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω)
    (X N : Ω → ℝ) (μ α : ℝ) : ℝ :=
  ∫ ω, (X ω - μ - α * (X ω + N ω - μ)) ^ 2 ∂P

def sensorMSE2 {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω)
    (X N₁ N₂ : Ω → ℝ) (μ α β : ℝ) : ℝ :=
  ∫ ω, (X ω - μ - α * (X ω + N₁ ω - μ) -
    β * (X ω + N₂ ω - μ)) ^ 2 ∂P

def sensorQuadratic1 (v₀ v₁ α : ℝ) : ℝ :=
  (1 - α) ^ 2 * v₀ + α ^ 2 * v₁

def sensorQuadratic2 (v₀ v₁ v₂ α β : ℝ) : ℝ :=
  (1 - α - β) ^ 2 * v₀ + α ^ 2 * v₁ + β ^ 2 * v₂

def sensorDenominator2 (v₀ v₁ v₂ : ℝ) : ℝ :=
  v₀ * v₁ + v₀ * v₂ + v₁ * v₂

private lemma integrable_sq_of_memLp_two {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} {Z : Ω → ℝ} (hZ : MemLp Z 2 P) :
    Integrable (fun ω ↦ (Z ω) ^ 2) P := by
  simpa [Real.norm_eq_abs, sq_abs] using hZ.integrable_norm_pow

theorem centered_second_moment_eq_variance {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} {Z : Ω → ℝ} {m v : ℝ}
    (hZ : MemLp Z 2 P) (hm : ∫ ω, Z ω ∂P = m) (hv : Var[Z; P] = v) :
    ∫ ω, (Z ω - m) ^ 2 ∂P = v := by
  rw [← hv, variance_eq_integral hZ.aemeasurable, hm]

theorem integral_centered_eq_zero {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P] {Z : Ω → ℝ} {m : ℝ}
    (hZ : MemLp Z 2 P) (hm : ∫ ω, Z ω ∂P = m) :
    ∫ ω, (Z ω - m) ∂P = 0 := by
  rw [integral_sub (hZ.integrable (by norm_num)) (integrable_const m), hm]
  simp

/-- Independence and zero means imply a zero mixed moment. -/
theorem mixed_moment_eq_zero_of_indep {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P] {U V : Ω → ℝ}
    (hU : MemLp U 2 P) (hV : MemLp V 2 P) (hUV : IndepFun U V P)
    (hU0 : ∫ ω, U ω ∂P = 0) (hV0 : ∫ ω, V ω ∂P = 0) :
    ∫ ω, U ω * V ω ∂P = 0 := by
  rw [hUV.integral_fun_mul_eq_mul_integral
    hU.aestronglyMeasurable hV.aestronglyMeasurable, hU0, hV0, zero_mul]

/-- Source independence forces the centered signal/noise cross term to zero. -/
theorem centered_noise_mixed_moment_eq_zero {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P] {X N : Ω → ℝ} {μ : ℝ}
    (hX : MemLp X 2 P) (hN : MemLp N 2 P) (hXN : IndepFun X N P)
    (hXmean : ∫ ω, X ω ∂P = μ) (hNmean : ∫ ω, N ω ∂P = 0) :
    ∫ ω, (X ω - μ) * N ω ∂P = 0 := by
  have hcenter : MemLp (fun ω ↦ X ω - μ) 2 P := hX.sub (memLp_const μ)
  have hind : IndepFun (fun ω ↦ X ω - μ) N P := by
    simpa [Function.comp_def] using
      hXN.comp (measurable_id.sub measurable_const) measurable_id
  exact mixed_moment_eq_zero_of_indep hcenter hN hind
    (integral_centered_eq_zero hX hXmean) hNmean

/-- The true one-sensor integral equals its quadratic form. -/
theorem sensorMSE1_eq_quadratic {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P] {X N : Ω → ℝ} {μ v₀ v₁ : ℝ}
    (hX : MemLp X 2 P) (hN : MemLp N 2 P) (hXN : IndepFun X N P)
    (hXmean : ∫ ω, X ω ∂P = μ) (hNmean : ∫ ω, N ω ∂P = 0)
    (hXvar : Var[X; P] = v₀) (hNvar : Var[N; P] = v₁) (α : ℝ) :
    sensorMSE1 P X N μ α = sensorQuadratic1 v₀ v₁ α := by
  have hXc : MemLp (fun ω ↦ X ω - μ) 2 P := hX.sub (memLp_const μ)
  have hXsq : Integrable (fun ω ↦ (X ω - μ) ^ 2) P := integrable_sq_of_memLp_two hXc
  have hNsq : Integrable (fun ω ↦ N ω ^ 2) P := integrable_sq_of_memLp_two hN
  have hcross : Integrable (fun ω ↦ (X ω - μ) * N ω) P := hXc.integrable_mul hN
  have hcross0 := centered_noise_mixed_moment_eq_zero hX hN hXN hXmean hNmean
  have hX2 := centered_second_moment_eq_variance hX hXmean hXvar
  have hN2 : ∫ ω, N ω ^ 2 ∂P = v₁ := by
    simpa using centered_second_moment_eq_variance hN hNmean hNvar
  rw [sensorMSE1, sensorQuadratic1]
  have hp : (fun ω ↦ (X ω - μ - α * (X ω + N ω - μ)) ^ 2) =
      fun ω ↦ (1 - α) ^ 2 * (X ω - μ) ^ 2 + α ^ 2 * N ω ^ 2 -
        (2 * (1 - α) * α) * ((X ω - μ) * N ω) := by funext ω; ring
  rw [hp]
  let A := fun ω ↦ (1 - α) ^ 2 * (X ω - μ) ^ 2
  let B := fun ω ↦ α ^ 2 * N ω ^ 2
  let C := fun ω ↦ (2 * (1 - α) * α) * ((X ω - μ) * N ω)
  have hA : Integrable A P := hXsq.const_mul _
  have hB : Integrable B P := hNsq.const_mul _
  have hC : Integrable C P := hcross.const_mul _
  change (∫ ω, (A + B) ω - C ω ∂P) = _
  calc
    _ = (∫ ω, A ω + B ω ∂P) - ∫ ω, C ω ∂P := integral_sub (hA.add hB) hC
    _ = ((∫ ω, A ω ∂P) + ∫ ω, B ω ∂P) - ∫ ω, C ω ∂P := by
      rw [integral_add hA hB]
    _ = _ := by
      dsimp [A, B, C]
      rw [integral_const_mul, integral_const_mul, integral_const_mul,
        hX2, hN2, hcross0]
      ring

/-- The true two-sensor integral equals its quadratic form. -/
theorem sensorMSE2_eq_quadratic {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P] {X N₁ N₂ : Ω → ℝ} {μ v₀ v₁ v₂ : ℝ}
    (hX : MemLp X 2 P) (hN₁ : MemLp N₁ 2 P) (hN₂ : MemLp N₂ 2 P)
    (hXN₁ : IndepFun X N₁ P) (hXN₂ : IndepFun X N₂ P) (hN₁N₂ : IndepFun N₁ N₂ P)
    (hXmean : ∫ ω, X ω ∂P = μ)
    (hN₁mean : ∫ ω, N₁ ω ∂P = 0) (hN₂mean : ∫ ω, N₂ ω ∂P = 0)
    (hXvar : Var[X; P] = v₀) (hN₁var : Var[N₁; P] = v₁)
    (hN₂var : Var[N₂; P] = v₂) (α β : ℝ) :
    sensorMSE2 P X N₁ N₂ μ α β = sensorQuadratic2 v₀ v₁ v₂ α β := by
  have hXc : MemLp (fun ω ↦ X ω - μ) 2 P := hX.sub (memLp_const μ)
  have hXsq := integrable_sq_of_memLp_two hXc
  have hN₁sq := integrable_sq_of_memLp_two hN₁
  have hN₂sq := integrable_sq_of_memLp_two hN₂
  have hXN₁int : Integrable (fun ω ↦ (X ω - μ) * N₁ ω) P := hXc.integrable_mul hN₁
  have hXN₂int : Integrable (fun ω ↦ (X ω - μ) * N₂ ω) P := hXc.integrable_mul hN₂
  have hN₁N₂int : Integrable (fun ω ↦ N₁ ω * N₂ ω) P := hN₁.integrable_mul hN₂
  have hXN₁0 := centered_noise_mixed_moment_eq_zero hX hN₁ hXN₁ hXmean hN₁mean
  have hXN₂0 := centered_noise_mixed_moment_eq_zero hX hN₂ hXN₂ hXmean hN₂mean
  have hN₁N₂0 := mixed_moment_eq_zero_of_indep hN₁ hN₂ hN₁N₂ hN₁mean hN₂mean
  have hX2 := centered_second_moment_eq_variance hX hXmean hXvar
  have hN₁2 : ∫ ω, N₁ ω ^ 2 ∂P = v₁ := by
    simpa using centered_second_moment_eq_variance hN₁ hN₁mean hN₁var
  have hN₂2 : ∫ ω, N₂ ω ^ 2 ∂P = v₂ := by
    simpa using centered_second_moment_eq_variance hN₂ hN₂mean hN₂var
  rw [sensorMSE2, sensorQuadratic2]
  have hp : (fun ω ↦ (X ω - μ - α * (X ω + N₁ ω - μ) -
        β * (X ω + N₂ ω - μ)) ^ 2) = fun ω ↦
      (1 - α - β) ^ 2 * (X ω - μ) ^ 2 + α ^ 2 * N₁ ω ^ 2 + β ^ 2 * N₂ ω ^ 2 -
      (2 * (1 - α - β) * α) * ((X ω - μ) * N₁ ω) -
      (2 * (1 - α - β) * β) * ((X ω - μ) * N₂ ω) +
      (2 * α * β) * (N₁ ω * N₂ ω) := by funext ω; ring
  rw [hp]
  let A := fun ω ↦ (1 - α - β) ^ 2 * (X ω - μ) ^ 2
  let B := fun ω ↦ α ^ 2 * N₁ ω ^ 2
  let C := fun ω ↦ β ^ 2 * N₂ ω ^ 2
  let R := fun ω ↦ (2 * (1 - α - β) * α) * ((X ω - μ) * N₁ ω)
  let S := fun ω ↦ (2 * (1 - α - β) * β) * ((X ω - μ) * N₂ ω)
  let T := fun ω ↦ (2 * α * β) * (N₁ ω * N₂ ω)
  have hA : Integrable A P := hXsq.const_mul _
  have hB : Integrable B P := hN₁sq.const_mul _
  have hC : Integrable C P := hN₂sq.const_mul _
  have hR : Integrable R P := hXN₁int.const_mul _
  have hS : Integrable S P := hXN₂int.const_mul _
  have hT : Integrable T P := hN₁N₂int.const_mul _
  change (∫ ω, (((A + B + C - R - S) ω) + T ω) ∂P) = _
  calc
    _ = (∫ ω, (A + B + C - R - S) ω ∂P) + ∫ ω, T ω ∂P :=
      integral_add (((hA.add hB).add hC).sub hR |>.sub hS) hT
    _ = _ := by
      have eS : (∫ ω, (A + B + C - R - S) ω ∂P) =
          (∫ ω, (A + B + C - R) ω ∂P) - ∫ ω, S ω ∂P := by
        change (∫ ω, (A + B + C - R) ω - S ω ∂P) = _
        exact integral_sub ((hA.add hB).add hC |>.sub hR) hS
      have eR : (∫ ω, (A + B + C - R) ω ∂P) =
          (∫ ω, (A + B + C) ω ∂P) - ∫ ω, R ω ∂P := by
        change (∫ ω, (A + B + C) ω - R ω ∂P) = _
        exact integral_sub ((hA.add hB).add hC) hR
      have eC : (∫ ω, (A + B + C) ω ∂P) =
          (∫ ω, (A + B) ω ∂P) + ∫ ω, C ω ∂P := by
        change (∫ ω, (A + B) ω + C ω ∂P) = _
        exact integral_add (hA.add hB) hC
      have eB : (∫ ω, (A + B) ω ∂P) =
          (∫ ω, A ω ∂P) + ∫ ω, B ω ∂P := by
        change (∫ ω, A ω + B ω ∂P) = _
        exact integral_add hA hB
      rw [eS, eR, eC, eB]
      dsimp [A, B, C, R, S, T]
      rw [integral_const_mul, integral_const_mul, integral_const_mul,
        integral_const_mul, integral_const_mul, integral_const_mul,
        hX2, hN₁2, hN₂2, hXN₁0, hXN₂0, hN₁N₂0]
      ring

/-- One-sensor positive-denominator optimum, proved by completing the square. -/
theorem sensorQuadratic1_global_minimum {v₀ v₁ : ℝ}
    (_hv₀ : 0 ≤ v₀) (_hv₁ : 0 ≤ v₁) (hs : 0 < v₀ + v₁) (α : ℝ) :
    sensorQuadratic1 v₀ v₁ (v₀ / (v₀ + v₁)) = v₀ * v₁ / (v₀ + v₁) ∧
      sensorQuadratic1 v₀ v₁ (v₀ / (v₀ + v₁)) ≤ sensorQuadratic1 v₀ v₁ α := by
  have hs0 : v₀ + v₁ ≠ 0 := ne_of_gt hs
  have hid (a : ℝ) : sensorQuadratic1 v₀ v₁ a = v₀ * v₁ / (v₀ + v₁) +
      (v₀ + v₁) * (a - v₀ / (v₀ + v₁)) ^ 2 := by
    rw [sensorQuadratic1]; field_simp [hs0]; ring
  have hopt : sensorQuadratic1 v₀ v₁ (v₀ / (v₀ + v₁)) =
      v₀ * v₁ / (v₀ + v₁) := by rw [hid]; simp
  refine ⟨hopt, ?_⟩
  rw [hopt, hid]
  nlinarith [mul_nonneg (le_of_lt hs) (sq_nonneg (α - v₀ / (v₀ + v₁)))]

theorem sensorQuadratic1_zero_denominator {v₀ v₁ : ℝ}
    (hv₀ : 0 ≤ v₀) (hv₁ : 0 ≤ v₁) (hs : v₀ + v₁ = 0) (α : ℝ) :
    sensorQuadratic1 v₀ v₁ α = 0 := by
  have h0 : v₀ = 0 ∧ v₁ = 0 := by constructor <;> linarith
  simp [sensorQuadratic1, h0.1, h0.2]

/-- Two-sensor positive-denominator optimum and global inequality. -/
theorem sensorQuadratic2_global_minimum {v₀ v₁ v₂ : ℝ}
    (hv₀ : 0 ≤ v₀) (hv₁ : 0 ≤ v₁) (hv₂ : 0 ≤ v₂)
    (hD : 0 < sensorDenominator2 v₀ v₁ v₂) (α β : ℝ) :
    let D := sensorDenominator2 v₀ v₁ v₂
    let α₀ := v₀ * v₂ / D
    let β₀ := v₀ * v₁ / D
    sensorQuadratic2 v₀ v₁ v₂ α₀ β₀ = v₀ * v₁ * v₂ / D ∧
      sensorQuadratic2 v₀ v₁ v₂ α₀ β₀ ≤ sensorQuadratic2 v₀ v₁ v₂ α β := by
  dsimp
  let D := sensorDenominator2 v₀ v₁ v₂
  have hD0 : D ≠ 0 := ne_of_gt hD
  have hD0' : v₀ * (v₁ + v₂) + v₁ * v₂ ≠ 0 := by
    intro hz
    apply hD0
    dsimp [D, sensorDenominator2]
    calc v₀ * v₁ + v₀ * v₂ + v₁ * v₂ = v₀ * (v₁ + v₂) + v₁ * v₂ := by ring
      _ = 0 := hz
  let α₀ := v₀ * v₂ / D
  let β₀ := v₀ * v₁ / D
  have hid (a b : ℝ) : sensorQuadratic2 v₀ v₁ v₂ a b = v₀ * v₁ * v₂ / D +
      v₀ * ((a - α₀) + (b - β₀)) ^ 2 + v₁ * (a - α₀) ^ 2 +
        v₂ * (b - β₀) ^ 2 := by
    dsimp [α₀, β₀, D, sensorDenominator2]
    rw [sensorQuadratic2]
    field_simp [hD0']
    ring
  have hopt : sensorQuadratic2 v₀ v₁ v₂ α₀ β₀ = v₀ * v₁ * v₂ / D := by
    rw [hid]; simp
  refine ⟨hopt, ?_⟩
  rw [hopt, hid]
  have hn : 0 ≤ v₀ * ((α - α₀) + (β - β₀)) ^ 2 +
      v₁ * (α - α₀) ^ 2 + v₂ * (β - β₀) ^ 2 := add_nonneg (add_nonneg
        (mul_nonneg hv₀ (sq_nonneg ((α - α₀) + (β - β₀))))
        (mul_nonneg hv₁ (sq_nonneg (α - α₀))))
        (mul_nonneg hv₂ (sq_nonneg (β - β₀)))
  linarith

/-- Full `D = 0` boundary: choose `(0,0)` if `v₀=0`, else `(1,0)`. -/
theorem sensorQuadratic2_zero_denominator {v₀ v₁ v₂ : ℝ}
    (hv₀ : 0 ≤ v₀) (hv₁ : 0 ≤ v₁) (hv₂ : 0 ≤ v₂)
    (hD : sensorDenominator2 v₀ v₁ v₂ = 0) :
    (v₀ = 0 ∧ sensorQuadratic2 v₀ v₁ v₂ 0 0 = 0 ∧
      ∀ α β, sensorQuadratic2 v₀ v₁ v₂ 0 0 ≤ sensorQuadratic2 v₀ v₁ v₂ α β) ∨
    (0 < v₀ ∧ v₁ = 0 ∧ v₂ = 0 ∧ sensorQuadratic2 v₀ v₁ v₂ 1 0 = 0 ∧
      ∀ α β, sensorQuadratic2 v₀ v₁ v₂ 1 0 ≤ sensorQuadratic2 v₀ v₁ v₂ α β) := by
  by_cases hz : v₀ = 0
  · left
    refine ⟨hz, by simp [sensorQuadratic2, hz], ?_⟩
    intro α β
    rw [show sensorQuadratic2 v₀ v₁ v₂ 0 0 = 0 by simp [sensorQuadratic2, hz]]
    dsimp [sensorQuadratic2]
    positivity
  · right
    have hv₀pos : 0 < v₀ := lt_of_le_of_ne hv₀ (Ne.symm hz)
    have hp01 : 0 ≤ v₀ * v₁ := mul_nonneg hv₀ hv₁
    have hp02 : 0 ≤ v₀ * v₂ := mul_nonneg hv₀ hv₂
    have hp12 : 0 ≤ v₁ * v₂ := mul_nonneg hv₁ hv₂
    have hv₁z : v₁ = 0 := by dsimp [sensorDenominator2] at hD; nlinarith
    have hv₂z : v₂ = 0 := by dsimp [sensorDenominator2] at hD; nlinarith
    refine ⟨hv₀pos, hv₁z, hv₂z, by simp [sensorQuadratic2, hv₁z, hv₂z], ?_⟩
    intro α β
    rw [show sensorQuadratic2 v₀ v₁ v₂ 1 0 = 0 by
      simp [sensorQuadratic2, hv₁z, hv₂z]]
    simp [sensorQuadratic2, hv₁z, hv₂z]
    positivity


/-- The positive-denominator one-sensor optimum, stated directly for the true MSE. -/
theorem sensorMSE1_global_minimum {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P] {X N : Ω → ℝ} {μ v₀ v₁ : ℝ}
    (hX : MemLp X 2 P) (hN : MemLp N 2 P) (hXN : IndepFun X N P)
    (hXmean : ∫ ω, X ω ∂P = μ) (hNmean : ∫ ω, N ω ∂P = 0)
    (hXvar : Var[X; P] = v₀) (hNvar : Var[N; P] = v₁)
    (hs : 0 < v₀ + v₁) :
    sensorMSE1 P X N μ (v₀ / (v₀ + v₁)) = v₀ * v₁ / (v₀ + v₁) ∧
      ∀ α, sensorMSE1 P X N μ (v₀ / (v₀ + v₁)) ≤ sensorMSE1 P X N μ α := by
  have hv₀ : 0 ≤ v₀ := by rw [← hXvar]; exact variance_nonneg X P
  have hv₁ : 0 ≤ v₁ := by rw [← hNvar]; exact variance_nonneg N P
  have hform (α : ℝ) := sensorMSE1_eq_quadratic hX hN hXN hXmean hNmean hXvar hNvar α
  constructor
  · rw [hform]
    exact (sensorQuadratic1_global_minimum hv₀ hv₁ hs 0).1
  · intro α
    rw [hform, hform]
    exact (sensorQuadratic1_global_minimum hv₀ hv₁ hs α).2

/-- At the zero one-sensor denominator every coefficient has true MSE zero. -/
theorem sensorMSE1_zero_denominator {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P] {X N : Ω → ℝ} {μ v₀ v₁ : ℝ}
    (hX : MemLp X 2 P) (hN : MemLp N 2 P) (hXN : IndepFun X N P)
    (hXmean : ∫ ω, X ω ∂P = μ) (hNmean : ∫ ω, N ω ∂P = 0)
    (hXvar : Var[X; P] = v₀) (hNvar : Var[N; P] = v₁)
    (hs : v₀ + v₁ = 0) : ∀ α, sensorMSE1 P X N μ α = 0 := by
  have hv₀ : 0 ≤ v₀ := by rw [← hXvar]; exact variance_nonneg X P
  have hv₁ : 0 ≤ v₁ := by rw [← hNvar]; exact variance_nonneg N P
  intro α
  rw [sensorMSE1_eq_quadratic hX hN hXN hXmean hNmean hXvar hNvar]
  exact sensorQuadratic1_zero_denominator hv₀ hv₁ hs α

/-- The positive-`D` two-sensor optimum, minimum value, and global inequality,
stated directly for the true MSE. -/
theorem sensorMSE2_global_minimum {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P] {X N₁ N₂ : Ω → ℝ} {μ v₀ v₁ v₂ : ℝ}
    (hX : MemLp X 2 P) (hN₁ : MemLp N₁ 2 P) (hN₂ : MemLp N₂ 2 P)
    (hXN₁ : IndepFun X N₁ P) (hXN₂ : IndepFun X N₂ P) (hN₁N₂ : IndepFun N₁ N₂ P)
    (hXmean : ∫ ω, X ω ∂P = μ)
    (hN₁mean : ∫ ω, N₁ ω ∂P = 0) (hN₂mean : ∫ ω, N₂ ω ∂P = 0)
    (hXvar : Var[X; P] = v₀) (hN₁var : Var[N₁; P] = v₁) (hN₂var : Var[N₂; P] = v₂)
    (hD : 0 < sensorDenominator2 v₀ v₁ v₂) :
    let D := sensorDenominator2 v₀ v₁ v₂
    let α₀ := v₀ * v₂ / D
    let β₀ := v₀ * v₁ / D
    sensorMSE2 P X N₁ N₂ μ α₀ β₀ = v₀ * v₁ * v₂ / D ∧
      ∀ α β, sensorMSE2 P X N₁ N₂ μ α₀ β₀ ≤ sensorMSE2 P X N₁ N₂ μ α β := by
  dsimp
  have hv₀ : 0 ≤ v₀ := by rw [← hXvar]; exact variance_nonneg X P
  have hv₁ : 0 ≤ v₁ := by rw [← hN₁var]; exact variance_nonneg N₁ P
  have hv₂ : 0 ≤ v₂ := by rw [← hN₂var]; exact variance_nonneg N₂ P
  have hform (α β : ℝ) := sensorMSE2_eq_quadratic hX hN₁ hN₂ hXN₁ hXN₂ hN₁N₂
    hXmean hN₁mean hN₂mean hXvar hN₁var hN₂var α β
  constructor
  · rw [hform]
    exact (sensorQuadratic2_global_minimum hv₀ hv₁ hv₂ hD 0 0).1
  · intro α β
    rw [hform, hform]
    exact (sensorQuadratic2_global_minimum hv₀ hv₁ hv₂ hD α β).2

/-- Full `D=0` boundary stated directly for true MSE. -/
theorem sensorMSE2_zero_denominator {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P] {X N₁ N₂ : Ω → ℝ} {μ v₀ v₁ v₂ : ℝ}
    (hX : MemLp X 2 P) (hN₁ : MemLp N₁ 2 P) (hN₂ : MemLp N₂ 2 P)
    (hXN₁ : IndepFun X N₁ P) (hXN₂ : IndepFun X N₂ P) (hN₁N₂ : IndepFun N₁ N₂ P)
    (hXmean : ∫ ω, X ω ∂P = μ)
    (hN₁mean : ∫ ω, N₁ ω ∂P = 0) (hN₂mean : ∫ ω, N₂ ω ∂P = 0)
    (hXvar : Var[X; P] = v₀) (hN₁var : Var[N₁; P] = v₁) (hN₂var : Var[N₂; P] = v₂)
    (hD : sensorDenominator2 v₀ v₁ v₂ = 0) :
    (v₀ = 0 ∧ sensorMSE2 P X N₁ N₂ μ 0 0 = 0 ∧
      ∀ α β, sensorMSE2 P X N₁ N₂ μ 0 0 ≤ sensorMSE2 P X N₁ N₂ μ α β) ∨
    (0 < v₀ ∧ v₁ = 0 ∧ v₂ = 0 ∧ sensorMSE2 P X N₁ N₂ μ 1 0 = 0 ∧
      ∀ α β, sensorMSE2 P X N₁ N₂ μ 1 0 ≤ sensorMSE2 P X N₁ N₂ μ α β) := by
  have hv₀ : 0 ≤ v₀ := by rw [← hXvar]; exact variance_nonneg X P
  have hv₁ : 0 ≤ v₁ := by rw [← hN₁var]; exact variance_nonneg N₁ P
  have hv₂ : 0 ≤ v₂ := by rw [← hN₂var]; exact variance_nonneg N₂ P
  have hform (α β : ℝ) := sensorMSE2_eq_quadratic hX hN₁ hN₂ hXN₁ hXN₂ hN₁N₂
    hXmean hN₁mean hN₂mean hXvar hN₁var hN₂var α β
  rcases sensorQuadratic2_zero_denominator hv₀ hv₁ hv₂ hD with h | h
  · left
    refine ⟨h.1, ?_, ?_⟩
    · rw [hform]; exact h.2.1
    · intro α β
      rw [hform, hform]
      exact h.2.2 α β
  · right
    refine ⟨h.1, h.2.1, h.2.2.1, ?_, ?_⟩
    · rw [hform]; exact h.2.2.2.1
    · intro α β
      rw [hform, hform]
      exact h.2.2.2.2 α β

/-- Gaussian law gives the exact L², mean, and variance facts needed above. -/
theorem gaussian_noise_moments {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} {N : Ω → ℝ} {v : NNReal} (hN : HasLaw N (gaussianReal 0 v) P) :
    MemLp N 2 P ∧ (∫ ω, N ω ∂P = 0) ∧ Var[N; P] = (v : ℝ) := by
  have hid : HasLaw id (gaussianReal 0 v) (gaussianReal 0 v) := HasLaw.id
  have hident := hN.identDistrib hid
  refine ⟨hident.memLp_iff.mpr (memLp_id_gaussianReal' 2 (by norm_num)), ?_, ?_⟩
  · rw [hN.integral_eq, integral_id_gaussianReal]
  · rw [hN.variance_eq, variance_id_gaussianReal]

/-- Original Gaussian, mutually independent source model. -/
theorem prob_12_5_mse_formulas {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P]
    (X N₁ N₂ : Ω → ℝ) (μ v₀ : ℝ) (v₁ v₂ : NNReal)
    (hX : MemLp X 2 P) (hXmean : ∫ ω, X ω ∂P = μ) (hXvar : Var[X; P] = v₀)
    (hN₁law : HasLaw N₁ (gaussianReal 0 v₁) P)
    (hN₂law : HasLaw N₂ (gaussianReal 0 v₂) P)
    (hindep : iIndepFun ![X, N₁, N₂] P) :
    (∀ α, sensorMSE1 P X N₁ μ α = sensorQuadratic1 v₀ (v₁ : ℝ) α) ∧
    (∀ α β, sensorMSE2 P X N₁ N₂ μ α β =
      sensorQuadratic2 v₀ (v₁ : ℝ) (v₂ : ℝ) α β) := by
  rcases gaussian_noise_moments hN₁law with ⟨hN₁, hN₁mean, hN₁var⟩
  rcases gaussian_noise_moments hN₂law with ⟨hN₂, hN₂mean, hN₂var⟩
  have hXN₁ : IndepFun X N₁ P := hindep.indepFun (by decide : (0 : Fin 3) ≠ 1)
  have hXN₂ : IndepFun X N₂ P := hindep.indepFun (by decide : (0 : Fin 3) ≠ 2)
  have hN₁N₂ : IndepFun N₁ N₂ P := hindep.indepFun (by decide : (1 : Fin 3) ≠ 2)
  constructor
  · intro α
    exact sensorMSE1_eq_quadratic hX hN₁ hXN₁ hXmean hN₁mean hXvar hN₁var α
  · intro α β
    exact sensorMSE2_eq_quadratic hX hN₁ hN₂ hXN₁ hXN₂ hN₁N₂ hXmean
      hN₁mean hN₂mean hXvar hN₁var hN₂var α β


/-- Part (a), directly instantiated from a genuine zero-mean Gaussian law. -/
theorem prob_12_5_one_gaussian {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P]
    (X N : Ω → ℝ) (μ v₀ : ℝ) (v₁ : NNReal)
    (hX : MemLp X 2 P) (hXmean : ∫ ω, X ω ∂P = μ) (hXvar : Var[X; P] = v₀)
    (hNlaw : HasLaw N (gaussianReal 0 v₁) P) (hindep : IndepFun X N P) :
    (∀ α, sensorMSE1 P X N μ α = sensorQuadratic1 v₀ (v₁ : ℝ) α) ∧
    (0 < v₀ + (v₁ : ℝ) →
      sensorMSE1 P X N μ (v₀ / (v₀ + v₁)) = v₀ * v₁ / (v₀ + v₁) ∧
      ∀ α, sensorMSE1 P X N μ (v₀ / (v₀ + v₁)) ≤ sensorMSE1 P X N μ α) ∧
    (v₀ + (v₁ : ℝ) = 0 → ∀ α, sensorMSE1 P X N μ α = 0) := by
  rcases gaussian_noise_moments hNlaw with ⟨hN, hNmean, hNvar⟩
  refine ⟨fun α ↦ sensorMSE1_eq_quadratic hX hN hindep hXmean hNmean hXvar hNvar α,
    ?_, ?_⟩
  · exact sensorMSE1_global_minimum hX hN hindep hXmean hNmean hXvar hNvar
  · exact sensorMSE1_zero_denominator hX hN hindep hXmean hNmean hXvar hNvar

/-- Part (b), directly instantiated from the genuine Gaussian laws and the
source's mutual independence hypothesis. -/
theorem prob_12_5_two_gaussian {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P]
    (X N₁ N₂ : Ω → ℝ) (μ v₀ : ℝ) (v₁ v₂ : NNReal)
    (hX : MemLp X 2 P) (hXmean : ∫ ω, X ω ∂P = μ) (hXvar : Var[X; P] = v₀)
    (hN₁law : HasLaw N₁ (gaussianReal 0 v₁) P)
    (hN₂law : HasLaw N₂ (gaussianReal 0 v₂) P)
    (hindep : iIndepFun ![X, N₁, N₂] P) :
    (∀ α β, sensorMSE2 P X N₁ N₂ μ α β =
      sensorQuadratic2 v₀ (v₁ : ℝ) (v₂ : ℝ) α β) ∧
    (0 < sensorDenominator2 v₀ v₁ v₂ →
      let D := sensorDenominator2 v₀ v₁ v₂
      let α₀ := v₀ * v₂ / D
      let β₀ := v₀ * v₁ / D
      sensorMSE2 P X N₁ N₂ μ α₀ β₀ = v₀ * v₁ * v₂ / D ∧
        ∀ α β, sensorMSE2 P X N₁ N₂ μ α₀ β₀ ≤ sensorMSE2 P X N₁ N₂ μ α β) ∧
    (sensorDenominator2 v₀ v₁ v₂ = 0 →
      (v₀ = 0 ∧ sensorMSE2 P X N₁ N₂ μ 0 0 = 0 ∧
        ∀ α β, sensorMSE2 P X N₁ N₂ μ 0 0 ≤ sensorMSE2 P X N₁ N₂ μ α β) ∨
      (0 < v₀ ∧ (v₁ : ℝ) = 0 ∧ (v₂ : ℝ) = 0 ∧
        sensorMSE2 P X N₁ N₂ μ 1 0 = 0 ∧
        ∀ α β, sensorMSE2 P X N₁ N₂ μ 1 0 ≤ sensorMSE2 P X N₁ N₂ μ α β)) := by
  rcases gaussian_noise_moments hN₁law with ⟨hN₁, hN₁mean, hN₁var⟩
  rcases gaussian_noise_moments hN₂law with ⟨hN₂, hN₂mean, hN₂var⟩
  have hXN₁ : IndepFun X N₁ P := hindep.indepFun (by decide : (0 : Fin 3) ≠ 1)
  have hXN₂ : IndepFun X N₂ P := hindep.indepFun (by decide : (0 : Fin 3) ≠ 2)
  have hN₁N₂ : IndepFun N₁ N₂ P := hindep.indepFun (by decide : (1 : Fin 3) ≠ 2)
  refine ⟨?_, ?_, ?_⟩
  · intro α β
    exact sensorMSE2_eq_quadratic hX hN₁ hN₂ hXN₁ hXN₂ hN₁N₂ hXmean
      hN₁mean hN₂mean hXvar hN₁var hN₂var α β
  · exact sensorMSE2_global_minimum hX hN₁ hN₂ hXN₁ hXN₂ hN₁N₂ hXmean
      hN₁mean hN₂mean hXvar hN₁var hN₂var
  · exact sensorMSE2_zero_denominator hX hN₁ hN₂ hXN₁ hXN₂ hN₁N₂ hXmean
      hN₁mean hN₂mean hXvar hN₁var hN₂var


/-- Complete Problem 12.5: both parts under the textbook Gaussian source model,
including every positive-denominator and degenerate boundary conclusion. -/
theorem prob_12_5 {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P]
    (X N₁ N₂ : Ω → ℝ) (μ v₀ : ℝ) (v₁ v₂ : NNReal)
    (hX : MemLp X 2 P) (hXmean : ∫ ω, X ω ∂P = μ) (hXvar : Var[X; P] = v₀)
    (hN₁law : HasLaw N₁ (gaussianReal 0 v₁) P)
    (hN₂law : HasLaw N₂ (gaussianReal 0 v₂) P)
    (hindep : iIndepFun ![X, N₁, N₂] P) :
    ((∀ α, sensorMSE1 P X N₁ μ α = sensorQuadratic1 v₀ (v₁ : ℝ) α) ∧
      (0 < v₀ + (v₁ : ℝ) →
        sensorMSE1 P X N₁ μ (v₀ / (v₀ + v₁)) = v₀ * v₁ / (v₀ + v₁) ∧
        ∀ α, sensorMSE1 P X N₁ μ (v₀ / (v₀ + v₁)) ≤ sensorMSE1 P X N₁ μ α) ∧
      (v₀ + (v₁ : ℝ) = 0 → ∀ α, sensorMSE1 P X N₁ μ α = 0)) ∧
    ((∀ α β, sensorMSE2 P X N₁ N₂ μ α β =
        sensorQuadratic2 v₀ (v₁ : ℝ) (v₂ : ℝ) α β) ∧
      (0 < sensorDenominator2 v₀ v₁ v₂ →
        let D := sensorDenominator2 v₀ v₁ v₂
        let α₀ := v₀ * v₂ / D
        let β₀ := v₀ * v₁ / D
        sensorMSE2 P X N₁ N₂ μ α₀ β₀ = v₀ * v₁ * v₂ / D ∧
          ∀ α β, sensorMSE2 P X N₁ N₂ μ α₀ β₀ ≤ sensorMSE2 P X N₁ N₂ μ α β) ∧
      (sensorDenominator2 v₀ v₁ v₂ = 0 →
        (v₀ = 0 ∧ sensorMSE2 P X N₁ N₂ μ 0 0 = 0 ∧
          ∀ α β, sensorMSE2 P X N₁ N₂ μ 0 0 ≤ sensorMSE2 P X N₁ N₂ μ α β) ∨
        (0 < v₀ ∧ (v₁ : ℝ) = 0 ∧ (v₂ : ℝ) = 0 ∧
          sensorMSE2 P X N₁ N₂ μ 1 0 = 0 ∧
          ∀ α β, sensorMSE2 P X N₁ N₂ μ 1 0 ≤ sensorMSE2 P X N₁ N₂ μ α β))) := by
  have hXN₁ : IndepFun X N₁ P := hindep.indepFun (by decide : (0 : Fin 3) ≠ 1)
  exact ⟨prob_12_5_one_gaussian X N₁ μ v₀ v₁ hX hXmean hXvar hN₁law hXN₁,
    prob_12_5_two_gaussian X N₁ N₂ μ v₀ v₁ v₂ hX hXmean hXvar hN₁law hN₂law hindep⟩
