local M = {}

M.init = function()
  -- overwrite LazyVim lsp mappings
  local keys = require("lazyvim.plugins.lsp.keymaps").get()
  keys[#keys + 1] = { "<leader>cl", false }
  keys[#keys + 1] = { "gd", false }
  -- keys[#keys + 1] = { "gr", false }
  -- keys[#keys + 1] = { "gD", false }
  keys[#keys + 1] = { "gI", false }
  keys[#keys + 1] = { "gy", false }
  keys[#keys + 1] = { "K", false }
  keys[#keys + 1] = { "gK", false }
  keys[#keys + 1] = { "<c-k>", false, mode = "i" }
  keys[#keys + 1] = { "<leader>ca", false, mode = { "n", "v" } }
  keys[#keys + 1] = { "<leader>cA", false }
  keys[#keys + 1] = { "<leader>cr", false }

  keys[#keys + 1] = { "<leader>li", "<cmd>LspInfo<cr>", desc = "Lsp Info" }
  keys[#keys + 1] = {
    "gd",
    function()
      require("telescope.builtin").lsp_definitions { reuse_win = false }
    end,
    desc = "Goto Definition",
    has = "definition",
  }
  keys[#keys + 1] = {
    "gI",
    function()
      require("telescope.builtin").lsp_implementations { reuse_win = false }
    end,
    desc = "Goto Implementation",
  }
  keys[#keys + 1] = {
    "gy",
    function()
      require("telescope.builtin").lsp_type_definitions { reuse_win = false }
    end,
    desc = "Goto T[y]pe Definition",
  }
  keys[#keys + 1] = {
    "gH",
    function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then
        vim.lsp.buf.hover()
      end
    end,
    desc = "Hover",
  }
  keys[#keys + 1] = { "gh", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" }
  keys[#keys + 1] = { "<c-h>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" }
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
}

M.setup = function(_, opts)
  local Util = require "lazyvim.util"

  -- run LazyVim lsp config
  local find_lazy_spec = require("custom.utils").find_lazy_spec
  local lazyvim_lsp_specs = require "lazyvim.plugins.lsp.init"
  local lazyvim_lsp_spec = find_lazy_spec(lazyvim_lsp_specs, "neovim/nvim-lspconfig")
  lazyvim_lsp_spec.config(_, opts)

  -- run custom NvChad lsp config
  -- source: https://github.com/NvChad/ui/blob/v2.0/lua/nvchad/lsp.lua
  -- NOTE: folke/noice.nvim replace signature/hover windows completely
  -- NOTE: folke/noice.nvim automatically show signature help when typing
  -- NOTE: folke/noice.nvim allows us to add keymappings to scroll signature/hover windows
  Util.lsp.on_attach(function(client)
    local utils = require "core.utils"
    if not utils.load_config().ui.lsp_semantic_tokens and client.supports_method "textDocument/semanticTokens" then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end)

  -- disable typescript-tools if project use deno
  -- source: https://github.com/LazyVim/LazyVim/blob/5b89bc8/lua/lazyvim/plugins/lsp/init.lua:197
  if Util.lsp.get_config "denols" and Util.lsp.get_config "typescript-tools" then
    local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
    Util.lsp.disable("typescript-tools", is_deno)
    Util.lsp.disable("denols", function(root_dir)
      return not is_deno(root_dir)
    end)
  end

  -- HACK: add `.volar` file at the root of your vue project to enable volar "Take Over Mode"
  -- disable typescript-tools if project has `.volar` file at the root
  if Util.lsp.get_config "volar" and Util.lsp.get_config "typescript-tools" then
    local is_vue = require("lspconfig.util").root_pattern ".volar"
    Util.lsp.disable("typescript-tools", is_vue)
    Util.lsp.disable("volar", function(root_dir)
      return not is_vue(root_dir)
    end)
  end

  Util.lsp.on_attach(function(client, bufnr)
    local utils = require "core.utils"
    local is_semantic_tokens_enabled = utils.load_config().ui.lsp_semantic_tokens

    -- -- disable treesitter if server suppoerts semantic tokens
    -- if is_semantic_tokens_enabled and client.supports_method "textDocument/semanticTokens" then
    --   vim.treesitter.stop(bufnr)
    -- end

    -- disable semanticTokens in large files
    local is_bigfile = require("custom.utils").is_bigfile
    if is_bigfile(bufnr, 1) and is_semantic_tokens_enabled and client.supports_method "textDocument/semanticTokens" then
      client.server_capabilities.semanticTokensProvider = nil
      -- vim.treesitter.start(bufnr)
    end
  end)

  -- disable LazyVim autoformat on save
  vim.g.autoformat = false

  -- HACK: hide hint diagnostics
  -- vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, ...)
  --   local client = vim.lsp.get_client_by_id(ctx.client_id)
  --
  --   if client and client.name == "tsserver" then
  --     result.diagnostics = vim.tbl_filter(function(diagnostic)
  --       return diagnostic.severity ~= vim.lsp.protocol.DiagnosticSeverity.Hint
  --     end, result.diagnostics)
  --   end
  --
  --   return vim.lsp.diagnostic.on_publish_diagnostics(nil, result, ctx, ...)
  -- end
end

return M
