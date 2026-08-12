-- luacheck: no max line length
--------------------------------------------------------------------------------
-- tasklist.lua — 列出进程

local fo = clink.argmatcher():addarg({ "TABLE", "LIST", "CSV" })
local filter = clink.argmatcher():addarg({fromhistory=true})

clink.argmatcher("tasklist")
:addflags({
    "/fi"..filter,
    "/fo"..fo,
    "/nh",
    "/v",
    "/s"..filter,
    "/u"..filter,
    "/p"..filter,
    "/m"..filter,
    "/svc",
    "/apps",
    "/pn",
    "/?",
})
:adddescriptions({
    ["/fi"] = { " filter", "按筛选条件过滤，如 /FI \"IMAGENAME eq cmd.exe\"" },
    ["/fo"] = { " format", "输出格式：TABLE / LIST / CSV" },
    ["/nh"] = { "输出中省略列标题" },
    ["/v"] = { "显示详细信息（窗口标题、CPU 时间等）" },
    ["/s"] = { " system", "指定远程系统（主机名或 IP）" },
    ["/u"] = { " user", "以指定用户身份连接远程系统" },
    ["/p"] = { " pass", "指定用户密码" },
    ["/m"] = { " module", "列出加载了指定 DLL 模块的进程（省略则列出所有模块）" },
    ["/svc"] = { "显示每个进程承载的服务" },
    ["/apps"] = { "显示应用商店应用及其关联进程" },
    ["/pn"] = { "显示进程 ID（与 /apps 配合）" },
    ["/?"] = { "显示帮助" },
})
