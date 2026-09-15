# Stage 6 相邻审核过程分类与候选修改轨迹 v3

## 结果概览

本版对全部 2645 条可定向相邻审核逐条增加 `transition_role`。角色判断不读取两端 `pass/fail/inconclusive/partial`，只看审核对象、两端候选文本、正式成果状态、审核输入、来源/用途与上下文字段。

- 角色数量：{"candidate_landing":241,"candidate_repair":465,"external_review":207,"official_rereview":1176,"same_condition_stability":0,"same_review_representation":166,"unknown_mixed":390}。
- 置信度数量：{"high":1821,"low":390,"medium":434}。
- 已归入具体角色 2255/2645（85.26%）；`unknown_mixed` 390 条。后者仍保留在状态矩阵和明细中，不表示无用。
- 记录判断转移：{"fail→fail":339,"fail→inconclusive":7,"fail→partial":1,"fail→pass":375,"inconclusive→fail":9,"inconclusive→inconclusive":2,"inconclusive→pass":52,"partial→pass":1,"pass→fail":310,"pass→inconclusive":44,"pass→pass":1505}。16 个方向的完整矩阵（含 0 格）见 `state_transition_matrix.csv`。

## 角色口径

- `candidate_repair`：下一审核对象是候选版本、主 Lean 文本明确改变；高置信还要求上一审核记录了结构化问题。
- `official_rereview`：两端都审核正式成果；即使正式成果内容改变，也不反推中间一定发生候选落地。
- `candidate_landing`：候选版本之后出现正式成果审核，且两端主 Lean 文本完全相同。
- `same_review_representation`：同一目录、同一版本的 `_raw.json → .json`，且候选、输入和全部上下文条件相同；这是同一次审核的两个文件表示。
- `same_condition_stability`：除完整条件相同外，还必须有明确证据证明是两次不同审核执行；当前历史数据中为 0 条。
- `external_review`：来源明确标记为 Kenneth 外部成果审查；进入或离开该来源时置信度降为中。
- `unknown_mixed`：现有字段不能把过程唯一归到上述一类。

## 仅基于高置信候选修改边的 episode

高置信 `candidate_repair` 边 367 条，按共享端点组成 262 个 episode。每个 episode 的尝试次数分布为 {"1":212,"2":38,"3":1,"4":5,"5":3,"12":2,"17":1}；末端记录判断分布为 {"fail":20,"inconclusive":6,"pass":236}。这些是历史记录的端点，不是客观修改成功率。

`same_review_representation` 的 166 条边不进入稳定性样本，也不进入候选修改 episode。另有 1 条条件相同但只有普通结果文件版本变化，无法证明是独立执行，已归入 `unknown_mixed`。

## 核心规则相同的 `pass→fail`

76 个案例的核心规则字段相同，但 76/76 的完整审核输入都发生变化，所以不能称为“完整条件相同仍翻转”。重叠变化维度计数为 {"candidate_identity":29,"complete_review_input":76,"core_rule":0,"official_artifact":25,"primary_code":28,"raw_review_subject":76,"review_context":65,"review_object_type":33,"review_purpose_or_source":33}。这些计数分别说明代码、审核对象、上下文、用途/来源或其他输入成分是否变化；同一案例可计入多个维度。

## 使用边界

本版没有拟合 Stage 7 模型。`transition_role` 是可重复计算的过程分类，不是真值标签；相邻顺序不证明因果；不是候选修改边的审核仍保留其数据表示、复查、落地或外部审核价值。

## 对 Stage 7 的影响

- 严格 `same_condition_stability` 样本为 0，历史数据不能估计完整条件相同的重复审核方差。
- 166 条 `same_review_representation` 必须先从任何稳定性或独立执行分析中排除。
- 高置信候选修改边和 262 个 episode 数量不受本次修正影响，因为这些双重表示从未属于候选修改。
- 若以后研究同条件稳定性，需要前瞻性重复执行，并为每次执行登记独立执行标识；不能再用结果文件版本号代替执行次数。
