# A/B/C 版本差异独立核查

日期：2026-09-13。角色：**独立核查 Astra high**。核查对象为 `chapter1_design_010.md` 的版本差异表与主表纳入说明；该文件和第12版论文是待核主张及定位入口，不被当成原始运行权威。

本轮先读工作区 README、共享研究交接与 CURRENT_STATUS；只读源码、冻结清单、提示原件和公开运行事件，另写本记录。没有修改论文、实验、代码、统计或历史回执，没有启动模型求解、构建、测试，也没有读取或混入新的 `a-l7-resume-20260913`。这不是全部33次实验的完整上下文或数学正确性审计。

## 逐项结论

| 待核主张 | 判定 | 独立核查后的准确说法 | 效果边界 |
|---|---|---|---|
| 1. C早期到r3只将固定预算、目标文件参数化，属于小适配 | **确认模板差异；限定范围** | 真正冻结r1的四份模板与r3相比，确实只有协调预算5400→参数、审核目标路径→参数两处内容改变；作者、数学咨询模板字节相同。应改用冻结r1作依据，不能把当前已含r2修复的 `c_pilot` 当初始实现。 | 只能称模板的任务扩展适配。后台另有反馈返回、只读导出、状态和可读文件类型变化，不能据此称整个版本影响小。 |
| 2. 早B部分承诺能力不可用，r3补齐 | **确认；区分设计、实现及验证时间** | 早期源码仅为A装配/挂载引擎资料；抽查早B-L2的实际启动回执与种子支持该缺口。r3源码提供公共挂载及中性入口；后续同版本能力探针已有通过记录。 | 原 `CANDIDATE_STATUS.r3` 自己还写尚未完成真实验证，不能单凭它宣称已验证；早B表现受多少影响未量化。 |
| 3. B r4与C后期修复生成后不可读的反馈/补丁 | **确认机制和具体观察；限定效果** | B r4明确输出UTF-8、交付调用者可读的内层补丁；工程探针实际读取并应用。C原r1角色正常返回，但协调者实际收到导出错误；后期C-L1实际收到审核意见并作出回应。 | 工程修复改变可用信息和继续工作的机会，不能认定无影响；尚无匹配反事实给出净收益。也不能将一次可读推广为所有r4/r3服务均无故障。 |
| 4. 删除L4额外接口限制和M3/H1模块名，影响不一 | **确认；补强实际暴露证据** | r4实际投影的变换清单保留三份文件的完整删除差异；L4精确接口限制超过公开任务，M3/H1主要额外透露生产拆分/归属。A-L4第5次作者提示实际给出“若不要求MathGate，则直接用该接口”的条件性指令。 | “A是否看到”对L4精确接口已不宜一概留白；但尚不能证明它由哪个参考文件引入、改变了多少成本/结果。M3/H1本轮未重建阅读与采用链。 |
| 5. A-L7预算未尽却被外层停止 | **确认** | 原第7次作者提示禁止改Lean、求助和新审核身份，并要求宿主封存；原回执记录7200秒额度、封存时剩3668.152715秒。 | 这是实际机会截断；不能推出余时一定成功，也没有证实这是A生产规则必然要求。发令者身份与为何不允许接口改写仍未决。 |
| 主表A九早两晚、B全r4、C全r3 | **确认版本族；补充C子版本** | 主表筛选源码和固定运行索引一致；A后期为H1/M3，B十一启动清单绑定r4冻结epoch。C十一清单属于r3族，但有原r3、L2准入副本、覆盖准入副本。 | 版本族标签不等于同一文件树哈希，更不等于全部初始上下文相同。 |

## 1. C：真正冻结的提示与后台

原始C运行的 [implementation-manifest.json:2](D:/Grad_Study/Practimum/Formalization/fw_pilot_20260910_staging/c-pilot-r1/prob_13_9/implementation-manifest.json:2) 将运行实现绑定到 `fw_pilot_20260910_staging/c-runtime-frozen-r1`，其中第28–58行记录四份提示的哈希。本轮逐字节计算这些文件哈希，四项均与原运行清单吻合；r3四份模板也均与 [C-L1运行清单](D:/Grad_Study/Practimum/Formalization/c-r3-runs/c-r3-l1-001/run/implementation-manifest.json:2) 的记录吻合。

独立执行忽略行尾差异的文件比较，结果为：

| 模板 | 冻结r1 → r3 | 精确位置 |
|---|---|---|
| 协调者 | `5400` → `__ALLOWANCE_SECONDS__` | [r1第5行](D:/Grad_Study/Practimum/Formalization/fw_pilot_20260910_staging/c-runtime-frozen-r1/protocol/coordinator_prompt.zh-CN.txt:5)、[r3第5行](D:/Grad_Study/Practimum/Formalization/review_history_retro_20260901/research_framework/full_workflow_eval_codesign_20260910/c_runtime_r3_20260911/protocol/coordinator_prompt.zh-CN.txt:5) |
| 独立审核 | `ProbabilityTheory/chapter_13/prob_13_9.lean` → `__TARGET_FILE__` | [r1第3行](D:/Grad_Study/Practimum/Formalization/fw_pilot_20260910_staging/c-runtime-frozen-r1/protocol/review_template.zh-CN.txt:3)、[r3第3行](D:/Grad_Study/Practimum/Formalization/review_history_retro_20260901/research_framework/full_workflow_eval_codesign_20260910/c_runtime_r3_20260911/protocol/review_template.zh-CN.txt:3) |
| 数学咨询 | 字节相同 | SHA256 `9b8ad9a6eb8418dead1ca625375b7d9f4b0b06a0ad2e52fa37208d85deec90d4` |
| 作者 | 字节相同 | SHA256 `35ad8d016831e91e225e76025f889b6e14845cc7327399f0d0650d57d8c06cd4` |

这支持“小适配”的**模板内容判断**，不支持整个运行条件不变。独立比较冻结r1与r3后台，还看到以下实质执行差异，均在 [r3 c_backend.py](D:/Grad_Study/Practimum/Formalization/review_history_retro_20260901/research_framework/full_workflow_eval_codesign_20260910/c_runtime_r3_20260911/runtime/c_backend.py:29)：第29–33行区分退出状态及内容投影；36–52行从只读代理容器导出；54–76行提前持久化角色序号与结果；78–83行调整资源槽观察；92–97行临时目录成功后登记候选；104行在原 `.lean/.md/.tex` 之外开放候选 `.txt/.json`；136–153行先持久化反馈，再处理只读审计，即使后者失败也保存失败原因和反馈对象。

当前 `c_pilot` 已有 [snapshot_readonly_work:36](D:/Grad_Study/Practimum/Formalization/review_history_retro_20260901/research_framework/full_workflow_eval_codesign_20260910/c_pilot_20260911/runtime/c_backend.py:36)，而 [R2_FIX_NOTES:29](D:/Grad_Study/Practimum/Formalization/review_history_retro_20260901/research_framework/full_workflow_eval_codesign_20260910/c_pilot_20260911/R2_FIX_NOTES.zh-CN.md:29) 明确这份修复作用于未冻结r2，r1运行目录未改。此前选现存 `c_pilot` 作“早期”比较，模板结论碰巧仍成立，历史实现归属却必须纠正。

历史设计本来也只规定强协调者自主组织和信息边界，没有保证所有版本实现相同；见 [C选择记录:7–9、26–36](D:/Grad_Study/Practimum/Formalization/review_history_retro_20260901/research_framework/full_workflow_eval_codesign_20260910/C_SIMPLE_COORDINATION_r2_20260911.zh-CN.md:7)。本轮没有把设计声明当成每次调用都遵守的证明。

## 2. B：承诺、实际能力与验证时间

历史诊断见 [B入口草稿:13–20](D:/Grad_Study/Practimum/Formalization/review_history_retro_20260901/research_framework/full_workflow_eval_codesign_20260910/B_BASELINE_ENTRY_DESIGN_DRAFT_r2_20260911.zh-CN.md:13)。本轮进一步检查原装配/启动源码：

- [assemble_seeds.py:66–95](D:/Grad_Study/Practimum/Formalization/review_history_retro_20260901/research_framework/full_workflow_eval_codesign_20260910/pilot_20260910/assemble_seeds.py:66) 仅 `arm == 'A'` 复制引擎并初始化对应私有环境。
- [coverage_pair_runner.py:31–50](D:/Grad_Study/Practimum/Formalization/review_history_retro_20260901/research_framework/full_workflow_eval_codesign_20260910/coverage_20260910/coverage_pair_runner.py:31) 仅A初始化引擎、读引擎环境并挂载 `src/docs/data/inputs/plans`。
- 实际早B-L2 [setup-result.json:5–11](D:/Grad_Study/Practimum/Formalization/fw_pilot_20260910_staging/coverage-runs-r1/L2_thm_11_4_to_11_5/B/setup-result.json:5) 绑定旧B种子；实际 [actor-container.json:151–170](D:/Grad_Study/Practimum/Formalization/fw_pilot_20260910_staging/coverage-runs-r1/L2_thm_11_4_to_11_5/B/actor-container.json:151) 只有工作和临时卷。抽查该保存种子的顶层确无引擎源码/参考目录。这是实际运行装配证据，仍不等于逐个旧B会话重演过命令查找。

r3则在 [runner_candidate.py:256–270、484](D:/Grad_Study/Practimum/Formalization/review_history_retro_20260901/research_framework/full_workflow_eval_codesign_20260910/coverage_20260910/formal_freeze_candidate_r3_capability/runner_candidate.py:256) 挂载 `/opt/common` 并初始化无历史状态；设计及实现意义是恢复能力健全的自主基线。

须纠正证据时间的省略：[CANDIDATE_STATUS.r3:5–9、65–79](D:/Grad_Study/Practimum/Formalization/review_history_retro_20260901/research_framework/full_workflow_eval_codesign_20260910/coverage_20260910/formal_freeze_candidate_r3_capability/CANDIDATE_STATUS.r3.zh-CN.md:5) 当时明确尚未完成当前版本真实验证。后续保存的 [SMOKE_RESULT.json:3、43–45](D:/Grad_Study/Practimum/Formalization/bcap-r3-evidence/smoke-L1-takeover-final-001/SMOKE_RESULT.json:3) 才给出通过、模块来源及命令退出码0，414–425行定位实际 `formalize -h` 检查。本轮只读该探针记录，没有重跑。

## 3. 返回修复：不能将工程修复等同于无性能影响

B r4源码在 [helper_dispatcher.py:40](D:/Grad_Study/Practimum/Formalization/review_history_retro_20260901/research_framework/full_workflow_eval_codesign_20260910/coverage_20260910/formal_freeze_candidate_r4_transport/candidate_runtime/helper_dispatcher.py:40) 以UTF-8字节写返回；第260–285行单独提取角色声明的内层产物，292–334行复制到调用者 `/tmp` 并返回路径和哈希。这里能确认传输安排，没有自动采用或数学成功保证。局部命令使用容器内GNU timeout，见 [container_mcp.py:150–162](D:/Grad_Study/Practimum/Formalization/review_history_retro_20260901/research_framework/full_workflow_eval_codesign_20260910/coverage_20260910/formal_freeze_candidate_r4_transport/candidate_runtime/container_mcp.py:150)；外层失控超时仍可杀容器，不能泛称任何超时都可继续。

独立于总结报告，保存的 [live-transport RESULT:3–19](D:/Grad_Study/Practimum/Formalization/bcap-r4-evidence/live-transport-001/RESULT.json:3) 记录两次非数学模型调用，调用者确实读到中文及内层补丁、检查并应用到工程文本。另抽查数学B-M3的 [原始公开事件:37、52–53](D:/Grad_Study/Practimum/Formalization/bcap-r4-runs/coverage-M3-B-r4-001/author-call-01/raw-public-events.bin:37)，可见内层补丁路径返回及随后应用命令成功。该抽查支持数学运行里也存在实际可达和操作，未在本轮重做最终代码逐字采用认证。

C原r1的 [审核角色回执:29–30](D:/Grad_Study/Practimum/Formalization/fw_pilot_20260910_staging/c-pilot-r1/prob_13_9/actors/reviewer-002/actor-receipt.json:29) 和 [数学检查回执:29–30](D:/Grad_Study/Practimum/Formalization/fw_pilot_20260910_staging/c-pilot-r1/prob_13_9/actors/math_checker-002/actor-receipt.json:29) 均为退出0、非超时；但 [协调者公开事件:46、50](D:/Grad_Study/Practimum/Formalization/fw_pilot_20260910_staging/c-pilot-r1/prob_13_9/actors/coordinator-001/raw-public-events.bin:46) 实际返回 `read-only file system`。第47、55–57行显示协调者因此将独立审核/咨询记为未完成。结合冻结r1后台先导出再保存反馈的顺序，支持“角色回合完成后，导出故障阻断意见返回”。

后期C-L1 [reviewer-2.json:5–9](D:/Grad_Study/Practimum/Formalization/c-r3-runs/c-r3-l1-001/run/results/reviewer-2.json:5) 保存完整意见且只读审计通过；更关键的 [协调者公开事件:61–62](D:/Grad_Study/Practimum/Formalization/c-r3-runs/c-r3-l1-001/run/actors/coordinator-001/raw-public-events.bin:61) 显示工具返回意见，协调者随后明确回应审核通过再提交。这超过“宿主文件存在”的证据强度。

上述改变能影响后续选择，却没有匹配重跑给出完成率、耗时或成本的净变化。r4/r3也不是绝无返回故障的保证，不能将修复后的一个成功实例推广到所有服务。

## 4. 公共投影：约束与命名应分别讨论

本轮读取实际B-M3运行的 [COMMON_MATERIAL_TRANSFORMATIONS.r4.json:3–33](D:/Grad_Study/Practimum/Formalization/bcap-r4-runs/coverage-M3-B-r4-001/projection/COMMON_MATERIAL_TRANSFORMATIONS.r4.json:3)，并非只复述旧审计。该文件逐份保存原哈希、结果哈希及完整统一差异：一份模块文档删除M3五行和H1三行；两份引擎源码删除L4双分支提醒和“禁止绕开 `thm_8_6_discrete`”的限制。

公开 [L4 TASK:3–5](D:/Grad_Study/Practimum/Formalization/bcap-r4-runs/coverage-L4-B-r4-001/projection/B-work/ProbabilityTheoryFormalization/TASK.zh-CN.md:3) 已要求双公式及例题计算；[共同规则:5](D:/Grad_Study/Practimum/Formalization/bcap-r4-runs/coverage-L4-B-r4-001/projection/B-work/ProbabilityTheoryFormalization/COMMON_RULES.zh-CN.md:5) 允许数学等价替代证明；[SOURCE:39](D:/Grad_Study/Practimum/Formalization/bcap-r4-runs/coverage-L4-B-r4-001/projection/B-work/ProbabilityTheoryFormalization/SOURCE.tex:39) 写应用定理8.6，没有指定Lean声明名。因此“双分支”主要重申公开义务，而精确接口禁令额外收窄实现选择。

还发现比原表更强的实际暴露证据：原 [A-L4 author-call-05/prompt.txt:1](D:/Grad_Study/Practimum/Formalization/fw_pilot_20260910_staging/coverage-runs-r1/L4_thm_8_6_to_ex_8_4_3/A/author-call-05/prompt.txt:1) 明确给出“若不要求MathGate，则……直接用thm_8_6_discrete”的条件性指令。因此至少能确认接口名称和条件性使用指令进入作者上下文，不能仅据这份提示确认该分支实际执行。它是否由被删引擎特例引起、是否本来就会选择该接口、是否额外消耗资源，本轮没有证据。该提示另有“三点分布”措辞，与公开L4例题表述不同；本轮不扩展为该运行全部数学提示审计，也不将它归因于投影删除。

M3的 [公开TASK:5](D:/Grad_Study/Practimum/Formalization/bcap-r4-runs/coverage-M3-B-r4-001/projection/B-work/ProbabilityTheoryFormalization/TASK.zh-CN.md:5) 已列概率空间、分位数、可测性、分布、逆像、可数坏水平和收敛；H1的 [公开TASK:11](D:/Grad_Study/Practimum/Formalization/bcap-r4-runs/coverage-H1-B-r4-001/projection/B-work/ProbabilityTheoryFormalization/TASK.zh-CN.md:11) 也明确本组新做专有分析支持。删除的模块行只提供精确文件名称和家族归属，没有Lean证明正文。将其称作额外组织线索比称作答案泄漏准确，但不能据此保证其效果为零。本轮没有重建A-M3/H1实际打开该文档的证据链。

冻结r4自身仍保留 [epoch:25](D:/Grad_Study/Practimum/Formalization/review_history_retro_20260901/research_framework/full_workflow_eval_codesign_20260910/coverage_20260910/formal_freeze_candidate_r4_transport/RUNNER_EPOCH.development-r4-20260911.json:25) 的条件：正式匹配A/B比较须A同投影或重跑受影响A。这是历史可比性限制，不是本轮重跑授权，也不使现有描述性观察自动失效。

## 5. A-L7：实际封存与剩余时间

[第7次作者提示:1](D:/Grad_Study/Practimum/Formalization/fw_pilot_20260910_staging/coverage-runs-r1/L7_thm_10_10_to_10_11/A/author-call-07/prompt.txt:1) 的确将数学关卡 `stop/interface_rewrite` 扩展为禁止任何Lean修改、求助和新审核身份，再由宿主封存。原 [A_INTERNAL_RESULT.development.json:12–16](D:/Grad_Study/Practimum/Formalization/fw_pilot_20260910_staging/coverage-runs-r1/L7_thm_10_10_to_10_11/A/A_INTERNAL_RESULT.development.json:12) 给出额度7200秒、已用3531.847285秒、剩3668.152715秒；第5行保留当时开发性质和不具正式比较资格。

可确认这不是额度耗尽。停止错误接口与禁止所有后续修订不是同一个动作。数学检查背景不自行证明永久封存为唯一合理处理；同时，剩余约61分钟也不能证明足以完成。发出封存决定的具体人/代理身份、决策依据及放开续作的反事实结果仍未决。本轮结论不受后来任何新续作结果替换。

## 6. 主表版本分布及共同上下文边界

本轮读 [主表组装源码:38–53](D:/Grad_Study/Practimum/Formalization/review_history_retro_20260901/research_framework/full_workflow_eval_codesign_20260910/evaluation_consistency_r1_20260911/assemble_final_delivery_r1.py:52) 的实际筛选表达式，并按固定 [RUN_INDEX.csv](D:/Grad_Study/Practimum/Formalization/reports/trajectory_analysis/team_review_v031_trajectory_v3_20260911/combined_revision_v12_20260912/manuscript/evidence/r9_rewrite_evidence/RUN_INDEX.csv:1) 读取 `main_panel` 行的组名、臂、版本和原运行路径，没有重算结果统计。分布与附录一致：

- A早期九组：L1–L7、M1、M2；A后期两组：H1、M3。后两者的原 [H1 setup-result:5](D:/Grad_Study/Practimum/Formalization/a-stage-runs/H1_inversion_chain/A/setup-result.json:5)、[M3 setup-result:5](D:/Grad_Study/Practimum/Formalization/a-stage-runs/M3_thm_10_8/A/setup-result.json:5) 均实际记录A-r2。H1的后续路径由主表记录为同根延续；本轮不重新审计全部延续调用。
- B十一组：逐份读取 `bcap-r4-runs/*/LAUNCH_MANIFEST.json`，全部绑定同一 `RUNNER_EPOCH.development-r4-20260911.json`；例如 [B-M3清单:13–20](D:/Grad_Study/Practimum/Formalization/bcap-r4-runs/coverage-M3-B-r4-001/LAUNCH_MANIFEST.json:13)。这比目录名证据强。
- C十一组：逐份读取 `c-r3-runs/*/run/implementation-manifest.json`。L1/M1绑定原 `c_runtime_r3_20260911`；L2绑定 `c_runtime_r3_l2_admission_r1_20260911`；H1、L3–L7、M2、M3绑定 `c_runtime_r3_coverage_admission_r1_20260911`。见 [L2清单:2](D:/Grad_Study/Practimum/Formalization/c-r3-runs/c-r3-l2-001/run/implementation-manifest.json:2)、[H1清单:2](D:/Grad_Study/Practimum/Formalization/c-r3-runs/c-r3-h1-001/run/implementation-manifest.json:2)。文件比较确认准入副本后台与模板一致，忽略行尾后启动文件内容差异在 [allowed表:14](D:/Grad_Study/Practimum/Formalization/review_history_retro_20260901/research_framework/full_workflow_eval_codesign_20260910/c_runtime_r3_coverage_admission_r1_20260911/run_c_pilot.py:14)。所以“全r3”作为版本族成立，不能写成十一份运行使用完全相同文件树。

第12版 [附录N.1.1:1846](D:/Grad_Study/Practimum/Formalization/reports/trajectory_analysis/team_review_v031_trajectory_v3_20260911/combined_revision_v12_20260912/manuscript/appendix.zh-CN.md:1846) 本来也只将共同包检查解释为冻结评估输入，不重建求解期间每个早期可访问文件。无论最终任务/原文一致性有多强，都不能反推系统提示、工具说明、参考资料、临时修复、停止指令与运行内反馈从起点起全部相同。

## 本轮尚未确定

1. 各工程变化对时间、成本、交付率的净贡献；没有进行匹配反事实比较。
2. 全部早B实际命令尝试与材料阅读、全部33次完整初始上下文的字节一致性。
3. A-M3/H1是否打开或采用被删除的模块命名信息；A-L4接口指令具体由哪个来源引入。
4. A-L7原封存决定的发令身份和理由，以及未封存时会发生什么。
5. 本轮未重新认证历史数学评审、全部补丁数学采用链或生产落地状态。

建议主代理保留五项差异，但将第一项明确缩为“冻结提示模板”；将第四项补上A-L4实际接口指令；将“C全r3”说明为含准入副本的版本族。其余不应从工程修复名义推论影响可忽略，也不应仅凭版本差异取消有界的描述性比较。
