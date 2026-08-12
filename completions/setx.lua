-- luacheck: no max line length
--------------------------------------------------------------------------------
-- setx.lua — 持久化设置环境变量

local freeform = clink.argmatcher():addarg({fromhistory=true})

clink.argmatcher("setx")
:addarg(freeform)
:addarg(freeform)
:addflags({
    "/m",
    "/s"..freeform,
    "/u"..freeform,
    "/p"..freeform,
    "/k"..freeform,
    "/f"..freeform,
    "/x",
    "/?",
})
:adddescriptions({
    ["/m"] = { "在系统级（HKLM）设置变量，而非用户级（需要管理员）" },
    ["/s"] = { " system", "指定远程系统" },
    ["/u"] = { " user", "以指定用户身份连接" },
    ["/p"] = { " pass", "指定用户密码" },
    ["/k"] = { " path", "从注册表项读取值（如 \\\\HKEY_CURRENT_USER\\...）" },
    ["/f"] = { " file", "从文件读取变量" },
    ["/x"] = { "显示文件中的键并等待输入选择" },
    ["/?"] = { "显示帮助" },
})
