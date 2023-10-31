local M = {}

local opts = require("custom.utils.lsp").get_opts()

M.options = {
  server = vim.tbl_deep_extend("force", opts, {
    on_attach = function(client, bufnr)
      -- Run nvchad's attach
      opts.on_attach(client, bufnr)

      -- disable tsserver's inbuilt formatting
      -- since I use null-ls for formatting
      client.server_capabilities.documentFormattingProvider = false

      -- enable document_highlight
      client.server_capabilities.document_highlight = true

      require("core.utils").load_mappings("lspconfig_tsserver", { buffer = bufnr })
    end,
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
  }),
}

return M
