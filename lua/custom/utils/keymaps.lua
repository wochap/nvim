local M = {}

M.close_all_floating = function()
  local present, cmp = pcall(require, "cmp")

  if not present then
    return
  end

  if cmp.visible() then
    return
  end

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local _, config = pcall(vim.api.nvim_win_get_config, win)
    -- TODO: close nui.nvim popups
    if config and config.relative ~= "" then
      local ok, _ = pcall(vim.api.nvim_win_close, win, false)
      vim.notify("closing window:" .. (not ok and " failed" or "") .. win)
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

  vim.notify("hi<" .. syn_name_start .. ">")
  vim.notify("trans<" .. syn_name_end .. ">")
  vim.notify("lo<" .. syn_trans_name .. ">")
end

M.print_buf_info = function()
  local winid = vim.api.nvim_get_current_win()
  local bufid = vim.api.nvim_win_get_buf(winid)
  local buftype = vim.api.nvim_buf_get_option(bufid, "buftype")
  local bufname = vim.api.nvim_buf_get_name(bufid)
  local filetype = vim.bo.filetype
  local floating = vim.api.nvim_win_get_config(winid).relative ~= ""

  vim.notify("winid " .. winid)
  vim.notify("bufid " .. bufid)
  vim.notify("buftype " .. buftype)
  vim.notify("bufname " .. bufname)
  vim.notify("filetype " .. filetype)
  vim.notify("floating " .. (floating and "yes" or "no"))
end

M.map = function(mode, lhs, rhs, desc, opts)
  if type(desc) == "table" then
    opts = desc
  end
  if not desc then
    desc = ""
  end
  if not opts then
    opts = {}
  end
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

M.exitTerminalMode = vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true)

local runExpr = function(expr)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(expr, true, false, true), "n", true)
end

M.getCloneLineFn = function(direction)
  return function()
    if vim.api.nvim_get_mode().mode == "v" then
      vim.cmd "normal! V"
    end
    local mode = vim.api.nvim_get_mode().mode
    if mode == "V" then
      vim.cmd 'normal! mz"zy'
      local start_line = vim.fn.line "'<"
      local end_line = vim.fn.line "'>"
      local num_lines = end_line - start_line + 1
      if direction == "down" then
        vim.cmd('normal! `]"zp`z' .. num_lines .. "j")
      elseif direction == "up" then
        vim.cmd('normal! `]"zP`z' .. num_lines .. "k")
      end
    elseif mode == "i" then
      if direction == "down" then
        runExpr '<C-o>mz<Esc>"zyy"zp`zi<Down>'
      elseif direction == "up" then
        runExpr '<C-o>mz<Esc>"zyy"zP`zi<Up>'
      end
    elseif mode == "n" then
      if direction == "down" then
        runExpr 'mz"zyy"zp`z<Down>'
      elseif direction == "up" then
        runExpr 'mz"zyy"zP`z<Up>'
      end
    end
  end
end

return M
