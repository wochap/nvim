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

local getOverridesHl = function(mocha)
  local utils = require "custom.ui.highlights.utils.init"
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
    DiffAdd = { bg = utils.darken(gitColors.add, 0.2, mocha.mantle), fg = "NONE" },
    DiffChange = { bg = utils.darken(gitColors.change, 0.2, mocha.mantle), fg = "NONE" },
    DiffDelete = { bg = utils.darken(gitColors.delete, 0.2, mocha.mantle), fg = "NONE" },
    DiffText = { bg = utils.brighten(utils.darken(gitColors.change, 0.2, mocha.mantle), 0.15), fg = "NONE" },

    -- diffview.nvim
    DiffviewDiffAdd = { link = "DiffAdd" }, -- right diff add
    DiffviewDiffAddText = {
      bg = utils.brighten(utils.darken(gitColors.add, 0.2, mocha.mantle), 0.15),
      fg = "NONE",
    }, -- right diff add text
    DiffviewDiffDelete = { link = "DiffDelete" }, -- left diff delete
    DiffviewDiffDeleteText = {
      bg = utils.brighten(utils.darken(gitColors.delete, 0.2, mocha.mantle), 0.15),
      fg = "NONE",
    }, -- left diff delete text
    DiffviewDiffDeleteSign = { fg = mocha.surface1 }, -- both diff delete sign
    DiffviewDiffAddAsDelete = { bg = mocha.green }, -- TODO: investigate
    DiffviewFilePanelCounter = { fg = mocha.red, bg = "NONE" },
    DiffviewFilePanelTitle = { fg = mocha.lavender, bg = "NONE" },
    -- DiffviewNormal = { link = "NvimTreeNormal" },
    -- DiffviewVertSplit = { link = "VertSplit" },

    -- git-conflict.nvim
    GitConflictCurrentLabel = { bg = utils.darken(gitColors.add, 0.4, mocha.mantle) },
    GitConflictCurrent = { bg = utils.darken(gitColors.add, 0.2, mocha.mantle) },
    GitConflictIncoming = { bg = utils.darken(gitColors.info, 0.2, mocha.mantle) },
    GitConflictIncomingLabel = { bg = utils.darken(gitColors.info, 0.4, mocha.mantle) },
    GitConflictAncestorLabel = { bg = utils.darken(gitColors.ancestor, 0.4, mocha.mantle) },
    GitConflictAncestor = { bg = utils.darken(gitColors.ancestor, 0.2, mocha.mantle) },

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
    DiagnosticUnnecessary = { fg = utils.darken(mocha.text, 0.667, mocha.base), link = nil },
    DiagnosticFloatingError = { fg = stateColors.error }, -- Used to color "Error" diagnostic messages in diagnostics float
    DiagnosticFloatingWarn = { fg = stateColors.warning }, -- Used to color "Warn" diagnostic messages in diagnostics float
    DiagnosticFloatingInfo = { fg = stateColors.info }, -- Used to color "Info" diagnostic messages in diagnostics float
    DiagnosticFloatingHint = { fg = stateColors.hint }, -- Used to color "Hint" diagnostic messages in diagnostics float
  }
end

local getExtraHl = function(mocha)
  local utils = require "custom.ui.highlights.utils.init"
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
    WindowPicker = { fg = mocha.red, bg = utils.darken(mocha.surface0, 0.64, mocha.base), style = { "bold" } },
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
      bg = utils.darken(gitColors.delete, 0.2, mocha.mantle),
      undercurl = true,
    },
  }
end

local getNvchadHl = function(mocha)
  local utils = require "custom.ui.highlights.utils.init"
  local gitColors = getColors(mocha).git
  local stateColors = getColors(mocha).state
  local stModuleBg = mocha.surface0
  local stModuleFg = mocha.text
  local statusline_bg = mocha.base
  local statusline_fg = mocha.text

  local result = {}

  -- statusline
  local function genModes_hl(modename, col)
    result["St_" .. modename .. "Mode"] = { fg = mocha.base, bg = mocha[col], style = { "bold" } }
    result["St_" .. modename .. "ModeSep"] = { fg = mocha[col], bg = statusline_bg }
  end
  genModes_hl("Normal", "lavender")
  genModes_hl("Visual", "flamingo")
  genModes_hl("Insert", "green")
  genModes_hl("Terminal", "green")
  genModes_hl("NTerminal", "lavender")
  genModes_hl("Replace", "maroon")
  genModes_hl("Confirm", "mauve")
  genModes_hl("Command", "peach")
  genModes_hl("Select", "maroon")

  return vim.tbl_deep_extend("force", result, {
    -- statusline
    St_gitAdd = {
      bg = statusline_bg,
      fg = gitColors.add,
    },
    St_gitChange = {
      bg = statusline_bg,
      fg = gitColors.change,
    },
    St_gitDelete = {
      bg = statusline_bg,
      fg = gitColors.delete,
    },
    St_lspInfo = {
      bg = statusline_bg,
      fg = stateColors.info,
    },
    St_lspWarning = {
      bg = statusline_bg,
      fg = stateColors.warning,
    },
    St_lspError = {
      bg = statusline_bg,
      fg = stateColors.error,
    },
    St_lspHints = {
      bg = statusline_bg,
      fg = stateColors.hint,
    },
    ST_sep = {
      fg = stModuleBg,
      bg = statusline_bg,
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
      bg = statusline_bg,
      bold = false,
    },
    St_LspStatus = {
      fg = statusline_fg,
      bg = statusline_bg,
    },
    St_IndentInfo = {
      fg = statusline_fg,
      bg = statusline_bg,
    },
    St_fileType = {
      fg = statusline_fg,
      bg = statusline_bg,
    },

    -- nvim-cmp
    PmenuSel = { bg = mocha.green, fg = mocha.base },
  })
end

return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    opts = {
      transparent_background = false, -- disables setting the background color.
      show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
      term_colors = true, -- sets terminal colors (e.g. `g:terminal_color_0`)
      dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.10, -- percentage of the shade to apply to the inactive window
      },
      no_italic = true, -- Force no italic
      no_bold = false, -- Force no bold
      no_underline = false, -- Force no underline
      styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = {}, -- Change the style of comments
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      color_overrides = {},
      highlight_overrides = {
        mocha = function(mocha)
          local extraHl = getExtraHl(mocha)
          local overridesHl = getOverridesHl(mocha)
          local nvchadHl = getNvchadHl(mocha)
          return vim.tbl_deep_extend("force", extraHl, overridesHl, nvchadHl)
        end,
      },
      integrations = {
        -- disable enabled by default
        alpha = false,
        cmp = false,
        dashboard = false,
        neogit = false,
        illuminate = {
          enabled = false,
          lsp = false,
        },

        -- enable the ones we'll use
        flash = true,
        gitsigns = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        markdown = true,
        mason = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        neotest = true,
        noice = true,
        nvimtree = true,
        semantic_tokens = true,
        telescope = {
          enabled = true,
          style = "nvchad",
        },
        treesitter = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme "catppuccin"
    end,
  },
}
