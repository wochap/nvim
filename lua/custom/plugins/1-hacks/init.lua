-- HACK: this file will be loaded first by lazy.nvim

return {
  {
    "williamboman/mason.nvim",
    optional = true,
    -- NOTE: `opts_extend` don't work as expected
    -- if it isn't read by `lazy.nvim` at the start
    opts_extend = { "ensure_installed" },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts_extend = { "ensure_installed" },
  },

  {
    "folke/which-key.nvim",
    optional = true,
    opts_extend = { "spec" },
  },

  {
    "hrsh7th/nvim-cmp",
    optional = true,
    opts_extend = { "sources" },
  },
}
