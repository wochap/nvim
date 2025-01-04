local utils = require "custom.utils"
local keymapsUtils = require "custom.utils.keymaps"
local nvim_textlabconfig_bin_path = vim.fn.stdpath "data" .. "/lazy/nvim-texlabconfig/nvim-texlabconfig"

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = { "latex", "bibtex" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    init = function()
      utils.autocmd({ "BufEnter" }, {
        group = utils.augroup "load_texlab_mappings",
        pattern = "*.tex",
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          keymapsUtils.map("n", "<leader>fl", "<cmd>TexlabForward<CR>", "texlab forward", {
            buffer = bufnr,
          })
        end,
      })
    end,
    opts = {
      servers = {
        texlab = {
          settings = {
            texlab = {
              -- auxDirectory = ".",
              -- bibtexFormatter = "texlab",
              build = {
                -- args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
                -- executable = "latexmk",
                forwardSearchAfter = true,
                onSave = true,
              },
              chktex = {
                --   onEdit = false,
                onOpenAndSave = true,
              },
              -- diagnosticsDelay = 300,
              -- formatterLineLength = 80,
              forwardSearch = {
                executable = "zathura",
                args = {
                  "--synctex-editor-command",
                  nvim_textlabconfig_bin_path .. [[ -file '%%%{input}' -line %%%{line} -server ]] .. vim.v.servername,
                  "--synctex-forward",
                  "%l:1:%f",
                  "%p",
                },
              },
              -- latexFormatter = "latexindent",
              -- latexindent = {
              --   modifyLineBreaks = false,
              -- },
            },
          },
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    dependencies = {
      -- NOTE: latexindent doesn't work on nixos
      -- {
      --   "williamboman/mason.nvim",
      --   optional = true,
      --   opts = {
      --     ensure_installed = { "latexindent" },
      --   },
      -- },
    },
    opts = {
      formatters_by_ft = {
        ["tex"] = { "latexindent" },
      },
    },
  },

  {
    "f3fora/nvim-texlabconfig",
    ft = { "tex", "bib" },
    build = "go build",
    opts = {},
  },

  {
    "folke/snacks.nvim",
    optional = true,
    opts = {
      indent = {
        exclude_filetypes = { "tex" },
      },
    },
  },
}
