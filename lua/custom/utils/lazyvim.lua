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

  -- LazyVim root dir detection
  -- Each entry can be:
  -- * the name of a detector function like `lsp` or `cwd`
  -- * a pattern or array of patterns like `.git` or `lua`.
  -- * a function with signature `function(buf) -> string|string[]`
  vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

  -- Add LazyFile event
  -- Properly load file based plugins without blocking the UI
  require("lazyvim.util.plugin").lazy_file()

  -- Override LazyVim lsp utils
  local lazyVimLspUtil = require "lazyvim.util.lsp"
  lazyVimLspUtil.format = require("custom.utils.lsp").format
  lazyVimLspUtil.formatter = require("custom.utils.lsp").formatter
end

return M
