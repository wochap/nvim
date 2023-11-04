local M = {}

M.setup = function(opts)
  -- Load vscode launchjs
  require("dap.ext.vscode").load_launchjs()

  vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

  vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DiagnosticError", linehl = "", numhl = "" })
  vim.fn.sign_define("DapBreakpointCondition", { text = " ", texthl = "DiagnosticError", linehl = "", numhl = "" })
  vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "DiagnosticError", linehl = "", numhl = "" })
  vim.fn.sign_define("DapStopped", { text = "󰁕 ", texthl = "DiagnosticWarn", linehl = "DapStoppedLine", numhl = "" })
  vim.fn.sign_define("DapLogPoint", { text = ".>", texthl = "DiagnosticError", linehl = "", numhl = "" })
end

return M
