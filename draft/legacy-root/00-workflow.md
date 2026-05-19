# 设计协作流程总说明（导演手册）

本目录是一个「AI 剧组」：6 个角色按顺序接力，把一个模糊需求推进到可落地的视觉方案。
所有角色脚本与 AI 平台无关，Claude / GPT / Gemini 均可用。

---

## 一、角色清单与交付物

| 顺序 | 角色 | 脚本文件 | 核心产出 |
|------|------|---------|---------|
| 1 | 研究助理 | roles/01-researcher.md | 需求成立性 + 拆解 + 竞品 + 用户痛点 |
| 2 | 产品助理 | roles/02-pm.md | PRD + 功能清单 + 优先级 |
| 3 | 交互助理 | roles/03-interaction.md | 主流程 + 状态 + 异常路径 + 交互规则 |
| 4 | 原型助理 | roles/04-prototype.md | 页面结构 + 可交互 Demo 规格 |
| 5 | UI 设计师 | roles/05-ui-designer.md | 原型评审 + 设计 Token + 页面美化 + AI 生成提示词 |
| 6 | 评审员 | roles/06-reviewer.md | 全盘漏洞清单 + 改进建议 |

> 备注：早期版本归档在 `draft/`（`research-assistant.md` 与 `workflow/流程编排文件.md`），可对照参考。

---

## 二、使用步骤（每次新项目）

### Step 0：建工作区
```
workspace/
└── YYYY-MM-DD-项目名/
```

### Step 1：启动研究助理
1. 打开任一 AI（Claude / GPT / Gemini），**开新对话**
2. 复制 `roles/01-researcher.md` 的 **PART 1** 全文，粘贴给 AI
3. 复制 **PART 2** 启动模板，填好项目信息后粘贴
4. AI 按格式输出研究报告
5. 保存到 `workspace/YYYY-MM-DD-项目名/01-research.md`

### Step 2 ~ 6：依次调用后续角色
- **每次都开新对话**（避免上一角色人格残留）
- 粘贴下一角色的 PART 1
- 粘贴上一角色产出文件的完整内容作为输入
- 保存到对应的 `02-prd.md`、`03-interaction.md`、`04-prototype.md`、`05-ui-spec.md`、`06-review.md`

### Step 7：回炉迭代
评审员会输出「回炉任务单」，按角色分组，每组自带可复制的启动语。

1. 看评审报告末尾的「回炉优先级」表，确认哪些角色需要改
2. 按优先级顺序，把对应的「📤 给 xxx 的回炉任务」复制粘贴给那个角色
3. 角色输出 v2 版本后，保存覆盖原文件（或另存 `-v2`）
4. 如果某角色的修改影响下游（评审报告会标注"是否阻塞下游"），下游角色也要跟着更新
5. 全部回炉完成后，可再跑一轮评审员确认

---

## 三、跨 AI 使用建议

| AI | 擅长的角色 | 原因 |
|----|----------|-----|
| Claude | 产品助理、UI 设计师、评审员 | 长文本、结构化输出稳、能写规范代码 |
| ChatGPT | 研究助理 | 联网搜竞品方便 |
| Gemini | 原型助理、UI 设计师 | 多模态，能看你的参考图 |

**最佳实践**：同一项目可以混用不同 AI，但每个角色的脚本保持不变。

---

## 四、四条铁律

1. **角色不越界**：每个角色只做自己那一环，超纲就转交。
2. **产出走文件**：所有交接通过 Markdown 文件，不依赖 AI 的对话记忆。
3. **契约优先**：所有输出遵守 `handoff-contract.md` 的统一格式。
4. **人工在环**：你是总导演，AI 不自动触发下一步，由你决定何时推进。

---

## 五、目录结构

```
design-workflow/
├── 00-workflow.md              ← 你现在看的这份
├── handoff-contract.md         ← 统一交接格式
├── roles/
│   ├── 01-researcher.md
│   ├── 02-pm.md
│   ├── 03-interaction.md
│   ├── 04-prototype.md
│   ├── 05-ui-designer.md       ← 新增：UI 设计师
│   └── 06-reviewer.md
├── draft/                       ← 历史版本归档
│   ├── research-assistant.md
│   └── workflow/流程编排文件.md
└── workspace/
    └── [日期]-[项目名]/
        ├── 01-research.md
        ├── 02-prd.md
        ├── 03-interaction.md
        ├── 04-prototype.md
        ├── 05-ui-spec.md
        └── 06-review.md
```

---

## 六、常见坑

- **AI 越权写 PRD**：研究助理开始自己写功能清单 → 在 PART 1 里明确边界，并在对话里提醒一句「只做研究那一步」。
- **上下文串味**：同一对话里切换角色，AI 会带前一角色偏见 → 每个角色都新开对话。
- **产出格式漂移**：AI 不按契约输出 → 在启动模板末尾强调「严格遵守 handoff-contract.md」。
- **版本混乱**：迭代时覆盖旧文件 → 文件名带 `-v1`、`-v2`，或用 git 管理 workspace。
