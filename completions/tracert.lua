-- luacheck: no max line length
--------------------------------------------------------------------------------
-- tracert.lua — 路由追踪

local freeform = clink.argmatcher():addarg({fromhistory=true})

clink.argmatcher("tracert")
:addflags({
    "/d",
    "/h"..freeform,
    "/j"..freeform,
    "/w"..freeform,
    "/r",
    "/s"..freeform,
    "/4",
    "/6",
    "/?",
})
:addarg(freeform)
:adddescriptions({
    ["/d"] = { "不将 IP 地址解析为主机名" },
    ["/h"] = { " max-hops", "最大跳数（默认 30）" },
    ["/j"] = { " host-list", "使用松散源路由（仅 IPv4）" },
    ["/w"] = { " timeout", "每次应答等待的毫秒数（默认 4000）" },
    ["/r"] = { "使用往返路径探测（仅 IPv6）" },
    ["/s"] = { " src-addr", "指定源地址（仅 IPv6）" },
    ["/4"] = { "强制使用 IPv4" },
    ["/6"] = { "强制使用 IPv6" },
    ["/?"] = { "显示帮助" },
})
