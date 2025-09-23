local lspUtils = require "custom.utils.lsp"
local iconsUtils = require "custom.utils.icons"
local formatUtils = require "custom.utils.format"
local lspKeymapsUtils = require "custom.plugins.lsp.keymaps"
local constants = require "custom.utils.constants"

return {
  {
    "neovim/nvim-lspconfig",
    enabled = not constants.in_vi_edit and not constants.in_kittyscrollback,
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
    config = vim.schedule_wrap(function(_, opts)
      -- slow down log file growth
      vim.lsp.set_log_level(vim.log.levels.ERROR)

      -- setup lsp formatter
      formatUtils.register(lspUtils.formatter())

      -- setup keymaps
      lspUtils.on_attach(function(client, buffer)
        lspKeymapsUtils.on_attach(client, buffer)
      end)
      lspUtils.setup()
      lspUtils.on_dynamic_capability(lspKeymapsUtils.on_attach)

      -- setup diagnostics
      vim.diagnostic.config {
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
            [vim.diagnostic.severity.ERROR] = iconsUtils.diagnostic.Error,
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
      }
      for name, icon in pairs(iconsUtils.diagnostic) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end
      lspUtils.setup_mode_toggle(
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

      -- enable inlay hints
      if not constants.transparent_background then
        lspUtils.on_supports_method("textDocument/inlayHint", function(client, buffer)
          local is_ih_enabled_ok, is_ih_enabled = pcall(vim.api.nvim_buf_get_var, buffer, "is_ih_enabled")
          if is_ih_enabled_ok and not is_ih_enabled then
            return
          end
          if vim.api.nvim_buf_is_valid(buffer) and vim.bo[buffer].buftype == "" then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
        -- PERF: disable inlay hints on insert/visual mode because
        -- it gets executed on every stroke
        lspUtils.setup_mode_toggle(
          "inlay_hints",
          -- Disable function
          function(event)
            vim.lsp.inlay_hint.enable(false, { bufnr = event.buf })
          end,
          -- Enable function
          function(event)
            local is_ih_enabled_ok, is_ih_enabled = pcall(vim.api.nvim_buf_get_var, event.buf, "is_ih_enabled")
            if is_ih_enabled_ok and not is_ih_enabled then
              return
            end
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
          end
        )
      end

      -- setup opts.capabilities
      if opts.capabilities then
        vim.lsp.config("*", { capabilities = opts.capabilities })
      end

      -- setup opts.servers and opts.setup
      -- get all the servers that are available through mason-lspconfig
      local have_mason = LazyVim.has "mason-lspconfig.nvim"
      local mason_all = have_mason
          and vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package)
        or {} --[[ @as string[] ]]
      ---@return boolean? exclude automatic setup
      local function configure(server)
        local sopts = opts.servers[server]
        sopts = sopts == true and {} or (not sopts) and { enabled = false } or sopts --[[@as lazyvim.lsp.Config]]
        if sopts.enabled == false then
          return true
        end
        if sopts.condition and sopts.condition() == false then
          return true
        end
        local setup = opts.setup[server] or opts.setup["*"]
        if setup and setup(server, sopts) then
          return true -- lsp will be configured and enabled by the setup function
        end
        vim.lsp.config(server, sopts) -- configure the server
        -- manually enable if mason=false or if this is a server that cannot be installed with mason-lspconfig
        if sopts.mason == false or not vim.tbl_contains(mason_all, server) then
          vim.lsp.enable(server)
          return true
        end
      end
      local servers = vim.tbl_keys(opts.servers)
      local exclude = vim.tbl_filter(configure, servers)
      if have_mason then
        require("mason-lspconfig").setup {
          ensure_installed = vim.tbl_filter(function(server)
            return not vim.tbl_contains(exclude, server)
          end, vim.list_extend(servers, LazyVim.opts("mason-lspconfig.nvim").ensure_installed or {})),
          automatic_enable = { exclude = exclude },
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
    -- fork places virtual text at the end of line
    -- instead of above the line
    "wochap/lsp-lens.nvim",
    enabled = not constants.transparent_background,
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
