local M = {}

M.options = {
  -- JoosepAlviste/nvim-ts-context-commentstring
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },

  indent = {
    enable = true,
  },

  highlight = { -- Be sure to enable highlights if you haven't!
    enable = true,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },

  ensure_installed = {
    "bash",
    "dap_repl",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "regex",
    "toml",
    "vim",
    "vimdoc",
    -- "norg"
  },
}

return M
