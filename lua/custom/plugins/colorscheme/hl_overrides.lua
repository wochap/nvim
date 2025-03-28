local getColors = function(palette)
  return {
    state = {
      error = palette.red,
      warning = palette.peach,
      info = palette.blue,
      hint = palette.mauve,
      conflict = palette.maroon,
    },
    git = {
      delete = palette.red,
      add = palette.green,
      change = palette.peach,
      info = palette.blue,
      ancestor = palette.text,
      stage = palette.mauve,
    },
    float = {
      bg = palette.mantle,
    },
    separator = {
      bg = "NONE",
      fg = palette.mantle,
    },
  }
end

local getExtraHl = function(mocha)
  local U = require "catppuccin.utils.colors"
  local colorschemeUtils = require "custom.utils.colorscheme"
  local gitColors = getColors(mocha).git
  local stateColors = getColors(mocha).state
  local floatColors = getColors(mocha).float
  local result = {}

  -- custom statusline
  local st_module_bg = mocha.surface0
  local st_module_fg = mocha.text
  local st_bg = "NONE"
  local st_fg = mocha.surface1
  local function gen_modes_hl(mode, color)
    result["St" .. mode .. "Mode"] = { fg = mocha.base, bg = mocha[color], bold = true }
    result["St" .. mode .. "ModeSep"] = { fg = mocha[color], bg = st_bg }
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
    lessCssAttribute = { fg = mocha.text, link = nil },

    zshCommands = { fg = mocha.blue },
    zshDeref = { fg = mocha.red },
    zshFunction = { fg = mocha.blue },
    zshShortDeref = { fg = mocha.text },
    zshSubst = { fg = mocha.red },
    zshSubstDelim = { fg = mocha.text },
    zshSubstQuoted = { fg = mocha.red },
    zshVariableDef = { fg = mocha.red },

    ["@punctuation.special.markdown"] = { fg = mocha.teal },
    ["@text.title.1.markdown"] = { fg = mocha.red },
    ["@text.title.1.marker.markdown"] = { fg = mocha.red },
    ["@text.title.2.markdown"] = { fg = mocha.peach },
    ["@text.title.2.marker.markdown"] = { fg = mocha.peach },
    ["@text.title.3.markdown"] = { fg = mocha.yellow },
    ["@text.title.3.marker.markdown"] = { fg = mocha.yellow },
    ["@text.title.4.markdown"] = { fg = mocha.green },
    ["@text.title.4.marker.markdown"] = { fg = mocha.green },
    ["@text.title.5.markdown"] = { fg = mocha.blue },
    ["@text.title.5.marker.markdown"] = { fg = mocha.blue },
    ["@text.literal.markdown_inline"] = { fg = mocha.green },
    ["@text.reference.markdown_inline"] = { fg = mocha.lavender },
    ["@text.strong.markdown_inline"] = { fg = mocha.red },
    ["@text.uri.markdown_inline"] = { fg = mocha.blue },

    -- custom statusline
    StRelativePath = { fg = mocha.overlay0 },
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
    StMaximize = { fg = mocha.blue },
    StLsp = { fg = mocha.maroon },
    StSearch = { fg = mocha.teal },
    StFolder = { fg = mocha.blue },
    StMacro = { fg = mocha.red },
    StCommand = { fg = mocha.mauve },
    StLazy = { fg = mocha.pink },
    StCopilot = { fg = mocha.sapphire },
    StSnacksProfiler = { fg = mocha.red },

    -- oil.nvim
    OilMtime = { fg = "#8383A9" },
    OilSize = { fg = "#87FF87" },
    OilRead = { fg = mocha.mauve },
    OilWrite = { fg = "#FD86D5" },
    OilExecute = { fg = mocha.teal },
    OilHyphen = { fg = mocha.red },

    -- visual-whitespace.nvim
    VisualWhitespace = {
      bg = mocha.surface1, -- same as Visual
      fg = mocha.overlay0, -- same as NonText
    },

    -- vim-illuminate
    IlluminatedWordText = { bg = colorschemeUtils.darken(mocha.surface1, 0.7, mocha.base), underline = false },
    IlluminatedWordRead = { link = "IlluminatedWordText" },
    IlluminatedWordWrite = { link = "IlluminatedWordText" },

    -- snacks.nvim
    SnacksIndent = { link = "IblIndent" },
    SnacksIndentScope = { link = "IblIndent" },
    SnacksIndentChunk = { link = "IblIndent" },
    SnacksIndentBlank = { link = "IblIndent" },
    SnacksNormal = { link = "Normal" },
    SnacksNormalNC = { link = "Normal" },
    -- TODO: bug, space without HL in snacks Input
    SnacksInputTitle = { link = "FloatTitle" },
    SnacksPickerMatch = {
      fg = mocha.blue,
      bg = U.darken(mocha.blue, 0.095, mocha.base),
    },
    SnacksTermFloatBorder = { bg = mocha.base, fg = mocha.base },

    -- incline.nvim
    InclineNormalNC = {
      fg = mocha.surface1,
      bg = mocha.mantle,
    },

    -- nvim-spectre
    SpectreSearch = {
      bg = colorschemeUtils.darken(gitColors.delete, 0.2, mocha.mantle),
      undercurl = true,
    },

    -- grug-far.nvim
    GrugFarResultsMatch = { default = true, link = "DiffChange" },
    GrugFarResultsMatchAdded = { default = true, link = "DiffAdd" },
    GrugFarResultsMatchRemoved = { default = true, link = "DiffDelete" },

    -- bufferline.nvim
    BufferLineOffset = { bg = mocha.mantle, fg = mocha.lavender },
    DevIconDimmed = { fg = mocha.surface1 },

    -- multicursor.nvim
    MultiCursorCursor = { link = "Cursor" },
    MultiCursorVisual = { link = "Visual" },
    MultiCursorDisabledCursor = { link = "Visual" },
    MultiCursorDisabledVisual = { link = "Visual" },

    -- highlight-undo.nvim
    Highlight = {
      fg = "NONE",
      bg = mocha.surface1,
    },

    --
    YankyPut = {
      fg = "NONE",
      bg = mocha.surface1,
    },
    YankyYanked = {
      link = "YankyPut",
    },

    -- nvim-web-devicons
    DevIconDefault = { fg = mocha.red },
    DevIconc = { fg = mocha.blue },
    DevIconcss = { fg = mocha.blue },
    DevIcondeb = { fg = mocha.teal },
    DevIconDockerfile = { fg = mocha.teal },
    DevIconhtml = { fg = mocha.maroon },
    DevIconjpeg = { fg = mocha.dark_purple },
    DevIconjpg = { fg = mocha.dark_purple },
    DevIconjs = { fg = mocha.sun },
    DevIconkt = { fg = mocha.peach },
    DevIconlock = { fg = mocha.red },
    DevIconlua = { fg = mocha.blue },
    DevIconmp3 = { fg = mocha.text },
    DevIconmp4 = { fg = mocha.text },
    DevIconout = { fg = mocha.text },
    DevIconpng = { fg = mocha.dark_purple },
    DevIconpy = { fg = mocha.teal },
    DevIcontoml = { fg = mocha.blue },
    DevIconts = { fg = mocha.teal },
    DevIconttf = { fg = mocha.text },
    DevIconrb = { fg = mocha.pink },
    DevIconrpm = { fg = mocha.peach },
    DevIconvue = { fg = mocha.vibrant_green },
    DevIconwoff = { fg = mocha.text },
    DevIconwoff2 = { fg = mocha.text },
    DevIconxz = { fg = mocha.sun },
    DevIconzip = { fg = mocha.sun },
    DevIconZig = { fg = mocha.peach },
    DevIconMd = { fg = mocha.blue },
    DevIconTSX = { fg = mocha.blue },
    DevIconJSX = { fg = mocha.blue },
    DevIconSvelte = { fg = mocha.red },
    DevIconJava = { fg = mocha.peach },
    DevIconDart = { fg = mocha.teal },

    -- blink.cmp
    BlinkCmpKindClass = { fg = mocha.yellow },
    BlinkCmpKindColor = { fg = mocha.red },
    BlinkCmpKindConstant = { fg = mocha.peach },
    BlinkCmpKindConstructor = { fg = mocha.blue },
    BlinkCmpKindEnum = { fg = mocha.green },
    BlinkCmpKindEnumMember = { fg = mocha.red },
    BlinkCmpKindEvent = { fg = mocha.blue },
    BlinkCmpKindField = { fg = mocha.green },
    BlinkCmpKindFile = { fg = mocha.blue },
    BlinkCmpKindFolder = { fg = mocha.blue },
    BlinkCmpKindFunction = { fg = mocha.blue },
    BlinkCmpKindInterface = { fg = mocha.yellow },
    BlinkCmpKindKeyword = { fg = mocha.red },
    BlinkCmpKindMethod = { fg = mocha.blue },
    BlinkCmpKindModule = { fg = mocha.blue },
    BlinkCmpKindOperator = { fg = mocha.blue },
    BlinkCmpKindProperty = { fg = mocha.green },
    BlinkCmpKindReference = { fg = mocha.red },
    BlinkCmpKindSnippet = { fg = mocha.mauve },
    BlinkCmpKindStruct = { fg = mocha.blue },
    BlinkCmpKindText = { fg = mocha.teal },
    BlinkCmpKindTypeParameter = { fg = mocha.blue },
    BlinkCmpKindUnit = { fg = mocha.green },
    BlinkCmpKindValue = { fg = mocha.peach },
    BlinkCmpKindVariable = { fg = mocha.flamingo },

    BlinkCmpKindAvante = { fg = mocha.teal },
    BlinkCmpKindCodeium = { fg = mocha.teal },
    BlinkCmpKindCopilot = { fg = mocha.teal },
    BlinkCmpKindDap = { fg = mocha.red },
    BlinkCmpKindHistory = { fg = mocha.rosewater },
    BlinkCmpKindPackage = { fg = mocha.blue },
    BlinkCmpKindRenderMarkdown = { fg = mocha.blue },
    BlinkCmpKindSpell = { fg = mocha.yellow },
    BlinkCmpKindTabNine = { fg = mocha.teal },

    BlinkCmpSource = { fg = mocha.subtext0 },
    BlinkCmpLabel = { fg = mocha.text },
    BlinkCmpLabelDeprecated = { fg = mocha.surface1 },
    BlinkCmpLabelDescription = { fg = mocha.overlay0 },
    BlinkCmpLabelDetail = { fg = mocha.overlay0 },
    BlinkCmpLabelMatch = { fg = mocha.blue, bold = true },
    BlinkCmpMenuBorder = {
      bg = floatColors.bg,
      fg = floatColors.bg,
    },
    BlinkCmpDoc = {
      bg = mocha.crust,
    },
    BlinkCmpDocBorder = {
      fg = mocha.crust,
      bg = mocha.crust,
    },
    BlinkCmpDocSeparator = {
      fg = mocha.crust,
      bg = mocha.crust,
    },
    PmenuSel = { bg = mocha.surface0 },
    Pmenu = { bg = floatColors.bg },
  })
end

local getOverridesHl = function(mocha)
  local U = require "catppuccin.utils.colors"
  local colorschemeUtils = require "custom.utils.colorscheme"
  local gitColors = getColors(mocha).git
  local stateColors = getColors(mocha).state
  local floatColors = getColors(mocha).float
  local separatorColors = getColors(mocha).separator

  return {
    -- syntax
    ["@variable"] = { link = "Variable" },
    -- PreProc = { link = "Comment" },
    Todo = { fg = mocha.blue, bg = mocha.base },
    Error = { fg = mocha.red, bg = "NONE" }, -- (preferred) any erroneous construct

    -- ufo
    FoldColumn = { bg = "NONE" }, -- sign column
    Folded = { bg = "NONE" }, -- folded line
    UfoPreviewNormal = { bg = mocha.mantle },
    UfoFoldedEllipsis = { link = "LspInlayHint" },

    --mini.hipatterns
    MiniHipatternsFixme = { fg = mocha.red, bg = "NONE", style = {} },
    MiniHipatternsHack = { fg = mocha.yellow, bg = "NONE", style = {} },
    MiniHipatternsNote = { fg = mocha.sky, bg = "NONE", style = {} },
    MiniHipatternsTodo = { fg = mocha.teal, bg = "NONE", style = {} },
    MiniHipatternsPerf = { fg = mocha.green, bg = "NONE", style = {} },

    -- flash.nvim
    FlashPrompt = { link = "Normal" },
    FlashPromptMode = { bg = "NONE", fg = mocha.yellow },

    -- trouble.nvim
    TroubleNormal = { bg = mocha.base },
    TroubleNormalNC = { bg = mocha.base },

    -- nvim-tree.lua
    NvimTreeNormal = { bg = mocha.base },
    NvimTreeWinSeparator = separatorColors,
    NvimTreeEmptyFolderName = { fg = mocha.text },
    NvimTreeExecFile = { fg = mocha.text },
    NvimTreeFolderIcon = { fg = mocha.blue },
    NvimTreeFolderName = { fg = mocha.text },
    NvimTreeImageFile = { fg = mocha.text },
    NvimTreeIndentMarker = { fg = mocha.surface1 },
    NvimTreeOpenedFolderName = { fg = mocha.text },
    NvimTreeSymlink = { fg = mocha.text },
    NvimTreeGitDeleted = { fg = gitColors.delete },
    NvimTreeGitDirty = { fg = gitColors.change },
    NvimTreeGitIgnored = { fg = mocha.surface1_fg },
    NvimTreeGitNew = { fg = gitColors.add },
    NvimTreeGitStaged = { fg = gitColors.stage },
    NvimTreeGitStagedIcon = { fg = gitColors.add },
    NvimTreeGitFileStagedHL = { link = "NvimTreeGitStaged" },
    NvimTreeGitDirtyIcon = { fg = gitColors.delete },
    NvimTreeGitFileDirtyHL = { link = "NvimTreeGitDirty" },
    NvimTreeGitFileIgnoredHL = { link = "NeoTreeGitIgnored" },

    -- noice.nvim
    NoiceCmdlinePopupNormal = { fg = mocha.text, bg = mocha.crust },
    NoiceCmdlinePopupBorder = { fg = mocha.crust, bg = mocha.crust },
    NoiceConfirm = { link = "NormalFloat" },
    NoiceConfirmBorder = { link = "FloatBorder" },
    NoiceSplit = { link = "Normal" },
    NoiceSplitBorder = { link = "FloatBorder" },
    NoiceMini = { link = "Comment" },
    NoiceVirtualText = {
      fg = U.darken(mocha.sky, 0.90, mocha.base),
      bg = U.darken(U.darken(mocha.sky, 0.90, mocha.base), 0.095, mocha.base),
    },

    -- which-key.nvim
    WhichKey = { bg = "NONE", fg = mocha.text },

    -- neo-tree.nvim
    NeoTreeNormal = { bg = mocha.base },
    NeoTreeNormalNC = { bg = mocha.base },
    NeoTreeDirectoryName = { fg = mocha.text },
    NeoTreeGitUntracked = { fg = gitColors.add },
    NeoTreeVertSplit = separatorColors,
    NeoTreeWinSeparator = separatorColors,
    NeoTreeGitModified = { fg = gitColors.change },

    -- gitsigns.nvim
    GitSignsAdd = { fg = gitColors.add },
    GitSignsChange = { fg = gitColors.change },
    GitSignsDelete = { fg = gitColors.delete },
    GitSignsAddInline = {
      bg = colorschemeUtils.brighten(colorschemeUtils.darken(gitColors.add, 0.2, mocha.mantle), 0.15),
      fg = "NONE",
    },
    GitSignsDeleteInline = {
      bg = colorschemeUtils.brighten(colorschemeUtils.darken(gitColors.delete, 0.2, mocha.mantle), 0.15),
      fg = "NONE",
    },
    GitSignsChangeInline = { link = "DiffText" },
    GitSignsAddPreview = { link = "DiffAdd" },
    GitSignsDeletePreview = { link = "DiffDelete" },

    -- nvim git diff
    DiffAdd = { bg = colorschemeUtils.darken(gitColors.add, 0.2, mocha.mantle), fg = "NONE" },
    DiffChange = { bg = colorschemeUtils.darken(gitColors.change, 0.2, mocha.mantle), fg = "NONE" },
    DiffDelete = { bg = colorschemeUtils.darken(gitColors.delete, 0.2, mocha.mantle), fg = "NONE" },
    DiffText = {
      bg = colorschemeUtils.brighten(colorschemeUtils.darken(gitColors.change, 0.2, mocha.mantle), 0.15),
      fg = "NONE",
    },

    -- diffview.nvim
    DiffviewDiffDeleteSign = { fg = mocha.surface1 }, -- both diff delete sign
    DiffviewFilePanelCounter = { fg = mocha.red, bg = "NONE" },
    DiffviewFilePanelTitle = { fg = mocha.lavender, bg = "NONE" },
    -- DiffviewNormal = { link = "NvimTreeNormal" },
    -- DiffviewVertSplit = { link = "VertSplit" },

    -- git-conflict.nvim
    GitConflictCurrentLabel = { bg = colorschemeUtils.darken(gitColors.add, 0.4, mocha.mantle) },
    GitConflictCurrent = { bg = colorschemeUtils.darken(gitColors.add, 0.2, mocha.mantle) },
    GitConflictIncoming = { bg = colorschemeUtils.darken(gitColors.info, 0.2, mocha.mantle) },
    GitConflictIncomingLabel = { bg = colorschemeUtils.darken(gitColors.info, 0.4, mocha.mantle) },
    GitConflictAncestorLabel = { bg = colorschemeUtils.darken(gitColors.ancestor, 0.4, mocha.mantle) },
    GitConflictAncestor = { bg = colorschemeUtils.darken(gitColors.ancestor, 0.2, mocha.mantle) },

    -- avante.nvim
    AvanteConflictCurrentLabel = { link = "GitConflictCurrentLabel" },
    AvanteConflictCurrent = { link = "GitConflictCurrent" },
    AvanteConflictIncomingLabel = { link = "GitConflictIncomingLabel" },
    AvanteConflictIncoming = { link = "GitConflictIncoming" },
    AvanteSidebarNormal = { link = "Normal" },
    AvanteSidebarWinSeparator = { link = "WinSeparator" },
    AvanteSidebarWinHorizontalSeparator = { link = "WinSeparator" },

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
      fg = colorschemeUtils.darken(mocha.text, 0.667, mocha.base),
      undercurl = true,
      link = nil,
    },
    DiagnosticFloatingError = { fg = stateColors.error }, -- Used to color "Error" diagnostic messages in diagnostics float
    DiagnosticFloatingWarn = { fg = stateColors.warning }, -- Used to color "Warn" diagnostic messages in diagnostics float
    DiagnosticFloatingInfo = { fg = stateColors.info }, -- Used to color "Info" diagnostic messages in diagnostics float
    DiagnosticFloatingHint = { fg = stateColors.hint }, -- Used to color "Hint" diagnostic messages in diagnostics float
    DiagnosticVirtualTextError = {
      fg = stateColors.error,
      bg = U.darken(stateColors.error, 0.095, mocha.base),
    },
    DiagnosticVirtualTextHint = {
      fg = stateColors.hint,
      bg = U.darken(stateColors.hint, 0.095, mocha.base),
    },
    DiagnosticVirtualTextInfo = {
      fg = stateColors.info,
      bg = U.darken(stateColors.info, 0.095, mocha.base),
    },
    DiagnosticVirtualTextWarn = {
      fg = stateColors.warning,
      bg = U.darken(stateColors.warning, 0.095, mocha.base),
    },
    -- TODO: add DiagnosticVirtualLines...?

    -- nvim float windows
    FloatTitle = { bg = floatColors.bg, fg = mocha.surface1 },
    NormalFloat = { bg = floatColors.bg },
    FloatBorder = { bg = floatColors.bg, fg = floatColors.bg },

    -- nvim separators
    WinSeparator = separatorColors,
    VertSplit = separatorColors,

    -- nvim status bar
    StatusLine = { bg = mocha.base },

    -- nvim-lsp-endhints
    LspInlayHint = {
      fg = mocha.surface1,
      bg = U.darken(mocha.surface1, 0.095, mocha.base),
    },

    -- lsp-lens.nvim
    LspLens = { link = "LspInlayHint" },

    -- nvim-treesitter-context
    TreesitterContext = { fg = mocha.surface1, bg = "NONE" },
    TreesitterContextLineNumber = { link = "LineNr" },
    TreesitterContextBottom = { style = {} },

    -- nvim recording macro msg
    ModeMsg = {
      fg = mocha.peach,
    },

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
