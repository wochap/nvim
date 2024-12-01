local utils = require "custom.utils"
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
    { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References", nowait = true },
    { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration", has = "declaration" },
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
        if winid then
          -- remove left padding
          utils.disable_statuscol(winid)
        end
        if not winid then
          vim.lsp.buf.hover()
        end
      end,
      desc = "Hover",
    },
    { "gh", vim.lsp.buf.signature_help, desc = "Signature Help", has = "signatureHelp" },
    { "<c-h>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", has = "signatureHelp" },
    {
      "<leader>la",
      function()
        require("actions-preview").code_actions()
      end,
      desc = "Code Action",
      mode = { "n", "v" },
      has = "codeAction",
    },
    {
      "<leader>lA",
      function()
        require("actions-preview").code_actions { context = { only = { "source" } } }
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
    { "<leader>ld", vim.diagnostic.open_float, desc = "floating diagnostic" },
    { "[d", diagnostic_goto(false), desc = "prev diagnostic" },
    { "]d", diagnostic_goto(true), desc = "next diagnostic" },
    { "[e", diagnostic_goto(false, "ERROR"), desc = "prev diagnostic error" },
    { "]e", diagnostic_goto(true, "ERROR"), desc = "next diagnostic error" },
  }
  return M._keys
end

function M.has(...)
  return require("lazyvim.plugins.lsp.keymaps").has(...)
end

function M.resolve(buffer)
  local Keys = require "lazy.core.handler.keys"
  if not Keys.resolve then
    return {}
  end
  local spec = vim.tbl_extend("force", {}, M.get())
  local lspconfigOpts = lazyUtils.opts "nvim-lspconfig"
  local clients = lspUtils.get_clients { bufnr = buffer }
  for _, client in ipairs(clients) do
    local maps = lspconfigOpts.servers[client.name] and lspconfigOpts.servers[client.name].keys or {}
    vim.list_extend(spec, maps)
  end
  return Keys.resolve(spec)
end

function M.on_attach(_, buffer)
  local Keys = require "lazy.core.handler.keys"
  local keymaps = M.resolve(buffer)

  for _, keys in pairs(keymaps) do
    local has = not keys.has or M.has(buffer, keys.has)
    local cond = not (keys.cond == false or ((type(keys.cond) == "function") and not keys.cond()))

    if has and cond then
      local opts = Keys.opts(keys)
      opts.cond = nil
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
    end
  end
end

return M
