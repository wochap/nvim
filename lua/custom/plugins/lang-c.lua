local constants = require "custom.utils.constants"

return {
  {
    enabled = not constants.first_install,
    import = "lazyvim.plugins.extras.lang.clangd",
  },
  -- {
  --   enabled = not constants.first_install,
  --   import = "lazyvim.plugins.extras.lang.cmake",
  -- },

  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = { "make", "meson" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        -- autotools_ls = {},
        clangd = {
          keys = {
            {
              "<leader>cR",
              false,
            },
            {
              "<leader>lh",
              "<cmd>ClangdSwitchSourceHeader<cr>",
              desc = "Switch Source/Header (C/C++)",
            },
          },
          mason = false,
        },
      },
    },
  },
}
