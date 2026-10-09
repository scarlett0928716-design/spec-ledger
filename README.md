# spec-ledger

**面向遗留系统的 Spec 驱动开发工具包：人画边界，AI 填实现；行为先锁后动；状态只有人能动。**

一套可以复制进任何项目的目录骨架 + 9 个阶段 prompt + 词汇表 + 硬门禁。agent 中立（Claude Code / Codex / Cursor 都能用），零运行时依赖，纯 markdown + 两个 shell 脚本。

```
bash install.sh ~/Code/your-project
cd ~/Code/your-project && bash scripts/setup.sh
```

---

## 为什么不用 spec-kit 就够了

[GitHub spec-kit](https://github.com/github/spec-kit) 是优秀的 Spec-Driven Development 脚手架，但它假设你在**从 spec 生成新代码**。企业里更多的情况是：代码已经跑了五年、没人敢动、业务语义只在老员工脑子里。spec-ledger 为这种场景补了三件 spec-kit 没有的东西：

| | spec-kit | spec-ledger |
|---|---|---|
| 动遗留代码之前 | （无） | **先梳理、再锁特征测试、全绿才许动** |
| spec 的状态谁能改 | agent 流程推进 | **只有人**（planned → implemented 是人工动作） |
| 业务语义有疑问 | agent 自行推断 | **`/grill` 先问人；术语落盘在 `CONTEXT.md`，只有人能定** |
| 任务拆解 | tasks.md 落盘 | `*.tasks.md` 落盘（借鉴） |
| spec 自检 | clarify / analyze | 第 9 节自检记录（借鉴） |
| 命令入口 | /speckit-* | /triage … /pr（借鉴，薄包装） |
| 测试写在哪 | （无约定） | **接缝（seam）：先列、人确认、再写**（借鉴 mattpocock/skills） |
| 门禁 | 由 agent 执行 | **git pre-commit + CI 共用一个脚本** |
| 依赖 | uv + specify-cli | 无 |
| 语言 | 英文 | 中文 |

详细对比见 [docs/vs-spec-kit.md](docs/vs-spec-kit.md)；与 mattpocock/skills 的对比见 [docs/vs-pocock-skills.md](docs/vs-pocock-skills.md)。

---

## 工作循环

```
需求 / issue
   │
   ▼
 00 triage ──── 分流：bug？新功能？API 变更？遗留代码？
   │
   ├──（遗留代码）──▶ 01 survey（只读梳理）──▶ 04 lock（列接缝 → 特征测试，全绿）──┐
   │                                                                          │
   ▼                                                                          ▼
 02 grill（AI 追问，人裁决）──▶ 03 spec（生成 + 自检）──▶ 人审 ──▶ 05 tasks（账本落盘）
                                     │                                        │
                                     ▼                                        ▼
                              CONTEXT.md 词汇表 ◀──── 06 feature（列接缝 → TDD）/ 07 refactor
                                                                              │
                                                                              ▼
                                                08 pr ──▶ 门禁 ──▶ 人 merge ──▶ 人移 spec 状态
```

每一步的输入、输出、人审要点都在 `template/prompts/` 里。

---

## 安装后项目里多了什么

```
your-project/
├── AGENTS.md                      ← 所有 agent 进门先读的铁律（第零节填项目参数）
├── CONTEXT.md                     ← 项目词汇表：术语 / 主键 / 主路径，只有人能定（R6）
├── spec/
│   ├── README.md                  ← 账本说明
│   ├── SPEC_TEMPLATE.md           ← spec 模板（含第 9 节自检记录）
│   ├── TASKS_TEMPLATE.md          ← 任务账本模板
│   ├── governance/coding-discipline.md   ← R1–R8 长期规则，AI 不得改
│   ├── planned/ implemented/ archived/
├── prompts/00-triage.md … 08-pr.md     ← 方法论唯一真相源，任何 agent 可粘贴
├── .claude/
│   ├── commands/{triage,survey,grill,spec,lock,tasks,feature,refactor,pr}.md   ← 薄包装，@引用 prompts/
│   ├── skills/spec-ledger/SKILL.md     ← 让 Claude Code 自动判断该走哪一步
│   └── skills/tdd-seams/SKILL.md       ← 写测试时自动适用的接缝纪律（model-invoked）
├── scripts/
│   ├── gate.sh                    ← 质量门禁（自动识别 Python / Node）
│   ├── setup.sh                   ← 一次性启用 pre-commit hook
│   └── git-hooks/pre-commit
├── tests/characterization/        ← 特征测试（锁现状）
├── tests/regression/              ← 回归测试（锁验收标准）
└── .github/workflows/gates.yml    ← CI 跑同一个 gate.sh
```

安装器默认**不覆盖已存在的文件**，可以安全接入已有项目。

---

## 四条铁律

1. **没有 spec，不写代码。** spec 和代码冲突时，以 spec 为准；spec 错了报告人。
2. **没有特征测试全绿，不重构。** 可疑行为也原样锁住，重构 PR 里不修 bug。
3. **账本是唯一真相。** 进度只记在 `*.tasks.md`；spec 状态只有人能动。
4. **业务语义只有人能定。** 术语、主键、主路径以 `CONTEXT.md` 为准；没有的，AI 用 `/grill` 问，不猜。

---

## 人的角色

AI 做体力活，人做裁决：

| 环节 | 人的动作 |
|---|---|
| 需求进来 | 判断 issue 类型，决定要不要先写 spec |
| 追问（grill） | 回答 AI 提出的问题；对它的默认假设说"对"或"不对"——这是最省力的裁决方式 |
| 词汇表 | 把 `CONTEXT.md` 待确认区的术语移入正式表，或打回 |
| Spec 审批 | 边界对不对、验收标准够不够、"不做什么"有没有漏、**自检记录里的待裁决项逐条裁决** |
| 接缝确认 | AI 列出要在哪些公共边界上测，你确认层级对不对 |
| 架构梳理审 | public API、隐式状态有没有遗漏 |
| 特征测试审 | 锁的是现状还是理想 |
| 重构审 | diff 是否只做了一件事 |
| PR 审 | commit 信息、测试覆盖、账本与 spec 对齐 |
| 按 merge | 最终决策权永远在人 |
| Spec 状态移动 | 只有人可以移动到 implemented / archived |

---

## 文档

- [docs/methodology.md](docs/methodology.md) — 完整操作手册：场景分流、红灯决策树、质量飞轮、常见翻车
- [docs/vs-spec-kit.md](docs/vs-spec-kit.md) — 与 GitHub spec-kit 的机制级对比
- [docs/vs-pocock-skills.md](docs/vs-pocock-skills.md) — 与 mattpocock/skills 的对比，以及借了什么
- [docs/adapters.md](docs/adapters.md) — Claude Code / Codex / Cursor 各自怎么接
- [examples/](examples/) — 一组填好的 spec + 任务账本 + 词汇表

## 致谢

方法论源自莫欣老师的 AI Coding 课程（第 16–18 课），在真实的企业资产盘点系统项目中跑通后整理成本工具包；任务账本、spec 自检、命令入口三个机制借鉴自 GitHub spec-kit；追问（grill）、CONTEXT.md 词汇表、接缝（seams）、user/model-invoked 分层四个机制借鉴自 mattpocock/skills。

## License

MIT
