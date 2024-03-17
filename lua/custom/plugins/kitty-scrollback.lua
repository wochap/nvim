local in_kittyscrollback = require("custom.utils.constants").in_kittyscrollback

return {
  {
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = in_kittyscrollback,
    event = { "User KittyScrollbackLaunch" },
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    commit = "af95c02d558216202639609a56123fed9d8fb193",
    opts = function()
      local mocha = require("catppuccin.palettes").get_palette "mocha"
      return {
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
            bg = mocha.mantle,
            fg = mocha.lavender,
          },
          KittyScrollbackNvimNormal = {
            bg = mocha.mantle,
            fg = mocha.lavender,
          },
          KittyScrollbackNvimPasteWinNormal = {
            bg = mocha.mantle,
          },
          KittyScrollbackNvimPasteWinFloatBorder = {
            bg = mocha.mantle,
            fg = mocha.mantle,
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
    end,
    config = function(_, opts)
      require("kitty-scrollback").setup {
        global = function()
          return opts
        end,
      }
    end,
  },
}
