local constants = require "custom.constants"

local getColors = function(C)
  local U = require "catppuccin.utils.colors"

  return {
    state = {
      error = C.red,
      warning = C.yellow,
      info = C.sky,
      hint = C.teal,
      ok = C.green,
      conflict = C.maroon,
    },
    git = {
      add = C.green,
      change = C.peach,
      delete = C.red,
      stage = U.darken(C.green, 0.5, C.base),
      info = C.blue,
      ancestor = C.text,
      ignored = C.overlay0,
    },
    float = {
      bg = C.base,
      blockBg = C.mantle,
      blockBorderBg = C.mantle,
      blockBorderFg = C.mantle,
      borderBg = C.base,
      borderFg = C.blue,
    },
    separator = {
      bg = constants.blur_background and "NONE" or C.base,
      fg = C.mantle,
    },
  }
end

local get_extra_hl = function(C)
  local U = require "catppuccin.utils.colors"
  local gitColors = getColors(C).git
  local stateColors = getColors(C).state
  local floatColors = getColors(C).float
  local result = {}

  -- custom statusline
  local st_module_bg = C.surface0
  local st_module_fg = C.text
  local st_bg = C.base
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
    StEmptySpace = { bg = st_bg },
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
    StHarpoon = { fg = C.teal },

    -- betterTerm.nvim
    TabLineSel = { bg = C.base, fg = C.lavender },
    TabLine = { bg = C.base, fg = C.surface1 },
    BetterTermSymbol = { bg = C.base, fg = C.base },

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

    -- nvim-dap-virtual-text
    NvimDapVirtualText = { fg = C.blue, bg = U.darken(C.blue, 0.095, C.base) },
    NvimDapVirtualTextChanged = { fg = stateColors.warning, bg = U.darken(stateColors.warning, 0.095, C.base) },
    NvimDapVirtualTextError = { fg = stateColors.error, bg = U.darken(stateColors.error, 0.095, C.base) },
    NvimDapVirtualTextInfo = { fg = stateColors.info, bg = U.darken(stateColors.info, 0.095, C.base) },

    -- snacks.nvim
    SnacksIndentChunk = { link = "SnacksIndent" },
    SnacksIndentBlank = { link = "SnacksIndent" },
    SnacksNormal = { link = "Normal" },
    SnacksNormalNC = { link = "Normal" },
    -- TODO: bug, space without HL in snacks Input
    SnacksInputTitle = { link = "FloatTitle" },
    SnacksPickerMatch = { fg = C.blue, bg = U.darken(C.blue, 0.095, C.base) },
    SnacksTermFloatBorder = { bg = floatColors.borderBg, fg = floatColors.borderBg },
    SnacksPickerFloatBorder = { fg = floatColors.borderBg, bg = floatColors.borderBg },

    -- nvim-window-picker
    WindowPickerNormalFloat = { bg = floatColors.blockBg, fg = C.text },
    WindowPickerFloatBorder = { bg = floatColors.blockBorderBg, fg = floatColors.blockBorderFg },

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
    DevIconDimmed = { fg = C.surface1, bg = C.base },

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
    DevIconfolder = { fg = C.blue },
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
    BlinkCmpMenuBorder = { bg = floatColors.borderBg, fg = floatColors.borderFg },
    BlinkCmpDoc = { bg = floatColors.bg },
    BlinkCmpDocBorder = { bg = floatColors.borderBg, fg = floatColors.borderFg },
    BlinkCmpDocSeparator = { bg = floatColors.borderBg, fg = C.teal },
    BlinkCmpSignatureHelp = { bg = floatColors.bg },
    BlinkCmpSignatureHelpBorder = { bg = floatColors.borderBg, fg = floatColors.borderFg },

    -- nvim pmenu
    -- PmenuSel = { link = "CursorLine" },
    PmenuSel = { bg = U.darken(C.blue, 0.64, C.base) },
    Pmenu = { bg = floatColors.bg },
    PmenuThumb = { bg = floatColors.borderFg },
    PmenuSbar = { bg = "NONE" },
  })
end

local get_overrides_hl = function(C)
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
    FlashPrompt = { link = "NoiceCmdline" },
    FlashPromptMode = { link = "NoiceCmdlineIconSearch" },

    -- trouble.nvim
    TroubleNormal = { bg = C.base },
    TroubleNormalNC = { bg = C.base },

    -- noice.nvim
    NoiceCmdline = { bg = constants.blur_background and "NONE" or C.base, fg = C.text },
    NoiceCmdlinePopupNormal = { fg = C.text, bg = floatColors.blockBorderBg },
    NoiceCmdlinePopupBorder = { fg = floatColors.blockBorderFg, bg = floatColors.blockBorderBg },
    NoiceConfirm = { fg = C.text, bg = floatColors.blockBorderBg },
    NoiceConfirmBorder = { fg = floatColors.blockBorderFg, bg = floatColors.blockBorderBg },
    NoiceSplit = { link = "Normal" },
    NoiceSplitBorder = { link = "FloatBorder" },
    NoiceMini = { link = "Comment" },
    NoiceVirtualText = {
      fg = U.darken(C.sky, 0.90, C.base),
      bg = U.darken(U.darken(C.sky, 0.90, C.base), 0.095, C.base),
    },

    -- which-key.nvim
    WhichKey = { bg = floatColors.blockBg, fg = C.text },
    WhichKeyNormal = { link = "WhichKey" },
    WhichKeyBorder = { bg = floatColors.blockBorderBg, fg = floatColors.blockBorderFg },

    -- neo-tree.nvim
    NeoTreeNormal = { bg = C.base },
    NeoTreeNormalNC = { bg = C.base },
    NeoTreeDirectoryName = { fg = C.text },
    NeoTreeGitUntracked = { fg = gitColors.add },
    NeoTreeVertSplit = separatorColors,
    NeoTreeWinSeparator = separatorColors,
    NeoTreeGitModified = { fg = gitColors.change },
    NeoTreeMessage = { fg = gitColors.ignored, italic = false },

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
    DiffviewNormal = { bg = constants.blur_background and "NONE" or C.base, fg = C.text },
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
    AvantePromptInputBorder = { link = "FloatBorder" },
    AvantePopupHint = { fg = C.peach, bold = true },
    AvanteInlineHint = { fg = C.peach, bold = true },

    -- lsp-lens.nvim
    LspLens = { link = "LspInlayHint" },

    -- nvim-treesitter-context
    TreesitterContext = { fg = C.surface1, bg = constants.blur_background and "NONE" or C.base },
    TreesitterContextLineNumber = { link = "LineNr" },
    TreesitterContextBottom = { style = {} },

    -- nvim spelling
    SpellBad = { sp = stateColors.error, undercurl = true }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
    SpellCap = { sp = stateColors.warning, undercurl = true }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
    SpellLocal = { sp = stateColors.info, undercurl = true }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
    SpellRare = { sp = stateColors.hint, undercurl = true }, -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.

    -- nvim diagnostics
    ErrorMsg = { fg = stateColors.error }, -- error messages on the command line
    DiagnosticUnderlineError = { undercurl = true, sp = stateColors.error }, -- Used to underline "Error" diagnostics
    DiagnosticUnderlineWarn = { undercurl = true, sp = stateColors.warning }, -- Used to underline "Warning" diagnostics
    DiagnosticUnderlineInfo = { undercurl = true, sp = stateColors.info }, -- Used to underline "Information" diagnostics
    DiagnosticUnderlineHint = { undercurl = true, sp = stateColors.hint }, -- Used to underline "Hint" diagnostics
    DiagnosticError = { fg = stateColors.error }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
    DiagnosticWarn = { fg = stateColors.warning }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
    DiagnosticInfo = { fg = stateColors.info }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
    DiagnosticHint = { fg = stateColors.hint }, -- Used as the base highlight group. Other Diagnostic highlights link to this by default
    DiagnosticUnnecessary = { fg = U.darken(C.text, 0.667, C.base), undercurl = true, link = nil },
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
    FloatTitle = { bg = floatColors.bg, fg = floatColors.borderFg },
    NormalFloat = { bg = floatColors.bg },
    FloatBorder = { bg = floatColors.borderBg, fg = floatColors.borderFg },

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
    FoldColumn = { bg = constants.blur_background and "NONE" or C.base }, -- sign column
    Folded = { bg = "NONE" }, -- folded line

    -- nvim snippets
    SnippetTabstop = { bg = U.darken(C.surface1, 0.7, C.base) },

    -- nvim lsp
    LspReferenceText = { bg = U.darken(C.surface1, 0.7, C.base), underline = false },
    LspReferenceRead = { link = "LspReferenceText" },
    LspReferenceWrite = { link = "LspReferenceText" },

    -- col
    CursorLineNr = { bg = constants.blur_background and "NONE" or C.base },
    LineNr = { bg = constants.blur_background and "NONE" or C.base },
    SignColumn = { bg = constants.blur_background and "NONE" or C.base },

    -- nvim cursor
    -- Cursor = {
    --   bg = "NONE",
    --   fg = mocha.green,
    -- },
    -- CurSearch = {
    --   link = "Search",
    -- },
  }
end

local get_theme_overrides_hl = function(C)
  local extra_hl = get_extra_hl(C)
  local overrides_hl = get_overrides_hl(C)
  return vim.tbl_deep_extend("force", extra_hl, overrides_hl)
end

return {
  latte = get_theme_overrides_hl,
  frappe = get_theme_overrides_hl,
  macchiato = get_theme_overrides_hl,
  mocha = get_theme_overrides_hl,
}
