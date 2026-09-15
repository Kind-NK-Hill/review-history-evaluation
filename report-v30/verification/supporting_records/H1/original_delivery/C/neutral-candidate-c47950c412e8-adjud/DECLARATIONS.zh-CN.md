# 本组公开声明完整清单

本文档依据当前工作区源码逐项列出本次新建的五个目标文件及全部专用支持文件。声明代码块只保留声明签名，不含定义值或证明体；隐式参数、类型类前提和结论均按源码保留。`sincIntegral` 的源码返回类型由 Lean 推断，清单显式写为 `ℝ`。

## 文件范围与计数

- 本次新建文件共 15 个，顶层公开 `def`、`lemma`、`theorem` 共 74 个。
- `thm_9_5` 反演链共有九个专用文件：八个辅助文件 `thm_9_5_fubini`、`thm_9_5_kernel`、`thm_9_5_symmetry`、`thm_9_5_dirichlet`、`thm_9_5_damping`、`thm_9_5_abel`、`thm_9_5_pointwise`、`thm_9_5_bounds`，以及主文件 `thm_9_5`。

## `ProbabilityTheory/chapter_09/thm_9_4.lean`

### `thm_9_4`

职责：证明复指数增量的教材范数估计。

```lean
theorem thm_9_4 (x : ℝ) :
    ‖Complex.exp (Complex.I * (x : ℂ)) - 1‖ ≤ |x|
```

## `ProbabilityTheory/chapter_09/thm_9_5_fubini.lean`

### `inversionIntegrand`

职责：定义反演中用于有限截断双重积分的复值被积函数。

```lean
noncomputable def inversionIntegrand (a b x t : ℝ) : ℂ
```

### `inversionIntegrand_measurable`

职责：证明交换积分所需的联合可测性。

```lean
lemma inversionIntegrand_measurable (a b : ℝ) :
    Measurable (fun p : ℝ × ℝ => inversionIntegrand a b p.2 p.1)
```

### `norm_inversionIntegrand_le`

职责：给出由区间长度控制的逐点范数界。

```lean
lemma norm_inversionIntegrand_le {a b : ℝ} (hab : a ≤ b) (x t : ℝ) :
    ‖inversionIntegrand a b x t‖ ≤ b - a
```

### `inversion_finite_fubini`

职责：在有限测度和有限频率区间上严格交换两重积分。

```lean
theorem inversion_finite_fubini
    (μ : Measure ℝ) [IsFiniteMeasure μ] {a b : ℝ} (hab : a ≤ b) (T : ℝ) :
    (∫ t in -T..T, ∫ x, inversionIntegrand a b x t ∂μ) =
      ∫ x, ∫ t in -T..T, inversionIntegrand a b x t ∂volume ∂μ
```

## `ProbabilityTheory/chapter_09/thm_9_5_kernel.lean`

### `inversionIntegrand_eq_translated`

职责：把反演被积函数化为两个平移指数项之差。

```lean
lemma inversionIntegrand_eq_translated
    (a b x t : ℝ) :
    inversionIntegrand a b x t =
      (Complex.exp (Complex.I * (t : ℂ) * ((x - a : ℝ) : ℂ)) -
        Complex.exp (Complex.I * (t : ℂ) * ((x - b : ℝ) : ℂ))) /
          (Complex.I * (t : ℂ))
```

### `inversionKernel`

职责：定义对频率变量积分后的点态反演核。

```lean
noncomputable def inversionKernel (a b x T : ℝ) : ℂ
```

### `inversionKernel_zero`

职责：给出截断参数为零时反演核为零的化简定理；该声明带有 `@[simp]` 属性。

```lean
@[simp] lemma inversionKernel_zero (a b x : ℝ) :
    inversionKernel a b x 0 = 0
```

## `ProbabilityTheory/chapter_09/thm_9_5_symmetry.lean`

### `inversionIntegrand_add_neg`

职责：计算正负频率配对并消去虚部。

```lean
lemma inversionIntegrand_add_neg (a b x t : ℝ) (ht : t ≠ 0) :
    inversionIntegrand a b x t + inversionIntegrand a b x (-t) =
      (2 : ℂ) * (((b - x) * Real.sinc (t * (b - x)) : ℝ) -
        ((a - x) * Real.sinc (t * (a - x)) : ℝ))
```

### `inversionIntegrand_intervalIntegrable`

职责：证明核在任意有限区间上可积。

```lean
lemma inversionIntegrand_intervalIntegrable
    {a b : ℝ} (hab : a ≤ b) (x s t : ℝ) :
    IntervalIntegrable (inversionIntegrand a b x) volume s t
```

### `inversionKernel_eq_sinc`

职责：把复振荡核严格化为两个 sinc 积分之差。

```lean
theorem inversionKernel_eq_sinc {a b : ℝ} (hab : a ≤ b) (x T : ℝ) :
    inversionKernel a b x T =
      (2 : ℂ) * (((∫ u in 0..((b-x)*T), Real.sinc u : ℝ) : ℂ) -
        ((∫ u in 0..((a-x)*T), Real.sinc u : ℝ) : ℂ))
```

## `ProbabilityTheory/chapter_09/thm_9_5_dirichlet.lean`

### `sincIntegral`

职责：定义从零到给定端点的 Dirichlet sinc 积分。

```lean
noncomputable def sincIntegral (T : ℝ) : ℝ
```

### `sinc_tail_identity`

职责：通过分部积分给出正半轴 sinc 尾段恒等式。

```lean
lemma sinc_tail_identity {A B : ℝ} (hA : 0 < A) (hAB : A ≤ B) :
    ∫ x in A..B, Real.sinc x =
      Real.cos A / A - Real.cos B / B - ∫ x in A..B, Real.cos x / x^2
```

### `sinc_tail_remainder_bound`

职责：控制分部积分余项。

```lean
lemma sinc_tail_remainder_bound {A B : ℝ} (hA : 0 < A) (hAB : A ≤ B) :
    |∫ x in A..B, Real.cos x / x^2| ≤ A⁻¹
```

### `sinc_tail_bound`

职责：给出 sinc 尾段的一致衰减界。

```lean
lemma sinc_tail_bound {A B : ℝ} (hA : 0 < A) (hAB : A ≤ B) :
    |∫ x in A..B, Real.sinc x| ≤ 3 * A⁻¹
```

### `sincIntegral_sub`

职责：把两个原函数值之差改写为区间积分。

```lean
lemma sincIntegral_sub {A B : ℝ} (hAB : A ≤ B) :
    sincIntegral B - sincIntegral A = ∫ x in A..B, Real.sinc x
```

### `cauchy_sincIntegral`

职责：证明 sinc 原函数沿正无穷形成 Cauchy 滤子。

```lean
lemma cauchy_sincIntegral : Cauchy (Filter.map sincIntegral atTop)
```

### `exists_sincIntegral_limit`

职责：由完备性取得 sinc 积分的有限极限。

```lean
lemma exists_sincIntegral_limit : ∃ L : ℝ, Tendsto sincIntegral atTop (nhds L)
```

### `sincIntegral_neg`

职责：证明 sinc 积分关于端点为奇函数。

```lean
lemma sincIntegral_neg (T : ℝ) : sincIntegral (-T) = -sincIntegral T
```

### `abs_sincIntegral_le_four`

职责：给出所有实端点上的全局常数界。

```lean
lemma abs_sincIntegral_le_four (T : ℝ) : |sincIntegral T| ≤ 4
```

## `ProbabilityTheory/chapter_09/thm_9_5_damping.lean`

### `integral_exp_neg_mul_cos_Ioi`

职责：计算带指数阻尼的余弦半直线积分。

```lean
lemma integral_exp_neg_mul_cos_Ioi {ε t : ℝ} (hε : 0 < ε) :
    (∫ x in Ioi 0, Real.exp (-ε * x) * Real.cos (t * x)) =
      ε / (ε^2 + t^2)
```

### `integral_cos_mul_zero_one_eq_sinc`

职责：把单位区间余弦积分识别为 sinc。

```lean
lemma integral_cos_mul_zero_one_eq_sinc (x : ℝ) :
    (∫ t in 0..1, Real.cos (t*x)) = Real.sinc x
```

### `dampedSinc`

职责：定义 Abel 阻尼后的 sinc 半直线积分。

```lean
noncomputable def dampedSinc (ε : ℝ) : ℝ
```

### `dampedSinc_eq_integral_rational`

职责：利用 Fubini 把阻尼 sinc 改写为有理积分。

```lean
lemma dampedSinc_eq_integral_rational {ε : ℝ} (hε : 0 < ε) :
    dampedSinc ε = ∫ t in 0..1, ε / (ε^2+t^2)
```

### `integral_rational_eq_arctan_inv`

职责：计算该有理积分为反正切。

```lean
lemma integral_rational_eq_arctan_inv {ε : ℝ} (hε : 0 < ε) :
    (∫ t in 0..1, ε / (ε^2+t^2)) = Real.arctan ε⁻¹
```

### `dampedSinc_eq_arctan_inv`

职责：汇总阻尼积分的显式公式。

```lean
lemma dampedSinc_eq_arctan_inv {ε : ℝ} (hε : 0 < ε) :
    dampedSinc ε = Real.arctan ε⁻¹
```

### `tendsto_dampedSinc_nhdsGT_zero`

职责：证明阻尼趋零时极限为 π/2。

```lean
lemma tendsto_dampedSinc_nhdsGT_zero :
    Tendsto dampedSinc (nhdsWithin 0 (Ioi 0)) (nhds (Real.pi/2))
```

## `ProbabilityTheory/chapter_09/thm_9_5_abel.lean`

### `sincIntegral_hasDerivAt`

职责：给出 sinc 原函数的导数。

```lean
lemma sincIntegral_hasDerivAt (x : ℝ) : HasDerivAt sincIntegral (Real.sinc x) x
```

### `dampedSinc_finite_parts`

职责：在有限区间上对阻尼积分分部积分。

```lean
lemma dampedSinc_finite_parts {ε B : ℝ} (hε : 0 < ε) :
    (∫ x in 0..B, Real.exp (-ε*x) * Real.sinc x) =
      Real.exp (-ε*B) * sincIntegral B +
        ε * ∫ x in 0..B, Real.exp (-ε*x) * sincIntegral x
```

### `dampedSinc_eq_average`

职责：把阻尼积分表示为 sinc 原函数的 Abel 平均。

```lean
lemma dampedSinc_eq_average {ε : ℝ} (hε : 0 < ε) :
    dampedSinc ε = ε * ∫ x in Ioi 0, Real.exp (-ε*x) * sincIntegral x
```

### `tendsto_dampedSinc_of_sincIntegral_limit`

职责：证明普通 sinc 极限必与 Abel 极限一致。

```lean
lemma tendsto_dampedSinc_of_sincIntegral_limit {L : ℝ}
    (hL : Tendsto sincIntegral atTop (nhds L)) :
    Tendsto dampedSinc (nhdsWithin 0 (Ioi 0)) (nhds L)
```

### `tendsto_sincIntegral_atTop_pi_div_two`

职责：得到 Dirichlet 积分的关键极限 π/2。

```lean
lemma tendsto_sincIntegral_atTop_pi_div_two :
    Tendsto sincIntegral atTop (nhds (Real.pi/2))
```

## `ProbabilityTheory/chapter_09/thm_9_5_pointwise.lean`

### `tendsto_sincIntegral_atBot_neg_pi_div_two`

职责：得到负无穷方向的 sinc 积分极限。

```lean
lemma tendsto_sincIntegral_atBot_neg_pi_div_two :
    Tendsto sincIntegral atBot (nhds (-(Real.pi/2)))
```

### `tendsto_sincIntegral_mul_pos`

职责：处理正系数缩放后的极限。

```lean
lemma tendsto_sincIntegral_mul_pos {c : ℝ} (hc : 0 < c) :
    Tendsto (fun T : ℝ => sincIntegral (c*T)) atTop (nhds (Real.pi/2))
```

### `tendsto_sincIntegral_mul_neg`

职责：处理负系数缩放后的极限。

```lean
lemma tendsto_sincIntegral_mul_neg {c : ℝ} (hc : c < 0) :
    Tendsto (fun T : ℝ => sincIntegral (c*T)) atTop (nhds (-(Real.pi/2)))
```

### `tendsto_inversionKernel_inside`

职责：证明开区间内部点的核极限为 2π。

```lean
lemma tendsto_inversionKernel_inside {a b x : ℝ} (hab : a ≤ b)
    (hax : a < x) (hxb : x < b) :
    Tendsto (inversionKernel a b x) atTop (nhds ((2*Real.pi : ℝ) : ℂ))
```

### `tendsto_inversionKernel_leftEndpoint`

职责：证明左端点核极限为 π。

```lean
lemma tendsto_inversionKernel_leftEndpoint {a b : ℝ} (hab : a < b) :
    Tendsto (inversionKernel a b a) atTop (nhds ((Real.pi : ℝ) : ℂ))
```

### `tendsto_inversionKernel_rightEndpoint`

职责：证明右端点核极限为 π。

```lean
lemma tendsto_inversionKernel_rightEndpoint {a b : ℝ} (hab : a < b) :
    Tendsto (inversionKernel a b b) atTop (nhds ((Real.pi : ℝ) : ℂ))
```

### `tendsto_inversionKernel_outside_left`

职责：证明区间左外点核极限为零。

```lean
lemma tendsto_inversionKernel_outside_left {a b x : ℝ} (hab : a ≤ b)
    (hxa : x < a) : Tendsto (inversionKernel a b x) atTop (nhds 0)
```

### `tendsto_inversionKernel_outside_right`

职责：证明区间右外点核极限为零。

```lean
lemma tendsto_inversionKernel_outside_right {a b x : ℝ} (hab : a ≤ b)
    (hbx : b < x) : Tendsto (inversionKernel a b x) atTop (nhds 0)
```

## `ProbabilityTheory/chapter_09/thm_9_5_bounds.lean`

### `norm_inversionKernel_le_sixteen`

职责：给出与位置和截断参数均无关的统一核界。

```lean
lemma norm_inversionKernel_le_sixteen {a b : ℝ} (hab : a ≤ b) (x T : ℝ) :
    ‖inversionKernel a b x T‖ ≤ 16
```

## `ProbabilityTheory/chapter_09/thm_9_5.lean`

### `inversionLimit`

职责：定义反演核逐点极限对应的分段值。

```lean
noncomputable def inversionLimit (a b x : ℝ) : ℂ
```

### `tendsto_inversionKernel`

职责：汇总内部、端点和外部情形的点态收敛。

```lean
lemma tendsto_inversionKernel (a b x : ℝ) (hab : a < b) :
    Tendsto (inversionKernel a b x) atTop (nhds (inversionLimit a b x))
```

### `inversionLimit_aestronglyMeasurable`

职责：证明极限函数对任意实测度几乎处处强可测。

```lean
lemma inversionLimit_aestronglyMeasurable (a b : ℝ) (μ : Measure ℝ) :
    AEStronglyMeasurable (inversionLimit a b) μ
```

### `integral_inversionLimit`

职责：计算极限函数积分，显式产生开区间质量和两个半端点质量。

```lean
lemma integral_inversionLimit (μ : Measure ℝ) [IsFiniteMeasure μ] {a b : ℝ} (hab : a < b) :
    (∫ x, inversionLimit a b x ∂μ) =
      ((2 * Real.pi : ℝ) : ℂ) * (μ (Ioo a b)).toReal +
      ((Real.pi : ℝ) : ℂ) * (μ {a}).toReal +
      ((Real.pi : ℝ) : ℂ) * (μ {b}).toReal
```

### `thm_9_5_kernel`

职责：对有限测度应用支配收敛，证明反演核积分收敛到开区间质量及两个端点质量的加权和。

```lean
 theorem thm_9_5_kernel (μ : Measure ℝ) [IsFiniteMeasure μ] {a b : ℝ} (hab : a < b) :
    Tendsto (fun T : ℝ => ∫ x, inversionKernel a b x T ∂μ) atTop
      (nhds (((2 * Real.pi : ℝ) : ℂ) * (μ (Ioo a b)).toReal +
        ((Real.pi : ℝ) : ℂ) * (μ {a}).toReal +
        ((Real.pi : ℝ) : ℂ) * (μ {b}).toReal))
```

### `inversionFrequency`

职责：定义含测度特征函数的频率侧被积函数。

```lean
noncomputable def inversionFrequency (μ : Measure ℝ) (a b t : ℝ) : ℂ
```

### `integral_inversionIntegrand_eq_frequency`

职责：把空间变量积分识别为频率侧表达式。

```lean
lemma integral_inversionIntegrand_eq_frequency
    (μ : Measure ℝ) (a b t : ℝ) :
    (∫ x, inversionIntegrand a b x t ∂μ) = inversionFrequency μ a b t
```

### `inversionFrequency_eq_integral_kernel`

职责：结合有限 Fubini，把频率积分改写为核积分。

```lean
lemma inversionFrequency_eq_integral_kernel
    (μ : Measure ℝ) [IsFiniteMeasure μ] {a b : ℝ} (hab : a ≤ b) (T : ℝ) :
    (∫ t in -T..T, inversionFrequency μ a b t) =
      ∫ x, inversionKernel a b x T ∂μ
```

### `thm_9_5`

职责：反演公式主定理，以 atTop 极限给出开区间及端点半质量。

```lean
theorem thm_9_5 (μ : Measure ℝ) [IsFiniteMeasure μ] {a b : ℝ} (hab : a < b) :
    Tendsto (fun T : ℝ => (((2 * Real.pi : ℝ) : ℂ))⁻¹ *
      ∫ t in -T..T, inversionFrequency μ a b t) atTop
      (nhds ((((μ (Ioo a b)).toReal + (μ {a}).toReal / 2 +
        (μ {b}).toReal / 2 : ℝ) : ℂ)))
```

## `ProbabilityTheory/chapter_09/thm_9_6_support.lean`

### `atomPoints`

职责：定义有限测度的正质量原子点集合。

```lean
def atomPoints (μ : Measure ℝ) : Set ℝ
```

### `countable_atomPoints`

职责：证明有限测度原子点集合可数。

```lean
theorem countable_atomPoints (μ : Measure ℝ) [IsFiniteMeasure μ] :
    (atomPoints μ).Countable
```

### `commonContinuityPoints`

职责：定义两测度的共同非原子端点集合。

```lean
def commonContinuityPoints (μ ν : Measure ℝ) : Set ℝ
```

### `dense_commonContinuityPoints`

职责：证明共同非原子端点集合稠密。

```lean
theorem dense_commonContinuityPoints (μ ν : Measure ℝ)
    [IsFiniteMeasure μ] [IsFiniteMeasure ν] :
    Dense (commonContinuityPoints μ ν)
```

### `mem_commonContinuityPoints_iff`

职责：刻画共同连续点恰为两测度单点质量均为零。

```lean
theorem mem_commonContinuityPoints_iff {μ ν : Measure ℝ} {x : ℝ} :
    x ∈ commonContinuityPoints μ ν ↔ μ {x} = 0 ∧ ν {x} = 0
```

### `continuousAt_cdf_of_measure_singleton_eq_zero`

职责：证明零单点质量蕴含分布函数在该点连续。

```lean
theorem continuousAt_cdf_of_measure_singleton_eq_zero
    (μ : Measure ℝ) [IsProbabilityMeasure μ] {x : ℝ} (hx : μ {x} = 0) :
    ContinuousAt (ProbabilityTheory.cdf μ) x
```

### `isTopologicalBasis_Ioo_mem`

职责：证明稠密端点开区间族构成实直线拓扑基。

```lean
theorem isTopologicalBasis_Ioo_mem {D : Set ℝ} (hD : Dense D) :
    IsTopologicalBasis {s : Set ℝ | ∃ a ∈ D, ∃ b ∈ D, a < b ∧ Ioo a b = s}
```

### `isPiSystem_Ioo_mem_denseEndpoints`

职责：证明稠密端点开区间族构成 π 系统。

```lean
theorem isPiSystem_Ioo_mem_denseEndpoints (D : Set ℝ) :
    IsPiSystem {s : Set ℝ | ∃ a ∈ D, ∃ b ∈ D, a < b ∧ Ioo a b = s}
```

## `ProbabilityTheory/chapter_09/thm_9_6.lean`

### `measure_Ioo_eq_of_charFun_eq_of_commonContinuityPoints`

职责：由本次反演证明共同连续端点开区间质量相等。

```lean
theorem measure_Ioo_eq_of_charFun_eq_of_commonContinuityPoints
    (μ ν : Measure ℝ) [IsFiniteMeasure μ] [IsFiniteMeasure ν]
    (hφ : ∀ t : ℝ, characteristicFunction μ t = characteristicFunction ν t)
    {a b : ℝ} (ha : a ∈ commonContinuityPoints μ ν)
    (hb : b ∈ commonContinuityPoints μ ν) (hab : a < b) :
    μ (Ioo a b) = ν (Ioo a b)
```

### `thm_9_6_law`

职责：由稠密开区间生成和有限测度扩张证明测度层唯一性。

```lean
theorem thm_9_6_law
    (μ ν : Measure ℝ) [IsFiniteMeasure μ] [IsFiniteMeasure ν]
    (hφ : ∀ t : ℝ, characteristicFunction μ t = characteristicFunction ν t) :
    μ = ν
```

### `thm_9_6`

职责：给出两个概率空间上随机变量分布唯一性的包装。

```lean
theorem thm_9_6
    {Ω₁ Ω₂ : Type*} [MeasurableSpace Ω₁] [MeasurableSpace Ω₂]
    {P : Measure Ω₁} {Q : Measure Ω₂}
    [IsProbabilityMeasure P] [IsProbabilityMeasure Q]
    {X : Ω₁ → ℝ} {Y : Ω₂ → ℝ}
    (hX : AEMeasurable X P) (hY : AEMeasurable Y Q)
    (hφ : ∀ t : ℝ,
      characteristicFunction (P.map X) t =
        characteristicFunction (Q.map Y) t) :
    P.map X = Q.map Y
```

## `ProbabilityTheory/chapter_09/prob_9_6_cauchy.lean`

### `laplaceKernel`

职责：定义用于 Cauchy 密度傅里叶计算的 Laplace 核。

```lean
noncomputable def laplaceKernel (x : ℝ) : ℂ
```

### `continuous_laplaceKernel`

职责：证明 Laplace 核连续。

```lean
lemma continuous_laplaceKernel : Continuous laplaceKernel
```

### `integrable_laplaceKernel`

职责：证明 Laplace 核可积。

```lean
lemma integrable_laplaceKernel : Integrable laplaceKernel
```

### `fourier_laplaceKernel`

职责：在 Mathlib 的 2π 约定下显式计算其傅里叶变换。

```lean
theorem fourier_laplaceKernel (w : ℝ) :
    𝓕 laplaceKernel w = ((2 / (1 + (2 * Real.pi * w) ^ 2) : ℝ) : ℂ)
```

### `integrable_fourier_laplaceKernel`

职责：验证傅里叶反演所需的变换可积性。

```lean
lemma integrable_fourier_laplaceKernel : Integrable (𝓕 laplaceKernel)
```

### `characteristicFunction_cauchyMeasure_zero_one`

职责：从真实标准 Cauchy 密度证明特征函数公式。

```lean
theorem characteristicFunction_cauchyMeasure_zero_one (t : ℝ) :
    characteristicFunction (ProbabilityTheory.cauchyMeasure 0 1) t =
      (Real.exp (-|t|) : ℂ)
```

### `characteristicFunction_cauchyMeasure`

职责：由密度积分仿射换元证明一般位置—尺度 Cauchy 特征函数公式。

```lean
theorem characteristicFunction_cauchyMeasure
    (μ σ : ℝ) (hσ : 0 < σ) (t : ℝ) :
    characteristicFunction
        (ProbabilityTheory.cauchyMeasure μ ⟨σ, hσ.le⟩) t =
      Complex.exp
        (Complex.I * (μ : ℂ) * (t : ℂ) - ((σ * |t| : ℝ) : ℂ))
```

## `ProbabilityTheory/chapter_09/prob_9_6.lean`

### `charFun_fin_sampleAverage`

职责：证明有限独立样本平均特征函数的乘积公式。

```lean
lemma charFun_fin_sampleAverage
    {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    {n : ℕ} {X : Fin n → Ω → ℝ}
    (hindep : iIndepFun X P) (hmeas : ∀ i, AEMeasurable (X i) P)
    (t : ℝ) :
    charFun (P.map (fun ω => (n : ℝ)⁻¹ * ∑ i, X i ω)) t =
      ∏ i, charFun (P.map (X i)) ((n : ℝ)⁻¹ * t)
```

### `cauchy_fin_sampleAverage_charFun`

职责：将一般 Cauchy 特征函数代入乘积并完成位置—尺度代数。

```lean
lemma cauchy_fin_sampleAverage_charFun
    {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    [IsProbabilityMeasure P] {n : ℕ} {X : Fin n → Ω → ℝ}
    (hn : 0 < n) (hindep : iIndepFun X P)
    (hmeas : ∀ i, AEMeasurable (X i) P)
    (μ σ : ℝ) (hσ : 0 < σ)
    (hLaw : ∀ i, P.map (X i) = ProbabilityTheory.cauchyMeasure μ ⟨σ, hσ.le⟩)
    (t : ℝ) :
    characteristicFunction
        (P.map (fun ω => (∑ i, X i ω) / (n : ℝ))) t =
      characteristicFunction
        (ProbabilityTheory.cauchyMeasure μ ⟨σ, hσ.le⟩) t
```

### `prob_9_6`

职责：教材有限族的一般位置—尺度 Cauchy 样本平均主定理。

```lean
theorem prob_9_6
    {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    [IsProbabilityMeasure P] {n : ℕ} (hn : 0 < n)
    {X : Fin n → Ω → ℝ} (hindep : iIndepFun X P)
    (hmeas : ∀ i, AEMeasurable (X i) P)
    (μ σ : ℝ) (hσ : 0 < σ)
    (hLaw : ∀ i, P.map (X i) = ProbabilityTheory.cauchyMeasure μ ⟨σ, hσ.le⟩) :
    P.map (fun ω => (∑ i, X i ω) / (n : ℝ)) =
      ProbabilityTheory.cauchyMeasure μ ⟨σ, hσ.le⟩
```

### `prob_9_6_eq_each`

职责：证明样本平均分布等于任意一个样本成员的分布。

```lean
theorem prob_9_6_eq_each
    {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    [IsProbabilityMeasure P] {n : ℕ} (hn : 0 < n)
    {X : Fin n → Ω → ℝ} (hindep : iIndepFun X P)
    (hmeas : ∀ i, AEMeasurable (X i) P)
    (μ σ : ℝ) (hσ : 0 < σ)
    (hLaw : ∀ i, P.map (X i) = ProbabilityTheory.cauchyMeasure μ ⟨σ, hσ.le⟩)
    (i : Fin n) :
    P.map (fun ω => (∑ j, X j ω) / (n : ℝ)) = P.map (X i)
```

### `prob_9_6_standard`

职责：给出标准 Cauchy 情形的有限族推论。

```lean
theorem prob_9_6_standard
    {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω}
    [IsProbabilityMeasure P] {n : ℕ} (hn : 0 < n)
    {X : Fin n → Ω → ℝ} (hindep : iIndepFun X P)
    (hmeas : ∀ i, AEMeasurable (X i) P)
    (hLaw : ∀ i, P.map (X i) = ProbabilityTheory.cauchyMeasure 0 1) :
    P.map (fun ω => (∑ i, X i ω) / (n : ℝ)) =
      ProbabilityTheory.cauchyMeasure 0 1
```

## `ProbabilityTheory/chapter_09/prob_9_8.lean`

### `prob_9_8`

职责：证明特征函数在 2π 等于一与随机变量几乎处处取整数值的双向等价。

```lean
theorem prob_9_8
    {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω} [IsProbabilityMeasure P]
    {X : Ω → ℝ} (hX : AEMeasurable X P) :
    characteristicFunction (P.map X) (2 * Real.pi) = 1 ↔
      ∀ᵐ ω ∂P, ∃ n : ℤ, X ω = n
```

## 根导入

`ProbabilityTheory.lean` 当前逐项导入：

```lean
import ProbabilityTheory.chapter_09.thm_9_4
import ProbabilityTheory.chapter_09.thm_9_5_fubini
import ProbabilityTheory.chapter_09.thm_9_5_kernel
import ProbabilityTheory.chapter_09.thm_9_5_symmetry
import ProbabilityTheory.chapter_09.thm_9_5_dirichlet
import ProbabilityTheory.chapter_09.thm_9_5_damping
import ProbabilityTheory.chapter_09.thm_9_5_abel
import ProbabilityTheory.chapter_09.thm_9_5_pointwise
import ProbabilityTheory.chapter_09.thm_9_5
import ProbabilityTheory.chapter_09.thm_9_5_bounds
import ProbabilityTheory.chapter_09.thm_9_6_support
import ProbabilityTheory.chapter_09.thm_9_6
import ProbabilityTheory.chapter_09.prob_9_6_cauchy
import ProbabilityTheory.chapter_09.prob_9_6
import ProbabilityTheory.chapter_09.prob_9_8
```

## 既有种子白名单公共依赖

下列五个文件来自种子白名单，是本组允许复用的既有公共依赖；它们不是本次新建的目标专用支持，也不计入上述 15 个文件和 74 个声明。

- `ProbabilityTheory/chapter_03/thm_3_9.lean`：既有测度/分布函数公共结果 `thm_3_9`。
- `ProbabilityTheory/chapter_07/thm_7_7.lean`：既有支配收敛公共结果，包括 `thm_7_DCT_filter`、`thm_7_7_sequential_complex_DCT`、`thm_7_7_interval`、`thm_7_7`。
- `ProbabilityTheory/chapter_08/thm_8_5.lean`：既有 Fubini 公共结果 `thm_8_5`。
- `ProbabilityTheory/chapter_09/def_9_3.lean`：既有特征函数定义及密度/离散表示接口，包括 `characteristicFunction`、`characteristicFunction_apply`、`characteristicFunction_map_apply`、`characteristicFunction_eq_integral_of_pdf`、`characteristicFunction_eq_tsum_of_pmf`。
- `ProbabilityTheory/chapter_09/thm_9_3.lean`：既有特征函数基本性质公共模块，包括连续性、有界性、共轭对称、卷积和独立和接口及 `thm_9_3_law`、`thm_9_3`。
