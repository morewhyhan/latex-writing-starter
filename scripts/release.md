# 本地版本归档

流程参考原项目并按本工程改写；[来源与许可](../third_party/han-man-elegy/README.md)。

本命令在编译成功后生成本地发布版，不自动创建 GitHub Release、推送、上传或发送给他人。

先检查目标 `config.tex` 的书名、作者、版本与用户期望一致。需要版本号但用户尚未指定时沿用配置中的版本；同版本归档已存在时不要静默覆盖，应报告冲突并由用户明确新版本或替换意图。

运行 `powershell -NoProfile -File scripts/build.ps1 -Release`；翻译稿添加 `-Language <Language>`。不同语言串行执行。

成功输出：
- `releases/<Language>/<version>/book.pdf`：该版本成品。
- 同目录 `manifest.json`：语言、版本、时间及源文件／PDF 的 SHA-256。
- `releases/<Language>/latest.pdf`：最近一次成功归档的副本。
- `releases/<Language>/latest.json`：最近归档的版本与文件指向。

“最近”按成功归档时间，不自动判断版本号大小。失败时不更新 latest。归档目录默认忽略 Git；外部发布按用户明确要求另外执行。

清单摘要覆盖目标源稿目录中的文件，排除 `original/` 快照；如果正文引用目录外的共享图片等资源，归档前另外核对这些资源，不能声称清单已覆盖它们。
