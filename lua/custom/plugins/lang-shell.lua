return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = { "bash" },
    },
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
