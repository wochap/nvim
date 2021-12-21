local hooks = require "core.hooks"

hooks.add("install_plugins", function(use)
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
      end
   }

   use { 
      "TimUntersberger/neogit", 
      requires = { 
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
      },
      config = function()
         require("custom.plugins.configs.neogit").setup()
      end
    }

   use {
      "sindrets/diffview.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = function()
         require("custom.plugins.configs.diffview").setup()
      end
   }

   use {
      "folke/which-key.nvim",
      config = function()
         require("custom.plugins.configs.which-key").setup()
      end
   }

   use {
      "windwp/nvim-ts-autotag",
      after = "nvim-treesitter",
   }

   use {
      "hrsh7th/cmp-cmdline",
      after = "cmp-buffer",
   }

   use "ThePrimeagen/vim-be-good"

   use "nathom/filetype.nvim"

   use {
      "JoosepAlviste/nvim-ts-context-commentstring",
      after = "nvim-treesitter",
   }

   -- use "folke/tokyonight.nvim"

   -- use "dstein64/nvim-scrollview"

   -- use "tversteeg/registers.nvim"
end)
