---
role: 原型视觉助理
project: Bingxin Du 产品设计师作品集网站
date: 2026-05-13
version: v1
upstream: 03-interaction.md
downstream: 评审员
status: draft
---

## TL;DR
当前原型采用“原始效果图主视觉 + HTML 热区 + 后续内容模块”的高还原方案，已实现首页、项目区、AI Flow、Timeline、Contact。

## 1. 页面清单
| ID | 页面名 | 用途 | 入口 |
|----|--------|------|------|
| P1 | Home | 首屏品牌与主推项目 | 默认 |
| P2 | Work Section | 8 个项目浏览与筛选 | Explore Work |
| P3 | AI Flow | 展示全栈 AI 设计流程 | AI Flow |
| P4 | Timeline | 展示成长路径 | Timeline |
| P5 | Contact | 联系与下一步 | Footer / Contact |

## 2. 页面详述

### P1 Home
**当前实现**：
- 使用 `assets/hero-artwork.png` 作为 Hero 主视觉。
- 叠加 CTA、项目卡、小熊猫和语言切换热区。
- 使用定位点脉冲、路线光点、卡片浮动作为动效。

**优点**：
- 高度贴近用户确认的效果图。
- 快速解决 CSS 手绘和效果图差距过大的问题。

**局限**：
- Hero 内的文字和卡片目前仍在图片里，不利于双语、SEO 和维护。
- 图片裁切需要继续为移动端单独优化。

### P2 Work Section
- 8 个项目卡片。
- 支持 All / C-end / B-end / AI / Personal 筛选。
- 每张卡默认展示 Role / Value。

### P3 AI Flow
- 5 节点流程：Problem / Research / AI Workflow / Prototype / Evaluate。
- 节点自动点亮，强调 AI 工作流能力。

### P4 Timeline
- 4 个阶段 mock。

### P5 Contact
- Email CTA 与回到顶部。

## 3. 关键组件
### HeroArtwork
- **状态**：默认 / 热区 hover / reduced motion。
- **资产**：`assets/hero-artwork.png`。
- **响应式**：桌面尽量完整显示；移动端裁切左侧核心信息。

### ProjectCard
- **状态**：默认 / hover / 筛选隐藏。
- **变体**：Featured / Standard。
- **信息**：Type、Title、Role、Value、Impact。

### FlowNode
- **状态**：默认 / active / hover。
- **动效**：自动轮流 active。

## 4. 输出产物
- [index.html](/Users/admin/Documents/Codex/2026-05-13/files-mentioned-by-the-user-workflow/portfolio-journey/index.html)
- [styles.css](/Users/admin/Documents/Codex/2026-05-13/files-mentioned-by-the-user-workflow/portfolio-journey/styles.css)
- [script.js](/Users/admin/Documents/Codex/2026-05-13/files-mentioned-by-the-user-workflow/portfolio-journey/script.js)
- [hero-artwork.png](/Users/admin/Documents/Codex/2026-05-13/files-mentioned-by-the-user-workflow/portfolio-journey/assets/hero-artwork.png)

---

## 🤝 交接

### ✅ 已完成
- 实现高还原首页 Hero。
- 创建项目区、AI Flow、Timeline、Contact。
- 切出小熊猫与三张项目卡参考图。

### ⚠️ 假设与遗留
- 当前不是最终分层资产版本。
- Hero 里的图中文字还不能真正双语替换。
- 需要压缩图片与优化移动端裁切。

### 📤 给下游的钩子
- 评审需重点判断：高还原图驱动是否接受，还是必须进入分层重建。

### 🔗 启动下游
> 我是下游角色 **评审员**，以下是上游产出，请按你的脚本处理：
>
> [此处粘贴本文件完整内容]
