local utils = require "custom.utils"

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = { "bash", "just" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      utils.autocmd("BufEnter", {
        group = utils.augroup "disable_diagnostics_in_env_files",
        pattern = ".env*",
        callback = function(event)
          vim.diagnostic.enable(false, {
            bufnr = event.buf,
          })
        end,
      })

      vim.filetype.add {
        pattern = {
          ["%.env%.[%w_.-]+"] = "sh",
        },
      }
    end,
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        bashls = {},
      },
    },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    dependencies = {
      {
        "williamboman/mason.nvim",
        optional = true,
        opts = {
          ensure_installed = { "shfmt" },
        },
      },
    },
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
        just = { "just" },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    optional = true,
    dependencies = {
      {
        "williamboman/mason.nvim",
        optional = true,
        opts = {
          ensure_installed = { "shellcheck" },
        },
      },
    },
    opts = {
      linters_by_ft = {
        sh = { "shellcheck" },
      },
    },
  },
}
