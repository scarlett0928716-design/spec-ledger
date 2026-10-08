# Spec 状态账本

> 这个目录是项目的"账本"：每个功能从想法到落地到退役，状态只在这里记，而且**只有人能改状态**。

## 目录结构

```
spec/
├── README.md              ← 你正在看的这个文件
├── SPEC_TEMPLATE.md       ← 新 spec 的模板
├── TASKS_TEMPLATE.md      ← 任务账本模板（spec 拆成可勾选的任务）
├── governance/            ← 长期生效的规则（不会过期，AI 不得修改）
├── planned/               ← 已设计、未实现
│     ├── <id>-<name>.md         spec 本体
│     └── <id>-<name>.tasks.md   任务账本（AI 可更新状态列）
├── implemented/           ← 已实现，带代码锚点
└── archived/              ← 废弃或搁置
```

## 命名约定

`<id>-<简短名称>.md`，id 用项目前缀 + 三位数字，例如 `pd-003-移动盘点.md`、`inv-012-export.md`。
任务账本与 spec 同名，加 `.tasks` 后缀，两者永远同目录同步移动。

## 状态流转

```
新 issue 进来
    │
    ├─ 局部 bug，期望已清楚 → 最小修复 + 回归测试 + 同步文档（不需要新 spec）
    │
    ├─ 涉及新功能 → 写 planned spec → spec 自检 → 人审 → 拆任务账本 → 实现 → 人移到 implemented
    │
    ├─ 涉及 public API → 先对齐兼容策略 → 写 spec → 实现
    │
    ├─ 涉及架构边界 → 先画方案（不要让 AI 自己移目录）→ 写 spec
    │
    └─ 分不清影响面 → 按"影响设计"处理，先停下来问
```

## 核心铁律

**一个改动不算完，直到实现、测试、文档、spec 状态、任务账本讲的是同一个故事。**

## 完成标准

PR 合并时，检查以下对齐：
- [ ] 代码实现了 spec 中的验收标准
- [ ] 测试覆盖了 spec 中的行为面
- [ ] 任务账本所有任务为 ✅，每项有 commit 哈希
- [ ] spec 状态已从 `planned` 移到 `implemented`（人操作）
- [ ] spec 中的"实现锚点"已填写具体文件路径
- [ ] 如果有文档（README 等），已同步更新
