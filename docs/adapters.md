# 各 agent 怎么接

方法论的唯一真相源是 `prompts/00…07.md` 和 `AGENTS.md`。各 agent 只是不同的"入口"。

## Claude Code

安装后即可用，无需配置：

| 命令 | 作用 |
|---|---|
| `/triage <issue>` | 分流 |
| `/survey <路径>` | 只读梳理 → `docs/survey/` |
| `/spec <需求>` | 生成 spec + 自检 |
| `/lock <梳理结果或 spec>` | 特征测试 |
| `/tasks <spec 路径>` | 任务账本 |
| `/feature <spec 路径>` | TDD 实现 |
| `/refactor <目标 + 任务号>` | 小步重构 |
| `/pr <issue 号>` | 提交与 PR |

- 命令文件在 `.claude/commands/`，内容只有几行，通过 `@AGENTS.md` 和 `@prompts/xx.md` 把方法论文件引入上下文。改 `prompts/`，命令自动生效。
- `.claude/skills/spec-ledger/SKILL.md` 让 Claude Code 在收到"改代码"类请求时自动判断该走哪一步，并在该停的地方停下来问人。
- 建议搭配 Claude Code 的 plan mode 做 `/spec` 之前的探索；`/tasks` 产出的账本比会话内 TaskList 可靠——它落盘。
- 可选硬化：在 `.claude/settings.json` 加一个 `PreToolUse` hook 拦截 `git commit` 时跑 `scripts/gate.sh`。通常不需要，因为 pre-commit hook 已经覆盖了所有 agent。

## Codex

- Codex 自动读 `AGENTS.md`。
- 在 Codex 的 instructions 里加：

```
Always read and follow AGENTS.md before writing any code.
Always read the relevant spec in spec/ and its *.tasks.md before implementing.
Never modify files in spec/governance/ or AGENTS.md; never move spec files between status folders.
Run `bash scripts/gate.sh` before every commit.
```

- 具体阶段把 `prompts/xx.md` 里的 Prompt 模板粘进任务描述。
- setup commands 里安装门禁工具：`pip install ruff pytest` 或 `npm install --save-dev eslint jest`。

## Cursor

- Cursor 读 `AGENTS.md`（新版）或 `.cursor/rules/`。如果你的版本不读 AGENTS.md，建一个 `.cursor/rules/spec-ledger.mdc`，内容就是一行：`按 AGENTS.md 和 prompts/ 下的方法论工作。`
- 阶段 prompt 同样粘贴。

## 其他 agent / 纯对话（ChatGPT、Claude.ai、Gemini……）

把 `AGENTS.md` 全文 + 对应阶段的 `prompts/xx.md` 一起贴进对话即可。方法论不依赖任何 agent 特性。

## 人

每个 `prompts/xx.md` 末尾的"人审要点"是你的检查清单。`docs/methodology.md` 第五节"人的角色清单"建议贴在看得见的地方。
