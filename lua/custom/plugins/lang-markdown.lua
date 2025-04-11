local constants = require "custom.utils.constants"
local utils = require "custom.utils"
local lazyUtils = require "custom.utils.lazy"
local keymapsUtils = require "custom.utils.keymaps"
local langUtils = require "custom.utils.lang"

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

  -- NOTE: lang-web.lua adds Prettier formatting for Markdown

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

  {
    "folke/snacks.nvim",
    optional = true,
    opts = {
      indent = {
        exclude_filetypes = { "markdown" },
      },
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = not constants.in_kittyscrollback,
    event = (constants.in_zk and { "LazyFile", "VeryLazy" }) or "VeryLazy",
    opts = {
      file_types = { "markdown" },
      change_events = { "DiagnosticChanged" },
      latex = {
        enabled = false,
      },
      heading = {
        sign = false,
        icons = { "󰼏  ", " 󰎨  ", "  󰼑  ", "   󰎲  ", "    󰼓  ", "     󰎴  " },
      },
      code = {
        sign = false,
        left_margin = 1,
        left_pad = 1,
        right_pad = 1,
      },
      link = {
        wiki = {
          body = function(ctx)
            if ctx.alias then
              return ctx.alias
            end
            -- get wiki conceal title from zk hint diagnostic
            -- source: https://github.com/MeanderingProgrammer/render-markdown.nvim/discussions/228
            local diagnostics = vim.diagnostic.get(ctx.buf, {
              lnum = ctx.row,
              severity = vim.diagnostic.severity.HINT,
            })
            for _, diagnostic in ipairs(diagnostics) do
              if diagnostic.source == "zk" then
                return diagnostic.message
              end
            end
            return nil
          end,
        },
      },
      overrides = {
        buftype = {
          nofile = {
            enabled = false,
          },
        },
      },
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      sources = {
        defaults = {
          function(default)
            local filetype = vim.api.nvim_buf_get_option(0, "filetype")
            local has_render_markdown = package.loaded["render-markdown"]
            if has_render_markdown then
              if filetype == "markdown" then
                return langUtils.list_merge(default, { "markdown" })
              end
            end
            return nil
          end,
        },
        providers = {
          markdown = {
            name = "RenderMarkdown",
            module = "render-markdown.integ.blink",
            kind = "RenderMarkdown",
          },
        },
      },
    },
  },
}
