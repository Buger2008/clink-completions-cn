-- luacheck: no max line length
--------------------------------------------------------------------------------
-- netsh.lua — 网络脚本（部分操作需管理员）

local freeform = clink.argmatcher():addarg({fromhistory=true})

-- interface 子命令
local interface_context = clink.argmatcher()
:_addexarg({
    { "ipv4",  "IPv4 接口配置（show config / set address / add route 等）" },
    { "ipv6",  "IPv6 接口配置" },
    { "show",  "显示接口（show interface / show subinterfaces）" },
    { "set",   "设置接口（set interface / set subinterface）" },
})
:nofiles()

-- advfirewall 子命令
local advfirewall_context = clink.argmatcher()
:_addexarg({
    { "show",    "显示防火墙状态（show allprofiles / show publicprofile 等）" },
    { "set",     "设置防火墙（set allprofiles state on|off 等）" },
    { "reset",   "重置防火墙策略" },
    { "export",  "导出防火墙策略到文件" },
    { "import",  "导入防火墙策略" },
})
:nofiles()

-- 顶层
clink.argmatcher("netsh")
:addflags({
    "-c",
    "-f",
    "/?",
})
:_addexarg({
    { "interface" .. interface_context,    "网络接口配置（ipv4 / ipv6 等）" },
    { "advfirewall" .. advfirewall_context, "高级防火墙配置" },
    { "firewall",                         "经典防火墙配置" },
    { "wlan",                             "无线网络配置（show profiles / connect 等）" },
    { "http",                             "HTTP 服务配置" },
    { "winhttp",                          "WinHTTP 代理配置（show proxy / set proxy）" },
    { "dhcp",                             "DHCP 服务器配置" },
    { "wins",                             "WINS 服务器配置" },
    { "ras",                              "远程访问服务配置" },
    { "routing",                          "路由与远程访问配置" },
    { "bridge",                           "网桥配置" },
    { "p2p",                              "点对点网络配置" },
    { "rpc",                              "RPC 配置" },
    { "trace",                            "网络跟踪配置" },
    { "wfp",                              "Windows 过滤平台配置" },
    { "nap",                              "网络访问保护配置" },
})
:adddescriptions({
    ["-c"] = { " context", "切换到指定上下文，如 -c interface" },
    ["-f"] = { " file",    "执行脚本文件中的命令" },
    ["/?"] = { "显示帮助" },
})
