# 参考项目与迁移说明

来源：<https://github.com/sinyalee/han-man-elegy>

固定提交：`8bd163c51142518496f2537360a7d5e06a01b69a`。

原项目曾克隆到临时目录以核对文件，随后移出本仓库；新项目克隆本仓库时不会附带原项目。

本次恢复其“统一 AI 入口＋命令提示词＋语言约定＋编译脚本”的工作方式，并按当前空白工程改写：

| 原项目部分 | 当前对应 | 处理 |
|---|---|---|
| AGENTS、Claude、Gemini、Cursor、Copilot 入口 | 同名入口 | 统一读取本仓库 AGENTS；改为本项目目录与研究要求 |
| build、review、translate、release、get 提示词 | `scripts/*.md` | 基于其流程改写，保留错误检查、串行构建、审查分类、翻译快照等机制 |
| Python 构建脚本 | `scripts/build.ps1` | 扩展本仓库原有脚本，适配 book/main.tex、翻译路径与本地归档 |
| 中文与其他语言规则 | `scripts/languages/` | 保留语言约定机制，移除原书人物、内容替换及专有事实 |
| VS Code 编辑偏好 | `.vscode/` | 保留自动换行等写作设置，增加调用本仓库脚本的构建任务；不改变全局主题 |

没有移入原书正文、图片或已发布 PDF。模板中的原作实例仍用于解释写作方法。

原项目 `scripts/` 标注 Business Source License 1.1。本目录 [LICENSE](LICENSE) 保存该软件许可原文；基于原命令提示词改写的 `scripts/build.md`、`review.md`、`translate.md`、`release.md`、`get.md` 保留此来源与许可声明。这里没有将原项目全部内容重新声明为本项目的原创或统一许可。
