---
description: 任务拆解：把已审 spec 拆成落盘的任务账本 *.tasks.md
argument-hint: [spec/planned/xx.md]
disable-model-invocation: true
---
按下面引用的方法论文件执行（spec-ledger 插件）。项目里若有 prompts/ 同名文件，以项目文件为准。AGENTS.md 的铁律优先于任何临时指令；术语以 CONTEXT.md 为准。

本次输入：$ARGUMENTS

先读 spec/TASKS_TEMPLATE.md。只生成账本，不开始实现。

@AGENTS.md
@CONTEXT.md
@${CLAUDE_PLUGIN_ROOT}/prompts/05-tasks.md
