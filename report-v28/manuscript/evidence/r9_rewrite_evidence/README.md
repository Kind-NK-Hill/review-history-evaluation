# 修订稿 9 最小证据包

本包用于说明 ProbabilityTheoryFormalization 系统的评价方法与运行身份，不重写报告、不重新评价数学、不改变历史标签。只在本新目录写入文件；没有运行求解、构建、测试、抽样、统计研究或新模型调用，也未上传。

## 基准与范围

已核对 `Revisions from 913/report.en.md` 与 `appendix.en.md` 的完整原始字节，分别精确匹配附件 SHA-256：

- 正文 `18cb3a22934efe74c248e73612c38368984d34272b9991123331699c82f9b423`
- 附录 `340b34847164855d6dc670a5b66bbc13448d9be767fb5c62fac05fe7f88c6f80`

标题分别为 *How probability proofs are completed: workflow history and three organizational trajectories*、*Technical appendix: probability-proof workflows and trajectories*；均为 English substantive revision 9。没有用本地另行排版的修订稿替换基准。[标题原文](sources/BASE-report.txt)、[附录标题](sources/BASE-appendix.txt)。原实验接纳完成于北京时间 2026-09-12 09:22:31.625939；本次机械提取时间另列于 [检查记录](sources/PACKAGING_CHECKS.json)。核对结果：41 个真实根运行、33 项主表，A/B/C 通过数为 9/10/11，每组分母 11。[Y007](sources/A05.json)

检索从修订稿来源索引、归档引用、修订稿 7 的 Z/Y/X/I 冻结文件及 N 映射进入，定点读取运行普查、候选绑定、评价计划、实际请求与小回执、公开评审结果、E19 冻结决定及选择程序。只为已有异常和 A-L1 恢复读取了少数指向明确的日志，包内仅保留相关公开回复或会话标识。没有全盘扫描或重读全部角色日志。`ROOT` 是工作区别名，`USER_HOME` 是脱敏别名；它们不是外部可访问地址。

四个主文件：[运行索引](RUN_INDEX.csv)、[评价索引](EVALUATION_INDEX.csv)、[原始证据与来源哈希](EVIDENCE.md) 及本说明。CSV 空单元格表示未知/未记录；JSON null 未转换为 0。索引的 `source_pointer` 指向包内 B07 或 A40 数组；较长原字段保存在这些结构化文件中。

## A. 共同终验、裁决与后续接纳

**实际模型与会话。** 81 次原共同终验、31 次一致性评价、2 次 L7 补充评价均有实际回执；114 次请求中的型号与回执记录均为 `gpt-5.6-sol`、`medium`，不是由简称换算。114 个已记录会话标识互不重复，`source_session` 逐行保留；这支持不同评价会话，不证明模型错误统计独立。平台实际返回的模型型号未在本次核对的请求/回执/会话元数据中定位，保持未知。11 次早期临时评价不在本索引内。[逐调用证据 A40](sources/A40-call-evidence.json)

**可见内容与隔离。** 原终验输入清单逐项列出候选、源题、任务、上游与中性技术检查。提示要求隐藏配置身份；原程序把去身份的意见交给裁决者。实际清单、只读状态、前后清单哈希、会话与实现绑定均保留。提示中的“匿名”不证明候选注释、文件名或内容不可识别；本次未穷尽证明所有输入无身份线索。运行回执中的 A/B/C 字段属于宿主记录，尤其一致性评价的运行时 B 不能当作候选配置。后续裁决明确可见本候选初评及跨候选一致性检查，因此不应将所有裁决称为完全盲评。[实际请求 AP01–AP11，见证据索引](EVIDENCE.md)

**原协议与实际例外。** 已归档 `endpoint.py` 的 SHA-256 与实际运行固定实现一致。每个正常候选原规则要求两份结果；同票 pass/fail 直接完成，同票 inconclusive 成为 unresolved，异票生成至多一份裁决请求；裁决不能按多数或置信度机械选票。会话重复被拒绝。完整候选的判断对象是整束任务；部分交付另外保留范围，不能拿一个通过子目标替换整束结果。[绑定程序 A06](sources/A06.txt)

M3 的 A 第二意见实际使用对象型 confidence，原公开意见为 pass，宿主将其记为格式执行失败/inconclusive；与另一 pass 形成进入一次裁决的条件，裁决为 pass。对象型 confidence 并非只发生于 M3：原 H1-B、L5-B、L7-C 也有记录。原公开值、宿主代理结果、后续裁决分别保留在 A40；不能把宿主生成的 confidence=0 或 inconclusive 写成模型的数学意见。

L2/L3/H1 的一致性规则分别规定多种解释及维度合成：已知任一必要义务失败则该解释失败；否则有未决则未决；全部通过才通过。解释改变结论时保留争议。这些规则具有不同形成时间，不能当作原实验全部预注册。H1 六份初评之后、唯一裁决之前，补入原提交说明并对三份候选对称应用；原始最终消息、提交清单和交付说明有独立绑定。旧匿名视图没包含文档不等于作者没交付。H1-B 的反斜线引文问题及 L3 换行/定界符问题在 Y005 有原引文、真实上下文和兼容处理。[L2](sources/A10.json)、[H1规则](sources/A11.json)、[说明补入](sources/A12.json)、[原提交溯源](sources/A13.json)、[处理修复](sources/A03.json)

05:17:25 的补充阶段给 L7-C 增加两份实际评价；没有新求解，保留原构建。意见审查明确补入材料、原交付说明、可测性及合理修正条件。[补充范围](sources/A31.json)、[两份原意见](sources/A34.json)、[第二份](sources/A35.json)。09:22:31 阶段新增评价/求解/构建均为零：复用原意见，并明确选择 L2 的 G、L3 的最终尾部 T、H1 的教材标准柯西核心，以及 L7 合理且完整披露的条件修正。它同时是**接纳标准选择与结果处理修复**；十八项既有回归只验证处理，不是数学复判。[当前标准](sources/A01.txt)、[逐行变更和补充候选](sources/A02.json)、[既有回归](sources/A04.json)

当前未完成为 A-L3、A-L7、B-L3。L7 的 B/C 可测性修正与原字面合同不同；B 的 S 可测要求还应单列较强范围。原 A-L7 缺第二目标；独立修复运行也不自动替换主表。修订稿正文已披露标准事后更正与回归局限，应保留，补充方法细节即可。

## B. 41 个运行、候选选择、输入与缺失

A 原开发版本包括 L1、L2–L7、M1、M2 九组；后期运行时版本为 H1、M3 两组。H1 是同根继续并保留部分/完整候选身份；A-L7 修复另占一根。B 共五个原开发根、一个能力版本根、十一个传输修复版本根；C 为一个初始根与十一个运行时版本根。主表选择 A 上述九加二、B 的十一个传输版本、C 的十一个运行时版本，另外八根保留在全部版本范围。[版本原账](sources/B01.json)、[41 根详细绑定](sources/B07-root-bindings.json)

找到实际汇总程序：根内按绑定列表顺序优先首个完整授权候选，否则首个有共同终验的候选；再按上述版本过滤 33 项。注释明确不按有利结果选取。该程序产出 03:07:37 汇总，但本次未定位到同一选择规则在首次求解前已冻结的证据；不能改称预先规定、最后一次或最佳一次。A-L7 修复因独立修复版本不在该过滤条件中，未替换原主表根。[选择原文 B03](sources/B03.txt)

运行索引保存原候选/整包绑定、文件哈希及逻辑路径，原 hash 规则/协议字段、源任务与上游清单、配置/提示/实现/镜像绑定、预算、同根继续、真实停止证据和缺失状态。摘要/整包/主文件哈希分列，不互相替代。没有原字段的 seed 或实现身份不补猜；候选是否存在不能推出精确提交时刻。

**共同输入三个层次。** 协议要求见冻结共同规则和任务；本次只机械比较主表所选原终验清单，涵盖 A/B/C，结果如下。它验证冻结终验视图，不自动覆盖作者运行早期所有输入或事后材料。[逐组比较及原哈希](sources/B11-input-comparison.json)

| 组 | 源题清单 | 任务规则清单 | 上游清单 |
|---|---|---|---|
| H1 | 相同 | 相同 | 相同 |
| L1 | 相同 | 相同 | 相同 |
| L2 | 相同 | 相同 | 相同 |
| L3 | 相同 | 相同 | 相同 |
| L4 | 相同 | 相同 | 相同 |
| L5 | 相同 | 相同 | 相同 |
| L6 | 相同 | 相同 | 相同 |
| L7 | 相同 | 相同 | 不同 |
| M1 | 相同 | 相同 | 相同 |
| M2 | 相同 | 相同 | 相同 |
| M3 | 相同 | 相同 | 相同 |

L7 的上游清单差异已定点核对：A 额外列入 `ProbabilityTheory/chapter_10/thm_10_11.lean`，该文件只有一行“Blank experimental target”注释，没有实现；B/C 的上游清单没有此项。不能据此称三方完整输入包字节相同，也不能把这条占位注释说成已交付第二目标。[原文件 B12](sources/B12.txt)

实际隔离须另看宿主记录：L2 的原 A/B/C 停止容器明确绑定同一不可变镜像、只读根和没有覆盖库目录的挂载，且库文件/清单一致；这是有范围的实证，不应扩展为所有运行完全隔离的证明。[冻结库核验](sources/B04.json)。其他实际配置、原容器绑定、继续和停止记录见 B07。A-L1 的恢复属于宿主干预；H1 同根继续和独立 L7 修复均显式保留。

M2 准备任务给中心化四阶矩界，而原源题给原始四阶矩界；该差异不能整理为原始输入无歧义，源码应承担推导中心化界的责任。[源题片段](sources/B09.txt)、[准备任务](sources/B10.txt)。L7 的教材上下文和条件澄清是后补材料，见 A30/A31 与 AP11，不得追写为首次运行时已提供。

**用量缺失。** 以下 11 行直接来自现有成本账本：五次作者/协调者、六次内部服务；表内角色保留原名。完整 root、版本、调用源与原回执 hash 可按调用标识联结 B08 与 RUN_INDEX。未保存关闭记录的历史 active 状态不表示现在仍在运行。[原缺失行 B08](sources/B08-missing-usage.json)

| 调用标识 | 配置/组 | 版本 | 原角色 | 主表根 | 回执/时间 | 缺失用量字段 |
|---|---|---|---|---|---|---|
| `2ad8d4e6-0248-488c-b48e-445137c5d5c4` | A-L1 | `A_original_development_r1` | author | 是 | 有，失败记录；起止均有 | `input_tokens,cached_input_tokens,output_tokens,reasoning_output_tokens` |
| `65515f74-ec7e-4111-99dc-ef3058c3f755` | A-L1 | `A_original_development_r1` | general_reviewer | 是 | 整份完成回执未记录；关闭时点缺失 | `input_tokens,cached_input_tokens,output_tokens,reasoning_output_tokens` |
| `08dec13b-ffed-435e-b459-2a3d00af9bfa` | A-M1 | `A_original_development_r1` | support_author | 是 | 整份完成回执未记录；关闭时点缺失 | `input_tokens,cached_input_tokens,output_tokens,reasoning_output_tokens` |
| `c8528f6b-0e69-4b15-9943-c2f38a1d587a` | A-M1 | `A_original_development_r1` | general_reviewer | 是 | 有，失败记录；起止均有 | `input_tokens,cached_input_tokens,output_tokens,reasoning_output_tokens` |
| `d9978003-9b99-4ae5-8f59-dcb58ea09319` | A-M1 | `A_original_development_r1` | author | 是 | 有，失败记录；起止均有 | `input_tokens,cached_input_tokens,output_tokens,reasoning_output_tokens` |
| `93a19068-a9a8-4d0a-b13a-08d35213cdeb` | A-M1 | `A_original_development_r1` | general_reviewer | 是 | 整份完成回执未记录；关闭时点缺失 | `input_tokens,cached_input_tokens,output_tokens,reasoning_output_tokens` |
| `43df3e43-df3c-4576-9240-92e2641b14f7` | A-M1 | `A_original_development_r1` | author | 是 | 整份完成回执未记录；关闭时点缺失 | `input_tokens,cached_input_tokens,output_tokens,reasoning_output_tokens` |
| `401146c7-fb76-41f8-81ff-988e05bf92f8` | A-M1 | `A_original_development_r1` | general_reviewer | 是 | 整份完成回执未记录；关闭时点缺失 | `input_tokens,cached_input_tokens,output_tokens,reasoning_output_tokens` |
| `866ba1c8-d04a-43d0-b7da-7914b1499fd4` | A-L5 | `A_original_development_r1` | author | 是 | 有，失败记录；起止均有 | `input_tokens,cached_input_tokens,output_tokens,reasoning_output_tokens` |
| `ae2cdcf9-c752-4f75-8115-605362e0001f` | A-L5 | `A_original_development_r1` | author | 是 | 有，失败记录；起止均有 | `input_tokens,cached_input_tokens,output_tokens,reasoning_output_tokens` |
| `a55d42cc-14c9-4eb4-bb82-34c510932b51` | A-L7 | `A_l7_repair_r1` | math_reviewer_resume | 否 | 有，失败记录；起止均有 | `input_tokens,cached_input_tokens,output_tokens,reasoning_output_tokens` |

缺失限制全部版本活动成本总量只能给已观测下界；其中修复 A-L7 不属于主表。主表词元共同比较为八组，排除 L1/M1/L5；共同时间比较为九组，仅排除 L1/M1，**A-L5 虽缺词元但有完整跨度**。跨度统一从首次派发到最后角色返回，不含共同终验，不与提交耗时或外层控制器结束混用。缓存输入已包含于输入、推理输出已包含于输出；角色工作时长、帮助等待和区间并集不可再相加。N.5 全版本活动总量不是主表成本表；缺失调用比例也不等于缺失词元比例。不作美元估算、插补或无依据上界。[既有口径与共同组](sources/B02.json)

## C. 历史目标可比性

462 是受管理关系全集。冻结决定表实际有 131 条有明确判断的决定：129 肯定、2 边界；另 331 条在管理映射中为未实质判定，没有肯定依据。决定表自身 `unknown_decisions=0` 不与全集 331 未知冲突。129 肯定再扣除一条登记对象绑定冲突，得到 128 个目标/对象合格关系；这不等于审核条件相同，也不等于全部结果真实正确。[冻结核验及排除](sources/C01.json)

历史判断并非纯机械算法：原字段写明“AI archival reader; unblinded; not independent expert ground truth”，可见早晚标签以及源题、公开声明、端点输入/结果、代码差异和已有审查义务。已有明确 AI 决定与 v0.7.1 新增实质阅读分别标记来源；程序负责核对绑定、保留/排除及投影，禁止凭“筛查未发现变化”给肯定资格。新增阅读会覆盖较早决定，修订溯源仍保留；未定位到统一的独立专家裁决协议，不应补写成有。[程序与字段要求](sources/C05.txt)、[修改溯源](sources/C06.json)

目标可比性关心被接纳的源数学目标，而不要求实现或证明路线相同；表示改写、源目标恢复和支持组织变化可保持目标，新增参数本身也不是充分边界证据。已确认的源约定或接纳陈述改变才按边界处理；材料不足则未知。下面三例均逐标识确认属于同一 462 关系映射，没有重新判定：

- 肯定：`rel_1cc426169a021d9dd54961c8`，prob_14_11，两端历史 fail/fail。原决定认定任务目标相同，变化属于路线、支持、债务或审核政策；保留其他资格门槛。[原决定](sources/C02-decision.txt)、[全集成员行](sources/C02-map.txt)
- 边界：`rel_371ecb44ba45170919976d80`，prob_14_7，fail/pass。原决定详细说明源题未给极限变量独立性，而通过端公开 `hLimitIndep` 并伴随明确源题修正；边界不是简单由“多一个形式参数”推断。[原决定及反例说明](sources/C03-decision.txt)、[全集成员行](sources/C03-map.txt)
- 未知：`rel_7b7d8c2be77fd84f07915a2b`，def_3_6，fail/pass。`target_decision_id=null`，原理由明确没有此关系的目标专属实质裁决，筛查不能确立目标相同。未知不表示已确认变化。[原成员行与理由](sources/C04-map.txt)

## D. A-L1 恢复身份

恢复记录时间为 2026-09-10T16:08:03.2141265Z。它的 `dispatch_id` 是帮助目录 a8eee636…，`reviewer_session_id` 为 01a08bf3-acd6-7623-b4a3-23311bf5a423；但该 a8 目录的实际 actor 调用是 9d390ba0-5b05-4483-ac5f-fc6dddcb00d1，会话为 01a08c05-c5e1-7390-848d-7071e21a4878，日志起始事件也对应后者。恢复源和记录的目标哈希均为 `2731c4841276dd72e6148bfb65d8cd56c9a6027623e5ae66c3b62bafd48bac8e`；原最终 JSON 含候选 `f13136af…`、请求输入 `2a63e0f5…`，完整值见原对象。[恢复记录](sources/D01.json)、[目录回执](sources/D02.json)、[恢复 JSON](sources/D03.json)、[会话与最终公开回复](sources/D05.txt)

这确认了原稿已披露的身份字段冲突，并非新发现。目录标识、actor dispatch 和 session 是不同字段，不能互换。原控制器写 completed 及 complete_A，但不能凭此判定所有生产接纳链成立。恢复目标在当时容器中的内容本次没有独立重新读取，仅有恢复记录的目标哈希声明；不能把内容对应进一步写成已证明单纯抄错字段。需要当时恢复操作直接绑定该会话的原记录才能消除多种解释。[控制器状态](sources/D04.json)

## E. 分层中的已记录要求变化

原选择代码比较 `task_content_comparison` 和 `spine_contract_comparison`：任一值为 `different_recorded_value` 即 `recorded_change`，否则 `no_recorded_change`。后者明确包含不可比较字段，**不是确认要求未变化**。本包只读既有选择代码和字段语义，不重新选择八对。[原代码](sources/E01.txt)、[冻结说明](sources/E02.json)

## 修订边界与缺口

可直接补足：实际评价型号/会话、各版本输入范围和裁决触发、H1 文档补入时点、Y 的标准选择、实际候选过滤、缺失用量具体归属、历史 AI 判断/未知资格及分层字段含义。原稿关于 Y 事后更正、M2 差异、A-L1 身份冲突和回归局限已有充分明确说明，应保留而不是当作新发现。

仍未知：平台实际返回型号；所有运行无身份泄露/完全隔离的全称证明；某些历史 seed/原始输入绑定的缺字段；候选规则在首次求解前已冻结的证据；A-L1 恢复身份冲突唯一成因。定位到的原记录冲突原样保留，没有为对齐计数修补标签。冻结主表计数没有冲突；但其解释必须保留版本选择、事后标准选择、合理条件修正、输入差异与缺失范围，不能写成统一原始条件下的无条件排行榜。

本次没有发现权限阻碍。来源状态以“已核对原记录”“本次未找到”“记录冲突”分别说明；没有把未找到写成历史不存在。原记录的状态声明与本次独立核对范围分别标注。[全部来源索引](sources/SOURCE_INDEX.json)
