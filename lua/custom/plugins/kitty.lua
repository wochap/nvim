local utils = require "custom.utils"
local lazyUtils = require "custom.utils.lazy"
local in_kittyscrollback = require("custom.utils.constants").in_kittyscrollback

return {
  {
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = in_kittyscrollback,
    commit = "3f430ff8829dc2b0f5291d87789320231fdb65a1",
    event = { "User KittyScrollbackLaunch" },
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    init = function()
      if in_kittyscrollback then
        vim.opt.showtabline = 0
        vim.opt.laststatus = 0
      end
    end,
    opts = {
      callbacks = {
        after_setup = function()
          local ksb_api = require "kitty-scrollback.api"
          vim.opt.signcolumn = "no"
          vim.opt.cmdheight = 1
          vim.keymap.set("n", "Q", ksb_api.quit_all, {})
          vim.keymap.set("n", "q", ksb_api.close_or_quit_all, {})
          vim.keymap.set("n", "<esc>", ":noh<CR>", {})
        end,
      },
      keymaps_enabled = true,
      status_window = {
        enabled = true,
        style_simple = true,
      },
      paste_window = {
        hide_footer = true,
        winopts_overrides = function(winopts)
          return {
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
          }
        end,
      },
      visual_selection_highlight_mode = "nvim",
    },
    config = function(_, opts)
      local ks = require "kitty-scrollback"
      lazyUtils.on_load("catppuccin", function()
        local mocha = require("catppuccin.palettes").get_palette "mocha"
        vim.api.nvim_set_hl(0, "MsgArea", { fg = mocha.peach })
        opts.highlight_overrides = {
          KittyScrollbackNvimStatusWinNormal = {
            bg = mocha.surface0,
            fg = mocha.peach,
          },
          KittyScrollbackNvimStatusWinHeartIcon = { link = "KittyScrollbackNvimStatusWinNormal" },
          KittyScrollbackNvimStatusWinSpinnerIcon = { link = "KittyScrollbackNvimStatusWinNormal" },
          KittyScrollbackNvimStatusWinReadyIcon = { link = "KittyScrollbackNvimStatusWinNormal" },
          KittyScrollbackNvimStatusWinKittyIcon = { link = "KittyScrollbackNvimStatusWinNormal" },
          KittyScrollbackNvimStatusWinNvimIcon = { link = "KittyScrollbackNvimStatusWinNormal" },
          KittyScrollbackNvimPasteWinNormal = {
            bg = mocha.mantle,
          },
          KittyScrollbackNvimPasteWinFloatBorder = {
            bg = mocha.mantle,
            fg = mocha.mantle,
          },
        }
        ks.setup { opts }
      end)
    end,
  },

  {
    "fladson/vim-kitty",
    ft = "kitty",
    init = function()
      utils.autocmd("FileType", {
        pattern = "kitty",
        group = utils.augroup "enable_kitty_syntax",
        command = "set syntax=kitty",
      })
    end,
  },
}
