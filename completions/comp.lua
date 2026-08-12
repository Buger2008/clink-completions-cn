-- luacheck: no max line length
--------------------------------------------------------------------------------
-- comp.lua — 逐字节比较两个文件

local num_arg = clink.argmatcher():addarg({fromhistory=true})

clink.argmatcher("comp")
:addarg(clink.filematches)
:addarg(clink.filematches)
:addflags({
    "/d",
    "/a",
    "/l",
    "/n"..num_arg,
    "/c",
    "/off",
    "/?",
})
:adddescriptions({
    ["/d"] = { "以十进制格式显示差异（默认十六进制）" },
    ["/a"] = { "以 ASCII 字符显示差异" },
    ["/l"] = { "显示差异所在的行号，而非字节偏移" },
    ["/n"] = { " number", "只比较前 number 行（即使文件更大）" },
    ["/c"] = { "比较时忽略大小写" },
    ["/off"] = { "处理具有脱机属性集的文件" },
    ["/?"] = { "显示帮助" },
})
