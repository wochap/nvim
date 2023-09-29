local null_ls = require "null-ls"
local b = null_ls.builtins

local sources = {
  -- JS
  require "typescript.extensions.null-ls.code-actions",

  -- Nix
  b.code_actions.statix,
  b.formatting.nixfmt,
  b.diagnostics.statix,

  -- Git stage / preview / reset hunks, blame, etc.
  b.code_actions.gitsigns,
  b.code_actions.gitrebase,
}

null_ls.setup {
  sources = sources,
  on_attach = function(client, bufnr)
    require("core.utils").load_mappings("null_ls", { buffer = bufnr })
  end,
}
