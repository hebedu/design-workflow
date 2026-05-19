#!/bin/bash
# design-workflow 一键安装脚本
# 把 design-workflow 链接到目标项目，让 Claude Code / Codex / Cursor 自动加载

set -e

# 找到 design-workflow 根目录（脚本所在目录）
DW_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "================================================"
echo "  design-workflow 安装"
echo "================================================"
echo ""
echo "  框架位置: $DW_ROOT"
echo ""

# 询问目标项目目录
read -p "目标项目目录（留空则只在当前 design-workflow 内使用）: " TARGET_DIR

if [ -z "$TARGET_DIR" ]; then
  echo ""
  echo "✅ 在 design-workflow 内直接使用"
  echo ""
  echo "下一步："
  echo "  1. 用 Claude Code 打开 $DW_ROOT"
  echo "  2. 输入 /dw-init 初始化项目"
  echo "  3. 输入 /dw-research 开始第一棒"
  echo ""
  echo "Cursor 用户：在该目录打开会自动读取 .cursorrules"
  echo "Codex 用户：推到 GitHub 后 Codex 拉取即可（自动读取 AGENTS.md）"
  exit 0
fi

# 展开 ~
TARGET_DIR="${TARGET_DIR/#\~/$HOME}"

if [ ! -d "$TARGET_DIR" ]; then
  echo "❌ 目标目录不存在: $TARGET_DIR"
  exit 1
fi

echo ""
echo "正在安装到: $TARGET_DIR"
echo ""

# 创建符号链接而非复制（这样升级 design-workflow 时所有项目都自动更新）
INSTALL_TYPE=""
read -p "安装方式: [1] 符号链接（推荐，自动跟随升级）  [2] 复制文件 (1/2): " INSTALL_TYPE
INSTALL_TYPE="${INSTALL_TYPE:-1}"

# .claude/commands
mkdir -p "$TARGET_DIR/.claude"
if [ "$INSTALL_TYPE" = "1" ]; then
  ln -sfn "$DW_ROOT/.claude/commands" "$TARGET_DIR/.claude/commands"
else
  cp -r "$DW_ROOT/.claude/commands" "$TARGET_DIR/.claude/commands"
fi
echo "  ✅ .claude/commands/ 已安装（10 个斜杠命令）"

# CLAUDE.md
if [ "$INSTALL_TYPE" = "1" ]; then
  ln -sfn "$DW_ROOT/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
else
  cp "$DW_ROOT/CLAUDE.md" "$TARGET_DIR/CLAUDE.md"
fi
echo "  ✅ CLAUDE.md 已安装"

# .cursorrules
if [ "$INSTALL_TYPE" = "1" ]; then
  ln -sfn "$DW_ROOT/.cursorrules" "$TARGET_DIR/.cursorrules"
else
  cp "$DW_ROOT/.cursorrules" "$TARGET_DIR/.cursorrules"
fi
echo "  ✅ .cursorrules 已安装"

# workflow/ 目录（角色脚本）
if [ "$INSTALL_TYPE" = "1" ]; then
  ln -sfn "$DW_ROOT/workflow" "$TARGET_DIR/workflow"
else
  cp -r "$DW_ROOT/workflow" "$TARGET_DIR/workflow"
fi
echo "  ✅ workflow/ 已安装（角色脚本 + 流程文档）"

# scripts/
if [ "$INSTALL_TYPE" = "1" ]; then
  ln -sfn "$DW_ROOT/scripts" "$TARGET_DIR/scripts"
else
  cp -r "$DW_ROOT/scripts" "$TARGET_DIR/scripts"
fi
echo "  ✅ scripts/ 已安装"

# AGENTS.md (Codex)
if [ "$INSTALL_TYPE" = "1" ]; then
  ln -sfn "$DW_ROOT/AGENTS.md" "$TARGET_DIR/AGENTS.md"
else
  cp "$DW_ROOT/AGENTS.md" "$TARGET_DIR/AGENTS.md"
fi
echo "  ✅ AGENTS.md 已安装（Codex 自动加载）"

# workspace/ 目录（独立，每个项目有自己的）
if [ ! -d "$TARGET_DIR/workspace" ]; then
  mkdir -p "$TARGET_DIR/workspace"
  echo "  ✅ workspace/ 已创建（项目产出目录，每个项目独立）"
else
  echo "  ⏭  workspace/ 已存在，跳过"
fi

# learning/ 目录（自动学习系统）
if [ "$INSTALL_TYPE" = "1" ]; then
  ln -sfn "$DW_ROOT/learning" "$TARGET_DIR/learning"
else
  cp -r "$DW_ROOT/learning" "$TARGET_DIR/learning"
fi
echo "  ✅ learning/ 已安装（自动学习系统，跨项目共享）"

# 安装 git post-commit hook（自动捕获 diff 学习信号）
if [ -d "$TARGET_DIR/.git" ]; then
  HOOK_PATH="$TARGET_DIR/.git/hooks/post-commit"
  if [ -e "$HOOK_PATH" ] && [ ! -L "$HOOK_PATH" ]; then
    echo "  ⚠️  $HOOK_PATH 已存在且不是符号链接，跳过 hook 安装（手动合并）"
  else
    ln -sfn "$DW_ROOT/scripts/learn-from-commit.sh" "$HOOK_PATH"
    chmod +x "$DW_ROOT/scripts/learn-from-commit.sh"
    echo "  ✅ git post-commit hook 已安装（自动学习捕获）"
  fi
else
  echo "  ⏭  目标目录不是 git 仓库，跳过 hook 安装（git init 后重新运行此脚本）"
fi

echo ""
echo "================================================"
echo "  ✅ 安装完成"
echo "================================================"
echo ""
echo "下一步："
echo "  1. cd $TARGET_DIR"
echo "  2. 用 Claude Code 打开该目录"
echo "  3. 输入 /dw-init 开始一个新项目"
echo ""
echo "Cursor 用户：直接打开该目录即可（自动读取 .cursorrules）"
echo "Codex 用户：推到 GitHub 后 Codex 拉取即可（自动读取 AGENTS.md）"
echo "网页版 GPT/DeepSeek：手动粘贴 workflow/roles/0X-xxx.md 的 PART 1 内容"
