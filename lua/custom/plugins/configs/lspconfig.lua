local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- TODO: add clangd vimls pyls_ms?
local servers = {
  "clangd",
  "html",
  "cssls",
  "emmet_language_server",
  "jsonls",
  "svelte",
  "tailwindcss",
  "bashls",
  -- "tsserver", -- setup lsp server inside jose-elias-alvarez/typescript.nvim
  "lua_ls",
  -- "flow",
  "cssmodules_ls",
  "rnix",
}

for _, lsp in ipairs(servers) do
  local opts = {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
  }

  if lsp == "rnix" or lsp == "jsonls" then
    opts.on_attach = function(client, bufnr)
      -- Run nvchad's attach
      on_attach(client, bufnr)

      -- disable server inbuilt formatting
      -- since I use null-ls for formatting
      client.server_capabilities.document_formatting = false
      client.server_capabilities.document_range_formatting = false
    end
  end

  -- json
  if lsp == "jsonls" then
    local present, schemastore = pcall(require, "schemastore")

    if present then
      opts.settings = {
        json = {
          schemas = schemastore.json.schemas(),
        },
      }
    end
  end

  -- emmet
  if lsp == "emmet_language_server" then
    opts.filetypes = {
      "html",
      "xhtml",
      "xml",
      "css",
      "sass",
      "scss",
      "less",
    }
  end

  -- lua
  if lsp == "lua_ls" then
    opts.settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
      },
    }
  end

  -- c
  if lsp == "clangd" then
    -- Fix clangd offset encoding
    opts.capabilities.offsetEncoding = { "utf-16" }
  end

  lspconfig[lsp].setup(opts)
end

vim.diagnostic.config {
  severity_sort = true,
  signs = false,
  virtual_text = false,
  float = {
    border = "single",
    format = function(diagnostic)
      return string.format("%s (%s)", diagnostic.message, diagnostic.source)
    end,
  },
}

-- HACK: hide hint diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, ...)
  local client = vim.lsp.get_client_by_id(ctx.client_id)

  if client and client.name == "tsserver" then
    result.diagnostics = vim.tbl_filter(function(diagnostic)
      return diagnostic.severity ~= vim.lsp.protocol.DiagnosticSeverity.Hint
    end, result.diagnostics)
  end

  return vim.lsp.diagnostic.on_publish_diagnostics(nil, result, ctx, ...)
end
