-- profile startup
if vim.env.PROF then
  local snacks = vim.fn.stdpath "data" .. "/lazy/snacks.nvim"
  vim.opt.rtp:append(snacks)
  require("snacks.profiler").startup {
    startup = {
      -- event = "VimEnter",
      -- event = "UIEnter",
      event = "VeryLazy",
    },
  }
end

-- enable experimental Lua module loader
vim.loader.enable()

local constants = require "custom.utils.constants"
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
if constants.has_file_arg then
  require "custom.autocmds"
end
utils.autocmd("User", {
  group = utils.augroup "load_core",
  pattern = "VeryLazy",
  callback = function()
    if not constants.has_file_arg then
      require "custom.autocmds"
    end
    require "custom.keymaps"
    require "custom.macros"
    require "custom.commands"
  end,
})

vim.cmd.colorscheme "catppuccin"
