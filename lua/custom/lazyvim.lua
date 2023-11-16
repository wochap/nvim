-- code necessary to integrate LazyVim in NvChad

local autocmd = vim.api.nvim_create_autocmd
local function augroup(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

-- LazyVim code to make formatting work in NvChad
vim.o.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
autocmd("User", {
  group = augroup("LazyVim", { clear = true }),
  pattern = "VeryLazy",
  callback = function()
    local Util = require "lazyvim.util"
    Util.format.setup()
  end,
})
