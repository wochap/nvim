local iconsUtils = require "custom.utils.icons"
local lspUtils = require "custom.utils.lsp"
local lazyUtils = require "custom.utils.lazy"
local gitBranchUtils = require "custom.utils.git-branch"
local formatUtils = require "custom.utils.format"
local lintUtils = require "custom.utils.lint"

local fn = vim.fn
local api = vim.api
local breakpoint = 110
local separators = {
  l = "",
  l_b = "",
  r = "",
  r_b = "",
}
local modes = {
  ["n"] = { "NORMAL", "Normal" },
  ["no"] = { "NORMAL (no)", "Normal" },
  ["nov"] = { "NORMAL (nov)", "Normal" },
  ["noV"] = { "NORMAL (noV)", "Normal" },
  ["noCTRL-V"] = { "NORMAL", "Normal" },
  ["niI"] = { "NORMAL i", "Normal" },
  ["niR"] = { "NORMAL r", "Normal" },
  ["niV"] = { "NORMAL v", "Normal" },
  ["nt"] = { "NTERMINAL", "NTerminal" },
  ["ntT"] = { "NTERMINAL (ntT)", "NTerminal" },

  ["v"] = { "VISUAL", "Visual" },
  ["vs"] = { "V-CHAR (Ctrl O)", "Visual" },
  ["V"] = { "V-LINE", "Visual" },
  ["Vs"] = { "V-LINE", "Visual" },
  [""] = { "V-BLOCK", "Visual" },

  ["i"] = { "INSERT", "Insert" },
  ["ic"] = { "INSERT (completion)", "Insert" },
  ["ix"] = { "INSERT completion", "Insert" },

  ["t"] = { "TERMINAL", "Terminal" },

  ["R"] = { "REPLACE", "Replace" },
  ["Rc"] = { "REPLACE (Rc)", "Replace" },
  ["Rx"] = { "REPLACEa (Rx)", "Replace" },
  ["Rv"] = { "V-REPLACE", "Replace" },
  ["Rvc"] = { "V-REPLACE (Rvc)", "Replace" },
  ["Rvx"] = { "V-REPLACE (Rvx)", "Replace" },

  ["s"] = { "SELECT", "Select" },
  ["S"] = { "S-LINE", "Select" },
  [""] = { "S-BLOCK", "Select" },
  ["c"] = { "COMMAND", "Command" },
  ["cv"] = { "COMMAND", "Command" },
  ["ce"] = { "COMMAND", "Command" },
  ["r"] = { "PROMPT", "Confirm" },
  ["rm"] = { "MORE", "Confirm" },
  ["r?"] = { "CONFIRM", "Confirm" },
  ["x"] = { "CONFIRM", "Confirm" },
  ["!"] = { "SHELL", "Terminal" },
}

local function remove_empty_str(list)
  local result = {}
  for _, value in ipairs(list) do
    if value ~= "" then
      table.insert(result, value)
    end
  end
  return result
end

local function hl_str(str)
  return "%#" .. str .. "#"
end

-- returns a new hl group, where it applies
-- group 1 fg and group 2 bg
local function hl_merge(group1, group2)
  local fg = fn.synIDattr(fn.synIDtrans(fn.hlID(group1)), "fg#")
  local bg = fn.synIDattr(fn.synIDtrans(fn.hlID(group2)), "bg#")
  api.nvim_set_hl(0, "StModule" .. group1 .. group2, { fg = fg, bg = bg })

  return "%#" .. "StModule" .. group1 .. group2 .. "#"
end

local function empty_space(count)
  count = count or 1

  return hl_str "StEmptySpace" .. (" "):rep(count)
end

local function mode_module()
  local m = vim.api.nvim_get_mode().mode
  local current_mode = modes[m][1]
  local mode_sep = separators.l

  return hl_str("St" .. modes[m][2] .. "Mode")
    .. " "
    .. current_mode
    .. " "
    .. hl_str("St" .. modes[m][2] .. "ModeSep")
    .. mode_sep
end

local function filetype_icon()
  local has_nwd, nwd = pcall(require, "nvim-web-devicons")

  if not has_nwd then
    return ""
  end

  local icon, hl = nwd.get_icon(vim.fn.expand "%:t", nil, {
    default = true,
  })

  return hl_merge(hl, "StModule") .. icon .. " "
end

local function file_relative_path()
  if vim.o.columns <= breakpoint then
    return ""
  end

  local filename_str = vim.fn.expand "%:t"
  if string.len(filename_str) == 0 then
    return ""
  end

  local filename_path_str = vim.api.nvim_buf_get_name(0)
  local filename_relative_path_str = vim.fn.fnamemodify(filename_path_str, ":~:.")
  filename_relative_path_str = string.sub(filename_relative_path_str, 1, -2 + string.len(filename_str) * -1)
  -- TODO: remove git root pwd from relative path str

  if string.len(filename_relative_path_str) > 40 then
    local parts = {}
    for part in string.gmatch(filename_relative_path_str, "[^/]+") do
      table.insert(parts, part)
    end
    if #parts > 2 then
      local first_folder = parts[1]
      local last_folder = parts[#parts]
      filename_relative_path_str = first_folder .. "/…/" .. last_folder
    end
  end

  return hl_merge("StRelativePath", "StModule") .. filename_relative_path_str
end

local function filename()
  local filename_str = (fn.expand "%" == "" and "[No Name]") or fn.expand "%:t"

  if #filename_str > 40 then
    filename_str = iconsUtils.other.ellipsis .. string.sub(filename_str, -20)
  end

  return hl_str "StModule" .. filename_str
end

local function file_module()
  local file_relative_path_str = file_relative_path()
  return hl_str "StModuleSep"
    .. separators.l_b
    .. hl_str "StModule"
    .. " "
    .. filetype_icon()
    .. filename()
    .. (#file_relative_path_str > 0 and " " .. file_relative_path_str or "")
    .. hl_str "StModule"
    .. " "
    .. hl_str "StModuleSep"
    .. separators.l
end

local trouble_st
local function symbols_module()
  if not LazyVim.has "trouble.nvim" then
    return ""
  end
  if not trouble_st then
    local trouble = require "trouble"
    trouble_st = trouble.statusline {
      mode = "symbols",
      groups = {},
      title = false,
      filter = { range = true },
      format = "{kind_icon:StModuleAlt}{symbol.name:StModuleAlt}",
      hl_group = "StModuleAlt",
    }
  end
  if not trouble_st.has() then
    return ""
  end
  return trouble_st.get()
end

local function git_branch_module()
  local branch_name = gitBranchUtils.get_branch()

  if #branch_name > 0 then
    return hl_str "StModuleAlt" .. " " .. branch_name
  end

  return ""
end

local function git_branch_gitsigns_module()
  if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
    return ""
  end

  local git_status = vim.b.gitsigns_status_dict
  local branch_name = git_status.head

  if #branch_name > 0 then
    return hl_str "StModuleAlt" .. " " .. branch_name
  end

  return ""
end

local function git_diff_module()
  if not vim.b.gitsigns_head or vim.b.gitsigns_git_status or vim.o.columns <= breakpoint then
    return ""
  end

  local git_status = vim.b.gitsigns_status_dict
  local added = (git_status.added and git_status.added ~= 0)
      and (hl_str "StGitAdd" .. iconsUtils.git.Add .. " " .. git_status.added)
    or ""
  local changed = (git_status.changed and git_status.changed ~= 0)
      and (hl_str "StGitChange" .. iconsUtils.git.Change .. " " .. git_status.changed)
    or ""
  local removed = (git_status.removed and git_status.removed ~= 0)
      and (hl_str "StGitDelete" .. iconsUtils.git.Delete .. " " .. git_status.removed)
    or ""
  local conflict = ""
  if lazyUtils.is_loaded "git-conflict.nvim" then
    local gc = require "git-conflict"
    local ok, conflict_count = pcall(gc.conflict_count)
    if ok then
      conflict = (conflict_count ~= 0) and (hl_str "StGitConflict" .. iconsUtils.git.Conflict .. " " .. conflict_count)
        or ""
    end
  end

  return table.concat(remove_empty_str { added, changed, removed, conflict }, " ")
end

local function maximize_status_module()
  -- requires declancm/maximize.nvim
  return vim.t.maximized and (hl_str "StMaximize" .. " zoom") or ""
end

local function snacks_profiler_module()
  if not lazyUtils.is_loaded "snacks.nvim" then
    return ""
  end
  local status = require("snacks.profiler").status()
  return status.cond() and (hl_str "StSnacksProfiler" .. " profile") or ""
end

local function diagnostics_module()
  if not rawget(vim, "lsp") then
    return ""
  end

  local errors_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local hints_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  local infos_count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  local errors = (errors_count and errors_count > 0)
      and (hl_str "StErrors" .. iconsUtils.diagnostic.Error .. " " .. errors_count)
    or ""
  local warnings = (warnings_count and warnings_count > 0)
      and (hl_str "StWarnings" .. iconsUtils.diagnostic.Warn .. " " .. warnings_count)
    or ""
  local hints = (hints_count and hints_count > 0)
      and (hl_str "StHints" .. iconsUtils.diagnostic.Hint .. " " .. hints_count)
    or ""
  local infos = (infos_count and infos_count > 0)
      and (hl_str "StInfos" .. iconsUtils.diagnostic.Info .. " " .. infos_count)
    or ""

  return table.concat(remove_empty_str { errors, warnings, hints, infos }, " ")
end

local function search_count_module()
  if vim.v.hlsearch == 0 then
    return ""
  end

  local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 500 })

  if not ok or next(result) == nil then
    return ""
  end

  local denominator = math.min(result.total, result.maxcount)
  local current_search = vim.fn.getreg "/"

  return hl_str "StSearch" .. string.format("%s [%d/%d]", current_search, result.current, denominator)
end

local function command_module()
  if not lazyUtils.is_loaded "noice.nvim" then
    return ""
  end
  if not require("noice").api.status.command.has() then
    return ""
  end
  return hl_str "StCommand" .. require("noice").api.status.command.get()
end

local function lazy_module()
  if not require("lazy.status").has_updates() then
    return ""
  end
  return hl_str "StLazy" .. require("lazy.status").updates()
end

local function macro_module()
  if not lazyUtils.is_loaded "noice.nvim" then
    return ""
  end
  if not require("noice").api.status.mode.has() then
    return ""
  end
  return hl_str "StMacro" .. require("noice").api.status.mode.get()
end

local function filetype()
  if not vim.tbl_contains({ "", "nowrite" }, vim.bo.bt) and not vim.fn.bufname():match "^Scratch %d+$" then
    return ""
  end

  if vim.bo.ft ~= "" then
    return hl_str "StModuleAlt" .. " " .. vim.bo.ft
  end

  return ""
end

local function lsp()
  if rawget(vim, "lsp") then
    local client_names = {}
    local client_names_ignore = { "copilot" }

    for _, client in ipairs(lspUtils.get_clients()) do
      if client.attached_buffers[vim.api.nvim_get_current_buf()] then
        if vim.tbl_contains(client_names_ignore, client.name) then
          goto continue
        end
        table.insert(client_names, client.name)
        ::continue::
      end
    end

    if #client_names == 0 then
      return ""
    end

    if #client_names > 1 then
      return hl_str "StLsp" .. " " .. #client_names
    end

    return hl_str "StLsp" .. " " .. client_names[1]
  end

  return ""
end

local function lsp_or_filetype_module()
  local lsp_str = lsp()

  if #lsp_str > 0 then
    return lsp_str
  end

  return filetype()
end

local function formatter_module()
  if not lazyUtils.is_loaded "conform.nvim" then
    return ""
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local formatter_names = {}

  for _, formatter in ipairs(formatUtils.resolve(bufnr)) do
    if #formatter.resolved > 0 and formatter.active then
      vim.list_extend(formatter_names, formatter.resolved)
    end
  end

  if #formatter_names == 0 then
    return ""
  end

  if #formatter_names > 1 then
    return hl_str "StFormatter" .. " " .. #formatter_names
  end

  return hl_str "StFormatter" .. " " .. formatter_names[1]
end

local function linter_module()
  if not lazyUtils.is_loaded "nvim-lint" then
    return ""
  end

  local buf = vim.api.nvim_get_current_buf()
  local linter_names = {}

  for _, linter in ipairs(lintUtils.resolve(buf)) do
    table.insert(linter_names, linter)
  end

  if #linter_names == 0 then
    return ""
  end

  if #linter_names > 1 then
    return hl_str "StLinter" .. " " .. #linter_names
  end

  return hl_str "StLinter" .. " " .. linter_names[1]
end

local function copilot_module()
  local clients = lspUtils.get_clients(), "copilot"
  local client_names = vim.tbl_map(function(client)
    return client.name
  end, clients)

  if not vim.tbl_contains(client_names, "copilot") then
    return ""
  end

  return hl_str "StCopilot" .. " "
end

local function indent_module()
  local str = ""

  if vim.bo.expandtab then
    str = vim.bo.shiftwidth .. ":󱁐"
  else
    str = vim.bo.tabstop .. ":󰌒"
  end

  return hl_str "StModuleAlt" .. str
end

local function dirname_relative_path()
  if vim.o.columns <= breakpoint then
    return ""
  end

  local dirname_path_str = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
  local dirname_str = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  local dirname_relative_path_str = string.sub(dirname_path_str, 1, -2 + string.len(dirname_str) * -1)

  if string.len(dirname_relative_path_str) > 30 then
    local parts = {}
    for part in string.gmatch(dirname_relative_path_str, "[^/]+") do
      table.insert(parts, part)
    end
    if #parts > 2 then
      local first_folder = parts[1]
      local last_folder = parts[#parts]
      dirname_relative_path_str = first_folder .. "/…/" .. last_folder
    end
  end

  return hl_merge("StRelativePath", "StModule") .. dirname_relative_path_str
end

local function dirname_module()
  local dirname_str = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  local dirname_relative_path_str = dirname_relative_path()

  return hl_str "StModuleSep"
    .. separators.r_b
    .. hl_str "StModule"
    .. " "
    .. hl_merge("StFolder", "StModule")
    .. iconsUtils.folder.default
    .. " "
    .. hl_str "StModule"
    .. dirname_str
    .. (#dirname_relative_path_str > 0 and " " .. dirname_relative_path_str or "")
    .. hl_str "StModule"
    .. " "
    .. hl_str "StModuleSep"
    .. separators.r
end

local function location_module()
  local m = vim.api.nvim_get_mode().mode
  local current_mode_hl = hl_str("St" .. modes[m][2] .. "Mode")
  local mode_sep_hl = hl_str("St" .. modes[m][2] .. "ModeSep")

  local col = fn.virtcol "."
  local line = fn.line "."
  local total_line = fn.line "$"
  local cursor = string.format("%3d:%-2d", line, col)
  local scroll = math.modf((line / total_line) * 100) .. tostring "%%"
  scroll = string.format("%4s", scroll)
  scroll = (line == 1 and "Top") or scroll
  scroll = (line == total_line and "Bot") or scroll

  return mode_sep_hl .. separators.r_b .. current_mode_hl .. " " .. cursor .. " " .. scroll .. " "
end

local M = {}

M.statusline = function()
  local modules = {
    mode_module() .. file_module(),
    -- git_branch_module(),
    git_branch_gitsigns_module(),
    -- git_diff_module(),
    diagnostics_module(),
    -- symbols_module(),
    -- NOTE: the following string takes all the available space
    "%=",
    -- search_count_module(),
    macro_module(),
    snacks_profiler_module(),
    maximize_status_module(),
    formatter_module(),
    linter_module(),
    lsp_or_filetype_module(),
    copilot_module(),
    command_module(),
    lazy_module(),
    indent_module(),
    dirname_module() .. location_module(),
  }

  return table.concat(remove_empty_str(modules), empty_space(2))
end

M.init = function()
  -- gitBranchUtils.init()
end

return M
