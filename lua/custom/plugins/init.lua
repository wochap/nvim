local plugins = {
  { "nvim-lua/popup.nvim" },

  -- nvchad
  {
    "NvChad/base46",
    dependencies = {
      "levouh/tint.nvim",
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      "https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git",
    },
    opts = function()
      return vim.tbl_deep_extend(
        "force",
        require "plugins.configs.treesitter",
        require "custom.plugins.overrides.treesitter"
      )
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function()
      return vim.tbl_deep_extend(
        "force",
        require("plugins.configs.others").gitsigns,
        require "custom.plugins.overrides.gitsigns"
      )
    end,
  },
  {
    "rafamadriz/friendly-snippets",
    dependencies = {
      {
        "nicoache1/vscode-es7-javascript-react-snippets",
        build = "yarn install --frozen-lockfile && yarn compile",
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      return vim.tbl_deep_extend("force", require "plugins.configs.cmp", require "custom.plugins.overrides.cmp")
    end,
  },
  {
    "windwp/nvim-autopairs",
    opts = function()
      return require("custom.plugins.overrides.others").autopairs
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    opts = function()
      return require("custom.plugins.overrides.others").luasnip
    end,
  },
  {
    "numToStr/Comment.nvim",
    config = function(_, opts)
      require("Comment").setup {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = function()
      return vim.tbl_deep_extend(
        "force",
        require "plugins.configs.nvimtree",
        require "custom.plugins.overrides.nvim-tree"
      )
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = function()
      return vim.tbl_deep_extend(
        "force",
        require "plugins.configs.telescope",
        require "custom.plugins.overrides.telescope"
      )
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "whichkey")
      require("which-key").setup(opts)
      require "custom.plugins.overrides.whichkey"
    end,
  },
  {
    "williamboman/mason.nvim",
    enabled = false,
  },
  {
    "NvChad/nvim-colorizer.lua",
    opts = function()
      return require("custom.plugins.overrides.others").colorizer
    end,
  },

  -- custom
  {
    "echasnovski/mini.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("custom.plugins.configs.mini").setup()
    end,
  },
  {
    "Saimo/peek.nvim",
    commit = "f23200c241b06866b561150fa0389d535a4b903d",
    build = "deno task --quiet build:fast",
    config = function()
      require("custom.plugins.configs.peek").setup()
    end,
  },
  {
    "levouh/tint.nvim",
    event = "VeryLazy",
    config = function()
      require("custom.plugins.configs.tint").setup()
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitFilter" },
    config = function()
      vim.g.lazygit_floating_window_scaling_factor = 1 -- scaling factor for floating window
    end,
  },
  { "kazhala/close-buffers.nvim" },
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    config = function()
      require("custom.plugins.configs.todo-comments").setup()
    end,
  },
  {
    "folke/trouble.nvim",
    config = function()
      require("custom.plugins.configs.others").trouble_nvim()
    end,
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    config = function()
      require("persistence").setup()
    end,
  },
  {
    "folke/zen-mode.nvim",
    cmd = { "ZenMode" },
    opts = function()
      return require "custom.plugins.configs.zen-mode"
    end,
  },
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.input(...)
      end
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    config = function()
      require("custom.plugins.configs.diffview").setup()
    end,
  },
  { "ThePrimeagen/harpoon" },
  -- {
  --   "nvim-neorg/neorg",
  --   lazy = false,
  --   build = ":Neorg sync-parsers",
  --   dependencies = { "nvim-neorg/neorg-telescope" },
  --   config = function()
  --     require("custom.plugins.configs.neorg").setup()
  --   end,
  -- },
  { "szw/vim-maximizer", cmd = { "MaximizerToggle" } },
  {
    "windwp/nvim-spectre",
    config = function()
      require("custom.plugins.configs.others").nvim_spectre()
    end,
  },
  {
    "wochap/emmet-vim",
    lazy = false,
    init = function()
      require("custom.plugins.configs.others").emmet_vim()
    end,
  },
  {
    "rhysd/conflict-marker.vim",
    event = "BufReadPost",
    init = function()
      require("custom.plugins.configs.others").conflict_marker()
    end,
  },
  {
    url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git",
    config = function()
      require("custom.plugins.configs.others").rainbow_delimiters()
    end,
  },
  { "tpope/vim-abolish" }, -- Change word casing
  { "tpope/vim-repeat" }, -- Repeat vim-abolish

  -- LSP stuff
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins.configs.lspconfig"
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require "custom.plugins.configs.null-ls"
    end,
  },
  {
    "jose-elias-alvarez/typescript.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("custom.plugins.configs.typescript").setup()
    end,
  },
  {
    "b0o/schemastore.nvim",
    event = "VeryLazy",
  },

  -- Dap
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "rcarriga/nvim-dap-ui",
        config = function()
          require("dapui").setup()
        end,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
          require("nvim-dap-virtual-text").setup()
        end,
      },
    },
    config = function()
      require("custom.plugins.configs.nvim-dap").setup()
    end,
  },
}

return plugins
