local M = {}

M.have = function(...)
  return require("lazyvim.util.treesitter").have(...)
end

M.foldexpr = function(...)
  return require("lazyvim.util.treesitter").foldexpr(...)
end

M.indentexpr = function(...)
  return require("lazyvim.util.treesitter").indentexpr(...)
end

M.get_installed = function(...)
  return require("lazyvim.util.treesitter").get_installed(...)
end

return M
