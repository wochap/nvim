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

  -- JS
  b.code_actions.eslint_d,
  b.formatting.eslint_d,
  b.diagnostics.eslint_d.with {
    method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
  },

  -- Python
  b.diagnostics.pylint,

  -- Lua
  b.formatting.stylua,
  b.diagnostics.luacheck.with { extra_args = { "--globals vim" } },

  -- Shell
  b.formatting.shfmt,
  b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },

  -- Nix
  b.code_actions.statix,
  b.formatting.nixfmt,
  b.diagnostics.statix,

  -- Extras
  -- b.formatting.trim_newlines,

  -- Git stage / preview / reset hunks, blame, etc.
  b.code_actions.gitsigns,
  b.code_actions.gitrebase,

  -- Refactor for ts, js, go, lua, python
  -- b.code_actions.refactoring,
}

local M = {}

M.setup = function()
  null_ls.setup {
    sources = sources,
  }
end

return M
