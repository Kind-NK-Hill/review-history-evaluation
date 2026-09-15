# 启动前工具信息卡：探测样本

探测时间：2026-09-14T11:49:05.583280+00:00。镜像：`sha256:bf8ecae88af17ff13c736eb7b1f374170f608895a8eea0058be0183bf00e088c`。用户：`1001:1001`；命令解释器：`bash --noprofile --norc`。

这是新建、无网络、只读且无挂载容器的镜像探测结果。它没有包含某项历史运行的工作区或环境覆盖；用于正式新会话时须在其实际环境刷新此卡。

## 可用入口

- `lake`（`/opt/lean/bin/lake`）
- `lean`（`/opt/lean/bin/lean`）
- `python3`（`/usr/bin/python3`）
- `perl`（`/usr/bin/perl`）
- `git`（`/usr/bin/git`）
- `sed`（`/usr/bin/sed`）
- `tee`（`/usr/bin/tee`）

当前PATH未找到：`apply_patch`、`patch`、`jq`、`python`、`file`、`xxd`、`node`、`ruby`、`sqlite3`。

`apply_patch`和`patch`不可作为该shell里的命令使用。`python`名称未找到，但`python3`可用。选择现有工具时仍须使用该工具支持的输入语法。

镜像默认PATH包含`/opt/lean/bin`，所以`lake`和`lean`可以直接找到。受控移除该目录后，两个名称均找不到；明确路径`/opt/lean/bin/lake`和`/opt/lean/bin/lean`仍为可执行文件。改变PATH或用户后要重新探测，不能把名称查找失败写成软件未安装。

## 调用参数

- `container_exec`：必填字符串`command`，最多100000个字符；可选数值`timeout_seconds`在0.1至600秒之间，省略时为600。仅接受这两个字段。
- `read_artifact`：必填字符串`artifact_id`；可选整数`start_line`至少1、`max_lines`在1至1000之间。更多内容应由调用者分次读取。
- 参数预检给出错误字段和原因，不执行、改写或截断命令，也不替调用者调整时间或阅读范围。其他工具返回“未覆盖”，不冒称已经校验。

证据：[容器探测](environment_probe/receipt.json) · [原始输出](environment_probe/stdout.tsv) · [参数规则实现](parameter_preflight.py)。
