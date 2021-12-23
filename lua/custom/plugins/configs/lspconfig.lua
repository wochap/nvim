local M = {}
local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec(
      [[
        augroup lsp_document_highlight
          autocmd! * <buffer>
          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
      ]],
      false
    )
  end
end

M.setup_lsp = function(attach, capabilities)
  local lspconfig = require "lspconfig"
  -- TODO: add clangd vimls pyls_ms?
  local servers = { "html", "cssls", "emmet_ls", "jsonls", "svelte", "tailwindcss", "bashls", "tsserver", "sumneko_lua" }

  for _, lsp in ipairs(servers) do
    local opts = {
      on_attach = function(client, bufnr)
        -- Run nvchad's attach
        attach(client, bufnr)

        lsp_highlight_document(client)
      end,
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

        lsp_highlight_document(client)
        
        -- disable tsserver's inbuilt formatting 
        -- since I use null-ls for formatting
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
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
