local hooks = require "core.hooks"

hooks.add("install_plugins", function(use)
   use {
      "mfussenegger/nvim-dap",
      opt = true,
      config = function()
         require("custom.plugins.configs.nvim-dap").setup()
      end,
      setup = function()
         require("core.utils").packer_lazy_load "nvim-dap"
      end,
   }

   use { 
      "rcarriga/nvim-dap-ui",
      after = "nvim-dap",
      config = function()
         require("dapui").setup()
      end,
   }

   use {
      "theHamsta/nvim-dap-virtual-text",
      after = "nvim-dap",
      config = function()
         require("custom.plugins.configs.others").nvim_dap_virtual_text()
      end,
   }

   use {
      "jose-elias-alvarez/null-ls.nvim",
      after = "nvim-lspconfig",
      config = function()
         require("custom.plugins.configs.null-ls").setup()
      end,
   }

   use {
      "dsznajder/vscode-es7-javascript-react-snippets",
      event = "InsertEnter",
   }

   use {
      "folke/todo-comments.nvim",
      cmd = { "TodoTrouble", "TodoTelescope" },
      requires = "nvim-lua/plenary.nvim",
      event = "BufReadPost",
      config = function()
         require("custom.plugins.configs.todo-comments").setup()
      end,
   }

   use {
      "windwp/nvim-spectre",
      opt = true,
      module = "spectre",
      wants = { "plenary.nvim", "popup.nvim" },
      requires = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
   }

   use { 
      "TimUntersberger/neogit",
      cmd = "Neogit",
      requires = { 
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
      },
      config = function()
         require("custom.plugins.configs.neogit").setup()
      end,
    }

   use {
      "sindrets/diffview.nvim",
      cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
      requires = "nvim-lua/plenary.nvim",
      config = function()
         require("custom.plugins.configs.diffview").setup()
      end,
   }

   use {
      "folke/which-key.nvim",
      event = "VimEnter",
      config = function()
         require("custom.plugins.configs.which-key").setup()
      end,
   }

   use {
      "windwp/nvim-ts-autotag",
      after = "nvim-treesitter",
   }

   use {
      "hrsh7th/cmp-cmdline",
      after = "cmp-buffer",
   }

   use {
      "elkowar/yuck.vim",
      event = "BufReadPre",
   }

   use {
      "szw/vim-maximizer",
      event = "BufRead",
   }

   use {
      "rhysd/conflict-marker.vim",
      event = "BufReadPost",
      setup = function()
         require("custom.plugins.configs.others").conflict_marker()
      end,
   }

   use {
      "mattn/emmet-vim",
      event = "InsertEnter",
      setup = function()
         require("custom.plugins.configs.others").emmet_vim()
      end,
   }

   use {
      "ThePrimeagen/vim-be-good",
      cmd = "VimBeGood",
      setup = function()
         require("core.utils").packer_lazy_load "vim-be-good"
      end,
   }

   use "nathom/filetype.nvim"

   use {
      "JoosepAlviste/nvim-ts-context-commentstring",
      after = "nvim-treesitter",
   }

   use "b0o/schemastore.nvim"

   use {
      "blackCauldron7/surround.nvim",
      event = "BufReadPre",
      config = function()
         require"surround".setup {mappings_style = "surround"}
      end,
   }

   use {
      "folke/trouble.nvim",
      cmd = { "TroubleToggle", "Trouble" },
      event = "BufReadPre",
      requires = "kyazdani42/nvim-web-devicons",
      config = function()
         require("custom.plugins.configs.others").trouble_nvim()
      end
   }

   use {
      "ThePrimeagen/harpoon",
      config = function()
         -- require"surround".setup {mappings_style = "surround"}
      end,
   }

   use {
      "ThePrimeagen/refactoring.nvim",
      requires = {
         { "nvim-lua/plenary.nvim" },
         { "nvim-treesitter/nvim-treesitter" },
      },
      config = function()
         require("custom.plugins.configs.others").refactoring()
      end
   }

   -- This is needed to fix lsp doc highlight
   use "antoinemadec/FixCursorHold.nvim"

   use {
      "tweekmonster/startuptime.vim",
      cmd = "StartupTime"
   }

   -- use "dstein64/nvim-scrollview"
end)
