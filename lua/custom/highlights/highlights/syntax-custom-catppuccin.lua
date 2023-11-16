local utils = require "custom.highlights.utils.init"
local theme = require "custom.highlights.catppuccin-mocha"
local C = theme.palette

local M = {
  -- custom highlights so it matches vscode catppuccin-mocha theme
  -- source: https://github.com/nvim-treesitter/nvim-treesitter/commit/42ab95d5e11f247c6f0c8f5181b02e816caa4a4f#commitcomment-87014462

  ["@variable"] = { link = "Variable" },
  PreProc = { link = "Comment" },
  Todo = { fg = C.blue, bg = C.base },
  Error = { fg = C.red, bg = "NONE" }, -- (preferred) any erroneous construct

  lessCssAttribute = { fg = C.white, link = nil },

  zshCommands = { fg = C.blue },
  zshDeref = { fg = C.red },
  zshFunction = { fg = C.blue },
  zshShortDeref = { fg = C.text },
  zshSubst = { fg = C.red },
  zshSubstDelim = { fg = C.text },
  zshSubstQuoted = { fg = C.red },
  zshVariableDef = { fg = C.red },

  Tag = { fg = C.blue },
  TagAttribute = { fg = C.yellow },
  ["@tag.attribute"] = { link = "TagAttribute" },
  ["@tag.delimiter"] = { fg = C.teal },

  ["@boolean.javascript"] = { fg = C.peach },
  ["@constant.builtin.javascript"] = { fg = C.mauve },
  ["@constant.javascript"] = { link = "Variable" },
  ["@constructor.javascript"] = { fg = C.blue },
  ["@function.call.javascript"] = { fg = C.blue },
  ["@parameter.javascript"] = { fg = C.maroon },
  ["@property.javascript"] = { link = "Variable" },
  ["@tag.attribute.javascript"] = { link = "TagAttribute" },
  ["@type.javascript"] = { link = "Variable" },

  ["@boolean.nix"] = { fg = C.red },
  ["@constant.builtin.nix"] = { fg = C.red },
  ["@field.nix"] = { fg = C.yellow },
  ["@function.call.nix"] = { fg = C.maroon },
  ["@parameter.nix"] = { fg = C.maroon },
  ["@punctuation.bracket.nix"] = { fg = C.white },
  ["@string.special.nix"] = { fg = C.green },

  ["@boolean.python"] = { fg = C.mauve },
  ["@constant.builtin.python"] = { fg = C.mauve },
  ["@function.builtin.python"] = { fg = C.peach },
  ["@keyword.operator.python"] = { fg = C.mauve },
  ["@type.builtin.python"] = { fg = C.peach },
  ["@type.python"] = { link = "Variable" },

  ["@punctuation.special.markdown"] = { fg = C.teal },
  ["@text.title.1.markdown"] = { fg = C.red },
  ["@text.title.1.marker.markdown"] = { fg = C.red },
  ["@text.title.2.markdown"] = { fg = C.peach },
  ["@text.title.2.marker.markdown"] = { fg = C.peach },
  ["@text.title.3.markdown"] = { fg = C.yellow },
  ["@text.title.3.marker.markdown"] = { fg = C.yellow },
  ["@text.title.4.markdown"] = { fg = C.green },
  ["@text.title.4.marker.markdown"] = { fg = C.green },
  ["@text.title.5.markdown"] = { fg = C.blue },
  ["@text.title.5.marker.markdown"] = { fg = C.blue },
  ["@text.literal.markdown_inline"] = { fg = C.green },
  ["@text.reference.markdown_inline"] = { fg = C.lavender },
  ["@text.strong.markdown_inline"] = { fg = C.red },
  ["@text.uri.markdown_inline"] = { fg = C.blue },

  ["@field.lua"] = { link = "Variable" },
}

return M
