# L3：审核运行了，为什么没有拦住尾部范围遗漏？

2026-09-13。回应用户追问“review、review-apply这些关口为何没有警报”。本轮只读核查，没有新改论文或实验。

## 直接解释

A有实际警报：第一次一般审核拒绝了额外要求极限函数处处非负、处处可测的接口，触发诊断和修复。其后数学路线检查及一般复审均接受了逐项可积的范围。没有针对尾部范围发出阻断意见。

数学门第一轮负责原命题及接口，实际看到尾部许可，却将逐项可积认定为有限实值积分的合法编码。三轮是同一个会话的命题、路线、Lean形状检查，不是三个独立审核员。一般复审的`interface_contract`再次采用该理由，`mismatches`为空；其总结把源决议、诊断和数学门与当前实现的一致性列为通过依据。记录支持共享了相同范围解释，不能仅凭此断定心理层面的锚定、模型同源性或提示缺陷是已识别的根因。

`review-apply`检查审核结果的结构、当前候选与材料绑定，以及适用的构建和依赖证据，再记录或应用判决。它不会再次调用一个独立数学审核者，重新证明“范围完整”的意见正确。因此，真实、当前、字段合格的错误通过意见仍可能通过这些检查。审核失败后的修复和诊断分支依赖阻断意见；复审已给通过时，不会自动为未被识别的尾部问题启动修复。

下游检查也没有揭露本例缺口：被检查的`ex_10_3_2`使用概率密度，本身就满足每项可积。较窄的Scheffé定理足以服务这个下游，不能由此确认较广源命题的范围已完整交付。

B自选复核同样明确看见尾部差别，却称其可选、不影响通过。它是B机制的一部分，故其错误应记入B系统表现。

结论：审核机制修掉了其他前提问题，却把逐项可积当作合法编码，没有正确区分尾部适用范围；后续程序校验保护判决与材料的对应关系，无法自行纠正这一语义错误。按采用的尾部验收范围，这是A的数学审核及一般审核漏检、B自选复核错误放行。任务原措辞为“允许”、后续验收明确化的限制仍保留，不能据此取消机制责任。

## 本轮核对的证据

- [一般复审原始结果](../../../fw_pilot_20260910_staging/coverage-runs-r1/L3_prob_7_6_to_ex_10_3_2/A/same-reviewer-resumes/general-v2/semantic_review_result_v2.raw.json)：`interface_contract`第193–196行；`downstream_adequacy`第198–205行；摘要第16行。
- [实际轨迹抽取](../../../review_history_retro_20260901/research_framework/full_workflow_eval_codesign_20260910/diagnostics/l3_responsibility_20260913/trace_extract.json)：第2轮作者提示明确原失败已应用，第5轮要求跳过已通过目标，首次审核指出两项前提转移。
- [更新的责任核查](../../../review_history_retro_20260901/research_framework/full_workflow_eval_codesign_20260910/diagnostics/l3_responsibility_20260913/REVIEW_MECHANISM_RECHECK.zh-CN.md)：数学门实际曝光与B会话身份。
- [保留的状态文档摘录](../../trajectory_analysis/team_review_v031_trajectory_v3_20260911/combined_revision_v12_20260912/manuscript/evidence/project_docs/workspace_state.excerpt.md)：review-apply与审核绑定的职责；不当作原实验全部执行细节的替代。

