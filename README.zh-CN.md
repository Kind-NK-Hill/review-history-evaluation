# 概率证明如何完成

**对 ProbabilityTheoryFormalization 项目的评价研究**

Shuo Deng、Kenneth W. Shum · 技术报告 · 2026年9月

[中文正文](report-v30/zh.pdf) · [英文正文](report-v30/en.pdf) · [中文附录](report-v30/zh-appendix.pdf) · [英文附录](report-v30/en-appendix.pdf) · [English](README.md)

智能体完成了局部证明，成果却可能没有送达需要它的作者；代码能够编译，定理也可能只覆盖题目的一部分。本研究检查：**实际证明了什么、完成判断依据是什么，以及中间成果有没有进入最终证明。**

**当前报告：第30版／公开 v0.7.0。** [完整阅读包](https://github.com/Kind-NK-Hill/review-history-evaluation/releases/tag/v0.7.0) · [本版变化与证据](report-v30/README.md)

## 评价了什么

十一组概率任务、三种工作配置、两批共 **66次选定主运行**。A 为规定流程，B 为可读取参考资料并请求协助的作者，C 为指挥作者与检查服务的协调者。

研究结合数学完成判断、同题耗时比较、源码检查和执行轨迹。66次运行不是66个独立数学任务；两批的任务说明和执行安排有变化，每种配置也同时包含多个差异。

## 值得查看的发现

- **完成判断需要同时检查已有数学成果和任务范围。** H1 的历史组件配合新写的连接代码，改变了先前对缺失数学工作的解释。L6 的调用检查支持历史组件可组合，但任务书又同时包含较宽噪声要求与高斯实例化要求。保存的11/11判断不能视作按较宽读法重新认证全部交付。[H1/L6代码与编译回执](report-v30/README.md#start-with-the-evidence)
- **已经证明，不代表完成交接。** M2 的协作者证明了原目标，却未能交付；后一个协作者的输入没有包含该证明，重新构造时又缩窄了目标，之后才有另一位协作者提供最终采用的证明。输入快照、源码和导出错误分别支持这些阶段的判断。[M2证据与运行规则](report-v30/verification/revision30/README.md)
- **平均耗时差异需要回到具体任务解释。** 同题比较和移除任务的敏感性分析显示，总体差异会受到具体任务影响；反馈到修订的过程分析进一步解释时间花在了哪些数学变化上。现有证据不支持把优势单独归因于某一机制。[补充比较的复算入口](report-v30/README.md#recompute-and-read-offline)

第二批过程研究包含33次主运行的4,054次实际工具调用和179次工具发现。每次运行从两个固定起点形成记录，共66条。这些记录与前面的66次主运行是不同单位，部分过程重叠，不能合并成全体失败恢复率。

## 阅读与核查入口

| 想了解什么 | 从哪里开始 |
|---|---|
| 结论、案例和完整论证 | [当前报告及四份PDF](report-v30/README.md) |
| 反馈怎样进入证明修订 | [分布函数表示适配的逐步记录](report-v28/examples/r2-m3-b.zh-CN.md) |
| 成果、耗时与过程如何定义 | [66项保存判断](report-v28/evaluation/assessment.json)、[共同标准](report-v28/evaluation/policy.json)、[过程协议](report-v28/process/protocol.zh-CN.md) |
| 记录选择与复核范围 | [66条标注](report-v28/process/semantic/adjudicated_annotations.json)、[复核覆盖说明](report-v28/process/semantic/summary_provenance.json) |
| 系统如何运行 | [工程仓库与完整流程演示](https://github.com/Kind-NK-Hill/ProbabilityTheoryFormalization) |

## 复算

需要 Python 3.11及以上，核心分析只使用标准库：

```text
python verify_release.py
python report-v30/recompute_followup.py
python report-v28/reproduce.py --output recomputed
```

上述命令核对包内文件并从冻结输入复算结果，不新增语义判断、不调用模型，也不重跑 Lean。H1/L6 的数学检查以文档所述环境中的保存回执提供；完整复算范围及离线证据准备见[说明](report-v30/README.md#recompute-and-read-offline)。

## 贡献与版本

Shuo Deng 的工作包括提出要求、协调人工智能辅助执行、审阅结果、质疑解释和要求纠正；人工智能工具协助代码、证明生成、分析和写作。Kenneth W. Shum 是教材作者及报告合作者。报告区分实际产物、模型辅助判断与独立人工验证。

工程系统与评价研究是同一研究背景下的两个部分。研究引用的工程公开版本为 `d07f272850899b58612adf1c7dc202538503252f`，历史实验保留各自版本身份。

第28版的[报告勘误](report-v28/ERRATA.md)和[原始复算](report-v28/REPRODUCIBILITY.md)继续保留，其数据仍供第30版使用。更早的 [v0.5.0研究](releases/v0.5.0/README.md)也完整保留。[发布历史](CHANGELOG.md) · [相关方法](report-v28/RELATED_WORK.md)
