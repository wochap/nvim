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

local function get_last_daily()
  local journal_dir = vim.fn.expand "~/Sync/zk/journal/"
  local files = vim.fn.globpath(journal_dir, "*.md", false, true)

  if #files == 0 then
    return nil
  end

  table.sort(files, function(a, b)
    return a > b -- Sort in descending order
  end)

  return files[1] -- Return the most recent file
end
M.open_last_daily = function()
  local last_daily_path = get_last_daily()
  vim.cmd("e " .. last_daily_path)
end

return M
