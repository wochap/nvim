local utils = require "custom.highlights.utils.init"
local theme = require "custom.highlights.catppuccin-mocha"

local nvimtreeBg = theme.base_30.darker_black
local tabuflineBg = theme.base_30.black
local tabuflineFg = theme.base_30.grey
local stModuleBg = theme.base_30.grey
local stModuleFg = theme.base_30.white
local statusline_fg = theme.base_30.white
local stateColors = {
  error = theme.base_30.red,
  warning = theme.base_30.yellow,
  info = theme.base_30.blue,
  hint = theme.base_30.teal,
}
local gitColors = {
  delete = theme.base_30.red,
  add = theme.base_30.green,
  change = theme.base_30.orange,
  info = theme.base_30.blue,
  stage = theme.base_30.purple,
}

local M = {
  -- Git signs
  GitSignsAdd = { fg = gitColors.add },
  GitSignsChange = { fg = gitColors.change },
  GitSignsDelete = { fg = gitColors.delete },

  -- Diffview
  DiffAdd = { bg = utils.darken(gitColors.add, 0.2, theme.base_16.base01) }, -- right diff add
  DiffChange = { bg = utils.darken(gitColors.change, 0.2, theme.base_16.base01) }, -- both diff change line
  DiffDelete = { bg = utils.darken(gitColors.delete, 0.2, theme.base_16.base01) }, -- right delete
  DiffText = { bg = utils.brighten(utils.darken(gitColors.change, 0.2, theme.base_16.base01), 0.3) }, -- both diff change text
  DiffviewDiffAddAsDelete = { bg = utils.darken(gitColors.delete, 0.2, theme.base_16.base01) }, -- left diff delete
  DiffviewDiffDelete = { fg = theme.base_16.base03 }, -- both diff delete sign
  DiffviewFilePanelCounter = { fg = theme.base_30.blue, bg = "NONE" },
  DiffviewFilePanelTitle = { fg = theme.base_30.red, bg = "NONE" },
  -- DiffviewNormal = { link = "NvimTreeNormal" },
  -- DiffviewVertSplit = { link = "VertSplit" },

  -- Conflict marker
  ConflictMarkerBegin = { bg = utils.darken(gitColors.add, 0.4, theme.base_16.base01) },
  ConflictMarkerOurs = { bg = utils.darken(gitColors.add, 0.2, theme.base_16.base01) },
  ConflictMarkerTheirs = { bg = utils.darken(gitColors.info, 0.2, theme.base_16.base01) },
  ConflictMarkerEnd = { bg = utils.darken(gitColors.info, 0.4, theme.base_16.base01) },
  ConflictMarkerCommonAncestorsHunk = { bg = theme.base_16.base01 },
  ConflictMarkerSeparator = { fg = theme.base_16.base0B },

  -- NvimTree
  NvimTreeEmptyFolderName = { fg = theme.base_30.white },
  NvimTreeExecFile = { fg = theme.base_30.white },
  NvimTreeFolderIcon = { fg = theme.base_30.blue },
  NvimTreeFolderName = { fg = theme.base_30.white },
  NvimTreeImageFile = { fg = theme.base_30.white },
  NvimTreeIndentMarker = { fg = theme.base_30.line },
  NvimTreeOpenedFolderName = { fg = theme.base_30.white },
  NvimTreeRootFolder = { fg = theme.base_30.lavender },
  NvimTreeSymlink = { fg = theme.base_30.white },

  NvimTreeEndOfBuffer = { fg = nvimtreeBg },
  NvimTreeNormal = { bg = nvimtreeBg },
  NvimTreeNormalNC = { bg = nvimtreeBg },
  NvimTreeWinSeparator = {
    fg = nvimtreeBg,
    bg = nvimtreeBg,
  },

  NvimTreeGitDeleted = { fg = gitColors.delete },
  NvimTreeGitDirty = { fg = gitColors.change },
  NvimTreeGitIgnored = { fg = theme.base_30.grey_fg },
  NvimTreeGitNew = { fg = gitColors.add },
  NvimTreeGitStaged = { fg = gitColors.stage },

  -- NvimSpectre
  SpectreSearch = {
    bg = utils.darken(gitColors.delete, 0.2, theme.base_16.base01),
    undercurl = true,
  },

  -- Diagnostics
  DiagnosticUnderlineError = { undercurl = true, sp = stateColors.error }, -- Used to underline "Error" diagnostics
  DiagnosticUnderlineWarn = { undercurl = true, sp = stateColors.warning }, -- Used to underline "Warning" diagnostics
  DiagnosticUnderlineInfo = { undercurl = true, sp = stateColors.info }, -- Used to underline "Information" diagnostics
  DiagnosticUnderlineHint = { undercurl = true, sp = stateColors.hint }, -- Used to underline "Hint" diagnostics
  ErrorMsg = { fg = stateColors.error }, -- error messages on the command line
  SpellBad = { sp = stateColors.error, undercurl = true }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
  SpellCap = { sp = stateColors.warning, undercurl = true }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
  SpellLocal = { sp = stateColors.info, undercurl = true }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
  SpellRare = { sp = stateColors.hint, undercurl = true }, -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
  DiagnosticError = { fg = stateColors.error }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
  DiagnosticWarn = { fg = stateColors.warning }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
  DiagnosticInfo = { fg = stateColors.info }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
  DiagnosticHint = { fg = stateColors.hint }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
  DiagnosticUnnecessary = { fg = utils.darken(theme.base_30.white, 0.667, theme.base_30.black), link = nil },
  DiagnosticVirtualTextError = { fg = stateColors.error }, -- Used for "Error" diagnostic virtual text
  DiagnosticVirtualTextWarn = { fg = stateColors.warning }, -- Used for "Warning" diagnostic virtual text
  DiagnosticVirtualTextInfo = { fg = stateColors.info }, -- Used for "Information" diagnostic virtual text
  DiagnosticVirtualTextHint = { fg = stateColors.hint }, -- Used for "Hint" diagnostic virtual text

  -- statusline
  St_lspInfo = {
    bg = theme.base_30.statusline_bg,
    fg = gitColors.add,
  },
  St_lspWarning = {
    bg = theme.base_30.statusline_bg,
    fg = gitColors.change,
  },
  St_lspError = {
    bg = theme.base_30.statusline_bg,
    fg = gitColors.delete,
  },
  ST_sep = {
    fg = stModuleBg,
    bg = theme.base_30.statusline_bg,
  },
  ST_module = {
    fg = stModuleFg,
    bg = stModuleBg,
  },
  St_relative_path = {
    fg = utils.darken(stModuleFg, 0.667, stModuleBg),
    bg = stModuleBg,
  },
  St_gitIcons = {
    fg = statusline_fg,
    bg = theme.base_30.statusline_bg,
    bold = false,
  },
  St_LspStatus = {
    fg = statusline_fg,
    bg = theme.base_30.statusline_bg,
  },

  -- rainbow-delimiters
  rainbow1 = { fg = theme.base_30.red },
  rainbow2 = { fg = theme.base_30.orange },
  rainbow3 = { fg = theme.base_30.yellow },
  rainbow4 = { fg = theme.base_30.vibrant_green },
  rainbow5 = { fg = theme.base_30.blue },
  rainbow6 = { fg = theme.base_30.lavender },

  -- tabufline
  TblineFill = {
    bg = tabuflineBg,
  },
  TbLineBufOff = {
    bg = tabuflineBg,
    fg = tabuflineFg,
  },
  TbLineBufOffModified = {
    bg = tabuflineBg,
  },
  TbLineBufOffClose = {
    bg = tabuflineBg,
  },
  TbLineTabOn = {
    bg = tabuflineBg,
    fg = theme.base_30.white,
    bold = false,
  },
  TbLineTabOff = {
    bg = tabuflineBg,
    fg = tabuflineFg,
  },

  -- cmp
  CmpDoc = {
    bg = utils.darken(theme.base_16.base02, 0.54, theme.base_16.base00),
  },
  CmpDocBorder = {
    fg = utils.darken(theme.base_16.base02, 0.54, theme.base_16.base00),
    bg = utils.darken(theme.base_16.base02, 0.54, theme.base_16.base00),
  },

  -- blankline
  IndentBlanklineSpaceChar = { bg = "NONE", fg = theme.base_30.grey },
  IndentBlanklineChar = { bg = "NONE", fg = theme.base_30.grey },
  IndentBlanklineContextStart = { bg = "NONE" },

  -- todo-comments
  TodoBgFix = { fg = theme.base_30.black2, bg = theme.base_30.red, bold = true },
  TodoBgHack = { fg = theme.base_30.black2, bg = theme.base_30.orange, bold = true },
  TodoBgNote = { fg = theme.base_30.black2, bg = theme.base_30.teal, bold = true },
  TodoBgPerf = { fg = theme.base_30.black2, bg = theme.base_30.purple, bold = true },
  TodoBgTest = { fg = theme.base_30.black2, bg = theme.base_30.purple, bold = true },
  TodoBgTodo = { fg = theme.base_30.black2, bg = theme.base_30.blue, bold = true },
  TodoBgWarn = { fg = theme.base_30.orange, bold = true },
  TodoFgFix = { fg = theme.base_30.red },
  TodoFgHack = { fg = theme.base_30.orange },
  TodoFgNote = { fg = theme.base_30.teal },
  TodoFgPerf = { fg = theme.base_30.purple },
  TodoFgTest = { fg = theme.base_30.purple },
  TodoFgTodo = { fg = theme.base_30.blue },
  TodoFgWarn = { fg = theme.base_30.orange },
  TodoSignFix = { link = "TodoFgFix" },
  TodoSignHack = { link = "TodoFgHack" },
  TodoSignNote = { link = "TodoFgNote" },
  TodoSignPerf = { link = "TodoFgPerf" },
  TodoSignTest = { link = "TodoFgTest" },
  TodoSignTodo = { link = "TodoFgTodo" },
  TodoSignWarn = { link = "TodoFgWarn" },

  -- nvim
  WinSeparator = {
    fg = theme.base_30.grey,
    bg = "NONE",
  },
  FoldColumn = {
    bg = theme.base_30.black,
    fg = theme.base_30.grey,
  },
}

local colors = theme.base_30
local function genModes_hl(modename, col)
  M["St_" .. modename .. "Mode"] = { fg = colors.black, bg = colors[col], bold = true }
  M["St_" .. modename .. "ModeSep"] = { fg = colors[col], bg = colors.statusline_bg }
end
genModes_hl("Normal", "nord_blue")
genModes_hl("Visual", "cyan")
genModes_hl("Insert", "dark_purple")
genModes_hl("Terminal", "green")
genModes_hl("NTerminal", "yellow")
genModes_hl("Replace", "orange")
genModes_hl("Confirm", "teal")
genModes_hl("Command", "green")
genModes_hl("Select", "blue")

return M
