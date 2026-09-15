# 交接决策的直接来源

本轮结论由角色实际请求、当时工作区与返回状态共同约束。以下不是根据最终文件倒推助手当时已知的信息。

- [第二次帮助的完整角色提示](D:/Grad_Study/Practimum/Formalization/review_history_retro_20260901/research_framework/replication_20260913/runs/r2-m2-a/help/7199ffd4-6d75-4104-9445-b99ab512731c/actor/prompt.txt)：请求允许重新取得或重建；要求完整替换候选及仓库补丁。
- [第二助手输入中的任务书](r2-m2-a/7199ffd4-6d75-4104-9445-b99ab512731c/before/.__ProbabilityTheoryFormalization__TASK.zh-CN.md)：明确不要求同分布，也不能强化为同分布。
- [第二助手输入中的原草稿](r2-m2-a/7199ffd4-6d75-4104-9445-b99ab512731c/before/.__artifacts__phase2_prompt_packs__thm_11_7__draft.lean)：不含首位助手的完成证明。
- [第二助手最终替换候选](r2-m2-a/7199ffd4-6d75-4104-9445-b99ab512731c/after/.__artifacts__phase2_prompt_packs__thm_11_7__draft.lean)：加入`hident`，调用`strong_law_ae_real`，一致上界参数未使用。
- [当时导出错误](D:/Grad_Study/Practimum/Formalization/review_history_retro_20260901/research_framework/replication_20260913/runs/r2-m2-a/help/7199ffd4-6d75-4104-9445-b99ab512731c/after-export.stderr.bin)：提交说明及两个角色输出文件不能读取，导致归档命令非零退出。
- [负责复制和导出的程序](D:/Grad_Study/Practimum/Formalization/review_history_retro_20260901/research_framework/replication_20260913/runtime/runtime_a/helper_dispatcher.py:103)：从调用者容器导出工作区，再恢复到助手卷；第378行起的补丁逻辑排除任务包区域。
- [第三助手最终候选](r2-m2-a/9a2df7de-9c00-4dbc-b085-da4465c50c99/after/.__artifacts__phase2_prompt_packs__thm_11_7__draft.lean)：其完整字节散列与E152作者实际应用后的一致。
- [选定事件原件](INDEX.zh-CN.md)：E065证明教材原文实际返回；E085、E152、E154分别证明补丁返回、实际采用与作者构建。

输入快照里有任务书，不能单独证明助手读了这份文件；E065的返回则可以证明它读到了原始数学任务。两种信息强度分别使用。
