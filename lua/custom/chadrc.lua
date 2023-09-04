local ui = require "custom.highlights"

local M = {}

M.plugins = "custom.plugins"

M.mappings = require "custom.mappings"

M.ui = require "custom.highlights"
-- HACK: `theme` doesn't have effect in `custom.highlights`
-- M.ui.theme = "chadracula"
M.ui.theme = "catppuccin"
M.ui.changed_themes = {
  catppuccin = {
    base_16 = {
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
    },
    base_30 = {
      white = "#B4BEFE",
      darker_black = "#181825",
      black = "#1E1E2E", --  nvim bg
      -- black2 = "#252434",
      -- one_bg = "#2d2c3c", -- real bg of onedark
      -- one_bg2 = "#363545",
      -- one_bg3 = "#3e3d4d",
      grey = "#45475a",
      grey_fg = "#6c7086",
      grey_fg2 = "#7f849c",
      -- light_grey = "#9399b2",
      red = "#F38BA8",
      baby_pink = "#eba0ac",
      -- pink = "#F5C2E7",
      line = "#45475A", -- for lines like vertsplit
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
      -- statusline_bg = "#232232",
      lightbg = "#313244",
      pmenu_bg = "#A6E3A1",
      folder_bg = "#89B4FA",
      -- lavender = "#c7d1ff",
    },
  },
}
local ov = {
  ["@punctuation.delimiter"] = { link = "PunctuationDelimiter" },
  ["@punctuation.bracket"] = { link = "PunctuationBracket" },
  ["@punctuation.special"] = { link = "PunctuationSpecial" },
  ["@field"] = { link = "Field" },
  ["@string"] = { link = "String" },
  ["@_expr"] = { link = "Expr" },
  ["@function.builtin"] = { link = "FunctionBuiltin" },
  ["@function.call"] = { link = "FunctionCall" },
  ["@operator"] = { link = "Operator" },
  ["@keyword.operator"] = { link = "KeywordOperator" },
  ["@keyword"] = { link = "Keyword" },
  ["@variable"] = { link = "Variable" },
  ["@type.builtin"] = { link = "TypeBuiltin" },
  ["@string.escape"] = { link = "StringEscape" },
  ["@parameter"] = { link = "Parameter" },
  ["@constant.builtin"] = { link = "ConstantBuiltin" },
  ["@tag.attribute"] = { link = "TagAttribute" },
  ["@constructor"] = { link = "Constructor" },
  ["@boolean.javascript"] = { link = "BooleanJavascript" },
  ["@constant.javascript"] = { link = "Variable" },
  ["@type.javascript"] = { link = "Variable" },
  ["@property"] = { link = "Property" },
  ["@tag.delimiter"] = { link = "TagDelimiter" },
  -- PunctuationDelimiter = { fg = "#94E2D5" },
  -- DelimiterSpecial = { fg = "#CDD6F4" },
  -- Field = { fg = "#CBA6F7" },
  -- -- Variable = { fg = "#F5E0DC" },
  -- Include = { fg = "#F38BA8" },
  -- Keyword = { fg = "#F38BA8" },
  -- -- Expr = { fg = "#f2cdcd" },
  -- Expr = { fg = "#000000", bg = "#ffffff" },
  -- Repeat = { fg = "#CBA6F7", bold = true },
  -- FunctionBuiltin = { fg = "#FAB387" },
  -- Operator = { fg = "#94E2D5", bold = true },
  -- Conditional = { bold = true },
  -- KeywordOperator = { fg = "#CBA6F7", bold = true },

  -- PunctuationDelimiter = { fg = "#94E2D5" },
  -- DelimiterSpecial = { fg = "#CDD6F4" },
  Field = { fg = "#F9E2AF" },
  Boolean = { fg = "#F38BA8" },
  -- -- Variable = { fg = "#F5E0DC" },
  Include = { fg = "#CBA6F7" },
  -- Keyword = { fg = "#F38BA8" },
  -- -- Expr = { fg = "#f2cdcd" },
  -- Expr = { fg = "#000000", bg = "#ffffff" },
  Repeat = { fg = "#CBA6F7", bold = true },
  FunctionBuiltin = { fg = "#FAB387" },
  Operator = { fg = "#94E2D5", bold = true },
  -- Conditional = { bold = true },
  KeywordOperator = { fg = "#CBA6F7", bold = true },
  FunctionCall = { fg = "#89B4FA" },
  PreProc = { link = "Comment" },
  TypeBuiltin = { fg = "#FAB387" },
  StringEscape = { fg = "#F5C2E7" },
  Parameter = { fg = "#eba0ac" },
  PunctuationBracket = { fg = "#F38BA8" },
  ConstantBuiltin = { fg = "#CBA6F7" },
  TagAttribute = { fg = "#f9e2af" },
  Constructor = { fg = "#89B4FA" },
  Tag = { fg = "#89B4FA" },
  BooleanJavascript = { fg = "#fab387" },
  Property = { link = "Variable" },
  TagDelimiter = { fg = "#94e2d5", bold = true },
}
M.ui.hl_override = ov
M.ui.hl_add = ov
return M
