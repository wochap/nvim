local plugins = {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "nix" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        rnix = {},
      },
    },
  },

  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      local null_ls = require "null-ls"
      local b = null_ls.builtins

      vim.list_extend(opts.sources, {
        b.code_actions.statix,
        b.formatting.nixfmt,
        b.diagnostics.statix,
      })
    end,
  },
}

return plugins
