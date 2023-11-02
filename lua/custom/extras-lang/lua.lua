local plugins = {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "lua" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    dependencies = {
      { "folke/neodev.nvim", opts = {} },
    },
    opts = {
      servers = {
        lua_ls = {
          -- mason = false, -- set to false if you don't want this server to be installed with mason
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
      },
    },
  },

  {
    "nvimtools/none-ls.nvim",
    optional = true,
    dependencies = {
      {
        "jay-babu/mason-null-ls.nvim",
        optional = true,
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, { "stylua", "luacheck" })
        end,
      },
    },
    opts = function(_, opts)
      local null_ls = require "null-ls"
      local b = null_ls.builtins

      vim.list_extend(opts.sources, {
        b.formatting.stylua,
        b.diagnostics.luacheck.with { extra_args = { "--globals vim" } },
      })
    end,
  },

  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "jbyuki/one-small-step-for-vimkind",
        config = function()
          local dap = require "dap"

          dap.adapters.nlua = function(callback, conf)
            local adapter = {
              type = "server",
              host = conf.host or "127.0.0.1",
              port = conf.port or 8086,
            }
            if conf.start_neovim then
              local dap_run = dap.run
              dap.run = function(c)
                adapter.port = c.port
                adapter.host = c.host
              end
              require("osv").run_this()
              dap.run = dap_run
            end
            callback(adapter)
          end

          dap.configurations.lua = {
            {
              name = "nlua: Run this file",
              type = "nlua",
              request = "attach",
              start_neovim = {},
            },
            {
              name = "nlua: Attach to running Neovim instance (port = 8086)",
              type = "nlua",
              request = "attach",
              port = 8086,
            },
          }
        end,
      },
    },
  },
}

return plugins
