local M = {}

-- Pass down cb argument to conform format method
-- use default_format_opts instead of format
---@param opts? lsp.Client.format
M.format = function(opts, cb)
  opts = vim.tbl_deep_extend(
    "force",
    {},
    opts or {},
    LazyVim.opts("nvim-lspconfig").format or {},
    LazyVim.opts("conform.nvim").default_format_opts or {}
  )
  local ok, conform = pcall(require, "conform")
  -- use conform for formatting with LSP when available,
  -- since it has better format diffing
  if ok then
    opts.formatters = {}
    conform.format(opts, cb)
  else
    vim.lsp.buf.format(opts)
  end
end

M.get_clients = function(...)
  return require("lazyvim.util.lsp").get_clients(...)
end

-- Pass down cb argument to conform format method
---@param opts? LazyFormatter| {filter?: (string|lsp.Client.filter)}
M.formatter = function(opts)
  opts = opts or {}
  local filter = opts.filter or {}
  filter = type(filter) == "string" and { name = filter } or filter
  ---@cast filter lsp.Client.filter
  ---@type LazyFormatter
  local ret = {
    name = "LSP",
    primary = true,
    priority = 1,
    format = function(buf, cb)
      M.format(LazyVim.merge({}, filter, { bufnr = buf }), cb)
    end,
    sources = function(buf)
      local clients = M.get_clients(LazyVim.merge({}, filter, { bufnr = buf }))
      ---@param client vim.lsp.Client
      local ret = vim.tbl_filter(function(client)
        return client.supports_method "textDocument/formatting" or client.supports_method "textDocument/rangeFormatting"
      end, clients)
      ---@param client vim.lsp.Client
      return vim.tbl_map(function(client)
        return client.name
      end, ret)
    end,
  }
  return LazyVim.merge(ret, opts) --[[@as LazyFormatter]]
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

M.toggle_inlay_hints = function(bufnr, state)
  if bufnr == nil then
    bufnr = 0
  end
  if state == nil then
    state = not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
  end
  vim.lsp.inlay_hint.enable(state, { bufnr = bufnr })
  vim.api.nvim_buf_set_var(bufnr, "is_ih_enabled", state)
end

M.get_pkg_path = function(pkg, path, opts)
  -- pcall(require, "mason") -- make sure Mason is loaded. Will fail when generating docs
  local root = vim.env.MASON or (vim.fn.stdpath "data" .. "/mason")
  opts = opts or {}
  opts.warn = opts.warn == nil and true or opts.warn
  path = path or ""
  local ret = root .. "/packages/" .. pkg .. "/" .. path
  if opts.warn and not vim.uv.fs_stat(ret) and not require("lazy.core.config").headless() then
    require("lazyvim.util").warn(
      ("Mason package path not found for **%s**:\n- `%s`\nYou may need to force update the package."):format(pkg, path)
    )
  end
  return ret
end

return M
