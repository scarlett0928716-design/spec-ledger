# Changelog

## v0.1.0 — 2026-10-08

首个公开版本。从 hrp-asset-inventory 项目里实际跑过的 AGENTS.md + spec/ + prompts/ 抽象而来，并吸收了 GitHub spec-kit 的三个机制：

- 新增 **任务账本** `*.tasks.md`：spec 拆成 commit 粒度任务后落盘，换会话/换 agent 从账本继续（对应 spec-kit 的 tasks.md）
- 新增 **spec 自检**：生成 spec 后强制列出含糊点 / 内部矛盾 / 不可测条目 / 领域假设，写进 spec 第 9 节（对应 spec-kit 的 clarify / analyze）
- 新增 **Claude Code 斜杠命令**：8 个薄包装命令通过 `@prompts/xx.md` 引用方法论文件，内容单一来源（对应 spec-kit 的 /speckit-* 命令）
- 新增 **硬门禁**：`scripts/gate.sh` 被 pre-commit hook 和 CI 共用，本地与 CI 永远一致
- 新增 governance R6（业务语义由人裁决）、R7（账本是唯一真相）
- 保留并强调 spec-kit 没有的两条：**特征测试先锁后动**、**spec 状态只有人能动**
