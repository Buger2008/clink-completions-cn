-- luacheck: no max line length
--------------------------------------------------------------------------------
-- tree.lua — 以树形显示目录结构

clink.argmatcher("tree")
:addarg(clink.dirmatches)
:addflags({
    "/f",
    "/a",
    "/?",
})
:adddescriptions({
    ["/f"] = { "显示所有目录中的文件" },
    ["/a"] = { "使用 ASCII 字符而非图形字符" },
    ["/?"] = { "显示帮助" },
})
