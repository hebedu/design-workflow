# Diff 模式分析

> 这个文件由 post-commit hook 自动写入。用户修改 AI 输出后 commit 时，hook 会分析 diff 并提取模式。
> 不要手动编辑此文件。

## 记录格式

```
---
date: YYYY-MM-DDTHH:MM:SSZ
role: 0X-xxx
project: <项目名>
file: <被修改的文件名>
commit: <commit hash>
change_type: format | content | structure | logic | deletion
summary: <一句话总结改了什么>
diff_size: +N -M
---
```

## Insights

<!-- post-commit hook 将在此处追加记录 -->
