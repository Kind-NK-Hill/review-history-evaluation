import Mathlib

open MeasureTheory ProbabilityTheory
noncomputable section

/-- True MSE for one noisy sensor. -/
def singleSensorMSE {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω)
    (X N : Ω → ℝ) (a : ℝ) := ∫ ω, (X ω - a * (X ω + N ω)) ^ 2 ∂P

/-- True MSE for two noisy sensors. -/
def twoSensorMSE {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω)
    (X N₁ N₂ : Ω → ℝ) (a b : ℝ) :=
  ∫ ω, (X ω - (a * (X ω + N₁ ω) + b * (X ω + N₂ ω))) ^ 2 ∂P

/-- First two moments and square-integrability of a zero-mean Gaussian. -/
theorem gaussian_noise_moments {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} {N : Ω → ℝ} {v : NNReal}
    (hN : HasLaw N (gaussianReal 0 v) P) :
    MemLp N 2 P ∧ (∫ ω, N ω ∂P) = 0 ∧ (∫ ω, N ω ^ 2 ∂P) = (v : ℝ) := by
  have hLp : MemLp N 2 P := by
    have hg : MemLp id 2 (gaussianReal 0 v) :=
      memLp_id_gaussianReal' (μ := 0) (v := v) 2 (by simp)
    rw [← hN.map_eq] at hg
    simpa using hg.comp_of_map hN.aemeasurable
  have hm : (∫ ω, N ω ∂P) = 0 := by simpa using hN.integral_eq
  have hgs : (∫ x : ℝ, x ^ 2 ∂gaussianReal 0 v) = (v : ℝ) := by
    have hv := variance_fun_id_gaussianReal (μ := (0 : ℝ)) (v := v)
    rw [variance_eq_integral (X := fun x : ℝ => x) measurable_id.aemeasurable] at hv
    simpa using hv
  have hs : (∫ ω, N ω ^ 2 ∂P) = (v : ℝ) := by
    rw [← hgs]
    simpa [Function.comp_def] using
      hN.integral_comp (show AEStronglyMeasurable (fun x : ℝ => x ^ 2)
        (gaussianReal 0 v) by fun_prop)
  exact ⟨hLp, hm, hs⟩

private theorem cross_zero {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} {X N : Ω → ℝ} (hX : MemLp X 2 P) (hN : MemLp N 2 P)
    (hi : IndepFun X N P) (hm : (∫ ω, N ω ∂P) = 0) :
    (∫ ω, X ω * N ω ∂P) = 0 := by
  rw [hi.integral_fun_mul_eq_mul_integral hX.1 hN.1, hm, mul_zero]

/-- Independence and zero mean remove the mixed term in the one-sensor MSE. -/
theorem singleSensorMSE_eq_quadratic {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} {X N : Ω → ℝ} (a : ℝ)
    (hX : MemLp X 2 P) (hN : MemLp N 2 P) (hi : IndepFun X N P)
    (hm : (∫ ω, N ω ∂P) = 0) :
    singleSensorMSE P X N a =
      (1-a)^2 * (∫ ω, X ω ^ 2 ∂P) + a^2 * (∫ ω, N ω ^ 2 ∂P) := by
  have hXX : Integrable (fun ω => X ω ^ 2) P := by
    rw [← show X * X = (fun ω => X ω ^ 2) by ext ω; simp [pow_two]]; exact hX.integrable_mul hX
  have hNN : Integrable (fun ω => N ω ^ 2) P := by
    rw [← show N * N = (fun ω => N ω ^ 2) by ext ω; simp [pow_two]]; exact hN.integrable_mul hN
  have hXN : Integrable (fun ω => X ω * N ω) P := hX.integrable_mul hN
  have hc := cross_zero hX hN hi hm
  rw [singleSensorMSE]
  simp_rw [show ∀ ω, (X ω-a*(X ω+N ω))^2 =
      (1-a)^2*X ω^2+a^2*N ω^2-(2*a*(1-a))*(X ω*N ω) by intro ω; ring]
  rw [integral_sub, integral_add, integral_const_mul, integral_const_mul,
    integral_const_mul, hc]
  ring
  all_goals fun_prop

/-- Explicit globally optimal one-sensor coefficient. -/
theorem singleSensorMSE_optimal {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X N : Ω → ℝ) (sX sN : ℝ)
    (hsX : 0 ≤ sX) (hsN : 0 ≤ sN)
    (hq : ∀ a, singleSensorMSE P X N a = (1-a)^2*sX+a^2*sN)
    (hp : 0 < sX+sN) (a : ℝ) :
    singleSensorMSE P X N (sX/(sX+sN)) ≤ singleSensorMSE P X N a := by
  rw [hq, hq]
  have hid : (1-a)^2*sX+a^2*sN-
      ((1-sX/(sX+sN))^2*sX+(sX/(sX+sN))^2*sN) =
      (sX+sN)*(a-sX/(sX+sN))^2 := by field_simp; ring
  nlinarith [sq_nonneg (a-sX/(sX+sN))]

/-- With zero denominator every one-sensor coefficient has zero MSE. -/
theorem singleSensorMSE_degenerate {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X N : Ω → ℝ) (sX sN : ℝ)
    (hsX : 0 ≤ sX) (hsN : 0 ≤ sN)
    (hq : ∀ a, singleSensorMSE P X N a = (1-a)^2*sX+a^2*sN)
    (hz : sX+sN=0) (a : ℝ) : singleSensorMSE P X N a = 0 := by
  have hx : sX = 0 := by nlinarith
  have hn : sN=0 := by nlinarith
  simp [hq, hx, hn]

/-- Mutual independence removes all three mixed terms in the two-sensor MSE. -/
theorem twoSensorMSE_eq_quadratic {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} {X N₁ N₂ : Ω → ℝ} (a b : ℝ)
    (hX : MemLp X 2 P) (hN₁ : MemLp N₁ 2 P) (hN₂ : MemLp N₂ 2 P)
    (hi : iIndepFun ![X,N₁,N₂] P)
    (hm₁ : (∫ ω, N₁ ω ∂P)=0) (hm₂ : (∫ ω, N₂ ω ∂P)=0) :
    twoSensorMSE P X N₁ N₂ a b =
      (1-a-b)^2*(∫ ω, X ω^2 ∂P)+a^2*(∫ ω, N₁ ω^2 ∂P)+
        b^2*(∫ ω, N₂ ω^2 ∂P) := by
  have hi01 : IndepFun X N₁ P := by
    simpa using hi.indepFun (i:=0) (j:=1) (by decide)
  have hi02 : IndepFun X N₂ P := by
    simpa using hi.indepFun (i:=0) (j:=2) (by decide)
  have hi12 : IndepFun N₁ N₂ P := by
    simpa using hi.indepFun (i:=1) (j:=2) (by decide)
  have hc01 := cross_zero hX hN₁ hi01 hm₁
  have hc02 := cross_zero hX hN₂ hi02 hm₂
  have hc12 := cross_zero hN₁ hN₂ hi12 hm₂
  have hXX : Integrable (fun ω => X ω^2) P := by
    rw [← show X * X = (fun ω => X ω ^ 2) by ext ω; simp [pow_two]]; exact hX.integrable_mul hX
  have h11 : Integrable (fun ω => N₁ ω^2) P := by
    rw [← show N₁ * N₁ = (fun ω => N₁ ω ^ 2) by ext ω; simp [pow_two]]; exact hN₁.integrable_mul hN₁
  have h22 : Integrable (fun ω => N₂ ω^2) P := by
    rw [← show N₂ * N₂ = (fun ω => N₂ ω ^ 2) by ext ω; simp [pow_two]]; exact hN₂.integrable_mul hN₂
  have hX1 : Integrable (fun ω => X ω*N₁ ω) P := hX.integrable_mul hN₁
  have hX2 : Integrable (fun ω => X ω*N₂ ω) P := hX.integrable_mul hN₂
  have h12 : Integrable (fun ω => N₁ ω*N₂ ω) P := hN₁.integrable_mul hN₂
  rw [twoSensorMSE]
  simp_rw [show ∀ ω, (X ω-(a*(X ω+N₁ ω)+b*(X ω+N₂ ω)))^2 =
      (1-a-b)^2*X ω^2+a^2*N₁ ω^2+b^2*N₂ ω^2-
      (2*a*(1-a-b))*(X ω*N₁ ω)-(2*b*(1-a-b))*(X ω*N₂ ω)+
      (2*a*b)*(N₁ ω*N₂ ω) by intro ω; ring]
  rw [integral_add, integral_sub, integral_sub, integral_add, integral_add,
    integral_const_mul, integral_const_mul, integral_const_mul,
    integral_const_mul, integral_const_mul, integral_const_mul, hc01, hc02, hc12]
  · ring
  all_goals fun_prop

theorem twoSensorMSE_optimal {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X N₁ N₂ : Ω → ℝ) (sX s₁ s₂ : ℝ)
    (hsX : 0 ≤ sX) (hs₁ : 0 ≤ s₁) (hs₂ : 0 ≤ s₂)
    (hq : ∀ a b, twoSensorMSE P X N₁ N₂ a b =
      (1-a-b)^2*sX+a^2*s₁+b^2*s₂)
    (hp : 0<sX*s₁+sX*s₂+s₁*s₂) (a b : ℝ) :
    twoSensorMSE P X N₁ N₂
      (sX*s₂/(sX*s₁+sX*s₂+s₁*s₂)) (sX*s₁/(sX*s₁+sX*s₂+s₁*s₂)) ≤
      twoSensorMSE P X N₁ N₂ a b := by
  let D := sX*s₁+sX*s₂+s₁*s₂
  let a₀ := sX*s₂/D
  let b₀ := sX*s₁/D
  rw [hq, hq]
  have hD : D ≠ 0 := ne_of_gt hp
  have hden : sX*s₁+sX*s₂+s₁*s₂ ≠ 0 := by simpa [D] using hD
  have hnorm : sX*(s₁+s₂)+s₂*s₁ ≠ 0 := by
    intro hh
    apply hden
    calc sX*s₁+sX*s₂+s₁*s₂ = sX*(s₁+s₂)+s₂*s₁ := by ring
      _ = 0 := hh
  have ha : sX*(a₀+b₀-1)+s₁*a₀ = 0 := by
    dsimp only [a₀,b₀,D]
    field_simp [hnorm]
    ring
  have hb : sX*(a₀+b₀-1)+s₂*b₀ = 0 := by
    dsimp only [a₀,b₀,D]
    field_simp [hnorm]
    ring
  have hid : (1-a-b)^2*sX+a^2*s₁+b^2*s₂-
      ((1-a₀-b₀)^2*sX+a₀^2*s₁+b₀^2*s₂) =
      sX*((a-a₀)+(b-b₀))^2+s₁*(a-a₀)^2+s₂*(b-b₀)^2 := by
    calc
      _ = sX*((a-a₀)+(b-b₀))^2+s₁*(a-a₀)^2+s₂*(b-b₀)^2 +
          2*(a-a₀)*(sX*(a₀+b₀-1)+s₁*a₀) +
          2*(b-b₀)*(sX*(a₀+b₀-1)+s₂*b₀) := by ring
      _ = _ := by rw [ha, hb]; ring
  change (1-a₀-b₀)^2*sX+a₀^2*s₁+b₀^2*s₂ ≤
    (1-a-b)^2*sX+a^2*s₁+b^2*s₂
  nlinarith [mul_nonneg hsX (sq_nonneg ((a-a₀)+(b-b₀))),
    mul_nonneg hs₁ (sq_nonneg (a-a₀)), mul_nonneg hs₂ (sq_nonneg (b-b₀))]

/-- Explicit zero-denominator boundary solution. -/
theorem twoSensorMSE_degenerate {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X N₁ N₂ : Ω → ℝ) (sX s₁ s₂ : ℝ)
    (hsX : 0 ≤ sX) (hs₁ : 0 ≤ s₁) (hs₂ : 0 ≤ s₂)
    (hq : ∀ a b, twoSensorMSE P X N₁ N₂ a b =
      (1-a-b)^2*sX+a^2*s₁+b^2*s₂)
    (hz : sX*s₁+sX*s₂+s₁*s₂ = 0) :
    twoSensorMSE P X N₁ N₂ (if sX = 0 then 0 else 1) 0 = 0 := by
  by_cases hx : sX = 0
  · simp [hx, hq]
  · have hxp : 0<sX := lt_of_le_of_ne hsX (Ne.symm hx)
    have h1 : s₁ = 0 := by nlinarith [mul_nonneg hs₁ hs₂]
    have h2 : s₂ = 0 := by nlinarith [mul_nonneg hs₁ hs₂]
    simp [hx, h1, h2, hq]

/-- One Gaussian sensor: quadratic identity and positive-denominator optimum. -/
theorem prob_12_5_one_gaussian {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} {X N : Ω → ℝ} {v : NNReal}
    (hX : MemLp X 2 P) (hN : HasLaw N (gaussianReal 0 v) P)
    (hi : IndepFun X N P) (hp : 0<(∫ ω, X ω^2 ∂P)+(v:ℝ)) :
    (∀ a, singleSensorMSE P X N a =
      (1-a)^2*(∫ ω, X ω^2 ∂P)+a^2*(v:ℝ)) ∧
    (∀ a, singleSensorMSE P X N
      ((∫ ω, X ω^2 ∂P)/((∫ ω, X ω^2 ∂P)+(v:ℝ))) ≤
      singleSensorMSE P X N a) := by
  obtain ⟨hNLp,hm,hv⟩ := gaussian_noise_moments hN
  have hq := fun a => (singleSensorMSE_eq_quadratic a hX hNLp hi hm).trans (by rw [hv])
  refine ⟨hq, fun a => singleSensorMSE_optimal P X N _ _ ?_ v.coe_nonneg hq hp a⟩
  exact integral_nonneg fun ω => sq_nonneg (X ω)

/-- Two Gaussian sensors: the complete quadratic identity. -/
theorem prob_12_5_two_gaussian {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} {X N₁ N₂ : Ω → ℝ} {v₁ v₂ : NNReal}
    (hX : MemLp X 2 P) (hN₁ : HasLaw N₁ (gaussianReal 0 v₁) P)
    (hN₂ : HasLaw N₂ (gaussianReal 0 v₂) P)
    (hi : iIndepFun ![X,N₁,N₂] P) :
    ∀ a b, twoSensorMSE P X N₁ N₂ a b =
      (1-a-b)^2*(∫ ω, X ω^2 ∂P)+a^2*(v₁:ℝ)+b^2*(v₂:ℝ) := by
  obtain ⟨h1,hm1,hv1⟩ := gaussian_noise_moments hN₁
  obtain ⟨h2,hm2,hv2⟩ := gaussian_noise_moments hN₂
  intro a b
  rw [twoSensorMSE_eq_quadratic a b hX h1 h2 hi hm1 hm2, hv1, hv2]
