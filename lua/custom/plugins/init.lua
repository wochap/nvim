local commit = {
   -- nvchad
   plenary = "1c7e3e6b0f4dd5a174fcea9fda8a4d7de593b826",
   nvchad_extensions = "1f67c3c2dfca8ff545afd694eb76c9ef45169567",
   nvchad_base64 = "be301b2cd309394dfa62e8c569250e4fb58dd763",
   nvchad_ui = "eaf9d087594cc8cc6cf8355ebcc1568edb817f66",
   nvchad_nvterm = "29a70ef608a8cc5db3a5fc300d39a39d1a44a863",
   web_devicons = "9ca185ed23cc47bef66d97332f0694be568121e8",
   indent_blankline = "c4c203c3e8a595bc333abaf168fcb10c13ed5fb7",
   nvchad_colorizer = "760e27df4dd966607e8fb7fd8b6b93e3c7d2e193",
   treesitter = "da6dc214ddde3fac867bd4a6f4ea51a794b01e18",
   gitsigns = "7b37bd5c2dd4d7abc86f2af096af79120608eeca",
   mason = "71069da64d33a33afc169ca37d7ae66699cfe5ee",
   lspconfig = "0eecf453d33248e9d571ad26559f35175c37502d",
   friendly_snippets = "046e4d3491baf664e0eef5231d28beb49333578b",
   cmp = "11a95792a5be0f5a40bab5fc5b670e5b1399a939",
   luasnip = "8c23e1af82bdafa86556a36c4e075079dd167771",
   cmp_luasnip = "18095520391186d634a0045dacaa346291096566",
   cmp_lua = "f3491638d123cfd2c8048aefaf66d246ff250ca6",
   cmp_lsp = "59224771f91b86d1de12570b4070fe4ad7cd1eeb",
   cmp_buffer = "3022dbc9166796b644a841a02de8dd1cc1d311fa",
   cmp_path = "91ff86cd9c29299a64f968ebb45846c485725f23",
   autopairs = "31042a5823b55c4bfb30efcbba2fc1b5b53f90dc",
   alpha = "21a0f2520ad3a7c32c0822f943368dc063a569fb",
   comment = "eab2c83a0207369900e92783f56990808082eac2",
   tree = "96506fee49542f3aedab76368d400a147fea344e",
   telescope = "2f32775405f6706348b71d0bb8a15a22852a61e4",
   which_key = "e4fa445065a2bb0bbc3cca85346b67817f28e83e",

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
   null_ls = "33cfeb7a761f08e8535dca722d4b237cabadd371",
   neorg = "4ad79529477fd8b84fec75485e705eab2d3ca34a",
   nvim_surround = "d91787d5a716623be7cec3be23c06c0856dc21b8",

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

local M = {
   -- nvchad
   ["nvim-lua/plenary.nvim"] = { commit = commit.plenary },
   ["NvChad/extensions"] = { commit = commit.nvchad_extensions },
   ["NvChad/base46"] = { commit = commit.nvchad_base64 },
   ["NvChad/ui"] = { commit = commit.nvchad_ui, 
   override_options = {

      -- TODO: fix
      tabufline = require "custom.plugins.overrides.tabufline",
      statusline = require "custom.plugins.overrides.statusline",
   },
},
   ["NvChad/nvterm"] = { commit = commit.nvchad_nvterm },
   ["kyazdani42/nvim-web-devicons"] = { commit = commit.web_devicons },
   ["lukas-reineke/indent-blankline.nvim"] = { commit = commit.indent_blankline },
   ["NvChad/nvim-colorizer.lua"] = { commit = commit.nvchad_colorizer },
   ["nvim-treesitter/nvim-treesitter"] = {
      commit = commit.treesitter,
      requires = {
         { "JoosepAlviste/nvim-ts-context-commentstring" },
      },
      override_options = require "custom.plugins.overrides.treesitter",
   },
   ["lewis6991/gitsigns.nvim"] = { commit = commit.gitsigns, override_options = require("custom.plugins.overrides.others").gitsigns, },
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
   ["hrsh7th/nvim-cmp"] = { commit = commit.cmp, override_options = require "custom.plugins.overrides.cmp", },
   ["L3MON4D3/LuaSnip"] = { commit = commit.luasnip, override_options = require("custom.plugins.overrides.others").luasnip, },
   ["saadparwaiz1/cmp_luasnip"] = { commit = commit.cmp_luasnip },
   ["hrsh7th/cmp-nvim-lua"] = { commit = commit.cmp_lua },
   ["hrsh7th/cmp-nvim-lsp"] = { commit = commit.cmp_lsp },
   ["hrsh7th/cmp-buffer"] = { commit = commit.cmp_buffer },
   ["hrsh7th/cmp-path"] = { commit = commit.cmp_path },
   ["windwp/nvim-autopairs"] = { commit = commit.autopairs },
   ["goolord/alpha-nvim"] = { commit = commit.alpha },
   ["numToStr/Comment.nvim"] = { commit = commit.comment, override_options = require("custom.plugins.overrides.others").comment, },
   ["nvim-tree/nvim-tree.lua"] = { commit = commit.tree, override_options = require "custom.plugins.overrides.nvim-tree", },
   ["nvim-telescope/telescope.nvim"] = {
      commit = commit.telescope,
      ft = { "norg" },
      module = { "telescope", "telescope.builtin", "telescope.action" },
      cmd = "Telescope",
      override_options = require "custom.plugins.overrides.telescope",
   },
   ["folke/which-key.nvim"] = { commit = commit.which_key, disable = false,
   config = function()
      require "plugins.configs.whichkey"
      require("custom.plugins.configs.others").which_key()
   end,
},

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

   ["kylechui/nvim-surround"] = {
      commit = commit.nvim_surround,
      config = function()
         require("custom.plugins.configs.others").nvim_surround()
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

-- M.override = {
--    ["kyazdani42/nvim-tree.lua"] = require "custom.plugins.overrides.nvim-tree",
--    ["nvim-telescope/telescope.nvim"] = require "custom.plugins.overrides.telescope",
--    ["lewis6991/gitsigns.nvim"] = require("custom.plugins.overrides.others").gitsigns,
--    ["hrsh7th/nvim-cmp"] = require "custom.plugins.overrides.cmp",
--    ["nvim-treesitter/nvim-treesitter"] = require "custom.plugins.overrides.treesitter",
--    ["L3MON4D3/LuaSnip"] = require("custom.plugins.overrides.others").luasnip,
--    ["numToStr/Comment.nvim"] = require("custom.plugins.overrides.others").comment,
--    ["NvChad/ui"] = {
--       -- TODO: fix
--       -- tabufline = require "custom.plugins.overrides.tabufline",
--       -- statusline = require "custom.plugins.overrides.statusline",
--    },
-- }

return M
