local M = {}

M.setup = function()
  local capabilities = require("plugins.configs.lspconfig").capabilities
  local on_attach = require("custom.utils.lsp").on_attach

  local opts = {
    on_attach = function(client, bufnr)
      -- Run nvchad's attach
      on_attach(client, bufnr)

      -- disable tsserver's inbuilt formatting
      -- since I use null-ls for formatting
      client.server_capabilities.documentFormattingProvider = false

      -- enable document_highlight
      client.server_capabilities.document_highlight = true

      require("core.utils").load_mappings("lspconfig_tsserver", { buffer = bufnr })
    end,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    settings = {
      typescript = {
        format = {
          indentSize = vim.o.shiftwidth,
          convertTabsToSpaces = vim.o.expandtab,
          tabSize = vim.o.tabstop,
        },
      },
      javascript = {
        format = {
          indentSize = vim.o.shiftwidth,
          convertTabsToSpaces = vim.o.expandtab,
          tabSize = vim.o.tabstop,
        },
      },
      completions = {
        completeFunctionCalls = true,
      },
    },
  }

  require("typescript").setup {
    server = opts,
  }
end

return M