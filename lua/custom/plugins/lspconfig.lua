local M = {}

M.setup_lsp = function(attach, capabilities)
  local lspconfig = require "lspconfig"
  -- TODO: add clangd vimls pyls_ms jsonls?
  local servers = { "html", "cssls" }

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
    on_attach = function(client, bufnr)
      -- disable tsserver's inbuilt formatting 
      -- since I use null-ls with denofmt for formatting ts/js stuff.
      client.resolved_capabilities.document_formatting = false

      -- add keybinding for lsp formatting
      vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>fm", "<cmd>lua vim.lsp.buf.formatting()<CR>", {})
    end,
  }
end

return M
