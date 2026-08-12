-- luacheck: no max line length
--------------------------------------------------------------------------------
-- npx.lua — 运行本地或远程 npm 包的命令

local freeform = clink.argmatcher():addarg({fromhistory=true})

clink.argmatcher("npx")
:addflags({
    "--package"..freeform,
    "-c"..freeform,
    "--call"..freeform,
    "-w"..freeform,
    "--workspace"..freeform,
    "--workspaces",
    "--include-workspace-root",
    "--allow-scripts"..freeform,
    "--strict-allow-scripts",
    "--dangerously-allow-all-scripts",
    "--no-install",
    "--yes",
    "--no",
    "--ignore-existing",
    "--quiet",
    "-h",
    "--help",
    "-v",
    "--version",
})
:addarg(freeform)
:adddescriptions({
    ["--package"] = { " spec", "指定要使用的包（可多次）" },
    ["-c"] = { " cmd", "执行字符串命令（如 -c \"tsc --version\"）" },
    ["--call"] = { " cmd", "执行字符串命令" },
    ["-w"] = { " workspace", "在指定工作区中执行" },
    ["--workspace"] = { " workspace", "在指定工作区中执行" },
    ["--workspaces"] = { "在所有配置的工作区中执行" },
    ["--include-workspace-root"] = { "启用工作区时包含工作区根" },
    ["--allow-scripts"] = { " pkgs", "允许指定包的安装生命周期脚本" },
    ["--strict-allow-scripts"] = { "将安装脚本策略从警告改为硬错误" },
    ["--dangerously-allow-all-scripts"] = { "允许所有包的安装脚本（危险）" },
    ["--no-install"] = { "如果包未安装则报错，不自动安装" },
    ["--yes"] = { "自动确认安装缺失的包" },
    ["--no"] = { "禁止自动安装（同 --no-install）" },
    ["--ignore-existing"] = { "忽略已安装的包，始终使用注册表" },
    ["--quiet"] = { "抑制输出" },
    ["-h"] = { "显示帮助" },
    ["--help"] = { "显示帮助" },
    ["-v"] = { "显示版本" },
    ["--version"] = { "显示版本" },
})
