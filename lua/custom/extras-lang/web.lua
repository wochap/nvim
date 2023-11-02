local plugins = {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "css",
        "graphql",
        "html",
        "javascript",
        "svelte",
        "tsx",
        "typescript",
      })
    end,
  },

  { "jose-elias-alvarez/typescript.nvim" },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        html = { filetypes = { "xhtml", "html" } },
        cssls = {},
        svelte = {},
        cssmodules_ls = {},
        emmet_language_server = {
          filetypes = {
            "html",
            "xhtml",
            "xml",
            "css",
            "sass",
            "scss",
            "less",
          },
          init_options = {
            showSuggestionsAsSnippets = true,
          },
        },
        tailwindcss = {
          -- exclude a filetype from the default_config
          filetypes_exclude = { "markdown" },
          -- add additional filetypes to the default_config
          filetypes_include = {},
          -- to fully override the default_config, change the below
          -- filetypes = {}
        },
        tsserver = {
          on_attach = function(client, bufnr)
            -- disable tsserver's inbuilt formatting
            -- since I use null-ls for formatting
            client.server_capabilities.documentFormattingProvider = false

            -- enable document_highlight
            client.server_capabilities.document_highlight = true

            require("core.utils").load_mappings("lspconfig_tsserver", { buffer = bufnr })
          end,
          settings = {
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
          },
        },
      },
      setup = {
        tsserver = function(_, opts)
          require("typescript").setup(opts)
        end,
        tailwindcss = function(_, opts)
          local tw = require "lspconfig.server_configurations.tailwindcss"
          opts.filetypes = opts.filetypes or {}

          -- Add default filetypes
          vim.list_extend(opts.filetypes, tw.default_config.filetypes)

          -- Remove excluded filetypes
          --- @param ft string
          opts.filetypes = vim.tbl_filter(function(ft)
            return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
          end, opts.filetypes)

          -- Add additional filetypes
          vim.list_extend(opts.filetypes, opts.filetypes_include or {})
        end,
      },
    },
  },

  {
    "hrsh7th/nvim-cmp",
    optional = true,
    dependencies = {
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
    },
    opts = function(_, opts)
      -- original kind icon formatter
      local format_kinds = opts.formatting.format
      opts.formatting.format = function(entry, item)
        format_kinds(entry, item) -- add icons
        return require("tailwindcss-colorizer-cmp").formatter(entry, item)
      end
    end,
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
              runtimeArgs = (isJs and nil or { "-r", "ts-node/register" }),
              sourceMaps = true,
              protocol = "inspector",
              skipFiles = { "<node_internals>/**/*.js" },
            },
            {
              name = "node2: Launch file" .. (isJs and "" or " TS"),
              type = "node2",
              request = "launch",
              cwd = vim.fn.getcwd(),
              runtimeArgs = isJs and nil or { "-r", "ts-node/register" },
              args = isJs and nil or { "${file}" },
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
