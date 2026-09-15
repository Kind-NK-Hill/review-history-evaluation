import ProbabilityTheory.chapter_12.prob_12_5

open MeasureTheory ProbabilityTheory
noncomputable section

/-- The actual affine one-sensor MSE from the statement, before centering `X`. -/
def singleSensorAffineMSE {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω)
    (X N : Ω → ℝ) (μ a : ℝ) :=
  ∫ ω, (X ω - (μ + a * (X ω + N ω - μ))) ^ 2 ∂P

/-- The actual affine two-sensor MSE from the statement, before centering `X`. -/
def twoSensorAffineMSE {Ω : Type*} [MeasurableSpace Ω] (P : Measure Ω)
    (X N₁ N₂ : Ω → ℝ) (μ a b : ℝ) :=
  ∫ ω, (X ω - (μ + a * (X ω + N₁ ω - μ) +
    b * (X ω + N₂ ω - μ))) ^ 2 ∂P

theorem singleSensorAffineMSE_eq_centered {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X N : Ω → ℝ) (μ a : ℝ) :
    singleSensorAffineMSE P X N μ a = singleSensorMSE P (fun ω => X ω - μ) N a := by
  apply integral_congr_ae
  filter_upwards [] with ω
  congr 1
  ring

theorem twoSensorAffineMSE_eq_centered {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X N₁ N₂ : Ω → ℝ) (μ a b : ℝ) :
    twoSensorAffineMSE P X N₁ N₂ μ a b =
      twoSensorMSE P (fun ω => X ω - μ) N₁ N₂ a b := by
  apply integral_congr_ae
  filter_upwards [] with ω
  congr 1
  ring

/-- Centering preserves `L²`, realizes variance as a second moment, and preserves independence. -/
theorem centered_source_facts {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P] {X N : Ω → ℝ} {μ σsq : ℝ}
    (hX : MemLp X 2 P) (hmean : (∫ ω, X ω ∂P) = μ)
    (hvar : Var[X; P] = σsq) (hi : IndepFun X N P) :
    MemLp (fun ω => X ω - μ) 2 P ∧
      (∫ ω, (X ω - μ) ^ 2 ∂P) = σsq ∧
      IndepFun (fun ω => X ω - μ) N P := by
  have hS : MemLp (fun ω => X ω - μ) 2 P := by
    convert hX.sub (memLp_const μ) using 1
    ext ω; rfl
  refine ⟨hS, ?_, ?_⟩
  · calc
      (∫ ω, (X ω - μ) ^ 2 ∂P) =
          ∫ ω, (X ω - ∫ x, X x ∂P) ^ 2 ∂P := by rw [hmean]
      _ = Var[X; P] := (variance_eq_integral hX.aemeasurable).symm
      _ = σsq := hvar
  · simpa [Function.comp_def] using
      hi.comp (measurable_id.sub measurable_const) measurable_id

/-- Full one-sensor Gaussian-source result in the original textbook variables. -/
theorem prob_12_5_one_gaussian_affine {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P] {X N : Ω → ℝ}
    {μ σ₀sq : ℝ} {σ₁sq : NNReal}
    (hX : MemLp X 2 P) (hmean : (∫ ω, X ω ∂P) = μ)
    (hvar : Var[X; P] = σ₀sq)
    (hN : HasLaw N (gaussianReal 0 σ₁sq) P) (hi : IndepFun X N P)
    (hden : 0 < σ₀sq + (σ₁sq : ℝ)) :
    (∀ a, singleSensorAffineMSE P X N μ a =
      (1-a)^2 * σ₀sq + a^2 * (σ₁sq : ℝ)) ∧
    (∀ a, singleSensorAffineMSE P X N μ
        (σ₀sq / (σ₀sq + (σ₁sq : ℝ))) ≤ singleSensorAffineMSE P X N μ a) := by
  obtain ⟨hNLp, hmN, hvN⟩ := gaussian_noise_moments hN
  obtain ⟨hS, hSsq, hiS⟩ := centered_source_facts hX hmean hvar hi
  have hq0 : ∀ a, singleSensorMSE P (fun ω => X ω - μ) N a =
      (1-a)^2 * σ₀sq + a^2 * (σ₁sq : ℝ) := by
    intro a
    rw [singleSensorMSE_eq_quadratic a hS hNLp hiS hmN, hSsq, hvN]
  have hq : ∀ a, singleSensorAffineMSE P X N μ a =
      (1-a)^2 * σ₀sq + a^2 * (σ₁sq : ℝ) := by
    intro a
    rw [singleSensorAffineMSE_eq_centered, hq0]
  refine ⟨hq, fun a => ?_⟩
  rw [singleSensorAffineMSE_eq_centered, singleSensorAffineMSE_eq_centered]
  exact singleSensorMSE_optimal P (fun ω => X ω - μ) N σ₀sq (σ₁sq : ℝ)
    (hvar ▸ variance_nonneg X P) σ₁sq.coe_nonneg hq0 hden a

theorem centered_three_independent {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} {X N₁ N₂ : Ω → ℝ} (μ : ℝ)
    (hi : iIndepFun ![X, N₁, N₂] P) :
    iIndepFun ![(fun ω => X ω - μ), N₁, N₂] P := by
  have hc := hi.comp
    (fun i : Fin 3 => if i = 0 then (fun x : ℝ => x - μ) else id)
    (by intro i; split_ifs <;> fun_prop)
  convert hc using 1
  funext i ω
  fin_cases i <;> simp [Function.comp_def]

/-- Full two-sensor Gaussian-source result: quadratic form and global minimizer. -/
theorem prob_12_5_two_gaussian_affine {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P] {X N₁ N₂ : Ω → ℝ}
    {μ σ₀sq : ℝ} {σ₁sq σ₂sq : NNReal}
    (hX : MemLp X 2 P) (hmean : (∫ ω, X ω ∂P) = μ)
    (hvar : Var[X; P] = σ₀sq)
    (hN₁ : HasLaw N₁ (gaussianReal 0 σ₁sq) P)
    (hN₂ : HasLaw N₂ (gaussianReal 0 σ₂sq) P)
    (hi : iIndepFun ![X, N₁, N₂] P)
    (hden : 0 < σ₀sq * (σ₁sq : ℝ) + σ₀sq * (σ₂sq : ℝ) +
      (σ₁sq : ℝ) * (σ₂sq : ℝ)) :
    (∀ a b, twoSensorAffineMSE P X N₁ N₂ μ a b =
      (1-a-b)^2 * σ₀sq + a^2 * (σ₁sq : ℝ) + b^2 * (σ₂sq : ℝ)) ∧
    (∀ a b, twoSensorAffineMSE P X N₁ N₂ μ
        (σ₀sq * (σ₂sq : ℝ) /
          (σ₀sq * (σ₁sq : ℝ) + σ₀sq * (σ₂sq : ℝ) + (σ₁sq : ℝ) * (σ₂sq : ℝ)))
        (σ₀sq * (σ₁sq : ℝ) /
          (σ₀sq * (σ₁sq : ℝ) + σ₀sq * (σ₂sq : ℝ) + (σ₁sq : ℝ) * (σ₂sq : ℝ))) ≤
      twoSensorAffineMSE P X N₁ N₂ μ a b) := by
  obtain ⟨h1, hm1, hv1⟩ := gaussian_noise_moments hN₁
  obtain ⟨h2, hm2, hv2⟩ := gaussian_noise_moments hN₂
  have hi01 : IndepFun X N₁ P := by
    simpa using hi.indepFun (i := (0 : Fin 3)) (j := (1 : Fin 3)) (by decide)
  obtain ⟨hS, hSsq, _⟩ := centered_source_facts hX hmean hvar hi01
  have hiS := centered_three_independent μ hi
  have hq0 : ∀ a b, twoSensorMSE P (fun ω => X ω - μ) N₁ N₂ a b =
      (1-a-b)^2 * σ₀sq + a^2 * (σ₁sq : ℝ) + b^2 * (σ₂sq : ℝ) := by
    intro a b
    rw [twoSensorMSE_eq_quadratic a b hS h1 h2 hiS hm1 hm2, hSsq, hv1, hv2]
  have hq : ∀ a b, twoSensorAffineMSE P X N₁ N₂ μ a b =
      (1-a-b)^2 * σ₀sq + a^2 * (σ₁sq : ℝ) + b^2 * (σ₂sq : ℝ) := by
    intro a b
    rw [twoSensorAffineMSE_eq_centered, hq0]
  refine ⟨hq, fun a b => ?_⟩
  rw [twoSensorAffineMSE_eq_centered, twoSensorAffineMSE_eq_centered]
  exact twoSensorMSE_optimal P (fun ω => X ω - μ) N₁ N₂ σ₀sq
    (σ₁sq : ℝ) (σ₂sq : ℝ) (hvar ▸ variance_nonneg X P)
    σ₁sq.coe_nonneg σ₂sq.coe_nonneg hq0 hden a b

/-- Complete affine one-sensor zero-denominator boundary. -/
theorem singleSensorAffineMSE_degenerate {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X N : Ω → ℝ) (μ sX sN : ℝ)
    (hsX : 0 ≤ sX) (hsN : 0 ≤ sN)
    (hq : ∀ a, singleSensorAffineMSE P X N μ a = (1-a)^2*sX+a^2*sN)
    (hz : sX+sN=0) (a : ℝ) : singleSensorAffineMSE P X N μ a = 0 := by
  have hx : sX = 0 := by nlinarith
  have hn : sN = 0 := by nlinarith
  simp [hq, hx, hn]

/-- Complete affine two-sensor zero-determinant boundary. -/
theorem twoSensorAffineMSE_degenerate {Ω : Type*} [MeasurableSpace Ω]
    (P : Measure Ω) (X N₁ N₂ : Ω → ℝ) (μ sX s₁ s₂ : ℝ)
    (hsX : 0 ≤ sX) (hs₁ : 0 ≤ s₁) (hs₂ : 0 ≤ s₂)
    (hq : ∀ a b, twoSensorAffineMSE P X N₁ N₂ μ a b =
      (1-a-b)^2*sX+a^2*s₁+b^2*s₂)
    (hz : sX*s₁+sX*s₂+s₁*s₂ = 0) :
    twoSensorAffineMSE P X N₁ N₂ μ (if sX = 0 then 0 else 1) 0 = 0 := by
  by_cases hx : sX = 0
  · simp [hx, hq]
  · have hxp : 0 < sX := lt_of_le_of_ne hsX (Ne.symm hx)
    have h1 : s₁ = 0 := by nlinarith [mul_nonneg hs₁ hs₂]
    have h2 : s₂ = 0 := by nlinarith [mul_nonneg hs₁ hs₂]
    simp [hx, h1, h2, hq]
