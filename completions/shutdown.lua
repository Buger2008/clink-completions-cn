-- luacheck: no max line length
--------------------------------------------------------------------------------
-- shutdown.lua — 关机 / 重启 / 注销

local num_arg = clink.argmatcher():addarg({fromhistory=true})
local reason = clink.argmatcher():addarg({fromhistory=true})

clink.argmatcher("shutdown")
:addflags({
    "/s",
    "/r",
    "/g",
    "/a",
    "/p",
    "/h",
    "/e",
    "/l",
    "/t"..num_arg,
    "/c"..reason,
    "/f",
    "/d"..reason,
    "/m"..reason,
    "/?",
})
:adddescriptions({
    ["/s"] = { "关闭计算机" },
    ["/r"] = { "关闭并重启计算机" },
    ["/g"] = { "重启并重新启动所有注册的应用程序" },
    ["/a"] = { "取消已计划的关机（仅限 /t 期间）" },
    ["/p"] = { "立即关闭本机（无提示）" },
    ["/h"] = { "休眠本机" },
    ["/e"] = { "记录计算机意外关机的原因" },
    ["/l"] = { "注销当前用户" },
    ["/t"] = { " xxx", "执行前等待 xxx 秒（默认 30，/f 下为 0）" },
    ["/c"] = { " comment", "添加关机注释（最长 512 字符）" },
    ["/f"] = { "强制关闭运行中的应用程序（可能丢失数据）" },
    ["/d"] = { " p:xx:yy", "记录关机原因代码，如 /d p:0:0" },
    ["/m"] = { " computer", "指定远程计算机，如 \\\\server" },
    ["/?"] = { "显示帮助" },
})
