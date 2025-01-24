local langUtils = require "custom.utils.lang"

local M = {}

local function get_buf_size_in_mb(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  local file_size = vim.fn.getfsize(filepath)
  return math.floor(0.5 + (file_size / (1024 * 1024)))
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

local fn_pattern = "%.min%.[a-zA-Z]*$"
local ft_ignore_patterns = { "gitcommit", "gitrebase", "markdown", "tex", "bib", "typst" }
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
M.is_minfile = function(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
  return filename:match(fn_pattern)
    or (not langUtils.matches_any_regex(filetype, ft_ignore_patterns) and has_long_line(bufnr))
end

M.disable_ufo = function(bufnr, winid)
  local has_ufo, ufo = pcall(require, "ufo")
  if not has_ufo then
    return
  end
  pcall(ufo.detach, bufnr)
  if winid then
    vim.wo[winid].foldenable = false
    vim.wo[winid].foldcolumn = "0"
  else
    vim.opt_local.foldenable = false
    vim.opt_local.foldcolumn = "0"
  end
end

M.enable_ufo = function(bufnr)
  local has_ufo, ufo = pcall(require, "ufo")
  if not has_ufo then
    return
  end
  pcall(ufo.attach, bufnr)
  vim.opt_local.foldenable = true
  vim.opt_local.foldcolumn = "1"
end

M.autocmd = vim.api.nvim_create_autocmd

M.augroup = function(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

local files_count_cache = {}
M.in_big_project = function(cwd)
  cwd = cwd or vim.loop.cwd()
  local count = files_count_cache[cwd]
  if count == nil then
    local output = vim.fn.systemlist "(git ls-files --cached || fd --type f) | wc -l"
    count = #output > 0 and tonumber(output[1]) or 0
    files_count_cache[cwd] = count
  end
  if count >= 1000 then
    return true
  end
  return false
end

M.close_sidebars = function(ignore_sidebar)
  local has_neo_tree, neo_tree = pcall(require, "neo-tree.command")
  if has_neo_tree and ignore_sidebar ~= "neo_tree" then
    neo_tree.execute { action = "close" }
  end

  local has_nvim_tree, nvim_tree = pcall(require, "nvim-tree.api")
  if has_nvim_tree and ignore_sidebar ~= "nvim_tree" then
    nvim_tree.tree.close()
  end

  local has_avante, avante = pcall(require, "avante")
  if has_avante and ignore_sidebar ~= "avante" then
    avante.close_sidebar()
  end

  local has_dapui, dapui = pcall(require, "dapui")
  if has_dapui and ignore_sidebar ~= "dapui" then
    dapui.close()
  end
end

return M
