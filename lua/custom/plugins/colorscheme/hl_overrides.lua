local getColors = function(palette)
  return {
    state = {
      error = palette.red,
      warning = palette.yellow,
      info = palette.sky,
      hint = palette.teal,
      ok = palette.green,
      conflict = palette.maroon,
    },
    git = {
      add = palette.green,
      change = palette.peach,
      delete = palette.red,
      stage = palette.yellow,
      info = palette.blue,
      ancestor = palette.text,
    },
    float = {
      bg = palette.base,
    },
    separator = {
      bg = "NONE",
      fg = palette.mantle,
    },
  }
end

local getExtraHl = function(C)
  local U = require "catppuccin.utils.colors"
  local gitColors = getColors(C).git
  local stateColors = getColors(C).state
  local floatColors = getColors(C).float
  local result = {}

  -- custom statusline
  local st_module_bg = C.surface0
  local st_module_fg = C.text
  local st_bg = "NONE"
  local st_fg = C.surface1
  local function gen_modes_hl(mode, color)
    result["St" .. mode .. "Mode"] = { fg = C.base, bg = C[color], bold = true }
    result["St" .. mode .. "ModeSep"] = { fg = C[color], bg = st_bg }
  end
  gen_modes_hl("Normal", "blue")
  gen_modes_hl("Visual", "mauve")
  gen_modes_hl("Insert", "green")
  gen_modes_hl("Terminal", "green")
  gen_modes_hl("Nterminal", "blue")
  gen_modes_hl("Replace", "red")
  gen_modes_hl("Confirm", "blue")
  gen_modes_hl("Command", "peach")
  gen_modes_hl("Select", "mauve")

  return vim.tbl_deep_extend("force", result, {
    -- lang less
    lessCssAttribute = { fg = C.text, link = nil },

    -- lang zsh
    zshCommands = { fg = C.blue },
    zshDeref = { fg = C.red },
    zshFunction = { fg = C.blue },
    zshShortDeref = { fg = C.text },
    zshSubst = { fg = C.red },
    zshSubstDelim = { fg = C.text },
    zshSubstQuoted = { fg = C.red },
    zshVariableDef = { fg = C.red },

    -- lang markdown
    ["@punctuation.special.markdown"] = { fg = C.teal },
    ["@text.literal.markdown_inline"] = { fg = C.green },
    ["@text.reference.markdown_inline"] = { fg = C.lavender },
    ["@text.strong.markdown_inline"] = { fg = C.red },
    ["@text.uri.markdown_inline"] = { fg = C.blue },

    -- custom statusline
    StRelativePath = { fg = C.overlay0 },
    StModule = { bg = st_module_bg, fg = st_module_fg },
    StModuleAlt = { bg = st_bg, fg = st_fg },
    StModuleSep = { bg = st_bg, fg = st_module_bg },
    StGitAdd = { fg = gitColors.add },
    StGitChange = { fg = gitColors.change },
    StGitDelete = { fg = gitColors.delete },
    StGitConflict = { fg = gitColors.conflict },
    StErrors = { fg = stateColors.error },
    StWarnings = { fg = stateColors.warning },
    StHints = { fg = stateColors.hint },
    StInfos = { fg = stateColors.info },
    StEmptySpace = { bg = "NONE" },
    StMaximize = { fg = C.blue },
    StLsp = { fg = C.maroon },
    StFormatter = { fg = C.green },
    StLinter = { fg = C.yellow },
    StSearch = { fg = C.teal },
    StFolder = { fg = C.blue },
    StMacro = { fg = C.red },
    StCommand = { fg = C.mauve },
    StLazy = { fg = C.pink },
    StCopilot = { fg = C.sapphire },
    StSnacksProfiler = { fg = C.red },

    -- oil.nvim
    OilMtime = { fg = "#8383A9" },
    OilSize = { fg = "#87FF87" },
    OilRead = { fg = C.mauve },
    OilWrite = { fg = "#FD86D5" },
    OilExecute = { fg = C.teal },
    OilHyphen = { fg = C.red },

    -- visual-whitespace.nvim
    VisualWhitespace = {
      bg = C.surface1, -- same as Visual
      fg = C.overlay0, -- same as NonText
    },

    -- nvim-dap
    DapStoppedLine = { link = "Visual" },

    -- snacks.nvim
    SnacksIndentChunk = { link = "SnacksIndent" },
    SnacksIndentBlank = { link = "SnacksIndent" },
    SnacksNormal = { link = "Normal" },
    SnacksNormalNC = { link = "Normal" },
    -- TODO: bug, space without HL in snacks Input
    SnacksInputTitle = { link = "FloatTitle" },
    SnacksPickerMatch = {
      fg = C.blue,
      bg = U.darken(C.blue, 0.095, C.base),
    },
    SnacksTermFloatBorder = { bg = C.base, fg = C.base },

    -- incline.nvim
    InclineNormalNC = {
      fg = C.surface1,
      bg = C.mantle,
    },

    -- nvim-spectre
    SpectreSearch = {
      bg = U.darken(gitColors.delete, 0.2, C.mantle),
      undercurl = true,
    },

    -- grug-far.nvim
    GrugFarResultsMatch = { default = true, link = "DiffChange" },
    GrugFarResultsMatchAdded = { default = true, link = "DiffAdd" },
    GrugFarResultsMatchRemoved = { default = true, link = "DiffDelete" },

    -- bufferline.nvim
    BufferLineOffset = { bg = C.mantle, fg = C.lavender },
    DevIconDimmed = { fg = C.surface1 },

    -- multicursor.nvim
    MultiCursorCursor = { link = "Cursor" },
    MultiCursorVisual = { link = "Visual" },
    MultiCursorSign = { link = "SignColumn" },
    MultiCursorMatchPreview = { link = "Search" },
    MultiCursorDisabledCursor = { link = "Visual" },
    MultiCursorDisabledVisual = { link = "Visual" },
    MultiCursorDisabledSign = { link = "SignColumn" },

    -- highlight-undo.nvim
    Highlight = {
      fg = "NONE",
      bg = C.surface1,
    },

    -- yanky.nvim
    YankyPut = {
      fg = "NONE",
      bg = C.surface1,
    },
    YankyYanked = {
      link = "YankyPut",
    },

    -- nvim-web-devicons
    DevIconDefault = { fg = C.red },
    DevIconc = { fg = C.blue },
    DevIconcss = { fg = C.blue },
    DevIcondeb = { fg = C.teal },
    DevIconDockerfile = { fg = C.teal },
    DevIconhtml = { fg = C.maroon },
    DevIconjpeg = { fg = C.dark_purple },
    DevIconjpg = { fg = C.dark_purple },
    DevIconjs = { fg = C.sun },
    DevIconkt = { fg = C.peach },
    DevIconlock = { fg = C.red },
    DevIconlua = { fg = C.blue },
    DevIconmp3 = { fg = C.text },
    DevIconmp4 = { fg = C.text },
    DevIconout = { fg = C.text },
    DevIconpng = { fg = C.dark_purple },
    DevIconpy = { fg = C.teal },
    DevIcontoml = { fg = C.blue },
    DevIconts = { fg = C.teal },
    DevIconttf = { fg = C.text },
    DevIconrb = { fg = C.pink },
    DevIconrpm = { fg = C.peach },
    DevIconvue = { fg = C.vibrant_green },
    DevIconwoff = { fg = C.text },
    DevIconwoff2 = { fg = C.text },
    DevIconxz = { fg = C.sun },
    DevIconzip = { fg = C.sun },
    DevIconZig = { fg = C.peach },
    DevIconMd = { fg = C.blue },
    DevIconTSX = { fg = C.blue },
    DevIconJSX = { fg = C.blue },
    DevIconSvelte = { fg = C.red },
    DevIconJava = { fg = C.peach },
    DevIconDart = { fg = C.teal },

    -- blink.cmp
    BlinkCmpKindAvante = { fg = C.teal },
    BlinkCmpKindCodeium = { fg = C.teal },
    BlinkCmpKindCopilot = { fg = C.teal },
    BlinkCmpKindDap = { fg = C.red },
    BlinkCmpKindHistory = { fg = C.rosewater },
    BlinkCmpKindPackage = { fg = C.blue },
    BlinkCmpKindRenderMarkdown = { fg = C.blue },
    BlinkCmpKindSpell = { fg = C.yellow },
    BlinkCmpKindTabNine = { fg = C.teal },

    BlinkCmpSource = { fg = C.subtext0 },
    BlinkCmpLabel = { fg = C.text },
    BlinkCmpLabelDeprecated = { fg = C.surface1 },
    BlinkCmpLabelDescription = { fg = C.overlay0 },
    BlinkCmpLabelDetail = { fg = C.overlay0 },
    BlinkCmpLabelMatch = { fg = C.blue, bold = true },
    BlinkCmpMenuBorder = {
      bg = floatColors.bg,
      fg = floatColors.bg,
    },
    BlinkCmpDoc = {
      bg = C.crust,
    },
    BlinkCmpDocBorder = {
      fg = C.crust,
      bg = C.crust,
    },
    BlinkCmpDocSeparator = {
      fg = C.crust,
      bg = C.crust,
    },

    PmenuSel = { bg = C.surface0 },
    Pmenu = { bg = floatColors.bg },
  })
end

local getOverridesHl = function(C)
  local U = require "catppuccin.utils.colors"
  local gitColors = getColors(C).git
  local stateColors = getColors(C).state
  local floatColors = getColors(C).float
  local separatorColors = getColors(C).separator

  return {
    -- syntax
    ["@variable"] = { link = "Variable" },
    Todo = { fg = C.blue, bg = C.base },
    Error = { fg = C.red, bg = "NONE" }, -- (preferred) any erroneous construct

    -- flash.nvim
    FlashPrompt = { link = "Normal" },
    FlashPromptMode = { bg = "NONE", fg = C.yellow },

    -- trouble.nvim
    TroubleNormal = { bg = C.base },
    TroubleNormalNC = { bg = C.base },

    -- nvim-tree.lua
    NvimTreeNormal = { bg = C.base },
    NvimTreeWinSeparator = separatorColors,
    NvimTreeEmptyFolderName = { fg = C.text },
    NvimTreeExecFile = { fg = C.text },
    NvimTreeFolderIcon = { fg = C.blue },
    NvimTreeFolderName = { fg = C.text },
    NvimTreeImageFile = { fg = C.text },
    NvimTreeIndentMarker = { fg = C.surface1 },
    NvimTreeOpenedFolderName = { fg = C.text },
    NvimTreeSymlink = { fg = C.text },
    NvimTreeGitDeleted = { fg = gitColors.delete },
    NvimTreeGitDirty = { fg = gitColors.change },
    NvimTreeGitIgnored = { fg = C.surface1_fg },
    NvimTreeGitNew = { fg = gitColors.add },
    NvimTreeGitStaged = { fg = gitColors.stage },
    NvimTreeGitStagedIcon = { fg = gitColors.add },
    NvimTreeGitFileStagedHL = { link = "NvimTreeGitStaged" },
    NvimTreeGitDirtyIcon = { fg = gitColors.delete },
    NvimTreeGitFileDirtyHL = { link = "NvimTreeGitDirty" },
    NvimTreeGitFileIgnoredHL = { link = "NeoTreeGitIgnored" },

    -- noice.nvim
    NoiceCmdlinePopupNormal = { fg = C.text, bg = C.crust },
    NoiceCmdlinePopupBorder = { fg = C.crust, bg = C.crust },
    NoiceConfirm = { link = "NormalFloat" },
    NoiceConfirmBorder = { link = "FloatBorder" },
    NoiceSplit = { link = "Normal" },
    NoiceSplitBorder = { link = "FloatBorder" },
    NoiceMini = { link = "Comment" },
    NoiceVirtualText = {
      fg = U.darken(C.sky, 0.90, C.base),
      bg = U.darken(U.darken(C.sky, 0.90, C.base), 0.095, C.base),
    },

    -- which-key.nvim
    WhichKey = { bg = "NONE", fg = C.text },

    -- neo-tree.nvim
    NeoTreeNormal = { bg = C.base },
    NeoTreeNormalNC = { bg = C.base },
    NeoTreeDirectoryName = { fg = C.text },
    NeoTreeGitUntracked = { fg = gitColors.add },
    NeoTreeVertSplit = separatorColors,
    NeoTreeWinSeparator = separatorColors,
    NeoTreeGitModified = { fg = gitColors.change },

    -- gitsigns.nvim
    GitSignsAdd = { fg = gitColors.add },
    GitSignsChange = { fg = gitColors.change },
    GitSignsDelete = { fg = gitColors.delete },
    GitSignsAddInline = {
      bg = U.brighten(U.darken(gitColors.add, 0.2, C.mantle), 0.15),
      fg = "NONE",
    },
    GitSignsDeleteInline = {
      bg = U.brighten(U.darken(gitColors.delete, 0.2, C.mantle), 0.15),
      fg = "NONE",
    },
    GitSignsChangeInline = { link = "DiffText" },
    GitSignsAddPreview = { link = "DiffAdd" },
    GitSignsDeletePreview = { link = "DiffDelete" },

    -- nvim git diff
    DiffAdd = { bg = U.darken(gitColors.add, 0.2, C.mantle), fg = "NONE" },
    DiffChange = { bg = U.darken(gitColors.change, 0.2, C.mantle), fg = "NONE" },
    DiffDelete = { bg = U.darken(gitColors.delete, 0.2, C.mantle), fg = "NONE" },
    DiffText = {
      bg = U.brighten(U.darken(gitColors.change, 0.2, C.mantle), 0.15),
      fg = "NONE",
    },

    -- diffview.nvim
    DiffviewDiffDeleteSign = { fg = C.surface1 }, -- both diff delete sign
    DiffviewFilePanelCounter = { fg = C.red, bg = "NONE" },
    DiffviewFilePanelTitle = { fg = C.lavender, bg = "NONE" },
    DiffviewNormal = { link = "Normal" },
    DiffviewFilePanelSelected = { fg = C.text },
    -- DiffviewVertSplit = { link = "VertSplit" },

    -- git-conflict.nvim
    GitConflictCurrentLabel = { bg = U.darken(gitColors.add, 0.4, C.mantle) },
    GitConflictCurrent = { bg = U.darken(gitColors.add, 0.2, C.mantle) },
    GitConflictIncoming = { bg = U.darken(gitColors.info, 0.2, C.mantle) },
    GitConflictIncomingLabel = { bg = U.darken(gitColors.info, 0.4, C.mantle) },
    GitConflictAncestorLabel = { bg = U.darken(gitColors.ancestor, 0.4, C.mantle) },
    GitConflictAncestor = { bg = U.darken(gitColors.ancestor, 0.2, C.mantle) },

    -- avante.nvim
    AvanteConflictCurrentLabel = { link = "GitConflictCurrentLabel" },
    AvanteConflictCurrent = { link = "GitConflictCurrent" },
    AvanteConflictIncomingLabel = { link = "GitConflictIncomingLabel" },
    AvanteConflictIncoming = { link = "GitConflictIncoming" },
    AvanteSidebarNormal = { link = "Normal" },
    AvanteSidebarWinSeparator = { link = "WinSeparator" },
    AvanteSidebarWinHorizontalSeparator = { link = "WinSeparator" },

    -- lsp-lens.nvim
    LspLens = { link = "LspInlayHint" },

    -- nvim-treesitter-context
    TreesitterContext = { fg = C.surface1, bg = "NONE" },
    TreesitterContextLineNumber = { link = "LineNr" },
    TreesitterContextBottom = { style = {} },

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
    DiagnosticUnnecessary = {
      fg = U.darken(C.text, 0.667, C.base),
      undercurl = true,
      link = nil,
    },
    DiagnosticFloatingError = { fg = stateColors.error }, -- Used to color "Error" diagnostic messages in diagnostics float
    DiagnosticFloatingWarn = { fg = stateColors.warning }, -- Used to color "Warn" diagnostic messages in diagnostics float
    DiagnosticFloatingInfo = { fg = stateColors.info }, -- Used to color "Info" diagnostic messages in diagnostics float
    DiagnosticFloatingHint = { fg = stateColors.hint }, -- Used to color "Hint" diagnostic messages in diagnostics float
    DiagnosticVirtualTextError = { fg = stateColors.error, bg = "NONE" },
    DiagnosticVirtualTextHint = { fg = stateColors.hint, bg = "NONE" },
    DiagnosticVirtualTextInfo = { fg = stateColors.info, bg = "NONE" },
    DiagnosticVirtualTextWarn = { fg = stateColors.warning, bg = "NONE" },
    -- TODO: add DiagnosticVirtualLines...?

    -- nvim float windows
    FloatTitle = { bg = floatColors.bg, fg = C.surface1 },
    NormalFloat = { bg = floatColors.bg },
    FloatBorder = { bg = floatColors.bg, fg = floatColors.bg },

    -- nvim separators
    WinSeparator = separatorColors,
    VertSplit = separatorColors,

    -- nvim status bar
    StatusLine = { bg = C.base },

    -- nvim-lsp-endhints
    LspInlayHint = {
      fg = C.surface1,
      bg = U.darken(C.surface1, 0.095, C.base),
    },

    -- nvim recording macro msg
    ModeMsg = {
      fg = C.peach,
    },

    -- nvim fold
    FoldColumn = { bg = "NONE" }, -- sign column
    Folded = { bg = "NONE" }, -- folded line

    -- nvim snippets
    SnippetTabstop = { bg = U.darken(C.surface1, 0.7, C.base) },

    -- nvim lsp
    LspReferenceText = { bg = U.darken(C.surface1, 0.7, C.base), underline = false },
    LspReferenceRead = { link = "LspReferenceText" },
    LspReferenceWrite = { link = "LspReferenceText" },

    -- nvim cursor
    -- Cursor = {
    --   bg = "NONE",
    --   fg = mocha.green,
    -- },
    CurSearch = {
      link = "Search",
    },
  }
end

return {
  mocha = function(mocha)
    local extraHl = getExtraHl(mocha)
    local overridesHl = getOverridesHl(mocha)
    return vim.tbl_deep_extend("force", extraHl, overridesHl)
  end,
}
