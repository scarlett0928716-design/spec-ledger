---
name: spec-ledger
description: 本项目的开发纪律：spec 先行、特征测试锁行为、任务账本落盘、业务语义以 CONTEXT.md 为准、人控状态流转。任何涉及改代码、加功能、重构、修 bug 的请求都先走这里判断该用哪个阶段命令（/triage /survey /grill /spec /lock /tasks /feature /refactor /pr），没有 spec 不写代码，没有特征测试不重构，没有确认的接缝不写测试。
---

# spec-ledger 开发纪律

## 一句话

**人画边界，AI 填实现；行为先锁后动；状态只有人能动。**

## 收到任何改代码的请求时

1. 先读 `AGENTS.md`（铁律）、`CONTEXT.md`（词汇表）、`spec/README.md`（账本结构）。
2. 判断请求处在哪个阶段，用对应命令，不要跳步：

| 请求长什么样 | 该走的阶段 | 命令 |
|---|---|---|
| "加个功能 / 改需求 / 这个 issue" 而没有 spec | 分流 → 追问 → 写 spec | `/triage` → `/grill` → `/spec` |
| spec 已有、人已审，但没有 `*.tasks.md` | 拆任务账本 | `/tasks` |
| spec + 账本都有 | 列接缝 → 按账本实现 | `/feature` |
| "重构 / 整理 / 拆一下这段代码" | 先梳理、先锁 | `/survey` → `/lock` → `/refactor` |
| "看看这段代码是干嘛的" | 只读梳理 | `/survey` |
| "修个 bug" | 先 triage 定类型；A 类直接红回归测试→修 | `/triage` |
| "提交 / 开 PR" | 门禁全绿 + 账本全 ✅ 后 | `/pr` |

`/survey` 和 `/lock` 你可以自行调用（碰到不熟的遗留代码、要动没锁住的代码时）；其余命令只由人发起。

3. 以下情况**停下来问人**，不要自己决定：
   - spec 没覆盖的场景
   - CONTEXT.md 里没有的业务术语、主键、主路径（写入待确认区，或在 /grill 里问）
   - 测试接缝还没人确认
   - 特征测试红了且不确定是测试错还是行为变了
   - 任何需要移动 spec 状态、改 governance、改 CONTEXT.md 正式表、改 public API 的事

## 账本是唯一真相

- 进度只记在 `spec/planned/<spec>.tasks.md`，不记在对话里。
- 会话结束前把账本更新到最新；下一个会话从账本开始，不重新拆。
- `*.tasks.md` 的状态列和 commit 列是 spec/ 下唯一允许 AI 修改的内容。

## 测试纪律

写测试前适用 `tdd-seams` skill：先列接缝等确认，一个接缝一个测试一个最小实现，不 mock 内部、不同义反复、不横切。

## 门禁

提交前 `bash scripts/gate.sh` 必须全绿；pre-commit hook 会强制执行。不要设 `SKIP_GATE`。
