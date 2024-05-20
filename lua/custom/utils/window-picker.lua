local M = {}

local api = vim.api
local fn = vim.fn

M.window_pick = function()
  local winid = require("window-picker").pick_window()

  if not winid then
    return
  end

  api.nvim_set_current_win(winid)
end

M.window_swap = function()
  local winid = require("window-picker").pick_window()

  if not winid then
    return
  end

  local cur_winid = fn.win_getid()
  local cur_bufnr = api.nvim_win_get_buf(cur_winid)
  local target_bufnr = api.nvim_win_get_buf(winid)

  api.nvim_win_set_buf(cur_winid, target_bufnr)
  api.nvim_win_set_buf(winid, cur_bufnr)

  api.nvim_set_current_win(winid)
end

return M
