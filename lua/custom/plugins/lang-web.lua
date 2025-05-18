local constants = require "custom.utils.constants"
local lspUtils = require "custom.utils.lsp"
local utils = require "custom.utils"

if vim.g.lazyvim_biome_needs_config == nil then
  vim.g.lazyvim_biome_needs_config = true
end
if vim.g.lazyvim_eslint_auto_format == nil then
  vim.g.lazyvim_eslint_auto_format = false
end
if vim.g.lazyvim_prettier_needs_config == nil then
  vim.g.lazyvim_prettier_needs_config = false
end

local prettier_supported = {
  "css",
  "graphql",
  "handlebars",
  "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "less",
  "markdown",
  "markdown.mdx",
  "scss",
  "typescript",
  "typescriptreact",
  "vue",
  "yaml",
}

local function has_prettier_config(ctx)
  vim.fn.system { "prettier", "--find-config-path", ctx.filename }
  return vim.v.shell_error == 0
end

local function has_biome_config(path)
  local has_biome = require("lspconfig.util").root_pattern("biome.json", "biome.jsonc")
  return has_biome(path)
end

-- source: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/formatting/prettier.lua
local function has_prettier_parser(ctx)
  local ft = vim.bo[ctx.buf].filetype --[[@as string]]
  -- default filetypes are always supported
  if vim.tbl_contains(prettier_supported, ft) then
    return true
  end
  -- otherwise, check if a parser can be inferred
  local ret = vim.fn.system { "prettierd", "--file-info", "'" .. ctx.filename .. "'" }
  ---@type boolean, string?
  local ok, parser = pcall(function()
    return vim.fn.json_decode(ret).inferredParser
  end)
  return ok and parser and parser ~= vim.NIL
end

local has_prettier_config = LazyVim.memoize(has_prettier_config)
local has_prettier_parser = LazyVim.memoize(has_prettier_parser)
local has_biome_config = LazyVim.memoize(has_biome_config)

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
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      vim.filetype.add {
        extension = {
          mdx = "markdown.mdx",
        },
      }
    end,
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
        tsserver = {
          enabled = false,
        },
        ts_ls = {
          enabled = false,
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
              "go",
              function()
                require("vtsls").commands.goto_source_definition(0)
              end,
              desc = "Goto Source Definition (Vtsls)",
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
              desc = "Add Missing Imports",
            },
            {
              "<leader>lu",
              function()
                require("vtsls").commands.remove_unused_imports(0)
              end,
              desc = "Remove Unused Imports",
            },
            {
              "<leader>lD",
              function()
                require("vtsls").commands.fix_all(0)
              end,
              desc = "Fix All Diagnostics",
            },
            {
              "<leader>lT",
              function()
                require("vtsls").commands.select_ts_version(0)
              end,
              desc = "Select TS Workspace Version",
            },
          },
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  -- PERF: vtsls sends a large number of completions
                  -- reducing this number makes blink.cmp fast again
                  enableServerSideFuzzyMatch = true,
                  entriesLimit = 20,
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
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = false },
                parameterNames = { enabled = "all" },
                parameterTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
              tsserver = {
                maxTsServerMemory = 8192,
              },
            },
          },
          flags = {
            debounce_text_changes = 250,
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
        biome = {
          condition = function()
            return has_biome_config(vim.uv.cwd())
          end,
        },
        eslint = {
          settings = {
            run = "onSave",
            -- validate = "off", -- disables diagnostics and code actions
            format = vim.g.lazyvim_eslint_auto_format,
            runtime = "node",
          },
          flags = {
            debounce_text_changes = 250,
          },
        },
        tailwindcss = {
          flags = {
            debounce_text_changes = 250,
          },
        },
      },
      setup = {
        tsserver = function()
          -- disable tsserver
          return true
        end,
        ts_ls = function()
          -- disable ts_ls
          return true
        end,
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
        "mason-org/mason.nvim",
        optional = true,
        opts = {
          ensure_installed = { "prettierd", "xmlformatter" },
        },
      },
    },
    opts = {
      -- https://biomejs.dev/internals/language-support/
      formatters_by_ft = {
        ["astro"] = { "biome" },
        ["css"] = { "biome", "prettierd" },
        ["graphql"] = { "biome", "prettierd" },
        ["handlebars"] = { "prettierd" },
        ["html"] = {
          -- "biome",
          "prettierd",
        },
        ["javascript"] = { "biome", "prettierd" },
        ["javascriptreact"] = { "biome", "prettierd" },
        ["json"] = { "biome", "prettierd" },
        ["jsonc"] = { "biome", "prettierd" },
        ["less"] = { "prettierd" },
        ["markdown"] = {
          -- "biome",
          "prettierd",
        },
        ["markdown.mdx"] = { "prettierd" },
        ["svelte"] = { "biome", "prettierd" },
        ["scss"] = { "prettierd" },
        ["typescript"] = { "biome", "prettierd" },
        ["typescriptreact"] = { "biome", "prettierd" },
        ["vue"] = { "biome", "prettierd" },
        ["yaml"] = {
          -- "biome",
          "prettierd",
        },
        ["xml"] = { "xmlformat" },
      },
      formatters = {
        prettierd = {
          condition = function(_, ctx)
            return has_prettier_parser(ctx)
              and (vim.g.lazyvim_prettier_needs_config ~= true or has_prettier_config(ctx))
          end,
        },
        biome = {
          condition = function(_, ctx)
            return vim.g.lazyvim_biome_needs_config ~= true or has_biome_config(ctx.dirname)
          end,
        },
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
              vim.fn.expand "$MASON/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
              "${port}",
            },
          },
        }
      end

      if not dap.adapters["node"] then
        dap.adapters["node"] = function(cb, config)
          if config.type == "node" then
            config.type = "pwa-node"
          end
          local nativeAdapter = dap.adapters["pwa-node"]
          if type(nativeAdapter) == "function" then
            nativeAdapter(cb, config)
          else
            cb(nativeAdapter)
          end
        end
      end

      if not dap.adapters["node2"] then
        -- very old nodejs adapter
        require("dap").adapters["node2"] = {
          type = "executable",
          command = "node",
          args = {
            vim.fn.expand "$MASON/packages/node-debug2-adapter/out/src/nodeDebug.js",
          },
        }
      end

      if not dap.adapters["chrome"] then
        require("dap").adapters["chrome"] = {
          type = "executable",
          command = "node",
          args = {
            vim.fn.expand "$MASON/packages/chrome-debug-adapter/out/src/chromeDebug.js",
          },
        }
      end

      local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
      local vscode = require "dap.ext.vscode"
      vscode.type_to_filetypes["node"] = js_filetypes
      vscode.type_to_filetypes["pwa-node"] = js_filetypes
      for _, language in ipairs(js_filetypes) do
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

  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "thenbe/neotest-playwright",
      -- "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
    },
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        adapters = {
          ["neotest-playwright"] = {
            options = {
              -- persist_project_selection = true,
              enable_dynamic_test_discovery = true,
            },
          },
          -- ["neotest-jest"] = {
          --   jestConfigFile = function(file)
          --     -- TODO: monorepo setup?
          --     local cwd = vim.fn.getcwd()
          --     if vim.uv.fs_stat(cwd .. "/jest.config.ts") then
          --       return cwd .. "/jest.config.ts"
          --     end
          --     return cwd .. "/jest.config.js"
          --   end,
          --   cwd = function(path)
          --     -- TODO: monorepo setup?
          --     return vim.fn.getcwd()
          --   end,
          -- },
          ["neotest-vitest"] = {},
        },
      })
    end,
  },
}
