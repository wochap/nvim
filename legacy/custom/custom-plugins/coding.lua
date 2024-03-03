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
  {
    "johmsalas/text-case.nvim",
    lazy = false,
    opts = {
      prefix = "gt",
      enabled_methods = {
        "to_snake_case",
        "to_dash_case",
        "to_constant_case",
        "to_camel_case",
        "to_pascal_case",
      },
    },
    config = function(_, opts)
      require("textcase").setup(opts)
      require("telescope").load_extension "textcase"

      require("lazyvim.util").on_load("which-key.nvim", function()
        require("which-key").register({
          ["gt"] = {
            name = "Text case",
          },
        }, {
          mode = "x",
        })
      end)
    end,
    keys = {
      { "gt.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "v" }, desc = "Telescope" },
    },
  },
  { "tpope/vim-repeat", event = "VeryLazy" }, -- Repeat vim-abolish
  {
    "fladson/vim-kitty",
    event = "VeryLazy",
    ft = "kitty",
  },
}
