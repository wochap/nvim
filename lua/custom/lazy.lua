local constants = require "custom.utils.constants"
local lazyUtils = require "custom.utils.lazy"

-- Install `lazy.nvim` plugin manager
lazyUtils.install()

-- Load `lazy.nvim` keymaps
lazyUtils.load_mappings()

-- Add LazyFile event
lazyUtils.lazy_file()

-- Configure and install plugins
require("lazy").setup {
  spec = {
    {
      "folke/lazy.nvim",
      version = "*",
    },
    -- Necessary to import extras from LazyVim
    {
      "LazyVim/LazyVim",
      version = false,
      commit = "987bd2207f7f2f7f72f65b0e7e811ec04c03aa32",
      priority = 10000,
      config = function()
        _G.lazyvim_docs = false
        -- required by lazyvim extras using `LazyVim.extras.wants`
        _G.LazyVim = require "lazyvim.util"
      end,
    },

    { import = "custom.plugins" },
    {
      enabled = not constants.first_install,
      import = "lazyvim.plugins.extras.lang.json",
    },
    {
      enabled = not constants.first_install,
      import = "lazyvim.plugins.extras.lang.yaml",
    },
  },
  defaults = {
    lazy = true,
    version = false,
  },
  dev = {
    path = vim.fn.stdpath "config" .. "/lua",
  },
  install = { colorscheme = { "catppuccin", "habamax" } },
  checker = { enabled = true, notify = false },
  change_detection = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "bugreport",
        "compiler",
        "ftplugin",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "matchit",
        "matchparen",
        "netrw",
        "netrwFileHandlers",
        "netrwPlugin",
        "netrwSettings",
        "optwin",
        "rplugin",
        "rrhelper",
        "spellfile_plugin",
        "synmenu",
        "tar",
        "tarPlugin",
        "tohtml",
        "tutor",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
      },
    },
  },
}
