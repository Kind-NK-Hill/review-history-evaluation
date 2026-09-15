# L7 候选缺口与合同责任

| 原候选 | 原终验 | 实际情况 |
|---|---|---|
| A 原部分候选 | fail | 整个连续映射分支缺失，不能全部归因于可测性合同缺陷。 |
| A 单独修复候选 | fail | 数值收敛证明获得原两评认可，但公开结论遗漏复合输出可测性；原假设也不足以推出这项义务。 |
| B r4 首次 L7 | fail | 增加全局 `Measurable f` 及 `MeasurableSet S`；原裁决认为在加强条件下证明正确，但改变了公开适用范围。 |
| C r3 首次 L7 | unresolved | 增加 `Measurable f`，并明确交付全部复合输出可测性；两份原终验均因置信度字段格式无效而保留未决。 |

这四份记录均只用于合同诊断。原局部连续条件不足以保证每个复合输出可测，纸面反例与搜索边界已有记录；反例未新增 Lean 验证。候选遗漏、主动增加假设、数值证明与评价格式故障分开记载，旧标签保持。

新合同草案显式要求 f 为 Borel 可测，并在 S 各点按环境拓扑连续；不得只用子空间相对连续性。新条件下的三配置求解需要另行登记与授权，本次没有启动。

逐候选代码位置、实际意见和来源哈希见 [L7_RESPONSIBILITY_MATRIX.json](D:/Grad_Study/Practimum/Formalization/review_history_retro_20260901/research_framework/full_workflow_eval_codesign_20260910/evaluation_consistency_r1_20260911/L7_RESPONSIBILITY_MATRIX.json)。
