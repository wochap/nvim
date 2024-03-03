require "custom.options"

-- lazy load lua/custom/plugins/*
require "custom.lazy"

-- lazy load autocmds, keymaps
local lazy_autocmds = vim.fn.argc(-1) == 0
if not lazy_autocmds then
  require "custom.autocmds"
end
local group = vim.api.nvim_create_augroup("LazyVim", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "VeryLazy",
  callback = function()
    if lazy_autocmds then
      require "custom.autocmds"
    end
    require "custom.keymaps"
  end,
})
