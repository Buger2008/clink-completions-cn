--------------------------------------------------------------------------------
-- Clink argmatcher for stat (uutils / GNU coreutils)
--

clink.argmatcher("stat")
:addarg(clink.filematches)
:adddescriptions({
    ["-c"] = { " format", "使用指定的 FORMAT 字符串输出" },
    ["--format"] = { " format", "使用指定的 FORMAT 字符串输出" },
    ["-f"] = { "显示文件系统状态而非文件状态" },
    ["--file-system"] = { "显示文件系统状态而非文件状态" },
    ["-L"] = { "跟随符号链接" },
    ["--dereference"] = { "跟随符号链接" },
    ["-t"] = { "以简洁（一行）格式输出" },
    ["--terse"] = { "以简洁（一行）格式输出" },
    ["--cached"] = { " mode", "指定如何使用缓存属性：never, always, auto" },
    ["--printf"] = { " format", "类似 --format，但解释反斜杠转义" },
    ["--append-exe"] = { "需要时追加 .exe（cygwin 特定）" },
    ["--help"] = { "显示帮助并退出" },
    ["--version"] = { "输出版本信息并退出" },
})
:addflags({
    "-c"..(clink.argmatcher():addarg({fromhistory=true})),
    "--format="..(clink.argmatcher():addarg({fromhistory=true})),
    "-f", "--file-system",
    "-L", "--dereference",
    "-t", "--terse",
    "--cached="..(clink.argmatcher():addarg({"never", "always", "auto"})),
    "--printf="..(clink.argmatcher():addarg({fromhistory=true})),
    "--append-exe",
    "--help", "--version",
})
