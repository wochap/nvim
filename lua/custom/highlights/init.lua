local theme = require "custom.highlights.catppuccin-mocha"
local integrations = require "custom.highlights.integrations"
local syntax = require "custom.highlights.syntax"
local syntaxCatppuccin = require "custom.highlights.syntax-catppuccin"
local syntaxFixes = require "custom.highlights.syntax-fixes"

local hls = vim.tbl_deep_extend("force", integrations, syntaxFixes, syntaxCatppuccin, syntax)

return {
  theme_toggle = {},
  hl_add = hls,
  hl_override = hls,
  -- lsp_semantic_tokens = true,
  tabufline = require "custom.plugins.overrides.tabufline",
  statusline = require "custom.plugins.overrides.statusline",
  changed_themes = {
    catppuccin = theme,
  },
  cmp = {
    style = "flat_dark",
  },
}
