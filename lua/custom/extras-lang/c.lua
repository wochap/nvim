local plugins = {
  { import = "lazyvim.plugins.extras.lang.clangd" },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        clangd = {
          keys = {
            { "<leader>cR", false },
            { "<leader>lh", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
          },
        },
      },
    },
  },
}

return plugins
