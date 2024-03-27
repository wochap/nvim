local utils = require "custom.utils"

-- PERF: disable nvim syntax, which causes severe lag
-- however you can still enable it per buffer with a
-- FileType autocmd that calls `:set syntax=<filetype>`
vim.cmd.syntax "manual"

require "custom.options"
require "custom.globals"

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

local lazyCoreUtils = require "lazy.core.util"
lazyCoreUtils.track "colorscheme"
vim.cmd.colorscheme "catppuccin"
lazyCoreUtils.track()
