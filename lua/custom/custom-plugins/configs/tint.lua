local M = {}

M.options = {
  tint = -20,
  highlight_ignore_patterns = {
    "WinSeparator",
    "Status.*",
    "CursorLineNr",
    "LineNr",
  },
  window_ignore_function = function(winid)
    local bufid = vim.api.nvim_win_get_buf(winid)
    local buftype = vim.api.nvim_buf_get_option(bufid, "buftype")
    local bufname = vim.api.nvim_buf_get_name(bufid)
    local floating = vim.api.nvim_win_get_config(winid).relative ~= ""
    local isNvimTree = bufname:match "NvimTree_1$"
    local isDap = bufname:match "%[dap%-repl%]$" or bufname:match "%/DAP .*$"

    return buftype == "terminal" or floating or isNvimTree or isDap
  end,
}

return M
