#!/usr/bin/env bash
# post-commit hook: 自动分析 workspace/ 中 AI 输出文件的修改，提取学习信号
#
# 安装方式：
#   ln -s ../../scripts/learn-from-commit.sh .git/hooks/post-commit
# 或：
#   cp scripts/learn-from-commit.sh .git/hooks/post-commit && chmod +x .git/hooks/post-commit

set -e

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)" || exit 0
cd "$REPO_ROOT"

# 只关心 workspace/ 下的产出文件
CHANGED_FILES=$(git diff-tree --no-commit-id --name-only -r HEAD | grep -E '^workspace/.*\.(md|html)$' || true)

if [ -z "$CHANGED_FILES" ]; then
  exit 0
fi

COMMIT_HASH=$(git rev-parse --short HEAD)
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
LEARNING_DIR="$REPO_ROOT/learning"
INSIGHTS_FILE="$LEARNING_DIR/diff-insights.md"
DIFFS_DIR="$LEARNING_DIR/diffs"

mkdir -p "$DIFFS_DIR"

while IFS= read -r file; do
  [ -z "$file" ] && continue

  # 解析角色：从文件名推断
  basename=$(basename "$file")
  role=""
  case "$basename" in
    01-research.md)        role="01-researcher" ;;
    02-prd.md)             role="02-pm" ;;
    03-interaction.md)     role="03-interaction" ;;
    04-style-*)            role="04-prototype-visual" ;;
    04-prototype*)         role="04-prototype-visual" ;;
    05-review.md)          role="05-reviewer" ;;
    uat-*.md)              role="06-uat-walker" ;;
    launch-ops.md)         role="07-launch-ops" ;;
    *)                     role="unknown" ;;
  esac

  # 提取项目名
  project=$(echo "$file" | awk -F'/' '{print $2}')

  # 获取 diff 大小
  diff_stat=$(git diff HEAD~1 HEAD -- "$file" 2>/dev/null | grep -E '^[+-]' | grep -v '^[+-]{3}' | awk 'BEGIN{a=0;d=0} /^\+/{a++} /^-/{d++} END{print "+"a" -"d}')

  # 推断变更类型（粗粒度启发式）
  added=$(echo "$diff_stat" | awk '{print $1}' | tr -d '+')
  deleted=$(echo "$diff_stat" | awk '{print $2}' | tr -d '-')
  added=${added:-0}
  deleted=${deleted:-0}

  if [ "$added" -gt 0 ] && [ "$deleted" -eq 0 ]; then
    change_type="content"
  elif [ "$deleted" -gt 0 ] && [ "$added" -eq 0 ]; then
    change_type="deletion"
  elif [ "$deleted" -gt 0 ] && [ "$added" -gt 0 ] && [ "$added" -lt 5 ] && [ "$deleted" -lt 5 ]; then
    change_type="format"
  else
    change_type="structure"
  fi

  # 保存完整 diff 到归档
  diff_file="$DIFFS_DIR/${role}-$(date -u +%Y%m%d-%H%M%S)-${COMMIT_HASH}.md"
  {
    echo "# Diff: $file"
    echo ""
    echo "- Commit: $COMMIT_HASH"
    echo "- Date: $TIMESTAMP"
    echo "- Role: $role"
    echo "- Project: $project"
    echo "- Change: $diff_stat ($change_type)"
    echo ""
    echo '```diff'
    git diff HEAD~1 HEAD -- "$file" 2>/dev/null || echo "(no prior version)"
    echo '```'
  } > "$diff_file"

  # 追加到 insights
  commit_msg=$(git log -1 --pretty=%s)
  {
    echo ""
    echo "---"
    echo "date: $TIMESTAMP"
    echo "role: $role"
    echo "project: $project"
    echo "file: $basename"
    echo "commit: $COMMIT_HASH"
    echo "change_type: $change_type"
    echo "summary: $commit_msg"
    echo "diff_size: $diff_stat"
    echo "detail: diffs/$(basename $diff_file)"
    echo "---"
  } >> "$INSIGHTS_FILE"

  echo "[learning] captured: $file → $change_type ($diff_stat)"

done <<< "$CHANGED_FILES"

# 提示用户：若 insights 增长到阈值，建议 /dw-evolve
total_insights=$(grep -c "^date:" "$INSIGHTS_FILE" 2>/dev/null || echo 0)
if [ "$total_insights" -ge 10 ] && [ $((total_insights % 10)) -eq 0 ]; then
  echo ""
  echo "[learning] 已累积 $total_insights 条 diff insights，建议运行 /dw-evolve 合并补丁回角色脚本"
fi
