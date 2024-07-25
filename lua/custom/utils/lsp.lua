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

M.get_pkg_path = function(pkg, path, opts)
  -- pcall(require, "mason") -- make sure Mason is loaded. Will fail when generating docs
  local root = vim.env.MASON or (vim.fn.stdpath "data" .. "/mason")
  opts = opts or {}
  opts.warn = opts.warn == nil and true or opts.warn
  path = path or ""
  local ret = root .. "/packages/" .. pkg .. "/" .. path
  if opts.warn and not vim.loop.fs_stat(ret) and not require("lazy.core.config").headless() then
    require("lazyvim.util").warn(
      ("Mason package path not found for **%s**:\n- `%s`\nYou may need to force update the package."):format(pkg, path)
    )
  end
  return ret
end

return M
