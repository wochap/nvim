local M = {}
local ignore = "<leader>zx"

M.mappings = {
   misc = {
      cheatsheet = "<leader>hc",
      close_buffer = "<leader>w",
      copy_whole_file = "<C-a>", -- copy all contents of current buffer
      line_number_toggle = "<leader>n", -- toggle line number
      update_nvchad = "<leader>uu",
      save_file = "<C-s>", -- save file using :w
      new_tab = "tn",
      
      new_buffer = ignore,
   },

   window_nav = {
      moveLeft = "<C-Left>",
      moveRight = "<C-Right>",
      moveUp = "<C-Up>",
      moveDown = "<C-Down>",
   },

   terminal = {
      esc_termmode = { "jk" },
      esc_hide_termmode = { "JK" },
      pick_term = "<leader>tW",
      new_horizontal = "<leader>th",
      new_vertical = "<leader>tv",
      new_window = "<leader>tw",
   },

   plugins = {
      bufferline = {
         next_buffer = "<S-Right>",
         prev_buffer = "<S-Left>",
      },

      dashboard = {
         bookmarks = "<leader>fm",
         new_file = "<C-n>", -- basically create a new buffer
         open = "<leader>bb", -- open dashboard
         session_load = "<leader>bl",
         session_save = "<leader>bs",
      },

      lspconfig = {
         goto_next = "]d",
         goto_prev = "[d",
         
         hover = "K",
         
         declaration = "gD",
         definition = "gd",
         implementation = "gi",
         signature_help = "gs",
         type_definition = "gt",
         
         rename = "<leader>lr",
         code_action = "<leader>la",
         float_diagnostics = "<leader>ld",
         formatting = "<leader>lf",
         
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
         live_grep = "<leader>sw",

         buffers = "<leader>fb",
         oldfiles = "<leader>fo",

         git_commits = "<leader>gm",
         git_status = "<leader>gt",

         help_tags = ignore,
      },
   },
}

M.options = {
   signcolumn = "yes:2",
   relativenumber = true,
   fillchars = {
      eob = "~",
      diff = "╱"
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
   status = {
      -- feline = false,
      dashboard = true,
      colorizer = false,
      better_escape = false,
   },
   options = {
      nvimtree = {
         enable_git = 1,
         ui = {
            allow_resize = true,
            side = "left",
            width = 35,
            hide_root_folder = false,
            number = true,
            relativenumber = true,
         },
      },
      lspconfig = {
         setup_lspconf = "custom.plugins.configs.lspconfig",
      },
      statusline = {
         -- shortline = false,
         style = "default",
      },
   },
   -- To change the Packer `config` of a plugin that comes with NvChad,
   -- add a table entry below matching the plugin github name
   --              '-' -> '_', remove any '.lua', '.nvim' extensions
   -- this string will be called in a `require`
   --              use "(custom.configs).my_func()" to call a function
   --              use "custom.blankline" to call a file
   default_plugin_config_replace = {
      gitsigns = "custom.plugins.configs.gitsigns",
      nvim_cmp = "custom.plugins.configs.cmp",
      nvim_comment = "custom.plugins.configs.nvim-comment",
      nvim_tree = "custom.plugins.configs.nvimtree",
      nvim_treesitter = "custom.plugins.configs.treesitter",
      nvim_autopairs = "custom.plugins.configs.autopairs",
      bufferline = "custom.plugins.configs.bufferline",
   },
}

return M
