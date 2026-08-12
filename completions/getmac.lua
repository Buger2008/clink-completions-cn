-- luacheck: no max line length
--------------------------------------------------------------------------------
-- getmac.lua — 查看网卡 MAC 地址

local fo = clink.argmatcher():addarg({ "TABLE", "LIST", "CSV" })

clink.argmatcher("getmac")
:addflags({
    "/fo"..fo,
    "/nh",
    "/v",
    "/s"..clink.argmatcher():addarg({fromhistory=true}),
    "/u"..clink.argmatcher():addarg({fromhistory=true}),
    "/p"..clink.argmatcher():addarg({fromhistory=true}),
    "/?",
})
:adddescriptions({
    ["/fo"] = { " format", "输出格式：TABLE / LIST / CSV" },
    ["/nh"] = { "输出中省略列标题（仅 TABLE/CSV）" },
    ["/v"] = { "显示详细信息" },
    ["/s"] = { " system", "指定远程系统（主机名或 IP）" },
    ["/u"] = { " user", "以指定用户身份连接远程系统" },
    ["/p"] = { " pass", "指定用户密码" },
    ["/?"] = { "显示帮助" },
})
