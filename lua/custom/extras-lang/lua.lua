local plugins = {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "lua",
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    dependencies = {
      { "folke/neodev.nvim", opts = {} },
    },
  },
  -- {
  --   "nvimtools/none-ls.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     if type(opts.sources) == "table" then
  --       local nls = require "null-ls"
  --       vim.list_extend(opts.sources, {
  --         nls.builtins.code_actions.gomodifytags,
  --         nls.builtins.code_actions.impl,
  --         nls.builtins.formatting.gofumpt,
  --         nls.builtins.formatting.goimports_reviser,
  --       })
  --     end
  --   end,
  -- },
  -- {
  --   "jay-babu/mason-null-ls.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     if type(opts.ensure_installed) == "table" then
  --       vim.list_extend(opts.ensure_installed, {
  --         "gofumpt",
  --         "goimports-reviser",
  --       })
  --     end
  --   end,
  -- },
  -- {
  --   "mason.nvim",
  --   opts = function(_, opts)
  --     opts.ensure_installed = opts.ensure_installed or {}
  --     vim.list_extend(opts.ensure_installed, { "gomodifytags", "impl" })
  --   end,
  -- },
  -- {
  --   "jay-babu/mason-nvim-dap.nvim",
  --   optional = true,
  --   dependencies = {
  --     {
  --       "leoluz/nvim-dap-go",
  --       config = true,
  --     },
  --   },
  --   opts = function(_, opts)
  --     if type(opts.ensure_installed) == "table" then
  --       vim.list_extend(opts.ensure_installed, {
  --         "delve",
  --       })
  --     end
  --
  --     if type(opts.handlers) == "table" then
  --       opts.handlers.delve = function() end
  --     end
  --   end,
  -- },
}

return plugins
