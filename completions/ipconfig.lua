-- luacheck: no max line length
--------------------------------------------------------------------------------
-- ipconfig.lua — Windows 网络配置

local adapter = clink.argmatcher():addarg({fromhistory=true})

clink.argmatcher("ipconfig")
:addflags({
    "/all",
    "/allcompartments",
    "/compartments",
    "/renew"..adapter,
    "/renew6"..adapter,
    "/release"..adapter,
    "/release6"..adapter,
    "/flushdns",
    "/displaydns",
    "/registerdns",
    "/showclassid"..adapter,
    "/setclassid"..adapter,
    "/?",
})
:adddescriptions({
    ["/all"] = { "显示所有适配器的完整配置信息（含 MAC、DHCP 等）" },
    ["/allcompartments"] = { "显示所有隔离网络分区的信息" },
    ["/compartments"] = { "显示当前网络分区信息" },
    ["/renew"] = { " adapter", "为指定适配器重新获取 DHCP 地址" },
    ["/renew6"] = { " adapter", "为指定适配器重新获取 DHCPv6 地址" },
    ["/release"] = { " adapter", "释放指定适配器的 DHCP 地址" },
    ["/release6"] = { " adapter", "释放指定适配器的 DHCPv6 地址" },
    ["/flushdns"] = { "清空 DNS 解析缓存" },
    ["/displaydns"] = { "显示 DNS 解析缓存内容" },
    ["/registerdns"] = { "刷新所有 DHCP 租约并重新注册 DNS 名称" },
    ["/showclassid"] = { " adapter", "显示指定适配器的 DHCP 类 ID" },
    ["/setclassid"] = { " adapter", "设置指定适配器的 DHCP 类 ID" },
    ["/?"] = { "显示帮助" },
})
