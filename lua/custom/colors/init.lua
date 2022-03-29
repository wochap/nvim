local colors = require("colors").get()
local theme = require("core.utils").load_config().ui.theme
local present, base16 = pcall(require, "base16")
local themeColors = base16.themes(theme)
local utils = require "custom.colors.utils"
local stateColors = {
   error = colors.red,
   warning = colors.yellow,
   info = colors.blue,
   hint = colors.teal,
}
local gitColors = {
   delete = colors.red,
   add = colors.green,
   change = colors.orange,
   info = colors.blue,
}

if not present then
   return
end

-- Add # sign
for name, color in pairs(themeColors) do
   themeColors[name] = "#" .. color
end

local function highlight(group, color)
   local style = color.style and "gui=" .. color.style or "gui=NONE"
   local fg = color.fg and "guifg=" .. color.fg or "guifg=NONE"
   local bg = color.bg and "guibg=" .. color.bg or "guibg=NONE"
   local sp = color.sp and "guisp=" .. color.sp or ""

   local hl = "highlight " .. group .. " " .. style .. " " .. fg .. " " .. bg .. " " .. sp

   if color.link then
      vim.cmd("highlight! link " .. group .. " " .. color.link)
   else
      vim.cmd(hl)
   end
end

local syntax = {
   -- CursorLine = { bg = colors.one_bg2 },
   -- Comment = { fg = themeColors.base03 },
   -- diffAdded
   -- diffChanged
   -- diffChanged
   -- diffFile
   -- diffIndexLine
   -- diffLine
   -- diffNewFile
   -- diffOldFile
   -- diffRemoved

   -- DiffChangeDelete = { bg = "#ffffff" },
   -- DiffModified = { bg = "#ffffff" },

   -- DiffAdded = { fg = themeColors.base0B, bg = themeColors.base00 },
   -- DiffFile = { fg = themeColors.base08, bg = themeColors.base00 },
   -- DiffLine = { fg = themeColors.base0D, bg = themeColors.base00 },
   -- DiffNewFile = { fg = themeColors.base0B, bg = themeColors.base00 },
   -- DiffRemoved = { fg = themeColors.base08, bg = themeColors.base00 },

   ConflictMarkerBegin = { bg = utils.darken(gitColors.add, 0.4, themeColors.base01) },
   ConflictMarkerOurs = { bg = utils.darken(gitColors.add, 0.2, themeColors.base01) },
   ConflictMarkerTheirs = { bg = utils.darken(gitColors.info, 0.2, themeColors.base01) },
   ConflictMarkerEnd = { bg = utils.darken(gitColors.info, 0.4, themeColors.base01) },
   ConflictMarkerCommonAncestorsHunk = { bg = themeColors.base01 },
   ConflictMarkerSeparator = { fg = themeColors.base0B },

   -- Git signs
   GitSignsAdd = { fg = gitColors.add },
   GitSignsChange = { fg = gitColors.change },
   GitSignsDelete = { fg = gitColors.delete },

   -- NvimTree
   NvimTreeRootFolder = {
      fg = colors.red,
      -- style = "underline"
   },
   NvimTreeSymlink = { fg = colors.white },
   NvimTreeFolderName = { fg = colors.white },
   NvimTreeFolderIcon = { fg = colors.blue },
   NvimTreeEmptyFolderName = { fg = colors.white },
   NvimTreeOpenedFolderName = { fg = colors.white },
   NvimTreeExecFile = { fg = colors.white },
   NvimTreeFileDirty = { fg = gitColors.change },
   NvimTreeFileNew = { fg = gitColors.add },
   NvimTreeFileDeleted = { fg = gitColors.delete },
   -- NvimTreeFileRenamed
   -- NvimTreeFileStaged
   -- NvimTreeFileMerge

   -- WhichKey
   WhichKeySeparator = { fg = themeColors.base03 },

   -- Diffview
   DiffAdd = { bg = utils.darken(gitColors.add, 0.2, themeColors.base01) }, -- right diff add
   DiffChange = { bg = utils.darken(gitColors.change, 0.2, themeColors.base01) }, -- both diff change line
   DiffDelete = { bg = utils.darken(gitColors.delete, 0.2, themeColors.base01) }, -- right delete
   DiffText = { bg = utils.brighten(utils.darken(gitColors.change, 0.2, themeColors.base01), 0.3) }, -- both diff change text
   DiffviewDiffAddAsDelete = { bg = utils.darken(gitColors.delete, 0.2, themeColors.base01) }, -- left diff delete
   DiffviewDiffDelete = { fg = themeColors.base03 }, -- both diff delete sign
   DiffviewFilePanelCounter = { fg = colors.blue, bg = "NONE" },
   DiffviewFilePanelTitle = { fg = colors.red, bg = "NONE" },
   DiffviewNormal = { link = "NvimTreeNormal" },
   DiffviewVertSplit = { link = "VertSplit" },
   -- DiffviewFilePanelFileName = { fg = , bg = },
   -- DiffviewCursorLine = { fg = , bg = },
   -- DiffviewSignColumn = { fg = , bg = },
   -- DiffviewStatusLine = { fg = , bg = },
   -- DiffviewStatusLineNC = { fg = , bg = },
   -- DiffviewEndOfBuffer = { fg = , bg = },
   -- DiffviewFilePanelRootPath = { fg = , bg = },
   -- DiffviewFilePanelPath = { fg = , bg = },
   -- DiffviewFilePanelInsertions = { fg = , bg = },
   -- DiffviewFilePanelDeletions = { fg = , bg = },
   -- DiffviewStatusAdded = { fg = , bg = },
   -- DiffviewStatusUntracked = { fg = , bg = },
   -- DiffviewStatusModified = { fg = , bg = },
   -- DiffviewStatusRenamed = { fg = , bg = },
   -- DiffviewStatusCopied = { fg = , bg = },
   -- DiffviewStatusTypeChange = { fg = , bg = },
   -- DiffviewStatusUnmerged = { fg = , bg = },
   -- DiffviewStatusUnknown = { fg = , bg = },
   -- DiffviewStatusDeleted = { fg = , bg = },
   -- DiffviewStatusBroken = { fg = , bg = },

   -- Neogit
   NeogitDiffAdd = { fg = themeColors.base05, bg = utils.darken(gitColors.add, 0.2, themeColors.base01) },
   NeogitDiffAddHighlight = { fg = colors.white, bg = utils.darken(gitColors.add, 0.2, themeColors.base01) },
   -- NeogitDiffContext = { fg = themeColors.base05 },
   NeogitDiffContextHighlight = { bg = "#383a45" },
   NeogitDiffDelete = { fg = themeColors.base0, bg = utils.darken(gitColors.delete, 0.2, themeColors.base01) },
   NeogitDiffDeleteHighlight = { fg = colors.white, bg = utils.darken(gitColors.delete, 0.2, themeColors.base01) },
   NeogitHunkHeader = { fg = themeColors.base05 },
   NeogitHunkHeaderHighlight = { fg = themeColors.white, bg = "#484a54" },
   -- NeogitBranch = { fg = , bg = },
   -- NeogitRemote = { fg = , bg = },

   -- Pmenu
   CmpItemAbbrMatch = { fg = themeColors.base0C },
   -- CmpItemAbbr = { fg = colors.grey_fg },

   -- LSP
   LspReferenceRead = { bg = "#343a46" }, -- highlight for refecences
   -- LspReferenceText = { bg = colors.red },
   -- LspReferenceWrite = { bg = colors.yellow },

   -- Others
   -- EndOfBuffer = { fg = colors.grey },
   CustomDirectory = { fg = colors.green, bg = colors.darker_black },
   FoldColumn = { fg = themeColors.base0C, bg = colors.black },
   VertSplit = {
      bg = colors.black2,
      fg = colors.black2,
   },

   -- StatusLine
   StatusLine = {
      bg = colors.black2,
   },
   StatusLineNC = {
      bg = colors.black2,
      fg = colors.black2,
      style = "underline",
   },
   -- WinSeparator = {
   --    bg = "NONE",
   --    fg = colors.black2,
   -- },

   -- Diagnostics
   DiagnosticUnderlineError = { style = "undercurl", sp = stateColors.error }, -- Used to underline "Error" diagnostics
   DiagnosticUnderlineWarn = { style = "undercurl", sp = stateColors.warning }, -- Used to underline "Warning" diagnostics
   DiagnosticUnderlineInfo = { style = "undercurl", sp = stateColors.info }, -- Used to underline "Information" diagnostics
   DiagnosticUnderlineHint = { style = "undercurl", sp = stateColors.hint }, -- Used to underline "Hint" diagnostics
   ErrorMsg = { fg = stateColors.error }, -- error messages on the command line
   SpellBad = { sp = stateColors.error, style = "undercurl" }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
   SpellCap = { sp = stateColors.warning, style = "undercurl" }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
   SpellLocal = { sp = stateColors.info, style = "undercurl" }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
   SpellRare = { sp = stateColors.hint, style = "undercurl" }, -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
   DiagnosticError = { fg = stateColors.error }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
   DiagnosticWarn = { fg = stateColors.warning }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
   DiagnosticInfo = { fg = stateColors.info }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
   DiagnosticHint = { fg = stateColors.hint }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
   DiagnosticVirtualTextError = { fg = stateColors.error }, -- Used for "Error" diagnostic virtual text
   DiagnosticVirtualTextWarn = { fg = stateColors.warning }, -- Used for "Warning" diagnostic virtual text
   DiagnosticVirtualTextInfo = { fg = stateColors.info }, -- Used for "Information" diagnostic virtual text
   DiagnosticVirtualTextHint = { fg = stateColors.hint }, -- Used for "Hint" diagnostic virtual text
}

for group, colors in pairs(syntax) do
   highlight(group, colors)
end

-- Neovim terminal colours
-- Mirror dracula theme in kitty terminal
if vim.fn.has "nvim" then
   vim.g.terminal_color_0 = "#" .. "21222C"
   vim.g.terminal_color_1 = "#" .. "FF5555"
   vim.g.terminal_color_2 = "#" .. "50FA7B"
   vim.g.terminal_color_3 = "#" .. "F1FA8C"
   vim.g.terminal_color_4 = "#" .. "BD93F9"
   vim.g.terminal_color_5 = "#" .. "FF79C6"
   vim.g.terminal_color_6 = "#" .. "8BE9FD"
   vim.g.terminal_color_7 = "#" .. "F8F8F2"
   vim.g.terminal_color_8 = "#" .. "6272A4"
   vim.g.terminal_color_9 = "#" .. "FF6E6E"
   vim.g.terminal_color_10 = "#" .. "69FF94"
   vim.g.terminal_color_11 = "#" .. "FFFFA5"
   vim.g.terminal_color_12 = "#" .. "D6ACFF"
   vim.g.terminal_color_13 = "#" .. "FF92DF"
   vim.g.terminal_color_14 = "#" .. "A4FFFF"
   vim.g.terminal_color_15 = "#" .. "FFFFFF"
end
