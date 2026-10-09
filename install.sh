#!/usr/bin/env bash
# spec-ledger 安装器：把方法论骨架复制进目标项目。
#
# 用法：
#   bash install.sh <目标项目目录> [--force]
#   curl -fsSL https://raw.githubusercontent.com/scarlett0928716-design/spec-ledger/main/install.sh | bash -s -- <目标目录>
#
# 默认不覆盖已存在的文件（安全接入已有项目）；--force 覆盖全部。
set -euo pipefail

TARGET="${1:-}"
FORCE=0
[ "${2:-}" = "--force" ] && FORCE=1

if [ -z "$TARGET" ]; then
  echo "用法: bash install.sh <目标项目目录> [--force]" >&2
  exit 1
fi

# 定位 template/：本地克隆用脚本旁边的；curl 管道安装则临时拉取
HERE="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || echo "")"
if [ -n "$HERE" ] && [ -d "$HERE/template" ]; then
  SRC="$HERE/template"
else
  TMP="$(mktemp -d)"
  REPO="${SPEC_LEDGER_REPO:-https://github.com/scarlett0928716-design/spec-ledger.git}"
  git clone --depth 1 --quiet "$REPO" "$TMP/spec-ledger"
  SRC="$TMP/spec-ledger/template"
fi

mkdir -p "$TARGET"
TARGET="$(cd "$TARGET" && pwd)"

copied=0; skipped=0; copied_list=()
while IFS= read -r -d '' f; do
  rel="${f#"$SRC"/}"
  dest="$TARGET/$rel"
  if [ -e "$dest" ] && [ "$FORCE" -eq 0 ]; then
    echo "  跳过（已存在）: $rel"; skipped=$((skipped+1)); continue
  fi
  mkdir -p "$(dirname "$dest")"
  cp "$f" "$dest"
  copied=$((copied+1)); copied_list+=("$dest")
done < <(find "$SRC" -type f -print0)

chmod +x "$TARGET/scripts/gate.sh" "$TARGET/scripts/setup.sh" "$TARGET/scripts/git-hooks/"* 2>/dev/null || true

# 把日期填进模板——只处理本次新复制的文件，绝不碰项目里已有的
TODAY="$(date +%Y-%m-%d)"
for f in "${copied_list[@]}"; do
  case "$f" in
    */AGENTS.md|*/spec/governance/coding-discipline.md)
      sed -i.bak "s/YYYY-MM-DD/$TODAY/g" "$f" && rm -f "$f.bak" ;;
  esac
done

cat <<EOF

spec-ledger 已安装到: $TARGET
  复制 $copied 个文件，跳过 $skipped 个已存在文件$( [ "$skipped" -gt 0 ] && echo "（需要覆盖请加 --force）" )

下一步（按顺序）：
  1. 编辑 AGENTS.md 第零节"项目参数"（代码目录、裁决人），往 CONTEXT.md 填前 5 个最容易混淆的术语
  2. cd "$TARGET" && bash scripts/setup.sh      # 启用 pre-commit 门禁并试跑
  3. 已有项目：挑一个最不敢动的老入口，先 /survey → /lock
     新项目：  第一个功能先 /grill → /spec → 人审 → /tasks → /feature
  4. 把 docs/methodology.md 里的"人的角色清单"贴在你看得见的地方

EOF
