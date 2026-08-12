-- luacheck: no max line length
--------------------------------------------------------------------------------
-- unzip.lua — GNU unzip
-- 用法: unzip [-opts[modifiers]] file[.zip] [list] [-x xlist] [-d exdir]

local freeform = clink.argmatcher():addarg({fromhistory=true})

clink.argmatcher("unzip")
:addflags({
    "-p",
    "-l",
    "-f",
    "-t",
    "-u",
    "-z",
    "-v",
    "-T",
    "-x"..freeform,
    "-d"..clink.argmatcher():addarg(clink.dirmatches),
    "-n",
    "-q",
    "-o",
    "-a",
    "-j",
    "-aa",
    "-U",
    "-UU",
    "-C",
    "-L",
    "-X",
    "-K",
    "-M",
    "-Z",
    "-h",
})
:addarg(freeform)
:adddescriptions({
    ["-p"] = { "解压到管道（不显示消息）" },
    ["-l"] = { "列出归档内容（简短格式）" },
    ["-f"] = { "仅更新已存在的文件" },
    ["-t"] = { "测试归档数据完整性" },
    ["-u"] = { "更新文件，必要时创建" },
    ["-z"] = { "仅显示归档注释" },
    ["-v"] = { "详细列出或显示版本信息" },
    ["-T"] = { "将归档时间戳设为最新" },
    ["-x"] = { " xlist", "排除 xlist 中的文件" },
    ["-d"] = { " exdir", "解压到指定目录" },
    ["-n"] = { "绝不覆盖已存在的文件" },
    ["-q"] = { "安静模式（-qq 更安静）" },
    ["-o"] = { "覆盖文件而不提示" },
    ["-a"] = { "自动转换文本文件" },
    ["-j"] = { "丢弃路径（不创建目录）" },
    ["-aa"] = { "将所有文件视为文本" },
    ["-U"] = { "对非 ASCII Unicode 使用转义" },
    ["-UU"] = { "忽略 Unicode 字段" },
    ["-C"] = { "文件名匹配不区分大小写" },
    ["-L"] = { "将某些名称转为小写" },
    ["-X"] = { "恢复 UID/GID 信息" },
    ["-K"] = { "保留 setuid/setgid 权限" },
    ["-M"] = { "通过 more 分页器显示" },
    ["-Z"] = { "ZipInfo 模式（unzip -Z 查看用法）" },
    ["-h"] = { "显示帮助" },
})
