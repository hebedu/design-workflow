# Learning System · 自动学习与优化系统

> 这个目录是 design-workflow 的"大脑外挂"。所有 AI 角色越用越聪明的秘密在这里。

## 工作原理

```
你正常工作
    ├─ 对话中纠正 AI ─────→ AI 自动写入 corrections.md + role-patches/
    └─ 修改 AI 输出后 commit → post-commit hook 分析 diff → diff-insights.md

下次启动角色时
    └─ slash command 自动加载 role-patches/<角色>.patch.md 作为上下文

积累到一定量
    └─ /dw-evolve 合并补丁回角色脚本本体（生成新版本 + changelog）
```

## 文件说明

| 文件 / 目录 | 作用 | 谁来写 |
|------------|------|-------|
| `corrections.md` | 对话中用户对 AI 输出的修正记录 | AI（自动） |
| `diff-insights.md` | 用户修改 AI 输出后的 diff 模式分析 | post-commit hook |
| `role-patches/0X-*.patch.md` | 每个角色累积的补丁知识，下次启动时自动注入 | AI + hook |
| `diffs/<role>-<date>.md` | 原始 diff 详情归档 | post-commit hook |
| `prompt-changelog.md` | 角色脚本变更历史 | `/dw-evolve` |

## 使用准则

### 你只需要：
1. 正常工作（用斜杠命令、提需求）
2. 不满意时直接说出来（"不是这样"、"应该 X 才对"、"漏了 Y"）—— AI 自动记录
3. 修改 AI 输出后正常 `git commit` —— hook 自动分析
4. 偶尔（每 5-10 个项目）跑 `/dw-evolve`，把补丁合并回角色脚本

### 你不需要：
- ❌ 手动写反馈（系统自动捕获）
- ❌ 评分、打标签（无需主观判断）
- ❌ 维护学习目录（自动维护）

## 不要做的事

- 不要手动编辑 `corrections.md` / `diff-insights.md`（破坏自动化）
- 不要把项目敏感信息塞进 patches（这些会成为通用角色脚本）
- 合并前先看一眼 `prompt-changelog.md`，确认没有不合理的修改
