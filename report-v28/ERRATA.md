# Revision 28: corrections and reading notes

The four PDFs and four manuscript files are the frozen revision 28. This public companion corrects metadata and clarifies the following readings. It does not change task outcomes, elapsed time or the 66 semantic classifications.

## Review coverage

The former generated metadata described all 66 records as receiving a second-agent review. The preserved review division was **44 A/C records checked by another agent and 22 B records checked by the lead investigator**. All were nonblind. The public `process/semantic/summarize.py` and [generated provenance](process/semantic/summary_provenance.json) now state this division. It is not a human gold standard or an estimate of population annotation accuracy.

## Original process window and accepted delivery

The 4,054 service calls and 179 discovery calls in Section 5 cover the **33 original second-batch runs**. The event corpus does not include the separate engineering-recovery window. The outcome table uses the final accepted delivery, including the A-L3 continuation; its cumulative solving time includes that continuation.

Both selected A-L3 records cite `prob_7_6.lean`. For this publication, the file was read from the original main-run archive and recovery archive and compared with the included accepted source. **All three copies are byte-identical.** Thus the particular proof evidence cited by these two records survives into the recovered delivery. This does not establish identity of the complete task bundle or make the recovery window part of the event count. [Comparison and hashes](examples/a-l3-window-check.json) · [run and recovery index](evaluation/RUN_INDEX.csv).

## B-L6: unfinished generic trial, completed specialized proof

Section 5.3 and the corresponding Appendix S/T discussion should distinguish the early generic three-term square-integral trial from the final task-specific proof. The final code includes **both one-sensor and two-sensor quadratic mean-square-error proofs**. In particular, `twoSensorMSE_eq_quadratic` expands the three-term square and removes the cross integrals.

The early generic trial has no observed passing receipt. Its `no_resolution_observed` and `unknown` labels concern that selected trial and its unconfirmed adoption; they do not mean that the mathematical need in the final task remained unsolved. [Stepwise trial record](examples/r2-l6-b.zh-CN.md) · [final specialized source](process/final_sources/acceptance/r2-l6-b/technical/saved-sources/ProbabilityTheory/chapter_12/prob_12_5.lean). A future analysis of whether every mathematical need is eventually solved would require a consistent endpoint definition across the records.

## 中文说明

- **复核分工：**44条A/C记录由另一代理复核，22条B记录由主调查者复核，均非盲。公开版已同时纠正程序和生成的来源说明。
- **执行窗口：**第5章4,054次实际调用与179次工具发现统计的是33项原主运行；独立工程恢复未纳入该事件集合。最终成果表包含A-L3恢复后的交付和相应累计用时。两条A-L3过程记录引用的 `prob_7_6.lean` 在主运行、恢复和最终接纳三个版本中字节完全相同，相关采用证据保持连续。
- **B-L6终点：**最终单、双传感器专用证明均已存在，双传感器证明也完成三项平方展开。未知标签指早期通用试验是否通过、是否被原样采用，不能读成实际任务仍缺少这项数学证明。

## Public evidence scope

The original report's references were written for a private review package. This repository provides a curated public companion and an explicit [reproduction map](REPRODUCIBILITY.md). Archived local paths in preserved records identify their origins; they are not prerequisites for the published core-table commands. The two examples link directly to included events and final code. The original session files, all acceptance snapshots, and the full operational database are not redistributed here.
