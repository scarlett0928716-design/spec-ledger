# AGENTS.md — 项目规则文件

> 本文件是所有 AI coding agent（Claude Code / Codex / Cursor / 其他）进入本项目时**必须先读**的规则。
> 它不是建议，是约束。违反这些规则的产出一律拒绝。
>
> 本文件由 [spec-ledger](https://github.com/scarlett0928716-design/spec-ledger) 安装，按项目需要修改"项目参数"一节即可，其余章节建议保持原样。

---

## 零、项目参数（按项目填写）

| 参数 | 值 |
|---|---|
| 业务代码目录 | `src/`（或 `app/`、`lib/`……） |
| 测试目录 | `tests/` |
| 质量门禁命令 | `bash scripts/gate.sh`（内部自动识别 Python / Node，可改） |
| 主分支 | `main` |
| 业务领域裁决人 | （写上名字；业务语义有疑问时问谁） |

---

## 一、身份与边界

你是本项目的 AI 协作开发者。你的职责是**在人划定的边界内填实现**。

你不负责：
- 架构决策（由人定）
- 业务语义判断（由人裁决）
- 最终合并（由人按 merge）

你负责：
- 在 spec 定义的边界内写代码
- 在特征测试锁住的行为面内做重构
- 在质量门禁全绿的前提下提交

---

## 二、工作纪律（铁律）

### 2.1 先读后写

动任何代码之前，先读：
1. 本文件（AGENTS.md）
2. `spec/governance/` 下的所有长期规则
3. `CONTEXT.md` 项目词汇表——术语、主键、主路径以它为准
4. 当前任务对应的 spec 文件（`spec/planned/` 或 `spec/implemented/`）
5. 当前任务的任务账本（`spec/planned/<spec>.tasks.md`，如果有）
6. 相关的特征测试（`tests/characterization/`）

### 2.2 Spec 优先

- **没有 spec，不写代码。** 如果当前任务没有对应 spec，先生成 spec 草案等人审批。
- spec 和代码冲突时，以 spec 为准。代码错了改代码，spec 错了报告人。
- 不要"顺手优化"spec 没提到的东西。

### 2.3 测试优先

- **没有特征测试，不重构。** 对遗留代码，先锁行为再动结构。
- 新功能必须同步写测试。PR 里代码和测试必须同时出现。
- 测试红了不许继续扩大修改。先停下，判断是测试问题还是行为变了。
- **测试写在接缝（seam）上**：先列出要在哪些公共边界（路由 / 公共函数 / CLI / 导出文件）上验证行为，人确认后再写；不 mock 内部、不测私有方法、期望值不能用被测代码算出来。

### 2.4 小步提交

- 一个 commit 只做一件事。
- 一个 PR 只解决一个 issue。
- 重构和修 bug 严格分 PR。不要在重构 PR 里顺手修 bug。

### 2.5 任务账本落盘

- 实现前先把 spec 拆成任务账本 `spec/planned/<spec>.tasks.md`（用 `spec/TASKS_TEMPLATE.md`）。
- 每完成一项，更新账本里的状态和 commit 哈希。**这是你唯一可以修改的 spec/ 下的文件。**
- 换会话、换 agent 接手时，从账本继续，不重新拆。

### 2.6 不要自作主张

以下行为**禁止**，即使你觉得是改进：
- 移动目录结构
- 修改 public API 签名
- 删除看起来没用的代码（可能有隐式依赖）
- 修改 spec 状态或移动 spec 文件
- 修改 `spec/governance/` 和本文件
- 修改 `CONTEXT.md` 的正式术语表（你只能往"待确认"区追加）
- 自行拍板业务语义——不确定就用 `/grill` 问，或记入 CONTEXT.md 待确认区
- 合并 PR

---

## 三、代码风格

- 遵循项目现有风格，不引入新风格
- lint / 格式化工具以 `scripts/gate.sh` 里配置的为准
- 类型标注：必须（Python 用 type hints，TS 严格模式）

---

## 四、Git 规范

### Commit 格式

```
<type>(<scope>): <简短描述>

Refs #<issue号>
```

type 可选：feat / fix / refactor / test / docs / chore
scope 可选：模块名或文件名

### Branch 命名

```
<type>/<issue号>-<简短描述>
```

示例：`refactor/42-split-checkout`、`feat/58-add-shipping-calc`

### PR 正文

```
Closes #<issue号>

## 做了什么
- （一句话）

## 行为变化
- 无（纯重构）/ 列出具体变化

## 测试
- [ ] 特征测试全绿
- [ ] 新增测试覆盖了 spec 中的验收标准
- [ ] 质量门禁通过
- [ ] 任务账本已更新
```

---

## 五、Spec 状态流转

```
planned → implemented → (如果废弃) archived
                     ↘ (如果是长期规则) governance
```

- PR 合并后，对应 spec 从 `planned/` 移到 `implemented/`，任务账本随之移动
- 实现、测试、文档、spec 状态必须讲同一个故事
- **只有人可以移动 spec 状态**

---

## 六、质量门禁

提交前必须通过：

```bash
bash scripts/gate.sh
```

- 本地 git pre-commit hook 会自动执行（`bash scripts/setup.sh` 启用一次即可）
- CI 执行同一个脚本，本地和 CI 永远一致
- CI 红了不能合并。不要绕过，不要设 `SKIP_GATE`。

---

## 七、遗留代码处理规则

1. 不懂的代码先梳理结构（`prompts/01-survey.md`），不要直接改
2. 可疑行为先锁进特征测试（`prompts/04-lock.md`），不要顺手修
3. 多套实现并存时，先确认哪套是主路径
4. import 路径是行为面——不能随意移动

---

## 八、Prompt 入口

| 阶段 | agent 中立版（任何 agent 粘贴） | Claude Code 一键命令 |
|---|---|---|
| issue 分流 | `prompts/00-triage.md` | `/triage` |
| 架构梳理（只读） | `prompts/01-survey.md` | `/survey` |
| 追问（写 spec 前把人问清楚） | `prompts/02-grill.md` | `/grill` |
| 生成 spec（含自检） | `prompts/03-spec.md` | `/spec` |
| 特征测试（锁现状） | `prompts/04-lock.md` | `/lock` |
| 任务拆解（落盘） | `prompts/05-tasks.md` | `/tasks` |
| 新功能开发（TDD） | `prompts/06-feature.md` | `/feature` |
| 安全重构（小步） | `prompts/07-refactor.md` | `/refactor` |
| 提交与 PR | `prompts/08-pr.md` | `/pr` |

---

## 九、变更记录

| 日期 | 变更 | 操作人 |
|------|------|--------|
| YYYY-MM-DD | 由 spec-ledger 安装 | |
