-- luacheck: no max line length
--------------------------------------------------------------------------------
-- cmake.lua — CMake 构建系统

local freeform = clink.argmatcher():addarg({fromhistory=true})
local dir = clink.argmatcher():addarg(clink.dirmatches)
local file = clink.argmatcher():addarg(clink.filematches)

local build_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    { "--build"..dir,            " dir",      "构建指定目录（生成器模式）" },
    { "--target"..freeform,      " target",   "构建指定目标" },
    { "-j"..freeform,            " n",        "并行任务数" },
    { "--config"..freeform,      " config",   "构建配置：Debug / Release / RelWithDebInfo / MinSizeRel" },
    { "--clean-first",                       "先清理再构建" },
    { "--verbose",                           "详细输出" },
})
:nofiles()

local install_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    { "--install"..dir,          " dir",      "安装到指定目录" },
    { "--config"..freeform,      " config",   "安装配置" },
    { "--component"..freeform,   " comp",     "只安装指定组件" },
    { "--prefix"..dir,           " dir",      "安装前缀" },
})
:nofiles()

local regen_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    { "-S"..dir,                 " src",      "指定源码目录" },
    { "-B"..dir,                 " build",    "指定构建目录" },
    { "-C"..file,                " cache",    "预加载缓存脚本" },
    { "-D"..freeform,            " var",      "设置缓存变量，如 -DCMAKE_BUILD_TYPE=Release" },
    { "-U"..freeform,            " glob",     "从缓存删除匹配项" },
    { "-G"..freeform,            " gen",      "生成器：MinGW Makefiles / Ninja / Visual Studio 17 2022" },
    { "-T"..freeform,            " toolset",  "工具集名称" },
    { "-A"..freeform,            " platform", "平台名称（如 x64 / Win32）" },
    { "--toolchain"..file,       " file",     "工具链文件" },
    { "--install-prefix"..dir,   " dir",      "安装目录" },
    { "-Wdev",                              "启用开发者警告" },
    { "-Wno-dev",                           "抑制开发者警告" },
    { "-Werror=dev",                        "将开发者警告视为错误" },
    { "--debug-output",                     "输出调试信息" },
    { "--trace",                            "跟踪 cmake 脚本执行" },
    { "--trace-expand",                     "展开变量的跟踪" },
    { "--warn-uninitialized",               "警告未初始化的变量" },
    { "-E",                                 "平台无关命令模式（cmake -E help）" },
    { "-P"..file,                           "以脚本模式运行 cmake 脚本" },
    { "--help",                             "显示帮助" },
})
:nofiles()

clink.argmatcher("cmake")
:_addexflags({
    opteq=true,
    { "--version",  "显示版本" },
    { "--help",     "显示帮助" },
})
:_addexarg({
    { "--build"..build_parser,    "构建模式：cmake --build <dir>" },
    { "--install"..install_parser,"安装模式：cmake --install <dir>" },
    { "--open"..dir,              "打开项目（IDE 生成器）" },
    { "--find-package",           "查找包模式" },
    { "--graphviz"..freeform,     "生成依赖图 dot 文件" },
    { "--list-presets",           "列出可用的预设" },
    { "--preset"..freeform,       "使用指定预设" },
})
:addarg(regen_parser)
:addarg(freeform)
