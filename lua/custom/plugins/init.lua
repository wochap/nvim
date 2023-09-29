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
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("plugins.configs.others").luasnip(opts)
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
      },
    },
    opts = function()
      return vim.tbl_deep_extend(
        "force",
        require "plugins.configs.cmp",
        require("custom.plugins.overrides.cmp").options
      )
    end,
    config = function(_, opts)
      require("cmp").setup(opts)
      require("custom.plugins.overrides.cmp").setup(opts)
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
    opts = function()
      return vim.tbl_deep_extend(
        "force",
        require "plugins.configs.mason",
        require("custom.plugins.overrides.others").mason
      )
    end,
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
  {
    "kazhala/close-buffers.nvim",
    opts = {
      next_buffer_cmd = function(windows)
        require("nvchad.tabufline").tabuflineNext()

        local bufnr = vim.api.nvim_get_current_buf()
        for _, window in ipairs(windows) do
          vim.api.nvim_win_set_buf(window, bufnr)
        end
      end,
    },
  },
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
    -- <C-y>,
    "wochap/emmet-vim",
    event = "VeryLazy",
    dependencies = { "wochap/cmp-emmet-vim" },
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
  -- TODO: wait for nvim 0.10
  -- {
  --   "mikesmithgh/kitty-scrollback.nvim",
  --   enabled = true,
  --   lazy = true,
  --   cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
  --   version = "^1.0.0", -- pin major version, include fixes and features that do not have breaking changes
  --   config = function()
  --     require("kitty-scrollback").setup()
  --   end,
  -- },
  { "mrjones2014/smart-splits.nvim" },
  { "tpope/vim-abolish" }, -- Change word casing
  { "tpope/vim-repeat" }, -- Repeat vim-abolish

  -- LSP stuff
  {
    "neovim/nvim-lspconfig",
    init = nil,
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.plugins.configs.lspconfig"
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require "custom.plugins.configs.null-ls"
    end,
  },
  {
    "jose-elias-alvarez/typescript.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("custom.plugins.configs.typescript").setup()
    end,
  },
  {
    "b0o/schemastore.nvim",
    event = "VeryLazy",
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "jose-elias-alvarez/typescript.nvim",
    },
    config = function()
      require("custom.plugins.configs.mason-lspconfig").setup()
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    init = function()
      require("core.utils").lazy_load "mason-null-ls.nvim"
    end,
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
      require("custom.plugins.configs.mason-null-ls").setup()
    end,
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

  -- Lang
  {
    "fladson/vim-kitty",
    event = "VeryLazy",
    ft = "kitty",
  },
}

return plugins
