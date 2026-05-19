#!/bin/bash
# 初始化新项目工作区
# 用法: ./scripts/init.sh "项目名"
# 或:   bash scripts/init.sh

set -e

# 找到 design-workflow 根目录（脚本所在目录的上一级）
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# 项目名
PROJECT_NAME="${1:-}"
if [ -z "$PROJECT_NAME" ]; then
  read -p "项目名（中英文均可）: " PROJECT_NAME
fi

if [ -z "$PROJECT_NAME" ]; then
  echo "❌ 项目名不能为空"
  exit 1
fi

# 日期前缀
DATE_PREFIX=$(date +%Y-%m-%d)
PROJECT_DIR="$ROOT_DIR/workspace/${DATE_PREFIX}-${PROJECT_NAME}"

# 创建项目目录
if [ -d "$PROJECT_DIR" ]; then
  echo "⚠️  项目目录已存在: $PROJECT_DIR"
  read -p "是否覆盖现有 manifest？(y/N) " CONFIRM
  if [ "$CONFIRM" != "y" ] && [ "$CONFIRM" != "Y" ]; then
    echo "已取消"
    exit 0
  fi
else
  mkdir -p "$PROJECT_DIR"
fi

# 复制 manifest 模板并填入项目信息
MANIFEST_TEMPLATE="$SCRIPT_DIR/manifest-template.json"
MANIFEST_FILE="$PROJECT_DIR/manifest.json"

if [ ! -f "$MANIFEST_TEMPLATE" ]; then
  echo "❌ 找不到模板文件: $MANIFEST_TEMPLATE"
  exit 1
fi

# 用 sed 替换占位符
sed "s/PROJECT_NAME/${PROJECT_NAME}/g; s/YYYY-MM-DD/${DATE_PREFIX}/g" "$MANIFEST_TEMPLATE" > "$MANIFEST_FILE"

# 写入 .current-project 文件，方便其他脚本快速读取当前项目
echo "${DATE_PREFIX}-${PROJECT_NAME}" > "$ROOT_DIR/workspace/.current-project"

echo "✅ 项目已初始化"
echo ""
echo "📁 项目目录: $PROJECT_DIR"
echo "📄 manifest:  $MANIFEST_FILE"
echo ""
echo "下一步："
echo "  在 Claude Code / Codex / Cursor 中输入 /dw-research 开始研究"
echo "  或直接调用 workflow/roles/01-researcher.md 的内容"
