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
      commit = "73f14943bac5830905d715804ca581a91844272a", -- v12.44.1
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
      disabled_plugins = vim.tbl_extend("force", {
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
        "optwin",
        "rplugin",
        "rrhelper",
        "synmenu",
        "tar",
        "tarPlugin",
        "tohtml",
        "tutor",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
      }, constants.disable_netrw and {
        "netrw",
        "netrwFileHandlers",
        "netrwPlugin",
        "netrwSettings",
      } or {}),
    },
  },
}
