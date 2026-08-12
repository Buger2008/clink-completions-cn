--------------------------------------------------------------------------------
-- python3.lua, Python 3 completion for Clink.
--
-- 用法：python3 [option] ... [-c cmd | -m mod | file | -] [arg] ...
-- 补全内容基于 `python3 --help` 输出。
--------------------------------------------------------------------------------

-- luacheck: no max line length

local arghelper = require('arghelper')

--------------------------------------------------------------------------------
-- 文件匹配

local function python_file_matches(word)
    if clink.filematchesexact then
        local matches = clink.dirmatches(word) or {}
        for _, m in ipairs(clink.filematchesexact(word.."*.py")) do
            table.insert(matches, m)
        end
        return matches
    else
        return clink.filematches(word)
    end
end

local py_file = clink.argmatcher():addarg({python_file_matches, "-"})
local freeform = clink.argmatcher():addarg({fromhistory=true})

--------------------------------------------------------------------------------
-- python -m 常用可运行模块

local runnable_modules = {
    fromhistory=true,
    "http.server", "json.tool", "venv", "pip", "unittest", "doctest",
    "pdb", "timeit", "cProfile", "profile", "compileall", "ensurepip",
    "zipapp", "xmlrpc.server", "smtpd", "tkinter", "idlelib", "pydoc",
    "sysconfig", "site", "calendar", "this", "turtledemo",
}

local module_arg = clink.argmatcher():addarg(runnable_modules)

--------------------------------------------------------------------------------
-- 主解析器

clink.argmatcher("python3")
:_addexflags({
    opteq=true,
    { "-h",                     "显示帮助信息并退出" },
    { "--help",                 "显示帮助信息并退出" },
    { "-V",                     "输出版本信息并退出（-VV 显示更多构建信息）" },
    { "--version",              "输出版本信息并退出" },
    { "-c" .. freeform, " cmd", "将命令行中的字符串作为程序执行（终止选项列表）" },
    { "-m" .. module_arg, " mod", "将库模块作为脚本运行（终止选项列表）" },
    { "-i",                     "运行脚本后进入交互模式（即使 stdin 不是终端也强制提示符）" },
    { "-I",                     "隔离 Python 与用户环境（隐含 -E 和 -s）" },
    { "-u",                     "强制 stdout 和 stderr 为非缓冲" },
    { "-O",                     "移除 assert 语句和 __debug__ 相关代码" },
    { "-OO",                    "同时移除文档字符串（docstring）" },
    { "-q",                     "交互启动时不打印版本和版权信息" },
    { "-s",                     "不将用户 site 目录添加到 sys.path" },
    { "-S",                     "初始化时不隐含导入 site 模块" },
    { "-E",                     "忽略所有 PYTHON* 环境变量" },
    { "-B",                     "导入时不写入 .pyc 文件" },
    { "-b",                     "str 与 bytes/bytearray 比较或转换时发出警告" },
    { "-bb",                    "str 与 bytes/bytearray 比较或转换时报错" },
    { "-d",                     "打开解析器调试输出（仅调试构建）" },
    { "-v",                     "详细模式：每次初始化模块时打印加载位置" },
    { "-W" .. freeform, " arg", "警告控制：action:message:category:module:lineno" },
    { "-X" .. freeform, " opt", "实现特定选项（如 -X dev、-X utf8）" },
    { "--check-hash-based-pycs" .. freeform, " arg", "控制 hash 型 .pyc 文件的校验：always|default|never" },
})
:addarg(py_file)
:loop(1)
