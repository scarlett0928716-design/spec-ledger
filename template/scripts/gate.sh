#!/usr/bin/env bash
# 质量门禁：本地 pre-commit 和 CI 跑的是同一个脚本，永远一致。
# 退出码非 0 = 门禁失败 = 不许提交 / 不许合并。
#
# 自动识别项目类型；需要定制时只改下面"CUSTOMIZE"区。
set -euo pipefail
cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

# ---------- CUSTOMIZE：按项目填写（留空则自动识别） ----------
SRC_DIRS="${GATE_SRC_DIRS:-}"      # 例: "app tests" 或 "src tests"
PY_LINT="${GATE_PY_LINT:-}"        # 例: "ruff check"
PY_TEST="${GATE_PY_TEST:-}"        # 例: "pytest -q"
JS_LINT="${GATE_JS_LINT:-}"        # 例: "npm run lint --silent"
JS_TEST="${GATE_JS_TEST:-}"        # 例: "npm test --silent"
# ------------------------------------------------------------

log()  { printf '\033[1;34m[gate]\033[0m %s\n' "$*"; }
fail() { printf '\033[1;31m[gate] FAILED:\033[0m %s\n' "$*"; exit 1; }

# 找 Python 工具：.venv → PATH → uv 临时环境
py_tool() {
  local t="$1"
  if   [ -x ".venv/bin/$t" ]; then echo ".venv/bin/$t"
  elif command -v "$t" >/dev/null 2>&1; then echo "$t"
  elif command -v uv >/dev/null 2>&1; then echo "uv run --with $t $t"
  else return 1
  fi
}

ran=0

if [ -f pyproject.toml ] || [ -f setup.py ] || [ -f requirements.txt ]; then
  ran=1
  if [ -z "$SRC_DIRS" ]; then
    SRC_DIRS=""
    for d in src app lib tests; do [ -d "$d" ] && SRC_DIRS="$SRC_DIRS $d"; done
    SRC_DIRS="${SRC_DIRS# }"
  fi
  : "${PY_LINT:=$(py_tool ruff || true) check}"
  : "${PY_TEST:=$(py_tool pytest || true) -q}"

  if [[ "$PY_LINT" == " check" ]]; then fail "找不到 ruff（装 ruff，或安装 uv）"; fi
  if [[ "$PY_TEST" == " -q" ]];   then fail "找不到 pytest（装 pytest，或安装 uv）"; fi

  log "lint: $PY_LINT $SRC_DIRS"
  # shellcheck disable=SC2086
  $PY_LINT $SRC_DIRS || fail "lint 未通过"
  log "test: $PY_TEST"
  # shellcheck disable=SC2086
  $PY_TEST || fail "测试未通过"
fi

if [ -f package.json ]; then
  ran=1
  : "${JS_LINT:=npm run lint --silent --if-present}"
  : "${JS_TEST:=npm test --silent --if-present}"
  log "lint: $JS_LINT"
  $JS_LINT || fail "lint 未通过"
  log "test: $JS_TEST"
  $JS_TEST || fail "测试未通过"
fi

if [ "$ran" -eq 0 ]; then
  log "未识别到 Python / Node 项目，门禁空跑通过。需要门禁请在 scripts/gate.sh 的 CUSTOMIZE 区配置。"
fi

log "全绿 ✅"
