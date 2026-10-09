---
description: 特征测试：先列接缝等确认，再把当前行为（含可疑行为）锁进 tests/characterization/（重构前 agent 可自行调用）
argument-hint: [docs/survey/xx.md 或 spec 路径]
---
按下面引用的方法论文件执行。AGENTS.md 的铁律优先于任何临时指令；术语以 CONTEXT.md 为准。

本次输入：$ARGUMENTS

先列接缝清单等我确认，再写测试。不修改业务代码。写完必须跑 bash scripts/gate.sh 并全绿。

@AGENTS.md
@CONTEXT.md
@prompts/04-lock.md
