整组交付说明

本工作区现已完成五个目标 `thm_9_4`、`thm_9_5`、`thm_9_6`、`prob_9_6`、`prob_9_8`。所有目标专有支持均在本组源码中证明；未使用 `sorry`、`admit`、新增 `axiom`，未修改 Mathlib 或给定材料。

全部 15 个本次目标/专用支持文件及其 74 个顶层公开声明的准确签名、隐式参数、类型类前提与结论，见 [`DECLARATIONS.zh-CN.md`](DECLARATIONS.zh-CN.md)；该清单同时记录根导入和五个既有种子白名单公共依赖。

目标文件、公开声明与前提

- `ProbabilityTheory/chapter_09/thm_9_4.lean`
  - `thm_9_4 (x : ℝ)`：无额外前提证明 `‖exp(ix)-1‖ ≤ |x|`。
- `ProbabilityTheory/chapter_09/thm_9_5.lean`
  - `thm_9_5 (μ : Measure ℝ) [IsFiniteMeasure μ] (hab : a < b)`：反演主定理，结论包括开区间质量与两端各半质量，并证明主值极限存在。
  - 同文件另公开 `inversionLimit`、`tendsto_inversionKernel`、`inversionLimit_aestronglyMeasurable`、`integral_inversionLimit`、`thm_9_5_kernel`、`inversionFrequency`、`integral_inversionIntegrand_eq_frequency`、`inversionFrequency_eq_integral_kernel`；完整签名见声明清单。
- `ProbabilityTheory/chapter_09/thm_9_6.lean`
  - `measure_Ioo_eq_of_charFun_eq_of_commonContinuityPoints`：共同非原子端点处，由本次 `thm_9_5` 得开区间质量相等。
  - `thm_9_6_law`：两个有限实 Borel 测度的特征函数逐点相等即测度相等。
  - `thm_9_6`：任意两个概率空间上实随机变量的分布唯一性包装；前提仅为几乎处处可测及特征函数相等。
- `ProbabilityTheory/chapter_09/prob_9_6.lean`
  - `charFun_fin_sampleAverage`：对 `X : Fin n → Ω → ℝ`，由 `iIndepFun X P` 与逐项几乎处处可测证明有限和及 `1/n` 缩放的特征函数乘积公式。
  - `cauchy_fin_sampleAverage_charFun`：若每项分布均为真实密度测度 `cauchyMeasure μ ⟨σ,hσ.le⟩`，在 `0<n`、`0<σ` 下证明样本平均与该一般 Cauchy 分布特征函数相等。
  - `prob_9_6`：教材有限族主声明；对 `X : Fin n → Ω → ℝ`，前提为 `0<n`、`iIndepFun X P`、逐项几乎处处可测、位置 `μ`、正尺度 `σ` 及每项共同 Cauchy law，结论为样本平均 law 等于该共同 law。
  - `prob_9_6_eq_each`：同一前提下，样本平均 law 等于任意指定成员 `X i` 的 law。
  - `prob_9_6_standard`：位置零、尺度一的标准 Cauchy 有限族推论。
- `ProbabilityTheory/chapter_09/prob_9_8.lean`
  - `prob_9_8`：对可测实随机变量证明 `φ_X(2π)=1 ↔ X` 几乎处处取整数值。

反演分析支持

- `thm_9_5_fubini.lean`：`inversionIntegrand`、可测性、`norm_inversionIntegrand_le`、`inversion_finite_fubini`；落实有限截断绝对可积及 Fubini 交换。
- `thm_9_5_kernel.lean`、`thm_9_5_symmetry.lean`：`inversionKernel`、`inversionKernel_zero` 及复振荡核到两个 sinc 积分之差的恒等式。
- `thm_9_5_dirichlet.lean`：分部积分尾恒等式、尾界、柯西性、普通极限存在及 `abs_sincIntegral_le_four` 全局界。
- `thm_9_5_damping.lean`：阻尼余弦积分、阻尼 sinc 的有理积分与反正切计算。
- `thm_9_5_abel.lean`：Abel 平均、支配收敛识别普通极限，得到 `tendsto_sincIntegral_atTop_pi_div_two`。
- `thm_9_5_pointwise.lean`：内部、左端、右端、左外、右外五类核点态极限。
- `thm_9_5_bounds.lean`：`norm_inversionKernel_le_sixteen`，与 `x,T` 无关的统一支配界。

唯一性与柯西支持

- `thm_9_6_support.lean`：`atomPoints`、`countable_atomPoints`、`commonContinuityPoints`、`dense_commonContinuityPoints`；证明有限测度原子集可数且共同非原子点稠密。`mem_commonContinuityPoints_iff` 给出两端单点质量为零；`continuousAt_cdf_of_measure_singleton_eq_zero` 进一步证明这确为概率分布函数连续点。`isTopologicalBasis_Ioo_mem` 与 `isPiSystem_Ioo_mem_denseEndpoints` 证明稠密端点开区间生成实 Borel σ 代数并构成 π 系统，供有限测度扩张。
- `prob_9_6_cauchy.lean`：`laplaceKernel` 及其连续、可积性；`fourier_laplaceKernel` 显式计算 `exp(-|x|)` 的傅里叶变换，`integrable_fourier_laplaceKernel` 验证反演前提；`characteristicFunction_cauchyMeasure_zero_one` 从 Mathlib 的真实密度测度 `cauchyMeasure 0 1 = volume.withDensity(cauchyPDF 0 1)` 推出标准特征函数；`characteristicFunction_cauchyMeasure` 再对 `cauchyPDFReal μ ⟨σ,hσ.le⟩` 作平移缩放换元，证明一般公式 `exp(i μ t - σ |t|)`，前提仅 `0<σ`。

合同义务绑定

- 有限 T 的 Fubini、振荡核恒等式、Dirichlet 极限、五类点态极限、统一界及 DCT 端点半质量由九个反演专用文件落实：八个 `thm_9_5_*` 辅助文件和 `thm_9_5.lean` 主文件。
- 唯一性没有调用 `Measure.ext_of_charFun`：它调用本次反演，排除两测度可数原子，使用共同连续点稠密开区间拓扑基和 π 系统有限测度扩张。
- 柯西分支没有以期望结论定义柯西性：共同 law 直接是 Mathlib 的真实位置—尺度 Cauchy 密度测度。标准密度的特征函数由本次傅里叶反演计算，一般 `μ,σ` 公式由密度积分的仿射换元推出；主声明使用教材的有限 `Fin n` 族、`iIndepFun`、`n>0` 和 `σ>0`，并由有限乘积代数及本次唯一性得到共同 law 与逐项 law 两种结论。
- 整数分支保持完整双向证明。
- `ProbabilityTheory.lean` 已导入全部目标和支持文件。

实际构建

- `lake build`：退出码 0，整库默认目标构建成功；仅有既有风格与检查器提示，无证明错误。
- `lake env lean ProbabilityTheory.lean`：退出码 0，包含五个目标及全部支持的根导入构建成功。
- 静态检索 `ProbabilityTheory` 与 `ProbabilityTheory.lean`：未发现 `sorry`、`admit` 或新增 `axiom`。
