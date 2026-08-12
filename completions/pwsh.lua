-- luacheck: no max line length
--------------------------------------------------------------------------------
-- pwsh.lua — PowerShell 7（pwsh）
-- 用法: pwsh [-Login] [[-File] <filePath> [args]] [-Command { - | <script> }] [...]

local freeform = clink.argmatcher():addarg({fromhistory=true})
local file = clink.argmatcher():addarg(clink.filematches)

local exec_policy = clink.argmatcher():addarg({ "Bypass", "Unrestricted", "RemoteSigned", "Restricted", "AllSigned", fromhistory=true })
local fmt = clink.argmatcher():addarg({ "Text", "XML" })
local style = clink.argmatcher():addarg({ "Normal", "Hidden", "Minimized", "Maximized" })

clink.argmatcher("pwsh")
:addflags({
    "-login",
    "-f"..file,
    "-file"..file,
    "-command"..freeform,
    "-c"..freeform,
    "-commandwithargs"..freeform,
    "-configurationname"..freeform,
    "-configurationfile"..file,
    "-custompipename"..freeform,
    "-encodedcommand"..freeform,
    "-e"..freeform,
    "-executionpolicy"..exec_policy,
    "-ep"..exec_policy,
    "-inputformat"..fmt,
    "-outputformat"..fmt,
    "-interactive",
    "-i",
    "-mta",
    "-sta",
    "-noexit",
    "-nologo",
    "-noninteractive",
    "-noprofile",
    "-nop",
    "-noprofileloadtime",
    "-settingsfile"..file,
    "-sshservermode",
    "-version",
    "-v",
    "-windowstyle"..style,
    "-workingdirectory"..clink.argmatcher():addarg(clink.dirmatches),
    "-wd"..clink.argmatcher():addarg(clink.dirmatches),
    "-help",
    "-h",
    "-?",
    "/?",
})
:addarg(file)
:adddescriptions({
    ["-login"] = { "以登录 shell 启动（加载登录配置文件）" },
    ["-f"] = { " file", "运行指定脚本文件（必须是最后一个参数）" },
    ["-file"] = { " file", "运行指定脚本文件" },
    ["-command"] = { " cmd", "执行命令字符串（- 表示从标准输入读取）" },
    ["-c"] = { " cmd", "执行命令字符串" },
    ["-commandwithargs"] = { " cmd", "执行命令并传递参数" },
    ["-configurationname"] = { " name", "启动指定配置" },
    ["-configurationfile"] = { " file", "从文件启动指定配置" },
    ["-custompipename"] = { " name", "指定自定义管道名称（远程连接）" },
    ["-encodedcommand"] = { " base64", "执行 Base64 编码的命令" },
    ["-e"] = { " base64", "执行 Base64 编码的命令" },
    ["-executionpolicy"] = { " policy", "执行策略：Bypass / Unrestricted / RemoteSigned / Restricted / AllSigned" },
    ["-ep"] = { " policy", "执行策略" },
    ["-inputformat"] = { " fmt", "输入格式：Text / XML" },
    ["-outputformat"] = { " fmt", "输出格式：Text / XML" },
    ["-interactive"] = { "交互模式" },
    ["-i"] = { "交互模式" },
    ["-mta"] = { "以多线程单元（MTA）启动" },
    ["-sta"] = { "以单线程单元（STA）启动" },
    ["-noexit"] = { "命令执行后不退出" },
    ["-nologo"] = { "启动时不显示横幅" },
    ["-noninteractive"] = { "非交互模式" },
    ["-noprofile"] = { "不加载配置文件" },
    ["-nop"] = { "不加载配置文件" },
    ["-noprofileloadtime"] = { "不显示配置文件加载时间" },
    ["-settingsfile"] = { " file", "从文件加载设置" },
    ["-sshservermode"] = { "SSH 服务器模式" },
    ["-version"] = { "显示版本" },
    ["-v"] = { "显示版本" },
    ["-windowstyle"] = { " style", "窗口样式：Normal / Hidden / Minimized / Maximized" },
    ["-workingdirectory"] = { " dir", "指定工作目录" },
    ["-wd"] = { " dir", "指定工作目录" },
    ["-help"] = { "显示帮助" },
    ["-h"] = { "显示帮助" },
    ["-?"] = { "显示帮助" },
})
