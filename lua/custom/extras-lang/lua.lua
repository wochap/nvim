local plugins = {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "lua" })
    end,
  },

  { "folke/neodev.nvim", enabled = true },
  {
    "neovim/nvim-lspconfig",
    optional = true,
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
    "stevearc/conform.nvim",
    optional = true,
    dependencies = {
      {
        "williamboman/mason.nvim",
        optional = true,
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, { "stylua" })
        end,
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    dependencies = {
      {
        "williamboman/mason.nvim",
        optional = true,
        opts = function(_, opts)
          vim.list_extend(opts.ensure_installed, { "luacheck" })
        end,
      },
    },
    opts = {
      linters_by_ft = {
        lua = { "luacheck" },
      },
      linters = {
        luacheck = {
          args = { "--globals", "vim", "--formatter", "plain", "--codes", "--ranges", "-" },
        },
      },
    },
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
            if conf.start_neovim_server then
              require("osv").launch { port = 8086 }
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
              name = "nlua: Start neovim server",
              type = "nlua",
              request = "attach",
              start_neovim_server = {},
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
