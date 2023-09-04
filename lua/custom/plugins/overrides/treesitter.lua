local options = {
  -- JoosepAlviste/nvim-ts-context-commentstring
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },

  highlight = { -- Be sure to enable highlights if you haven't!
    enable = true,
  },

  ensure_installed = {
    "bash",
    "c",
    "css",
    "graphql",
    "html",
    "javascript",
    "lua",
    "markdown",
    "markdown_inline",
    "nix",
    "norg",
    "python",
    "svelte",
    "toml",
    "tsx",
    "typescript",
    "vim",
  },
}

return options
