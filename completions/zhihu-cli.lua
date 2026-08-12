--------------------------------------------------------------------------------
-- zhihu-cli.lua, Zhihu CLI completion for Clink.
--
-- zhihu-cli：知乎开放平台官方 CLI（Skill 版本 0.2.1）。
-- 命令结构基于 Skill 文档；answer 的模型/流式选项为推断值，
-- 实际以 `<CLI> answer --help` 输出为准。
--------------------------------------------------------------------------------

-- luacheck: no max line length

local arghelper = require('arghelper')

--------------------------------------------------------------------------------
-- 公共选项

local common_flags = {
    { "-h",        "显示帮助和使用信息" },
    { "--help",    "显示帮助和使用信息" },
    { "--version", "显示版本信息" },
}

--------------------------------------------------------------------------------
-- 通用参数

local freeform = clink.argmatcher():addarg({fromhistory=true})
local num_arg = clink.argmatcher():addarg({fromhistory=true})

--------------------------------------------------------------------------------
-- status / capabilities：无位置参数

local simple_parser = clink.argmatcher()
:_addexflags(common_flags)
:nofiles()

--------------------------------------------------------------------------------
-- auth：set / status

local auth_set_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--secret-stdin", "从标准输入读取 Access Secret（不回显、不写入命令行历史）" },
})
:nofiles()

local auth_status_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--verify", "发起一次本人内容请求以在线验证 Access Secret" },
})
:nofiles()

local auth_parser = clink.argmatcher()
:_addexflags(common_flags)
:_addexarg({
    { "set" .. auth_set_parser,    "配置 Access Secret" },
    { "status" .. auth_status_parser, "查看认证状态（可用 --verify 在线验证）" },
})
:nofiles()

--------------------------------------------------------------------------------
-- search：zhihu / global

local search_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--query" .. freeform, " query", "搜索关键词（必填）" },
    { "--count" .. num_arg,  " count", "返回结果数量（默认 10）" },
})
:_addexarg({
    { "zhihu", "搜索知乎社区内容（回答、文章、真实经验与观点）" },
    { "global", "搜索知乎之外的全网来源（新闻、官网、权威资料）" },
})
:nofiles()

--------------------------------------------------------------------------------
-- hot

local hot_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--limit" .. num_arg, " limit", "返回热榜条目数量（默认 20）" },
})
:nofiles()

--------------------------------------------------------------------------------
-- answer：知乎直答（模型选项为推断，请以 answer --help 为准）

local answer_model = clink.argmatcher():addarg({ "quick", "deep", "smart", fromhistory=true })

local answer_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--query" .. freeform,     " query", "要回答的问题（必填）" },
    { "--model" .. answer_model, " model", "切换直答模型：quick（快速）/ deep（深度思考）/ smart（智能检索）" },
    { "--stream",                         "以流式方式输出答案" },
})
:nofiles()

--------------------------------------------------------------------------------
-- me：contents / followees / favorites

local me_type = clink.argmatcher():addarg({ "all", "article", "answer", "pin", "video", fromhistory=true })
local me_sort = clink.argmatcher():addarg({ "ts", fromhistory=true })
local me_order = clink.argmatcher():addarg({ "desc", "asc" })

local me_contents_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--type" .. me_type,   " type",   "内容类型：all（全部）/ article（文章）/ answer（回答）/ pin（想法）/ video（视频）" },
    { "--sort" .. me_sort,   " sort",   "排序字段（默认 ts 时间戳）" },
    { "--order" .. me_order, " order",  "排序方向：desc（降序，默认）/ asc（升序）" },
    { "--offset" .. num_arg, " offset", "分页偏移（默认 0）" },
    { "--limit" .. num_arg,  " limit",  "返回条数（默认 20）" },
})
:nofiles()

local me_followees_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--offset" .. num_arg, " offset", "分页偏移（默认 0）" },
    { "--limit" .. num_arg,  " limit",  "返回条数（默认 20）" },
})
:nofiles()

local me_favorites_recent_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--limit" .. num_arg, " limit", "返回条数（默认 20）；recent 无分页，不等于完整历史" },
})
:nofiles()

local me_favorites_lists_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--limit" .. num_arg, " limit", "返回条数（默认 20）；收藏夹列表无分页，服务端忽略 Offset" },
})
:nofiles()

local me_favorites_items_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--url-token" .. freeform, " url-token", "收藏夹的 URL Token（必填，来自 favorites lists）" },
    { "--offset" .. num_arg,     " offset",    "分页偏移（默认 0）" },
    { "--limit" .. num_arg,      " limit",     "返回条数（默认 20）" },
})
:nofiles()

local me_favorites_parser = clink.argmatcher()
:_addexflags(common_flags)
:_addexarg({
    { "recent" .. me_favorites_recent_parser, "查看近期收藏（无分页，非完整历史）" },
    { "lists" .. me_favorites_lists_parser,   "查看我的收藏夹列表（获取 URL Token）" },
    { "items" .. me_favorites_items_parser,   "查看指定收藏夹中的内容" },
})
:nofiles()

local me_parser = clink.argmatcher()
:_addexflags(common_flags)
:_addexarg({
    { "contents" .. me_contents_parser,   "查看我的创作（标题与摘要）" },
    { "followees" .. me_followees_parser, "查看我的关注" },
    { "favorites" .. me_favorites_parser, "查看我的收藏" },
})
:nofiles()

--------------------------------------------------------------------------------
-- 主解析器

clink.argmatcher("zhihu-cli")
:_addexflags(common_flags)
:_addexarg({
    { "status" .. simple_parser,       "检查 CLI 的安装与兼容性状态" },
    { "capabilities" .. simple_parser, "输出机器可解析的能力清单" },
    { "auth" .. auth_parser,           "配置与验证 Access Secret" },
    { "search" .. search_parser,       "搜索知乎或全网内容" },
    { "hot" .. hot_parser,             "获取知乎热榜" },
    { "answer" .. answer_parser,       "调用知乎直答" },
    { "me" .. me_parser,               "查看我的创作、关注与收藏" },
})
:nofiles()
