local M = {}

local utils = require "core.utils"
local nvchad_on_attach = function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  utils.load_mappings("lspconfig", { buffer = bufnr })

  if client.server_capabilities.signatureHelpProvider then
    require("nvchad.signature").setup(client)
  end

  if not utils.load_config().ui.lsp_semantic_tokens and client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end
local nvchad_capabilities = vim.lsp.protocol.make_client_capabilities()
nvchad_capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

M.get_opts = function()
  local cmp_nvim_lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
  local nvim_ufo_lsp_capabilities = {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  }

  local opts = {
    on_attach = function(client, bufnr)
      -- Run nvchad's attach
      nvchad_on_attach(client, bufnr)

      -- Fix formatting for null-ls
      if client.name == "null-ls" then
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.documentRangeFormattingProvider = true
      end

      require("core.utils").load_mappings("dap", { buffer = bufnr })
      local wk = require "which-key"
      wk.register({
        ["<leader>d"] = { name = "dap" },
        ["<leader>l"] = { name = "lsp" },
      }, { buffer = bufnr })
    end,
    capabilities = vim.tbl_deep_extend(
      "force",
      {},
      cmp_nvim_lsp_capabilities,
      nvchad_capabilities,
      nvim_ufo_lsp_capabilities
    ),
    flags = {
      debounce_text_changes = 150,
    },
  }

  return opts
end

return M
