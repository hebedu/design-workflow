---
description: 自动推进到下一个角色（读 manifest 判断，就地执行，不起新 agent）
---

# 自动推进（/dw-next）

你是设计协作流程的自动调度器。**在当前会话里就地执行下一个角色，不要起新 agent / 后台任务。**

## 执行步骤

1. **读取当前项目**：
   - 读 `workspace/.current-project`
   - 不存在则提示用户先 `/dw-init`，停下

2. **读取 manifest.json**，按顺序找第一个 `status != "done"` 且 `status != "n/a"` 的角色：
   ```
   01-research → 02-prd → 03-interaction → 04-style-options → 04-prototype-hifi → 05-review → uat-checklist → uat-report
   ```

3. **特殊处理**：
   - 有 `needs_revision` 的角色 → 优先回炉它
   - `04-style-options` done + `04-prototype-hifi` pending → 先问用户选了哪个风格
   - `05-review` done → 不自动进阶段 3，提示可选 `/dw-package`
   - `launch-ops` 永远跳过（需显式 `/dw-launch`）
   - 全部 done → 输出完成提示 + 可选操作列表

4. **告诉用户进度 + 开始执行**：
   ```
   📍 项目：[名]
   ✅ 已完成：01 / 02 / ...
   ➡️ 下一步：03 交互助理
   正在执行...
   ```

5. **加载并执行**：
   - 读 `learning/role-patches/<角色ID>.patch.md`（如有）
   - 读 `workflow/roles/<角色文件>.md` 完整内容
   - 读上游产出文件
   - 按 PART 0 → PART 1 → PART 3 执行
   - 保存产出 + 更新 manifest

6. **执行完毕**：
   ```
   ✅ [角色名] 完成，已保存 [文件名]。
   ➡️ 输入 /dw-next 继续。
   ```

## 用户附带的输入

$ARGUMENTS

- "骨架" / "skeleton" → 用场景 S 执行
- "跳到 05" / "skip to review" → 直接执行指定角色
- "回炉 03" → 执行 03 回炉模式（读 05-review.md 回炉任务）
- 留空 → 自动判断下一步

## 映射表

| manifest 字段 | 角色文件 | 产出文件 |
|--------------|---------|---------|
| 01-research | 01-researcher.md | 01-research.md |
| 02-prd | 02-pm.md | 02-prd.md |
| 03-interaction | 03-interaction.md | 03-interaction.md |
| 04-style-options | 04-prototype-visual.md (A1) | 04-style-options.md + HTML |
| 04-prototype-hifi | 04-prototype-visual.md (A2) | 04-prototype-hifi.md + HTML |
| 05-review | 05-reviewer.md | 05-review.md |
| uat-checklist | 06-uat-walker.md (A1) | uat-checklist.md |
| uat-report | 06-uat-walker.md (A2) | uat-report.md |
