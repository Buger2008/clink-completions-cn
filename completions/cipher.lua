-- luacheck: no max line length
--------------------------------------------------------------------------------
-- cipher.lua — 显示/更改 NTFS 卷上目录的加密（EFS）

local freeform = clink.argmatcher():addarg({fromhistory=true})

clink.argmatcher("cipher")
:addarg(clink.filematches)
:addflags({
    "/e",
    "/d",
    "/c",
    "/u",
    "/k",
    "/r"..freeform,
    "/w"..freeform,
    "/x"..freeform,
    "/a",
    "/i",
    "/f",
    "/q",
    "/h",
    "/s"..freeform,
    "/?",
})
:adddescriptions({
    ["/e"] = { "加密指定目录（新文件自动加密）" },
    ["/d"] = { "解密指定目录" },
    ["/c"] = { "显示文件或目录的加密信息" },
    ["/u"] = { "尝试更新所有加密文件的密钥" },
    ["/k"] = { "为当前用户生成新的证书和密钥" },
    ["/r"] = { " filename", "生成 EFS 恢复代理证书和密钥到文件" },
    ["/w"] = { " dir", "删除未使用数据（可安全删除已删除文件的剩余数据）" },
    ["/x"] = { " file", "备份 EFS 证书和密钥到文件" },
    ["/a"] = { "对目录及其内容操作" },
    ["/i"] = { "出错时继续执行" },
    ["/f"] = { "强制对已加密文件执行操作" },
    ["/q"] = { "安静模式（仅报告最重要信息）" },
    ["/h"] = { "显示隐藏文件" },
    ["/s"] = { " dir", "递归处理指定目录" },
    ["/?"] = { "显示帮助" },
})
