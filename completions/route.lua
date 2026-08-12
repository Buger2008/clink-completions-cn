-- luacheck: no max line length
--------------------------------------------------------------------------------
-- route.lua — 查看/修改 IPv4 与 IPv6 路由表（修改需管理员）

local freeform = clink.argmatcher():addarg({fromhistory=true})

clink.argmatcher("route")
:addflags({
    "-f",
    "-p",
    "-4",
    "-6",
    "/?",
})
:_addexarg({
    { "print",  "打印路由表" },
    { "add",    "添加路由：add dest mask gateway [metric] [if]" },
    { "delete", "删除路由：delete dest" },
    { "change", "修改现有路由：change dest mask gateway" },
})
:addarg(freeform)
:addarg(freeform)
:adddescriptions({
    ["-f"] = { "清除所有网关条目（与命令联用）" },
    ["-p"] = { "与 add 联用时添加永久路由" },
    ["-4"] = { "仅操作 IPv4 路由" },
    ["-6"] = { "仅操作 IPv6 路由" },
    ["/?"] = { "显示帮助" },
})
