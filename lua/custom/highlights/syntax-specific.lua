local utils = require "custom.highlights.utils.init"
local theme = require "custom.highlights.catppuccin-mocha"
local C = theme.palette

-- overrides so nvim theme matches https://github.com/catppuccin/vscode
local M = {
  PreProc = { link = "Comment" },
  Tag = { fg = C.blue },
  TagAttribute = { fg = C.yellow },
  zshCommands = { fg = C.blue },
  zshDeref = { fg = C.red },
  zshFunction = { fg = C.blue },
  zshShortDeref = { fg = C.text },
  zshSubst = { fg = C.red },
  zshSubstDelim = { fg = C.text },
  zshSubstQuoted = { fg = C.red },
  zshVariableDef = { fg = C.red },

  ["@boolean.javascript"] = { fg = C.peach },
  ["@boolean.nix"] = { fg = C.red },
  ["@boolean.python"] = { fg = C.mauve },
  ["@constant.builtin.javascript"] = { fg = C.mauve },
  ["@constant.builtin.nix"] = { fg = C.red },
  ["@constant.builtin.python"] = { fg = C.mauve },
  ["@constructor.javascript"] = { fg = C.blue },
  ["@field.nix"] = { fg = C.yellow },
  ["@function.builtin.python"] = { fg = C.peach },
  ["@function.call.javascript"] = { fg = C.blue },
  ["@function.call.nix"] = { fg = C.maroon },
  ["@keyword.operator.python"] = { fg = C.mauve },
  ["@parameter.javascript"] = { fg = C.maroon },
  ["@parameter.nix"] = { fg = C.maroon },
  ["@punctuation.bracket.nix"] = { fg = C.white },
  ["@punctuation.special.markdown"] = { fg = C.teal },
  ["@string.special.nix"] = { fg = C.green },
  ["@tag.delimiter"] = { fg = C.teal },
  ["@text.literal.markdown_inline"] = { fg = C.green },
  ["@text.reference.markdown_inline"] = { fg = C.lavender },
  ["@text.strong.markdown_inline"] = { fg = C.red },
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
  ["@text.uri.markdown_inline"] = { fg = C.blue },
  ["@type.builtin.python"] = { fg = C.peach },
}

return M