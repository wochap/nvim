local theme = require "custom.highlights.catppuccin-mocha"
local integrations = require "custom.highlights.integrations"
local syntaxCatppuccin = require "custom.highlights.syntax-catppuccin"
local syntaxCustomCatppuccin = require "custom.highlights.syntax-custom-catppuccin"

local hls = vim.tbl_deep_extend("force", integrations, syntaxCatppuccin, syntaxCustomCatppuccin)

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
