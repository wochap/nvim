local M = {}

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
