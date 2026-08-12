-- luacheck: no max line length
--------------------------------------------------------------------------------
-- chkdsk.lua — 检查磁盘并显示状态报告（部分操作需管理员）

local freeform = clink.argmatcher():addarg({fromhistory=true})

clink.argmatcher("chkdsk")
:addarg(freeform)
:addflags({
    "/f",
    "/v",
    "/r",
    "/x",
    "/i",
    "/c",
    "/l"..freeform,
    "/b",
    "/scan",
    "/spotfix",
    "/sdcleanup",
    "/offlinescanandfix",
    "/perf",
    "/?",
})
:adddescriptions({
    ["/f"] = { "修复磁盘上的错误" },
    ["/v"] = { "检查时显示每个目录中的完整路径与名称" },
    ["/r"] = { "查找坏扇区并恢复可读信息（隐含 /f）" },
    ["/x"] = { "必要时先强制卸载卷（隐含 /f）" },
    ["/i"] = { "（仅 NTFS）跳过索引项检查" },
    ["/c"] = { "（仅 NTFS）跳过文件夹内的循环结构检查" },
    ["/l"] = { " size", "（仅 NTFS）设置日志文件大小（KB），省略则显示当前大小" },
    ["/b"] = { "（仅 NTFS）重新评估卷上的坏簇（隐含 /r）" },
    ["/scan"] = { "（仅 NTFS）在线扫描卷（需管理员）" },
    ["/spotfix"] = { "（仅 NTFS）在线修复发现的问题（需管理员）" },
    ["/sdcleanup"] = { "（仅 NTFS）清理无用安全描述符数据（隐含 /f）" },
    ["/offlinescanandfix"] = { "离线扫描并修复卷" },
    ["/perf"] = { "（仅 NTFS）扫描时使用更多系统资源，更快完成" },
    ["/?"] = { "显示帮助" },
})
