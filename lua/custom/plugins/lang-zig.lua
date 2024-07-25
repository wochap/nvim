return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = { "zig" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        zls = {},
      },
    },
  },
}
