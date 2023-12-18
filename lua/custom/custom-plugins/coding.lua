return {
  {
    "windwp/nvim-ts-autotag",
    event = "LazyFile",
    opts = {},
  },
  {
    "echasnovski/mini.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("custom.custom-plugins.configs.mini").setup()
    end,
  },
  {
    "wochap/emmet-vim",
    event = "VeryLazy",
    init = function()
      vim.g.user_emmet_leader_key = "<C-z>"
    end,
  },
  { "tpope/vim-abolish", event = "VeryLazy" }, -- Change word casing
  { "tpope/vim-repeat", event = "VeryLazy" }, -- Repeat vim-abolish
  {
    "fladson/vim-kitty",
    event = "VeryLazy",
    ft = "kitty",
  },
}
