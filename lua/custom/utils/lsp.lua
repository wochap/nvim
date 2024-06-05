local M = {}

M.format = function(opts)
  opts = vim.tbl_deep_extend("force", {}, opts or {}, {
    formatting_options = nil,
    timeout_ms = nil,
    formatters = {},
    lsp_fallback = true,
  })

  local has_conform, conform = pcall(require, "conform")
  if not has_conform then
    return
  end
  conform.format(opts)
end

M.get_clients = function(opts)
  ---@diagnostic disable-next-line: deprecated
  local ret = vim.lsp.get_active_clients(opts)
  if opts and opts.method then
    ret = vim.tbl_filter(function(client)
      return client.supports_method(opts.method, { bufnr = opts.bufnr })
    end, ret)
  end
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

M.formatter = function(opts)
  local lazyCoreUtils = require "lazy.core.util"
  opts = opts or {}
  local filter = opts.filter or {}
  filter = type(filter) == "string" and { name = filter } or filter
  local ret = {
    name = "LSP",
    primary = true,
    priority = 1,
    format = function(buf)
      M.format(lazyCoreUtils.merge(filter, { bufnr = buf }))
    end,
    sources = function(buf)
      local clients = M.get_clients(lazyCoreUtils.merge(filter, { bufnr = buf }))
      local ret = vim.tbl_filter(function(client)
        return client.supports_method "textDocument/formatting" or client.supports_method "textDocument/rangeFormatting"
      end, clients)
      return vim.tbl_map(function(client)
        return client.name
      end, ret)
    end,
  }
  return lazyCoreUtils.merge(ret, opts)
end

M.on_attach = function(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

M.get_config = function(server)
  local configs = require "lspconfig.configs"
  return rawget(configs, server)
end

M.disable = function(server, cond)
  local util = require "lspconfig.util"
  local def = M.get_config(server)
  ---@diagnostic disable-next-line: undefined-field
  def.document_config.on_new_config = util.add_hook_before(def.document_config.on_new_config, function(config, root_dir)
    if cond(root_dir, config) then
      config.enabled = false
    end
  end)
end

M.toggle_inlay_hints = function(buf, value)
  return require("lazyvim.util.toggle").inlay_hints(buf, value)
end

return M
