local M = {}

M.new = function()
  local title = vim.trim(vim.fn.input "Title: ")

  if title == "" then
    return
  end

  vim.cmd("ObsidianNew " .. title)
end

M.open_main = function()
  vim.cmd("e " .. vim.uv.cwd() .. "/main.md")
end

return M
