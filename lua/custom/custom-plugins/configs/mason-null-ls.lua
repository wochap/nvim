local null_ls = require "null-ls"
local b = null_ls.builtins

local M = {}

local handlers = {
  function(source_name, methods)
    require("mason-null-ls").default_setup(source_name, methods)
  end,

  -- JS TS Vue CSS HTML JSON YAML Markdown GraphQL
  prettierd = function(source_name, methods)
    null_ls.register(b.formatting.prettierd.with {
      prefer_local = false,
      filetypes = {
        "css",
        "graphql",
        "handlebars",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "jsonc",
        "less",
        "markdown",
        "markdown.mdx",
        "scss",
        "typescript",
        "typescriptreact",
        "vue",
        "xhtml",
        "yaml",
      },
      dynamic_command = function()
        return "prettierd"
      end,
    })
  end,

  -- JS
  eslint_d = function(source_name, methods)
    null_ls.register {
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
    }
  end,

  -- Python
  pylint = function(source_name, methods)
    null_ls.register(b.diagnostics.pylint)
  end,

  -- Lua
  stylua = function(source_name, methods)
    null_ls.register(b.formatting.stylua)
  end,
  luacheck = function(source_name, methods)
    null_ls.register(b.diagnostics.luacheck.with { extra_args = { "--globals vim" } })
  end,

  -- Shell
  shfmt = function(source_name, methods)
    null_ls.register(b.formatting.shfmt)
  end,
  shellcheck = function(source_name, methods)
    null_ls.register(b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" })
  end,
}

M.options = {
  ensure_installed = {
    "eslint_d",
    "luacheck",
    "prettierd",
    "pylint",
    "shellcheck",
    "shfmt",
    "stylua",
  },
  automatic_installation = true,
  handlers = handlers,
}

return M
