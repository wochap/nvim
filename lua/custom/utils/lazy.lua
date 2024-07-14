local keymapsUtils = require "custom.utils.keymaps"
local constants = require "custom.utils.constants"

local M = {}

M.install = function()
  local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    constants.first_install = true

    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
  end
  vim.opt.rtp:prepend(lazypath)
end

M.on_load = function(...)
  require("lazyvim.util").on_load(...)
end

M.has_load = function(...)
  return require("lazyvim.util").is_loaded(...)
end

M.opts = function(...)
  return require("lazyvim.util").opts(...)
end

M.on_very_lazy = function(...)
  require("lazyvim.util").on_very_lazy(...)
end

M.load_mappings = function()
  local map = keymapsUtils.map
  map("n", "<leader>LR", "<cmd>Lazy restore<cr>", "restore")
  map("n", "<leader>LI", "<cmd>Lazy install<cr>", "install")
  map("n", "<leader>LS", "<cmd>Lazy sync<cr>", "sync")
  map("n", "<leader>LC", "<cmd>Lazy check<cr>", "check")
  map("n", "<leader>LU", "<cmd>Lazy update<cr>", "update")
  map("n", "<leader>LP", "<cmd>Lazy profile<cr>", "profile")
  map("n", "<leader>LH", "<cmd>Lazy<cr>", "info")
  map("n", "<leader>Li", "<cmd>Lazy<cr>", "info")
end

return M
