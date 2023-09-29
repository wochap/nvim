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
