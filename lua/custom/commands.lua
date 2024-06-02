vim.api.nvim_create_user_command("LazyHealth", function()
  vim.cmd [[Lazy! load all]]
  vim.cmd [[checkhealth]]
end, { desc = "Load all plugins and run :checkhealth" })

vim.api.nvim_create_user_command("WindowPicker", function(e)
  local ok, winid = pcall(require("window-picker").pick_window, {
    include_current_win = true,
  })

  if not ok then
    if e.fargs[1] ~= nil then
      vim.cmd("e " .. e.fargs[1])
    end
    return
  end

  if not winid then
    return
  end

  vim.api.nvim_set_current_win(winid)
  if e.fargs[1] ~= nil then
    vim.cmd("e " .. e.fargs[1])
  end
end, { nargs = "?", complete = "file" })
