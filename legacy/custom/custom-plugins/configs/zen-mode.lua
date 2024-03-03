local M = {}

local utils = require "custom.utils"

M.options = {
  window = {
    backdrop = 1,
    width = 130, -- width of the Zen window
    height = 1, -- height of the Zen window
    options = {
      cursorline = false,
      cursorcolumn = false,
      number = false,
      relativenumber = false,
      signcolumn = "no",
      foldcolumn = "0",
    },
  },
  plugins = {
    options = {
      enabled = true,
      ruler = false, -- disables the ruler text in the cmd line area
      showcmd = false, -- disables the command in the last line of the screen
      laststatus = 0,
    },
    twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
    gitsigns = { enabled = true }, -- disables git signs
  },
  on_open = function()
    vim.cmd "IBLDisable"
    utils.disable_ufo()
    utils.disable_statuscol()

    -- TODO: disable inline.nvim
    -- local incline_ok, incline = pcall(require, "incline")
    -- if incline_ok then
    --   local on = incline.is_enabled()
    --   if on then
    --     incline.disable()
    --   end
    -- end
  end,
  on_close = function()
    vim.cmd "IBLEnable"

    -- TODO: enable inline.nvim
    -- local incline_ok, incline = pcall(require, "incline")
    -- if incline_ok then
    --   local on = incline.is_enabled()
    --   if not on then
    --     incline.enable()
    --   end
    -- end
  end,
}

return M
