local customPlugins = require "custom.plugins"

local M = {}

M.plugins = {
   override = customPlugins.override,
   remove = {},
   user = customPlugins.user,
}

M.mappings = require "custom.mappings"

M.ui = require "custom.highlights"

return M
