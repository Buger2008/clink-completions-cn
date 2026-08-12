--------------------------------------------------------------------------------
-- dism.lua, DISM（部署映像服务和管理工具）completion for Clink.
--
-- 用法：
--   dism /Online [/Cleanup-Image /StartComponentCleanup ...]
--   dism /Image:C:\offline /Add-Package /PackagePath:xxx.cab
--   dism /Get-WimInfo /WimFile:install.wim /Index:1
--
-- 补全内容基于 `dism /?` 与 `dism /Online /?` 输出（Windows 10.0.26100）。
-- DISM 的所有命令与选项均以 / 开头，因此这里全部作为 flag 处理，
-- 每个命令链接到各自的子解析器以提供命令级参数。
--------------------------------------------------------------------------------

-- luacheck: no max line length

local arghelper = require('arghelper')

--------------------------------------------------------------------------------
-- 参数匹配器

local file_arg = clink.argmatcher():addarg(clink.filematches)
local dir_arg = clink.argmatcher():addarg(clink.dirmatches)
local num_arg = clink.argmatcher():addarg({fromhistory=true})
local name_arg = clink.argmatcher():addarg({fromhistory=true})
local lang_arg = clink.argmatcher():addarg({fromhistory=true})
local format_arg = clink.argmatcher():addarg({ "Table", "List" })
local compress_arg = clink.argmatcher():addarg({ "max", "fast", "none" })

--------------------------------------------------------------------------------
-- 常用选项组（每个命令都可用）

local format_flags = {
    { "/Format" .. format_arg, " <Table|List>", "指定报告输出格式" },
    { "/Format:" .. format_arg, " <Table|List>", "指定报告输出格式" },
}

local imagefile_flags = {
    { "/ImageFile" .. file_arg, " <path>", "指定映像文件" },
    { "/ImageFile:" .. file_arg, " <path>", "指定映像文件" },
}

local index_flags = {
    { "/Index" .. num_arg, " <n>", "指定映像索引" },
    { "/Index:" .. num_arg, " <n>", "指定映像索引" },
}

local name_flags = {
    { "/Name" .. name_arg, " <name>", "指定映像名称" },
    { "/Name:" .. name_arg, " <name>", "指定映像名称" },
}

local mountdir_flags = {
    { "/MountDir" .. dir_arg, " <path>", "指定挂载目录" },
    { "/MountDir:" .. dir_arg, " <path>", "指定挂载目录" },
}

local source_flags = {
    { "/Source" .. file_arg, " <path>", "指定修复源文件的位置" },
    { "/Source:" .. file_arg, " <path>", "指定修复源文件的位置" },
    { "/LimitAccess", "阻止 DISM 联系 Windows 更新/WSUS" },
}

local common_flags = {
    { "/English",    "用英文显示命令行输出" },
    format_flags,
    { "/WinDir" .. dir_arg, " <path>", "指定 Windows 目录的路径" },
    { "/WinDir:" .. dir_arg, " <path>", "指定 Windows 目录的路径" },
    { "/SysDriveDir" .. dir_arg, " <path>", "指定名为 BootMgr 的系统加载程序文件的路径" },
    { "/SysDriveDir:" .. dir_arg, " <path>", "指定名为 BootMgr 的系统加载程序文件的路径" },
    { "/LogPath" .. file_arg, " <path>", "指定日志文件路径" },
    { "/LogPath:" .. file_arg, " <path>", "指定日志文件路径" },
    { "/LogLevel" .. num_arg, " <1-4>", "指定日志中显示的输出级别（1-4）" },
    { "/LogLevel:" .. num_arg, " <1-4>", "指定日志中显示的输出级别（1-4）" },
    { "/NoRestart",  "取消自动重新启动和重新启动提示" },
    { "/Quiet",      "取消除错误消息之外的所有输出" },
    { "/ScratchDir" .. dir_arg, " <path>", "指定暂存目录的路径" },
    { "/ScratchDir:" .. dir_arg, " <path>", "指定暂存目录的路径" },
    { "/Online",     "以正在运行的操作系统为目标" },
    { "/Image" .. dir_arg, " <path>", "指定脱机 Windows 映像的根目录路径" },
    { "/Image:" .. dir_arg, " <path>", "指定脱机 Windows 映像的根目录路径" },
    { "/?",          "显示帮助" },
}

-- 无额外参数的命令
local plain_parser = clink.argmatcher()
:_addexflags(common_flags)
:nofiles()

--------------------------------------------------------------------------------
-- FFU 命令

local capture_ffu_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    imagefile_flags,
    { "/CaptureDir" .. dir_arg, " <path>", "指定捕获目录" },
    { "/CaptureDir:" .. dir_arg, " <path>", "指定捕获目录" },
    { "/Verify",     "验证捕获的文件" },
})
:nofiles()

local apply_ffu_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    imagefile_flags,
    { "/ApplyDir" .. dir_arg, " <path>", "指定应用目录" },
    { "/ApplyDir:" .. dir_arg, " <path>", "指定应用目录" },
    { "/Verify",     "验证应用的文件" },
})
:nofiles()

local split_ffu_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    imagefile_flags,
    { "/FFUFile" .. file_arg, " <file>", "指定目标 FFU 文件" },
    { "/FFUFile:" .. file_arg, " <file>", "指定目标 FFU 文件" },
    { "/FileSize" .. num_arg, " <MB>", "指定拆分文件的最大大小（MB）" },
    { "/FileSize:" .. num_arg, " <MB>", "指定拆分文件的最大大小（MB）" },
})
:nofiles()

local optimize_ffu_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    imagefile_flags,
    { "/Verify",     "验证文件" },
})
:nofiles()

--------------------------------------------------------------------------------
-- WIM 命令

local apply_customdata_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    imagefile_flags,
    { "/CustomDataImage" .. file_arg, " <path>", "指定自定义数据映像文件" },
    { "/CustomDataImage:" .. file_arg, " <path>", "指定自定义数据映像文件" },
    index_flags,
})
:nofiles()

local capture_customimage_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/CaptureDir" .. dir_arg, " <path>", "指定捕获目录" },
    { "/CaptureDir:" .. dir_arg, " <path>", "指定捕获目录" },
})
:nofiles()

local get_wimbootentry_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/Path" .. file_arg, " <path>", "指定磁盘卷的路径" },
    { "/Path:" .. file_arg, " <path>", "指定磁盘卷的路径" },
})
:nofiles()

local update_wimbootentry_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/Path" .. file_arg, " <path>", "指定磁盘卷的路径" },
    { "/Path:" .. file_arg, " <path>", "指定磁盘卷的路径" },
    { "/DataImagePath" .. file_arg, " <path>", "指定数据映像的路径" },
    { "/DataImagePath:" .. file_arg, " <path>", "指定数据映像的路径" },
    { "/DataImageIndex" .. num_arg, " <n>", "指定数据映像的索引" },
    { "/DataImageIndex:" .. num_arg, " <n>", "指定数据映像的索引" },
})
:nofiles()

local list_image_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    imagefile_flags,
    index_flags,
})
:nofiles()

local delete_image_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    imagefile_flags,
    index_flags,
})
:nofiles()

local export_image_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/SourceImageFile" .. file_arg, " <path>", "指定源映像文件" },
    { "/SourceImageFile:" .. file_arg, " <path>", "指定源映像文件" },
    { "/SourceIndex" .. num_arg, " <n>", "指定源映像索引" },
    { "/SourceIndex:" .. num_arg, " <n>", "指定源映像索引" },
    { "/DestinationImageFile" .. file_arg, " <path>", "指定目标映像文件" },
    { "/DestinationImageFile:" .. file_arg, " <path>", "指定目标映像文件" },
    { "/DestinationName" .. name_arg, " <name>", "指定目标映像名称" },
    { "/DestinationName:" .. name_arg, " <name>", "指定目标映像名称" },
    { "/Compress" .. compress_arg, " <max|fast|none>", "指定压缩类型" },
    { "/Compress:" .. compress_arg, " <max|fast|none>", "指定压缩类型" },
    { "/Bootable",   "将映像标记为可启动" },
    { "/CheckIntegrity", "检测并跟踪 WIM 文件的损坏" },
    { "/Verify",     "验证映像文件" },
    { "/NoRpFix",    "禁用重解析点标记修复" },
})
:nofiles()

local append_image_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    imagefile_flags,
    { "/CaptureDir" .. dir_arg, " <path>", "指定捕获目录" },
    { "/CaptureDir:" .. dir_arg, " <path>", "指定捕获目录" },
    name_flags,
    { "/Description" .. name_arg, " <desc>", "指定映像描述" },
    { "/Description:" .. name_arg, " <desc>", "指定映像描述" },
    { "/CheckIntegrity", "检测并跟踪 WIM 文件的损坏" },
    { "/Verify",     "验证映像文件" },
    { "/NoRpFix",    "禁用重解析点标记修复" },
    { "/EA",         "捕获扩展属性" },
})
:nofiles()

local capture_image_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    imagefile_flags,
    { "/CaptureDir" .. dir_arg, " <path>", "指定捕获目录" },
    { "/CaptureDir:" .. dir_arg, " <path>", "指定捕获目录" },
    name_flags,
    { "/Description" .. name_arg, " <desc>", "指定映像描述" },
    { "/Description:" .. name_arg, " <desc>", "指定映像描述" },
    { "/Compress" .. compress_arg, " <max|fast|none>", "指定压缩类型" },
    { "/Compress:" .. compress_arg, " <max|fast|none>", "指定压缩类型" },
    { "/Bootable",   "将映像标记为可启动" },
    { "/CheckIntegrity", "检测并跟踪 WIM 文件的损坏" },
    { "/Verify",     "验证映像文件" },
    { "/NoRpFix",    "禁用重解析点标记修复" },
    { "/EA",         "捕获扩展属性" },
})
:nofiles()

local get_wiminfo_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/WimFile" .. file_arg, " <file>", "指定 WIM 文件" },
    { "/WimFile:" .. file_arg, " <file>", "指定 WIM 文件" },
    index_flags,
    name_flags,
})
:nofiles()

local commit_wim_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    mountdir_flags,
    { "/Commit",     "提交对映像的更改" },
})
:nofiles()

local unmount_wim_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    mountdir_flags,
    { "/Commit",     "保存更改后卸载" },
    { "/Discard",    "放弃更改后卸载" },
})
:nofiles()

local mount_wim_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/WimFile" .. file_arg, " <file>", "指定 WIM 文件" },
    { "/WimFile:" .. file_arg, " <file>", "指定 WIM 文件" },
    index_flags,
    mountdir_flags,
    { "/ReadOnly",   "以只读方式挂载映像" },
    { "/Optimize",   "优化挂载的映像" },
})
:nofiles()

local remount_wim_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    mountdir_flags,
})
:nofiles()

local cleanup_wim_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    mountdir_flags,
})
:nofiles()

--------------------------------------------------------------------------------
-- 通用映像处理命令

local split_image_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    imagefile_flags,
    { "/SWMFile" .. file_arg, " <file>", "指定目标拆分 WIM 文件" },
    { "/SWMFile:" .. file_arg, " <file>", "指定目标拆分 WIM 文件" },
    { "/FileSize" .. num_arg, " <MB>", "指定拆分文件的最大大小（MB）" },
    { "/FileSize:" .. num_arg, " <MB>", "指定拆分文件的最大大小（MB）" },
})
:nofiles()

local apply_image_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    imagefile_flags,
    index_flags,
    { "/ApplyDir" .. dir_arg, " <path>", "指定应用目录" },
    { "/ApplyDir:" .. dir_arg, " <path>", "指定应用目录" },
    { "/CheckIntegrity", "检测并跟踪 WIM 文件的损坏" },
    { "/Verify",     "验证映像文件" },
    { "/NoRpFix",    "禁用重解析点标记修复" },
})
:nofiles()

local get_imageinfo_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    imagefile_flags,
    index_flags,
    name_flags,
})
:nofiles()

local commit_image_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    mountdir_flags,
    { "/Commit",     "提交对映像的更改" },
})
:nofiles()

local unmount_image_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    mountdir_flags,
    { "/Commit",     "保存更改后卸载" },
    { "/Discard",    "放弃更改后卸载" },
})
:nofiles()

local mount_image_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    imagefile_flags,
    index_flags,
    mountdir_flags,
    { "/ReadOnly",   "以只读方式挂载映像" },
    { "/Optimize",   "优化挂载的映像" },
})
:nofiles()

local remount_image_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    mountdir_flags,
})
:nofiles()

--------------------------------------------------------------------------------
-- 程序包与功能服务命令

local get_features_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    format_flags,
    { "/PackagePath" .. file_arg, " <path>", "指定程序包路径（.cab 文件或文件夹）" },
    { "/PackagePath:" .. file_arg, " <path>", "指定程序包路径（.cab 文件或文件夹）" },
    { "/PackageName" .. name_arg, " <name>", "指定映像中的程序包名称" },
    { "/PackageName:" .. name_arg, " <name>", "指定映像中的程序包名称" },
})
:nofiles()

local get_featureinfo_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    format_flags,
    { "/FeatureName" .. name_arg, " <name>", "指定功能名称" },
    { "/FeatureName:" .. name_arg, " <name>", "指定功能名称" },
})
:nofiles()

local enable_feature_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/FeatureName" .. name_arg, " <name>", "指定要启用的功能名称" },
    { "/FeatureName:" .. name_arg, " <name>", "指定要启用的功能名称" },
    { "/All",        "启用父功能的所有依赖项" },
    source_flags,
    { "/NoRestart",  "取消自动重新启动" },
})
:nofiles()

local disable_feature_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/FeatureName" .. name_arg, " <name>", "指定要禁用的功能名称" },
    { "/FeatureName:" .. name_arg, " <name>", "指定要禁用的功能名称" },
    { "/Remove",     "移除功能，而非仅禁用" },
    { "/NoRestart",  "取消自动重新启动" },
})
:nofiles()

local add_package_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/PackagePath" .. file_arg, " <path>", "指定要添加的程序包路径（.cab/.msu 或文件夹）" },
    { "/PackagePath:" .. file_arg, " <path>", "指定要添加的程序包路径（.cab/.msu 或文件夹）" },
    { "/IgnoreCheck", "跳过安装先决条件检查" },
    { "/PreventPending", "存在待处理操作时跳过程序包" },
    { "/NoRestart",  "取消自动重新启动" },
})
:nofiles()

local remove_package_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/PackageName" .. name_arg, " <name>", "指定要删除的程序包名称" },
    { "/PackageName:" .. name_arg, " <name>", "指定要删除的程序包名称" },
    { "/NoRestart",  "取消自动重新启动" },
})
:nofiles()

local get_packages_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    format_flags,
})
:nofiles()

local get_packageinfo_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    format_flags,
    { "/PackageName" .. name_arg, " <name>", "指定程序包名称" },
    { "/PackageName:" .. name_arg, " <name>", "指定程序包名称" },
})
:nofiles()

local cleanup_image_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/CheckHealth",  "检查映像是否已损坏且可修复" },
    { "/ScanHealth",   "扫描映像中的组件存储损坏" },
    { "/RestoreHealth", "扫描并自动修复映像中的组件存储损坏" },
    { "/StartComponentCleanup", "清理被取代的组件并减小组件存储大小" },
    { "/ResetBase",    "重置被取代组件的基本信息（进一步减小组件存储）" },
    { "/Defer",        "将清理操作推迟到下一次自动维护" },
    { "/SPSuperseded", "删除 Service Pack 安装期间创建的备份文件" },
    { "/HideSP",       "阻止在已安装更新中列出 Service Pack" },
    { "/RevertPendingActions", "对无法启动的映像执行恢复操作（警告！）" },
    { "/AnalyzeComponentStore", "创建 WinSxS 组件存储的报告" },
    source_flags,
})
:nofiles()

local export_source_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/Source" .. file_arg, " <path>", "指定源位置" },
    { "/Source:" .. file_arg, " <path>", "指定源位置" },
    { "/LimitAccess", "阻止 DISM 联系 Windows 更新/WSUS" },
})
:nofiles()

local add_capability_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/CapabilityName" .. name_arg, " <name>", "指定要添加的功能名称" },
    { "/CapabilityName:" .. name_arg, " <name>", "指定要添加的功能名称" },
    source_flags,
    { "/NoRestart",  "取消自动重新启动" },
})
:nofiles()

local remove_capability_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/CapabilityName" .. name_arg, " <name>", "指定要删除的功能名称" },
    { "/CapabilityName:" .. name_arg, " <name>", "指定要删除的功能名称" },
    { "/NoRestart",  "取消自动重新启动" },
})
:nofiles()

local get_capabilities_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    format_flags,
})
:nofiles()

local get_capabilityinfo_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    format_flags,
    { "/CapabilityName" .. name_arg, " <name>", "指定功能名称" },
    { "/CapabilityName:" .. name_arg, " <name>", "指定功能名称" },
})
:nofiles()

local set_reservedstorage_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/State" .. clink.argmatcher():addarg({ "Enabled", "Disabled" }), " <Enabled|Disabled>", "启用或禁用保留存储空间" },
    { "/State:" .. clink.argmatcher():addarg({ "Enabled", "Disabled" }), " <Enabled|Disabled>", "启用或禁用保留存储空间" },
})
:nofiles()

local add_language_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/PackagePath" .. file_arg, " <path>", "指定语言包路径" },
    { "/PackagePath:" .. file_arg, " <path>", "指定语言包路径" },
})
:nofiles()

local remove_language_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/Language" .. lang_arg, " <lang>", "指定语言（如 zh-CN、en-US）" },
    { "/Language:" .. lang_arg, " <lang>", "指定语言（如 zh-CN、en-US）" },
})
:nofiles()

--------------------------------------------------------------------------------
-- APPX 预配命令

local add_provisionedappx_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/PackagePath" .. file_arg, " <path>", "指定应用包路径（.appx/.appxbundle）" },
    { "/PackagePath:" .. file_arg, " <path>", "指定应用包路径（.appx/.appxbundle）" },
    { "/SkipLicense", "跳过许可协议" },
    { "/LicensePath" .. file_arg, " <path>", "指定许可文件路径" },
    { "/LicensePath:" .. file_arg, " <path>", "指定许可文件路径" },
    { "/Region" .. name_arg, " <region>", "指定区域（如 all）" },
    { "/Region:" .. name_arg, " <region>", "指定区域（如 all）" },
    { "/CustomDataPath" .. file_arg, " <path>", "指定自定义数据文件路径" },
    { "/CustomDataPath:" .. file_arg, " <path>", "指定自定义数据文件路径" },
    { "/FolderPath" .. dir_arg, " <path>", "指定包含应用包的文件夹路径" },
    { "/FolderPath:" .. dir_arg, " <path>", "指定包含应用包的文件夹路径" },
})
:nofiles()

local remove_provisionedappx_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/PackageName" .. name_arg, " <name>", "指定应用包名称" },
    { "/PackageName:" .. name_arg, " <name>", "指定应用包名称" },
    { "/AllUsers",   "删除所有用户的预配应用包" },
})
:nofiles()

local get_provisionedappx_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    format_flags,
})
:nofiles()

local set_provisionedappxdata_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/PackagePath" .. file_arg, " <path>", "指定应用包路径" },
    { "/PackagePath:" .. file_arg, " <path>", "指定应用包路径" },
    { "/CustomDataPath" .. file_arg, " <path>", "指定自定义数据文件路径" },
    { "/CustomDataPath:" .. file_arg, " <path>", "指定自定义数据文件路径" },
})
:nofiles()

local set_nonremovableapp_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/PackageFamilyName" .. name_arg, " <name>", "指定程序包系列名称" },
    { "/PackageFamilyName:" .. name_arg, " <name>", "指定程序包系列名称" },
    { "/Policy" .. clink.argmatcher():addarg({ "on", "off" }), " <on|off>", "设置不可删除策略" },
    { "/Policy:" .. clink.argmatcher():addarg({ "on", "off" }), " <on|off>", "设置不可删除策略" },
})
:nofiles()

local get_nonremovableapp_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    format_flags,
})
:nofiles()

--------------------------------------------------------------------------------
-- 驱动程序命令

local add_driver_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/Driver" .. file_arg, " <path>", "指定驱动程序包（.inf 或文件夹）" },
    { "/Driver:" .. file_arg, " <path>", "指定驱动程序包（.inf 或文件夹）" },
    { "/Recurse",    "递归搜索子文件夹" },
    { "/ForceUnsigned", "强制安装未签名驱动" },
})
:nofiles()

local remove_driver_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/Driver" .. file_arg, " <path>", "指定要删除的驱动程序包（.inf）" },
    { "/Driver:" .. file_arg, " <path>", "指定要删除的驱动程序包（.inf）" },
})
:nofiles()

local get_drivers_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    format_flags,
    { "/All",        "显示所有驱动程序（包括内置驱动）" },
})
:nofiles()

local get_driverinfo_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    format_flags,
    { "/Driver" .. file_arg, " <path>", "指定驱动程序包（.inf）" },
    { "/Driver:" .. file_arg, " <path>", "指定驱动程序包（.inf）" },
})
:nofiles()

local export_driver_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/Destination" .. dir_arg, " <path>", "指定导出目标目录" },
    { "/Destination:" .. dir_arg, " <path>", "指定导出目标目录" },
})
:nofiles()

--------------------------------------------------------------------------------
-- 应用程序（MSI/MSP）命令

local check_apppatch_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/PatchLocation" .. file_arg, " <path>", "指定 MSP 修补程序位置" },
    { "/PatchLocation:" .. file_arg, " <path>", "指定 MSP 修补程序位置" },
})
:nofiles()

local get_apppatchinfo_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/PatchName" .. name_arg, " <name>", "指定修补程序名称" },
    { "/PatchName:" .. name_arg, " <name>", "指定修补程序名称" },
})
:nofiles()

local get_appinfo_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/Name" .. name_arg, " <name>", "指定 MSI 应用程序名称" },
    { "/Name:" .. name_arg, " <name>", "指定 MSI 应用程序名称" },
})
:nofiles()

--------------------------------------------------------------------------------
-- 默认应用关联命令

local import_defaultassoc_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/DefaultAppAssociations" .. file_arg, " <xml>", "指定默认应用关联 XML 文件" },
    { "/DefaultAppAssociations:" .. file_arg, " <xml>", "指定默认应用关联 XML 文件" },
})
:nofiles()

local get_defaultassoc_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    format_flags,
})
:nofiles()

local remove_defaultassoc_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/AllUsers",   "删除所有用户的默认应用关联" },
})
:nofiles()

--------------------------------------------------------------------------------
-- 国际设置命令

local set_lang_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/Lang" .. lang_arg, " <lang>", "指定语言（如 zh-CN）" },
    { "/Lang:" .. lang_arg, " <lang>", "指定语言（如 zh-CN）" },
})
:nofiles()

local set_locale_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/Locale" .. lang_arg, " <locale>", "指定区域设置（如 zh-CN）" },
    { "/Locale:" .. lang_arg, " <locale>", "指定区域设置（如 zh-CN）" },
})
:nofiles()

local set_inputlocale_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/Locale" .. lang_arg, " <locale>", "指定输入区域设置和键盘布局" },
    { "/Locale:" .. lang_arg, " <locale>", "指定输入区域设置和键盘布局" },
})
:nofiles()

local set_timezone_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/TimeZone" .. name_arg, " <tz>", "指定时区（如 China Standard Time）" },
    { "/TimeZone:" .. name_arg, " <tz>", "指定时区（如 China Standard Time）" },
})
:nofiles()

local set_layereddriver_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/Driver" .. name_arg, " <driver>", "指定键盘分层驱动程序（如 kbd）" },
    { "/Driver:" .. name_arg, " <driver>", "指定键盘分层驱动程序（如 kbd）" },
})
:nofiles()

local set_allintl_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/UILang" .. lang_arg, " <lang>", "指定默认系统用户界面语言" },
    { "/UILang:" .. lang_arg, " <lang>", "指定默认系统用户界面语言" },
    { "/UserLocale" .. lang_arg, " <locale>", "指定用户区域设置" },
    { "/UserLocale:" .. lang_arg, " <locale>", "指定用户区域设置" },
    { "/InputLocale" .. lang_arg, " <locale>", "指定输入区域设置和键盘布局" },
    { "/InputLocale:" .. lang_arg, " <locale>", "指定输入区域设置和键盘布局" },
    { "/SysLocale" .. lang_arg, " <locale>", "指定系统区域设置" },
    { "/SysLocale:" .. lang_arg, " <locale>", "指定系统区域设置" },
    { "/SysUILang" .. lang_arg, " <lang>", "指定系统 UI 语言" },
    { "/SysUILang:" .. lang_arg, " <lang>", "指定系统 UI 语言" },
    { "/SetupUILang" .. lang_arg, " <lang>", "指定安装程序使用的默认语言" },
    { "/SetupUILang:" .. lang_arg, " <lang>", "指定安装程序使用的默认语言" },
    { "/LayeredDriver" .. name_arg, " <driver>", "指定键盘分层驱动程序" },
    { "/LayeredDriver:" .. name_arg, " <driver>", "指定键盘分层驱动程序" },
    { "/TimeZone" .. name_arg, " <tz>", "指定默认时区" },
    { "/TimeZone:" .. name_arg, " <tz>", "指定默认时区" },
    { "/SKU" .. name_arg, " <sku>", "指定 SKU" },
    { "/SKU:" .. name_arg, " <sku>", "指定 SKU" },
})
:nofiles()

local set_skuintl_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/SKU" .. name_arg, " <sku>", "指定 SKU" },
    { "/SKU:" .. name_arg, " <sku>", "指定 SKU" },
})
:nofiles()

local get_intl_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    format_flags,
})
:nofiles()

--------------------------------------------------------------------------------
-- 无人参与 / EDGE / 预配程序包 / Windows 版本命令

local apply_unattend_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/UnattendDir" .. dir_arg, " <path>", "指定无人参与文件（Unattend.xml）所在目录" },
    { "/UnattendDir:" .. dir_arg, " <path>", "指定无人参与文件（Unattend.xml）所在目录" },
})
:nofiles()

local provisioning_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/PackagePath" .. file_arg, " <path>", "指定预配程序包路径（.ppkg）" },
    { "/PackagePath:" .. file_arg, " <path>", "指定预配程序包路径（.ppkg）" },
    { "/FolderPath" .. dir_arg, " <path>", "指定包含预配程序包的文件夹路径" },
    { "/FolderPath:" .. dir_arg, " <path>", "指定包含预配程序包的文件夹路径" },
    { "/SkipLicense", "跳过许可协议" },
})
:nofiles()

local set_productkey_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/ProductKey" .. name_arg, " <key>", "指定产品密钥" },
    { "/ProductKey:" .. name_arg, " <key>", "指定产品密钥" },
})
:nofiles()

local get_targeteditions_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    format_flags,
})
:nofiles()

local set_edition_parser = clink.argmatcher()
:_addexflags({
    common_flags,
    { "/Edition" .. name_arg, " <edition>", "指定目标版本（如 Professional）" },
    { "/Edition:" .. name_arg, " <edition>", "指定目标版本（如 Professional）" },
    { "/ProductKey" .. name_arg, " <key>", "指定产品密钥" },
    { "/ProductKey:" .. name_arg, " <key>", "指定产品密钥" },
})
:nofiles()

--------------------------------------------------------------------------------
-- 主解析器

clink.argmatcher("dism")
:_addexflags({
    common_flags,
    -- FFU 命令
    { "/Capture-Ffu" .. capture_ffu_parser,     " <options>", "将物理磁盘映像捕获到新的 FFU 文件中" },
    { "/Apply-Ffu" .. apply_ffu_parser,         " <options>", "应用 .ffu 映像" },
    { "/Split-Ffu" .. split_ffu_parser,         " <options>", "将现有 .ffu 文件拆分成多个只读拆分 FFU 文件" },
    { "/Optimize-Ffu" .. optimize_ffu_parser,   " <options>", "优化 FFU 文件，使其可应用于不同大小的存储" },
    -- WIM 命令
    { "/Apply-CustomDataImage" .. apply_customdata_parser, " <options>", "冻结自定义数据映像中包含的文件" },
    { "/Capture-CustomImage" .. capture_customimage_parser, " <options>", "将自定义设置捕获到 WIMBoot 系统上的增量 WIM 文件中" },
    { "/Get-WIMBootEntry" .. get_wimbootentry_parser, " <options>", "显示指定磁盘卷的 WIMBoot 配置项" },
    { "/Update-WIMBootEntry" .. update_wimbootentry_parser, " <options>", "更新指定磁盘卷的 WIMBoot 配置项" },
    { "/List-Image" .. list_image_parser,       " <options>", "显示指定映像中的文件和文件夹列表" },
    { "/Delete-Image" .. delete_image_parser,   " <options>", "从多卷映像 WIM 文件中删除指定的卷映像" },
    { "/Export-Image" .. export_image_parser,   " <options>", "将指定映像的副本导出到其他文件" },
    { "/Append-Image" .. append_image_parser,   " <options>", "将其他映像添加到 WIM 文件中" },
    { "/Capture-Image" .. capture_image_parser, " <options>", "将驱动器的映像捕获到新的 WIM 文件中" },
    { "/Get-MountedWimInfo" .. plain_parser,    "显示有关已挂载 WIM 映像的信息" },
    { "/Get-WimInfo" .. get_wiminfo_parser,     " <options>", "显示有关 WIM 文件中的映像的信息" },
    { "/Commit-Wim" .. commit_wim_parser,       " <options>", "保存对已挂载 WIM 映像的更改" },
    { "/Unmount-Wim" .. unmount_wim_parser,     " <options>", "卸载已挂载的 WIM 映像" },
    { "/Mount-Wim" .. mount_wim_parser,         " <options>", "从 WIM 文件挂载映像" },
    { "/Remount-Wim" .. remount_wim_parser,     " <options>", "恢复孤立的 WIM 挂载目录" },
    { "/Cleanup-Wim" .. cleanup_wim_parser,     " <options>", "删除与损坏的已挂载 WIM 映像关联的资源" },
    -- 通用映像处理命令
    { "/Split-Image" .. split_image_parser,     " <options>", "将现有 .wim 文件拆分为多个只读拆分 WIM (SWM) 文件" },
    { "/Apply-Image" .. apply_image_parser,     " <options>", "应用一个映像" },
    { "/Get-MountedImageInfo" .. plain_parser,  "显示有关已挂载 WIM 和 VHD 映像的信息" },
    { "/Get-ImageInfo" .. get_imageinfo_parser, " <options>", "显示有关 WIM、VHD 或 FFU 文件中映像的信息" },
    { "/Commit-Image" .. commit_image_parser,   " <options>", "保存对已装载 WIM 或 VHD 映像的更改" },
    { "/Unmount-Image" .. unmount_image_parser, " <options>", "卸载已装载的 WIM 或 VHD 映像" },
    { "/Mount-Image" .. mount_image_parser,     " <options>", "从 WIM 或 VHD 文件装载映像" },
    { "/Remount-Image" .. remount_image_parser, " <options>", "恢复孤立的映像装载目录" },
    { "/Cleanup-Mountpoints" .. plain_parser,   "删除与损坏的已安装映像关联的资源" },
    -- OS 卸载服务命令
    { "/Set-OSUninstallWindow" .. plain_parser, "设置 OS 卸载窗口" },
    { "/Get-OSUninstallWindow" .. plain_parser, "获取 OS 卸载窗口" },
    { "/Remove-OSUninstall" .. plain_parser,    "移除 OS 卸载" },
    { "/Initiate-OSUninstall" .. plain_parser,  "启动 OS 卸载" },
    -- APPX 服务命令
    { "/Get-NonRemovableAppPolicy" .. get_nonremovableapp_parser, "列出配置为不可删除的程序包系列" },
    { "/Set-NonRemovableAppPolicy" .. set_nonremovableapp_parser, "设置企业不可删除策略" },
    { "/Optimize-ProvisionedAppxPackages" .. plain_parser, "优化预配的 appx 占用空间" },
    { "/Set-ProvisionedAppxDataFile" .. set_provisionedappxdata_parser, "将自定义数据放入指定的应用包" },
    { "/Remove-ProvisionedAppxPackage" .. remove_provisionedappx_parser, "从映像中删除应用包" },
    { "/Add-ProvisionedAppxPackage" .. add_provisionedappx_parser, "将应用包添加到映像并为每个新用户安装" },
    { "/Get-ProvisionedAppxPackages" .. get_provisionedappx_parser, "显示映像中为每个新用户安装的应用包信息" },
    -- 程序包与功能服务命令
    { "/Add-Package" .. add_package_parser,     " <options>", "向映像中添加程序包" },
    { "/Remove-Package" .. remove_package_parser, " <options>", "从映像中删除程序包" },
    { "/Enable-Feature" .. enable_feature_parser, " <options>", "启用映像中的特定功能" },
    { "/Disable-Feature" .. disable_feature_parser, " <options>", "禁用映像中的特定功能" },
    { "/Get-Packages" .. get_packages_parser,   " <options>", "显示映像中所有程序包的信息" },
    { "/Get-PackageInfo" .. get_packageinfo_parser, " <options>", "显示有关特定程序包的信息" },
    { "/Get-Features" .. get_features_parser,   " <options>", "显示程序包中所有功能的信息" },
    { "/Get-FeatureInfo" .. get_featureinfo_parser, " <options>", "显示有关特定功能的信息" },
    { "/Cleanup-Image" .. cleanup_image_parser, " <options>", "对映像执行清理和恢复操作" },
    { "/Export-Source" .. export_source_parser, " <options>", "将一组功能导出到新存储库中" },
    { "/Add-Capability" .. add_capability_parser, " <options>", "将一个或多个功能添加到映像中" },
    { "/Remove-Capability" .. remove_capability_parser, " <options>", "从一个映像中删除功能" },
    { "/Get-Capabilities" .. get_capabilities_parser, " <options>", "获取映像中的功能" },
    { "/Get-CapabilityInfo" .. get_capabilityinfo_parser, " <options>", "获取映像中功能的信息" },
    { "/Get-ReservedStorageState" .. plain_parser, "获取保留存储空间的当前状态" },
    { "/Set-ReservedStorageState" .. set_reservedstorage_parser, "设置保留存储空间的当前状态" },
    { "/Add-Language" .. add_language_parser,   " <options>", "为给定语言添加最匹配包" },
    { "/Remove-Language" .. remove_language_parser, " <options>", "删除给定语言的最佳匹配包" },
    -- 操作系统常规命令
    { "/Optimize-Image" .. plain_parser,        "对脱机映像执行指定的配置" },
    -- 恢复管理（RRMP）命令
    { "/Remove-RRMPAltitude" .. plain_parser,   "移除恢复远程管理插件 (RRMP) 的 altitude" },
    { "/Set-RRMPAltitude" .. plain_parser,      "设置恢复远程管理插件 (RRMP) 的 altitude" },
    { "/Get-RRMPAltitude" .. plain_parser,      "显示恢复远程管理插件 (RRMP) 的 altitude" },
    { "/Get-RRMPs" .. plain_parser,             "列出所有已注册的恢复远程管理插件 (RRMP)" },
    { "/Get-RRMPInfo" .. plain_parser,          "显示已注册的 RRMP 的详细信息" },
    { "/Unregister-RRMP" .. plain_parser,       "注销恢复远程管理插件 (RRMP)" },
    { "/Register-RRMP" .. plain_parser,         "注册恢复远程管理插件 (RRMP)" },
    { "/Set-RemoteManagementStatus" .. plain_parser, "启用或禁用恢复远程管理插件 (RRMP)" },
    { "/Get-RemoteManagementStatus" .. plain_parser, "显示恢复远程管理插件 (RRMP) 的当前状态" },
    -- 驱动程序服务命令
    { "/Remove-Driver" .. remove_driver_parser, " <options>", "从脱机映像中删除驱动程序包" },
    { "/Add-Driver" .. add_driver_parser,       " <options>", "向脱机映像中添加驱动程序包" },
    { "/Get-DriverInfo" .. get_driverinfo_parser, " <options>", "显示有关特定驱动程序的信息" },
    { "/Get-Drivers" .. get_drivers_parser,     " <options>", "显示有关所有驱动程序的信息" },
    { "/Export-Driver" .. export_driver_parser, " <options>", "导出所有第三方驱动程序包" },
    -- 应用程序（MSI/MSP）命令
    { "/Check-AppPatch" .. check_apppatch_parser, " <options>", "显示 MSP 修补程序是否适用于映像" },
    { "/Get-AppPatchInfo" .. get_apppatchinfo_parser, " <options>", "显示有关已安装 MSP 修补程序的信息" },
    { "/Get-AppPatches" .. plain_parser,        "显示应用于所有已安装应用程序的 MSP 修补程序信息" },
    { "/Get-AppInfo" .. get_appinfo_parser,     " <options>", "显示有关特定 MSI 应用程序的信息" },
    { "/Get-Apps" .. plain_parser,              "显示有关所有已安装 MSI 应用程序的信息" },
    -- 默认应用关联命令
    { "/Remove-DefaultAppAssociations" .. remove_defaultassoc_parser, "删除 Windows 映像中的默认应用程序关联" },
    { "/Import-DefaultAppAssociations" .. import_defaultassoc_parser, "导入一组默认应用程序关联" },
    { "/Get-DefaultAppAssociations" .. get_defaultassoc_parser, "显示 Windows 映像中默认应用程序关联的列表" },
    { "/Export-DefaultAppAssociations" .. plain_parser, "从运行的操作系统导出默认的应用程序关联" },
    -- 国际服务命令
    { "/Set-SysUILang" .. set_lang_parser,      " <options>", "设置脱机映像中使用的系统 UI 语言" },
    { "/Set-LayeredDriver" .. set_layereddriver_parser, " <options>", "设置键盘分层驱动程序" },
    { "/Set-UILang" .. set_lang_parser,         " <options>", "设置默认系统用户界面语言" },
    { "/Set-UILangFallback" .. set_lang_parser, " <options>", "设置系统用户界面的回退默认语言" },
    { "/Set-UserLocale" .. set_locale_parser,   " <options>", "设置用户区域设置" },
    { "/Set-SysLocale" .. set_locale_parser,    " <options>", "设置系统区域设置" },
    { "/Set-InputLocale" .. set_inputlocale_parser, " <options>", "设置输入区域设置和键盘布局" },
    { "/Set-TimeZone" .. set_timezone_parser,   " <options>", "设置默认时区" },
    { "/Set-AllIntl" .. set_allintl_parser,     " <options>", "设置所有国际设置" },
    { "/Set-SKUIntlDefaults" .. set_skuintl_parser, " <options>", "将指定 SKU 语言的所有国际设置设为默认值" },
    { "/Gen-LangIni" .. plain_parser,           "生成新的 lang.ini 文件" },
    { "/Set-SetupUILang" .. set_lang_parser,    " <options>", "定义安装程序将使用的默认语言" },
    { "/Get-Intl" .. get_intl_parser,           " <options>", "显示有关国际设置和语言的信息" },
    -- 无人参与服务命令
    { "/Apply-Unattend" .. apply_unattend_parser, " <options>", "将无人参与文件应用于映像" },
    -- EDGE 服务命令
    { "/Add-Edge" .. plain_parser,              "将 Microsoft Edge 添加到映像" },
    { "/Add-EdgeBrowser" .. plain_parser,       "将 Microsoft Edge 浏览器添加到映像" },
    { "/Add-EdgeWebView" .. plain_parser,       "将 Microsoft Edge WebView 添加到映像" },
    -- 预配程序包服务命令
    { "/Get-ProvisioningPackageInfo" .. provisioning_parser, "获取预配程序包的信息" },
    { "/Add-ProvisioningPackage" .. provisioning_parser, "添加预配程序包" },
    -- Windows 版本服务命令
    { "/Set-ProductKey" .. set_productkey_parser, " <options>", "设置脱机映像的产品密钥" },
    { "/Get-TargetEditions" .. get_targeteditions_parser, " <options>", "显示映像可以升级到的 Windows 版本列表" },
    { "/Get-CurrentEdition" .. plain_parser,    "显示当前映像的版本" },
    { "/Set-Edition" .. set_edition_parser,     " <options>", "将映像升级到较高的版本" },
})
:nofiles()
