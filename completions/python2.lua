--------------------------------------------------------------------------------
-- python2.lua, Python 2 completion for Clink.
--
-- 用法：python2 [option] ... [-c cmd | -m mod | file | -] [arg] ...
-- 补全内容基于 `python2 --help` 输出。
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
-- python2 -m 常用可运行模块

local runnable_modules = {
    fromhistory=true,
    "SimpleHTTPServer", "json.tool", "pip", "unittest", "doctest", "pdb",
    "timeit", "cProfile", "profile", "compileall", "ensurepip", "smtpd",
    "Tkinter", "idlelib", "pydoc", "sysconfig", "site", "calendar", "this",
    "turtledemo",
}

local module_arg = clink.argmatcher():addarg(runnable_modules)

--------------------------------------------------------------------------------
-- 主解析器

clink.argmatcher("python2")
:_addexflags({
    opteq=true,
    { "-h",                     "显示帮助信息并退出" },
    { "--help",                 "显示帮助信息并退出" },
    { "-V",                     "输出版本信息并退出" },
    { "--version",              "输出版本信息并退出" },
    { "-c" .. freeform, " cmd", "将命令行中的字符串作为程序执行（终止选项列表）" },
    { "-m" .. module_arg, " mod", "将库模块作为脚本运行（终止选项列表）" },
    { "-i",                     "运行脚本后进入交互模式（即使 stdin 不是终端也强制提示符）" },
    { "-u",                     "强制 stdout 和 stderr 为非缓冲" },
    { "-O",                     "移除 assert 语句和 __debug__ 相关代码" },
    { "-OO",                    "同时移除文档字符串（docstring）" },
    { "-Q" .. freeform, " arg", "除法选项：-Qold（默认）、-Qwarn、-Qwarnall、-Qnew" },
    { "-s",                     "不将用户 site 目录添加到 sys.path" },
    { "-S",                     "初始化时不隐含导入 site 模块" },
    { "-E",                     "忽略所有 PYTHON* 环境变量" },
    { "-B",                     "导入时不写入 .pyc/.pyo 文件" },
    { "-b",                     "bytearray 与 unicode/bytes/int 比较时发出警告" },
    { "-bb",                    "bytearray 与 unicode/bytes/int 比较时报错" },
    { "-t",                     "对不一致的制表符用法发出警告" },
    { "-tt",                    "对不一致的制表符用法报错" },
    { "-3",                     "对 2to3 无法简单修复的 Python 3 不兼容性发出警告" },
    { "-d",                     "打开解析器调试输出（仅调试构建）" },
    { "-v",                     "详细模式：跟踪 import 语句" },
    { "-W" .. freeform, " arg", "警告控制：action:message:category:module:lineno" },
    { "-x",                     "跳过源文件第一行，允许非 Unix 形式的 #!cmd（已弃用）" },
})
:addarg(py_file)
:loop(1)
