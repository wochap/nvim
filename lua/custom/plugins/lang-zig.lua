local constants = require "custom.constants"

if constants.in_fast then
  return {}
end

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
