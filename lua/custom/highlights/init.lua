local theme = require "custom.highlights.chadracula"
local utils = require "custom.highlights.utils.init"

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

-- if vim.fn.has "nvim" then
--    vim.g.terminal_color_0 = "#" .. "21222C"
--    vim.g.terminal_color_1 = "#" .. "FF5555"
--    vim.g.terminal_color_2 = "#" .. "50FA7B"
--    vim.g.terminal_color_3 = "#" .. "F1FA8C"
--    vim.g.terminal_color_4 = "#" .. "BD93F9"
--    vim.g.terminal_color_5 = "#" .. "FF79C6"
--    vim.g.terminal_color_6 = "#" .. "8BE9FD"
--    vim.g.terminal_color_7 = "#" .. "F8F8F2"
--    vim.g.terminal_color_8 = "#" .. "6272A4"
--    vim.g.terminal_color_9 = "#" .. "FF6E6E"
--    vim.g.terminal_color_10 = "#" .. "69FF94"
--    vim.g.terminal_color_11 = "#" .. "FFFFA5"
--    vim.g.terminal_color_12 = "#" .. "D6ACFF"
--    vim.g.terminal_color_13 = "#" .. "FF92DF"
--    vim.g.terminal_color_14 = "#" .. "A4FFFF"
--    vim.g.terminal_color_15 = "#" .. "FFFFFF"
-- end

local hls = {
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
}

return {
  theme = "chadracula",
  hl_add = hls,
  hl_override = hls,
}
