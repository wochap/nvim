local getColors = function(palette)
  return {
    state = {
      error = palette.red,
      warning = palette.peach,
      info = palette.blue,
      hint = palette.mauve,
    },
    git = {
      delete = palette.red,
      add = palette.green,
      change = palette.peach,
      info = palette.blue,
      ancestor = palette.text,
      stage = palette.mauve,
    },
  }
end

local getExtraHl = function(mocha)
  local colorschemeUtils = require "custom.utils.colorscheme"
  local gitColors = getColors(mocha).git

  return {
    lessCssAttribute = { fg = mocha.white, link = nil },

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

    -- window-picker.nvim
    WindowPicker = {
      fg = mocha.red,
      bg = colorschemeUtils.darken(mocha.surface0, 0.64, mocha.base),
      style = { "bold" },
    },
    WindowPickerSwap = { link = "WindowPicker" },

    -- oil.nvim
    OilMtime = { fg = "#8383A9" },
    OilSize = { fg = "#87FF87" },
    OilRead = { fg = mocha.mauve },
    OilWrite = { fg = "#FD86D5" },
    OilExecute = { fg = mocha.teal },
    OilHyphen = { fg = mocha.red },

    -- vim-illuminate
    -- IlluminatedWordText = { bg = utils.darken(mocha.surface1, 0.7, mocha.base) },
    IlluminatedWord = { bg = "NONE", underline = false },
    IlluminatedCurWord = { link = "IlluminatedWord" },
    IlluminatedWordText = { link = "IlluminatedWord" },
    IlluminatedWordRead = { link = "IlluminatedWord" },
    IlluminatedWordWrite = { link = "IlluminatedWord" },

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
  }
end

local getOverridesHl = function(mocha)
  local colorschemeUtils = require "custom.utils.colorscheme"
  local gitColors = getColors(mocha).git
  local stateColors = getColors(mocha).state

  return {
    -- syntax
    ["@variable"] = { link = "Variable" },
    PreProc = { link = "Comment" },
    Todo = { fg = mocha.blue, bg = mocha.base },
    Error = { fg = mocha.red, bg = "NONE" }, -- (preferred) any erroneous construct

    -- ufo
    UfoPreviewNormal = { bg = mocha.mantle },
    UfoFoldedEllipsis = { link = "Comment" },
    FoldColumn = { link = "LineNr" },

    -- flash.nvim
    FlashPrompt = { link = "Normal" },
    FlashPromptMode = { link = "St_CommandMode" },
    FlashPromptModeSep = { link = "St_CommandModeSep" },

    -- nvim-tree.lua
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
    NvimTreeWindowPicker = { link = "WindowPicker" },

    -- gitsigns.nvim
    GitSignsAdd = { fg = gitColors.add },
    GitSignsChange = { fg = gitColors.change },
    GitSignsDelete = { fg = gitColors.delete },
    GitSignsDeleteInline = { link = "DiffviewDiffDeleteText" },
    GitSignsAddInline = { link = "DiffviewDiffAddText" },
    GitSignsAddPreview = { link = "DiffAdd" },
    GitSignsDeletePreview = { link = "DiffDelete" },

    -- nvim diff
    DiffAdd = { bg = colorschemeUtils.darken(gitColors.add, 0.2, mocha.mantle), fg = "NONE" },
    DiffChange = { bg = colorschemeUtils.darken(gitColors.change, 0.2, mocha.mantle), fg = "NONE" },
    DiffDelete = { bg = colorschemeUtils.darken(gitColors.delete, 0.2, mocha.mantle), fg = "NONE" },
    DiffText = {
      bg = colorschemeUtils.brighten(colorschemeUtils.darken(gitColors.change, 0.2, mocha.mantle), 0.15),
      fg = "NONE",
    },

    -- diffview.nvim
    DiffviewDiffAdd = { link = "DiffAdd" }, -- right diff add
    DiffviewDiffAddText = {
      bg = colorschemeUtils.brighten(colorschemeUtils.darken(gitColors.add, 0.2, mocha.mantle), 0.15),
      fg = "NONE",
    }, -- right diff add text
    DiffviewDiffDelete = { link = "DiffDelete" }, -- left diff delete
    DiffviewDiffDeleteText = {
      bg = colorschemeUtils.brighten(colorschemeUtils.darken(gitColors.delete, 0.2, mocha.mantle), 0.15),
      fg = "NONE",
    }, -- left diff delete text
    DiffviewDiffDeleteSign = { fg = mocha.surface1 }, -- both diff delete sign
    DiffviewDiffAddAsDelete = { bg = mocha.green }, -- TODO: investigate
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
    DiagnosticUnnecessary = { fg = colorschemeUtils.darken(mocha.text, 0.667, mocha.base), link = nil },
    DiagnosticFloatingError = { fg = stateColors.error }, -- Used to color "Error" diagnostic messages in diagnostics float
    DiagnosticFloatingWarn = { fg = stateColors.warning }, -- Used to color "Warn" diagnostic messages in diagnostics float
    DiagnosticFloatingInfo = { fg = stateColors.info }, -- Used to color "Info" diagnostic messages in diagnostics float
    DiagnosticFloatingHint = { fg = stateColors.hint }, -- Used to color "Hint" diagnostic messages in diagnostics float
  }
end

return {
  mocha = function(mocha)
    local extraHl = getExtraHl(mocha)
    local overridesHl = getOverridesHl(mocha)
    return vim.tbl_deep_extend("force", extraHl, overridesHl)
  end,
}
