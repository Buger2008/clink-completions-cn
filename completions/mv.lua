--------------------------------------------------------------------------------
-- Clink argmatcher for mv (GNU coreutils)
--

clink.argmatcher("mv")
:adddescriptions({
    ["-f"] = { "覆盖前不提示" },
    ["--force"] = { "覆盖前不提示" },
    ["-i"] = { "覆盖前提示" },
    ["--interactive"] = { "覆盖前提示" },
    ["-n"] = { "不覆盖现有文件" },
    ["--no-clobber"] = { "不覆盖现有文件" },
    ["-v"] = { "说明正在执行的操作" },
    ["--verbose"] = { "说明正在执行的操作" },
    ["-u"] = { "仅在源文件比目标文件更新时才移动" },
    ["--update"] = { "仅在源文件比目标文件更新时才移动" },
    ["-T"] = { "将目标视为普通文件" },
    ["--no-target-directory"] = { "将目标视为普通文件" },
    ["-t"] = { " arg", "将所有源文件移动到 DIRECTORY" },
    ["--target-directory"] = { " arg", "将所有源文件移动到 DIRECTORY" },
    ["-b"] = { "备份每个现有的目标文件" },
    ["--backup"] = { "备份每个现有的目标文件" },
    ["--strip-trailing-slashes"] = { "从每个源参数中移除尾随斜杠" },
    ["-S"] = { " suffix", "覆盖默认的备份后缀" },
    ["--suffix"] = { " suffix", "覆盖默认的备份后缀" },
    ["-Z"] = { "设置目标文件的 SELinux 安全上下文" },
    ["--context"] = { "设置目标文件的 SELinux 安全上下文" },
    ["--help"] = { "显示帮助并退出" },
    ["--version"] = { "输出版本信息并退出" },
})
:addflags({
    "-f", "--force",
    "-i", "--interactive",
    "-n", "--no-clobber",
    "-v", "--verbose",
    "-u", "--update",
    "-T", "--no-target-directory",
    "-t"..(clink.argmatcher():addarg(clink.dirmatches)),
    "--target-directory="..(clink.argmatcher():addarg(clink.dirmatches)),
    "-b", "--backup",
    "--strip-trailing-slashes",
    "-S"..(clink.argmatcher():addarg({fromhistory=true})),
    "--suffix="..(clink.argmatcher():addarg({fromhistory=true})),
    "-Z", "--context",
    "--help", "--version",
})
