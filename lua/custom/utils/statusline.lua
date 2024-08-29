local constants = require "custom.utils.constants"
local iconsUtils = require "custom.utils.icons"
local lspUtils = require "custom.utils.lsp"

local fn = vim.fn
local api = vim.api
local breakpoint = 100
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

local function removeEmptyStr(list)
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

local function relative_path()
  if vim.o.columns < breakpoint then
    return ""
  end

  local filename_str = vim.fn.expand "%:t"
  if string.len(filename_str) == 0 then
    return ""
  end

  local filename = vim.api.nvim_buf_get_name(0)
  local relative_path_str = vim.fn.fnamemodify(filename, ":~:.")
  relative_path_str = string.sub(relative_path_str, 1, -2 + string.len(filename_str) * -1)

  if string.len(relative_path_str) > 60 then
    local parts = {}
    for part in string.gmatch(relative_path_str, "[^/]+") do
      table.insert(parts, part)
    end
    if #parts > 2 then
      local first_folder = parts[1]
      local last_folder = parts[#parts]
      relative_path_str = first_folder .. "/…/" .. last_folder
    end
  end

  return hl_merge("StRelativePath", "StModule") .. relative_path_str
end

local function filename()
  local filename_str = (fn.expand "%" == "" and "[No Name]") or fn.expand "%:t"

  return hl_str "StModule" .. filename_str
end

local function file_module()
  return hl_str "StModuleSep"
    .. separators.l_b
    .. hl_str "StModule"
    .. " "
    .. filetype_icon()
    .. filename()
    .. " "
    .. relative_path()
    .. hl_str "StModule"
    .. " "
    .. hl_str "StModuleSep"
    .. separators.l
end

local branch_cache = {}
local function git_branch_module()
  -- retrieve git branch from custom solution
  if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
    local cwd = vim.loop.cwd()

    -- try to return git branch from cache
    if branch_cache[cwd] and branch_cache[cwd] ~= "" then
      local branch_name = " " .. branch_cache[cwd]

      -- refresh cache
      vim.schedule(function()
        local output = vim.fn.systemlist "git rev-parse --abbrev-ref HEAD 2>/dev/null"
        branch_cache[cwd] = #output > 0 and output[1] or ""
      end)

      return hl_str "StModuleAlt" .. branch_name
    end

    -- git branch isn't in cache
    if branch_cache[cwd] ~= "" then
      local output = vim.fn.systemlist "git rev-parse --abbrev-ref HEAD 2>/dev/null"
      branch_cache[cwd] = #output > 0 and output[1] or ""

      if branch_cache[cwd] == "" then
        return ""
      end

      local branch_name = " " .. branch_cache[cwd]

      return hl_str "StModuleAlt" .. branch_name
    end

    return ""
  end

  -- retrieve git branch from gitsigns
  local git_status = vim.b.gitsigns_status_dict
  local branch_name = " " .. git_status.head

  return hl_str "StModuleAlt" .. branch_name
end

local function git_diff_module()
  if not vim.b.gitsigns_head or vim.b.gitsigns_git_status or vim.o.columns < breakpoint then
    return ""
  end

  local git_status = vim.b.gitsigns_status_dict
  local added = (git_status.added and git_status.added ~= 0) and (hl_str "StGitAdd" .. " " .. git_status.added) or ""
  local changed = (git_status.changed and git_status.changed ~= 0)
      and (hl_str "StGitChange" .. " " .. git_status.changed)
    or ""
  local removed = (git_status.removed and git_status.removed ~= 0)
      and (hl_str "StGitDelete" .. " " .. git_status.removed)
    or ""

  return table.concat(removeEmptyStr { added, changed, removed }, " ")
end

local function maximize_status_module()
  -- requires declancm/maximize.nvim
  return vim.t.maximized and (hl_str "StMaximize" .. " zoom") or ""
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
      and (hl_str "StErrors" .. iconsUtils.diagnostic.Error .. "" .. errors_count)
    or ""
  local warnings = (warnings_count and warnings_count > 0)
      and (hl_str "StWarnings" .. iconsUtils.diagnostic.Warn .. "" .. warnings_count)
    or ""
  local hints = (hints_count and hints_count > 0)
      and (hl_str "StHints" .. iconsUtils.diagnostic.Hint .. "" .. hints_count)
    or ""
  local infos = (infos_count and infos_count > 0)
      and (hl_str "StInfos" .. iconsUtils.diagnostic.Info .. "" .. infos_count)
    or ""

  return table.concat(removeEmptyStr { errors, warnings, hints, infos }, " ")
end

local function searchcount_module()
  if vim.v.hlsearch == 0 then
    return ""
  end

  local ok, result = pcall(vim.fn.searchcount, { maxcount = 999, timeout = 500 })

  if not ok or next(result) == nil then
    return ""
  end

  local denominator = math.min(result.total, result.maxcount)

  return hl_str "StSearchCount" .. string.format("[%d/%d]", result.current, denominator)
end

local function selectioncount_module()
  local mode = vim.fn.mode(true)
  local line_start, col_start = vim.fn.line "v", vim.fn.col "v"
  local line_end, col_end = vim.fn.line ".", vim.fn.col "."

  if mode:match "" then
    return string.format("%dx%d", math.abs(line_start - line_end) + 1, math.abs(col_start - col_end) + 1)
  elseif mode:match "V" or line_start ~= line_end then
    return math.abs(line_start - line_end) + 1
  elseif mode:match "v" then
    return math.abs(col_start - col_end) + 1
  else
    return ""
  end
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

    for _, client in ipairs(lspUtils.get_clients()) do
      if client.attached_buffers[vim.api.nvim_get_current_buf()] then
        table.insert(client_names, client.name)
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

local function indent_module()
  local str = ""

  if vim.bo.expandtab then
    str = vim.bo.shiftwidth .. ":󱁐"
  else
    str = vim.bo.tabstop .. ":󰌒"
  end

  return hl_str "StModuleAlt" .. str
end

local function dirname_module()
  local dirname = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")

  return hl_str "StModuleSep"
    .. separators.r_b
    .. hl_str "StModule"
    .. " "
    .. hl_merge("StFolder", "StModule")
    .. " "
    .. hl_str "StModule"
    .. dirname
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
    git_branch_module(),
    git_diff_module(),
    -- NOTE: the following string takes all the available space
    "%=",
    searchcount_module(),
    maximize_status_module(),
    diagnostics_module(),
    lsp_or_filetype_module(),
    indent_module(),
    dirname_module() .. location_module(),
  }

  return table.concat(removeEmptyStr(modules), empty_space(2))
end

return M
