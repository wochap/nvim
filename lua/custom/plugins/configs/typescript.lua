local M = {}

M.setup = function()
  local capabilities = require("plugins.configs.lspconfig").capabilities
  local on_attach = require("plugins.configs.lspconfig").on_attach

  local opts = {
    on_attach = function(client, bufnr)
      -- Run nvchad's attach
      on_attach(client, bufnr)

      -- disable tsserver's inbuilt formatting
      -- since I use null-ls for formatting
      client.server_capabilities.documentFormattingProvider = false

      -- enable document_highlight
      client.server_capabilities.document_highlight = true

      require("core.utils").load_mappings "dap"
      require("core.utils").load_mappings "lspconfig_tsserver"
      require("which-key").register({ d = { name = "dap" } }, { prefix = "<leader>" })
    end,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
  }

  require("typescript").setup {
    server = opts,
  }
end

return M
