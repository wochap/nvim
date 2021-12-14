local M = {}

M.setup_lsp = function(attach, capabilities)
  local lspconfig = require "lspconfig"
  -- TODO: add clangd vimls pyls_ms jsonls?
  local servers = { "html", "cssls", "emmet_ls", "jsonls", "svelte", "tailwindcss" }

  -- html, css
  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup {
      on_attach = attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 150,
      },
    }
  end
   
  -- typescript
  lspconfig.tsserver.setup {
    root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json"),
    on_attach = function(client, bufnr)
      -- disable tsserver's inbuilt formatting 
      -- since I use null-ls for formatting
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
    end,
  }
end

return M
