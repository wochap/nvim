vim.api.nvim_create_user_command("LazyHealth", function()
  vim.cmd [[Lazy! load all]]
  vim.cmd [[checkhealth]]
end, { desc = "Load all plugins and run :checkhealth" })

vim.api.nvim_create_user_command("Pick", function(e)
  local Filter = require "window-picker.filters.default-window-filter"
  local filter = Filter:new()
  local all_windows = vim.api.nvim_tabpage_list_wins(0)
  local fwindows = filter:filter_windows(all_windows)

  if #fwindows <= 1 then
    if e.fargs[1] ~= nil then
      vim.cmd("e " .. e.fargs[1])
    end
    return
  end

  local winid = require("window-picker").pick_window {
    include_current_win = true,
  }
  if not winid then
    return
  end

  vim.api.nvim_set_current_win(winid)
  if e.fargs[1] ~= nil then
    vim.cmd("e " .. e.fargs[1])
  end
end, { nargs = "?", complete = "file" })
