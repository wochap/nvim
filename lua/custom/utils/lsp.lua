local M = {}

M.format = function(...)
  require("lazyvim.util.lsp").format(...)
end

M.get_clients = function(...)
  return require("lazyvim.util.lsp").get_clients(...)
end

M.formatter = function(...)
  return require("lazyvim.util.lsp").formatter(...)
end

M.on_attach = function(...)
  return require("lazyvim.util.lsp").on_attach(...)
end

M.get_config = function(...)
  return require("lazyvim.util.lsp").get_config(...)
end

M.disable = function(...)
  require("lazyvim.util.lsp").disable(...)
end

M.toggle_inlay_hints = function(...)
  return require("lazyvim.util.toggle").inlay_hints(...)
end

M.get_pkg_path = function(...)
  return require("lazyvim.util").get_pkg_path(...)
end

return M
