local utils = require "custom.ui.highlights.utils.init"
local catppuccin_nvchad = require "custom.ui.highlights.themes.catppuccin-nvchad"

local M = {}

M.base_30 = {
  white = "#cdd6f4",
  darker_black = "#181825",
  black = "#1E1E2E", -- nvim bg
  black2 = utils.darken("#313244", 0.64, "#1e1e2e"),
  -- one_bg = "#2d2c3c", -- real bg of onedark
  -- one_bg2 = "#363545",
  -- one_bg3 = "#3e3d4d",
  grey = "#45475a", -- line number
  grey_fg = "#6c7086", -- comment
  grey_fg2 = "#7f849c",
  light_grey = "#6c7086",
  red = "#F38BA8",
  baby_pink = "#eba0ac",
  -- pink = "#F5C2E7",
  line = "#45475a", -- for lines like vertsplit
  green = "#A6E3A1",
  -- vibrant_green = "#b6f4be",
  -- nord_blue = "#8bc2f0",
  blue = "#89B4FA",
  yellow = "#F9E2AF",
  -- sun = "#ffe9b6",
  -- purple = "#d0a9e5",
  -- dark_purple = "#c7a0dc",
  -- teal = "#B5E8E0",
  orange = "#FAB387",
  cyan = "#94E2D5",
  statusline_bg = "#1E1E2E",
  lightbg = "#181825",
  pmenu_bg = "#A6E3A1",
  folder_bg = "#89B4FA",
  lavender = "#b4befe",
}
M.base_30 = vim.tbl_deep_extend("force", {}, catppuccin_nvchad.base_30, M.base_30)

M.base_16 = {
  base00 = "#1E1E2E", -- base
  base01 = "#181825", -- mantle
  base02 = "#313244", -- surface0
  base03 = "#45475A", -- surface1
  base04 = "#585B70", -- surface2
  base05 = "#CDD6F4", -- text
  base06 = "#F5E0DC", -- rosewater
  base07 = "#B4BEFE", -- lavender
  base08 = "#F38BA8", -- red
  base09 = "#FAB387", -- peach
  base0A = "#F9E2AF", -- yellow
  base0B = "#A6E3A1", -- green
  base0C = "#94E2D5", -- teal
  base0D = "#89B4FA", -- blue
  base0E = "#CBA6F7", -- mauve
  base0F = "#f2cdcd", -- flamingo
}

M.palette = {
  rosewater = "#f5e0dc",
  flamingo = "#f2cdcd",
  pink = "#f5c2e7",
  mauve = "#cba6f7",
  red = "#f38ba8",
  maroon = "#eba0ac",
  peach = "#fab387",
  yellow = "#f9e2af",
  green = "#a6e3a1",
  teal = "#94e2d5",
  sky = "#89dceb",
  sapphire = "#74c7ec",
  blue = "#89b4fa",
  lavender = "#b4befe",
  text = "#cdd6f4",
  subtext1 = "#bac2de",
  subtext0 = "#a6adc8",
  overlay2 = "#9399b2",
  overlay1 = "#7f849c",
  overlay0 = "#6c7086",
  surface2 = "#585b70",
  surface1 = "#45475a",
  surface0 = "#313244",
  base = "#1e1e2e",
  mantle = "#181825",
  crust = "#11111b",
}

return M
