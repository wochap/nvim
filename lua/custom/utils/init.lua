local langUtils = require "custom.utils.lang"

local M = {}

local function get_buf_size_in_mb(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local ok, stats = pcall(function()
    return vim.loop.fs_stat(vim.api.nvim_buf_get_name(bufnr))
  end)
  if not (ok and stats) then
    return
  end
  return math.floor(0.5 + (stats.size / (1024 * 1024)))
end

M.is_bigfile = function(bufnr, mb)
  local status_ok, is_bigfile_cached = pcall(vim.api.nvim_buf_get_var, bufnr, "is_bigfile")
  if status_ok then
    return is_bigfile_cached
  end

  local filesize = get_buf_size_in_mb(bufnr) or 0
  local is_bigfile = filesize >= mb

  if not is_bigfile then
    vim.api.nvim_buf_set_var(bufnr, "is_bigfile", false)
    return false
  end

  vim.api.nvim_buf_set_var(bufnr, "is_bigfile", true)
  return true
end

local function has_long_line(bufnr)
  -- get the first 10 lines
  local lines_count = vim.api.nvim_buf_line_count(bufnr)
  local lines_start = vim.api.nvim_buf_get_lines(bufnr, 0, 10, false)
  local lines_end = vim.api.nvim_buf_get_lines(bufnr, lines_count > 10 and lines_count - 9 or 0, lines_count, false)
  local max_line_length = 0
  local lines = vim.tbl_extend("force", {}, lines_start, lines_end)
  for _, line in ipairs(lines) do
    if #line > max_line_length then
      max_line_length = #line
    end
  end
  return max_line_length > 300
end

local fn_pattern = "%.min%.[a-zA-Z]*$"
local ft_patterns = { "gitcommit", "gitrebase", "markdown", "norg" }
M.is_minfile = function(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
  return filename:match(fn_pattern) or (not langUtils.matchesAnyRegex(filetype, ft_patterns) and has_long_line(bufnr))
end

M.disable_ufo = function()
  local has_ufo, ufo = pcall(require, "ufo")
  if not has_ufo then
    return
  end
  pcall(ufo.detach)
  vim.opt_local.foldenable = false
  vim.opt_local.foldcolumn = "0"
end

M.disable_statuscol = function(winid)
  vim.api.nvim_set_option_value("stc", "", { scope = "local", win = winid })
end

M.autocmd = vim.api.nvim_create_autocmd

M.augroup = function(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

M.get_buffer_root_path = function()
  local root_path = vim.fn.finddir(".git", ".;")
  if root_path == "" then
    root_path = vim.fn.findfile("package.json", ".;")
  end
  return vim.fn.fnamemodify(root_path, ":h")
end

return M
