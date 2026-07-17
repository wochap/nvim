vim.g.lazyvim_php_lsp = "intelephense"

return {
  {
    import = "lazyvim.plugins.extras.lang.php",
  },

  -- undo none-ls changes added by LazyVim
  {
    "nvimtools/none-ls.nvim",
    enabled = false,
  },
}
