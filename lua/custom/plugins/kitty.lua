local nvim_utils = require "custom.utils.nvim"
local lazy_utils = require "custom.utils.lazy"
local constants = require "custom.constants"

return {
  {
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = constants.in_kittyscrollback,
    commit = "db7ab6676774e3d33ef0d7833c96251456eecaa2", -- v9.2.0
    event = { "User KittyScrollbackLaunch" },
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    init = function()
      if constants.in_kittyscrollback then
        vim.opt.showtabline = 0
        vim.opt.laststatus = 0
      end
    end,
    opts = {
      callbacks = {
        after_setup = function()
          vim.opt.signcolumn = "no"
          vim.opt.cmdheight = 1
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
            zindex = constants.zindex_fullscreen,
          }
        end,
      },
      visual_selection_highlight_mode = "nvim",
    },
    config = function(_, opts)
      local ks = require "kitty-scrollback"
      lazy_utils.on_load("catppuccin", function()
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
    opts = {},
    config = function()
      nvim_utils.autocmd("FileType", {
        pattern = "kitty",
        group = nvim_utils.augroup "enable_kitty_syntax",
        command = "set syntax=kitty",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      vim.filetype.add {
        pattern = {
          [".*/kitty/.+%.conf"] = "kitty",
        },
      }
    end,
  },
}
