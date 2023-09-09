local utils = require "custom.highlights.utils.init"
local theme = require "custom.highlights.catppuccin-mocha"
local C = theme.palette

local M = {
  -- overrides so nvim theme matches https://github.com/catppuccin/vscode
  -- source: https://github.com/catppuccin/nvim/blob/main/lua/catppuccin/groups/editor.lua
  Conceal = { fg = C.overlay1 }, -- placeholder characters substituted for concealed text (see 'conceallevel')
  Cursor = { fg = C.base, bg = C.text }, -- character under the cursor
  lCursor = { fg = C.base, bg = C.text }, -- the character under the cursor when |language-mapping| is used (see 'guicursor')
  CursorIM = { fg = C.base, bg = C.text }, -- like Cursor, but used when in IME mode |CursorIM|
  CursorColumn = { bg = C.mantle }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
  CursorLine = {
    bg = utils.darken(C.surface0, 0.64, C.base),
  }, -- Screen-line at the cursor, when 'cursorline' is set.  Low-priority if forecrust (ctermfg OR guifg) is not set.
  VertSplit = { fg = C.crust }, -- the column separating vertically split windows
  Substitute = { bg = C.surface1, fg = C.pink }, -- |:substitute| replacement text highlighting
  MatchParen = { fg = C.peach, bg = C.surface1 }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
  Search = { bg = utils.darken(C.sky, 0.30, C.base), fg = C.text }, -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
  IncSearch = { bg = utils.darken(C.sky, 0.90, C.base), fg = C.mantle }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
  CurSearch = { bg = C.red, fg = C.mantle }, -- 'cursearch' highlighting: highlights the current search you're on differently
  SpecialKey = { link = "NonText" }, -- Unprintable characters: text displayed differently from what it really is.  But not 'listchars' textspace. |hl-Whitespace|
  NonText = { fg = C.overlay0 }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.

  Comment = { fg = C.overlay0 }, -- just comments
  SpecialComment = { link = "Special" }, -- special things inside a comment
  Constant = { fg = C.peach }, -- (preferred) any constant
  String = { fg = C.green }, -- a string constant: "this is a string"
  Character = { fg = C.teal }, --  a character constant: 'c', '\n'
  Number = { fg = C.peach }, --   a number constant: 234, 0xff
  Float = { link = "Number" }, --    a floating point constant: 2.3e10
  Boolean = { fg = C.peach }, --  a boolean constant: TRUE, false
  Identifier = { fg = C.flamingo }, -- (preferred) any variable name
  Function = { fg = C.blue }, -- function name (also: methods for classes)
  Statement = { fg = C.mauve }, -- (preferred) any statement
  Conditional = { fg = C.mauve }, --  if, then, else, endif, switch, etc.
  Repeat = { fg = C.mauve }, --   for, do, while, etc.
  Label = { fg = C.sapphire }, --    case, default, etc.
  Operator = { fg = C.sky }, -- "sizeof", "+", "*", etc.
  Keyword = { fg = C.mauve }, --  any other keyword
  Exception = { fg = C.mauve }, --  try, catch, throw

  PreProc = { fg = C.pink }, -- (preferred) generic Preprocessor
  Include = { fg = C.mauve }, --  preprocessor #include
  Define = { link = "PreProc" }, -- preprocessor #define
  Macro = { fg = C.mauve }, -- same as Define
  PreCondit = { link = "PreProc" }, -- preprocessor #if, #else, #endif, etc.

  StorageClass = { fg = C.yellow }, -- static, register, volatile, etc.
  Structure = { fg = C.yellow }, --  struct, union, enum, etc.
  Special = { fg = C.pink }, -- (preferred) any special symbol
  Type = { fg = C.yellow }, -- (preferred) int, long, char, etc.
  Typedef = { link = "Type" }, --  A typedef
  SpecialChar = { link = "Special" }, -- special character in a constant
  Tag = { fg = C.lavender }, -- you can use CTRL-] on this
  Delimiter = { fg = C.overlay2 }, -- character that needs attention
  Debug = { link = "Special" }, -- debugging statements
}

return M
