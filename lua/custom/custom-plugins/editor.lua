local in_kittyscrollback = require("custom.utils.constants").in_kittyscrollback

return {
  {
    "stevearc/oil.nvim",
    cmd = { "Oil" },
    opts = function()
      return require("custom.custom-plugins.configs.oil").options
    end,
  },
  {
    -- loaded with autocmd, md files
    "Saimo/peek.nvim",
    commit = "f23200c241b06866b561150fa0389d535a4b903d",
    build = "deno task --quiet build:fast",
    opts = function(_, opts)
      return require("custom.custom-plugins.configs.peek").options
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitFilter" },
    config = function()
      vim.g.lazygit_floating_window_scaling_factor = 1 -- scaling factor for floating window
    end,
  },
  {
    "kazhala/close-buffers.nvim",
    opts = function(_, opts)
      return require("custom.custom-plugins.configs.close-buffers").options
    end,
  },
  {
    "folke/todo-comments.nvim",
    event = "LazyFile",
    cmd = { "TodoTrouble", "TodoTelescope" },
    opts = {
      signs = false,
      highlight = {
        before = "", -- "fg" or "bg" or empty
        keyword = "fg", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
        after = "", -- "fg" or "bg" or empty
      },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = {
      use_diagnostic_signs = true,
      -- group = false,
    },
    config = function(_, opts)
      require("trouble").setup(opts)
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    opts = function()
      return require("custom.custom-plugins.configs.diffview").options
    end,
  },
  { "ThePrimeagen/harpoon" },
  {
    "szw/vim-maximizer",
    cmd = { "MaximizerToggle" },
  },
  {
    "nvim-pack/nvim-spectre",
    opts = function()
      return require("custom.custom-plugins.configs.nvim-spectre").options
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = function()
      return require("custom.custom-plugins.configs.flash").options
    end,
    keys = function()
      return require("custom.custom-plugins.configs.flash").keys
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = function(_, opts)
      -- integrate flash in telescope
      local flash = require("custom.utils.telescope").flash
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        mappings = { n = { s = flash }, i = { ["<c-s>"] = flash } },
      })
    end,
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "VeryLazy",
    opts = function()
      return require("custom.custom-plugins.configs.git-conflict").options
    end,
    config = function(_, opts)
      require("custom.custom-plugins.configs.git-conflict").setup(opts)
    end,
  },
  {
    "NMAC427/guess-indent.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "mikesmithgh/kitty-scrollback.nvim",
    lazy = not in_kittyscrollback,
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    commit = "8c36b74723049521cbcc5361c7477cb69c02812f",
    opts = function()
      return require("custom.custom-plugins.configs.kitty-scrollback").options
    end,
    config = function(_, opts)
      require("kitty-scrollback").setup {
        global = function()
          return opts
        end,
      }
    end,
  },
  {
    "mrjones2014/smart-splits.nvim",
    opts = {
      cursor_follows_swapped_bufs = true,
      at_edge = "stop",
    },
  },
  {
    "ten3roberts/window-picker.nvim",
    cmd = { "WindowSwap", "WindowPick" },
    opts = {
      swap_shift = false,
    },
  },
}
