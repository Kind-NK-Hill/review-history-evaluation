# 基线、源码与链接核对

本文件是本轮只读交付核对，不是历史实验结果，也没有执行跨阅读器点击测试。

## 身份与可编辑源码

两份用户基线与本地 `combined_revision_v11_20260912/output/pdf/` 文件均逐字节相同；正文 27 页、附录 57 页。其 SHA-256 见 [原校验值](BASELINE_SHA256SUMS.txt)，完整结构结果见 [PDF_STRUCTURE_CHECK.json](PDF_STRUCTURE_CHECK.json)。PDF 字节身份不依赖文件名、标题或日期推测。

本地两份英文 Markdown 的哈希与导入第 11 版时的原记录一致。本轮在内存中运行已复制的转换函数，用原工作根解释相对链接，逐字符比较返回正文与已有 `qa/pdf/en/main.tex`、`qa/pdf/en-appendix/main.tex` 的正文：均一致（采用 Python 通用换行读取规则；原始字节哈希另列）。26 组显示公式（7+19）仍在对应源稿与 TeX 中。已有 BUILD.json 的返回码为 0，记录页数与精确 PDF 相符。没有执行构建引擎或生成新 PDF。

因此找到了对应源稿、当次实际转换器、生成 TeX、字体声明、构建日志与原输出，而非从 PDF 反推新稿。构建记录未保存 Python/Tectonic 的完整版本清单；这部分保留未知。

## 跨文件链接结构

数量按 PDF 注释对象计算，同一文字换行可产生多个对象，不能当作不同语义链接数。正文 113 个 `/GoToR`，附录 10 个，合计 123 个。其中 121 个指定命名目的地，2 个使用 `[0 /Fit]` 打开另一文件首页。

- **121 个命名链接均存在相同结构问题**：`/D` 实际保存 `nameddest=名字`，而目标文件定义的是 `名字`。原字符串目的地不存在，去掉此前缀后对应目的地全部存在。正文 112 个、附录 9 个。
- **2 个首页链接没有上述问题**：均有目标文件和有效的第 0 页数组。不能把所有跨文件链接一概说成失效。
- 附录另有 3 个 `/URI` 注释对象，实际是 2 个本地来源指南（页 21 的链接分成两段）。两个原本地文件实际都存在；限制是地址只适用于原电脑，不是原文件缺失。本包已包含实际指南及其已有补充包。

| 基线位置及文字 | 原始动作与目标 | 目标核对 | 对应可编辑来源 |
|---|---|---|---|
| 正文 §2.2，页 8，Appendix N.6 | `/S /GoToR`；`/F en-appendix.pdf`；`/D (nameddest=n6)` | 文件存在；`n6` 存在，`nameddest=n6` 不存在 | `manuscript/report.en.md:174,182` |
| 正文 §3.4，页 12，Appendix N.5 | `/S /GoToR`；`/F en-appendix.pdf`；`/D (nameddest=n5)` | 文件存在；`n5` 存在，带前缀名称不存在 | `manuscript/report.en.md:280,282` |
| 附录 G.10，页 26，Section 3.1 | `/S /GoToR`；`/F en.pdf`；`/D (nameddest=section-3-1)` | 文件存在；`section-3-1` 存在，带前缀名称不存在 | `manuscript/appendix.en.md:877` |
| 附录 E.2，页 19，source guide | `/S /URI`；`file:///D:/Grad_Study/Practimum/Formalization/reports/trajectory_analysis/team_review_v031_trajectory_v3_20260911/combined_revision_v11_20260912/evidence/README.md` | 原文件存在；包内人工入口 `manuscript/evidence/README.md` | `manuscript/appendix.en.md:651` |
| 附录 E.3，页 21，the documentation source guide | `/S /URI`；同一原根下 `evidence/project_docs/README.md` | 原文件存在；包内人工入口 `manuscript/evidence/project_docs/README.md` | `manuscript/appendix.en.md:694` |

两类链接的生成位置均在 `manuscript/qa/pdf/build_pdf.py` 的 `href()`：第 61 行把跨 PDF URL 写为 `文件.pdf#nameddest=锚点`；第 65 行把证据相对路径转换为本机 `file:` URI。对应生成 TeX 也保留在 `manuscript/qa/pdf/`。本轮没有改这些源稿、脚本或 PDF。

网页端观察到的 `#nameddest=nameddest%3Dn6` 与原 PDF 动作相容：原始 `/D` 已带一层 `nameddest=`，阅读器再用命名目标 URL 表示它时会再加一层。这是对既有结构的解释，不是声称本轮在各阅读器点过链接。原上传名带 `(2)` 不是本轮认定问题的依据；两份交付文件的正确相邻命名仍是 `en.pdf` 和 `en-appendix.pdf`。

## 交付说明的时点

附录 F.2 页 22（`appendix.en.md:724–728`）确实仍称只更新英文 Markdown，不声明已检查 PDF；`manuscript/README.md` 也保留这一早期包说明。之后已有实际构建日志、BUILD.json 和 ENGLISH_CHECK.json，且其输出就是本轮精确基线。因此它是未同步后续 PDF 交付状态的说明，不能据此断言 PDF 从未生成或没有任何检查。现有检查记录不等于所有阅读器点击都已验证，也不支持双语同步声明。

## 来源交付边界

第 11 版既有 `evidence/` 99 个文件全部逐字节复制，保留补充包命名空间和原摘录说明。正文 [30]–[33] 可回到实际随附的 A/B/C/D/E/AP/AX 材料；[34]–[36] 可回到固定公共提交 `d07f272850899b58612adf1c7dc202538503252f` 的七份摘录、原链接与身份清单。没有下载当前仓库来替代它们。

新增的定向原件和上下文摘录位于 `verification/supporting_records/`，由 L1_MAP、H1_MAP、CANDIDATE_DELIVERY_INDEX、L2_SERVICE_AUDIT 与 LOCATOR_MAP 连接。普通文字中的本地路径、旧完整档案入口和摘录内引用原仓库的相对链接仍可能外指；它们是原记录定位线索，不算本包已提供了完整私人档案，也没有被误报成点击失败。两份基线不作修改，离线阅读应从 START_HERE 与这些相对入口进入。
