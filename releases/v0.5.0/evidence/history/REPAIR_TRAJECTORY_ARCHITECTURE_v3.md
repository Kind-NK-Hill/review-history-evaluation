# Stage 6 相邻审核过程分类与候选修改轨迹架构 v3

## 修订目的

v1/v2 把很多不同用途的相邻审核放在同一条“修补轨迹”中。本版不改写旧数据和旧结果，而是在 v2 数据库上增加一层过程分类：先判断相邻两次审核在做什么，再决定哪些边可以进入候选修改 episode。

分类覆盖全部 2,645 条可定向的同任务相邻审核。记录判断只用于事后生成状态转移矩阵，不参与过程分类。v3 修订后明确区分“同一次审核的两个文件表示”和“两次不同审核执行”。

## 输入边界

程序只读取：

1. `execution_v2/review_repair_analysis_v2.sqlite3`；
2. EDA-1 的 `task_adjacent_pair_classification.csv`。

程序不直接读取旧 ToyApollo 归档，不修改 EDA-0、EDA-1、Stage 5、v1 或 v2 产物。v2 数据库中保留的历史来源路径只作为已登记来源字段使用，不沿路径读取原文件。

## 审核对象与用途

审核对象按已登记的候选文件分为：

- `candidate`：`candidate_vN.lean` 或 `draft.lean`；
- `official`：`official_snapshot_vN.lean`，或正式 `ProbabilityTheory/chapter_*`、`ToyApollo/Output` 路径；
- `unavailable`：字段缺失或无法识别。

审核用途从来源系列与对象类型派生。明确带 Kenneth 的来源视为外部成果审核；`exact_current_authority`、`rubric7_8_coverage`、`modern_catalog_gap_closure` 分别保留其正式成果复查用途；其他条目按候选或正式成果语义审核记录。

## `transition_role` 映射

分类按以下优先级执行，且不读取 recorded verdict：

1. `same_review_representation`：同一目录、同一结果版本的 `semantic_review_result_vN_raw.json → semantic_review_result_vN.json`，并且候选、完整输入和全部上下文条件相同。这是同一次审核的原始/整理表示，不是第二次审核。
2. `external_review`：任一端来源明确属于 Kenneth 外部成果审核。两端都属于该来源为高置信，进入或离开为中置信。
3. `same_condition_stability`：除候选、输入、对象和上下文全部相同外，还必须有明确的不同执行证据。只有满足该额外条件才可进入稳定性样本。
4. `candidate_landing`：候选审核之后是正式成果审核，且主 Lean 文本相同。记为高置信候选落地。
5. `candidate_repair`：下一审核对象是候选版本，且主 Lean 文本改变。若前一审核有结构化 finding，记高置信；否则记中置信。
6. `official_rereview`：两端对象均为正式成果。主文本相同时为高置信，改变或不可比较时为中置信，因为不能从两个正式端点反推中间过程。
7. `unknown_mixed`：其余边。条件相同但无法证明是两次执行的记录也进入本类。保留为低置信混合/信息不足，不删除，也不称为无用数据。

当前数据中明确识别出 166 条 `same_review_representation`。原先剩余的 `semantic_review_result.json → semantic_review_result_v2.json` 虽有不同时间戳，但候选、输入、摘要和 findings 相同，没有独立执行标识，因此归入 `unknown_mixed`。严格 `same_condition_stability` 样本为 0。

## 变化维度

每条边同时记录下列相互重叠的变化维度：

- 完整审核输入；
- 候选 identity；
- 主 Lean 代码；
- 审核对象类型；
- 正式成果内容；
- 核心规则；
- 其他审核上下文代理；
- 审核来源/用途；
- 原始审核对象标识。

这些字段用于解释“哪里变了”，不把共同变化解释成因果。

## episode 规则

新的 `repair_episode_v3` 只由 `transition_role=candidate_repair` 且 `confidence=high` 的边组成。相邻高置信边共享审核端点时合并为一个最大连续 episode；遇到其他角色、时间不可定向或观测结束即停止。

一次 attempt 定义为一条高置信候选修改边。episode 报告 attempt 数、候选数、记录判断路径、最后记录判断和退出原因。最后记录为 pass 不叫客观成功，最后记录为 fail 也不叫无进展。

## 输出

- `transition_role_ledger.csv`：全部 2,645 条边及其角色证据；
- `same_review_representation_pairs.csv`：明确识别的同一审核双重表示；
- `classification_coverage.csv`、`transition_role_summary.csv`：覆盖率、角色与置信度；
- `state_transition_matrix.csv`：四类记录判断的完整 4×4 矩阵；
- `high_confidence_candidate_repair_edges.csv`：episode 的唯一输入边；
- `repair_episode_ledger.csv`、`episode_attempt_distribution.csv`、`episode_outcome_distribution.csv`；
- `pass_to_fail_core_rule_same_change_summary.csv`：76 个核心规则相同案例的变化维度；
- v3 SQLite、结果说明和 QA 回执。

## Stage 7 接口

Stage 7 若获单独授权，应优先读取 `adjacent_review_transition_v3` 和 `repair_episode_v3`，并把角色置信度作为选择条件或敏感性维度。`same_review_representation` 必须从执行稳定性样本中排除。由于严格稳定性样本为 0，历史数据不能估计相同条件下的重复审核方差；该问题需要前瞻性重复执行。不得重新把全部相邻审核当作同一种修改过程，也不得把记录判断当数学真值。
