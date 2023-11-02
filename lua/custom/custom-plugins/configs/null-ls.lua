local M = {}

local null_ls = require "null-ls"
local b = null_ls.builtins

M.options = {
  sources = {
    -- Git stage / preview / reset hunks, blame, etc.
    b.code_actions.gitsigns,
    b.code_actions.gitrebase,

    -- Shell
    b.formatting.shfmt,
    b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },
  },
  on_attach = function(client, bufnr)
    require("core.utils").load_mappings("null_ls", { buffer = bufnr })
  end,
}

return M
