-- luacheck: no max line length
--------------------------------------------------------------------------------
-- taskkill.lua — 结束进程

local freeform = clink.argmatcher():addarg({fromhistory=true})

clink.argmatcher("taskkill")
:addflags({
    "/pid"..freeform,
    "/im"..freeform,
    "/f",
    "/t",
    "/fi"..freeform,
    "/s"..freeform,
    "/u"..freeform,
    "/p"..freeform,
    "/?",
})
:adddescriptions({
    ["/pid"] = { " pid", "结束指定进程 ID 的进程" },
    ["/im"] = { " name", "结束指定映像名称的进程（如 notepad.exe）" },
    ["/f"] = { "强制结束进程（远程操作必需）" },
    ["/t"] = { "连同子进程一起结束" },
    ["/fi"] = { " filter", "按筛选条件结束，如 /FI \"IMAGENAME eq cmd.exe\"" },
    ["/s"] = { " system", "指定远程系统（主机名或 IP）" },
    ["/u"] = { " user", "以指定用户身份连接远程系统" },
    ["/p"] = { " pass", "指定用户密码" },
    ["/?"] = { "显示帮助" },
})
