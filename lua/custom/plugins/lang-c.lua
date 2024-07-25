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
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "make", "meson" })
    end,
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
