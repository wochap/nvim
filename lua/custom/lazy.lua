local lazyUtils = require "custom.utils.lazy"

-- Install `lazy.nvim` plugin manager
lazyUtils.install()
lazyUtils.load_mappings()

-- Add LazyFile event
lazyUtils.lazy_file()

-- Configure and install plugins
require("lazy").setup {
  spec = {
    {
      "LazyVim/LazyVim",
      version = false,
      commit = "68ff818a5bb7549f90b05e412b76fe448f605ffb",
      priority = 10000,
      config = function() end,
    },

    { import = "custom.plugins" },
    { import = "custom.plugins.extras-lang" },
  },
  defaults = {
    lazy = true,
    version = false,
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
        "netrw",
        "netrwFileHandlers",
        "netrwPlugin",
        "netrwSettings",
        "optwin",
        "rplugin",
        "rrhelper",
        "spellfile_plugin",
        "synmenu",
        "syntax",
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