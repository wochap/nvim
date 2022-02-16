local pluginOverridesOthers = require "custom.plugins.overrides.others"
local M = {}
local ignore = "<leader>zx"

M.mappings = {
   misc = {
      cheatsheet = "<leader>nc",
      close_buffer = "<leader>w",
      copy_whole_file = "<C-a>", -- copy all contents of current buffer
      copy_to_system_clipboard = "<C-C>", -- copy selected text (visual mode) or curent line (normal)
      line_number_toggle = "<leader>nn", -- toggle line number
      update_nvchad = "<leader>nu",
      save_file = "<C-s>", -- save file using :w

      new_tab = ignore,
      new_buffer = ignore,
   },

   window_nav = {
      moveLeft = "<C-Left>",
      moveRight = "<C-Right>",
      moveUp = "<C-Up>",
      moveDown = "<C-Down>",
   },

   terminal = {
      esc_termmode = { "jj" },
      esc_hide_termmode = { "JJ" },
      pick_term = "<leader>tT",
      new_horizontal = "<leader>th",
      new_vertical = "<leader>tv",
      new_window = "<leader>tt",
   },

   plugins = {
      bufferline = {
         next_buffer = "<S-Right>",
         prev_buffer = "<S-Left>",
      },

      dashboard = {
         bookmarks = "<leader>fm",
         new_file = "<leader>fn", -- basically create a new buffer
         open = "<leader>nb", -- open dashboard
         session_load = "<leader>nl",
         session_save = "<leader>ns",
      },

      lspconfig = {
         goto_next = "]d",
         goto_prev = "[d",

         hover = "K",

         declaration = "gD",
         definition = "gdd",
         implementation = "gi",
         signature_help = "gs",
         type_definition = "gy",

         float_diagnostics = "<leader>ld",
         formatting = "<leader>lf",

         rename = ignore,
         code_action = ignore,
         references = ignore,
         add_workspace_folder = ignore,
         remove_workspace_folder = ignore,
         list_workspace_folders = ignore,
         set_loclist = ignore,
      },

      nvimtree = {
         toggle = "<leader>b",
         focus = "<leader>e",
      },

      telescope = {
         live_grep = "<leader>sg",

         buffers = "<leader>fb",
         oldfiles = "<leader>fo",

         git_commits = "<leader>gm",
         git_status = "<leader>gt",

         themes = "<leader>nt", -- NvChad theme picker

         help_tags = ignore,
      },
   },
}

M.options = {
   tabstop = 2,
   signcolumn = "yes:2",
   relativenumber = true,
   fillchars = {
      eob = "~",
      diff = "╱",
   },

   nvChad = {
      insert_nav = false, -- navigation in insertmode
   },
}

M.ui = {
   theme = "chadracula",
   hl_override = "custom.colors",
}

-- NvChad included plugin options & overrides
M.plugins = {
   install = require "custom.plugins",

   status = {
      -- feline = false,
      dashboard = true,
      colorizer = false,
      better_escape = false,
      autotag = false,
      lspsignature = false,
   },

   options = {
      lspconfig = {
         setup_lspconf = "custom.plugins.configs.lspconfig",
      },
      statusline = {
         hidden = {
            "help",
            "dashboard",
            "NvimTree",
            "terminal",
            "dap-repl",
            "dapui_watches",
            "dapui_stacks",
            "dapui_breakpoints",
            "dapui_scopes",
            "DiffviewFiles",
         },
         style = "default",
      },
   },
   default_plugin_config_replace = {
      bufferline = pluginOverridesOthers.bufferline,
      gitsigns = pluginOverridesOthers.gitsigns,
      luasnip = pluginOverridesOthers.luasnip,
      nvim_autopairs = "custom.plugins.overrides.autopairs",
      nvim_cmp = "custom.plugins.overrides.cmp",
      nvim_comment = pluginOverridesOthers.nvim_comment,
      nvim_tree = "custom.plugins.overrides.nvimtree",
      nvim_treesitter = "custom.plugins.overrides.treesitter",
      signature = pluginOverridesOthers.signature,
   },
   default_plugin_remove = {
      "nathom/filetype.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rafamadriz/friendly-snippets",
   },
}

return M
