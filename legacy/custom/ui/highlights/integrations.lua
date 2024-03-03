local utils = require "custom.ui.highlights.utils.init"
local theme = require "custom.ui.highlights.themes.catppuccin-mocha"
local mocha = theme.palette
local tabuflineBg = mocha.base
local tabuflineFg = mocha.surface1
local tabuflineFgActive = mocha.lavender

local M = {
  -- tabufline
  TblineFill = {
    bg = tabuflineBg,
  },
  TbLineBufOff = {
    bg = tabuflineBg,
    fg = tabuflineFg,
  },
  TbLineBufOn = {
    bg = tabuflineBg,
    fg = tabuflineFgActive,
  },
  TbLineBufOffModified = {
    bg = tabuflineBg,
    fg = tabuflineFg,
  },
  TbLineBufOffClose = {
    bg = tabuflineBg,
  },
  TbLineTabOn = {
    bg = tabuflineBg,
    fg = tabuflineFgActive,
    bold = false,
  },
  TbLineTabOff = {
    bg = tabuflineBg,
    fg = tabuflineFg,
  },

  -- nvim-cmp
  CmpDoc = {
    bg = utils.darken(mocha.surface0, 0.54, mocha.base),
  },
  CmpDocBorder = {
    fg = utils.darken(mocha.surface0, 0.54, mocha.base),
    bg = utils.darken(mocha.surface0, 0.54, mocha.base),
  },
}

return M
