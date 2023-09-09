local M = {}

M.plugins = "custom.plugins"

M.mappings = require "custom.mappings"

M.ui = require "custom.highlights"
-- HACK: `theme` doesn't have effect in `custom.highlights`
-- because nvchad loads highlights from cache
-- M.ui.theme = "chadracula"
M.ui.theme = "catppuccin"

return M
