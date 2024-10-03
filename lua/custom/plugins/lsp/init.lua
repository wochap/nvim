local utils = require "custom.utils"
local lspUtils = require "custom.utils.lsp"
local iconsUtils = require "custom.utils.icons"
local formatUtils = require "custom.utils.format"
local lspKeymapsUtils = require "custom.plugins.lsp.keymaps"

return {
  {
    "neovim/nvim-lspconfig",
    event = { "LazyFile", "VeryLazy" },
    dependencies = {
      {
        "folke/neoconf.nvim",
        cmd = "Neoconf",
        opts = {
          import = {
            vscode = true,
            coc = false,
            nlsp = false,
          },
        },
      },

      "mason.nvim",

      "williamboman/mason-lspconfig.nvim",
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
        },
      },
      -- NOTE: nvim-lspconfig doesn't have the option `servers`
      -- LSP Server Settings
      servers = {
        -- example to setup with lua_ls
        -- lua_ls = {
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
      vim.diagnostic.config {
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        signs = false, -- PERF: a lot of signs causes lag
        severity_sort = true,
        float = {
          border = "single",
          format = function(diagnostic)
            return string.format("%s (%s)", diagnostic.message, diagnostic.source)
          end,
        },
      }
      for name, icon in pairs(iconsUtils.diagnostic) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end
      utils.autocmd("InsertEnter", {
        group = utils.augroup "hide_underline_diagnostic",
        pattern = "*",
        callback = function()
          vim.schedule(function()
            vim.diagnostic.config { underline = false }
          end)
        end,
      })
      utils.autocmd("InsertLeave", {
        group = utils.augroup "show_underline_diagnostic",
        pattern = "*",
        callback = function()
          -- NOTE: it doesn't work well on JS files without the vim.schedule
          vim.schedule(function()
            vim.diagnostic.config { underline = true }
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

      -- setup opts.servers and opts.setup
      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        opts.capabilities or {}
      )
      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

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
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end
      local ensure_installed = {}
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end
      if have_mason then
        mlsp.setup { ensure_installed = ensure_installed, handlers = { setup } }
      end
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    opts_extend = { "ensure_installed" },
    opts = {
      -- NOTE: mason.nvim doesn't have the option `ensure_installed`
      ensure_installed = {},
      ui = {
        icons = {
          package_pending = " ",
          package_installed = "󰄳 ",
          package_uninstalled = " 󰚌",
        },
      },
      max_concurrent_installers = 10,
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
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {
      preview_empty_name = true,
    },
  },
  {
    "wochap/noice.nvim",
    optional = true,
    opts = {
      cmdline = {
        format = {
          IncRename = {
            pattern = "^:%s*IncRename%s+",
            icon = " ",
            conceal = true,
            opts = {
              relative = "cursor",
              size = { min_width = 20 },
              position = { row = -2, col = 2 },
            },
          },
        },
      },
    },
  },

  {
    "RRethy/vim-illuminate",
    keys = {
      {
        "]]",
        function()
          require("illuminate").goto_next_reference(false)
        end,
        desc = "Next Reference",
      },
      {
        "[[",
        function()
          require("illuminate").goto_prev_reference(false)
        end,
        desc = "Prev Reference",
      },
    },
    opts = {
      delay = 200,
      under_cursor = false,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },

  {
    "wochap/lsp-lens.nvim",
    event = { "LazyFile", "VeryLazy" },
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
        callback = lens.procedure,
      })
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
      telescope = {
        layout_strategy = "vertical",
        layout_config = {
          vertical = {
            prompt_position = "top",
            preview_width = 0.55,
          },
        },
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
}
