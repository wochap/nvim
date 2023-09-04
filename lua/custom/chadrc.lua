local ui = require "custom.highlights"

local M = {}

M.plugins = "custom.plugins"

M.mappings = require "custom.mappings"

M.ui = require "custom.highlights"
-- HACK: `theme` doesn't have effect in `custom.highlights`
-- M.ui.theme = "chadracula"
M.ui.theme = "catppuccin"

return M
