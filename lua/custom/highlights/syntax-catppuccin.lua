local utils = require "custom.highlights.utils.init"
local theme = require "custom.highlights.catppuccin-mocha"
local C = theme.palette

local M = {
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

  -- source: https://github.com/catppuccin/nvim/blob/main/lua/catppuccin/groups/syntax.lua
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

  Error = { fg = C.red }, -- (preferred) any erroneous construct

  -- https://github.com/catppuccin/nvim/blob/main/lua/catppuccin/groups/integrations/semantic_tokens.lua
  ["@lsp.type.boolean"] = { link = "@boolean" },
  ["@lsp.type.builtinType"] = { link = "@type.builtin" },
  ["@lsp.type.comment"] = { link = "@comment" },
  ["@lsp.type.enum"] = { link = "@type" },
  ["@lsp.type.enumMember"] = { link = "@constant" },
  ["@lsp.type.escapeSequence"] = { link = "@string.escape" },
  ["@lsp.type.formatSpecifier"] = { link = "@punctuation.special" },
  ["@lsp.type.interface"] = { fg = C.flamingo },
  ["@lsp.type.keyword"] = { link = "@keyword" },
  ["@lsp.type.namespace"] = { link = "@namespace" },
  ["@lsp.type.number"] = { link = "@number" },
  ["@lsp.type.operator"] = { link = "@operator" },
  ["@lsp.type.parameter"] = { link = "@parameter" },
  ["@lsp.type.property"] = { link = "@property" },
  ["@lsp.type.selfKeyword"] = { link = "@variable.builtin" },
  ["@lsp.type.typeAlias"] = { link = "@type.definition" },
  ["@lsp.type.unresolvedReference"] = { link = "@error" },
  ["@lsp.type.variable"] = {}, -- use treesitter styles for regular variables
  ["@lsp.typemod.class.defaultLibrary"] = { link = "@type.builtin" },
  ["@lsp.typemod.enum.defaultLibrary"] = { link = "@type.builtin" },
  ["@lsp.typemod.enumMember.defaultLibrary"] = { link = "@constant.builtin" },
  ["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
  ["@lsp.typemod.keyword.async"] = { link = "@keyword.coroutine" },
  ["@lsp.typemod.macro.defaultLibrary"] = { link = "@function.builtin" },
  ["@lsp.typemod.method.defaultLibrary"] = { link = "@function.builtin" },
  ["@lsp.typemod.operator.injected"] = { link = "@operator" },
  ["@lsp.typemod.string.injected"] = { link = "@string" },
  ["@lsp.typemod.type.defaultLibrary"] = { link = "@type.builtin" },
  ["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
  ["@lsp.typemod.variable.injected"] = { link = "@variable" },

  -- https://github.com/catppuccin/nvim/blob/main/lua/catppuccin/groups/integrations/treesitter.lua
  ["@comment"] = { link = "Comment" },
  ["@error"] = { link = "Error" },
  ["@preproc"] = { link = "PreProc" }, -- various preprocessor directives & shebangs
  ["@define"] = { link = "Define" }, -- preprocessor definition directives
  ["@operator"] = { link = "Operator" }, -- For any operator: +, but also -> and * in C.

  ["@punctuation.delimiter"] = { link = "Delimiter" }, -- For delimiters (e.g. `;` / `.` / `,`).
  ["@punctuation.bracket"] = { fg = C.overlay2 }, -- For brackets and parenthesis.
  ["@punctuation.special"] = { link = "Special" }, -- For special punctuation that does not fall in the categories before (e.g. `{}` in string interpolation).

  ["@string"] = { link = "String" }, -- For strings.
  ["@string.regex"] = { fg = C.peach }, -- For regexes.
  ["@string.escape"] = { fg = C.pink }, -- For escape characters within a string.
  ["@string.special"] = { link = "Special" }, -- other special strings (e.g. dates)

  ["@character"] = { link = "Character" }, -- character literals
  ["@character.special"] = { link = "SpecialChar" }, -- special characters (e.g. wildcards)

  ["@boolean"] = { link = "Boolean" }, -- For booleans.
  ["@number"] = { link = "Number" }, -- For all numbers
  ["@float"] = { link = "Float" }, -- For floats.

  ["@function"] = { link = "Function" }, -- For function (calls and definitions).
  ["@function.builtin"] = { fg = C.peach }, -- For builtin functions: table.insert in Lua.
  ["@function.call"] = { link = "Function" }, -- function calls
  ["@function.macro"] = { fg = C.teal }, -- For macro defined functions (calls and definitions): each macro_rules in Rust.
  ["@method"] = { link = "Function" }, -- For method definitions.
  ["@method.call"] = { link = "Function" }, -- For method calls.

  ["@constructor"] = { fg = C.sapphire }, -- For constructor calls and definitions: = { } in Lua, and Java constructors.
  ["@parameter"] = { fg = C.maroon }, -- For parameters of a function.

  ["@keyword"] = { link = "Keyword" }, -- For keywords that don't fall in previous categories.
  ["@keyword.function"] = { fg = C.mauve }, -- For keywords used to define a function.
  ["@keyword.operator"] = { fg = C.mauve }, -- For new keyword operator
  ["@keyword.return"] = { fg = C.mauve },
  ["@keyword.export"] = { fg = C.sky },

  ["@conditional"] = { link = "Conditional" }, -- For keywords related to conditionnals.
  ["@repeat"] = { link = "Repeat" }, -- For keywords related to loops.
  ["@label"] = { link = "Label" }, -- For labels: label: in C and :label: in Lua.
  ["@include"] = { link = "Include" }, -- For includes: #include in C, use or extern crate in Rust, or require in Lua.
  ["@exception"] = { link = "Exception" }, -- For exception related keywords.

  ["@type"] = { link = "Type" }, -- For types.
  ["@type.builtin"] = { fg = C.yellow }, -- For builtin types.
  ["@type.definition"] = { link = "Type" }, -- type definitions (e.g. `typedef` in C)
  ["@type.qualifier"] = { link = "Keyword" }, -- type qualifiers (e.g. `const`)

  ["@storageclass"] = { link = "StorageClass" }, -- visibility/life-time/etc. modifiers (e.g. `static`)
  ["@attribute"] = { link = "Constant" }, -- attribute annotations (e.g. Python decorators)
  ["@field"] = { fg = C.lavender }, -- For fields.
  ["@property"] = { fg = C.lavender }, -- Same as TSField.

  ["@variable"] = { fg = C.text }, -- Any variable name that does not have another highlight.
  ["@variable.builtin"] = { fg = C.red }, -- Variable names that are defined by the languages, like this or self.

  ["@constant"] = { link = "Constant" }, -- For constants
  ["@constant.builtin"] = { fg = C.peach }, -- For constant that are built in the language: nil in Lua.
  ["@constant.macro"] = { link = "Macro" }, -- For constants that are defined by macros: NULL in C.

  ["@namespace"] = { fg = C.lavender }, -- For identifiers referring to modules and namespaces.
  ["@symbol"] = { fg = C.flamingo },

  ["@text"] = { fg = C.text }, -- For strings considerated text in a markup language.
  ["@text.strong"] = { fg = C.maroon }, -- bold
  ["@text.emphasis"] = { fg = C.maroon }, -- italic
  ["@text.underline"] = { link = "Underline" }, -- underlined text
  ["@text.strike"] = { fg = C.text }, -- strikethrough text
  ["@text.title"] = { fg = C.blue }, -- titles like: # Example
  ["@text.literal"] = { fg = C.teal }, -- used for inline code in markdown and for doc in python (""")
  ["@text.uri"] = { fg = C.rosewater }, -- urls, links and emails
  ["@text.math"] = { fg = C.blue }, -- math environments (e.g. `$ ... $` in LaTeX)
  ["@text.environment"] = { fg = C.pink }, -- text environments of markup languages
  ["@text.environment.name"] = { fg = C.blue }, -- text indicating the type of an environment
  ["@text.reference"] = { link = "Tag" }, -- text references, footnotes, citations, etc.

  ["@text.todo"] = { fg = C.base, bg = C.yellow }, -- todo notes
  ["@text.todo.checked"] = { fg = C.green }, -- todo notes
  ["@text.todo.unchecked"] = { fg = C.overlay1 }, -- todo notes
  ["@text.note"] = { fg = C.base, bg = C.blue },
  ["@text.warning"] = { fg = C.base, bg = C.yellow },
  ["@text.danger"] = { fg = C.base, bg = C.red },

  ["@text.diff.add"] = { link = "diffAdded" }, -- added text (for diff files)
  ["@text.diff.delete"] = { link = "diffRemoved" }, -- deleted text (for diff files)

  ["@tag"] = { fg = C.mauve }, -- Tags like html tag names.
  ["@tag.attribute"] = { fg = C.teal }, -- Tags like html tag names.
  ["@tag.delimiter"] = { fg = C.sky }, -- Tag delimiter like < > /

  ["@function.builtin.bash"] = { fg = C.red },

  ["@text.title.2.markdown"] = { link = "rainbow2" },
  ["@text.title.1.markdown"] = { link = "rainbow1" },
  ["@text.title.3.markdown"] = { link = "rainbow3" },
  ["@text.title.4.markdown"] = { link = "rainbow4" },
  ["@text.title.5.markdown"] = { link = "rainbow5" },
  ["@text.title.6.markdown"] = { link = "rainbow6" },

  ["@constant.java"] = { fg = C.teal },

  ["@property.css"] = { fg = C.lavender },
  ["@property.id.css"] = { fg = C.blue },
  ["@property.class.css"] = { fg = C.yellow },
  ["@type.css"] = { fg = C.lavender },
  ["@type.tag.css"] = { fg = C.mauve },
  ["@string.plain.css"] = { fg = C.peach },
  ["@number.css"] = { fg = C.peach },

  ["@property.toml"] = { fg = C.blue }, -- Differentiates between string and properties

  ["@label.json"] = { fg = C.blue }, -- For labels: label: in C and :label: in Lua.

  ["@constructor.lua"] = { fg = C.flamingo }, -- For constructor calls and definitions: = { } in Lua.

  ["@property.typescript"] = { fg = C.lavender },
  ["@constructor.typescript"] = { fg = C.lavender },

  ["@constructor.tsx"] = { fg = C.lavender },
  ["@tag.attribute.tsx"] = { fg = C.mauve },

  ["@field.yaml"] = { fg = C.blue }, -- For fields.

  ["@symbol.ruby"] = { fg = C.flamingo },

  ["@method.php"] = { link = "Function" },
  ["@method.call.php"] = { link = "Function" },

  ["@type.builtin.c"] = { fg = C.yellow },
  ["@property.cpp"] = { fg = C.text },
  ["@type.builtin.cpp"] = { fg = C.yellow },

  gitcommitSummary = { fg = C.rosewater },
  zshKSHFunction = { link = "Function" },
}

return M
