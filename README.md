# LaTeX Writing Starter

用于研究、写作与排版的预配置 LaTeX 项目模板，集成 AI 辅助工作流程。第一版以空白中文书籍工程为默认入口，提供编译、审查、翻译与本地归档；正文为空，作者自行安排内容和章节。

## 开始一本新书

1. 克隆这个仓库，或在 GitHub 使用“Use this template”创建新仓库（需要先将仓库发布并设置为模板仓库）。
2. 修改 `book/config.tex` 中的书名、作者和版本。
3. 根据需要使用 [李星野书籍写作模板](templates/写作框架/李星野书籍写作模板.md)，与 AI 一起研究、写作；它是可选方法，不会强制生成书籍目录。
4. 在 `book/content/` 写入正文。`chapters.tex` 可以直接写多个章，也可用 `\input{content/章节文件名}` 拆分文件。
5. 安装包含 XeLaTeX、latexmk 和中文宏包的 TeX 环境，运行下面的命令。

```powershell
powershell -NoProfile -File scripts/build.ps1
```

PowerShell 7 用户也可以运行 `pwsh -NoProfile -File scripts/build.ps1`。最终 PDF 位于 `build/main.pdf`，生成文件不进入 Git。

## 目录

```text
book/
  main.tex               排版与内容装配入口
  config.tex             书名、作者、日期、版本
  style.tex              页面、链接及命题环境
  content/
    preface.tex          前言（空白）
    chapters.tex         章节（空白，自行安排）
    closing.tex          结语（空白）
    appendix.tex         附录（空白）
scripts/build.ps1        编译入口
AGENTS.md                AI 统一规则与命令路由
scripts/*.md             编译、审查、翻译、归档、获取提示词
templates/               可选写作方法模板
```

## 排版基础

正文前有标题页与自动目录。内容支持章、节、图片、公式、脚注、超链接和交叉引用。`axiom`、`theorem`、`corollary` 环境分别用于公理、定理、推论；数量由内容决定，环境名称本身不代表命题已经得到证明。前言、结语和附录目前只是空白文件，不会自动产生占位章节。

全书结构在 `book/main.tex` 中装配，样式集中在 `book/style.tex`。写作模板与排版分开维护，可以添加其他方法；当前未自动将 Markdown 模板转换成 LaTeX 正文。

本仓库不包含原书正文、图片、研究报告或历史模板。编译需要外部 TeX 工具，不随仓库附带安装程序。

## AI 辅助工作流程

Codex 读取 `AGENTS.md`；Claude、Gemini、Cursor 与 Copilot 入口均指向同一份规则。可以直接说“编译”“审查正文”“翻译成英语”“生成本地发布版”“打开PDF”，AI 按 `scripts/` 中的对应提示词执行。没有必要时不要求作者重复确认。

翻译按需生成 `translations/<Language>/`，保留已翻译源稿快照；默认没有译文。其他语言的字体与语体需要适配后再编译。

```powershell
powershell -NoProfile -File scripts/build.ps1 -Language English
powershell -NoProfile -File scripts/build.ps1 -Release
```

发布命令生成本地 `releases/<Language>/<version>/book.pdf` 与校验清单，不自动上传。默认不覆盖同版本归档；生成目录被 Git 忽略。

VS Code／Cursor 可运行 `Book: Build` 任务，仍通过同一构建脚本。编辑器规则不安装扩展或 TeX 工具。

临时参考克隆已移出本仓库，不随模板发布。迁移范围、固定版本与提示词许可见 [来源说明](third_party/han-man-elegy/README.md)。
