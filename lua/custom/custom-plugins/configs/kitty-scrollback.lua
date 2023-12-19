local M = {}

local theme = require "custom.ui.highlights.themes.catppuccin-mocha"

M.options = {
  callbacks = {
    after_setup = function()
      local ksb_api = require "kitty-scrollback.api"
      vim.opt_local.signcolumn = "no"
      vim.keymap.set("n", "q", ksb_api.close_or_quit_all, {})
      vim.keymap.del("n", "g?")
      vim.keymap.set("n", "<esc>", ":noh<CR>", {})
    end,
  },
  highlight_overrides = {
    KittyScrollbackNvimSpinner = {
      bg = theme.base_30.darker_black,
      fg = theme.base_30.lavender,
    },
    KittyScrollbackNvimNormal = {
      bg = theme.base_30.darker_black,
      fg = theme.base_30.lavender,
    },
    KittyScrollbackNvimPasteWinNormal = {
      bg = theme.base_30.darker_black,
    },
    KittyScrollbackNvimPasteWinFloatBorder = {
      bg = theme.base_30.darker_black,
      fg = theme.base_30.darker_black,
    },
  },
  keymaps_enabled = true,
  status_window = {
    enabled = true,
    style_simple = true,
  },
  paste_window = {
    hide_footer = true,
    winopts_overrides = function(winopts)
      return vim.tbl_deep_extend("force", {}, {
        anchor = "NW",
        border = "rounded",
        col = 0,
        focusable = true,
        height = math.floor(vim.o.lines / 2.5),
        relative = "editor",
        row = vim.o.lines,
        style = "minimal",
        width = vim.o.columns,
        zindex = 40,
      })
    end,
    footer_winopts_overrides = function(winopts)
      return winopts
    end,
  },
  visual_selection_highlight_mode = "nvim",
}

return M
