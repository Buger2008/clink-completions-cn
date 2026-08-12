[![Build status](https://github.com/vladimir-kotikov/clink-completions/actions/workflows/code-check.yml/badge.svg?branch=master)](https://github.com/vladimir-kotikov/clink-completions/actions/workflows/code-check.yml)
[![codecov](https://codecov.io/gh/vladimir-kotikov/clink-completions/branch/master/graph/badge.svg)](https://codecov.io/gh/vladimir-kotikov/clink-completions)



本仓库为原仓库中文汉化版，并添加了更多的指令支持

# clink-completions

面向 [Clink](https://github.com/chrisant996/clink) 工具的补全文件，随 [Cmder](https://github.com/cmderdev/cmder) 一同分发。

# 环境要求

这些补全需要 Clink v0.4.3 或更高版本。

# 说明

本仓库的 `master` 分支包含全部可用的补全。如果你缺少某些功能，请提交功能请求。

本包中的部分补全生成器使用了最新版 Clink 发行版才有的特性。如果在使用这些补全时遇到错误信息，请考虑将 Clink 升级到最新版本。

如果升级后问题依旧，欢迎提交 issue。

# 安装与更新

### 如果你使用 Cmder

如果你正在使用 [Cmder](https://github.com/cmderdev/cmder)，那么 clink-completions 已经随它一起打包了。

更新 Cmder 会同时更新 clink-completions，但不一定是最新的 clink-completions。

要让 Cmder 使用最新的 clink-completions，请按以下步骤操作：

1. 前往 [Releases](https://github.com/vladimir-kotikov/clink-completions/releases) 页面。
2. 在最新版本的 "Assets" 下下载 "Source code (zip)" 文件。
3. 将文件解压到你的 Cmder `vendor\clink-completions` 目录。
4. 重新启动一个新的 Cmder 会话。

否则，在使用较新版本的 [Clink](https://github.com/chrisant996/clink) 时，还有以下几种安装 clink-completions 脚本的方式：

### 使用 git 安装

1. 确保你已经安装了 [git](https://www.git-scm.com/downloads)。
2. 通过 <code>git clone https://github.com/vladimir-kotikov/clink-completions <em>local_directory</em></code> 将本仓库克隆到一个新的本地目录（将 <em>local_directory</em> 替换为你想要安装脚本的目录名）。

> **重要：** 不要命名为 `completions`，因为它是 Clink 中的保留子目录名。更多信息请参见 [补全目录](https://chrisant996.github.io/clink/clink.html#completion-directories)。

3. 通过 <code>clink installscripts <em>full_path_to_local_directory</em></code> 让 Clink 从该仓库加载脚本。

> **重要：** 请指定本地目录的完整路径（不要使用相对路径）。

4. 重新启动一个新的 Clink 会话。

之后通过 `git pull` 和常规的 git 工作流获取更新。

### 从 .zip 文件安装

1. 前往 [Releases](https://github.com/vladimir-kotikov/clink-completions/releases) 页面。
2. 在最新版本的 "Assets" 下下载 "Source code (zip)" 文件。
3. 将文件解压到一个本地目录。

> **重要：** 不要命名为 `completions`，因为它是 Clink 中的保留子目录名。更多信息请参见 [补全目录](https://chrisant996.github.io/clink/clink.html#completion-directories)。

4. 通过 <code>clink installscripts <em>full_path_to_local_directory</em></code> 让 Clink 从该目录加载脚本（仅首次安装时需要；更新时跳过此步骤）。

> **重要：** 请指定本地目录的完整路径（不要使用相对路径）。

5. 重新启动一个新的 Clink 会话。

之后获取更新时重复以上步骤，但跳过第 4 步。

# 仓库结构

根目录下的脚本文件在 Clink 启动时加载。

`completions\` 目录下的脚本只有在实际使用到对应命令时才会被加载。大多数补全脚本都可以放在 completions 目录中，但旧版本的 Clink 不会从 completions 目录加载脚本。

`modules\` 目录下的脚本包含辅助函数。`!init.lua` 脚本（或 `.init.lua` 脚本）负责告诉 Clink modules 和 completions 目录的位置。

`spec\` 目录下的脚本是测试文件，可由 `busted` 包运行。



# 开发与贡献

新流程采用单一的 `master` 分支来管理所有有一定价值的改动。`master` 分支应当保持整洁，并展示清晰的项目历史。缺陷修复直接合并进 `master` 分支。

功能开发应在独立的主题分支（topic branch）中进行，每个功能一个分支。提交拉取请求将功能合并进 `master` 分支，并为功能改动附上有意义的提交说明。

主题分支在合并进 `master` 之后不要重复使用，因为重复使用会导致不必要的合并冲突。主题分支被复用得越多，准确解决合并冲突就越困难。

`dev` 分支不稳定，贡献者不应使用。

# 测试

你需要在本机（`lua_modules` 目录）安装 `busted` 包。使用 Luarocks 安装：`luarocks --lua-version 5.2 install --tree=lua_modules busted`。你可能还想安装 `luacov` 来获取覆盖率信息。

安装完成后，在仓库根目录运行 `test.bat` 并观察测试是否通过。就这么简单。

### 在 Windows 上运行 `tests`

> [!IMPORTANT]
> Clink 和 clink-completions 使用 Lua **5.2**；请务必下载 Lua 5.2（而不是 5.4 或其他版本）。

**前置条件：**

1. 创建一个本地 luabin 目录，例如 `c:\luabin`。
2. 执行 `set PATH=%PATH%;c:\luabin` 将 luabin 目录添加到系统 PATH。
3. 从 [LuaBinaries](https://luabinaries.sourceforge.net/download.html) 下载 Lua 5.2 可执行文件到你的 luabin 目录。
4. 从 [LuaBinaries](https://luabinaries.sourceforge.net/download.html) 下载 Lua 5.2 源码压缩包，并将其 `include` 子目录中的头文件解压到 luabin 目录下的 `include\lua\5.2`。
5. 安装 [MinGW](https://sourceforge.net/projects/mingw/)，因为 luasystem luarock 需要从头编译自身。
6. 将 [luacheck](https://github.com/lunarmodules/luacheck/releases) 下载到你的 luabin 目录。
7. 将 [luarocks](https://github.com/luarocks/luarocks/wiki/Installation-instructions-for-Windows) 可执行文件下载到你的 luabin 目录。
8. 执行 `luarocks --local config variables.lua c:\luabin\lua52.exe` 告诉 luarocks 你的 Lua 二进制文件在哪里。
9. 执行 `luarocks --lua-version 5.2 install busted` 安装 busted。
10. 执行 `luarocks --lua-version 5.2 install luacov` 安装 luacov。
11. 执行 `set PATH=%PATH%;%USERPROFILE%\AppData\Roaming\luarocks\bin` 将 luarocks 的 bin 目录添加到系统 PATH，以便找到并执行 `busted`。

完成以上步骤后环境就配置好了。

**运行 `tests`：**

确保 PATH 中包含 luabin 目录和 luarocks 的 bin 目录（即上面前置条件中的第 2 步和第 11 步）。

然后在 clink-completions 仓库根目录下运行 `tests`。
