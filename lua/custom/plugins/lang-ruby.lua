local constants = require "custom.utils.constants"

vim.g.lazyvim_ruby_lsp = "solargraph"
vim.g.lazyvim_ruby_formatter = "rubocop"

return {
  {
    enabled = not constants.first_install,
    import = "lazyvim.plugins.extras.lang.ruby",
  },
}
