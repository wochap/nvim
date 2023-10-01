local theme = require "custom.highlights.catppuccin-mocha"
local integrations = require "custom.highlights.integrations"
local syntaxCatppuccin = require "custom.highlights.syntax-catppuccin"
local syntaxCustomCatppuccin = require "custom.highlights.syntax-custom-catppuccin"

local hls = vim.tbl_deep_extend("force", {}, integrations, syntaxCatppuccin, syntaxCustomCatppuccin)

return {
  theme_toggle = {},
  hl_add = hls,
  hl_override = hls,
  lsp_semantic_tokens = true,
  tabufline = require "custom.plugins.overrides.tabufline",
  statusline = require "custom.plugins.overrides.statusline",
  changed_themes = {
    catppuccin = theme,
  },
  cmp = {
    style = "flat_dark",
  },
  extended_integrations = { "dap", "trouble", "todo" },
  nvdash = {
    load_on_startup = true,
    buttons = {
      { "󰈚  New buffer", "Spc f n", "enew" },
      { "  Find File", "Spc f f", "Telescope find_files" },
      { "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
      { "󰈭  Find Word", "Spc f w", "Telescope live_grep" },
      { "  Bookmarks", "Spc f x", "Telescope marks" },
      { "  Mappings", "Spc c h", "NvCheatsheet" },
    },
  },
}
