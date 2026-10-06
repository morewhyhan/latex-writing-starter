# 编译

流程参考原项目并按本工程改写；[来源与许可](../third_party/han-man-elegy/README.md)。

1. 根据用户指定选择源稿：默认 `book/`；翻译稿为 `translations/<Language>/`。先检查目标入口、书籍信息和本地 `\input`／`\include` 路径，不能误编译中文源稿。
2. 默认运行 `powershell -NoProfile -File scripts/build.ps1`；翻译稿添加 `-Language <Language>`。PowerShell 7 可将 `powershell` 换为 `pwsh`。
3. 不并发编译。同一脚本为所有语言使用仓库级锁，输出按语言隔离。
4. 非零退出码意味着失败。修复授权范围内的 LaTeX 错误再重试；依赖缺失则如实报告，保留源稿。
5. 成功后核对生成文件、目标语言及目录／引用警告，返回 PDF 的绝对路径链接。退出码通过只是编译成功，不等于排版或论证全部正确。

默认输出 `build/main.pdf`；翻译稿输出 `build/<Language>/main.pdf`。使用 `-Release` 才生成本地归档，见 `release.md`。
