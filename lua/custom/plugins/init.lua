-- local commit = {
--    vscode-es7-javascript-react-snippets = "6bc8ec96c24beea7e54f21c9fe2476e73d669cd7",
-- };

return {
   -- Dap
   {
      "mfussenegger/nvim-dap",
      opt = true,
      module = "dap",
      config = function()
         require("custom.plugins.configs.nvim-dap").setup()
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
         require("nvim-dap-virtual-text").setup()
      end,
   },

   -- LSP stuff
   {
      "jose-elias-alvarez/null-ls.nvim",
      requires = "nvim-lua/plenary.nvim",
      wants = "plenary.nvim",
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
   { "b0o/schemastore.nvim" },

   -- treesitter
   {
      "nvim-treesitter/nvim-treesitter",
      requires = {
         { "RRethy/nvim-treesitter-textsubjects" },
         { "windwp/nvim-ts-autotag" },
         { "JoosepAlviste/nvim-ts-context-commentstring" },
      },
      event = "BufRead",
      config = function()
         require "custom.plugins.overrides.treesitter"
      end,
   },

   -- snippets
   {
      "dsznajder/vscode-es7-javascript-react-snippets",
      run = "yarn install --frozen-lockfile && yarn compile",
      commit = "6bc8ec96c24beea7e54f21c9fe2476e73d669cd7",
      module = "cmp_nvim_lsp",
      event = "InsertEnter",
   },
   {
      "rafamadriz/friendly-snippets",
      after = "vscode-es7-javascript-react-snippets",
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
      "hrsh7th/cmp-cmdline",
      after = "cmp-path",
      config = function()
         require("custom.plugins.configs.others").cmp_cmdline()
      end,
   },

   -- langs support
   {
      "elkowar/yuck.vim",
      ft = "yuck",
   },

   -- misc
   {
      "szw/vim-maximizer",
      event = "BufRead",
   },
   {
      "folke/which-key.nvim",
      event = "VimEnter",
      config = function()
         require("custom.plugins.configs.which-key").setup()
      end,
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
      opt = true,
      module = "harpoon",
   },

   {
      "ThePrimeagen/refactoring.nvim",
      opt = true,
      module = "refactoring",
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

   {
      "tweekmonster/startuptime.vim",
      cmd = "StartupTime",
   },

   -- { "dstein64/nvim-scrollview" },
}
