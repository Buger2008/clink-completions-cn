-- luacheck: no max line length
--------------------------------------------------------------------------------
-- sc.lua — 服务控制（修改需管理员）

local freeform = clink.argmatcher():addarg({fromhistory=true})

local service_parser = clink.argmatcher()
:addarg(freeform)

local query_parser = clink.argmatcher()
:addarg({ "type=", "state=", "bufsize=", "ri=", "group=", fromhistory=true })
:nofiles()

local config_parser = clink.argmatcher()
:addarg({ "type=", "start=", "error=", "binPath=", "group=", "tag=", "depend=", "obj=", "displayname=", "password=", fromhistory=true })
:nofiles()

clink.argmatcher("sc")
:_addexflags({
    opteq=true,
    { "/?",            "显示帮助" },
})
:_addexarg({
    { "query" .. query_parser,            "查询服务状态" },
    { "queryex" .. query_parser,          "查询服务扩展状态" },
    { "start" .. service_parser,          "启动服务" },
    { "stop" .. service_parser,           "停止服务" },
    { "pause" .. service_parser,          "暂停服务" },
    { "continue" .. service_parser,       "恢复暂停的服务" },
    { "config" .. config_parser,          "修改服务配置" },
    { "description" .. service_parser,    "设置服务描述" },
    { "qdescription" .. service_parser,   "查询服务描述" },
    { "failure" .. service_parser,        "设置失败恢复操作" },
    { "qfailure" .. service_parser,       "查询失败恢复操作" },
    { "qc" .. service_parser,             "查询服务配置" },
    { "sdshow" .. service_parser,         "显示服务安全描述符" },
    { "sdset" .. service_parser,          "设置服务安全描述符" },
    { "privs" .. service_parser,          "设置服务所需权限" },
    { "qprivs" .. service_parser,         "查询服务所需权限" },
    { "sidtype" .. service_parser,        "设置服务 SID 类型" },
    { "qsidtype" .. service_parser,       "查询服务 SID 类型" },
    { "qc" .. service_parser,             "查询服务配置" },
    { "querylock" .. service_parser,      "查询服务数据库锁定状态" },
    { "getkeyname" .. service_parser,     "获取服务的键名" },
    { "control" .. service_parser,        "发送控制命令给服务" },
})
:nofiles()
