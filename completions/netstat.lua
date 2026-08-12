-- luacheck: no max line length
--------------------------------------------------------------------------------
-- netstat.lua — 网络连接、路由表、接口统计

local proto = clink.argmatcher():addarg({ "tcp", "udp", "tcpv6", "udpv6", "icmp", "icmpv6", "ip", "ipv6", "raw", "rawv6", fromhistory=true })

clink.argmatcher("netstat")
:addflags({
    "-a",
    "-b",
    "-e",
    "-f",
    "-n",
    "-o",
    "-p"..proto,
    "-q",
    "-r",
    "-s",
    "-t",
    "-x",
    "-y",
    "-?",
})
:adddescriptions({
    ["-a"] = { "显示所有连接和监听端口" },
    ["-b"] = { "显示每个连接关联的可执行文件（需管理员）" },
    ["-e"] = { "显示以太网统计信息（可与 -s 联用）" },
    ["-f"] = { "显示外部地址的完全限定域名（FQDN）" },
    ["-n"] = { "以数字形式显示地址和端口（不解析名称）" },
    ["-o"] = { "显示每个连接所属的进程 ID（PID）" },
    ["-p"] = { " proto", "仅显示指定协议：tcp / udp / tcpv6 / udpv6 等" },
    ["-q"] = { "显示所有连接、监听端口及绑定的非监听 TCP 端口" },
    ["-r"] = { "显示路由表" },
    ["-s"] = { "显示各协议的统计信息" },
    ["-t"] = { "显示当前连接的卸载状态（TCP Chimney）" },
    ["-x"] = { "显示 NetworkDirect 连接、监听器和共享端点" },
    ["-y"] = { "显示所有连接的 TCP 连接模板" },
    ["-?"] = { "显示帮助" },
})
