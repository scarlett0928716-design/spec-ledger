#!/usr/bin/env bash
# 一次性启用：git hook 门禁 + 脚本可执行权限。
# 克隆仓库后每台机器跑一次：bash scripts/setup.sh
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

chmod +x scripts/gate.sh scripts/git-hooks/* 2>/dev/null || true
git config core.hooksPath scripts/git-hooks

echo "[spec-ledger] 已启用 pre-commit 门禁（core.hooksPath = scripts/git-hooks）"
echo "[spec-ledger] 现在试跑一次门禁："
bash scripts/gate.sh
