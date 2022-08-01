local commit = {
   -- nvchad
   plenary = "986ad71ae930c7d96e812734540511b4ca838aa2",
   nvchad_extensions = "fd46bb0ed0eab9584e75742bf18d81467b1b6faa",
   nvchad_base64 = "f7340d7245eb5a6f47bc2c3df50a3c130ba04ece",
   nvchad_ui = "21e627a91f9607274abd2bd3d75c516070bb20d2",
   nvchad_nvterm = "1317d6238f089e117e3ed98b3cecc37cc4364675",
   web_devicons = "2d02a56189e2bde11edd4712fea16f08a6656944",
   indent_blankline = "c15bbe9f23d88b5c0b4ca45a446e01a0a3913707",
   nvchad_colorizer = "fbe4a8d12ec1238ab1552361f64c852debd9a33f",
   treesitter = "6289410c7a4715d6e7743c4d81cf5d262e90951e",
   gitsigns = "8b817e76b6399634f3f49e682d6e409844241858",
   mason = "2f7a2c317f14a2d0e8a5ad4b583eeeea9f7deb7d",
   lspconfig = "ba25b747a3cff70c1532c2f28fcc912cf7b938ea",
   friendly_snippets = "8c95fecb3960eb0d3d3b9bd582d49a613bd7a7fb",
   cmp = "706371f1300e7c0acb98b346f80dad2dd9b5f679",
   luasnip = "53e812a6f51c9d567c98215733100f0169bcc20a",
   cmp_luasnip = "a9de941bcbda508d0a45d28ae366bb3f08db2e36",
   cmp_lua = "d276254e7198ab7d00f117e88e223b4bd8c02d21",
   cmp_lsp = "affe808a5c56b71630f17aa7c38e15c59fd648a8",
   cmp_buffer = "62fc67a2b0205136bc3e312664624ba2ab4a9323",
   cmp_path = "447c87cdd6e6d6a1d2488b1d43108bfa217f56e1",
   autopairs = "972a7977e759733dd6721af7bcda7a67e40c010e",
   alpha = "d688f46090a582be8f9d7b70b4cf999b780e993d",
   comment = "78ab4e9785b6da9b7a539df3bd6f70300dc9482b",
   tree = "7fcb48c852b9d58709169a4dc1ec634fa9ea56f9",
   telescope = "b5833a682c511885887373aad76272ad70f7b3c2",
   which_key = "bd4411a2ed4dd8bb69c125e339d837028a6eea71",

   -- custom
   lazygit = "9bceeab97668935cc6b91ab5190167d9771b5210",
   close_buffer = "3acbcad1211572342632a6c0151f839e7dead27f",
   trouble = "da61737d860ddc12f78e638152834487eabf0ee5",
   editorconfig = "764577498694a1035c7d592149458c5799db69d4",
   vim_maximizer = "2e54952fe91e140a2e69f35f22131219fcd9c5f1",
   diffview = "a45163cb9ee65742cf26b940c2b24cc652f295c9",
   todo_comments = "98b1ebf198836bdc226c0562b9f906584e6c400e",
   harpoon = "d035ef263a75029b0351f2be3708ec2829e2a3df",
   nvim_spectre = "9842b5fe987fb2c5a4ec4d42f8dbcdd04a047d4d",
   nvim_dap = "ee39d5d570d07161e16eb73054c295c6561eb2b4",
   nvim_dap_ui = "ae3b003af6c6646832dfe704a1137fd9110ab064",
   nvim_dap_virtual_text = "fb176ca8cf666331fcfa75b7dcc238116d66f801",
   nvim_lsp_ts_utils = "64d233a8859e27139c55472248147114e0be1652",
   wochap_emmet = "4b41cf2bb003b1e758d7073d897c5543ea88aa0d",
   conflict_marker = "22b6133116795ea8fb6705ddca981aa8faecedda",
   vscode_es7_javascript_react_snippets = "6bc8ec96c24beea7e54f21c9fe2476e73d669cd7",
   schemastore = "65e845c491db027f93648dbf6241bc73e68a44d0",
   null_ls = "e8a666829a3d803844f24daa4932e4f5fe76cbeb",
   neorg = "5dc942ce225f80639a9a37fe39f488b6c6cbb791",

   -- legacy
   cmp_cmdline = "29ca81a6f0f288e6311b3377d9d9684d22eac2ec",
   filetype = "4d2c0d4488a05f9b0d18a7e2004c0182e350bb45",
   lspsaga = "73c89a000429e58dcdb3b13cecc4148b5f2929ae",
   nvim_treesitter_textsubjects = "795e577fd69c2427158cad97d77d54ae5c6269ac",
   persistence = "77cf5a6ee162013b97237ff25450080401849f85",
   refactoring = "23340bf6b19ab50504165462676f87a3e1bd4870",
   shade = "4286b5abc47d62d0c9ffb22a4f388b7bf2ac2461",
   startuptime = "dfa57f522d6f61793fe5fea65bca7484751b8ca2",
   vim_be_good = "bc499a06c14c729b22a6cc7e730a9fbc44d4e737",
   vim_visual_multi = "e20908963d9b0114e5da1eacbc516e4b09cf5803",
   yuck = "6dc3da77c53820c32648cf67cbdbdfb6994f4e08",
}

local M = {}

M.user = {
   -- nvchad
   ["nvim-lua/plenary.nvim"] = { commit = commit.plenary },
   ["NvChad/extensions"] = { commit = commit.nvchad_extensions },
   ["NvChad/base46"] = { commit = commit.nvchad_base64 },
   ["NvChad/ui"] = { commit = commit.nvchad_ui },
   ["NvChad/nvterm"] = { commit = commit.nvchad_nvterm },
   ["kyazdani42/nvim-web-devicons"] = { commit = commit.web_devicons },
   ["lukas-reineke/indent-blankline.nvim"] = { commit = commit.indent_blankline },
   ["NvChad/nvim-colorizer.lua"] = { commit = commit.nvchad_colorizer },
   ["nvim-treesitter/nvim-treesitter"] = {
      commit = commit.treesitter,
      requires = {
         { "JoosepAlviste/nvim-ts-context-commentstring" },
      },
   },
   ["lewis6991/gitsigns.nvim"] = { commit = commit.gitsigns },
   ["williamboman/mason.nvim"] = { commit = commit.mason },
   ["neovim/nvim-lspconfig"] = {
      commit = commit.lspconfig,
      config = function()
         require "plugins.configs.lspconfig"
         require "custom.plugins.configs.lspconfig"
      end,
   },
   ["rafamadriz/friendly-snippets"] = {
      commit = commit.friendly_snippets,
      -- event = "InsertEnter",
      event = nil,
      after = "vscode-es7-javascript-react-snippets",
   },
   ["hrsh7th/nvim-cmp"] = { commit = commit.cmp },
   ["L3MON4D3/LuaSnip"] = { commit = commit.luasnip },
   ["saadparwaiz1/cmp_luasnip"] = { commit = commit.cmp_luasnip },
   ["hrsh7th/cmp-nvim-lua"] = { commit = commit.cmp_lua },
   ["hrsh7th/cmp-nvim-lsp"] = { commit = commit.cmp_lsp },
   ["hrsh7th/cmp-buffer"] = { commit = commit.cmp_buffer },
   ["hrsh7th/cmp-path"] = { commit = commit.cmp_path },
   ["windwp/nvim-autopairs"] = { commit = commit.autopairs },
   ["goolord/alpha-nvim"] = { commit = commit.alpha },
   ["numToStr/Comment.nvim"] = { commit = commit.comment },
   ["kyazdani42/nvim-tree.lua"] = { commit = commit.tree },
   ["nvim-telescope/telescope.nvim"] = {
      commit = commit.telescope,
      ft = { "norg" },
      module = { "telescope", "telescope.builtin", "telescope.action" },
      cmd = "Telescope",
   },
   ["folke/which-key.nvim"] = { commit = commit.which_key },

   -- custom
   ["dsznajder/vscode-es7-javascript-react-snippets"] = {
      commit = commit.vscode_es7_javascript_react_snippets,
      run = "yarn install --frozen-lockfile && yarn compile",
      module = "cmp_nvim_lsp",
      event = "VimEnter",
   },

   ["kdheepak/lazygit.nvim"] = {
      commit = commit.lazygit,
      opt = true,
      cmd = { "LazyGit", "LazyGitConfig", "LazyGitFilter" },
   },

   ["kazhala/close-buffers.nvim"] = {
      commit = commit.close_buffer,
      module = "close_buffers",
   },

   ["folke/todo-comments.nvim"] = {
      commit = commit.todo_comments,
      cmd = { "TodoTrouble", "TodoTelescope" },
      requires = "nvim-lua/plenary.nvim",
      wants = { "plenary.nvim" },
      event = "BufReadPost",
      config = function()
         require("custom.plugins.configs.todo-comments").setup()
      end,
   },
   ["folke/trouble.nvim"] = {
      commit = commit.trouble,
      opt = true,
      cmd = { "TroubleToggle", "Trouble", "TodoTrouble", "TodoTelescope" },
      requires = "kyazdani42/nvim-web-devicons",
      wants = "nvim-web-devicons",
      config = function()
         require("custom.plugins.configs.others").trouble_nvim()
      end,
   },

   -- LSP stuff
   ["jose-elias-alvarez/null-ls.nvim"] = {
      commit = commit.null_ls,
      requires = "nvim-lua/plenary.nvim",
      wants = "plenary.nvim",
      after = "nvim-lspconfig",
      config = function()
         require("custom.plugins.configs.null-ls").setup()
      end,
   },
   ["jose-elias-alvarez/nvim-lsp-ts-utils"] = {
      commit = commit.nvim_lsp_ts_utils,
      after = "nvim-lspconfig",
   },
   ["b0o/schemastore.nvim"] = {
      commit = commit.schemastore,
   },

   ["gpanders/editorconfig.nvim"] = {
      commit = commit.editorconfig,
   },

   ["folke/persistence.nvim"] = {
      commit = commit.persistence,
      event = "BufReadPre", -- this will only start session saving when an actual file was opened
      module = "persistence",
      config = function()
         require("persistence").setup()
      end,
   },

   ["sindrets/diffview.nvim"] = {
      commit = commit.diffview,
      opt = true,
      cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
      requires = "nvim-lua/plenary.nvim",
      wants = "plenary.nvim",
      config = function()
         require("custom.plugins.configs.diffview").setup()
      end,
   },

   ["ThePrimeagen/harpoon"] = {
      commit = commit.harpoon,
      opt = true,
      module = "harpoon",
   },

   ["nvim-neorg/neorg"] = {
      commit = commit.neorg,
      -- run = ":Neorg sync-parsers",
      requires = { "nvim-lua/plenary.nvim", "nvim-neorg/neorg-telescope" },
      wants = { "plenary.nvim", "neorg-telescope" },
      config = function()
         require("custom.plugins.configs.neorg").setup()
      end,
   },

   -- Dap
   ["mfussenegger/nvim-dap"] = {
      commit = commit.nvim_dap,
      opt = true,
      module = "dap",
      config = function()
         require("custom.plugins.configs.nvim-dap").setup()
      end,
   },
   ["rcarriga/nvim-dap-ui"] = {
      commit = commit.nvim_dap_ui,
      after = "nvim-dap",
      config = function()
         require("dapui").setup()
      end,
   },
   ["theHamsta/nvim-dap-virtual-text"] = {
      commit = commit.nvim_dap_virtual_text,
      after = "nvim-dap",
      config = function()
         require("nvim-dap-virtual-text").setup()
      end,
   },

   -- misc
   ["szw/vim-maximizer"] = {
      commit = commit.vim_maximizer,
      event = "BufRead",
   },

   ["windwp/nvim-spectre"] = {
      commit = commit.nvim_spectre,
      opt = true,
      module = "spectre",
      wants = { "plenary.nvim", "popup.nvim" },
      requires = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
      config = function()
         require("custom.plugins.configs.others").nvim_spectre()
      end,
   },

   ["wochap/emmet-vim"] = {
      commit = commit.wochap_emmet,
      keys = {
         { "i", "<C-y>" },
      },
      setup = function()
         require("custom.plugins.configs.others").emmet_vim()
      end,
   },

   ["rhysd/conflict-marker.vim"] = {
      commit = commit.conflict_marker,
      event = "BufReadPost",
      setup = function()
         require("custom.plugins.configs.others").conflict_marker()
      end,
   },

   -- This is needed to fix lsp doc highlight
   ["antoinemadec/FixCursorHold.nvim"] = {},

   -- Change word casing
   ["tpope/vim-abolish"] = {},

   ["tpope/vim-repeat"] = {},

   -- Switch words
   ["tommcdo/vim-exchange"] = {},

   -- Align text vertically
   ["tommcdo/vim-lion"] = {},
}

M.override = {
   ["kyazdani42/nvim-tree.lua"] = require "custom.plugins.overrides.nvim-tree",
   ["nvim-telescope/telescope.nvim"] = require "custom.plugins.overrides.telescope",
   ["lewis6991/gitsigns.nvim"] = require("custom.plugins.overrides.others").gitsigns,
   ["hrsh7th/nvim-cmp"] = require "custom.plugins.overrides.cmp",
   ["nvim-treesitter/nvim-treesitter"] = require "custom.plugins.overrides.treesitter",
   ["L3MON4D3/LuaSnip"] = require("custom.plugins.overrides.others").luasnip,
   ["numToStr/Comment.nvim"] = require("custom.plugins.overrides.others").comment,
   ["NvChad/ui"] = {
      tabufline = require "custom.plugins.overrides.tabufline",
      statusline = require "custom.plugins.overrides.statusline",
   },
}

return M
