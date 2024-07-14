local constants = require "custom.utils.constants"

return {
  -- {
  --   enabled = not constants.first_install,
  --   import = "lazyvim.plugins.extras.lang.python",
  -- },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        ruff_lsp = {
          keys = {
            {
              "<leader>co",
              false,
            },
            {
              "<leader>lo",
              function()
                vim.lsp.buf.code_action {
                  apply = true,
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                }
              end,
              desc = "Organize Imports",
            },
          },
        },
      },
    },
  },

  -- undo none-ls changes added by LazyVim
  {
    "nvimtools/none-ls.nvim",
    enabled = false,
  },

  {
    "mfussenegger/nvim-lint",
    dependencies = {
      {
        "williamboman/mason.nvim",
        optional = true,
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "pylint" })
        end,
      },
    },
    opts = {
      linters_by_ft = {
        python = { "pylint" },
      },
    },
  },
}
