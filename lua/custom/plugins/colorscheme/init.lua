local highlight_overrides = require "custom.plugins.colorscheme.hl_overrides"
local constants = require "custom.utils.constants"

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    event = "LazyFile",
    opts = {
      transparent_background = constants.transparent_background,
      show_end_of_buffer = false,
      term_colors = true,
      dim_inactive = {
        enabled = false,
      },
      no_italic = true,
      no_bold = false,
      no_underline = false,
      styles = {
        comments = {},
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
      color_overrides = {
        all = {
          dark_purple = "#c7a0dc",
          sun = "#ffe9b6",
          vibrant_green = "#b6f4be",
        },
      },
      -- TODO: use custom_highlights
      custom_highlights = {},
      highlight_overrides = highlight_overrides,
      default_integrations = false,
      integrations = {
        -- enable the ones we'll use
        blink_cmp = true,
        diffview = true,
        fidget = true,
        flash = true,
        gitsigns = true,
        grug_far = true,
        harpoon = true,
        -- markdown = true,
        mason = true,
        mini = true,
        neotree = true,
        noice = true,
        neotest = true,
        dap = true,
        dap_ui = true,
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = {},
            hints = {},
            warnings = {},
            information = {},
            ok = {},
          },
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
            ok = { "undercurl" },
          },
          inlay_hints = {
            background = false,
          },
        },
        semantic_tokens = true,
        nvimtree = true,
        treesitter_context = true,
        treesitter = true,
        window_picker = true,
        render_markdown = true,
        snacks = {
          enabled = true,
          indent_scope_color = "surface2",
        },
        lsp_trouble = true,
        which_key = true,
      },
    },
  },
}
