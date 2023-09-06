local M = {}

M.setup = function()
  local tint = require "tint"

  tint.setup {
    tint = -20,
    highlight_ignore_patterns = { "WinSeparator", "Status.*", "IndentBlankline.*", "CursorLineNr", "LineNr" },
    window_ignore_function = function(winid)
      local bufid = vim.api.nvim_win_get_buf(winid)
      local buftype = vim.api.nvim_buf_get_option(bufid, "buftype")
      local bufname = vim.api.nvim_buf_get_name(bufid)
      local floating = vim.api.nvim_win_get_config(winid).relative ~= ""
      local isNvimTree = bufname:match "NvimTree_1$"

      return buftype == "terminal" or floating or isNvimTree
    end,
  }
end

return M
