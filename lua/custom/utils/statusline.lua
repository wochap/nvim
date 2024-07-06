local constants = require "custom.utils.constants"

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

local function hl_str(str)
  return "%#" .. str .. "#"
end

local function hl_merge(group1, group2)
  local fg = fn.synIDattr(fn.synIDtrans(fn.hlID(group1)), "fg#")
  local bg = fn.synIDattr(fn.synIDtrans(fn.hlID(group2)), "bg#")
  api.nvim_set_hl(0, "StModule" .. group1 .. group2, { fg = fg, bg = bg })
  return "%#" .. "StModule" .. group1 .. group2 .. "#"
end

local function empty_space(count)
  local count = count or 1
  return hl_str "StEmptySpace" .. (" "):rep(count)
end

local function mode()
  local m = vim.api.nvim_get_mode().mode
  local current_mode = hl_str("St" .. modes[m][2] .. "Mode") .. " " .. modes[m][1] .. " "
  local mode_sep = hl_str("St" .. modes[m][2] .. "ModeSep") .. separators.l
  return current_mode .. mode_sep
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
  local relative_path = vim.fn.fnamemodify(filename, ":~:.")
  relative_path = string.sub(relative_path, 1, -1 + string.len(filename_str) * -1)

  if string.len(relative_path) > 60 then
    local parts = {}
    for part in string.gmatch(relative_path, "[^/]+") do
      table.insert(parts, part)
    end
    if #parts > 2 then
      local first_folder = parts[1]
      local last_folder = parts[#parts]
      relative_path = first_folder .. "/…/" .. last_folder .. "/"
    end
  end

  return hl_merge("StRelativePath", "StModule") .. relative_path
end

local function filename()
  local filename = (fn.expand "%" == "" and "[No Name]") or fn.expand "%:t"
  return filename
end

local branch_cache = {}
local function git_branch()
  if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
    local cwd = vim.loop.cwd()
    if branch_cache[cwd] and branch_cache[cwd] ~= "" then
      local branch_name = " " .. branch_cache[cwd]
      vim.schedule(function()
        local output = vim.fn.systemlist "git rev-parse --abbrev-ref HEAD 2>/dev/null"
        branch_cache[cwd] = #output > 0 and output[1] or ""
      end)
      return hl_str "StModuleAlt" .. branch_name
    end
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
  local git_status = vim.b.gitsigns_status_dict
  local branch_name = " " .. git_status.head
  return hl_str "StModuleAlt" .. branch_name
end

local function git_diff()
  if not vim.b.gitsigns_head or vim.b.gitsigns_git_status or vim.o.columns < breakpoint then
    return ""
  end
  local git_status = vim.b.gitsigns_status_dict
  local added = (git_status.added and git_status.added ~= 0) and (hl_str "StGitAdd" .. "  " .. git_status.added)
    or ""
  local changed = (git_status.changed and git_status.changed ~= 0)
      and (hl_str "StGitChange" .. "  " .. git_status.changed)
    or ""
  local removed = (git_status.removed and git_status.removed ~= 0)
      and (hl_str "StGitDelete" .. "  " .. git_status.removed)
    or ""
  return added .. changed .. removed
end

local function maximize_status()
  -- requires declancm/maximize.nvim
  return hl_str "StMaximize" .. (vim.t.maximized and " zoom" or "")
end

local function diagnostics()
  if not rawget(vim, "lsp") then
    return ""
  end
  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  local infos = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  errors = (errors and errors > 0) and (hl_str "StErrors" .. constants.diagnostic_icons.Error .. "" .. errors .. " ")
    or ""
  warnings = (warnings and warnings > 0)
      and (hl_str "StWarnings" .. constants.diagnostic_icons.Warn .. "" .. warnings .. " ")
    or ""
  hints = (hints and hints > 0) and (hl_str "StHints" .. constants.diagnostic_icons.Hint .. "" .. hints .. " ") or ""
  infos = (infos and infos > 0) and (hl_str "StInfos" .. constants.diagnostic_icons.Info .. "" .. infos .. " ") or ""
  return errors .. warnings .. hints .. infos
end

local function fileType()
  if not vim.tbl_contains({ "", "nowrite" }, vim.bo.bt) and not vim.fn.bufname():match "^Scratch %d+$" then
    return ""
  end
  if vim.bo.ft ~= "" then
    return " " .. vim.bo.ft
  end
  return ""
end

local function lsp_or_filetype()
  if rawget(vim, "lsp") then
    local client_names = {}
    for _, client in ipairs(vim.lsp.get_active_clients()) do
      if client.attached_buffers[vim.api.nvim_get_current_buf()] then
        table.insert(client_names, client.name)
      end
    end
    if next(client_names) == nil then
      return fileType()
    end
    if #client_names > 1 then
      return hl_str "StLsp" .. " " .. #client_names
    end
    return hl_str "StLsp" .. " " .. client_names[1]
  end
  return fileType()
end

local function indent()
  if vim.bo.expandtab then
    return "␣:" .. vim.bo.shiftwidth
  else
    return "»:" .. vim.bo.tabstop
  end
end

local function dirname()
  return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
end

local function location()
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
  local maximize_status_str = maximize_status()
  local diagnostics_str = diagnostics()
  local modules = {
    mode(),
    hl_str "StModuleSep"
      .. separators.l_b
      .. hl_str "StModule"
      .. " "
      .. filetype_icon()
      .. relative_path()
      .. hl_str "StModule"
      .. filename()
      .. " "
      .. hl_str "StModuleSep"
      .. separators.l,
    empty_space(2) .. git_branch() .. empty_space(1) .. git_diff(),
    "%=",
    (#maximize_status_str > 0 and maximize_status_str .. empty_space(2) or ""),
    (#diagnostics_str > 0 and diagnostics_str .. empty_space(1) or ""),
    hl_str "StModuleAlt" .. lsp_or_filetype(),
    empty_space(2) .. hl_str "StModuleAlt" .. indent(),
    empty_space(2)
      .. hl_str "StModuleSep"
      .. separators.r_b
      .. hl_str "StModule"
      .. " "
      .. dirname()
      .. " "
      .. hl_str "StModuleSep"
      .. separators.r,
    location(),
  }
  return table.concat(modules, "")
end

return M
