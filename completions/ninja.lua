-- luacheck: no max line length
--------------------------------------------------------------------------------
-- ninja.lua — Ninja 构建工具

local num_arg = clink.argmatcher():addarg({fromhistory=true})
local freeform = clink.argmatcher():addarg({fromhistory=true})

clink.argmatcher("ninja")
:addflags({
    "--version",
    "-v", "--verbose",
    "--quiet",
    "-C"..clink.argmatcher():addarg(clink.dirmatches),
    "-f"..clink.argmatcher():addarg(clink.filematches),
    "-j"..num_arg,
    "-k"..num_arg,
    "-l"..num_arg,
    "-n",
    "-d"..freeform,
    "-t"..freeform,
    "-w"..freeform,
    "-h", "--help",
})
:addarg(freeform)
:adddescriptions({
    ["--version"] = { "显示版本号" },
    ["-v"] = { "显示构建时的完整命令行" },
    ["--verbose"] = { "显示构建时的完整命令行" },
    ["--quiet"] = { "不显示进度，只显示命令输出" },
    ["-C"] = { " dir", "先切换到指定目录再构建" },
    ["-f"] = { " file", "指定输入构建文件（默认 build.ninja）" },
    ["-j"] = { " n", "并行任务数（0 表示无限）" },
    ["-k"] = { " n", "容忍 n 个任务失败后停止（0 表示无限）" },
    ["-l"] = { " n", "系统负载超过 n 时不启动新任务" },
    ["-n"] = { "干跑（不实际执行命令）" },
    ["-d"] = { " mode", "调试模式（-d list 查看）" },
    ["-t"] = { " tool", "运行子工具（-t list 查看）" },
    ["-w"] = { " flag", "警告调整（-w list 查看）" },
    ["-h"] = { "显示帮助" },
})
