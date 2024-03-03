local M = {}

local function string_in_list(s, list)
  for _, v in ipairs(list) do
    if v == s then
      return true
    end
  end
  return false
end

M.options = {
  next_buffer_cmd = function(windows)
    local tabufline = require "nvchad.tabufline"
    local bufs = tabufline.bufilter() or {}
    local alt_bufname = vim.fn.getreg "#"
    local alt_bufnr = vim.fn.bufnr(alt_bufname)
    tabufline.tabuflineNext()
    if string_in_list(alt_bufnr, bufs) then
      vim.cmd("b " .. alt_bufnr)
    end

    local bufnr = vim.api.nvim_get_current_buf()
    for _, window in ipairs(windows) do
      vim.api.nvim_win_set_buf(window, bufnr)
    end
  end,
}

return M
