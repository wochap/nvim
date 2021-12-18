local hooks = require "core.hooks"

hooks.add("install_plugins", function(use)
   use {
      "jose-elias-alvarez/null-ls.nvim",
      after = "nvim-lspconfig",
      config = function()
         require("custom.plugins.confs.null-ls").setup()
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
         require("custom.plugins.confs.todo-comments").setup()
      end
   }

   use { 
      "TimUntersberger/neogit", 
      requires = { 
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
      },
      config = function()
         require("custom.plugins.confs.neogit").setup()
      end
    }

   use {
      "sindrets/diffview.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = function()
         require("custom.plugins.confs.diffview").setup()
      end
   }

   use {
      "folke/which-key.nvim",
      config = function()
         require("custom.plugins.confs.which-key").setup()
      end
   }

   use {
      "windwp/nvim-ts-autotag",
      after = "nvim-treesitter",
      config = function()
         require("nvim-ts-autotag").setup()
      end,
   }

   use "ThePrimeagen/vim-be-good"

   use "nathom/filetype.nvim"

   -- use "folke/tokyonight.nvim"

   -- use "dstein64/nvim-scrollview"

   -- use "tversteeg/registers.nvim"
end)
