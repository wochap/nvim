-- IMPORTANT NOTE : This is the user config, can be edited. Will be preserved if updated with internal updater
-- This file is for NvChad options & tools, custom settings are split between here and 'lua/custom/init.lua'

local M = {}
-- M.options, M.ui, M.mappings, M.plugins = {}, {}, {}, {}

-- NOTE: To use this, make a copy with `cp example_chadrc.lua chadrc.lua`

--------------------------------------------------------------------

-- To use this file, copy the structure of `core/default_config.lua`,
-- examples of setting relative number & changing theme:

M.mappings = {
   window_nav = {
      moveLeft = "<C-Left>",
      moveRight = "<C-Right>",
      moveUp = "<C-Up>",
      moveDown = "<C-Down>",
   },

   terminal = {
      new_horizontal = "<leader>hh",
      new_window = "<leader>ww",
   },

   plugins = {
      lspconfig = {
         references = "gre",
      }, 
   },
}

M.options = {
   relativenumber = true,
   fillchars = {
      eob = "~",
      diff = "╱"
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
   },
}

return M
