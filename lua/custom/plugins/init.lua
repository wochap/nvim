local plugin_settings = require("core.utils").load_config().plugins
local commit = {
   close_buffer = "3acbcad1211572342632a6c0151f839e7dead27f",
   cmp_cmdline = "29ca81a6f0f288e6311b3377d9d9684d22eac2ec",
   conflict_marker = "22b6133116795ea8fb6705ddca981aa8faecedda",
   diffview = "eef47458679a922ef101c1e4c07fb7b36d701385",
   emmet_vim = "def5d57a1ae5afb1b96ebe83c4652d1c03640f4d",
   filetype = "4d2c0d4488a05f9b0d18a7e2004c0182e350bb45",
   friendly_snippets = "2e575549910571ff5abb6b02178c69ad760a4e00",
   harpoon = "d035ef263a75029b0351f2be3708ec2829e2a3df",
   lazygit = "9bceeab97668935cc6b91ab5190167d9771b5210",
   lspsaga = "73c89a000429e58dcdb3b13cecc4148b5f2929ae",
   neogit = "c8a320359cea86834f62225849a75632258a7503",
   neorg = "27578af8581ca109ac51f0f5d215d12bf6933be1",
   null_ls = "e8a666829a3d803844f24daa4932e4f5fe76cbeb",
   nvim_dap = "ee39d5d570d07161e16eb73054c295c6561eb2b4",
   nvim_dap_ui = "ae3b003af6c6646832dfe704a1137fd9110ab064",
   nvim_dap_virtual_text = "fb176ca8cf666331fcfa75b7dcc238116d66f801",
   nvim_lsp_ts_utils = "64d233a8859e27139c55472248147114e0be1652",
   nvim_spectre = "9842b5fe987fb2c5a4ec4d42f8dbcdd04a047d4d",
   nvim_treesitter = "1f0771153542608a29cd06bacf2978adc40d1265",
   nvim_treesitter_textsubjects = "795e577fd69c2427158cad97d77d54ae5c6269ac",
   persistence = "77cf5a6ee162013b97237ff25450080401849f85",
   plenary = "e86dc9b11241ff69ece50c15a5cdd49d20d4c27c",
   refactoring = "23340bf6b19ab50504165462676f87a3e1bd4870",
   shade = "4286b5abc47d62d0c9ffb22a4f388b7bf2ac2461",
   startuptime = "dfa57f522d6f61793fe5fea65bca7484751b8ca2",
   todo_comments = "98b1ebf198836bdc226c0562b9f906584e6c400e",
   trouble = "20469be985143d024c460d95326ebeff9971d714",
   vim_be_good = "bc499a06c14c729b22a6cc7e730a9fbc44d4e737",
   vim_maximizer = "2e54952fe91e140a2e69f35f22131219fcd9c5f1",
   vim_visual_multi = "e20908963d9b0114e5da1eacbc516e4b09cf5803",
   vscode_es7_javascript_react_snippets = "6bc8ec96c24beea7e54f21c9fe2476e73d669cd7",
   which_key = "28d2bd129575b5e9ebddd88506601290bb2bb221",
   yuck = "6dc3da77c53820c32648cf67cbdbdfb6994f4e08",
}

return {
   -- Dap
   {
      "mfussenegger/nvim-dap",
      commit = commit.nvim_dap,
      opt = true,
      module = "dap",
      config = function()
         require("custom.plugins.configs.nvim-dap").setup()
      end,
   },
   {
      "rcarriga/nvim-dap-ui",
      commit = commit.nvim_dap_ui,
      after = "nvim-dap",
      config = function()
         require("dapui").setup()
      end,
   },
   {
      "theHamsta/nvim-dap-virtual-text",
      commit = commit.nvim_dap_virtual_text,
      after = "nvim-dap",
      config = function()
         require("nvim-dap-virtual-text").setup()
      end,
   },

   -- LSP stuff
   {
      "jose-elias-alvarez/null-ls.nvim",
      commit = commit.null_ls,
      requires = "nvim-lua/plenary.nvim",
      wants = "plenary.nvim",
      after = "nvim-lspconfig",
      config = function()
         require("custom.plugins.configs.null-ls").setup()
      end,
   },
   {
      "tami5/lspsaga.nvim",
      commit = commit.lspsaga,
      after = "nvim-lspconfig",
      config = function()
         require("custom.plugins.configs.lspsaga").setup()
      end,
   },
   {
      "jose-elias-alvarez/nvim-lsp-ts-utils",
      commit = commit.nvim_lsp_ts_utils,
      after = "nvim-lspconfig",
   },
   { "b0o/schemastore.nvim" },

   -- treesitter
   {
      "nvim-treesitter/nvim-treesitter",
      commit = commit.nvim_treesitter,
      run = ":TSUpdate",
      requires = {
         { "RRethy/nvim-treesitter-textsubjects" },
         { "windwp/nvim-ts-autotag", disable = not plugin_settings.status.autotag },
         { "JoosepAlviste/nvim-ts-context-commentstring" },
      },
      event = { "BufRead", "BufNewFile" },
      config = function()
         require "custom.plugins.overrides.treesitter"
      end,
   },
   {
      "nvim-treesitter/playground",
      run = ":TSInstall query",
      cmd = "TSPlaygroundToggle",
   },

   -- snippets
   {
      "dsznajder/vscode-es7-javascript-react-snippets",
      commit = commit.vscode_es7_javascript_react_snippets,
      run = "yarn install --frozen-lockfile && yarn compile",
      module = "cmp_nvim_lsp",
      -- event = "InsertEnter",
      event = "VimEnter",
   },
   {
      "rafamadriz/friendly-snippets",
      commit = commit.friendly_snippets,
      after = "vscode-es7-javascript-react-snippets",
   },

   {
      "windwp/nvim-spectre",
      commit = commit.nvim_spectre,
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
      commit = commit.neogit,
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
      commit = commit.diffview,
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
      "kdheepak/lazygit.nvim",
      commit = commit.lazygit,
      cmd = { "LazyGit", "LazyGitConfig", "LazyGitFilter" },
   },

   {
      "hrsh7th/cmp-cmdline",
      commit = commit.cmp_cmdline,
      after = "cmp-path",
      config = function()
         require("custom.plugins.configs.others").cmp_cmdline()
      end,
   },

   -- langs support
   {
      "elkowar/yuck.vim",
      commit = commit.yuck,
      ft = "yuck",
   },

   -- misc
   {
      "szw/vim-maximizer",
      commit = commit.vim_maximizer,
      event = "BufRead",
   },
   {
      "folke/which-key.nvim",
      commit = commit.which_key,
      event = "VimEnter",
      config = function()
         require("custom.plugins.configs.which-key").setup()
      end,
   },
   {
      "sunjon/shade.nvim",
      disable = true,
      commit = commit.shade,
      config = function()
         require("custom.plugins.configs.others").shade()
      end,
   },

   -- TODO: fix exa icons
   -- {
   --    "yamatsum/nvim-nonicons",
   --    after = "nvim-base16.lua",
   --    requires = { { "kyazdani42/nvim-web-devicons" } },
   --    config = override_req("nvim_web_devicons", "plugins.configs.icons", "setup"),
   -- },

   {
      "kazhala/close-buffers.nvim",
      commit = commit.close_buffer,
      module = "close_buffers",
      cmd = { "BDelete", "BWipeout" },
   },

   {
      "folke/persistence.nvim",
      commit = commit.persistence,
      event = "BufReadPre", -- this will only start session saving when an actual file was opened
      module = "persistence",
      config = function()
         require("persistence").setup()
      end,
   },

   {
      "rhysd/conflict-marker.vim",
      commit = commit.conflict_marker,
      event = "BufReadPost",
      setup = function()
         require("custom.plugins.configs.others").conflict_marker()
      end,
   },

   {
      "wochap/emmet-vim",
      -- "mattn/emmet-vim",
      -- commit = "0f247f9dee4d23cca6650129dac4c0112fe2a09e",
      keys = {
         { "i", "<C-y>" },
      },
      setup = function()
         require("custom.plugins.configs.others").emmet_vim()
      end,
   },

   {
      "mg979/vim-visual-multi",
      commit = commit.vim_visual_multi,
      keys = {
         { "n", "<C-n>" },
         { "n", "<S-C-Down>" },
         { "n", "<S-C-Up>" },
         { "v", "<C-n>" },
      },
      setup = function()
         require("custom.plugins.configs.others").vim_visual_multi()
      end,
   },

   {
      "ThePrimeagen/vim-be-good",
      commit = commit.vim_be_good,
      opt = true,
      cmd = "VimBeGood",
      setup = function()
         require("core.utils").packer_lazy_load "vim-be-good"
      end,
   },

   {
      "nathom/filetype.nvim",
      commit = commit.filetype,
      config = function()
         require("custom.plugins.configs.others").filetype()
      end,
   },

   { "tpope/vim-surround" },
   -- following macro deletes lines
   -- 0vt:s"??kd
   -- {
   --    "blackCauldron7/surround.nvim",
   --    event = "BufReadPre",
   --    config = function()
   --       require("surround").setup { mappings_style = "surround", map_insert_mode = false }
   --    end,
   -- }

   {
      "folke/todo-comments.nvim",
      commit = commit.todo_comments,
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
      commit = commit.trouble,
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
      commit = commit.harpoon,
      opt = true,
      module = "harpoon",
   },

   {
      "ThePrimeagen/refactoring.nvim",
      commit = commit.refactoring,
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
      commit = commit.neorg,
      requires = { "nvim-lua/plenary.nvim", "nvim-neorg/neorg-telescope" },
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
   -- { "sickill/vim-pasta" },

   {
      "tweekmonster/startuptime.vim",
      commit = commit.startuptime,
      cmd = "StartupTime",
   },

   -- { "dstein64/nvim-scrollview" },
}
