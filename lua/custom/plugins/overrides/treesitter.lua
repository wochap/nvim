local options = {
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
    "c",
    "css",
    "dap_repl",
    "graphql",
    "html",
    "javascript",
    "lua",
    "markdown",
    "markdown_inline",
    "nix",
    "python",
    "query",
    "regex",
    "svelte",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    -- "norg"
  },
}

return options
