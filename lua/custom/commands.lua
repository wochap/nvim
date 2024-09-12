vim.api.nvim_create_user_command("LazyHealth", function()
  vim.cmd [[Lazy! load all]]
  vim.cmd [[checkhealth]]
end, { desc = "Load all plugins and run :checkhealth" })

vim.api.nvim_create_user_command("WindowPicker", function(e)
  local file = e.fargs[1]
  if file == nil then
    return
  end

  -- unquote file string, lazyvim send it quoted
  if vim.startswith(file, '"') and vim.endswith(file, '"') then
    file = file:sub(2, -2)
  end

  local ok, winid = pcall(require("window-picker").pick_window, {
    include_current_win = true,
  })

  if not ok then
    vim.cmd("edit " .. file)
    return
  end

  if not winid then
    return
  end

  vim.api.nvim_set_current_win(winid)
  vim.cmd("edit " .. file)
end, { nargs = "?", complete = "file" })

-- open Nvim LSP in split
vim.api.nvim_create_user_command("LspLog", function()
  vim.cmd(string.format("vsplit %s", vim.lsp.get_log_path()))
end, {
  desc = "Opens the Nvim LSP client log.",
})
