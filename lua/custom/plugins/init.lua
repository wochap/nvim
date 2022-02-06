return {
   {
      "mfussenegger/nvim-dap",
      opt = true,
      config = function()
         require("custom.plugins.configs.nvim-dap").setup()
      end,
      setup = function()
         require("core.utils").packer_lazy_load "nvim-dap"
      end,
   },

   {
      "rcarriga/nvim-dap-ui",
      after = "nvim-dap",
      config = function()
         require("dapui").setup()
      end,
   },

   {
      "theHamsta/nvim-dap-virtual-text",
      after = "nvim-dap",
      config = function()
         require("custom.plugins.configs.others").nvim_dap_virtual_text()
      end,
   },

   {
      "jose-elias-alvarez/null-ls.nvim",
      commit = "92cd2951160442039744545bb76ede43480f6807",
      after = "nvim-lspconfig",
      config = function()
         require("custom.plugins.configs.null-ls").setup()
      end,
   },

   {
      "tami5/lspsaga.nvim",
      after = "nvim-lspconfig",
      config = function()
         require("custom.plugins.configs.lspsaga").setup()
      end,
   },

   {
      "jose-elias-alvarez/nvim-lsp-ts-utils",
      after = "nvim-lspconfig",
   },

   {
      "RRethy/nvim-treesitter-textsubjects",
      after = "nvim-treesitter",
   },

   {
      "dsznajder/vscode-es7-javascript-react-snippets",
      event = "InsertEnter",
   },

   {
      "folke/todo-comments.nvim",
      cmd = { "TodoTrouble", "TodoTelescope" },
      requires = "nvim-lua/plenary.nvim",
      wants = { "plenary.nvim" },
      event = "BufReadPost",
      config = function()
         require("custom.plugins.configs.todo-comments").setup()
      end,
   },

   {
      "windwp/nvim-spectre",
      opt = true,
      module = "spectre",
      wants = { "plenary.nvim", "popup.nvim" },
      requires = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
      config = function()
         require("custom.plugins.configs.others").nvim_spectre()
      end,
   },

   {
      "TimUntersberger/neogit",
      opt = true,
      cmd = "Neogit",
      requires = {
         "nvim-lua/plenary.nvim",
         "sindrets/diffview.nvim",
      },
      wants = {
         "plenary.nvim",
         "diffview.nvim",
      },
      config = function()
         require("custom.plugins.configs.neogit").setup()
      end,
   },

   {
      "sindrets/diffview.nvim",
      opt = true,
      after = "neogit",
      cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
      requires = "nvim-lua/plenary.nvim",
      wants = "plenary.nvim",
      config = function()
         require("custom.plugins.configs.diffview").setup()
      end,
   },

   {
      "folke/which-key.nvim",
      event = "VimEnter",
      config = function()
         require("custom.plugins.configs.which-key").setup()
      end,
   },

   {
      "windwp/nvim-ts-autotag",
      after = "nvim-treesitter",
   },

   {
      "hrsh7th/cmp-cmdline",
      after = "cmp-path",
      config = function()
         require("custom.plugins.configs.others").cmp_cmdline()
      end,
   },

   {
      "elkowar/yuck.vim",
      event = "VimEnter",
   },

   {
      "szw/vim-maximizer",
      event = "BufRead",
   },

   {
      "rhysd/conflict-marker.vim",
      event = "BufReadPost",
      setup = function()
         require("custom.plugins.configs.others").conflict_marker()
      end,
   },

   {
      "mattn/emmet-vim",
      event = "InsertEnter",
      setup = function()
         require("custom.plugins.configs.others").emmet_vim()
      end,
   },

   {
      "ThePrimeagen/vim-be-good",
      opt = true,
      cmd = "VimBeGood",
      setup = function()
         require("core.utils").packer_lazy_load "vim-be-good"
      end,
   },

   {
      "nathom/filetype.nvim",
      config = function()
         require("custom.plugins.configs.others").filetype()
      end,
   },

   {
      "JoosepAlviste/nvim-ts-context-commentstring",
      after = "nvim-treesitter",
   },

   { "b0o/schemastore.nvim" },

   { "tpope/vim-surround" },

   -- following macro deletes lines
   -- 0vt:s"kd
   -- {
   --    "blackCauldron7/surround.nvim",
   --    event = "BufReadPre",
   --    config = function()
   --       require("surround").setup { mappings_style = "surround", map_insert_mode = false }
   --    end,
   -- }

   {
      "folke/trouble.nvim",
      opt = true,
      module = "trouble",
      cmd = { "TroubleToggle", "Trouble", "TodoTrouble", "TodoTelescope" },
      requires = "kyazdani42/nvim-web-devicons",
      wants = "nvim-web-devicons",
      config = function()
         require("custom.plugins.configs.others").trouble_nvim()
      end,
   },

   {
      "ThePrimeagen/harpoon",
   },

   {
      "ThePrimeagen/refactoring.nvim",
      requires = {
         { "nvim-lua/plenary.nvim" },
         { "nvim-treesitter/nvim-treesitter" },
      },
      config = function()
         require("custom.plugins.configs.others").refactoring()
      end,
   },

   {
      "nvim-neorg/neorg",
      requires = "nvim-lua/plenary.nvim",
      wants = "plenary.nvim",
      config = function()
         require("custom.plugins.configs.neorg").setup()
      end,
   },

   -- This is needed to fix lsp doc highlight
   { "antoinemadec/FixCursorHold.nvim" },

   { "editorconfig/editorconfig-vim" },

   -- Change word casing
   { "tpope/vim-abolish" },

   { "tpope/vim-repeat" },

   -- Switch words
   { "tommcdo/vim-exchange" },

   -- Align text vertically
   { "tommcdo/vim-lion" },

   -- Better pasting
   { "sickill/vim-pasta" },

   -- Smooth scroll
   -- { "psliwka/vim-smoothie" },

   {
      "tweekmonster/startuptime.vim",
      cmd = "StartupTime",
   },

   -- { "dstein64/nvim-scrollview" },
}
