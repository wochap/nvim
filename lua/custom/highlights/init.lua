local theme = require "custom.highlights.catppuccin"
local integrations = require "custom.highlights.integrations"
local syntax = require "custom.highlights.syntax"
local syntaxSpecific = require "custom.highlights.syntax-specific"

local hls = vim.tbl_deep_extend("force", integrations, syntax, syntaxSpecific)

-- if vim.fn.has "nvim" then
--    vim.g.terminal_color_0 = "#" .. "21222C"
--    vim.g.terminal_color_1 = "#" .. "FF5555"
--    vim.g.terminal_color_2 = "#" .. "50FA7B"
--    vim.g.terminal_color_3 = "#" .. "F1FA8C"
--    vim.g.terminal_color_4 = "#" .. "BD93F9"
--    vim.g.terminal_color_5 = "#" .. "FF79C6"
--    vim.g.terminal_color_6 = "#" .. "8BE9FD"
--    vim.g.terminal_color_7 = "#" .. "F8F8F2"
--    vim.g.terminal_color_8 = "#" .. "6272A4"
--    vim.g.terminal_color_9 = "#" .. "FF6E6E"
--    vim.g.terminal_color_10 = "#" .. "69FF94"
--    vim.g.terminal_color_11 = "#" .. "FFFFA5"
--    vim.g.terminal_color_12 = "#" .. "D6ACFF"
--    vim.g.terminal_color_13 = "#" .. "FF92DF"
--    vim.g.terminal_color_14 = "#" .. "A4FFFF"
--    vim.g.terminal_color_15 = "#" .. "FFFFFF"
-- end

return {
  theme_toggle = {},
  hl_add = hls,
  hl_override = hls,
  tabufline = require "custom.plugins.overrides.tabufline",
  statusline = require "custom.plugins.overrides.statusline",
  changed_themes = {
    catppuccin = theme,
  },
}
