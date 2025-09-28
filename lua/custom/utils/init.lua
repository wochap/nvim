local constants = require "custom.utils.constants"
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
local ft_ignore_patterns = constants.text_filetypes
local function has_long_line(bufnr)
  -- get the first 10 lines
  local lines_count = vim.api.nvim_buf_line_count(bufnr)
  local lines_start = vim.api.nvim_buf_get_lines(bufnr, 0, 10, false)
  local lines_end = vim.api.nvim_buf_get_lines(bufnr, lines_count > 10 and lines_count - 9 or 0, lines_count, false)
  local max_line_length = 0
  local lines = langUtils.list_merge(lines_start, lines_end)
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

M.autocmd = vim.api.nvim_create_autocmd

M.augroup = function(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

M.close_right_sidebars = function(ignore_sidebar)
  local has_neo_tree = package.loaded["neo-tree"]
  if has_neo_tree and ignore_sidebar ~= "neo_tree_git" then
    require("neo-tree.command").execute { action = "close", source = "git_status" }
  end

  if has_neo_tree and ignore_sidebar ~= "neo_tree_filesystem" then
    require("neo-tree.command").execute { action = "close", source = "filesystem" }
  end

  -- local has_dap_view = package.loaded["dap-view"]
  -- if has_dap_view and ignore_sidebar ~= "dap-view" then
  --   require("dap-view").close()
  -- end
end

M.close_left_sidebars = function(ignore_sidebar)
  local has_avante = package.loaded["avante"]
  if has_avante and ignore_sidebar ~= "avante" then
    require("avante").close_sidebar()
  end

  local has_neotest = package.loaded["neotest"]
  if has_neotest and ignore_sidebar ~= "neotest" then
    require("neotest").summary.close()
  end
end

M.bufname_valid = function(bufname)
  if bufname:match "^/" or bufname:match "^[a-zA-Z]:" or bufname:match "^zipfile://" or bufname:match "^tarfile:" then
    return true
  end
  return false
end

M.replace_visual_selection = function(text)
  local start_line, start_col = vim.fn.getpos("'<")[2], vim.fn.getpos("'<")[3]
  local end_line, end_col = vim.fn.getpos("'>")[2], vim.fn.getpos("'>")[3]

  if start_line == end_line then
    local line = vim.fn.getline(start_line)
    local new_line = line:sub(1, start_col - 1) .. text .. line:sub(end_col + 1)
    vim.fn.setline(start_line, new_line)
    return
  end
end

M.get_visual_selection = function()
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  local start_line, start_col = start_pos[2], start_pos[3]
  local end_line, end_col = end_pos[2], end_pos[3]
  local line = vim.fn.getline(start_line)

  if start_line == end_line then
    return string.sub(line, start_col, end_col)
  end

  return nil
end

M.set_timeout = function(ms, callback)
  local timer = vim.loop.new_timer()
  timer:start(ms, 0, function()
    -- Stop and close the timer
    timer:stop()
    timer:close()

    -- Schedule the callback to run on the main thread
    vim.schedule(callback)
  end)
end

return M
