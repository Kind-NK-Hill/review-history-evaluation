# 语义过程样本：固定双起点规则 v1

2026-09-14。批量语义标注前确定。全部工具记录用于行动和可观察检查统计；本样本用于深入连接“需求—行动—反馈—变化—复验—成果”。它是覆盖33项运行的规则选样，不是全体恢复片段的普查，也不是随机样本。已读开发案例保留身份。

每项运行固定两个互补起点：

1. **首次可定位的Lean负面反馈。**按工具返回时间，从本运行全部主求解角色中找第一条真实Lean诊断；不能选择工具文档、旧日志或警告重放。该反馈可以出现在小试验或实际目标实现中，二者分别标注。若一次返回多条问题，跟踪所涉的同一实现/试验义务，不按错误行拆成独立片段。
2. **首次为具体数学证明需要而进行的资料检索。**包括搜索数学库、查定理类型或主动阅读相关定理源码，不要求先发生错误。读取任务契约、一般说明、目录清单或提交格式不算；读入数学工具说明也不算真正执行检索。从完整运行按时间选择首个满足条件的动作，说明具体证明需要和选择依据。

起点实施澄清（正式标注初期，三位标注者同步）：按任务要求批量读取全部给定上游主要属于输入阅读，不自动算主动检索。需能指出主动要查的名称、类型、性质或用法，并相应选择关键词、声明或源码段；单独读取某上游若明确服务具体证明需求可以计入。这一条件不根据后续是否成功改变。

两个起点指向同一需求时保留两个起点记录并给相同linked_need；分别在各自样本中汇总，不相加当独立恢复数。不存在对应行动时记no_eligible_event，不换成更精彩的后续案例。工具协议错误另有全量事实记录，不用来替换Lean诊断起点。

跟踪相同需求至可核实进展、明确替代/转交或运行结束；换文件/作者需要明确派发、编辑或候选对应。可报告局部结果，不必强行追到最终证明项依赖。搜索取得资料、局部应用、可见最终源码使用分别判定；缺证据填unknown。

每条标注使用如下字段：

```
run_id, sample_kind (first_lean_feedback | first_math_retrieval),
selection_status (selected | no_eligible_event | selection_uncertain),
start_event_id, start_source_file, start_source_line,
need_zh, linked_need, context_kind (probe | implementation | build_environment | mixed | retrieval),
feedback_zh, actions [{event_id, action, explanation_zh}],
progress (local_check_passed | usable_declaration_found | implementation_advanced | substituted | no_resolution_observed | evidence_insufficient | not_applicable),
end_event_id, resolution_zh,
final_adoption (explicit_final_source_use | final_source_present | replaced | unknown | not_applicable),
final_evidence [{path,line,detail_zh}],
evidence_event_ids, selection_reason_zh, confidence (high | medium | low),
review_notes_zh
```

action选用：read_or_search、changed_query、changed_namespace、changed_proof、changed_assumptions、changed_tool_or_parameter、delegated、rechecked、other。可以同一动作多标签，但时间和调用去重计算。不把先后顺序写成已证明因果。

逐配置由子代理读取原始公开记录标注，每个配置11项×2个起点，保存原判断。主调查者再核查起点选择、完整证据连接、全部最终采用主张与不确定案例；分歧另存。所有核对者均为代理，不能称真人专家金标准。后续随机抽样若开展，另存规则，不追认本批为随机选样。

报告必须说明：这些样本回答“每次运行最早出现的两类过程怎样推进”；不可用它们估计全体检索/恢复频率，不可据首错时间或恢复率给系统排名。完整33运行工具统计与样本的语义发现相互补充。
