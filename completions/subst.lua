-- luacheck: no max line length
--------------------------------------------------------------------------------
-- subst.lua — 将路径关联到虚拟盘符

local drive = clink.argmatcher():addarg({fromhistory=true})

clink.argmatcher("subst")
:addflags({
    "/d"..drive,
    "/?",
})
:addarg(drive)
:adddescriptions({
    ["/d"] = { " x:", "删除指定虚拟盘符的关联" },
    ["/?"] = { "显示帮助" },
})
