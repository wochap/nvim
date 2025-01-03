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

vim.api.nvim_create_user_command("DiffClip", function()
  -- Check if there is a visual selection
  local mode = vim.fn.mode()
  local ft = vim.bo.filetype

  if mode == "v" or mode == "V" then
    -- Save the visual selection into the unnamed register
    vim.cmd 'normal! "vy'
  else
    -- Select the entire file if there is no selection
    vim.cmd 'normal! ggVG"vy'
  end

  vim.cmd [[
    tabnew [Selection]
    setlocal bufhidden=wipe buftype=nofile noswapfile
    put v
    0d_
    " Remove Windows CR
    silent %s/\r$//e
  ]]
  vim.bo.filetype = ft

  -- Open a new vertical split to display clipboard content
  vim.cmd [[
    vnew [Clipboard]
    setlocal bufhidden=wipe buftype=nofile noswapfile
    put +
    0d_
    " Remove Windows CR
    silent %s/\r$//e
  ]]
  vim.bo.filetype = ft

  -- Enable diff mode in both buffers
  vim.cmd "diffthis"
  vim.opt_local.winhl = table.concat({
    "DiffDelete:DiffviewDiffDeleteSign",
    "DiffChange:GitSignsAddPreview",
    "DiffText:GitSignsAddInline",
  }, ",")
  vim.cmd "wincmd p"
  vim.cmd "diffthis"
  vim.opt_local.winhl = table.concat({
    "DiffAdd:GitSignsDeletePreview",
    "DiffDelete:DiffviewDiffDeleteSign",
    "DiffChange:GitSignsDeletePreview",
    "DiffText:GitSignsDeleteInline",
  }, ",")
end, { desc = "Compare Selection or Active File with Clipboard", range = false })
