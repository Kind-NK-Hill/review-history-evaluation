import ProbabilityTheory.chapter_12.prob_12_5_affine

open MeasureTheory ProbabilityTheory
noncomputable section

/-- Gaussian one-sensor quadratic identity, valid even when its denominator is zero. -/
theorem singleSensorAffineMSE_eq_quadratic_gaussian {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P] {X N : Ω → ℝ}
    {μ σ₀sq : ℝ} {σ₁sq : NNReal}
    (hX : MemLp X 2 P) (hmean : (∫ ω, X ω ∂P) = μ)
    (hvar : Var[X; P] = σ₀sq)
    (hN : HasLaw N (gaussianReal 0 σ₁sq) P) (hi : IndepFun X N P) :
    ∀ a, singleSensorAffineMSE P X N μ a =
      (1 - a) ^ 2 * σ₀sq + a ^ 2 * (σ₁sq : ℝ) := by
  obtain ⟨hNLp, hmN, hvN⟩ := gaussian_noise_moments hN
  obtain ⟨hS, hSsq, hiS⟩ := centered_source_facts hX hmean hvar hi
  intro a
  rw [singleSensorAffineMSE_eq_centered,
    singleSensorMSE_eq_quadratic a hS hNLp hiS hmN, hSsq, hvN]

/-- Gaussian two-sensor quadratic identity, valid even when its determinant is zero. -/
theorem twoSensorAffineMSE_eq_quadratic_gaussian {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P] {X N₁ N₂ : Ω → ℝ}
    {μ σ₀sq : ℝ} {σ₁sq σ₂sq : NNReal}
    (hX : MemLp X 2 P) (hmean : (∫ ω, X ω ∂P) = μ)
    (hvar : Var[X; P] = σ₀sq)
    (hN₁ : HasLaw N₁ (gaussianReal 0 σ₁sq) P)
    (hN₂ : HasLaw N₂ (gaussianReal 0 σ₂sq) P)
    (hi : iIndepFun ![X, N₁, N₂] P) :
    ∀ a b, twoSensorAffineMSE P X N₁ N₂ μ a b =
      (1 - a - b) ^ 2 * σ₀sq + a ^ 2 * (σ₁sq : ℝ) + b ^ 2 * (σ₂sq : ℝ) := by
  obtain ⟨h1, hm1, hv1⟩ := gaussian_noise_moments hN₁
  obtain ⟨h2, hm2, hv2⟩ := gaussian_noise_moments hN₂
  have hi01 : IndepFun X N₁ P := by
    simpa using hi.indepFun (i := (0 : Fin 3)) (j := (1 : Fin 3)) (by decide)
  obtain ⟨hS, hSsq, _⟩ := centered_source_facts hX hmean hvar hi01
  have hiS := centered_three_independent μ hi
  intro a b
  rw [twoSensorAffineMSE_eq_centered,
    twoSensorMSE_eq_quadratic a b hS h1 h2 hiS hm1 hm2, hSsq, hv1, hv2]

/-- Zero one-sensor denominator: every coefficient is globally optimal with zero MSE. -/
theorem prob_12_5_one_gaussian_affine_zero_denominator {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P] {X N : Ω → ℝ}
    {μ σ₀sq : ℝ} {σ₁sq : NNReal}
    (hX : MemLp X 2 P) (hmean : (∫ ω, X ω ∂P) = μ)
    (hvar : Var[X; P] = σ₀sq)
    (hN : HasLaw N (gaussianReal 0 σ₁sq) P) (hi : IndepFun X N P)
    (hz : σ₀sq + (σ₁sq : ℝ) = 0) :
    ∀ a, singleSensorAffineMSE P X N μ a = 0 := by
  have hs0 : 0 ≤ σ₀sq := hvar ▸ variance_nonneg X P
  exact fun a => singleSensorAffineMSE_degenerate P X N μ σ₀sq (σ₁sq : ℝ)
    hs0 σ₁sq.coe_nonneg
    (singleSensorAffineMSE_eq_quadratic_gaussian hX hmean hvar hN hi) hz a

/-- Zero two-sensor determinant: an explicit zero-MSE global minimizer. -/
theorem prob_12_5_two_gaussian_affine_zero_denominator {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P] {X N₁ N₂ : Ω → ℝ}
    {μ σ₀sq : ℝ} {σ₁sq σ₂sq : NNReal}
    (hX : MemLp X 2 P) (hmean : (∫ ω, X ω ∂P) = μ)
    (hvar : Var[X; P] = σ₀sq)
    (hN₁ : HasLaw N₁ (gaussianReal 0 σ₁sq) P)
    (hN₂ : HasLaw N₂ (gaussianReal 0 σ₂sq) P)
    (hi : iIndepFun ![X, N₁, N₂] P)
    (hz : σ₀sq * (σ₁sq : ℝ) + σ₀sq * (σ₂sq : ℝ) +
      (σ₁sq : ℝ) * (σ₂sq : ℝ) = 0) :
    let a₀ : ℝ := if σ₀sq = 0 then 0 else 1
    twoSensorAffineMSE P X N₁ N₂ μ a₀ 0 = 0 ∧
      ∀ a b, twoSensorAffineMSE P X N₁ N₂ μ a₀ 0 ≤
        twoSensorAffineMSE P X N₁ N₂ μ a b := by
  dsimp only
  have hs0 : 0 ≤ σ₀sq := hvar ▸ variance_nonneg X P
  have hq := twoSensorAffineMSE_eq_quadratic_gaussian hX hmean hvar hN₁ hN₂ hi
  have hzero := twoSensorAffineMSE_degenerate P X N₁ N₂ μ σ₀sq
    (σ₁sq : ℝ) (σ₂sq : ℝ) hs0 σ₁sq.coe_nonneg σ₂sq.coe_nonneg hq hz
  refine ⟨hzero, fun a b => ?_⟩
  rw [hzero, hq]
  positivity

/-- The exact source assumptions for the second sensor: only zero mean and variance are used. -/
theorem twoSensorAffineMSE_eq_quadratic_source {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P] {X N₁ N₂ : Ω → ℝ}
    {μ σ₀sq σ₂sq : ℝ} {σ₁sq : NNReal}
    (hX : MemLp X 2 P) (hmean : (∫ ω, X ω ∂P) = μ)
    (hvar : Var[X; P] = σ₀sq)
    (hN₁ : HasLaw N₁ (gaussianReal 0 σ₁sq) P)
    (hN₂ : MemLp N₂ 2 P) (hN₂mean : (∫ ω, N₂ ω ∂P) = 0)
    (hN₂var : Var[N₂; P] = σ₂sq)
    (hi : iIndepFun ![X, N₁, N₂] P) :
    ∀ a b, twoSensorAffineMSE P X N₁ N₂ μ a b =
      (1 - a - b) ^ 2 * σ₀sq + a ^ 2 * (σ₁sq : ℝ) + b ^ 2 * σ₂sq := by
  obtain ⟨h1, hm1, hv1⟩ := gaussian_noise_moments hN₁
  have h2sq : (∫ ω, N₂ ω ^ 2 ∂P) = σ₂sq := by
    calc
      (∫ ω, N₂ ω ^ 2 ∂P) = ∫ ω, (N₂ ω - ∫ x, N₂ x ∂P) ^ 2 ∂P := by
        rw [hN₂mean]
        simp
      _ = Var[N₂; P] := (variance_eq_integral hN₂.aemeasurable).symm
      _ = σ₂sq := hN₂var
  have hi01 : IndepFun X N₁ P := by
    simpa using hi.indepFun (i := (0 : Fin 3)) (j := (1 : Fin 3)) (by decide)
  obtain ⟨hS, hSsq, _⟩ := centered_source_facts hX hmean hvar hi01
  have hiS := centered_three_independent μ hi
  intro a b
  rw [twoSensorAffineMSE_eq_centered,
    twoSensorMSE_eq_quadratic a b hS h1 hN₂ hiS hm1 hN₂mean, hSsq, hv1, h2sq]

/-- Exact textbook two-sensor result for a positive denominator. `N₂` need not be Gaussian. -/
theorem prob_12_5_two_source_affine {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P] {X N₁ N₂ : Ω → ℝ}
    {μ σ₀sq σ₂sq : ℝ} {σ₁sq : NNReal}
    (hX : MemLp X 2 P) (hmean : (∫ ω, X ω ∂P) = μ)
    (hvar : Var[X; P] = σ₀sq)
    (hN₁ : HasLaw N₁ (gaussianReal 0 σ₁sq) P)
    (hN₂ : MemLp N₂ 2 P) (hN₂mean : (∫ ω, N₂ ω ∂P) = 0)
    (hN₂var : Var[N₂; P] = σ₂sq)
    (hi : iIndepFun ![X, N₁, N₂] P)
    (hden : 0 < σ₀sq * (σ₁sq : ℝ) + σ₀sq * σ₂sq + (σ₁sq : ℝ) * σ₂sq) :
    (∀ a b, twoSensorAffineMSE P X N₁ N₂ μ a b =
      (1 - a - b) ^ 2 * σ₀sq + a ^ 2 * (σ₁sq : ℝ) + b ^ 2 * σ₂sq) ∧
    (∀ a b, twoSensorAffineMSE P X N₁ N₂ μ
        (σ₀sq * σ₂sq /
          (σ₀sq * (σ₁sq : ℝ) + σ₀sq * σ₂sq + (σ₁sq : ℝ) * σ₂sq))
        (σ₀sq * (σ₁sq : ℝ) /
          (σ₀sq * (σ₁sq : ℝ) + σ₀sq * σ₂sq + (σ₁sq : ℝ) * σ₂sq)) ≤
      twoSensorAffineMSE P X N₁ N₂ μ a b) := by
  have hq := twoSensorAffineMSE_eq_quadratic_source
    hX hmean hvar hN₁ hN₂ hN₂mean hN₂var hi
  have hs0 : 0 ≤ σ₀sq := hvar ▸ variance_nonneg X P
  have hs2 : 0 ≤ σ₂sq := hN₂var ▸ variance_nonneg N₂ P
  refine ⟨hq, fun a b => ?_⟩
  rw [twoSensorAffineMSE_eq_centered, twoSensorAffineMSE_eq_centered]
  exact twoSensorMSE_optimal P (fun ω => X ω - μ) N₁ N₂ σ₀sq
    (σ₁sq : ℝ) σ₂sq hs0 σ₁sq.coe_nonneg hs2
    (fun u v => (twoSensorAffineMSE_eq_centered P X N₁ N₂ μ u v).symm.trans (hq u v))
    hden a b

/-- Exact textbook zero-denominator boundary. `N₂` need not be Gaussian. -/
theorem prob_12_5_two_source_affine_zero_denominator {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P] {X N₁ N₂ : Ω → ℝ}
    {μ σ₀sq σ₂sq : ℝ} {σ₁sq : NNReal}
    (hX : MemLp X 2 P) (hmean : (∫ ω, X ω ∂P) = μ)
    (hvar : Var[X; P] = σ₀sq)
    (hN₁ : HasLaw N₁ (gaussianReal 0 σ₁sq) P)
    (hN₂ : MemLp N₂ 2 P) (hN₂mean : (∫ ω, N₂ ω ∂P) = 0)
    (hN₂var : Var[N₂; P] = σ₂sq)
    (hi : iIndepFun ![X, N₁, N₂] P)
    (hz : σ₀sq * (σ₁sq : ℝ) + σ₀sq * σ₂sq + (σ₁sq : ℝ) * σ₂sq = 0) :
    let a₀ : ℝ := if σ₀sq = 0 then 0 else 1
    twoSensorAffineMSE P X N₁ N₂ μ a₀ 0 = 0 ∧
      ∀ a b, twoSensorAffineMSE P X N₁ N₂ μ a₀ 0 ≤
        twoSensorAffineMSE P X N₁ N₂ μ a b := by
  dsimp only
  have hq := twoSensorAffineMSE_eq_quadratic_source
    hX hmean hvar hN₁ hN₂ hN₂mean hN₂var hi
  have hs0 : 0 ≤ σ₀sq := hvar ▸ variance_nonneg X P
  have hs2 : 0 ≤ σ₂sq := hN₂var ▸ variance_nonneg N₂ P
  have hzero := twoSensorAffineMSE_degenerate P X N₁ N₂ μ σ₀sq
    (σ₁sq : ℝ) σ₂sq hs0 σ₁sq.coe_nonneg hs2 hq hz
  refine ⟨hzero, fun a b => ?_⟩
  rw [hzero, hq]
  positivity
