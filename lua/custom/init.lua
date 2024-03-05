local utils = require "custom.utils"

require "custom.options"

-- lazy load ./plugins/*
require "custom.lazy"

-- lazy load ./autocmds.lua, ./keymaps.lua, ./commands.lua
local lazy_autocmds = vim.fn.argc(-1) == 0
if not lazy_autocmds then
  require "custom.autocmds"
end
utils.autocmd("User", {
  group = utils.augroup "load_core",
  pattern = "VeryLazy",
  callback = function()
    if lazy_autocmds then
      require "custom.autocmds"
    end
    require "custom.keymaps"
    require "custom.commands"
  end,
})

vim.cmd.colorscheme "catppuccin"
