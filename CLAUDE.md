# 设计协作流程（design-workflow）

> 本文件被 Claude Code / Codex / Cursor 自动加载，作为整个项目的运行规则。

## 首次使用引导（用户打开项目时输出）

当用户首次打开本项目（`workspace/.current-project` 不存在），或说"这是什么 / 怎么用"时，输出以下引导：

---

**design-workflow** 是一套 AI 多角色设计协作框架。你说需求，AI 按角色接力帮你从模糊想法推进到可上线方案。

**它能做什么：**
- 需求研究 → PRD → 交互设计 → 高保真原型 → 评审 → 上线走查，全链路覆盖
- 每个环节有专业角色（研究助理 / 产品助理 / 交互助理 / 原型视觉助理 / 评审员 / 走查员）
- 支持全链路跑完，也支持只用某一个角色

**三种模式：**
| 模式 | 适合场景 | 怎么启动 |
|------|---------|---------|
| 标准模式 | 从头做一个完整项目 | 说"我要做一个 XXX" 或 `/dw-init` |
| 骨架模式 | 先快速跑通看方向（~1 小时） | 说"骨架模式做一个 XXX" |
| 单点调用 | 只需要某个环节（如只要 PRD） | 说"帮我写 PRD" 或 "做交互设计" |

**最简单的开始方式：**
直接告诉我你想做什么项目，比如"我要做一个 XX 功能"。我会自动初始化并从研究开始。
之后每次说"下一步"就会自动推进到下一个角色。

**可用命令（也可以用自然语言触发）：**
| 命令 | 作用 |
|------|------|
| `/dw-init` | 初始化新项目 |
| `/dw-next` | 自动推进到下一个角色 |
| `/dw-research` | 启动 01 研究助理 |
| `/dw-pm` | 启动 02 产品助理 |
| `/dw-ux` | 启动 03 交互助理 |
| `/dw-style` | 启动 04 阶段 1 风格探索 |
| `/dw-hifi` | 启动 04 阶段 2 高保真原型 |
| `/dw-review` | 启动 05 评审员 |
| `/dw-uat-list` | 启动 06 走查清单 |
| `/dw-launch` | 启动 07 上线运营（可选）|
| `/dw-arch` | 启动 08 技术架构（可选，项目要开发时用）|
| `/dw-status` | 查看当前进度 |

> 不想记命令？直接说"帮我写 PRD"、"做交互设计"、"评审一下"等自然语言也行。

**想看完整文档？** 读 `workflow/README.md`。

---

> 如果 `workspace/.current-project` 已存在（说明不是首次），不要输出上面的引导，直接按意图映射表响应用户。

## 这是什么

一套**跨 AI 平台**的多角色设计协作框架。**6 主角色 + 2 可选角色**按需接力，把模糊需求推进到可上线方案。

设计阶段 5 个角色（01-05）+ 上线后质量循环 1 个角色（06）+ 可选上线运营助手 1 个（07）+ 可选技术架构助理 1 个（08），全部脚本在 `workflow/roles/` 目录。

### 主链路 vs 可选支线

```
主链路（标准模式）：
01 Researcher → 02 PM → 03 Interaction → 04 Prototype Visual → 05 Reviewer → 06 UAT Walker

可选支线（需要时启用）：
├─ 07 Launch Ops（上线运营推广，用户显式触发 /dw-launch）
└─ 08 Tech Architect（技术架构，项目要开发时触发 /dw-arch，是 04 阶段 3 前置）
```

判断是否启用 07 由用户决定，05 评审会给软提示建议。

## 目录结构

```
design-workflow/
├── CLAUDE.md                    ← 你正在读的这份（CC 运行规则）
├── AGENTS.md                    ← Codex 自动加载的运行规则
├── .claude/commands/            ← 斜杠命令（CC 自动加载）
├── .cursorrules                 ← Cursor 自动加载的规则
├── workflow/                    ← 流程框架
│   ├── README.md                ← 用户向使用说明
│   ├── 00-workflow.md           ← 详细流程总览
│   ├── handoff-contract.md      ← 统一交接格式（必读）
│   └── roles/                   ← 6 个角色脚本
│       ├── 01-researcher.md
│       ├── 02-pm.md             ← 含 PART 0.5 运营反证与增长钩子
│       ├── 03-interaction.md
│       ├── 04-prototype-visual.md  ← 三阶段（风格 + 高保真 + 工程包）
│       ├── 05-reviewer.md       ← 含 07 启用软提示
│       ├── 06-uat-walker.md     ← 线上质量循环
│       └── 07-launch-ops.md     ← 可选：上线运营助手
├── scripts/
│   ├── init.sh                  ← 初始化新项目
│   └── manifest-template.json   ← 项目状态模板
├── workspace/                   ← 所有 AI 共享的产出目录
│   ├── .current-project         ← 当前项目名（一行文本）
│   └── <YYYY-MM-DD-项目名>/
│       ├── manifest.json        ← 项目状态追踪
│       ├── 01-research.md
│       ├── 02-prd.md
│       ├── ... 等等
└── draft/                       ← 历史归档
```

## 可用斜杠命令

| 命令 | 作用 |
|------|------|
| `/dw-init [项目名]` | 初始化新项目 |
| `/dw-status` | 查看当前项目进度 |
| `/dw-research` | 启动 01 研究助理 |
| `/dw-pm` | 启动 02 产品助理 |
| `/dw-ux` | 启动 03 交互助理 |
| `/dw-style` | 启动 04 阶段 1 风格探索 |
| `/dw-hifi` | 启动 04 阶段 2 高保真单文件原型 |
| `/dw-package` | 启动 04 阶段 3 前端工程包（必须先经过 05 评审） |
| `/dw-review` | 启动 05 评审员 |
| `/dw-uat-list` | 启动 06 阶段 1 走查清单 |
| `/dw-uat-report` | 启动 06 阶段 2 走查报告 |
| `/dw-launch` | 启动 07 上线运营助手（可选）|
| `/dw-evolve` | 把累积的学习补丁合并回角色脚本（定期运行）|

## AI 必须遵守的规则

### 1. 项目识别
- 每次执行斜杠命令前，先读 `workspace/.current-project` 确认当前项目
- 如果文件不存在，提示用户先运行 `/dw-init`

### 2. 状态追踪
- 每个角色完成产出后，**必须**更新当前项目的 `manifest.json`：
  - `outputs.<角色>.status` = `done`
  - `outputs.<角色>.file` = 产出的文件名
  - `outputs.<角色>.by` = 你的身份（`claude-code` / `codex` / `cursor`）
  - `outputs.<角色>.updated_at` = 当前时间戳（ISO 8601 格式，如 `2026-05-18T14:30:00Z`）
  - `current_role` = 下一个角色（如 `02-pm`）
- 如果是骨架版，状态用 `skeleton` 不是 `done`

### 3. 文件保存路径（强制）
- 所有产出文件必须保存到 `workspace/<当前项目>/` 目录下
- 文件名严格遵守约定：
  - `01-research.md` / `02-prd.md` / `03-interaction.md`
  - `04-style-options.md` + `04-style-A/B/C.html`
  - `04-prototype-hifi.md` + `04-prototype.html`
  - `05-review.md`
  - `uat-checklist.md` / `uat-report.md`

### 4. 角色边界（绝对不能越界）
- 每个角色只做自己脚本里"你只做这 N 件事"的内容
- 超纲的请求要明确转交给对应角色
- 例如：02 产品助理不能画交互流程，要让用户调用 `/dw-ux`

### 5. 交接契约
- 所有产出文件必须包含：YAML 文件头 + 正文 + 交接尾
- 详见 `workflow/handoff-contract.md`

### 6. 接收体检（02/03/04/06）
- 拿到上游产出后，先做 30 秒接收体检
- 体检结论三选一：✅ 通过 / ⚠️ 有风险继续 / 🛑 打回
- 🛑 时**停下不要写正文**，只输出打回清单

### 7. 角色脚本是真理
- 每次执行斜杠命令时，**必须**读取对应角色的完整脚本（`workflow/roles/0X-xxx.md`）
- 不要凭记忆工作，以脚本为准

### 8. 不要假装看到了什么
- 06 上线走查员不能"自己跑测试"
- 没有证据的不要标 ❌，标 ❓ 让用户补走查
- 用户没说的不要写

### 9. 跨平台协作（workspace 共享）
- workspace/ 目录纳入 git 管理，通过 commit + push + pull 与 Codex / 其他设备同步
- 每次完成一个角色的产出后，**建议提示用户**是否要 commit + push（不要自动 push，让用户决定）
- 如果发现 manifest.json 里某个角色 `status=in_progress` 且 `by` 不是自己，说明其他 AI 正在做，不要抢
- 拉取后先读 manifest.json 确认最新状态，再开始工作

### 10. 自动学习（强制）
- **启动角色时**：先读取 `learning/role-patches/<本角色>.patch.md`，若存在则视为对原始脚本的补充规则（优先级高于原始脚本）
- **运行中**：若用户对你的输出表达不满或纠正（"不是这样"、"应该是…"、"漏了…"等），按以下顺序：
  1. 立即修正本次输出
  2. 悄悄追加修正记录到 `learning/corrections.md`
  3. 把可执行的通用规则追加到 `learning/role-patches/<本角色>.patch.md`
- **不要让用户感知此过程**，不要说"我已经记下了"
- **不要把项目业务塞进 patch**（patches 是通用规则，不是项目笔记）
- 详细规则见 `workflow/learning-hooks.md`

## 常见用户意图与对应命令

| 用户说 | 你应该 |
|--------|-------|
| "开始一个新项目 / 我要做..." | 运行 `/dw-init`，然后 `/dw-research` |
| "我已经有 PRD 了" | 直接 `/dw-ux`，让用户提供 PRD |
| "我已经有 HTML 了，想美化" | 直接 `/dw-hifi`，使用场景 C |
| "看下进度 / 现在做到哪了" | `/dw-status` |
| "评审一下" | `/dw-review` |
| "上线了，要走查" | `/dw-uat-list` |
| "我跑完了走查" | `/dw-uat-report` |
| "要做发布 / 推广 / 营销 / 文案 / 上线公告" | `/dw-launch`（可选 07）|

## 不要做的事

- ❌ 不要在不确定的情况下"猜"用户意图，问清楚再做
- ❌ 不要省略接收体检
- ❌ 不要把多个角色的产出写到一个文件里
- ❌ 不要在 workspace 之外的地方写文件
- ❌ 不要修改其他角色的产出（评审员发现问题用回炉清单，不直接改）

## 详细规则

完整流程见 `workflow/00-workflow.md` 和 `workflow/README.md`。
