local utils = require "custom.highlights.utils.init"
local theme = require "custom.highlights.catppuccin-mocha"
local C = theme.palette

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
  NvimTreeRootFolder = { fg = theme.base_30.red },
  NvimTreeSymlink = { fg = theme.base_30.white },
  NvimTreeFolderName = { fg = theme.base_30.white },
  NvimTreeFolderIcon = { fg = theme.base_30.blue },
  NvimTreeEmptyFolderName = { fg = theme.base_30.white },
  NvimTreeOpenedFolderName = { fg = theme.base_30.white },
  NvimTreeExecFile = { fg = theme.base_30.white },
  NvimTreeFileDirty = { fg = gitColors.change },
  NvimTreeFileNew = { fg = gitColors.add },
  NvimTreeFileDeleted = { fg = gitColors.delete },
  NvimTreeIndentMarker = { fg = theme.base_30.line },

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
  DiagnosticVirtualTextError = { fg = stateColors.error }, -- Used for "Error" diagnostic virtual text
  DiagnosticVirtualTextWarn = { fg = stateColors.warning }, -- Used for "Warning" diagnostic virtual text
  DiagnosticVirtualTextInfo = { fg = stateColors.info }, -- Used for "Information" diagnostic virtual text
  DiagnosticVirtualTextHint = { fg = stateColors.hint }, -- Used for "Hint" diagnostic virtual text

  -- statusline
  St_relative_path = {
    bg = theme.base_30.lightbg,
    fg = theme.base_30.light_grey,
  },
  St_gitAdded = {
    bg = theme.base_30.statusline_bg,
    fg = gitColors.add,
  },
  St_gitChanged = {
    bg = theme.base_30.statusline_bg,
    fg = gitColors.change,
  },
  St_gitRemoved = {
    bg = theme.base_30.statusline_bg,
    fg = gitColors.delete,
  },

  -- rainbow-delimiters
  rainbow1 = { fg = C.red },
  rainbow2 = { fg = C.peach },
  rainbow3 = { fg = C.yellow },
  rainbow4 = { fg = C.green },
  rainbow5 = { fg = C.sapphire },
  rainbow6 = { fg = C.lavender },

  -- tabufline
  TblineFill = {
    bg = theme.base_30.statusline_bg,
  },
  TbLineBufOff = {
    bg = theme.base_30.statusline_bg,
    fg = theme.base_30.light_grey,
  },
  TbLineBufOffModified = {
    bg = theme.base_30.statusline_bg,
  },
  TbLineBufOffClose = {
    bg = theme.base_30.statusline_bg,
  },

  -- cmp
  CmpDoc = {
    bg = utils.darken(C.surface0, 0.54, C.base),
  },
  CmpDocBorder = {
    fg = utils.darken(C.surface0, 0.54, C.base),
    bg = utils.darken(C.surface0, 0.54, C.base),
  },

  -- nvim
  WinSeparator = {
    fg = theme.base_30.statusline_bg,
  },
}

return M
