local utils = require "custom.highlights.utils.init"
local theme = require "custom.highlights.catppuccin"
local C = theme.palette

local M = {
  -- Constructor = { fg = "#89B4FA" },
  -- FunctionCall = { fg = "#89B4FA" },
  BooleanJavascript = { fg = C.peach },
  BooleanNix = { fg = C.red },
  ConstantBuiltinPython = { fg = C.mauve },
  FieldNix = { fg = C.yellow },
  FunctionBuiltinPython = { fg = C.peach },
  KeywordOperatorPython = { fg = C.mauve },
  ParameterNix = { fg = C.maroon },
  PreProc = { link = "Comment" },
  Tag = { fg = C.blue },
  TagAttribute = { fg = C.yellow },
  TagDelimiter = { fg = C.teal },
}

return M
