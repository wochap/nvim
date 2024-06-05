local lspUtils = require "custom.utils.lsp"
local lazyUtils = require "custom.utils.lazy"

local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go { severity = severity }
  end
end

local M = {}

M._keys = nil

M.get = function()
  if M._keys then
    return M._keys
  end
  M._keys = {
    {
      "gr",
      "<cmd>Telescope lsp_references<cr>",
      desc = "References",
    },
    {
      "gD",
      vim.lsp.buf.declaration,
      desc = "Goto Declaration",
      has = "declaration",
    },
    {
      "gd",
      function()
        require("telescope.builtin").lsp_definitions { reuse_win = false }
      end,
      desc = "Goto Definition",
      has = "definition",
    },
    {
      "gI",
      function()
        require("telescope.builtin").lsp_implementations { reuse_win = false }
      end,
      desc = "Goto Implementation",
    },
    {
      "gy",
      function()
        require("telescope.builtin").lsp_type_definitions { reuse_win = false }
      end,
      desc = "Goto T[y]pe Definition",
    },
    {
      "gH",
      function()
        local has_ufo, ufo = pcall(require, "ufo")
        local winid = has_ufo and ufo.peekFoldedLinesUnderCursor() or nil
        if not winid then
          vim.lsp.buf.hover()
        end
      end,
      desc = "Hover",
    },
    {
      "gh",
      vim.lsp.buf.signature_help,
      desc = "Signature Help",
      has = "signatureHelp",
    },
    {
      "<c-h>",
      vim.lsp.buf.signature_help,
      mode = "i",
      desc = "Signature Help",
      has = "signatureHelp",
    },
    {
      "<leader>la",
      vim.lsp.buf.code_action,
      desc = "Code Action",
      mode = { "n", "v" },
      has = "codeAction",
    },
    {
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
    },
    {
      "<leader>lr",
      function()
        local inc_rename = require "inc_rename"
        return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand "<cword>"
      end,
      expr = true,
      desc = "Rename",
      has = "rename",
    },
    {
      "<leader>lr",
      function()
        local inc_rename = require "inc_rename"
        return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand "<cword>"
      end,
      expr = true,
      desc = "Rename",
      has = "rename",
    },
    {
      "<leader>lR",
      function()
        require("lazyvim.util.lsp").rename_file()
      end,
      desc = "Rename file",
      has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
    },
    {
      [[\]] .. "h",
      lspUtils.toggle_inlay_hints,
      desc = "Toggle 'inlay hints'",
      has = "inlayHint",
    },
    {
      [[\]] .. "c",
      "<cmd>LspLensToggle<CR>",
      desc = "Toggle 'codelens'",
      has = "codeLens",
    },
    {
      "<leader>ld",
      function()
        vim.diagnostic.open_float()
      end,
      desc = "floating diagnostic",
    },
    {
      "[d",
      diagnostic_goto(false),
      desc = "prev diagnostic",
    },
    {
      "]d",
      diagnostic_goto(true),
      desc = "next diagnostic",
    },
    {
      "[e",
      diagnostic_goto(false, "ERROR"),
      desc = "prev diagnostic error",
    },
    {
      "]e",
      diagnostic_goto(true, "ERROR"),
      desc = "next diagnostic error",
    },
  }
  return M._keys
end

function M.has(buffer, method)
  return require("lazyvim.plugins.lsp.keymaps").has(buffer, method)
end

function M.resolve(buffer)
  local Keys = require "lazy.core.handler.keys"
  if not Keys.resolve then
    return {}
  end
  local spec = M.get()
  local opts = lazyUtils.opts "nvim-lspconfig"
  local clients = lspUtils.get_clients { bufnr = buffer }
  for _, client in ipairs(clients) do
    local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    vim.list_extend(spec, maps)
  end
  return Keys.resolve(spec)
end

function M.on_attach(_, buffer)
  local Keys = require "lazy.core.handler.keys"
  local keymaps = M.resolve(buffer)

  for _, keys in pairs(keymaps) do
    if not keys.has or M.has(buffer, keys.has) then
      local opts = Keys.opts(keys)
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
    end
  end
end

return M
