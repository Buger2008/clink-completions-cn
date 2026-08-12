-- luacheck: no max line length
--------------------------------------------------------------------------------
-- git-lfs.lua — Git Large File Storage
-- 注意：单独使用时为 `git-lfs <command>`，作为 git 子命令为 `git lfs <command>`

local freeform = clink.argmatcher():addarg({fromhistory=true})
local file = clink.argmatcher():addarg(clink.filematches)

local common_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    { "-h",      "显示帮助" },
    { "--help",  "显示帮助" },
})
:nofiles()

local checkout_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    { "-h",      "显示帮助" },
    { "--help",  "显示帮助" },
    { "--include"..freeform,  " paths", "只处理指定路径（逗号分隔）" },
    { "--exclude"..freeform,  " paths", "跳过指定路径（逗号分隔）" },
    { "--to"..freeform,       " dir",   "检查到指定目录" },
    { "--base"..freeform,     " ref",   "相对基线引用" },
})
:nofiles()

local fetch_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    { "-h",              "显示帮助" },
    { "--help",          "显示帮助" },
    { "--all",                    "获取所有远端的所有对象" },
    { "--recent",                 "获取最近使用的对象" },
    { "--include"..freeform, " paths", "只获取指定路径（逗号分隔）" },
    { "--exclude"..freeform, " paths", "跳过指定路径（逗号分隔）" },
    { "--objects"..freeform, " ids",   "获取指定对象 ID" },
    { "--prune",                  "修剪过期的对象" },
})
:addarg(freeform)
:nofiles()

local lock_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    { "-h",      "显示帮助" },
    { "--help",  "显示帮助" },
    { "-r"..freeform, " remote", "指定远端" },
    { "--remote="..freeform, " remote", "指定远端" },
})
:addarg(freeform)
:nofiles()

local ls_files_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    { "-h",      "显示帮助" },
    { "--help",  "显示帮助" },
    { "-l",               "长格式显示" },
    { "--long",           "长格式显示" },
    { "-r"..freeform, " ref", "指定提交引用" },
    { "--all",            "显示所有提交中的 LFS 文件" },
    { "-s",               "显示对象大小" },
    { "--size",           "显示对象大小" },
    { "-d",               "调试模式" },
    { "--debug",          "调试模式" },
    { "-p"..freeform, " pattern", "按路径模式过滤" },
})
:addarg(freeform)
:nofiles()

local ext_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    { "-h",      "显示帮助" },
    { "--help",  "显示帮助" },
    { "-e"..freeform, " pattern", "匹配的扩展名" },
    { "-s"..freeform, " pre",     "清理/污渍过滤器参数" },
    { "-d",                       "调试模式" },
})
:nofiles()

local migrate_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    { "-h",      "显示帮助" },
    { "--help",  "显示帮助" },
    { "-i"..freeform,  " include", "包含的路径（逗号分隔）" },
    { "-e"..freeform,  " exclude", "排除的路径（逗号分隔）" },
    { "--everything",               "迁移所有分支/标签" },
    { "-y",                         "跳过确认" },
    { "--yes",                      "跳过确认" },
    { "--skip-fetch",               "跳过获取" },
    { "--no-rewrite",               "不重写提交" },
    { "--above"..freeform, " size", "只迁移大于指定大小的文件" },
})
:addarg(freeform)
:nofiles()

local install_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    { "-h",      "显示帮助" },
    { "--help",  "显示帮助" },
    { "--local",          "只安装到当前仓库" },
    { "--system",         "安装到系统级配置" },
    { "--worktree",       "安装到工作树配置" },
    { "--skip-smudge",    "跳过 smudge 过滤器" },
    { "--skip-repo",      "跳过仓库钩子安装" },
    { "-f",               "强制重新安装钩子" },
    { "--force",          "强制重新安装钩子" },
    { "--manual",         "手动安装（打印要执行的命令）" },
})
:nofiles()

clink.argmatcher("git-lfs")
:_addexflags({
    opteq=true,
    { "-h",      "显示帮助" },
    { "--help",  "显示帮助" },
    { "--version", "显示版本" },
})
:_addexarg({
    { "checkout" .. checkout_parser, "从 LFS 文件填充工作副本的真实内容" },
    { "completion",                  "生成命令补全脚本" },
    { "dedup",                       "去重 LFS 文件" },
    { "env",                         "显示 Git LFS 环境" },
    { "ext" .. ext_parser,           "显示 Git LFS 扩展详情" },
    { "fetch" .. fetch_parser,       "从远端下载 LFS 文件" },
    { "fsck",                        "检查 LFS 文件一致性" },
    { "install" .. install_parser,   "安装 Git LFS 配置与钩子" },
    { "lock" .. lock_parser,         "在 LFS 服务器上锁定文件" },
    { "locks" .. lock_parser,        "列出已锁定的文件" },
    { "logs",                        "显示 Git LFS 命令的错误日志" },
    { "ls-files" .. ls_files_parser, "显示索引/工作树中的 LFS 文件信息" },
    { "merge-driver",                "合并驱动（供 Git 调用）" },
    { "migrate" .. migrate_parser,   "将现有仓库迁移到 LFS" },
    { "pointer",                     "检查/生成 LFS 指针文件" },
    { "post-checkout",               "checkout 后钩子（供 Git 调用）" },
    { "post-commit",                 "commit 后钩子（供 Git 调用）" },
    { "post-merge",                  "merge 后钩子（供 Git 调用）" },
    { "pre-push",                    "push 前钩子（供 Git 调用）" },
    { "pull",                        "拉取并 checkout LFS 文件" },
    { "push",                        "推送 LFS 文件到远端" },
    { "status",                      "显示 LFS 文件状态" },
    { "track",                       "跟踪指定模式的文件（存入 .gitattributes）" },
    { "uninstall",                   "移除 Git LFS 配置与钩子" },
    { "unlock",                      "解锁文件" },
    { "untrack",                     "取消跟踪文件模式" },
    { "update",                      "更新 Git LFS 钩子" },
    { "version",                     "显示版本" },
})
:nofiles()
