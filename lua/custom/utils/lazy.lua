local keymaps_utils = require "custom.utils.keymaps"
local constants = require "custom.constants"

local M = {}

M.install = function()
  local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
  if not vim.uv.fs_stat(lazypath) then
    constants.first_install = true

    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
  end
  vim.opt.rtp:prepend(lazypath)
end

M.on_load = function(...)
  require("lazyvim.util").on_load(...)
end

-- PERF: try to avoid using it in recurring functions
M.is_loaded = function(...)
  return require("lazyvim.util").is_loaded(...)
end

M.opts = function(...)
  return require("lazyvim.util").opts(...)
end

M.on_very_lazy = function(...)
  require("lazyvim.util").on_very_lazy(...)
end

M.load_mappings = function()
  local map = keymaps_utils.map
  map("n", "<leader>L", "<cmd>Lazy<cr>", "Lazy")
end

M.find_local_nolazy_spec = function()
  local path = vim.uv.cwd()
  local LOCAL_SPEC = ".nolazy.lua"
  while path and path ~= "" do
    local file = path .. "/" .. LOCAL_SPEC
    if vim.fn.filereadable(file) == 1 then
      return {
        name = vim.fn.fnamemodify(file, ":~:."),
        import = function()
          local data = vim.secure.read(file)
          if data then
            return loadstring(data, LOCAL_SPEC)()
          end
          return {}
        end,
      }
    end
    local p = vim.fn.fnamemodify(path, ":h")
    if p == path then
      break
    end
    path = p
  end
end

return M
