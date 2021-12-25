local M = {}

M.setup_lsp = function(attach, capabilities)
  local lspconfig = require "lspconfig"
  -- TODO: add clangd vimls pyls_ms?
  local servers = { "html", "cssls", "emmet_ls", "jsonls", "svelte", "tailwindcss", "bashls", "tsserver", "sumneko_lua" }

  for _, lsp in ipairs(servers) do
    local opts = {
      on_attach = attach,
      capabilities = capabilities,
      flags = {
        debounce_text_changes = 150,
      },
    }

    -- typescript
    if lsp == "tsserver" then
      opts.on_attach = function(client, bufnr)
        -- Run nvchad's attach
        attach(client, bufnr)
        
        -- disable tsserver's inbuilt formatting 
        -- since I use null-ls for formatting
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false

        -- enable document_highlight
        client.resolved_capabilities.document_highlight = true
      end
    end

    -- json
    if lsp == "jsonls" then
      opts.settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
        },
      }
    end

    lspconfig[lsp].setup(opts)
  end

  -- vim.opt.signcolumn = "yes:2"
  vim.diagnostic.config {
    virtual_text = {
       spacing = 2, -- fix https://github.com/neovim/nvim-lspconfig/issues/195S
    },
    -- signs = false,
  }
end

return M
