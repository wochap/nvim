local utils = require "custom.utils"
local keymapsUtils = require "custom.utils.keymaps"

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = {
        "markdown",
        "markdown_inline",
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        marksman = {
          mason = false,
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["markdown"] = { "prettierd" },
      },
    },
  },

  {
    "Saimo/peek.nvim",
    main = "peek",
    commit = "f23200c241b06866b561150fa0389d535a4b903d",
    build = "deno task --quiet build:fast",
    init = function()
      utils.autocmd({ "BufEnter" }, {
        group = utils.augroup "load_peek_mappings",
        pattern = "*.md",
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          keymapsUtils.map("n", "<leader>fm", "<cmd>lua require('peek').open()<CR>", "open markdown previewer", {
            buffer = bufnr,
          })
          keymapsUtils.map("n", "<leader>fM", "<cmd>lua require('peek').close()<CR>", "close markdown previewer", {
            buffer = bufnr,
          })
        end,
      })
    end,
    opts = {
      auto_load = true, -- whether to automatically load preview when
      -- entering another markdown buffer

      close_on_bdelete = true, -- close preview window on buffer delete
      syntax = false, -- enable syntax highlighting, affects performance
      theme = "dark", -- 'dark' or 'light'
      update_on_change = true,
      app = { "qutebrowser", "--target", "window" }, -- 'webview', 'browser', string or a table of strings
      filetype = { "markdown" }, -- list of filetypes to recognize as markdown

      -- relevant if update_on_change is true
      throttle_at = 200000, -- start throttling when file exceeds this
      -- amount of bytes in size

      throttle_time = "auto", -- minimum amount of time in milliseconds
      -- that has to pass before starting new render
    },
  },
}
