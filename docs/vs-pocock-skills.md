# spec-ledger vs mattpocock/skills

[mattpocock/skills](https://github.com/mattpocock/skills) 是 25 个极小的、可单独安装的 agent skill（每个 `SKILL.md` 75–600 字），作者明确反对 GSD / BMAD / spec-kit 这类"接管流程"的框架。它和 spec-ledger 站在同一边——文件归你所有、可编辑、agent 中立——但切法不同。

打比方：Pocock 的 skills 是**单方**，每味药只管一件事，自己配；spec-ledger 是**临床路径**，规定先做什么检查、什么指标达标才能进下一步。两者正交：Pocock 补的是**对话和词汇**这一层，spec-ledger 强的是**闸门和账本**这一层。

## 机制对照

| 维度 | mattpocock/skills | spec-ledger |
|---|---|---|
| 形态 | 25 个独立 skill，可单独装、单独改 | 9 个阶段 + 账本 + 门禁，一体安装 |
| 流程控制 | 不控：用户自己串，`implement` 只说"用 tdd、跑测试、code-review、提交" | 控：没 spec 不写码、没特征测试不重构、状态只有人动 |
| spec 存哪 | 发到 issue tracker（GitHub / Linear），打 `ready-for-agent` 标签 | 仓库里 `spec/` 目录账本 |
| 任务拆解 | `to-tickets` 拆成 issue | `*.tasks.md` 落盘 |
| 澄清需求 | `grilling`：agent 反过来连环追问 | v0.2 借入为 `/grill`，放在 `/spec` 之前；`/spec` 自检保留在后 |
| 领域语义 | `CONTEXT.md` 共享词汇表，`grill-with-docs` 维护 | v0.2 借入 `CONTEXT.md`，并加"待确认区 → 人裁决 → 正式表"的流转（R6） |
| 测试 | seams 接缝：先列、人确认、再写；反 mock 内部、反同义反复、反横切 | v0.2 借入为 R8 + `tdd-seams` skill，叠加在特征测试之上 |
| 触发方式 | user-invoked / model-invoked 分层 | v0.2 借入：编排类命令 `disable-model-invocation`，`/survey` `/lock` 可由 agent 自行调用 |
| 遗留代码 | 无特征测试、无"先锁后动" | 核心优势 |
| 硬门禁 | 无 | pre-commit + CI 共用 `gate.sh` |
| 架构决策 | ADR 文件 | `spec/governance/` |
| 语言 | 英文 | 中文 |

## 借了什么、没借什么

**借了四样**（v0.2）：grill 追问、CONTEXT.md 词汇表、seams 接缝、invocation 分层。

**没借**：spec 发到 issue tracker（会拆散账本）；"不控流程"的立场（对遗留系统不安全）；与企业遗留系统无关的 skill（`wizard` `teach` `wait-what` 等）。

## 什么时候直接用它

你的项目是 greenfield、用 Linear/GitHub Issues 管需求、团队已有成熟 code review 文化——直接装 mattpocock/skills 可能更轻。你的项目是跑了多年的业务系统、术语在老员工脑子里、没人敢动老代码——用 spec-ledger，并把它的 grill 和 CONTEXT.md 当作已内置的部分。
