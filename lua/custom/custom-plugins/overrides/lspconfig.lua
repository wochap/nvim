local M = {}

M.init = function()
  require("core.utils").lazy_load "nvim-lspconfig"

  -- overwrite LazyVim lsp mappings
  local keys = require("lazyvim.plugins.lsp.keymaps").get()
  keys[#keys + 1] = { "<leader>cl", false }
  -- keys[#keys + 1] = { "gd", false }
  -- keys[#keys + 1] = { "gr", false }
  -- keys[#keys + 1] = { "gD", false }
  -- keys[#keys + 1] = { "gI", false }
  -- keys[#keys + 1] = { "gy", false }
  keys[#keys + 1] = { "K", false }
  keys[#keys + 1] = { "gK", false }
  -- keys[#keys + 1] = { "<c-k>", false }
  keys[#keys + 1] = { "<leader>ca", false }
  keys[#keys + 1] = { "<leader>cA", false }
  keys[#keys + 1] = { "<leader>cr", false }

  keys[#keys + 1] = { "<leader>li", "<cmd>LspInfo<cr>", desc = "Lsp Info" }
  keys[#keys + 1] = {
    "gh",
    function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end,
    desc = "Hover",
  }
  keys[#keys + 1] = { "gk", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" }
  keys[#keys + 1] =
    { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" }, has = "codeAction" }
  keys[#keys + 1] = {
    "<leader>lA",
    function()
      vim.lsp.buf.code_action {
        context = {
          only = {
            "source",
          },
          diagnostics = {},
        },
      }
    end,
    desc = "Source Action",
    has = "codeAction",
  }
  keys[#keys + 1] = {
    "<leader>lr",
    function()
      local inc_rename = require "inc_rename"
      return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand "<cword>"
    end,
    expr = true,
    desc = "Rename",
    has = "rename",
  }
end

M.options = {
  servers = {
    bashls = {},
  },
  diagnostics = {
    signs = false,
    virtual_text = false,
    float = {
      border = "rounded",
      format = function(diagnostic)
        return string.format("%s (%s)", diagnostic.message, diagnostic.source)
      end,
    },
  },
  -- inlay_hints = {
  --   enabled = true,
  -- },
  capabilities = {
    textDocument = {
      -- ufo capabilities
      -- TODO: move to ufo config
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
      -- nvchad capabilities
      completion = {
        completionItem = {
          documentationFormat = { "markdown", "plaintext" },
          snippetSupport = true,
          preselectSupport = true,
          insertReplaceSupport = true,
          labelDetailsSupport = true,
          deprecatedSupport = true,
          commitCharactersSupport = true,
          tagSupport = { valueSet = { 1 } },
          resolveSupport = {
            properties = {
              "documentation",
              "detail",
              "additionalTextEdits",
            },
          },
        },
      },
    },
  },
  -- TODO: remove lua_ls
}

M.setup = function(_, opts)
  local Util = require "lazyvim.util"

  -- run LazyVim lsp config
  local find_spec = require("custom.utils.lazy").find_spec
  local lazyvim_lsp_specs = require "custom.custom-plugins.external.lazyvim_plugins_lsp"
  local lazyvim_lsp_spec = find_spec(lazyvim_lsp_specs, "neovim/nvim-lspconfig")
  lazyvim_lsp_spec.config(_, opts)

  -- run NvChad lsp config
  dofile(vim.g.base46_cache .. "lsp")
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "single",
  })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "single",
    focusable = false,
    relative = "cursor",
  })
  local win = require "lspconfig.ui.windows"
  local _default_opts = win.default_opts
  win.default_opts = function(options)
    local opts = _default_opts(options)
    opts.border = "single"
    return opts
  end
  Util.lsp.on_attach(function(client, bufnr)
    local utils = require "core.utils"
    if client.server_capabilities.signatureHelpProvider then
      require("nvchad.signature").setup(client)
    end
    if not utils.load_config().ui.lsp_semantic_tokens and client.supports_method "textDocument/semanticTokens" then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end)

  Util.lsp.on_attach(function(client, bufnr)
    -- disable semanticTokens in large files
    local is_bigfile = require("custom.utils.bigfile").is_bigfile
    if is_bigfile(bufnr, 1) and client.supports_method "textDocument/semanticTokens" then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end)

  -- disable LazyVim autoformat on save
  vim.g.autoformat = false

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
end

return M
