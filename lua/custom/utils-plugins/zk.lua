local M = {}

M.new = function()
  local title = vim.trim(vim.fn.input "Title: ")

  if title == "" then
    return
  end

  require("zk.commands").get "ZkNew" { title = title }
end

M.open_main = function()
  vim.cmd("e " .. vim.fn.expand "~" .. "/Sync/zk/main.md")
end

return M
