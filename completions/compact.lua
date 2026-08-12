-- luacheck: no max line length
--------------------------------------------------------------------------------
-- compact.lua — 显示/更改 NTFS 分区上文件的压缩

clink.argmatcher("compact")
:addarg(clink.filematches)
:addflags({
    "/c",
    "/u",
    "/s"..clink.argmatcher():addarg({fromhistory=true}),
    "/a",
    "/i",
    "/f",
    "/q",
    "/exe",
    "/?",
})
:adddescriptions({
    ["/c"] = { "压缩指定文件/目录（新文件自动压缩）" },
    ["/u"] = { "解压缩指定文件/目录" },
    ["/s"] = { " dir", "递归处理指定目录" },
    ["/a"] = { "显示隐藏和系统文件" },
    ["/i"] = { "出错时继续执行" },
    ["/f"] = { "强制压缩（包括已压缩文件）" },
    ["/q"] = { "只报告最重要信息" },
    ["/exe"] = { "使用适合可执行文件的压缩算法" },
    ["/?"] = { "显示帮助" },
})
