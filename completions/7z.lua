-- luacheck: no max line length
--------------------------------------------------------------------------------
-- 7z.lua — 7-Zip / NanaZip 压缩工具
-- 用法: 7z <command> [<switches>...] <archive> [<files>...] [@listfile]

local freeform = clink.argmatcher():addarg({fromhistory=true})
local num_arg = clink.argmatcher():addarg({fromhistory=true})

local archive = clink.argmatcher():addarg(clink.filematches)

local switch_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    { "-o"..freeform,          " dir",        "设置输出目录（e/x 命令）" },
    { "-p"..freeform,          " pass",       "设置密码" },
    { "-m"..freeform,          " params",     "设置压缩参数，如 -mx9 -mmt" },
    { "-mx"..num_arg,          " n",          "压缩级别：-mx1（最快）~ -mx9（最大压缩）" },
    { "-mmt"..num_arg,         " n",          "CPU 线程数" },
    { "-t"..freeform,          " type",       "归档类型：7z / zip / tar / gzip / bzip2 / xz" },
    { "-r",                                "递归子目录" },
    { "-y",                                "所有询问都回答是" },
    { "-sdel",                             "压缩后删除源文件" },
    { "-ssw",                              "压缩正在共享/打开的文件" },
    { "-v"..freeform,          " size",      "分卷大小，如 -v100m" },
    { "-w"..freeform,          " dir",       "工作目录" },
    { "-x"..freeform,          " pattern",   "排除文件：-x!*.tmp" },
    { "-i"..freeform,          " pattern",   "包含文件：-i!*.doc" },
    { "-ao"..freeform,         " mode",      "覆盖模式：a（跳过）/ s（自动改名）/ t（覆盖）/ u（更新）" },
    { "-bb"..num_arg,          " n",         "日志级别 -bb0~-bb3" },
    { "-bd",                                "禁用进度指示" },
    { "-bt",                                "显示执行时间统计" },
    { "-scrc"..freeform,       " hash",      "哈希函数：CRC32 / CRC64 / SHA256 / SHA1 / XXH64" },
    { "-sfx"..freeform,        " name",      "创建自解压归档" },
    { "-si"..freeform,         " name",      "从标准输入读取数据" },
    { "-so",                                "写入标准输出" },
    { "-slp",                                "大页模式" },
    { "-slt",                                "列表命令显示技术信息" },
    { "-snh",                                "以硬链接存储链接" },
    { "-snl",                                "以符号链接存储链接" },
    { "-ssc",                                "区分大小写模式" },
    { "-ssp",                                "不改变源文件访问时间" },
    { "-stl",                                "用最新文件的修改时间设置归档时间" },
    { "-a"..freeform,          " mode",      "添加选项，如 -ai、-ax" },
})
:nofiles()

clink.argmatcher("7z")
:_addexflags({
    opteq=true,
    { "--version",  "显示版本信息" },
    { "--",         "停止开关和 @listfile 解析" },
    { "/?",         "显示帮助" },
})
:_addexarg({
    { "a",  "添加文件到归档" },
    { "b",  "基准测试" },
    { "d",  "从归档删除文件" },
    { "e",  "解压（不使用目录名）" },
    { "h",  "计算文件的哈希值" },
    { "i",  "显示支持的格式信息" },
    { "l",  "列出归档内容" },
    { "rn", "重命名归档中的文件" },
    { "t",  "测试归档完整性" },
    { "u",  "更新归档中的文件" },
    { "x",  "按完整路径解压" },
})
:addarg(archive)
:addarg(switch_parser)
:addarg(freeform)
