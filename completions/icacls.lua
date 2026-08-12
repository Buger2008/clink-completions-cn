-- luacheck: no max line length
--------------------------------------------------------------------------------
-- icacls.lua — 显示/修改文件与目录的 ACL

local freeform = clink.argmatcher():addarg({fromhistory=true})

local perm = freeform -- 如 user:(OI)(CI)F

clink.argmatcher("icacls")
:addarg(clink.filematches)
:addflags({
    "/grant"..perm,
    "/deny"..perm,
    "/remove"..perm,
    "/setowner"..perm,
    "/t",
    "/c",
    "/q",
    "/l",
    "/inheritance"..clink.argmatcher():addarg({ "r", "d", "e" }),
    "/restore"..clink.argmatcher():addarg(clink.filematches),
    "/save"..clink.argmatcher():addarg(clink.filematches),
    "/verify",
    "/reset",
    "/?",
})
:adddescriptions({
    ["/grant"] = { " r", "授予权限，如 /grant user:(OI)(CI)F；可加 :t 追加" },
    ["/deny"] = { " r", "显式拒绝权限" },
    ["/remove"] = { " r", "移除用户权限" },
    ["/setowner"] = { " user", "设置所有者" },
    ["/t"] = { "递归处理所有子目录和文件" },
    ["/c"] = { "出错时继续（忽略错误）" },
    ["/q"] = { "安静模式（不显示成功消息）" },
    ["/l"] = { "对符号链接本身操作，不跟随" },
    ["/inheritance"] = { " mode", "继承设置：r（复制并禁用继承）/ d（移除继承）/ e（启用继承）" },
    ["/restore"] = { " file", "从备份文件恢复 ACL" },
    ["/save"] = { " file", "将 ACL 保存到文件（与 /t 联用）" },
    ["/verify"] = { "检查所有 ACL 的一致性" },
    ["/reset"] = { "将 ACL 替换为默认继承值" },
    ["/?"] = { "显示帮助" },
})
