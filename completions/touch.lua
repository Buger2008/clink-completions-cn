--------------------------------------------------------------------------------
-- Clink argmatcher for touch (uutils / GNU coreutils)
--

clink.argmatcher("touch")
:addarg(clink.filematches)
:adddescriptions({
    ["-a"] = { "仅更改访问时间" },
    ["-c"] = { "不创建任何文件" },
    ["--no-create"] = { "不创建任何文件" },
    ["-d"] = { " arg", "使用指定日期字符串" },
    ["--date"] = { " arg", "使用指定日期字符串" },
    ["-m"] = { "仅更改修改时间" },
    ["-r"] = { " arg", "使用指定文件的时间戳" },
    ["--reference"] = { " arg", "使用指定文件的时间戳" },
    ["-t"] = { " arg", "使用指定的时间戳" },
    ["-f"] = { "忽略（兼容选项）" },
    ["-h"] = { "仅影响符号链接本身，而非其引用目标" },
    ["--no-dereference"] = { "仅影响符号链接本身，而非其引用目标" },
    ["--time"] = { " word", "更改指定时间：atime, access, use, mtime, modify" },
    ["--help"] = { "显示帮助并退出" },
    ["--version"] = { "输出版本信息并退出" },
})
:addflags({
    "-a",
    "-c", "--no-create",
    "-d"..(clink.argmatcher():addarg()),
    "--date="..(clink.argmatcher():addarg()),
    "-m",
    "-r"..(clink.argmatcher():addarg(clink.filematches)),
    "--reference="..(clink.argmatcher():addarg(clink.filematches)),
    "-t"..(clink.argmatcher():addarg()),
    "-f",
    "-h", "--no-dereference",
    "--time="..(clink.argmatcher():addarg({"atime", "access", "use", "mtime", "modify"})),
    "--help", "--version",
})
