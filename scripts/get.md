# 获取成品

流程参考原项目并按本工程改写；[来源与许可](../third_party/han-man-elegy/README.md)。

先从用户要求确定语言与版本，默认 `Chinese`。指定历史版本时查 `releases/<Language>/<version>/book.pdf`；要求已归档最新版时查 `latest.json` 与对应PDF；要求工作稿时查默认 `build/main.pdf` 或 `build/<Language>/main.pdf`。

文件存在时核对路径和所要求的版本，返回绝对路径链接。说明工作稿还是归档版，不把文件存在等同于与当前源稿一致。归档版可根据清单核对哈希；是否符合当前源稿还须比较清单中的源文件摘要。

文件不存在时，若用户已要求生成则按 `build.md`／`release.md` 执行；仅要求取回现有文件时说明不存在，不擅自翻译或发布。版本不明确且有多个可能目标时才询问。
