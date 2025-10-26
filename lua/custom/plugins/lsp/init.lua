local constants = require "custom.constants"
local icons_constants = require "custom.constants.icons"
local lazy_utils = require "custom.utils.lazy"
local lsp_utils = require "custom.utils.lsp"
local format_utils = require "custom.utils.format"
local blink_cmp_utils = require "custom.utils-plugins.blink-cmp"

return {
  {
    "neovim/nvim-lspconfig",
    enabled = not constants.in_vi_edit and not constants.in_kittyscrollback,
    event = { "LazyFile", "VeryLazy" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    opts_extend = { "servers.*.keys" },
    keys = {
      {
        "<leader>l",
        "",
        desc = "lsp",
        mode = { "n", "v" },
      },

      -- NOTE: more keys in ./keymaps.lua
      {
        "<leader>li",
        "<cmd>LspInfo<cr>",
        desc = "Lsp Info",
      },
      {
        "<leader>ll",
        "<cmd>LspLog<cr>",
        desc = "Lsp Log",
      },
    },
    opts = {
      -- NOTE: nvim-lspconfig doesn't have the option `default_format_opts`
      -- options for conform.nvim
      default_format_opts = {
        async = true,
        -- timeout_ms = 1000, -- doesn't have effect if async is true
        formatting_options = nil,
      },
      -- NOTE: nvim-lspconfig doesn't have the option `diagnostics`
      -- options for vim.diagnostic.config
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          current_line = true,
          format = function(diagnostic)
            return string.format("%s (%s)", diagnostic.message, diagnostic.source)
          end,
          prefix = "●",
          suffix = "",
          spacing = 0,
          source = false,
          severity = {
            max = vim.diagnostic.severity.WARN,
          },
          virt_text_pos = "eol_right_align",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = icons_constants.diagnostic.Error,
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
          },
        },
        severity_sort = true,
        float = {
          border = "rounded",
          format = function(diagnostic)
            return string.format("%s (%s)", diagnostic.message, diagnostic.source)
          end,
        },
        virtual_lines = {
          current_line = false,
          format = function(diagnostic)
            return string.format("%s (%s)", diagnostic.message, diagnostic.source)
          end,
          severity = {
            min = vim.diagnostic.severity.ERROR,
          },
        },
      },
      -- NOTE: nvim-lspconfig doesn't have the option `servers`
      -- LSP Server Settings
      servers = {
        ["*"] = {
          -- add any global capabilities here
          capabilities = {
            textDocument = {
              -- autocompletion
              completion = {
                completionItem = {
                  documentationFormat = { "markdown", "plaintext" },
                  snippetSupport = true,
                  preselectSupport = true,
                  insertReplaceSupport = true,
                  labelDetailsSupport = true,
                  deprecatedSupport = true,
                  commitCharactersSupport = true,
                  tagSupport = { valueSet = { 1 } },
                  resolveSupport = {
                    properties = {
                      "documentation",
                      "detail",
                      "additionalTextEdits",
                    },
                  },
                },
              },

              -- folds
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },

            -- rename
            workspace = {
              fileOperations = {
                didRename = true,
                willRename = true,
              },
            },
          },

          -- add any global keys here
          keys = {
            {
              "gr",
              function()
                Snacks.picker.lsp_references {
                  jump = { reuse_win = false },
                }
              end,
              desc = "References",
              nowait = true,
            },
            {
              "gD",
              function()
                Snacks.picker.lsp_declarations {
                  jump = { reuse_win = false },
                }
              end,
              desc = "Goto Declaration",
              has = "declaration",
            },
            {
              "gd",
              function()
                Snacks.picker.lsp_definitions {
                  jump = { reuse_win = false },
                }
              end,
              desc = "Goto Definition",
              has = "definition",
            },
            {
              "gI",
              function()
                Snacks.picker.lsp_implementations {
                  jump = { reuse_win = false },
                }
              end,
              desc = "Goto Implementation",
            },
            {
              "gy",
              function()
                Snacks.picker.lsp_type_definitions {
                  jump = { reuse_win = false },
                }
              end,
              desc = "Goto Type Definition",
            },
            {
              "gH",
              function()
                vim.lsp.buf.hover()
              end,
              desc = "Hover",
            },
            {
              "gh",
              function()
                blink_cmp_utils.show_signature()
              end,
              desc = "Signature Help",
              has = "signatureHelp",
            },
            {
              "<c-h>",
              function()
                blink_cmp_utils.show_signature()
              end,
              mode = "i",
              desc = "Signature Help",
              has = "signatureHelp",
            },
            {
              "<leader>la",
              function()
                require("actions-preview").code_actions()
              end,
              desc = "Code Action",
              mode = { "n", "v" },
              has = "codeAction",
            },
            {
              "<leader>lA",
              function()
                require("actions-preview").code_actions { context = { only = { "source" } } }
              end,
              desc = "Source Action",
              has = "codeAction",
            },
            {
              "<leader>lr",
              function()
                vim.lsp.buf.rename()
                -- save all buffers after rename
                vim.cmd "silent! wa"
              end,
              expr = true,
              desc = "Rename (Word)",
              has = "rename",
            },
            {
              "<leader>lR",
              function()
                Snacks.rename.rename_file()
              end,
              desc = "Rename (Buffer)",
              has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
            },
            { "<leader>ld", vim.diagnostic.open_float, desc = "Diagnostic" },
            { "[d", lsp_utils.diagnostic_goto(false), desc = "Prev Diagnostic" },
            { "]d", lsp_utils.diagnostic_goto(true), desc = "Next Diagnostic" },
            { "[e", lsp_utils.diagnostic_goto(false, "ERROR"), desc = "Prev Diagnostic (Error)" },
            { "]e", lsp_utils.diagnostic_goto(true, "ERROR"), desc = "Next Diagnostic (Error)" },
          },
        },

        -- example to setup with lua_ls
        -- lua_ls = {
        --   enabled = false, -- set to false if you don't want this server
        --   condition = function () return true end, -- return false if you don't want this server
        --   mason = false, -- set to false if you don't want this server to be installed with mason
        --   Use this to add any additional keymaps
        --   for specific lsp servers
        --   keys = {},
        --   settings = {
        --     Lua = {
        --       workspace = {
        --         checkThirdParty = false,
        --       },
        --     },
        --   },
        -- },
      },
      -- NOTE: nvim-lspconfig doesn't have the option `setup`
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
    config = vim.schedule_wrap(function(_, opts)
      -- slow down log file growth
      vim.lsp.set_log_level(vim.log.levels.ERROR)

      -- setup lsp formatter
      format_utils.register(lsp_utils.formatter())

      -- setup keymaps
      for server, server_opts in pairs(opts.servers) do
        if type(server_opts) == "table" and server_opts.keys then
          lsp_utils.keymap_set({ name = server ~= "*" and server or nil }, server_opts.keys)
        end
      end

      -- setup diagnostics
      vim.diagnostic.config(opts.diagnostics)
      lsp_utils.setup_mode_toggle(
        "diagnostics",
        -- Disable function
        function()
          vim.diagnostic.config { underline = false }
        end,
        -- Enable function
        function()
          vim.diagnostic.config { underline = true }
        end
      )

      -- setup folds
      Snacks.util.lsp.on({ method = "textDocument/foldingRange" }, function()
        vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
      end)

      if opts.servers["*"] then
        vim.lsp.config("*", opts.servers["*"])
      end

      -- setup opts.servers and opts.setup
      -- get all the servers that are available through mason-lspconfig
      local have_mason = lazy_utils.has "mason-lspconfig.nvim"
      local mason_all = have_mason
          and vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package)
        or {} --[[ @as string[] ]]
      local mason_exclude = {} ---@type string[]
      ---@return boolean? exclude automatic setup
      local function configure(server)
        if server == "*" then
          return false
        end
        local sopts = opts.servers[server]
        sopts = sopts == true and {} or (not sopts) and { enabled = false } or sopts --[[@as lazyvim.lsp.Config]]
        if sopts.enabled == false then
          mason_exclude[#mason_exclude + 1] = server
          return
        end
        -- NOTE: condition isn't part of LazyVim
        if sopts.condition and sopts.condition() == false then
          mason_exclude[#mason_exclude + 1] = server
          return
        end
        local use_mason = sopts.mason ~= false and vim.tbl_contains(mason_all, server)
        local setup = opts.setup[server] or opts.setup["*"]
        if setup and setup(server, sopts) then
          mason_exclude[#mason_exclude + 1] = server
        else
          vim.lsp.config(server, sopts) -- configure the server
          if not use_mason then
            vim.lsp.enable(server)
          end
        end
        return use_mason
      end
      local install = vim.tbl_filter(configure, vim.tbl_keys(opts.servers))
      if have_mason then
        require("mason-lspconfig").setup {
          ensure_installed = vim.list_extend(install, LazyVim.opts("mason-lspconfig.nvim").ensure_installed or {}),
          automatic_enable = { exclude = mason_exclude },
        }
      end

      -- add toggle keymap for diagnostics
      Snacks.toggle.diagnostics():map "<leader>ud"

      -- add toggle keymap for inlay hints
      -- TODO: check if the buffer's LSP supports `inlayHint`
      -- before adding a keymap to the buffer
      Snacks.toggle({
        name = "Inlay Hints",
        get = function()
          return vim.lsp.inlay_hint.is_enabled { bufnr = 0 }
        end,
        set = function(enabled)
          lsp_utils.toggle_inlay_hints(0, enabled)
        end,
      }):map "<leader>uh"
    end),
  },

  {
    "mason-org/mason.nvim",
    keys = {
      {
        "<leader>lm",
        "<cmd>Mason<CR>",
        desc = "Mason",
      },
      {
        "<leader>M",
        "<cmd>Mason<CR>",
        desc = "Mason",
      },
    },
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    opts_extend = { "ensure_installed" },
    opts = {
      -- NOTE: mason.nvim doesn't have the option `ensure_installed`
      ensure_installed = {},
      ui = {
        width = constants.width_fullscreen,
        height = constants.height_fullscreen,
        backdrop = 60,
        icons = {
          package_pending = "",
          package_installed = "●",
          package_uninstalled = "○",
        },
      },
      max_concurrent_installers = 10,
      -- slow down log file growth
      log_level = vim.log.levels.ERROR,
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require "mason-registry"
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger {
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          }
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    config = function() end,
  },

  {
    "aznhe21/actions-preview.nvim",
    opts = {
      backend = { "snacks", "nui" },
      snacks = {
        layout = "vertical",
      },
    },
    config = function(_, opts)
      local hl = require "actions-preview.highlight"
      opts.highlight_command = {
        hl.delta "delta --dark --paging=never",
      }
      require("actions-preview").setup(opts)
    end,
  },

  {
    "folke/snacks.nvim",
    optional = true,
    keys = {
      {
        "]]",
        function()
          Snacks.words.jump(1)
        end,
        desc = "Next Reference",
      },
      {
        "[[",
        function()
          Snacks.words.jump(-1)
        end,
        desc = "Prev Reference",
      },
    },
    opts = {
      words = {
        enabled = true,
      },
    },
  },
}
