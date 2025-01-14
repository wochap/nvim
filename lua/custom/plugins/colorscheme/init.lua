local highlight_overrides = require "custom.plugins.colorscheme.hl_overrides"
local constants = require "custom.utils.constants"

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    event = "LazyFile",
    opts = {
      transparent_background = constants.transparent_background, -- disables setting the background color.
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
      color_overrides = {
        mocha = {
          dark_purple = "#c7a0dc",
          sun = "#ffe9b6",
          vibrant_green = "#b6f4be",
        },
      },
      highlight_overrides = highlight_overrides,
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
        render_markdown = true,
        blink_cmp = true,
        grug_far = true,
        window_picker = true,
        fidget = true,
        flash = true,
        gitsigns = true,
        indent_blankline = {
          enabled = true,
        },
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
          inlay_hints = {
            background = false,
          },
        },
        neotest = true,
        noice = true,
        nvimtree = true,
        neotree = true,
        semantic_tokens = true,
        telescope = {
          enabled = true,
          style = "nvchad",
        },
        treesitter = true,
        which_key = true,
      },
    },
  },
}
