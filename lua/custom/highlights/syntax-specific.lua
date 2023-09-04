local utils = require "custom.highlights.utils.init"
local theme = require "custom.highlights.catppuccin"
local C = theme.palette

local M = {
  BooleanJavascript = { fg = C.peach },
  BooleanNix = { fg = C.red },
  ConstantBuiltinJavascript = { fg = C.mauve },
  ConstantBuiltinPython = { fg = C.mauve },
  ConstructorJavascript = { fg = C.blue },
  FieldNix = { fg = C.yellow },
  FunctionBuiltinPython = { fg = C.peach },
  FunctionCallJavascript = { fg = C.blue },
  KeywordOperatorPython = { fg = C.mauve },
  ParameterJavascript = { fg = C.maroon },
  ParameterNix = { fg = C.maroon },
  PreProc = { link = "Comment" },
  PunctuationSpecialMarkdown = { fg = C.teal },
  Tag = { fg = C.blue },
  TagAttribute = { fg = C.yellow },
  TagDelimiter = { fg = C.teal },
  TextLiteralMarkdownInline = { fg = C.green },
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
}

return M
