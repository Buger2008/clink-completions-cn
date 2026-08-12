-- luacheck: no max line length
--------------------------------------------------------------------------------
-- nslookup.lua — DNS 查询
-- 用法: nslookup [-opt ...] [host] [server]

local qtype = clink.argmatcher():addarg({ "A", "AAAA", "ANY", "CNAME", "MX", "NS", "PTR", "SOA", "SRV", "TXT", fromhistory=true })
local freeform = clink.argmatcher():addarg({fromhistory=true})

clink.argmatcher("nslookup")
:addflags({
    "-d",
    "-t"..qtype,
    "-port"..freeform,
    "-timeout"..freeform,
    "-retry"..freeform,
    "-vc",
    "-domain"..freeform,
    "-srchlist"..freeform,
    "-defname",
    "-search",
    "-norecurse",
    "-recurse",
    "-fail",
    "-nofail",
    "-?",
})
:addarg(freeform)
:addarg(freeform)
:adddescriptions({
    ["-d"] = { "调试模式（显示完整数据包信息）" },
    ["-t"] = { " type", "查询类型：A / AAAA / MX / NS / CNAME / SOA / SRV / TXT / ANY" },
    ["-port"] = { " port", "指定 DNS 服务器端口（默认 53）" },
    ["-timeout"] = { " sec", "等待应答的超时秒数" },
    ["-retry"] = { " n", "重试次数" },
    ["-vc"] = { "使用 TCP 而非 UDP 查询" },
    ["-domain"] = { " name", "附加默认域名" },
    ["-srchlist"] = { " list", "设置搜索列表（逗号分隔）" },
    ["-defname"] = { "在查询中附加默认域名" },
    ["-search"] = { "使用搜索列表查找主机（默认）" },
    ["-norecurse"] = { "关闭递归查询" },
    ["-recurse"] = { "打开递归查询（默认）" },
    ["-fail"] = { "失败时尝试下一个服务器（默认）" },
    ["-nofail"] = { "失败时不尝试下一个服务器" },
    ["-?"] = { "显示帮助" },
})
