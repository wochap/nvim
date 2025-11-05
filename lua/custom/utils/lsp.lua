local nvim_utils = require "custom.utils.nvim"
local lang_utils = require "custom.utils.lang"
local lazy_utils = require "custom.utils.lazy"

local M = {}

-- Pass down cb argument to conform format method
-- use default_format_opts instead of format
---@param opts? lsp.Client.format
M.format = function(opts, cb)
  opts = vim.tbl_deep_extend(
    "force",
    {},
    opts or {},
    lazy_utils.opts("nvim-lspconfig").default_format_opts or {},
    lazy_utils.opts("conform.nvim").default_format_opts or {}
  )
  local has_conform, conform = pcall(require, "conform")
  -- use conform for formatting with LSP when available,
  -- since it has better format diffing
  if has_conform then
    opts.formatters = {}
    conform.format(opts, cb)
  else
    vim.lsp.buf.format(opts)
  end
end

-- Pass down cb argument to conform format method
---@param opts? LazyFormatter| {filter?: (string|vim.lsp.get_clients.Filter)}
M.formatter = function(opts)
  opts = opts or {}
  local filter = opts.filter or {}
  filter = type(filter) == "string" and { name = filter } or filter
  ---@cast filter vim.lsp.get_clients.Filter
  ---@type LazyFormatter
  local ret = {
    name = "LSP",
    primary = true,
    priority = 1,
    format = function(buf, format_opts, cb)
      local _opts = lang_utils.tbl_merge({}, format_opts, filter, { bufnr = buf })
      M.format(_opts, cb)
    end,
    sources = function(buf)
      local clients = vim.lsp.get_clients(lang_utils.tbl_merge({}, filter, { bufnr = buf }))
      ---@param client vim.lsp.Client
      local ret = vim.tbl_filter(function(client)
        return client:supports_method "textDocument/formatting" or client:supports_method "textDocument/rangeFormatting"
      end, clients)
      ---@param client vim.lsp.Client
      return vim.tbl_map(function(client)
        return client.name
      end, ret)
    end,
  }
  return lang_utils.tbl_merge(ret, opts) --[[@as LazyFormatter]]
end

M.keymap_set = function(...)
  return require("lazyvim.plugins.lsp.keymaps").set(...)
end

M.get_pkg_path = function(...)
  return require("lazyvim.util").get_pkg_path(...)
end

M.execute = function(...)
  return require("lazyvim.util.lsp").execute(...)
end

M.code_action = function(action)
  return function()
    vim.lsp.buf.code_action {
      apply = true,
      context = {
        only = { action },
        diagnostics = {},
      },
    }
  end
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

---Sets up autocommands to enable/disable a feature based on mode.
---The feature will be disabled on InsertEnter and entering Visual mode,
---and enabled on InsertLeave and leaving Visual mode.
M.setup_mode_toggle = function(name, disable_fn, enable_fn)
  local function create_callback(fn)
    return function(event)
      vim.schedule(function()
        fn(event)
      end)
    end
  end

  nvim_utils.autocmd("InsertEnter", {
    group = nvim_utils.augroup("disable_" .. name .. "_on_insert_enter"),
    pattern = "*",
    callback = create_callback(disable_fn),
  })
  nvim_utils.autocmd("InsertLeave", {
    group = nvim_utils.augroup("enable_" .. name .. "_on_insert_leave"),
    pattern = "*",
    callback = create_callback(enable_fn),
  })
  nvim_utils.autocmd("ModeChanged", {
    group = nvim_utils.augroup("disable_" .. name .. "_on_visual_enter"),
    pattern = "*:[vV]",
    callback = function(event)
      local cur_mode = vim.fn.mode()
      if cur_mode ~= "v" and cur_mode ~= "V" then
        return
      end
      vim.schedule(function()
        disable_fn(event)
      end)
    end,
  })
  nvim_utils.autocmd("ModeChanged", {
    group = nvim_utils.augroup("enable_" .. name .. "_on_visual_leave"),
    pattern = "[vV]:*",
    callback = create_callback(enable_fn),
  })
end

M.diagnostic_goto = function(next, severity)
  return function()
    vim.diagnostic.jump {
      count = (next and 1 or -1) * vim.v.count1,
      severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    }
  end
end

return M
