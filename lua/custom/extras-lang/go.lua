local plugins = {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "go",
        "gomod",
        "gowork",
        "gosum",
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "gopls",
        })
      end

      if type(opts.handlers) == "table" then
        opts.handlers.gopls = function()
          local get_opts = require("custom.utils.lsp").get_opts
          local serverOpts = get_opts()

          serverOpts.on_attach = function(client, bufnr)
            -- Run nvchad's attach
            get_opts().on_attach(client, bufnr)

            if not client.server_capabilities.semanticTokensProvider then
              local semantic = client.config.capabilities.textDocument.semanticTokens
              client.server_capabilities.semanticTokensProvider = {
                full = true,
                legend = {
                  tokenTypes = semantic.tokenTypes,
                  tokenModifiers = semantic.tokenModifiers,
                },
                range = true,
              }
            end
          end

          serverOpts.settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          }

          require("lspconfig").gopls.setup(serverOpts)
        end
      end
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    optional = true,
    opts = function(_, opts)
      if type(opts.sources) == "table" then
        local nls = require "null-ls"
        vim.list_extend(opts.sources, {
          nls.builtins.code_actions.gomodifytags,
          nls.builtins.code_actions.impl,
          nls.builtins.formatting.gofumpt,
          nls.builtins.formatting.goimports_reviser,
        })
      end
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    optional = true,
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "gofumpt",
          "goimports-reviser",
        })
      end
    end,
  },
  {
    "mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "gomodifytags", "impl" })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    dependencies = {
      {
        "leoluz/nvim-dap-go",
        config = true,
      },
    },
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "delve",
        })
      end

      if type(opts.handlers) == "table" then
        opts.handlers.delve = function() end
      end
    end,
  },
}

return plugins
