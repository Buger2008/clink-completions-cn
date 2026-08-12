-- luacheck: no max line length
--------------------------------------------------------------------------------
-- fc.lua — 比较两个文件

local num_arg = clink.argmatcher():addarg({fromhistory=true})

clink.argmatcher("fc")
:addarg(clink.filematches)
:addarg(clink.filematches)
:addflags({
    "/a",
    "/b",
    "/c",
    "/l",
    "/lb"..num_arg,
    "/n",
    "/t",
    "/u",
    "/w",
    "/?",
})
:adddescriptions({
    ["/a"] = { "仅显示每组差异的首行和末行" },
    ["/b"] = { "以二进制模式比较（默认 .exe/.com/.sys/.obj/.lib 等）" },
    ["/c"] = { "比较时忽略大小写" },
    ["/l"] = { "以 ASCII 文本模式比较" },
    ["/lb"] = { " n", "设置内部行缓冲区大小（默认 100 行）" },
    ["/n"] = { "显示行号（ASCII 模式）" },
    ["/t"] = { "不将制表符展开为空格" },
    ["/u"] = { "以 Unicode 模式比较文件" },
    ["/w"] = { "比较时压缩空白（连续空白视为一个空格）" },
    ["/?"] = { "显示帮助" },
})
