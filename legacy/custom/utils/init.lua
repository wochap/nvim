local M = {}

local function get_buf_size(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local ok, stats = pcall(function()
    return vim.loop.fs_stat(vim.api.nvim_buf_get_name(bufnr))
  end)
  if not (ok and stats) then
    return
  end
  return math.floor(0.5 + (stats.size / (1024 * 1024)))
end

M.is_bigfile = function(bufnr, maxfilesize)
  local status_ok, is_bigfile_cached = pcall(vim.api.nvim_buf_get_var, bufnr, "is_bigfile")
  if status_ok then
    return is_bigfile_cached
  end

  local filesize = get_buf_size(bufnr) or 0
  local is_bigfile = filesize >= maxfilesize

  if not is_bigfile then
    vim.api.nvim_buf_set_var(bufnr, "is_bigfile", false)
    return false
  end

  vim.api.nvim_buf_set_var(bufnr, "is_bigfile", true)
  return true
end

M.remove_str_from_list = function(list, str)
  for i, value in ipairs(list) do
    if value == str then
      table.remove(list, i)
    end
  end
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

M.disable_statuscol = function()
  vim.api.nvim_set_option_value("stc", "", { scope = "local" })
end

M.find_lazy_spec = function(tbl, target)
  for _, entry in ipairs(tbl) do
    if entry[1] == target then
      return entry
    end
  end
end

M.close_all_floating = function()
  local present, cmp = pcall(require, "cmp")

  if not present then
    return
  end

  if cmp.visible() then
    return
  end

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      local ok, _ = pcall(vim.api.nvim_win_close, win, false)
      vim.schedule(function()
        print("closing window:" .. (not ok and " failed" or ""), win)
      end)
    end
  end
end

M.print_syntax_info = function()
  local line = vim.fn.line "."
  local col = vim.fn.col "."

  -- Get the syntax ID of the character under the cursor
  local syn_id_start = vim.fn.synID(line, col, 1)
  local syn_id_end = vim.fn.synID(line, col, 0)

  -- Get the syntax names for the IDs
  local syn_name_start = vim.fn.synIDattr(syn_id_start, "name")
  local syn_name_end = vim.fn.synIDattr(syn_id_end, "name")

  -- Get the syntax name after translation
  local syn_trans_id = vim.fn.synIDtrans(syn_id_start)
  local syn_trans_name = vim.fn.synIDattr(syn_trans_id, "name")

  print("hi<" .. syn_name_start .. ">")
  print("trans<" .. syn_name_end .. ">")
  print("lo<" .. syn_trans_name .. ">")
end

M.print_buf_info = function()
  local winid = vim.api.nvim_get_current_win()
  local bufid = vim.api.nvim_win_get_buf(winid)
  local buftype = vim.api.nvim_buf_get_option(bufid, "buftype")
  local bufname = vim.api.nvim_buf_get_name(bufid)
  local filetype = vim.bo.filetype
  local floating = vim.api.nvim_win_get_config(winid).relative ~= ""

  print("winid " .. winid)
  print("bufid " .. bufid)
  print("buftype " .. buftype)
  print("bufname " .. bufname)
  print("filetype " .. filetype)
  print("floating " .. (floating and "yes" or "no"))
end

return M
