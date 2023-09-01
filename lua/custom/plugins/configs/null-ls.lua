local null_ls = require "null-ls"

local b = null_ls.builtins

local sources = {
  -- JS TS Vue CSS HTML JSON YAML Markdown GraphQL
  b.formatting.prettierd.with {
    prefer_local = false,
    dynamic_command = function()
      return "prettierd"
    end,
  },

  -- CSS
  -- b.diagnostics.stylelint

  -- JS
  b.code_actions.eslint_d,
  b.formatting.eslint_d,
  b.diagnostics.eslint_d.with {
    prefer_local = false,
    condition = function(utils)
      return utils.root_has_file {
        ".eslintrc",
        ".eslintrc.js",
        ".eslintrc.yaml",
        ".eslintrc.yml",
        ".eslintrc.json",
      }
    end,
    method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
    dynamic_command = function()
      return "eslint_d"
    end,
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

null_ls.setup {
  sources = sources,
}
