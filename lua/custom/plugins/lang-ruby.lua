vim.g.lazyvim_ruby_lsp = "ruby_lsp"
vim.g.lazyvim_ruby_formatter = "rubocop"

return {
  {
    import = "lazyvim.plugins.extras.lang.ruby",
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        ruby_lsp = {
          cmd_env = { BUNDLE_GEMFILE = vim.fn.getenv "GLOBAL_GEMFILE" },
        },
      },
    },
  },
}
