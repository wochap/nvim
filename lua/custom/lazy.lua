local constants = require "custom.utils.constants"
local lazyUtils = require "custom.utils.lazy"
local lazyvimUtils = require "custom.utils.lazyvim"

-- Install `lazy.nvim` plugin manager
lazyUtils.install()

-- Load `lazy.nvim` keymaps
lazyUtils.load_mappings()

-- Load `LazyVim` if possible
lazyvimUtils.load()

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
      lazy = false,
      version = false,
      commit = "12818a6cb499456f4903c5d8e68af43753ebc869",
      priority = 10000,
      config = function()
        lazyvimUtils.setup()
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
