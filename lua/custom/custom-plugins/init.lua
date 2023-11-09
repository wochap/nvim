local g = vim.g

local plugins = {
  { "nvim-lua/popup.nvim" },

  -- nvchad
  {
    "lukas-reineke/indent-blankline.nvim",
    version = false,
    opts = function()
      return require("custom.custom-plugins.overrides.blankline").options
    end,
    config = function(_, opts)
      require("core.utils").load_mappings "blankline"
      dofile(vim.g.base46_cache .. "blankline")
      require("ibl").setup(opts)
    end,
    main = "ibl",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    init = function() end,
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
          require("custom.custom-plugins.configs.treesitter-textobjects").setup()
        end,
      },
      "JoosepAlviste/nvim-ts-context-commentstring",
      "https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git",
    },
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, require("custom.custom-plugins.overrides.treesitter").options)
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, require("custom.custom-plugins.overrides.gitsigns").options)
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
    event = { "CmdlineEnter", "InsertEnter" },
    version = false, -- last release is way too old
    dependencies = {
      -- cmp sources plugins
      {
        "hrsh7th/cmp-cmdline",
        "rcarriga/cmp-dap",
      },
    },
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, require("custom.custom-plugins.overrides.cmp").options)
    end,
    config = function(_, opts)
      require("custom.custom-plugins.overrides.cmp").setup(opts)
    end,
  },
  {
    "windwp/nvim-autopairs",
    opts = {
      -- Don't add pairs if it already has a close pair in the same line
      enable_check_bracket_line = true,
      -- Don't add pairs if the next char is alphanumeric
      ignored_next_char = "[%w%.]",
    },
  },
  {
    "L3MON4D3/LuaSnip",
    opts = {
      -- Show snippets related to the language
      -- in the current cursor position
      ft_func = function()
        return require("luasnip.extras.filetype_functions").from_pos_or_filetype()
      end,
    },
  },
  {
    "numToStr/Comment.nvim",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, require("custom.custom-plugins.overrides.nvim-tree").options)
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        file_ignore_patterns = { "node_modules", "%.git/", "%.lock$", "%-lock.json$", "%.direnv/" },
      },
    },
  },
  {
    "folke/which-key.nvim",
    config = function(_, opts)
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      dofile(vim.g.base46_cache .. "whichkey")
      require("which-key").setup(opts)
      require("custom.custom-plugins.overrides.whichkey").setup()
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {}, -- not an option from mason.nvim
    },
  },
  {
    "NvChad/nvim-colorizer.lua",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, require("custom.custom-plugins.overrides.colorizer").options)
    end,
  },

  -- custom
  {
    "echasnovski/mini.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("custom.custom-plugins.configs.mini").setup()
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
  -- {
  --   "levouh/tint.nvim",
  --   event = "VeryLazy",
  --   opts = function(_, opts)
  --     return require("custom.custom-plugins.configs.tint").options
  --   end,
  -- },
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
    init = function()
      require("core.utils").lazy_load "todo-comments.nvim"
    end,
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
      dofile(vim.g.base46_cache .. "trouble")
      require("trouble").setup(opts)
    end,
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {},
  },
  {
    "folke/zen-mode.nvim",
    cmd = { "ZenMode" },
    opts = function()
      return require("custom.custom-plugins.configs.zen-mode").options
    end,
  },
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      require("custom.custom-plugins.configs.dressing").init()
    end,
    opts = function()
      return require("custom.custom-plugins.configs.dressing").options
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
  -- {
  --   "nvim-neorg/neorg",
  --   lazy = false,
  --   build = ":Neorg sync-parsers",
  --   dependencies = { "nvim-neorg/neorg-telescope" },
  --   config = function()
  --     require("custom.custom-plugins.configs.neorg").setup()
  --   end,
  -- },
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
    "wochap/emmet-vim",
    event = "VeryLazy",
    init = function()
      g.user_emmet_leader_key = "<C-z>"
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
    url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git",
    init = function()
      require("custom.custom-plugins.configs.rainbow-delimeters").init()
    end,
    config = function() end,
  },
  {
    "kevinhwang91/nvim-ufo",
    event = "VeryLazy",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    config = function(_, opts)
      require("custom.custom-plugins.configs.ufo").setup()
    end,
  },
  {
    "luukvbaal/statuscol.nvim",
    event = "VeryLazy",
    opts = function()
      return require("custom.custom-plugins.configs.statuscol").options
    end,
  },
  {
    "NMAC427/guess-indent.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = function()
      return require("custom.custom-plugins.configs.flash").keys
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = function(_, opts)
      local flash = require("custom.utils.telescope").flash
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        mappings = { n = { s = flash }, i = { ["<c-s>"] = flash } },
      })
    end,
  }, -- integrate flash in telescope
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
  { "tpope/vim-abolish", event = "VeryLazy" }, -- Change word casing
  { "tpope/vim-repeat", event = "VeryLazy" }, -- Repeat vim-abolish

  -- LSP stuff
  {
    "kosayoda/nvim-lightbulb",
    enabled = false,
    event = "LspAttach",
    opts = {
      sign = {
        text = " ",
      },
      autocmd = {
        enabled = true,
        updatetime = -1,
      },
    },
  },
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    opts = {},
  },
  {
    "smjonas/inc-rename.nvim",
    opts = {
      input_buffer_type = "dressing",
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/neoconf.nvim",
        cmd = "Neoconf",
        config = function() end,
      },
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      servers = {
        bashls = {},
      },
      setup = {},
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "lsp")
      require("custom.custom-plugins.configs.lspconfig").config(opts)
    end,
  },

  -- Formatter
  {
    "nvimtools/none-ls.nvim",
    init = function()
      require("core.utils").lazy_load "none-ls.nvim"
    end,
    dependencies = {
      "mason.nvim",
      {
        "jay-babu/mason-null-ls.nvim",
        opts = {
          automatic_installation = true,
          handlers = {
            function() end,
          },
          ensure_installed = { "shellcheck", "shfmt" },
        },
      },
    },
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, require("custom.custom-plugins.configs.null-ls").options)
    end,
  },

  -- Debugger
  {
    "LiadOz/nvim-dap-repl-highlights",
    init = function()
      require("core.utils").lazy_load "nvim-dap-repl-highlights"
    end,
    opts = {},
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "mfussenegger/nvim-dap",
    init = function()
      require("core.utils").lazy_load "nvim-dap"
    end,
    dependencies = {
      "ofirgall/goto-breakpoints.nvim",
      {
        "rcarriga/nvim-dap-ui",
        config = function(_, opts)
          require("custom.custom-plugins.configs.nvim-dap-ui").setup(opts)
        end,
      },
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },
      "mason.nvim",
      {
        "jay-babu/mason-nvim-dap.nvim",
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
          automatic_installation = true,
          handlers = {
            function() end,
          },
          ensure_installed = {},
        },
      },
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "dap")
      require("custom.custom-plugins.configs.nvim-dap").setup(opts)
    end,
  },

  -- Lang
  {
    "fladson/vim-kitty",
    event = "VeryLazy",
    ft = "kitty",
  },

  -- Extras
  {
    "LazyVim/LazyVim",
    config = function() end,
  },
  { import = "custom.extras-lang.c" },
  { import = "custom.extras-lang.go" },
  { import = "custom.extras-lang.json" },
  { import = "custom.extras-lang.lua" },
  { import = "custom.extras-lang.nix" },
  { import = "custom.extras-lang.python" },
  { import = "custom.extras-lang.web" },
  { import = "custom.extras-lang.yaml" },
}

return plugins
