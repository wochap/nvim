local M = {}

M.config = function(opts)
  local Util = require "lazyvim.util"

  -- setup neoconf
  local plugin = require("lazy.core.config").spec.plugins["neoconf.nvim"]
  require("neoconf").setup(require("lazy.core.plugin").values(plugin, "opts", false))

  -- config UI for diagnostic
  vim.diagnostic.config {
    severity_sort = true,
    signs = false,
    virtual_text = false,
    float = {
      border = "single",
      format = function(diagnostic)
        return string.format("%s (%s)", diagnostic.message, diagnostic.source)
      end,
    },
  }

  -- HACK: hide hint diagnostics
  vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, ...)
    local client = vim.lsp.get_client_by_id(ctx.client_id)

    if client and client.name == "tsserver" then
      result.diagnostics = vim.tbl_filter(function(diagnostic)
        return diagnostic.severity ~= vim.lsp.protocol.DiagnosticSeverity.Hint
      end, result.diagnostics)
    end

    return vim.lsp.diagnostic.on_publish_diagnostics(nil, result, ctx, ...)
  end

  -- HACK: setup LazyVim autoformat
  vim.g.autoformat = false
  Util.format.register(Util.lsp.formatter())

  -- HACK: run nvchad's attach and setup keymaps
  Util.lsp.on_attach(function(client, bufnr)
    local on_attach = require("custom.utils.lsp").get_opts().on_attach
    on_attach(client, bufnr)
  end)

  -- HACK: use same configuration as LazyVim so we can overwrite/extend lsp config with opts
  local servers = opts.servers
  local get_opts = require("custom.utils.lsp").get_opts
  local server_opts = get_opts()
  local function setup(server)
    local _server_opts = vim.tbl_deep_extend(
      "force",
      vim.deepcopy {
        capabilities = server_opts.capabilities,
        flags = server_opts.flags,
      },
      servers[server] or {}
    )

    if opts.setup[server] then
      if opts.setup[server](server, _server_opts) then
        return
      end
    elseif opts.setup["*"] then
      if opts.setup["*"](server, _server_opts) then
        return
      end
    end
    require("lspconfig")[server].setup(_server_opts)
  end
  -- get all the servers that are available through mason-lspconfig
  local mlsp = require "mason-lspconfig"
  local all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
  local ensure_installed = {}
  for server, _server_opts in pairs(servers) do
    if _server_opts then
      _server_opts = _server_opts == true and {} or _server_opts
      -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
      if _server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
        setup(server)
      else
        ensure_installed[#ensure_installed + 1] = server
      end
    end
  end
  mlsp.setup { ensure_installed = ensure_installed, handlers = { setup } }
end

return M
