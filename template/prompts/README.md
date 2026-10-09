# prompts/ — agent 中立的方法论入口

这 9 个文件是方法论的**唯一真相源**。任何 AI coding agent 都能用：复制 Prompt 模板、替换方括号里的内容、粘贴。

| 编号 | 文件 | 阶段 | 产物 | 谁发起 |
|---|---|---|---|---|
| 00 | `00-triage.md` | issue 分流 | 类型判断 + 下一步 | 人 |
| 01 | `01-survey.md` | 架构梳理（只读） | `docs/survey/<模块>.md` | 人或 agent |
| 02 | `02-grill.md` | 追问（写 spec 前把人问清楚） | 裁决记录 + CONTEXT.md 待确认项 | 人 |
| 03 | `03-spec.md` | 生成 spec + 自检 | `spec/planned/<id>-<name>.md` | 人 |
| 04 | `04-lock.md` | 列接缝 → 特征测试 | `tests/characterization/` | 人或 agent |
| 05 | `05-tasks.md` | 任务拆解 | `spec/planned/<id>-<name>.tasks.md` | 人 |
| 06 | `06-feature.md` | 列接缝 → 新功能 TDD | 代码 + 测试 + 账本更新 | 人 |
| 07 | `07-refactor.md` | 小步重构 | 代码 + 账本更新 | 人 |
| 08 | `08-pr.md` | 提交与 PR | commit / PR 正文 | 人 |

"谁发起"借鉴 mattpocock/skills 的 user-invoked / model-invoked 分层：编排类阶段只由人敲命令；`survey` 和 `lock` 是纪律类，agent 碰到不熟或没锁住的遗留代码时可自行调用。

## 各 agent 的用法

- **Claude Code**：`.claude/commands/` 里有同名斜杠命令（`/triage` `/survey` `/grill` `/spec` `/lock` `/tasks` `/feature` `/refactor` `/pr`），命令只是薄包装，内容通过 `@prompts/xx.md` 引用这里的文件——改这里，命令自动生效。`.claude/skills/tdd-seams/` 是 agent 写测试时自动适用的纪律。
- **Codex / Cursor / 其他**：会自动读 `AGENTS.md`；具体阶段把对应文件的 Prompt 模板粘进对话。
- **人**：每个文件末尾的"人审要点"是你的检查清单。

## 典型路径

```
新功能：  00 → 02 → 03 → (人审) → 05 → 06 → 08 → (人移 spec 到 implemented)
遗留重构：00 → 01 → 02 → 03 → 04(全绿) → 05 → 07 → 08 → (人移 spec)
修 bug：  00 → (A 类直接) 写红回归测试 → 修 → 08
小改动：  00 → 03（跳过 02）→ 05 → 06 → 08
```
