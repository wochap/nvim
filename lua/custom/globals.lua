local constants = require "custom.utils.constants"

if constants.in_nix then
  -- overwrite PATH to ensure LSP servers start correctly in older projects
  -- doesn't work with LSP servers for langs with different
  -- grand major version number e.g. Ruby
  vim.env.PATH = "/run/current-system/sw/bin/:" .. vim.env.PATH
end

-- open nvim in lazygit terminal
vim.env.GIT_EDITOR = "nvim"

-- disable some default providers
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- https://vi.stackexchange.com/a/5318/12823
vim.g.matchparen_timeout = 2
vim.g.matchparen_insert_timeout = 2

-- disable netrw
if constants.disable_netrw then
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
end

if constants.in_neovide then
  vim.g.neovide_floating_shadow = false
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_floating_z_height = 7
  vim.g.neovide_floating_blur_amount_x = 0
  vim.g.neovide_floating_blur_amount_y = 0
end

vim.g.foot = constants.in_foot
vim.g.kitty = constants.in_kitty

_G.dd = function(...)
  Snacks.debug.inspect(...)
end
