local utils = require "custom.utils"
local lspUtils = require "custom.utils.lsp"
local iconsUtils = require "custom.utils.icons"
local formatUtils = require "custom.utils.format"
local lspKeymapsUtils = require "custom.plugins.lsp.keymaps"
local constants = require "custom.utils.constants"

return {
  {
    "neovim/nvim-lspconfig",
    enabled = not constants.in_vi_edit and not constants.in_kittyscrollback,
    version = "v1.8.0",
    event = { "LazyFile", "VeryLazy" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
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
      -- NOTE: nvim-lspconfig doesn't have the option `format`
      -- options for vim.lsp.buf.format
      format = {
        async = true,
        -- timeout_ms = 1000, -- doesn't have effect if async is true
        formatting_options = nil,
      },
      -- NOTE: nvim-lspconfig doesn't have the option `capabilities`
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
      -- NOTE: nvim-lspconfig doesn't have the option `servers`
      -- LSP Server Settings
      servers = {
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
    config = function(_, opts)
      -- slow down log file growth
      vim.lsp.set_log_level(vim.log.levels.ERROR)

      -- setup lsp formatter
      formatUtils.register(lspUtils.formatter())

      -- setup keymaps
      lspUtils.on_attach(function(client, buffer)
        lspKeymapsUtils.on_attach(client, buffer)
      end)
      local register_capability = vim.lsp.handlers["client/registerCapability"]
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
        local ret = register_capability(err, res, ctx)
        local client_id = ctx.client_id
        local client = vim.lsp.get_client_by_id(client_id)
        local buffer = vim.api.nvim_get_current_buf()
        lspKeymapsUtils.on_attach(client, buffer)
        return ret
      end

      -- setup diagnostics
      local diagnostic_signs_opts
      local diagnostic_virtual_text_opts
      local diagnostic_virtual_lines_opts
      if vim.fn.has "nvim-0.11" == 1 then
        diagnostic_signs_opts = {
          text = {
            [vim.diagnostic.severity.ERROR] = iconsUtils.diagnostic.Error,
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
          },
        }
        diagnostic_virtual_text_opts = {
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
        }
        diagnostic_virtual_lines_opts = {
          current_line = false,
          format = function(diagnostic)
            return string.format("%s (%s)", diagnostic.message, diagnostic.source)
          end,
          severity = {
            min = vim.diagnostic.severity.ERROR,
          },
        }
      else
        diagnostic_signs_opts = false
        diagnostic_virtual_text_opts = {
          current_line = false,
          format = function(diagnostic)
            return string.format("%s (%s)", diagnostic.message, diagnostic.source)
          end,
          prefix = "●",
          suffix = "",
          spacing = 0,
          source = false,
          severity = {
            min = vim.diagnostic.severity.WARN,
          },
        }
        diagnostic_virtual_lines_opts = false
      end
      vim.diagnostic.config {
        underline = true,
        update_in_insert = false,
        virtual_text = diagnostic_virtual_text_opts,
        signs = diagnostic_signs_opts,
        severity_sort = true,
        float = {
          border = "rounded",
          format = function(diagnostic)
            return string.format("%s (%s)", diagnostic.message, diagnostic.source)
          end,
        },
        virtual_lines = diagnostic_virtual_lines_opts,
      }
      for name, icon in pairs(iconsUtils.diagnostic) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end
      utils.autocmd("InsertEnter", {
        group = utils.augroup "disable_diagnostic",
        pattern = "*",
        callback = function()
          vim.schedule(function()
            vim.diagnostic.config {
              underline = false,
            }
          end)
        end,
      })
      utils.autocmd("InsertLeave", {
        group = utils.augroup "enable_diagnostic",
        pattern = "*",
        callback = function()
          -- NOTE: it doesn't work well on JS files without the vim.schedule
          vim.schedule(function()
            vim.diagnostic.config {
              underline = true,
            }
          end)
        end,
      })
      utils.autocmd("ModeChanged", {
        group = utils.augroup "disable_disagnostic_on_visual_mode_enter",
        pattern = "*:[vV]",
        callback = function(event)
          local cur_mode = vim.fn.mode()
          if cur_mode ~= "v" and cur_mode ~= "V" then
            return
          end

          vim.schedule(function()
            vim.diagnostic.config {
              underline = false,
            }
          end)
        end,
      })
      utils.autocmd("ModeChanged", {
        group = utils.augroup "enable_diagnostic_on_visual_mode_leave",
        pattern = "[vV]:*",
        callback = function(event)
          vim.schedule(function()
            vim.schedule(function()
              vim.diagnostic.config {
                underline = true,
              }
            end)
          end)
        end,
      })

      -- enable inlay hints
      lspUtils.on_attach(function(client, buffer)
        if client.supports_method "textDocument/inlayHint" then
          local is_ih_enabled_ok, is_ih_enabled = pcall(vim.api.nvim_buf_get_var, buffer, "is_ih_enabled")
          if is_ih_enabled_ok and not is_ih_enabled then
            return
          end
          if vim.api.nvim_buf_is_valid(buffer) and vim.bo[buffer].buftype == "" then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end
      end)
      -- PERF: disable inlay hints on insert mode because
      -- it gets executed on every stroke
      utils.autocmd("InsertEnter", {
        group = utils.augroup "disable_inlay_hints",
        pattern = "*",
        callback = function(event)
          vim.schedule(function()
            vim.lsp.inlay_hint.enable(false, { bufnr = event.buf })
          end)
        end,
      })
      utils.autocmd("InsertLeave", {
        group = utils.augroup "enable_inlay_hints",
        pattern = "*",
        callback = function(event)
          vim.schedule(function()
            local is_ih_enabled_ok, is_ih_enabled = pcall(vim.api.nvim_buf_get_var, event.buf, "is_ih_enabled")
            if is_ih_enabled_ok and not is_ih_enabled then
              return
            end
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
          end)
        end,
      })
      utils.autocmd("ModeChanged", {
        group = utils.augroup "disable_inlay_hints_on_visual_mode_enter",
        pattern = "*:[vV]",
        callback = function(event)
          local cur_mode = vim.fn.mode()
          if cur_mode ~= "v" and cur_mode ~= "V" then
            return
          end

          vim.schedule(function()
            vim.lsp.inlay_hint.enable(false, { bufnr = event.buf })
          end)
        end,
      })
      utils.autocmd("ModeChanged", {
        group = utils.augroup "enable_inlay_hints_on_visual_mode_leave",
        pattern = "[vV]:*",
        callback = function(event)
          vim.schedule(function()
            local is_ih_enabled_ok, is_ih_enabled = pcall(vim.api.nvim_buf_get_var, event.buf, "is_ih_enabled")
            if is_ih_enabled_ok and not is_ih_enabled then
              return
            end
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
          end)
        end,
      })

      -- setup opts.servers and opts.setup
      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local has_blink, blink = pcall(require, "blink.cmp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        has_blink and blink.get_lsp_capabilities() or {},
        opts.capabilities or {}
      )
      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if server_opts.enabled == false then
          return
        end

        if server_opts.condition and server_opts.condition() == false then
          return
        end

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end
      local has_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if has_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
        -- all_mslp_servers = vim.tbl_keys(require("mason-lspconfig").get_mappings().lspconfig_to_package)
      end
      local ensure_installed = {}
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
            if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
              setup(server)
            else
              ensure_installed[#ensure_installed + 1] = server
            end
          end
        end
      end
      if has_mason then
        mlsp.setup {
          ensure_installed = ensure_installed,
          handlers = { setup },
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
          lspUtils.toggle_inlay_hints(0, enabled)
        end,
      }):map "<leader>uh"
    end,
  },

  {
    "mason-org/mason.nvim",
    version = "v1.11.0",
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
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          -- if not p:is_installed() and not p:is_installing() then
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    version = "v1.32.0",
  },

  {
    -- fork places virtual text at the end of line
    -- instead of above the line
    "wochap/lsp-lens.nvim",
    event = "LspAttach",
    opts = {
      enable = true,
      include_declaration = false,
      sections = {
        definition = false,
        references = function(count)
          return "  " .. count .. " "
        end,
        implements = false,
        git_authors = false,
      },
    },
    config = function(_, opts)
      require("lsp-lens").setup(opts)

      -- override lsp_lens augroup, update its event list
      local lens = require "lsp-lens.lens-util"
      local augroup = vim.api.nvim_create_augroup("lsp_lens", { clear = true })
      vim.api.nvim_create_autocmd({ "LspAttach", "InsertLeave", "CursorHold", "BufEnter" }, {
        group = augroup,
        callback = function(...)
          local mode = vim.api.nvim_get_mode().mode
          -- Only run if not in insert mode
          if mode ~= "i" then
            lens.procedure(...)
          end
        end,
      })

      -- TODO: check if the buffer's LSP supports `codeLens`
      -- before adding a keymap to the buffer
      Snacks.toggle({
        name = "Codelens",
        get = function()
          return require("lsp-lens.config").config.enable
        end,
        set = function(enabled)
          if enabled then
            lens.lsp_lens_on()
          else
            lens.lsp_lens_off()
          end
        end,
      }):map "<leader>uC"
    end,
  },

  {
    "chrisgrieser/nvim-lsp-endhints",
    event = "LspAttach",
    opts = {
      icons = {
        type = " ",
        parameter = " ",
      },
      autoEnableHints = false,
    },
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
