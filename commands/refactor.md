---
description: 小步安全重构：特征测试全绿前提下一次一个职责块
argument-hint: [重构目标 + 账本任务号]
disable-model-invocation: true
---
按下面引用的方法论文件执行（spec-ledger 插件）。项目里若有 prompts/ 同名文件，以项目文件为准。AGENTS.md 的铁律优先于任何临时指令；术语以 CONTEXT.md 为准。

本次输入：$ARGUMENTS

先确认 tests/characterization/ 全绿（跑 bash scripts/gate.sh），再给本步计划，等确认后才改代码。

@AGENTS.md
@CONTEXT.md
@${CLAUDE_PLUGIN_ROOT}/prompts/07-refactor.md
