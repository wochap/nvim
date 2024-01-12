local plugins = {
  { import = "lazyvim.plugins.extras.lang.tailwind" },
  { import = "lazyvim.plugins.extras.linting.eslint" },

  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      -- "rafamadriz/friendly-snippets",
      "sdras/vue-vscode-snippets",
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
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
        cssls = {},
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
        ["typescript-tools"] = {
          mason = false,
          keys = {
            { "<leader>lo", "<cmd>TSToolsOrganizeImports<cr>", desc = "Organize Imports" },
            { "<leader>lu", "<cmd>TSToolsRemoveUnusedImports<cr>", desc = "Remove Unused Imports" },
            { "<leader>lR", "<cmd>TSToolsRenameFile<cr>", desc = "Rename File" },
            { "<leader>ls", "<cmd>TSToolsSortImports<cr>", desc = "Sort Imports" },
            { "<leader>lm", "<cmd>TSToolsAddMissingImports<cr>", desc = "Add Missing Imports" },
            { "gd", "<cmd>TSToolsGoToSourceDefinition<cr>", desc = "Goto Source Definition" },
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
              "@styled/typescript-styled-plugin",
            },
          },
        },
        volar = {
          filetypes = {
            "javascript",
            "javascript.jsx",
            "javascriptreact",
            "json",
            "typescript",
            "typescript.tsx",
            "typescriptreact",
            "vue",
          },
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true,
              },
            },
          },
          on_new_config = function(new_config, new_root_dir)
            local util = require "lspconfig.util"
            local function get_typescript_server_path(root_dir)
              local homeDir = os.getenv "HOME"
              local global_ts = homeDir .. "/.npm/lib/node_modules/typescript/lib"
              -- Alternative location if installed as root:
              -- local global_ts = '/usr/local/lib/node_modules/typescript/lib'
              local found_ts = ""
              local function check_dir(path)
                found_ts = util.path.join(path, "node_modules", "typescript", "lib")
                if util.path.exists(found_ts) then
                  return path
                end
              end
              if util.search_ancestors(root_dir, check_dir) then
                return found_ts
              else
                return global_ts
              end
            end
            new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
          end,
        },
        eslint = {
          settings = {
            run = "onSave",
          },
        },
      },
      setup = {
        tsserver = function()
          -- typescript-tools.nvim will handle tsserver
          -- NOTE: typescript-tools.nvim will not spawn a tsserver client, it will spawn typescript-tools client
          return true
        end,
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
        opts = function(_, opts)
          table.insert(opts.ensure_installed, "prettierd")
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

return plugins
