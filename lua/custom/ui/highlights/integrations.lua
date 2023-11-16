local utils = require "custom.ui.highlights.utils.init"
local theme = require "custom.ui.highlights.catppuccin-mocha"

local nvimtreeBg = theme.base_30.darker_black
local tabuflineBg = theme.base_30.black
local tabuflineFg = theme.base_30.grey
local tabuflineFgActive = theme.base_30.lavender
local stModuleBg = theme.base_16.base02
local stModuleFg = theme.base_30.white
local statusline_fg = theme.base_30.white
local stateColors = {
  error = theme.base_30.red,
  warning = theme.base_30.yellow,
  info = theme.base_30.blue,
  hint = theme.base_30.purple,
}
local gitColors = {
  delete = theme.base_30.red,
  add = theme.base_30.green,
  change = theme.base_30.orange,
  info = theme.base_30.blue,
  stage = theme.base_30.purple,
  ancestor = theme.base_30.white,
}

local M = {
  -- gitsigns.nvim
  GitSignsAdd = { fg = gitColors.add },
  GitSignsChange = { fg = gitColors.change },
  GitSignsDelete = { fg = gitColors.delete },
  GitSignsStagedAdd = { fg = gitColors.stage },
  GitSignsStagedChange = { link = "GitSignsStagedAdd" },
  GitSignsStagedDelete = { link = "GitSignsStagedAdd" },
  GitSignsDeleteInline = { link = "DiffviewDiffDeleteText" },
  GitSignsAddInline = { link = "DiffviewDiffAddText" },
  GitSignsAddPreview = { link = "DiffAdd" },
  GitSignsDeletePreview = { link = "DiffDelete" },

  -- nvim diff
  DiffAdd = { bg = utils.darken(gitColors.add, 0.2, theme.base_16.base01), fg = "NONE" },
  DiffChange = { bg = utils.darken(gitColors.change, 0.2, theme.base_16.base01), fg = "NONE" },
  DiffDelete = { bg = utils.darken(gitColors.delete, 0.2, theme.base_16.base01), fg = "NONE" },
  DiffText = { bg = utils.brighten(utils.darken(gitColors.change, 0.2, theme.base_16.base01), 0.15), fg = "NONE" },
  -- diffAdded = { fg = gitColors.add },
  -- diffRemoved = { fg = gitColors.delete },
  -- diffChanged = { fg = gitColors.change },
  -- diffOldFile = { fg = theme.palette.yellow },
  -- diffNewFile = { fg = theme.palette.peach },
  -- diffFile = { fg = theme.palette.blue },
  -- diffLine = { fg = theme.palette.overlay0 },
  -- diffIndexLine = { fg = theme.palette.teal },

  -- diffview.nvim
  DiffviewDiffAdd = { link = "DiffAdd" }, -- right diff add
  DiffviewDiffAddText = {
    bg = utils.brighten(utils.darken(gitColors.add, 0.2, theme.base_16.base01), 0.15),
    fg = "NONE",
  }, -- right diff add text
  DiffviewDiffDelete = { link = "DiffDelete" }, -- left diff delete
  DiffviewDiffDeleteText = {
    bg = utils.brighten(utils.darken(gitColors.delete, 0.2, theme.base_16.base01), 0.15),
    fg = "NONE",
  }, -- left diff delete text
  DiffviewDiffDeleteSign = { fg = theme.base_30.grey }, -- both diff delete sign
  DiffviewDiffAddAsDelete = { bg = theme.base_30.green }, -- TODO: investigate
  DiffviewFilePanelCounter = { fg = theme.base_30.red, bg = "NONE" },
  DiffviewFilePanelTitle = { fg = theme.base_30.lavender, bg = "NONE" },
  -- DiffviewNormal = { link = "NvimTreeNormal" },
  -- DiffviewVertSplit = { link = "VertSplit" },

  -- git-conflict.nvim
  GitConflictCurrentLabel = { bg = utils.darken(gitColors.add, 0.4, theme.base_16.base01) },
  GitConflictCurrent = { bg = utils.darken(gitColors.add, 0.2, theme.base_16.base01) },
  GitConflictIncoming = { bg = utils.darken(gitColors.info, 0.2, theme.base_16.base01) },
  GitConflictIncomingLabel = { bg = utils.darken(gitColors.info, 0.4, theme.base_16.base01) },
  GitConflictAncestorLabel = { bg = utils.darken(gitColors.ancestor, 0.4, theme.base_16.base01) },
  GitConflictAncestor = { bg = utils.darken(gitColors.ancestor, 0.2, theme.base_16.base01) },

  -- nvim-tree.lua
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

  -- nvim-spectre
  SpectreSearch = {
    bg = utils.darken(gitColors.delete, 0.2, theme.base_16.base01),
    undercurl = true,
  },

  -- diagnostics
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

  -- nvim-lighbulb
  LightBulbSign = { link = "DiagnosticWarn" },

  -- flash.nvim
  FlashBackdrop = { fg = theme.base_30.grey_fg },
  FlashLabel = { fg = theme.base_30.green, bg = theme.base_30.black, bold = true },
  FlashMatch = { fg = theme.base_30.lavender, bg = theme.base_30.black },
  FlashCurrent = { fg = theme.base_30.peach, bg = theme.base_30.black },
  FlashPrompt = { link = "Normal" },
  FlashPromptMode = { link = "St_CommandMode" },
  FlashPromptModeSep = { link = "St_CommandModeSep" },

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

  -- tabufline
  TblineFill = {
    bg = tabuflineBg,
  },
  TbLineBufOff = {
    bg = tabuflineBg,
    fg = tabuflineFg,
  },
  TbLineBufOn = {
    bg = tabuflineBg,
    fg = tabuflineFgActive,
  },
  TbLineBufOffModified = {
    bg = tabuflineBg,
    fg = tabuflineFg,
  },
  TbLineBufOffClose = {
    bg = tabuflineBg,
  },
  TbLineTabOn = {
    bg = tabuflineBg,
    fg = tabuflineFgActive,
    bold = false,
  },
  TbLineTabOff = {
    bg = tabuflineBg,
    fg = tabuflineFg,
  },

  -- rainbow-delimiters.nvim
  rainbow1 = { fg = theme.base_30.red },
  rainbow2 = { fg = theme.base_30.orange },
  rainbow3 = { fg = theme.base_30.yellow },
  rainbow4 = { fg = theme.base_30.vibrant_green },
  rainbow5 = { fg = theme.base_30.blue },
  rainbow6 = { fg = theme.base_30.lavender },

  -- nvim-cmp
  CmpDoc = {
    bg = utils.darken(theme.base_16.base02, 0.54, theme.base_16.base00),
  },
  CmpDocBorder = {
    fg = utils.darken(theme.base_16.base02, 0.54, theme.base_16.base00),
    bg = utils.darken(theme.base_16.base02, 0.54, theme.base_16.base00),
  },

  -- indent-blankline.nvim
  IblIndent = { bg = "NONE", fg = theme.base_16.base02 },
  IblScope = { bg = "NONE" },
  IblWhitespace = { bg = "NONE", fg = theme.base_16.base02 },

  -- nvim-ufo
  UfoPreviewNormal = { bg = theme.base_30.darker_black },
  UfoFoldedEllipsis = { link = "Comment" },
  FoldColumn = { link = "LineNr" },
  Folded = { fg = "NONE" },

  -- telescope.nvim
  TelescopePromptNormal = { bg = theme.base_30.black2 },

  -- todo-comments.nvim
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
  WinSeparator = { link = "VertSplit" },
}

return M
