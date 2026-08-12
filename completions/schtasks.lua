-- luacheck: no max line length
--------------------------------------------------------------------------------
-- schtasks.lua — 计划任务（创建/修改需管理员）

local freeform = clink.argmatcher():addarg({fromhistory=true})

local create_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    { "/tn"..freeform,          " name",   "任务名称（必填）" },
    { "/tr"..freeform,          " cmd",    "要运行的程序/命令" },
    { "/sc"..freeform,          " sched",  "计划类型：ONCE / DAILY / WEEKLY / MONTHLY / ONLOGON / ONSTART / ONIDLE 等" },
    { "/mo"..freeform,          " modifier", "计划频率修饰符" },
    { "/d"..freeform,           " days",   "每周/每月的日期" },
    { "/st"..freeform,          " time",   "开始时间 HH:MM" },
    { "/et"..freeform,          " time",   "结束时间" },
    { "/du"..freeform,          " dur",    "持续时间" },
    { "/k",                               "到时结束任务" },
    { "/sd"..freeform,          " date",   "开始日期 MM/DD/YYYY" },
    { "/ed"..freeform,          " date",   "结束日期" },
    { "/ru"..freeform,          " user",   "运行用户" },
    { "/rp"..freeform,          " pass",   "用户密码" },
    { "/it",                              "仅当用户登录时运行" },
    { "/f",                               "强制创建（覆盖同名任务）" },
    { "/rl"..freeform,          " level",  "运行级别：LIMITED / HIGHEST" },
    { "/delayed"..freeform,     " min",    "延迟运行分钟数" },
})
:nofiles()

local common_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    { "/tn"..freeform,   " name",    "任务名称" },
    { "/s"..freeform,    " system",  "远程系统" },
    { "/u"..freeform,    " user",    "用户" },
    { "/p"..freeform,    " pass",    "密码" },
    { "/fo"..freeform,   " format",  "输出格式：TABLE / LIST / CSV" },
    { "/nh",                        "无列标题" },
    { "/v",                         "详细信息" },
    { "/?",                         "显示帮助" },
})
:nofiles()

clink.argmatcher("schtasks")
:_addexflags({
    opteq=true,
    { "/?", "显示帮助" },
})
:_addexarg({
    { "create" .. create_parser,  "创建计划任务" },
    { "query" .. common_parser,   "查询计划任务" },
    { "delete" .. common_parser,  "删除计划任务（加 /f 强制）" },
    { "change" .. common_parser,  "修改计划任务" },
    { "run" .. common_parser,     "立即运行任务" },
    { "end" .. common_parser,     "停止任务" },
})
:nofiles()
