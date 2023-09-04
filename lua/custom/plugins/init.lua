local plugins = {
  { "nvim-lua/popup.nvim" },

  -- nvchad
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
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
    "Saimo/peek.nvim",
    commit = "f23200c241b06866b561150fa0389d535a4b903d",
    build = "deno task --quiet build:fast",
    config = function()
      require("custom.plugins.configs.peek").setup()
    end,
  },
  { "kdheepak/lazygit.nvim", cmd = { "LazyGit", "LazyGitConfig", "LazyGitFilter" } },
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
  { "gpanders/editorconfig.nvim" },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    config = function()
      require("persistence").setup()
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
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("custom.plugins.configs.others").nvim_surround()
    end,
  },
  { "tpope/vim-abolish" }, -- Change word casing
  { "tpope/vim-repeat" },
  { "tommcdo/vim-exchange" }, -- Switch words
  { "tommcdo/vim-lion" }, -- Align text vertically

  -- LSP stuff
  -- This is needed to fix lsp doc highlight
  -- { "antoinemadec/FixCursorHold.nvim" },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
          require "custom.plugins.configs.null-ls"
        end,
      },
      { "jose-elias-alvarez/nvim-lsp-ts-utils" },
    },
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins.configs.lspconfig"
    end,
  },
  { "b0o/schemastore.nvim" },

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
