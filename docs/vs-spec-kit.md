# spec-ledger vs GitHub spec-kit

两者不是对立理论，而是 Spec-Driven Development 的两种实现。spec-kit 像 ERP 里预置的标准单据流（节点固定、换哪家都一样）；spec-ledger 像在标准流程上做的行业二开——为"代码已经在跑、没人敢动、业务语义在人脑子里"的企业遗留系统补了几道闸。

## 机制对照

| 维度 | spec-kit | spec-ledger |
|---|---|---|
| 宪法层 | `/speckit-constitution` → `constitution.md` | `AGENTS.md` + `spec/governance/`（R1–R8）+ `CONTEXT.md` |
| 需求 → 设计 → 任务 | `specify → plan → tasks`，每 feature 独立编号目录 + 自动建分支 | `/spec`（生成 + 自检）→ 人审 → `/tasks`；spec 与账本同名同目录 |
| 执行与收敛 | `implement → converge` 循环到 "Converged" | `/feature` 或 `/refactor` 按账本逐任务；账本全 ✅ + 门禁全绿 = 收敛 |
| spec 自检 | 可选 clarify / checklist / 一致性分析 | 强制：spec 第 9 节自检记录（含糊点 / 矛盾 / 不可测 / 领域假设） |
| 遗留代码 | 不涉及 | **`/survey` 只读梳理 → `/lock` 特征测试全绿 → 才许重构** |
| 业务语义 | agent 推断 | **"领域假设"必须由裁决人确认（R6）** |
| 状态流转 | 目录 + 分支，流程推进 | `planned → implemented → archived`，**只有人能动** |
| 任务落盘 | `tasks.md` | `*.tasks.md`，状态列/commit 列是 spec/ 下 AI 唯一可改内容 |
| 约束硬度 | 命令序列 + 脚本 | `AGENTS.md` 软约束 + **git pre-commit / CI 共用 `gate.sh` 硬约束** |
| 跨 agent | `--integration` 生成各家命令文件 | `prompts/` 为唯一真相源；Claude Code 命令是 `@` 引用的薄包装；其他 agent 粘贴 |
| 前置评估 | `assess` 扩展（go / kill） | `/triage` 分流（更轻，不做可行性研究） |
| 工具依赖 | `uv` + `specify-cli` | 无（markdown + bash） |
| 语言 | 英文 | 中文 |

## 各自的真实优劣

**spec-kit 强在**：产物完整且标准（spec / plan / research / data-model / contracts / tasks），多人多 agent 协作一致，`converge` 把"做完了"变成可验证状态，`assess` 扩展补了"该不该做"。

**spec-kit 弱在**：仪式重（改一个字段也要走完全流程），为 greenfield 设计，不讲"先锁行为再动结构"，自动建分支和编号目录会与已有仓库结构打架，多一层 CLI 依赖要维护。

**spec-ledger 强在**：轻、零依赖、可安全接入已有仓库（安装器不覆盖）；对遗留代码有明确的"梳理 → 锁 → 动"闸门；业务语义和状态流转牢牢在人手里；门禁本地 CI 一致。

**spec-ledger 弱在**：没有 research / data-model / contracts 这种细分产物（spec 一个文件承担）；没有可行性评估阶段；多人协作时靠 git 和人审，没有 spec-kit 那种流程级的一致性检查。

## 什么时候选哪个

| 场景 | 建议 |
|---|---|
| 新项目、团队多人、多 agent 并行、需要可审计的完整产物 | spec-kit |
| 已有系统、遗留代码多、业务语义重（ERP / HRP / 医疗 / 金融）、一人或小团队 | spec-ledger |
| 两者都想要 | 用 spec-kit 做新模块，在 spec-ledger 的 `/survey → /lock` 闸门后面动老模块；AGENTS.md 和 constitution.md 内容可以互相引用 |
