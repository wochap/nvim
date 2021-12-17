local ok, null_ls = pcall(require, "null-ls")

if not ok then
  return
end

local b = null_ls.builtins

local sources = {
  -- JS TS Vue CSS HTML JSON YAML Markdown GraphQL
  b.formatting.prettierd,
  
  -- CSS
  -- b.diagnostics.stylelint
  
  -- JS TS Vue
  b.diagnostics.eslint_d,
  
  -- Python
  b.diagnostics.pylint,
  
  -- Lua
  b.formatting.stylua,
  b.diagnostics.luacheck.with { extra_args = { "--globals vim" } },

  -- Git stage / preview / reset hunks, blame, etc.
  b.code_actions.gitsigns,
  
  -- Shell
  b.formatting.shfmt,
  b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },

  -- Extras
  b.formatting.trim_newlines
}

local M = {}

M.setup = function(on_attach)
  null_ls.setup {
    sources = sources,
    on_attach = on_attach
  }
end

return M