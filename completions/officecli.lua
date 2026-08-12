--------------------------------------------------------------------------------
-- officecli.lua, Office CLI completion for Clink.
--
-- officecli：面向 AI 友好的 Office 文档（.docx、.xlsx、.pptx）命令行工具。
-- 补全内容基于 `officecli help` 输出（v1.0.143）。
--
-- 用法：
--   officecli <command> <file> [options]
--   文档路径自动补全 .docx/.xlsx/.pptx 文件；含 [brackets] 的路径请加引号（如 "/body/p[1]"）。
--------------------------------------------------------------------------------

-- luacheck: no max line length

local arghelper = require('arghelper')

--------------------------------------------------------------------------------
-- 文件匹配辅助

local function filematches_byext(word, exts)
    if clink.filematchesexact then
        local matches = clink.dirmatches(word) or {}
        for _, ext in ipairs(exts) do
            for _, m in ipairs(clink.filematchesexact(word.."*."..ext)) do
                table.insert(matches, m)
            end
        end
        return matches
    else
        return clink.filematches(word)
    end
end

local function office_file_matches(word)
    return filematches_byext(word, { "docx", "xlsx", "pptx" })
end

local function csv_file_matches(word)
    return filematches_byext(word, { "csv", "tsv" })
end

local function json_file_matches(word)
    return filematches_byext(word, { "json" })
end

local office_file = clink.argmatcher():addarg({office_file_matches})
local csv_file = clink.argmatcher():addarg({csv_file_matches})
local json_file = clink.argmatcher():addarg({json_file_matches})
local any_file = clink.argmatcher():addarg(clink.filematches)
local freeform = clink.argmatcher():addarg({fromhistory=true})

--------------------------------------------------------------------------------
-- 公共选项（每个子命令都可用）

local common_flags = {
    { "--json",    "以 JSON 格式输出（AI 友好）" },
    { "-h",        "显示帮助和使用信息" },
    { "--help",    "显示帮助和使用信息" },
    { hide=true, "-?" },
}

--------------------------------------------------------------------------------
-- open / close / unwatch / refresh / validate / save：officecli <cmd> <file>

local simple_file_parser = clink.argmatcher()
:_addexflags(common_flags)
:addarg(office_file)
:nofiles()

--------------------------------------------------------------------------------
-- watch：officecli watch <file> [command]

local watch_mark_parser = clink.argmatcher()
:_addexflags(common_flags)
:addarg(office_file)
:addarg(freeform)
:nofiles()

local watch_unmark_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--path" .. freeform, " path", "要移除标记的数据路径" },
    { "--all",              "移除所有标记" },
})
:addarg(office_file)
:nofiles()

local watch_marks_parser = clink.argmatcher()
:_addexflags(common_flags)
:addarg(office_file)
:nofiles()

local watch_goto_parser = clink.argmatcher()
:_addexflags(common_flags)
:addarg(office_file)
:addarg(freeform)
:nofiles()

local watch_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--port" .. freeform, " port", "预览服务器的 HTTP 端口 [默认: 26315]" },
})
:addarg(office_file)
:_addexarg({
    { "mark" .. watch_mark_parser,   " <file> <path>", "通过 watch 进程为文档元素附加内存中的咨询标记" },
    { "unmark" .. watch_unmark_parser, " <file>",      "从 watch 进程移除标记" },
    { "marks" .. watch_marks_parser, " <file>",        "列出 watch 进程当前持有的所有标记" },
    { "goto" .. watch_goto_parser,   " <file> <path>", "将运行中的 watch 查看器滚动到给定元素" },
})
:nofiles()

--------------------------------------------------------------------------------
-- view：officecli view <file> <mode>

local render_values = clink.argmatcher():addarg({ "auto", "native", "html" })

local view_mode_parser = clink.argmatcher()
:_addexflags(common_flags)
:_addexarg({
    { "text",       "文本模式（xlsx 中每个单元格渲染为 <A1>=<value>）" },
    { "annotated",  "带注释的文本模式" },
    { "outline",    "大纲模式" },
    { "stats",      "统计模式" },
    { "issues",     "问题检查模式" },
    { "html",       "HTML 预览" },
    { "svg",        "SVG 输出" },
    { "screenshot", "截图模式" },
    { "pdf",        "PDF 输出" },
    { "forms",      "表单模式" },
})
:nofiles()

local view_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--start" .. freeform,             " start",  "起始行/段落编号" },
    { "--end" .. freeform,               " end",    "结束行/段落编号" },
    { "--max-lines" .. freeform,         " max-lines", "最大输出行数/行/幻灯片数（超出则截断并显示总数）" },
    { "--type" .. freeform,              " type",   "问题类型过滤器（format/content/structure 或具体子类型）" },
    { "--limit" .. freeform,             " limit",  "限制结果数量" },
    { "--cols" .. freeform,              " cols",   "列过滤器，逗号分隔（仅 Excel，如 A,B,C）" },
    { "--page" .. freeform,              " page",   "页面过滤器（如 1、2-5、1,3,5）" },
    { "--browser",                                 "在浏览器中打开输出（html / svg 模式）" },
    { "-o" .. any_file,                  " out",    "输出文件路径（html、screenshot、pdf 模式）" },
    { "--out" .. any_file,               " out",    "输出文件路径（html、screenshot、pdf 模式）" },
    { "--range" .. freeform,             " range",  "将输出限制到某个区域（截图/文本模式）" },
    { "--screenshot-width" .. freeform,  " width",  "截图视口宽度（默认 1600）" },
    { "--screenshot-height" .. freeform, " height", "截图视口高度（默认 1200）" },
    { "--grid" .. freeform,              " grid",   "将页面/幻灯片平铺为缩略图联系表（截图模式）" },
    { "--render" .. render_values,       " render", "截图渲染路径：auto（默认）/ native / html" },
    { "--page-count",                              "stats 模式（仅 docx）：报告总页数（需要 Word 重新分页）" },
})
:addarg(office_file)
:addarg(view_mode_parser)
:nofiles()

--------------------------------------------------------------------------------
-- get / query / set / add / remove / move / swap / raw / raw-set / add-part

local get_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--depth" .. freeform, " depth", "包含的子节点深度 [默认: 1]" },
    { "--save" .. any_file,  " save",  "将后备二进制有效负载（图片/ole/媒体）提取到此文件路径" },
})
:addarg(office_file)
:addarg(freeform)
:nofiles()

local query_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--find" .. freeform,    " find",   "过滤结果，仅保留包含此文本的元素（不区分大小写的子字符串）" },
    { "--compact",                       "按文档顺序每行输出一个元素（稳定性契约格式）" },
    { "--fields" .. freeform,  " fields", "追加为额外 k=v 列的逗号分隔 Format 键（如 x,y,width）" },
})
:addarg(office_file)
:addarg(freeform)
:nofiles()

local set_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--prop" .. freeform,    " prop",   "要设置的属性（key=value）" },
    { "--find" .. freeform,    " find",   "查找此文本/模式（字面子串；r\"...\" 前缀启用正则）" },
    { "--replace" .. freeform, " replace", "--find 匹配的替换文本" },
    { "--force",                         "即使文档受保护也强制写入" },
})
:addarg(office_file)
:addarg(freeform)
:nofiles()

local add_type = clink.argmatcher():addarg({
    "paragraph", "run", "table", "sheet", "row", "cell", "slide", "shape",
    "picture", "diagram", "flowchart", "ole", "video", "textbox", "connector",
    "group", "comment", "chart", "hyperlink",
})

local add_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--type" .. add_type,    " type",  "要添加的元素类型（如 paragraph、run、table、sheet、slide、shape、picture）" },
    { "--from" .. freeform,    " from",  "从现有元素路径复制（如 /slide[1]/shape[2]）" },
    { "--index" .. freeform,   " index", "插入位置（0 基）；省略则追加到末尾" },
    { "--after" .. freeform,   " after", "在此路径处的元素之后插入" },
    { "--before" .. freeform,  " before", "在此路径处的元素之前插入" },
    { "--prop" .. freeform,    " prop",  "要设置的属性（key=value，如 --prop src=image.png）" },
    { "--force",                         "即使文档受保护也强制写入" },
})
:addarg(office_file)
:addarg(freeform)
:nofiles()

local shift_values = clink.argmatcher():addarg({ "left", "up" })

local remove_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--shift" .. shift_values, " shift", "（仅 Excel 单元格）移动周围单元格以填补空缺：left | up" },
    { "--prop" .. freeform,      " prop",  "修饰符属性（key=value，如 --prop trackChange.author=<name>）" },
})
:addarg(office_file)
:addarg(freeform)
:nofiles()

local move_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--to" .. freeform,     " to",     "目标父路径；省略则在当前父级内重新排序" },
    { "--index" .. freeform,  " index",  "插入位置（0 基）；省略则追加到末尾" },
    { "--after" .. freeform,  " after",  "在此路径处的元素之后移动" },
    { "--before" .. freeform, " before", "在此路径处的元素之前移动" },
    { "--prop" .. freeform,   " prop",   "移动时设置的属性（如 --prop trackChange.author=Alice）" },
})
:addarg(office_file)
:addarg(freeform)
:nofiles()

local swap_parser = clink.argmatcher()
:_addexflags(common_flags)
:addarg(office_file)
:addarg(freeform)
:addarg(freeform)
:nofiles()

local raw_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--start" .. freeform, " start", "起始行号（仅 Excel 工作表）" },
    { "--end" .. freeform,   " end",   "结束行号（仅 Excel 工作表）" },
    { "--cols" .. freeform,  " cols",  "列过滤器，逗号分隔（仅 Excel，如 A,B,C）" },
})
:addarg(office_file)
:addarg(freeform)
:nofiles()

local rawset_actions = clink.argmatcher():addarg({
    "append", "prepend", "insertbefore", "insertafter", "replace", "remove", "setattr",
})

local rawset_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--xpath" .. freeform,      " xpath",  "（必需）目标元素的 XPath" },
    { "--action" .. rawset_actions, " action", "（必需）操作：append / prepend / insertbefore / insertafter / replace / remove / setattr" },
    { "--xml" .. freeform,        " xml",    "XML 片段或 setattr 的 attr=value" },
})
:addarg(office_file)
:addarg(freeform)
:nofiles()

local addpart_types = clink.argmatcher():addarg({ "chart", "header", "footer" })

local addpart_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--type" .. addpart_types, " type", "（必需）要创建的部件类型：Word 为 chart/header/footer；PPT/Excel 为 chart" },
})
:addarg(office_file)
:addarg(freeform)
:nofiles()

--------------------------------------------------------------------------------
-- batch / dump / import / create / merge

local batch_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--input" .. json_file,    " input",     "包含批处理命令的 JSON 文件；省略则从 stdin 读取" },
    { "--commands" .. freeform,  " commands",  "内联 JSON 数组批处理命令（--input 或 stdin 的替代）" },
    { "--force",                            "默认 continue-on-error 模式的弃用别名（为兼容保留）" },
    { "--stop-on-error",                    "任何命令失败即中止批处理" },
    { "--best-effort",                      "即使部分命令失败也应用成功的项目（旧的原子前语义）" },
})
:addarg(office_file)
:nofiles()

local dump_format = clink.argmatcher():addarg({ "batch" })

local dump_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--format" .. dump_format, " format", "输出格式（目前：batch）" },
    { "-o" .. any_file,          " out",    "将输出写入文件而不是 stdout" },
    { "--out" .. any_file,       " out",    "将输出写入文件而不是 stdout" },
})
:addarg(office_file)
:addarg(freeform)
:nofiles()

local import_format = clink.argmatcher():addarg({ "csv", "tsv" })

local import_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--file" .. csv_file,       " file",       "要导入的源 CSV/TSV 文件" },
    { "--stdin",                             "从 stdin 读取 CSV/TSV 数据" },
    { "--format" .. import_format, " format",  "数据格式：csv 或 tsv（默认根据文件扩展名推断，或 csv）" },
    { "--header",                            "第一行为标题：设置自动筛选并冻结窗格" },
    { "--start-cell" .. freeform,  " start-cell", "起始单元格（默认: A1）" },
})
:addarg(office_file)
:addarg(freeform)
:addarg(csv_file)
:nofiles()

local create_types = clink.argmatcher():addarg({ "docx", "xlsx", "pptx" })

local create_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--type" .. create_types, " type",   "文档类型（docx、xlsx、pptx）——可选，默认从文件扩展名推断" },
    { "--force",                         "覆盖现有文件" },
    { "--locale" .. freeform,  " locale", "区域设置标签（如 zh-CN、ja、ko、ar、he），设置默认字体并启用 RTL 布局" },
    { "--minimal",                       "（仅 .docx）跳过 Word 的 Normal.dotm 基线，生成最紧凑的 OOXML" },
})
:addarg(office_file)
:nofiles()

local merge_parser = clink.argmatcher()
:_addexflags({
    opteq=true,
    common_flags,
    { "--data" .. json_file, " data", "（必需）JSON 数据或 .json 文件的路径" },
    { "--force",                    "覆盖现有的输出文件" },
})
:addarg(office_file)
:addarg(office_file)
:nofiles()

--------------------------------------------------------------------------------
-- plugins / mcp / skills / install

local plugin_name = clink.argmatcher():addarg({fromhistory=true})

local plugins_parser = clink.argmatcher()
:_addexflags(common_flags)
:_addexarg({
    { "list",                "列出标准搜索路径中可发现的插件" },
    { "info" .. plugin_name, " <name>", "显示单个插件的完整清单" },
    { "lint" .. plugin_name, " <name>", "根据主架构检查 dump-reader 插件" },
})
:nofiles()

local mcp_target = clink.argmatcher():addarg({
    "lms",     -- LM Studio
    "claude",  -- Claude Code
    "cursor",
    "vscode",  -- Copilot
})

local mcp_parser = clink.argmatcher()
:_addexflags(common_flags)
:_addexarg({
    { "uninstall" .. mcp_target, " <target>", "从 MCP 客户端注销 officecli" },
    { "list",                               "显示所有客户端的注册状态" },
    { "lms",                                "向 LM Studio 注册 officecli" },
    { "claude",                             "向 Claude Code 注册 officecli" },
    { "cursor",                             "向 Cursor 注册 officecli" },
    { "vscode",                             "向 VSCode（Copilot）注册 officecli" },
})
:nofiles()

local skill_names = {
    "pptx", "word", "excel", "word-form", "morph-ppt", "morph-ppt-3d",
    "pitch-deck", "academic-paper", "data-dashboard", "financial-model",
}

local skill_agents = {
    "claude", "copilot", "codex", "cursor", "windsurf", "minimax",
    "opencode", "openclaw", "nanobot", "zeroclaw", "hermes", "all",
}

local function merge_lists(...)
    local t = {}
    for _, list in ipairs({...}) do
        for _, item in ipairs(list) do
            table.insert(t, item)
        end
    end
    return t
end

-- install <skill-name> <agent> 两个位置（顺序可互换）
local skills_install_parser = clink.argmatcher()
:_addexflags(common_flags)
:addarg(merge_lists(skill_names, skill_agents))
:addarg(skill_agents)
:nofiles()

local skills_parser = clink.argmatcher()
:_addexflags(common_flags)
:_addexarg({
    { "install" .. skills_install_parser, " [<skill-name> [<agent>]]", "安装技能定义（默认安装基础 SKILL.md）" },
    { "list",                              "列出所有可用技能" },
    { "claude",                            "向 Claude 安装基础 SKILL.md" },
    { "copilot",                           "向 Copilot 安装基础 SKILL.md" },
    { "codex",                             "向 Codex 安装基础 SKILL.md" },
    { "cursor",                            "向 Cursor 安装基础 SKILL.md" },
    { "windsurf",                          "向 Windsurf 安装基础 SKILL.md" },
    { "minimax",                           "向 MiniMax 安装基础 SKILL.md" },
    { "opencode",                          "向 OpenCode 安装基础 SKILL.md" },
    { "openclaw",                          "向 OpenClaw 安装基础 SKILL.md" },
    { "nanobot",                           "向 Nanobot 安装基础 SKILL.md" },
    { "zeroclaw",                          "向 ZeroClaw 安装基础 SKILL.md" },
    { "hermes",                            "向 Hermes 安装基础 SKILL.md" },
    { "all",                               "向所有代理安装基础 SKILL.md" },
})
:nofiles()

local install_targets = clink.argmatcher():addarg({
    "claude", "copilot", "codex", "cursor", "windsurf", "vscode", "minimax",
    "opencode", "openclaw", "nanobot", "zeroclaw", "hermes", "all",
})

local install_parser = clink.argmatcher()
:_addexflags(common_flags)
:addarg(install_targets)
:nofiles()

--------------------------------------------------------------------------------
-- help：officecli help <format> [<verb-or-element>]

local help_verbs = {
    { "add",    "支持 add 操作的元素" },
    { "set",    "支持 set 操作的元素" },
    { "get",    "支持 get 操作的元素" },
    { "query",  "支持 query 操作的元素" },
    { "remove", "支持 remove 操作的元素" },
}

local help_elements = {
    -- docx
    { "abstractNum", "抽象编号定义" },
    { "body",        "文档正文" },
    { "diagram",     "图表" },
    { "document",    "文档根节点" },
    { "footer",      "页脚" },
    { "header",      "页眉" },
    { "markdown",    "Markdown 内容" },
    { "num",         "编号实例" },
    { "numbering",   "编号定义集合" },
    { "paragraph",   "段落" },
    { "raw",         "原始 XML 片段" },
    { "section",     "分节" },
    { "shape",       "形状" },
    { "style",       "样式定义" },
    { "styles",      "样式集合" },
    { "table",       "表格" },
    { "textbox",     "文本框" },
    { "watermark",   "水印" },
    -- xlsx
    { "aboveaverage",          "高于平均值条件格式" },
    { "autofilter",            "自动筛选" },
    { "cell",                  "单元格" },
    { "cellis",                "单元格值条件格式" },
    { "cfextended",            "扩展条件格式" },
    { "chart",                 "图表" },
    { "colbreak",              "列分页符" },
    { "colorscale",            "色阶条件格式" },
    { "column",                "列" },
    { "conditionalformatting", "条件格式" },
    { "containstext",          "包含文本条件格式" },
    { "databar",               "数据条条件格式" },
    { "dateoccurring",         "日期条件格式" },
    { "detectedtable",         "检测到的表格" },
    { "duplicatevalues",       "重复值条件格式" },
    { "formulacf",             "公式条件格式" },
    { "iconset",               "图标集条件格式" },
    { "namedrange",            "命名区域" },
    { "ole",                   "OLE 对象" },
    { "pagebreak",             "分页符" },
    { "picture",               "图片" },
    { "pivottable",            "数据透视表" },
    { "range",                 "区域" },
    { "row",                   "行" },
    { "rowbreak",              "行分页符" },
    { "sheet",                 "工作表" },
    { "slicer",                "切片器" },
    { "sparkline",             "迷你图" },
    { "topn",                  "前 N 项条件格式" },
    { "uniquevalues",          "唯一值条件格式" },
    { "validation",            "数据验证" },
    { "workbook",              "工作簿" },
    -- pptx
    { "comment",       "批注" },
    { "connector",     "连接线" },
    { "group",         "组合" },
    { "media",         "媒体" },
    { "model3d",       "3D 模型" },
    { "moderncomment", "现代批注" },
    { "notes",         "备注" },
    { "placeholder",   "占位符" },
    { "presentation",  "演示文稿根节点" },
    { "slide",         "幻灯片" },
    { "slidemaster",   "幻灯片母版" },
    { "theme",         "主题" },
    { "transition",    "切换效果" },
    { "zoom",          "缩放" },
}

local help_verb_or_element = clink.argmatcher()
:_addexflags(common_flags)
:_addexarg({
    help_verbs,
    help_elements,
})
:nofiles()

local help_parser = clink.argmatcher()
:_addexflags(common_flags)
:_addexarg({
    { "all" .. clink.argmatcher():nofiles(),        "所有 (格式,元素,属性) 的平面转储——可管道传输给 grep" },
    { "docx" .. help_verb_or_element, " <verb-or-element>", "Word 文档（docx）元素" },
    { "word" .. help_verb_or_element, " <verb-or-element>", "docx 的别名" },
    { "xlsx" .. help_verb_or_element, " <verb-or-element>", "Excel 工作表（xlsx）元素" },
    { "excel" .. help_verb_or_element, " <verb-or-element>", "xlsx 的别名" },
    { "pptx" .. help_verb_or_element, " <verb-or-element>", "PowerPoint 演示文稿（pptx）元素" },
    { "ppt" .. help_verb_or_element, " <verb-or-element>", "pptx 的别名" },
    { "powerpoint" .. help_verb_or_element, " <verb-or-element>", "pptx 的别名" },
})
:nofiles()

--------------------------------------------------------------------------------
-- 主解析器

clink.argmatcher("officecli")
:_addexflags({
    { "--json",    "以 JSON 格式输出（AI 友好）" },
    { "-h",        "显示帮助和使用信息" },
    { "--help",    "显示帮助和使用信息" },
    { "--version", "显示版本信息" },
    { hide=true, "-?" },
})
:_addexarg({
    { "open" .. simple_file_parser,   " <file>", "启动常驻进程，将文档驻留在内存中以加快后续命令" },
    { "close" .. simple_file_parser,  " <file>", "将内存中的修改刷写回磁盘并停止常驻进程（释放文件）" },
    { "watch" .. watch_parser,        " <file>", "启动实时预览服务器，officecli 修改文档时自动刷新" },
    { "unwatch" .. simple_file_parser, " <file>", "停止文档的 watch 预览服务器" },
    { "view" .. view_parser,          " <file> <mode>", "以不同模式查看文档" },
    { "get" .. get_parser,            " <file> [<path>]", "按路径获取文档节点 [默认: /]" },
    { "query" .. query_parser,        " <file> <selector>", "使用类 CSS 选择器查询文档元素" },
    { "set" .. set_parser,            " <file> <path>", "修改文档节点的属性" },
    { "add" .. add_parser,            " <file> <parent>", "向文档添加新元素" },
    { "remove" .. remove_parser,      " <file> <path>", "从文档中移除元素" },
    { "move" .. move_parser,          " <file> <path>", "将元素移动到新位置或父节点" },
    { "swap" .. swap_parser,          " <file> <path1> <path2>", "交换文档中的两个元素" },
    { "refresh" .. simple_file_parser, " <file>", "重新计算派生字段值（TOC 页码、PAGE/NUMPAGES、交叉引用）" },
    { "raw" .. raw_parser,            " <file> [<part>]", "查看文档部件的原始 XML [默认: /document]" },
    { "raw-set" .. rawset_parser,     " <file> <part>", "修改文档部件中的原始 XML（任何 OpenXML 操作的通用后备）" },
    { "add-part" .. addpart_parser,   " <file> <parent>", "创建新的文档部件并返回其关系 ID（供 raw-set 使用）" },
    { "validate" .. simple_file_parser, " <file>", "根据 OpenXML 架构验证文档" },
    { "save" .. simple_file_parser,   " <file>", "将内存中的修改刷写回磁盘，保持常驻进程运行" },
    { "batch" .. batch_parser,        " <file>", "在单次传递中执行 JSON 数组中的多个命令" },
    { "dump" .. dump_parser,          " <file> [<path>]", "将文档子树序列化为可重放的批处理脚本 [默认: /]" },
    { "import" .. import_parser,      " <file> <parent-path> [<source-file>]", "将 CSV/TSV 数据导入 Excel 工作表" },
    { "create" .. create_parser,      " <file>", "创建空白 Office 文档" },
    { "merge" .. merge_parser,        " <template> <output>", "使用 JSON 数据合并模板，替换 {{key}} 占位符" },
    { "plugins" .. plugins_parser,    "管理和检查已安装的插件" },
    { "mcp" .. mcp_parser,            "启动 MCP stdio 服务器，或向 MCP 客户端注册/注销 officecli" },
    { "skills" .. skills_parser,      "安装代理技能定义（Claude Code、Cursor、Copilot 等）" },
    { "install" .. install_parser,    " [<target>]", "一键设置：安装二进制文件 + 技能 + MCP" },
    { "help" .. help_parser,          " <format>", "显示 officecli 的 schema 驱动功能参考" },
})
:nofiles()
