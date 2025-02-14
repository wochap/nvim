local M = {}

M.load = function()
  local lazyvim_path = vim.fn.stdpath "data" .. "/lazy/LazyVim"
  if vim.uv.fs_stat(lazyvim_path) then
    vim.opt.rtp:prepend(lazyvim_path)
    M.setup()
  end
end

M.setup = function()
  _G.lazyvim_docs = false
  -- required by lazyvim extras using `LazyVim.extras.wants`
  _G.LazyVim = require "lazyvim.util"

  -- Add LazyFile event
  -- Properly load file based plugins without blocking the UI
  require("lazyvim.util.plugin").lazy_file()

  -- Override LazyVim lsp utils
  local lazyVimLspUtil = require "lazyvim.util.lsp"
  lazyVimLspUtil.format = require("custom.utils.lsp").format
  lazyVimLspUtil.formatter = require("custom.utils.lsp").formatter
end

return M
