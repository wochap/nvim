local pluginOverridesOthers = require "custom.plugins.overrides.others"
local M = {}
local ignore = "<leader>zx"

M.mappings = {
   misc = {
      cheatsheet = "<leader>nc",
      copy_to_system_clipboard = "<C-C>", -- copy selected text (visual mode) or curent line (normal)
      copy_whole_file = "<C-a>", -- copy all contents of current buffer
      line_number_toggle = "<leader>nn", -- toggle line number
      relative_line_number_toggle = "<leader>nr",
      save_file = "<C-s>", -- save file using :w

      close_buffer = ignore,
      new_buffer = ignore,
      new_tab = ignore,
      update_nvchad = ignore,
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

      lspconfig = {
         goto_next = "]d",
         goto_prev = "[d",

         hover = "gh",
         declaration = "gD",
         definition = "gdd",
         implementation = "gI",
         signature_help = "gs",
         type_definition = "gt",

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
         buffers = "<leader>fb",
         oldfiles = "<leader>fo",

         git_commits = "<leader>gm",
         git_status = "<leader>gt",

         themes = "<leader>nt", -- NvChad theme picker

         find_files = ignore,
         find_hiddenfiles = ignore,
         help_tags = ignore,
         live_grep = ignore,
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
      alpha = false,
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
            -- "DiffviewFiles",
            -- "NvimTree", -- Fix jump on focus
            "dap-repl",
            "dapui_breakpoints",
            "dapui_scopes",
            "dapui_stacks",
            "dapui_watches",
            "help",
            "terminal",
         },
         shown = {},
         style = "default",
      },
   },
   default_plugin_config_replace = {
      bufferline = "custom.plugins.overrides.bufferline",
      gitsigns = pluginOverridesOthers.gitsigns,
      luasnip = pluginOverridesOthers.luasnip,
      nvim_autopairs = "custom.plugins.overrides.autopairs",
      nvim_cmp = "custom.plugins.overrides.cmp",
      nvim_comment = pluginOverridesOthers.nvim_comment,
      nvim_tree = "custom.plugins.overrides.nvimtree",
      nvim_treesitter = "custom.plugins.overrides.treesitter",
      feline = "custom.plugins.overrides.statusline",
      signature = pluginOverridesOthers.signature,
      telescope = pluginOverridesOthers.telescope,
   },
   default_plugin_remove = {
      "nathom/filetype.nvim",
      "nvim-treesitter/nvim-treesitter",
      "rafamadriz/friendly-snippets",
   },
}

return M
