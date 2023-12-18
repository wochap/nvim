-- HACK: can't do `{ import = "lazyvim.plugins.lsp.init" },` or `{ import = "lazyvim.plugins.lsp" },`
-- in `lua/custom/custom-plugins/init.lua`, they result in errors
local lsp_specs = require "lazyvim.plugins.lsp.init"

return vim.list_extend(vim.deepcopy(lsp_specs), {
  -- LSP, import config from LazyVim
  -- https://www.lazyvim.org/plugins/lsp
  -- the following opts for nvim-lspconfig are managed by LazyVim:
  -- diagnostics, inlay_hints, capabilities, format, servers and setup
  -- LazyVim adds keymaps to buffers with LSP clients attached
  -- LazyVim installs any LSP server with Mason
  -- LazyVim installs neoconf
  -- NvChad lspconfig keymaps are ignored
  { "folke/neodev.nvim", enabled = false }, -- disable neodev.nvim added by LazyVim
  {
    "neovim/nvim-lspconfig",
    init = function()
      require("custom.custom-plugins.overrides.lspconfig").init()
    end,
    opts = function(_, opts)
      -- remove lua_ls added by LazyVim
      opts.servers = {}
      return vim.tbl_deep_extend("force", opts, require("custom.custom-plugins.overrides.lspconfig").options)
    end,
    config = function(_, opts)
      require("custom.custom-plugins.overrides.lspconfig").setup(_, opts)
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    keys = function()
      return {}
    end,
    opts = function(_, opts)
      local nvchad_opts = require "plugins.configs.mason"
      -- remove stylua and shfmt added by LazyVim
      nvchad_opts.ensure_installed = {}
      return nvchad_opts
    end,
    config = function(_, opts)
      require("custom.custom-plugins.overrides.mason").setup(opts)
    end,
  },

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = function()
      return require("custom.custom-plugins.configs.noice").options
    end,
    keys = function()
      return require("custom.custom-plugins.configs.noice").keys
    end,
  },
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    opts = {},
  },
  {
    "smjonas/inc-rename.nvim",
    opts = {
      input_buffer_type = "dressing",
    },
  },
  {
    "RRethy/vim-illuminate",
    event = "LazyFile",
    opts = {
      delay = 200,
      under_cursor = false,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
    keys = {
      {
        "]]",
        function()
          require("illuminate").goto_next_reference(false)
        end,
        desc = "Next Reference",
      },
      {
        "[[",
        function()
          require("illuminate").goto_prev_reference(false)
        end,
        desc = "Prev Reference",
      },
    },
  },
})
