-- HACK: this file will be loaded first by lazy.nvim

return {
  {
    "mason-org/mason.nvim",
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
    "nvim-neo-tree/neo-tree.nvim",
    optional = true,
    opts_extend = { "event_handlers" },
  },

  {
    "folke/which-key.nvim",
    optional = true,
    opts_extend = { "spec", "icons.rules" },
  },

  {
    "saghen/blink.cmp",
    optional = true,
    opts_extend = {
      "sources.default",
      -- NOTE: `sources.defaults` doesn't exist in blink.cmp
      -- it should be a list of functions
      "sources.defaults",
      -- NOTE: `enableds` doesn't exist in blink.cmp
      -- it should be a list of functions
      "enableds",
    },
  },

  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        optional = true,
        opts_extend = { "ensure_installed" },
      },
    },
  },

  {
    "folke/snacks.nvim",
    optional = true,
    opts_extend = { "indent.exclude_filetypes" },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    opts_extend = { "file_types" },
  },
}
