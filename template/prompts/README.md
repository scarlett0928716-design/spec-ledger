# prompts/ — agent 中立的方法论入口

这 8 个文件是方法论的**唯一真相源**。任何 AI coding agent 都能用：复制 Prompt 模板、替换方括号里的内容、粘贴。

| 编号 | 文件 | 阶段 | 产物 |
|---|---|---|---|
| 00 | `00-triage.md` | issue 分流 | 类型判断 + 下一步 |
| 01 | `01-survey.md` | 架构梳理（只读） | `docs/survey/<模块>.md` |
| 02 | `02-spec.md` | 生成 spec + 自检 | `spec/planned/<id>-<name>.md` |
| 03 | `03-lock.md` | 特征测试 | `tests/characterization/` |
| 04 | `04-tasks.md` | 任务拆解 | `spec/planned/<id>-<name>.tasks.md` |
| 05 | `05-feature.md` | 新功能 TDD | 代码 + 测试 + 账本更新 |
| 06 | `06-refactor.md` | 小步重构 | 代码 + 账本更新 |
| 07 | `07-pr.md` | 提交与 PR | commit / PR 正文 |

## 各 agent 的用法

- **Claude Code**：`.claude/commands/` 里有同名斜杠命令（`/triage` `/survey` `/spec` `/lock` `/tasks` `/feature` `/refactor` `/pr`），命令只是薄包装，内容通过 `@prompts/xx.md` 引用这里的文件——改这里，命令自动生效。
- **Codex / Cursor / 其他**：会自动读 `AGENTS.md`；具体阶段把对应文件的 Prompt 模板粘进对话。
- **人**：每个文件末尾的"人审要点"是你的检查清单。

## 典型路径

```
新功能：  00 → 02 → (人审) → 04 → 05 → 07 → (人移 spec 到 implemented)
遗留重构：00 → 01 → 02 → 03(全绿) → 04 → 06 → 07 → (人移 spec)
修 bug：  00 → (A 类直接) 写红回归测试 → 修 → 07
```
