local M = {}

M.on_attach = function(client, bufnr)
  local on_attach = require("plugins.configs.lspconfig").on_attach

  -- Run nvchad's attach
  on_attach(client, bufnr)

  require("core.utils").load_mappings("dap", { buffer = bufnr })
end

return M
