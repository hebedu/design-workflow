---
description: 初始化一个新的设计协作项目（创建 workspace + manifest）
---

# 初始化新项目

请帮我初始化一个新的设计协作项目。

## 执行步骤

1. **询问项目名**：如果用户调用时附带了项目名（见下方 $ARGUMENTS），直接使用；否则询问用户。
2. **运行 init 脚本**：执行 `bash scripts/init.sh "<项目名>"`
3. **确认结果**：读取 `workspace/.current-project` 确认当前项目，读取 `workspace/<日期>-<项目名>/manifest.json` 展示项目状态。
4. **给出下一步建议**：
   - 完整流程：建议从 `/dw-research` 开始
   - 已有 PRD：建议从 `/dw-ux` 开始
   - 已有交互规格：建议从 `/dw-style` 开始
   - 想先跑骨架：在每个角色启动时声明"用场景 S 骨架模式"

## 用户输入

$ARGUMENTS

## 注意

- 项目目录格式：`workspace/YYYY-MM-DD-项目名/`
- 不要重复初始化已存在的项目
- 创建后告知用户产出文件会自动保存到该目录
