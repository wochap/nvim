-- HACK: save this file to trigger ReloadNvChad autocmd
-- every time you modify any file in highlights folder

local theme = require "custom.ui.highlights.themes.catppuccin-mocha"
local integrations = require "custom.ui.highlights.integrations"

local hls = vim.tbl_deep_extend("force", {}, integrations)

return {
  theme = "catppuccin",
  theme_toggle = {},
  hl_add = hls,
  hl_override = hls,
  -- disable lsp_semantic_tokens for better performance
  -- https://github.com/neovim/neovim/issues/23026
  -- NOTE: make sure to disable treesitter on buffers with semantic tokens to better performance
  lsp_semantic_tokens = true,
  tabufline = require "custom.custom-plugins.overrides.tabufline",
  statusline = require "custom.custom-plugins.overrides.statusline",
  changed_themes = {
    catppuccin = theme,
  },
  cmp = {
    style = "flat_dark",
  },
  -- HACK: if you remove any item from here
  -- make sure you also delete it in ~/.local/share/nvim/nvchad/base46
  extended_integrations = {},
  exclude_integrations = {
    "blankline",
    "defaults",
    "git",
    "lsp",
    "mason",
    "nvchad_updater",
    "nvdash",
    "nvimtree",
    "statusline",
    "syntax",
    "telescope",
    "treesitter",
    "whichkey",
  },
  nvdash = {
    load_on_startup = false,
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
