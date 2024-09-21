local constants = require "custom.utils.constants"
local lspUtils = require "custom.utils.lsp"
local utils = require "custom.utils"

return {
  {
    enabled = not constants.first_install,
    import = "lazyvim.plugins.extras.lang.tailwind",
  },
  {
    enabled = not constants.first_install,
    import = "lazyvim.plugins.extras.linting.eslint",
  },

  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = {
        "astro",
        "css",
        "graphql",
        "html",
        "javascript",
        "scss",
        "svelte",
        "tsx",
        "typescript",
        "vue",
        "xml",
      },
    },
  },

  {
    "yioneko/nvim-vtsls",
    opts = {},
    config = function(_, opts)
      require("vtsls").config(opts)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        html = { filetypes = { "xhtml", "html" } },
        cssls = {
          init_options = {
            provideFormatter = false,
          },
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
        vtsls = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
            "vue",
          },
          keys = {
            {
              "gS",
              function()
                require("vtsls").commands.goto_source_definition(0)
              end,
              desc = "Goto Source Definition",
            },
            {
              "gR",
              function()
                require("vtsls").commands.file_references(0)
              end,
              desc = "File References",
            },
            {
              "<leader>lo",
              function()
                require("vtsls").commands.organize_imports(0)
              end,
              desc = "Organize Imports",
            },
            {
              "<leader>lm",
              function()
                require("vtsls").commands.add_missing_imports(0)
              end,
              desc = "Add missing imports",
            },
            {
              "<leader>lu",
              function()
                require("vtsls").commands.remove_unused_imports(0)
              end,
              desc = "Remove unused imports",
            },
            {
              "<leader>lD",
              function()
                require("vtsls").commands.fix_all(0)
              end,
              desc = "Fix all diagnostics",
            },
            {
              "<leader>lT",
              function()
                require("vtsls").commands.select_ts_version(0)
              end,
              desc = "Select TS workspace version",
            },
          },
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
              tsserver = {
                globalPlugins = {
                  {
                    name = "@vue/typescript-plugin",
                    location = lspUtils.get_pkg_path("vue-language-server", "/node_modules/@vue/language-server"),
                    languages = { "vue" },
                    configNamespace = "typescript",
                    enableForWorkspaceTypeScriptVersions = true,
                  },
                },
              },
            },
            typescript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
              preferences = { importModuleSpecifier = "non-relative" },
              updateImportsOnFileMove = { enabled = "always" },
              suggest = { completeFunctionCalls = true },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = false },
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
        },
        volar = {
          filetypes = { "vue" },
          init_options = {
            vue = {
              hybridMode = true,
            },
          },
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
        vtsls = function(_, opts)
          -- set default server config, recommended by yioneko/nvim-vtsls
          require("lspconfig.configs").vtsls = require("vtsls").lspconfig

          -- copy typescript settings to javascript
          opts.settings.javascript =
            vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
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
        opts = {
          ensure_installed = { "prettierd", "xmlformatter" },
        },
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
        opts = {
          ensure_installed = { "chrome", "js", "node2" },
        },
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

  {
    "echasnovski/mini.icons",
    opts = {
      file = {
        [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
        [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
        [".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
        ["eslint.config.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
        ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
      },
    },
  },

  {
    "mattn/emmet-vim",
    event = "VeryLazy",
    cmd = "EmmetInstall",
    init = function()
      vim.g.user_emmet_install_global = 0
      vim.g.user_emmet_leader_key = "<C-z>"
      vim.g.user_emmet_mode = "i"

      utils.autocmd("FileType", {
        group = utils.augroup "install_emmet",
        pattern = {
          "astro",
          "css",
          "eruby",
          "html",
          "xhtml",
          "xml",
          "htmldjango",
          "javascript",
          "javascriptreact",
          "less",
          "pug",
          "sass",
          "scss",
          "svelte",
          "typescript",
          "typescriptreact",
          "vue",
        },
        callback = function()
          vim.cmd [[ EmmetInstall ]]
        end,
      })
    end,
  },
}
