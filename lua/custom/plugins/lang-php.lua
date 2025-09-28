local constants = require "custom.constants"

vim.g.lazyvim_php_lsp = "intelephense"

return {
  {
    enabled = not constants.first_install,
    import = "lazyvim.plugins.extras.lang.php",
  },

  -- undo none-ls changes added by LazyVim
  {
    "nvimtools/none-ls.nvim",
    enabled = false,
  },
}
