local M = {}

local get_opts = require("custom.utils.lsp").get_opts
local on_attach = get_opts().on_attach
local handlers = {
  function(server_name)
    local opts = get_opts()

    require("lspconfig")[server_name].setup(opts)
  end,

  ["tsserver"] = function()
    local typescript_opts = require("lazyvim.util").opts "typescript.nvim"
    require("typescript").setup(typescript_opts)
  end,

  ["rnix"] = function()
    local opts = get_opts()

    opts.on_attach = function(client, bufnr)
      -- Run nvchad's attach
      on_attach(client, bufnr)

      -- disable server inbuilt formatting
      -- since I use null-ls for formatting
      client.server_capabilities.documentFormattingProvider = false
    end

    require("lspconfig").rnix.setup(opts)
  end,

  ["jsonls"] = function()
    local opts = get_opts()

    opts.on_attach = function(client, bufnr)
      -- Run nvchad's attach
      on_attach(client, bufnr)

      -- disable server inbuilt formatting
      -- since I use null-ls for formatting
      client.server_capabilities.documentFormattingProvider = false
    end

    -- lazy-load schemastore when needed
    opts.on_new_config = function(new_config)
      new_config.settings.json.schemas = new_config.settings.json.schemas or {}
      vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
    end
    opts.settings = {
      json = {
        format = {
          enable = false,
        },
        validate = {
          enable = true,
        },
      },
    }

    require("lspconfig").jsonls.setup(opts)
  end,

  ["yamlls"] = function()
    local opts = get_opts()

    opts.on_attach = function(client, bufnr)
      -- Run nvchad's attach
      on_attach(client, bufnr)

      -- disable server inbuilt formatting
      -- since I use null-ls for formatting
      client.server_capabilities.documentFormattingProvider = false
    end

    -- lazy-load schemastore when needed
    opts.on_new_config = function(new_config)
      new_config.settings.yaml.schemas = new_config.settings.yaml.schemas or {}
      vim.list_extend(new_config.settings.yaml.schemas, require("schemastore").yaml.schemas())
    end
    opts.settings = {
      redhat = { telemetry = { enabled = false } },
      yaml = {
        keyOrdering = false,
        format = {
          enable = false,
        },
        validate = true,
        schemaStore = {
          -- Must disable built-in schemaStore support to use
          -- schemas from SchemaStore.nvim plugin
          enable = false,
          -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
          url = "",
        },
      },
    }

    require("lspconfig").jsonls.setup(opts)
  end,

  ["emmet_language_server"] = function()
    local opts = get_opts()

    opts.filetypes = {
      "html",
      "xhtml",
      "xml",
      "css",
      "sass",
      "scss",
      "less",
    }
    opts.init_options = {
      showSuggestionsAsSnippets = true,
    }

    require("lspconfig").emmet_language_server.setup(opts)
  end,

  ["lua_ls"] = function()
    local opts = get_opts()

    opts.settings = {
      Lua = {
        workspace = {
          checkThirdParty = false,
        },
        completion = {
          callSnippet = "Replace",
        },
        diagnostics = {
          globals = { "vim" },
        },
      },
    }

    require("lspconfig").lua_ls.setup(opts)
  end,

  ["clangd"] = function()
    local opts = get_opts()

    -- Fix clangd offset encoding
    opts.capabilities.offsetEncoding = { "utf-16" }

    require("lspconfig").clangd.setup(opts)
  end,
}

M.options = {
  ensure_installed = {
    "bashls",
    "clangd",
    "cssls",
    "cssmodules_ls",
    "emmet_language_server",
    "html",
    "jsonls",
    "lua_ls",
    "rnix",
    "svelte",
    "tailwindcss",
    "tsserver",
    "yamlls",
  },
  automatic_installation = true,
  handlers = handlers,
}

return M
