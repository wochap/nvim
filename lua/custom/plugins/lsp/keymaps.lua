local blinkCmpUtils = require "custom.utils-plugins.blink-cmp"
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
      function()
        Snacks.picker.lsp_references {
          jump = { reuse_win = false },
        }
      end,
      desc = "References",
      nowait = true,
    },
    {
      "gD",
      function()
        Snacks.picker.lsp_declarations {
          jump = { reuse_win = false },
        }
      end,
      desc = "Goto Declaration",
      has = "declaration",
    },
    {
      "gd",
      function()
        Snacks.picker.lsp_definitions {
          jump = { reuse_win = false },
        }
      end,
      desc = "Goto Definition",
      has = "definition",
    },
    {
      "gI",
      function()
        Snacks.picker.lsp_implementations {
          jump = { reuse_win = false },
        }
      end,
      desc = "Goto Implementation",
    },
    {
      "gy",
      function()
        Snacks.picker.lsp_type_definitions {
          jump = { reuse_win = false },
        }
      end,
      desc = "Goto Type Definition",
    },
    {
      "gH",
      function()
        vim.lsp.buf.hover()
      end,
      desc = "Hover",
    },
    {
      "gh",
      function()
        blinkCmpUtils.show_signature()
      end,
      desc = "Signature Help",
      has = "signatureHelp",
    },
    {
      "<c-h>",
      function()
        blinkCmpUtils.show_signature()
      end,
      mode = "i",
      desc = "Signature Help",
      has = "signatureHelp",
    },
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
        vim.lsp.buf.rename()
        -- save all buffers after rename
        vim.cmd "silent! wa"
      end,
      expr = true,
      desc = "Rename (Word)",
      has = "rename",
    },
    {
      "<leader>lR",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename (Buffer)",
      has = { "workspace/didRenameFiles", "workspace/willRenameFiles" },
    },
    { "<leader>ld", vim.diagnostic.open_float, desc = "Diagnostic" },
    { "[d", diagnostic_goto(false), desc = "Prev Diagnostic" },
    { "]d", diagnostic_goto(true), desc = "Next Diagnostic" },
    { "[e", diagnostic_goto(false, "ERROR"), desc = "Prev Diagnostic (Error)" },
    { "]e", diagnostic_goto(true, "ERROR"), desc = "Next Diagnostic (Error)" },
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
