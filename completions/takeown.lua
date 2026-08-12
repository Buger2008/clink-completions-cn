-- luacheck: no max line length
--------------------------------------------------------------------------------
-- takeown.lua — 获取文件/目录所有权（需要管理员）

clink.argmatcher("takeown")
:addflags({
    "/f"..clink.argmatcher():addarg(clink.filematches),
    "/a",
    "/r",
    "/d"..clink.argmatcher():addarg({fromhistory=true}),
    "/skipsl",
    "/?",
})
:adddescriptions({
    ["/f"] = { " file", "指定要获取所有权的文件或目录（支持通配符）" },
    ["/a"] = { "将所有权授予管理员组，而非当前用户" },
    ["/r"] = { "递归处理指定目录及其子目录" },
    ["/d"] = { " prompt", "递归时无访问权限的处理：Y 确认 / N 跳过" },
    ["/skipsl"] = { "递归时不跟随符号链接" },
    ["/?"] = { "显示帮助" },
})
