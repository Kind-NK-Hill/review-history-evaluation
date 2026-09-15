# 启动前工具信息与参数预检原型

已完成一个研究目录内的有界原型：从隔离镜像实测生成工具信息卡，并对原记录中的工具参数作静态预检。原运行器、原始实验、生产系统和数学验收标准均未修改。

## 已验证的结果

1. **环境实测。** 新建容器`research-preflight-20260914-d777a9f1`使用冻结镜像，无网络、只读、无挂载，以原工具执行用户1001探测。容器已正常退出并保留，完整ID为`a952504ed8cf877444804ed8935b41fdd64668e70d0db434bb44c5c8285c09b8`。未执行旧日志命令、Lean或模型。
2. **信息卡反映入口差异。** `apply_patch`、`patch`等名称未找到，`python3`、`git`、`perl`、`sed`、`tee`可用。默认镜像PATH中的`lake`可用；受控去掉`/opt/lean/bin`后名称查找失败，但明确路径仍可执行。这一对照验证卡片能区分入口问题和安装状态，不将受控PATH冒充历史容器设置。
3. **参数静态回放。** 对两个相关工具的全部3896次参数，原型拒绝9次既有错误，接受3887次既有有效参数。与原桥接器中提取的纯校验条件逐项对照，未发现差异或误拒绝。这里的有效只指参数条件，包含后来执行失败的合法请求。
4. **边界验证。** 另有29个合成边界用例通过，涉及长度、数值上下限、类型、额外字段和原桥接器数值转换行为。合成用例不计入实际研究样本。

九条拒绝分别是：4条阅读行数超限，3条执行参数超范围，1条额外字段，1条超时值不能转为数值。[逐项拒绝说明](argument_replay/rejection_explanations.zh-CN.md)保留事件ID和具体原因。

## 产物与使用

- [启动前工具信息卡](startup_tool_card.zh-CN.md)：可以阅读、核对的卡片样本。正式接入应在每个实际环境重新生成。
- [参数校验器](parameter_preflight.py)：纯函数`validate(tool, arguments)`；只返回接受状态、错误字段和原因，不执行或改写输入。也可从标准输入读取`{"tool": ..., "arguments": ...}`形式的JSON请求。
- [全部回放结果](argument_replay/summary.json)与[有效对照](argument_replay/valid_controls.json)：覆盖container_exec和read_artifact，其他工具明确标为未覆盖。
- [环境探测凭据](environment_probe/receipt.json)与[容器检查结果](environment_probe/container_inspect.json)：记录固定镜像、隔离设置和保留容器。
- [后续代理对照方案](followup_control_protocol.zh-CN.md)：只增加环境信息卡，保持起点、额度和验收标准；尚未启动。

本次证明了原型能描述所探测环境，并能在现有输入上提前识别九次实际拒绝事件。它没有证明代理会遵循卡片、减少错误或节省运行时间；这些效果由后续真实对照检验。

复跑参数回放使用`validate_replay.py`；边界验证使用`test_parameter_boundaries.py`。`probe_environment.py`在已有凭据时直接返回该凭据，不重复创建容器。源码、输出与规则来源摘要见[交付清单](MANIFEST.json)。
