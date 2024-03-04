local lspUtils = require "custom.utils.lsp"
local formatUtils = require "custom.utils.format"

return {
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      {
        "folke/neoconf.nvim",
        cmd = "Neoconf",
        config = false,
        dependencies = { "nvim-lspconfig" },
      },

      "mason.nvim",

      "williamboman/mason-lspconfig.nvim",
    },
    keys = {
      {
        "<leader>li",
        "<cmd>LspInfo<cr>",
        desc = "Lsp Info",
      },
    },
    init = function()
      local keys = require("custom.plugins.lsp.keymaps").get()
      keys[#keys + 1] = {
        "gr",
        "<cmd>Telescope lsp_references<cr>",
        desc = "References",
      }
      keys[#keys + 1] = {
        "gD",
        vim.lsp.buf.declaration,
        desc = "Goto Declaration",
      }
      keys[#keys + 1] = {
        "gd",
        function()
          require("telescope.builtin").lsp_definitions { reuse_win = false }
        end,
        desc = "Goto Definition",
        has = "definition",
      }
      keys[#keys + 1] = {
        "gI",
        function()
          require("telescope.builtin").lsp_implementations { reuse_win = false }
        end,
        desc = "Goto Implementation",
      }
      keys[#keys + 1] = {
        "gy",
        function()
          require("telescope.builtin").lsp_type_definitions { reuse_win = false }
        end,
        desc = "Goto T[y]pe Definition",
      }
      keys[#keys + 1] = {
        "gH",
        function()
          local winid = require("ufo").peekFoldedLinesUnderCursor()
          if not winid then
            vim.lsp.buf.hover()
          end
        end,
        desc = "Hover",
      }
      keys[#keys + 1] = {
        "gh",
        vim.lsp.buf.signature_help,
        desc = "Signature Help",
        has = "signatureHelp",
      }
      keys[#keys + 1] = {
        "<c-h>",
        vim.lsp.buf.signature_help,
        mode = "i",
        desc = "Signature Help",
        has = "signatureHelp",
      }
      keys[#keys + 1] = {
        "<leader>la",
        vim.lsp.buf.code_action,
        desc = "Code Action",
        mode = { "n", "v" },
        has = "codeAction",
      }
      keys[#keys + 1] = {
        "<leader>lA",
        function()
          vim.lsp.buf.code_action {
            context = {
              only = {
                "source",
              },
              diagnostics = {},
            },
          }
        end,
        desc = "Source Action",
        has = "codeAction",
      }
      keys[#keys + 1] = {
        "<leader>lr",
        function()
          local inc_rename = require "inc_rename"
          return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand "<cword>"
        end,
        expr = true,
        desc = "Rename",
        has = "rename",
      }
      keys[#keys + 1] = {
        "<leader>ld",
        function()
          vim.diagnostic.open_float()
        end,
        "floating diagnostic",
      }
      -- TODO: add mappings for error and warning movements
      keys[#keys + 1] = {
        "[d",
        function()
          vim.diagnostic.goto_prev()
        end,
        "prev diagnostic",
      }
      keys[#keys + 1] = {
        "]d",
        function()
          vim.diagnostic.goto_next()
        end,
        "next diagnostic",
      }
    end,
    opts = {
      -- add any global capabilities here
      capabilities = {
        textDocument = {
          -- ufo capabilities
          -- TODO: move to ufo config
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
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
      -- setup neoconf
      local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
      require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))

      -- setup lsp formatter
      formatUtils.register(lspUtils.formatter())

      -- setup keymaps
      lspUtils.on_attach(function(client, buffer)
        require("custom.plugins.lsp.keymaps").on_attach(client, buffer)
      end)
      local register_capability = vim.lsp.handlers["client/registerCapability"]
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
        local ret = register_capability(err, res, ctx)
        local client_id = ctx.client_id
        ---@type lsp.Client
        local client = vim.lsp.get_client_by_id(client_id)
        local buffer = vim.api.nvim_get_current_buf()
        require("custom.plugins.lsp.keymaps").on_attach(client, buffer)
        return ret
      end

      -- setup diagnostics
      vim.diagnostic.config {
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      }

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

      -- disable typescript-tools if project use deno
      -- source: https://github.com/LazyVim/LazyVim/blob/5b89bc8/lua/lazyvim/plugins/lsp/init.lua:197
      if lspUtils.get_config "denols" and lspUtils.get_config "typescript-tools" then
        local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
        lspUtils.disable("typescript-tools", is_deno)
        lspUtils.disable("denols", function(root_dir)
          return not is_deno(root_dir)
        end)
      end

      -- HACK: add `.volar` file at the root of your vue project to enable volar "Take Over Mode"
      -- disable typescript-tools if project has `.volar` file at the root
      if lspUtils.get_config "volar" and lspUtils.get_config "typescript-tools" then
        local is_vue = require("lspconfig.util").root_pattern ".volar"
        lspUtils.disable("typescript-tools", is_vue)
        lspUtils.disable("volar", function(root_dir)
          return not is_vue(root_dir)
        end)
      end
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    opts = {
      ensure_installed = {}, -- not an option from mason.nvim
      PATH = "skip",
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
    "folke/noice.nvim",
    event = "VeryLazy",
    keys = {
      -- scroll signature/hover windows
      {
        "<c-u>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-u>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll backward",
        mode = { "i", "n", "s" },
      },
      {
        "<c-d>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-d>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll forward",
        mode = { "i", "n", "s" },
      },
    },
    opts = {
      cmdline = {
        enabled = false,
      },
      messages = {
        enabled = false,
      },
      popupmenu = {
        enabled = false,
      },
      notify = {
        enabled = false,
      },
      lsp = {
        progress = {
          enabled = false,
        },
        message = {
          enabled = false,
        },
        hover = {
          enabled = true,
        },
        signature = {
          enabled = true,
          -- automatically show signature help when typing
          auto_open = {
            enabled = true,
          },
          opts = {
            -- TODO: add max_height and max_width, noice doesn't support them yet
            -- TODO: add border, noice doesn't position the window correctly with border enabled
          },
        },
        override = {
          -- better highlighting for lsp signature/hover windows
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
    },
  },

  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    opts = {},
  },

  {
    "smjonas/inc-rename.nvim",
    opts = {
      input_buffer_type = "dressing",
    },
  },

  {
    "RRethy/vim-illuminate",
    event = "LazyFile",
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
}
