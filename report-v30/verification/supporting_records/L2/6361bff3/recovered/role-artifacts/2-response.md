# 完成情况

已在隔离副本中实现并联合构建 `thm_11_4` 与 `thm_11_5`，完整源码改动见 `patch.diff`。

## 公开接口

- `Uncorrelated P X Y`：直接定义为中心化乘积积分为零。
- `uncorrelated_iff_covariance_eq_zero`：把该展开定义连接到 Mathlib 的协方差记号。
- `thm_11_4 P s X hX huncorr`：有限指标集上，两两不相关的二次可积随机变量之和的 Mathlib 方差等于方差之和。
- `sampleAverage X n`：前 `n + 1` 项的平均；这一索引方式避免 `n = 0` 时除零，同时与教材从 1 开始的样本量一致。
- `thm_11_5 P X μ σ2 hXm hX hmean hvar huncorr`：上述平均依概率收敛到常值 `μ`。

## 证明义务对应

`thm_11_4` 没有调用现成的有限和方差公式。证明先把总和的方差改写为自身协方差，再把它展开成双重有限和 `∑ i, ∑ j, cov(X i, X j)`；对角项用 `covariance_self` 还原成方差，非对角项则由 `Uncorrelated` 的中心化交叉项定义消去。

`thm_11_5` 对每个 `n` 实际证明有限和的均值是 `(n+1)μ`、方差是 `(n+1)σ²`，进而证明平均值的均值是 `μ`、方差是 `σ²/(n+1)`。随后应用切比雪夫不等式得到尾概率上界

`ENNReal.ofReal (σ² * (1 / (n + 1)) / ε²)`，

并证明该上界趋于零，最后由夹逼定理得到 `ConvergesInProbability`。

## 构建命令

```bash
cd /work/ProbabilityTheoryFormalization
/opt/lean/bin/lake build ProbabilityTheory.chapter_11.thm_11_4 ProbabilityTheory.chapter_11.thm_11_5
```

联合构建成功，共 8562 个任务；仅出现既有上游文件的行长警告，没有目标文件错误或警告。

## 接口说明

任务本身未给出 `thm_11_4`、`thm_11_5` 的固定签名。实现采用 Mathlib 原生 `Var[X; P]`，它与 `def_9_1.lean` 中携带有限矩证明参数的 `_root_.variance` 在定义上都落到二阶中心矩；原生接口避免把证明项嵌入有限和结论，同时可直接供切比雪夫接口使用。没有增加独立性、同分布或由调用者提供尾概率界等额外条件。
