return {
  { import = "lazyvim.plugins.extras.lang.tailwind" },
  { import = "lazyvim.plugins.extras.linting.eslint" },

  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "astro",
        "css",
        "graphql",
        "html",
        "javascript",
        "svelte",
        "tsx",
        "typescript",
        "vue",
      })
    end,
  },

  { "pmizio/typescript-tools.nvim" },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        html = { filetypes = { "xhtml", "html" } },
        cssls = {
          provideFormatter = false,
          capabilities = {
            textDocument = {
              completion = {
                completionItem = {
                  snippetSupport = true,
                },
              },
            },
          },
          settings = {
            css = {
              validate = false,
            },
            less = {
              validate = false,
            },
            scss = {
              validate = false,
            },
          },
        },
        svelte = {},
        astro = {},
        cssmodules_ls = {},
        emmet_language_server = {
          filetypes = {
            "astro",
            "css",
            "eruby",
            "html",
            "xhtml",
            "xml",
            "htmldjango",
            "javascriptreact",
            "less",
            "pug",
            "sass",
            "scss",
            "svelte",
            "typescriptreact",
            "vue",
          },
          init_options = {
            showSuggestionsAsSnippets = true,
          },
        },
        tsserver = {
          filetypes = {
            "javascript",
            "javascript.jsx",
            "javascriptreact",
            "typescript",
            "typescript.tsx",
            "typescriptreact",
            "vue",
          },
          init_options = {
            preferences = {
              importModuleSpecifierPreference = "non-relative",

              includeInlayEnumMemberValueHints = true,
              includeInlayFunctionLikeReturnTypeHints = false,
              includeInlayFunctionParameterTypeHints = false,
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayPropertyDeclarationTypeHints = false,
              includeInlayVariableTypeHints = false,
            },
            plugins = {
              {
                name = "@vue/typescript-plugin",
                location = vim.fn.expand "$HOME/.npm-packages/lib/node_modules/@vue/typescript-plugin",
                languages = { "javascript", "typescript", "vue" },
              },
            },
          },
        },
        ["typescript-tools"] = {
          filetypes = {
            "javascript",
            "javascript.jsx",
            "javascriptreact",
            "typescript",
            "typescript.tsx",
            "typescriptreact",
            "vue",
          },
          mason = false,
          keys = {
            {
              "<leader>lo",
              "<cmd>TSToolsOrganizeImports<cr>",
              desc = "Organize Imports",
            },
            {
              "<leader>lu",
              "<cmd>TSToolsRemoveUnusedImports<cr>",
              desc = "Remove Unused Imports",
            },
            {
              "<leader>lR",
              "<cmd>TSToolsRenameFile<cr>",
              desc = "Rename File",
            },
            {
              "<leader>ls",
              "<cmd>TSToolsSortImports<cr>",
              desc = "Sort Imports",
            },
            {
              "<leader>lm",
              "<cmd>TSToolsAddMissingImports<cr>",
              desc = "Add Missing Imports",
            },
            {
              "gd",
              "<cmd>TSToolsGoToSourceDefinition<cr>",
              desc = "Goto Source Definition",
            },
          },
          settings = {
            -- tsserver settings
            typescript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            javascript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            completions = {
              completeFunctionCalls = true,
            },

            -- typescript-tools settings
            tsserver_plugins = {
              -- FIXME: find a way to pass location and languages like in tsserver config
              "@vue/typescript-plugin",
            },
          },
        },
        volar = {
          filetypes = { "vue" },
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                -- NOTE: `dynamicRegistration: true` reduces greatly the performance on nvim < 0.10.0
                dynamicRegistration = true,
              },
            },
          },
        },
        eslint = {
          settings = {
            run = "onSave",
          },
        },
      },
      setup = {
        -- NOTE: typescript-tools.nvim will not spawn a tsserver client, it will spawn typescript-tools client
        ["typescript-tools"] = function(_, opts)
          require("typescript-tools").setup(opts)
          return true
        end,
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
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "prettierd", "xmlformatter" })
        end,
      },
    },
    opts = {
      formatters_by_ft = {
        ["javascript"] = { "prettierd" },
        ["javascriptreact"] = { "prettierd" },
        ["typescript"] = { "prettierd" },
        ["typescriptreact"] = { "prettierd" },
        ["vue"] = { "prettierd" },
        ["css"] = { "prettierd" },
        ["scss"] = { "prettierd" },
        ["less"] = { "prettierd" },
        ["html"] = { "prettierd" },
        ["json"] = { "prettierd" },
        ["jsonc"] = { "prettierd" },
        ["yaml"] = { "prettierd" },
        ["markdown"] = { "prettierd" },
        ["markdown.mdx"] = { "prettierd" },
        ["graphql"] = { "prettierd" },
        ["handlebars"] = { "prettierd" },
        ["xml"] = { "xmlformat" },
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        optional = true,
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "chrome", "js", "node2" })
        end,
      },
    },
    opts = function()
      local dap = require "dap"

      if not dap.adapters["pwa-node"] then
        require("dap").adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = {
              require("mason-registry").get_package("js-debug-adapter"):get_install_path()
                .. "/js-debug/src/dapDebugServer.js",
              "${port}",
            },
          },
        }
      end

      if not dap.adapters["node2"] then
        require("dap").adapters["node2"] = {
          type = "executable",
          command = "node",
          args = {
            require("mason-registry").get_package("node-debug2-adapter"):get_install_path() .. "/out/src/nodeDebug.js",
          },
        }
      end

      if not dap.adapters["chrome"] then
        require("dap").adapters["chrome"] = {
          type = "executable",
          command = "node",
          args = {
            require("mason-registry").get_package("chrome-debug-adapter"):get_install_path()
              .. "/out/src/chromeDebug.js",
          },
        }
      end

      for _, language in ipairs { "typescript", "javascript", "typescriptreact", "javascriptreact" } do
        local isJs = language == "javascript"
        if not dap.configurations[language] then
          dap.configurations[language] = {
            {
              name = "pwa-node: Launch file",
              type = "pwa-node",
              request = "launch",
              program = "${file}",
              cwd = "${workspaceFolder}",
            },
            {
              name = "pwa-node: Attach to process",
              type = "pwa-node",
              request = "attach",
              -- processId = require("dap.utils").pick_process,
              cwd = "${workspaceFolder}",
              sourceMaps = true,
              protocol = "inspector",
              skipFiles = { "<node_internals>/**/*.js" },
            },
            {
              name = "node2: Attach to process" .. (isJs and "" or " TS"),
              type = "node2",
              request = "attach",
              -- processId = require("dap.utils").pick_process,
              cwd = vim.fn.getcwd(),
              runtimeArgs = isJs and {} or { "-r", "ts-node/register" },
              sourceMaps = true,
              protocol = "inspector",
              skipFiles = { "<node_internals>/**/*.js" },
            },
            {
              name = "node2: Launch file" .. (isJs and "" or " TS"),
              type = "node2",
              request = "launch",
              cwd = vim.fn.getcwd(),
              runtimeArgs = isJs and {} or { "-r", "ts-node/register" },
              args = { "${file}" },
              sourceMaps = true,
              protocol = "inspector",
              console = "integratedTerminal",
            },
          }
        end
      end
    end,
  },
}
