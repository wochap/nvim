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
      commit = "d1529f650fdd89cb620258bdeca5ed7b558420c7", -- v14.6.1
      priority = 10000,
      config = function()
        lazyvimUtils.setup()
      end,
    },
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      opts = {},
      config = function(_, opts)
        local notify = vim.notify
        require("snacks").setup(opts)
        -- HACK: restore vim.notify after snacks setup and let noice.nvim take over
        -- this is needed to have early notifications show up in noice history
        if LazyVim.has "noice.nvim" then
          vim.notify = notify
        end
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
