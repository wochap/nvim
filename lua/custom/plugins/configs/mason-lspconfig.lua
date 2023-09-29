local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local M = {}

local function get_opts()
  local opts = {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
  }

  return opts
end

local handlers = {
  function(server_name)
    local opts = get_opts()

    if server_name == "tsserver" then
      -- NOTE: typescript.nvim take care of tsserver
      return
    end

    require("lspconfig")[server_name].setup(opts)
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
    local ok, schemastore = pcall(require, "schemastore")

    if not ok then
      return
    end

    opts.on_attach = function(client, bufnr)
      -- Run nvchad's attach
      on_attach(client, bufnr)

      -- disable server inbuilt formatting
      -- since I use null-ls for formatting
      client.server_capabilities.documentFormattingProvider = false
    end

    opts.settings = {
      json = {
        schemas = schemastore.json.schemas(),
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

M.setup = function()
  require("mason-lspconfig").setup {
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
    },
    automatic_installation = true,
    handlers = handlers,
  }
end

return M
