local g = vim.g

local plugins = {
  { "nvim-lua/popup.nvim" },

  -- nvchad
  {
    -- NOTE: it causes flickering when indenting lines
    "lukas-reineke/indent-blankline.nvim",
    -- enabled = false,
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
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable "make" == 1,
        config = function()
          local Util = require "lazyvim.util"
          Util.on_load("telescope.nvim", function()
            require("telescope").load_extension "fzf"
          end)
        end,
      },
    },
    opts = {
      defaults = {
        file_ignore_patterns = { "node_modules", "%.git/", "%.lock$", "%-lock.json$", "%.direnv/" },
      },
      pickers = {
        oldfiles = {
          cwd_only = true,
        },
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
    "b0o/incline.nvim",
    event = "VeryLazy",
    opts = function()
      return require("custom.custom-plugins.configs.incline").options
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
    lazy = false,
    dependencies = {
      "kevinhwang91/promise-async",
    },
    config = function(_, opts)
      require("custom.custom-plugins.configs.ufo").setup()
    end,
  },
  {
    "luukvbaal/statuscol.nvim",
    lazy = false,
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
  {
    "mrjones2014/smart-splits.nvim",
    opts = {
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

  -- LSP, pull config from LazyVim
  -- https://www.lazyvim.org/plugins/lsp
  -- the following opts for nvim-lspconfig are managed by LazyVim:
  -- diagnostics, inlay_hints, capabilities, format, servers and setup
  -- LazyVim adds keymaps to buffers with LSP clients attached
  -- LazyVim installs any LSP server with Mason
  -- LazyVim installs neoconf
  -- NvChad lspconfig keymaps are ignored
  {
    "LazyVim/LazyVim",
    version = false,
    commit = "68ff818a5bb7549f90b05e412b76fe448f605ffb",
    config = function() end,
  },
  { import = "custom.custom-plugins.external.lazyvim_plugins_lsp" },
  { "folke/neodev.nvim", enabled = false }, -- disable neodev.nvim added by LazyVim
  {
    "neovim/nvim-lspconfig",
    event = false,
    init = function()
      require("custom.custom-plugins.overrides.lspconfig").init()
    end,
    opts = function(_, opts)
      opts.servers = {} -- remove lua_ls added by LazyVim
      return vim.tbl_deep_extend("force", opts, require("custom.custom-plugins.overrides.lspconfig").options)
    end,
    config = function(_, opts)
      require("custom.custom-plugins.overrides.lspconfig").setup(_, opts)
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    keys = function()
      return {}
    end,
    opts = function(_, opts)
      -- remove stylua and shfmt added by LazyVim
      local nvchad_opts = require "plugins.configs.mason"
      nvchad_opts.ensure_installed = {}
      return nvchad_opts
    end,
    config = function(_, opts)
      require("custom.custom-plugins.overrides.mason").setup(opts)
    end,
  },

  -- Formatter, pull config from LazyVim
  -- https://www.lazyvim.org/plugins/formatting
  { "LazyVim/LazyVim" },
  { import = "lazyvim.plugins.formatting" },
  {
    "stevearc/conform.nvim",
    keys = { { "<leader>cF", false, mode = { "n", "v" } } },
    opts = function(_, opts)
      opts.formatters_by_ft = {} -- remove lua, fish and sh added by LazyVim
      return opts
    end,
  },

  -- Linter, pull config from LazyVim
  -- https://www.lazyvim.org/plugins/linting
  -- the following opts for nvim-lint are managed by LazyVim:
  -- linters
  { "LazyVim/LazyVim" },
  { import = "lazyvim.plugins.linting" },
  {
    "mfussenegger/nvim-lint",
    event = false,
    init = function()
      require("core.utils").lazy_load "nvim-lint"
    end,
    opts = function(_, opts)
      opts.linters_by_ft = {} -- remove fish added by LazyVim
      return opts
    end,
  },

  -- Debugger
  {
    "LiadOz/nvim-dap-repl-highlights",
    init = function()
      require("core.utils").lazy_load "nvim-dap-repl-highlights"
    end,
    build = ":TSInstall dap_repl",
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
  { "LazyVim/LazyVim" },
  { import = "custom.extras-lang.c" },
  { import = "custom.extras-lang.go" },
  { import = "custom.extras-lang.lua" },
  { import = "custom.extras-lang.nix" },
  { import = "custom.extras-lang.python" },
  { import = "custom.extras-lang.web" },
  { import = "custom.extras-lang.shell" },
  { import = "custom.extras-lang.zig" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.yaml" },
}

return plugins
