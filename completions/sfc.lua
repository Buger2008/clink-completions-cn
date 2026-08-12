-- luacheck: no max line length
--------------------------------------------------------------------------------
-- sfc.lua — 系统文件检查（需要管理员）

clink.argmatcher("sfc")
:addflags({
    "/scannow",
    "/verifyonly",
    "/scanfile"..clink.argmatcher():addarg(clink.filematches),
    "/verifyfile"..clink.argmatcher():addarg(clink.filematches),
    "/offbootdir"..clink.argmatcher():addarg(clink.dirmatches),
    "/offwindir"..clink.argmatcher():addarg(clink.dirmatches),
    "/?",
})
:adddescriptions({
    ["/scannow"] = { "扫描所有受保护系统文件的完整性并修复（需管理员）" },
    ["/verifyonly"] = { "只检查完整性，不修复" },
    ["/scanfile"] = { " file", "扫描指定文件并修复" },
    ["/verifyfile"] = { " file", "只验证指定文件，不修复" },
    ["/offbootdir"] = { " dir", "离线修复时指定引导目录" },
    ["/offwindir"] = { " dir", "离线修复时指定 Windows 目录" },
    ["/?"] = { "显示帮助" },
})
