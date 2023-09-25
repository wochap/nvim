local utils = require "custom.highlights.utils.init"
local theme = require "custom.highlights.catppuccin-mocha"
local C = theme.palette

local M = {
  DiagnosticUnnecessary = { fg = utils.darken(theme.base_30.white, 0.667, theme.base_30.black) },
}

return M
