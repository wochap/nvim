return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = { "lua" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Enable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
      },
    },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "LazyVim", words = { "LazyVim" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "LazyVim" } },
      },
    },
  },
  {
    "Bilal2453/luvit-meta",
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      sources = {
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 1, -- show at a higher priority than lsp
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
        opts = {
          ensure_installed = { "stylua" },
        },
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
        opts = {
          ensure_installed = { "luacheck" },
        },
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
