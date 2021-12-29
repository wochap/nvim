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
      requires = "nvim-lua/plenary.nvim",
      config = function()
         require("custom.plugins.configs.todo-comments").setup()
      end,
   }

   use { 
      "TimUntersberger/neogit",
      opt = true,
      requires = { 
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
      },
      config = function()
         require("custom.plugins.configs.neogit").setup()
      end,
      setup = function()
         require("core.utils").packer_lazy_load "neogit"
      end,
    }

   use {
      "sindrets/diffview.nvim",
      opt = true,
      requires = "nvim-lua/plenary.nvim",
      config = function()
         require("custom.plugins.configs.diffview").setup()
      end,
      setup = function()
         require("core.utils").packer_lazy_load "diffview.nvim"
      end,
   }

   use {
      "folke/which-key.nvim",
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
      event = "BufRead",
   }

   use "szw/vim-maximizer"

   use {
      "rhysd/conflict-marker.vim",
      setup = function()
         require("custom.plugins.configs.others").conflict_marker()
      end,
   }

   use {
      "mattn/emmet-vim",
      setup = function()
         require("custom.plugins.configs.others").emmet_vim()
      end,
   }

   use {
      "ThePrimeagen/vim-be-good",
      opt = true,
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
      config = function()
         require"surround".setup {mappings_style = "surround"}
      end
   }

   -- use "dstein64/nvim-scrollview"
end)
