-- luacheck: no max line length
--------------------------------------------------------------------------------
-- diskpart.lua — 磁盘分区管理（交互式，需管理员）

local freeform = clink.argmatcher():addarg({fromhistory=true})

-- select / detail / delete：后接 disk n | volume n | partition n
local select_parser = clink.argmatcher()
:_addexarg({
    { "disk" .. freeform,      " <n>", "选择/显示磁盘编号" },
    { "volume" .. freeform,    " <n>", "选择/显示卷编号" },
    { "partition" .. freeform, " <n>", "选择/显示分区编号" },
})
:nofiles()

-- list：disk | volume | partition
local list_parser = clink.argmatcher()
:_addexarg({
    { "disk",     "列出磁盘" },
    { "volume",   "列出卷" },
    { "partition", "列出当前磁盘的分区" },
})
:nofiles()

-- create：partition / volume / vdisk
local create_parser = clink.argmatcher()
:_addexarg({
    { "partition" .. freeform, " <type>", "创建分区：primary / extended / logical" },
    { "volume" .. freeform,    " <type>", "创建卷：simple / stripe / mirror / raid" },
    { "vdisk" .. freeform,     " <type>", "创建虚拟磁盘：file" },
})
:nofiles()

-- format：fs= 与 quick/compress 等参数
local format_parser = clink.argmatcher()
:addarg({ "fs=ntfs", "fs=fat32", "fs=exfat", "fs=refs", "quick", "compress", fromhistory=true })
:nofiles()

-- assign / remove：letter=X / mount=path
local assign_parser = clink.argmatcher()
:addarg({ "letter=", "mount=", fromhistory=true })
:nofiles()

clink.argmatcher("diskpart")
:addflags({
    "/s",
    "/?",
})
:_addexarg({
    { "list" .. list_parser,         "列出磁盘/卷/分区" },
    { "select" .. select_parser,     "选择磁盘/卷/分区" },
    { "detail" .. select_parser,     "显示选中对象的详细信息" },
    { "create" .. create_parser,     "创建分区/卷" },
    { "delete" .. select_parser,     "删除选中的分区/卷" },
    { "clean",                       "清除磁盘上的所有分区（危险！）" },
    { "format" .. format_parser,     "格式化选中卷" },
    { "assign" .. assign_parser,     "分配盘符或挂载点" },
    { "remove" .. assign_parser,     "移除盘符或挂载点" },
    { "active",                      "将选中分区标记为活动" },
    { "inactive",                    "取消活动标记" },
    { "extend",                      "扩展选中卷" },
    { "shrink",                      "收缩选中卷" },
    { "convert",                     "转换磁盘格式（mbr / gpt / dynamic / basic）" },
    { "rescan",                      "重新扫描磁盘" },
    { "online",                      "联机磁盘/卷" },
    { "offline",                     "脱机磁盘/卷" },
    { "attributes",                  "磁盘/卷属性" },
    { "exit",                        "退出 diskpart" },
})
:adddescriptions({
    ["/s"] = { " script", "执行脚本文件" },
    ["/?"] = { "显示帮助" },
})
