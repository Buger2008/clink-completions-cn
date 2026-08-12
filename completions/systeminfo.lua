-- luacheck: no max line length
--------------------------------------------------------------------------------
-- systeminfo.lua — 系统信息

local fo = clink.argmatcher():addarg({ "TABLE", "LIST", "CSV" })

clink.argmatcher("systeminfo")
:addflags({
    "/s"..clink.argmatcher():addarg({fromhistory=true}),
    "/u"..clink.argmatcher():addarg({fromhistory=true}),
    "/p"..clink.argmatcher():addarg({fromhistory=true}),
    "/fo"..fo,
    "/nh",
    "/?",
})
:adddescriptions({
    ["/s"] = { " system", "指定远程系统（主机名或 IP）" },
    ["/u"] = { " user", "以指定用户身份连接远程系统" },
    ["/p"] = { " pass", "指定用户密码" },
    ["/fo"] = { " format", "输出格式：TABLE / LIST / CSV" },
    ["/nh"] = { "输出中省略列标题（仅 TABLE/CSV）" },
    ["/?"] = { "显示帮助" },
})
