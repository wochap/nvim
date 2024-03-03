local M = {}

M.options = {
  cmdline = {
    enabled = false,
  },
  messages = {
    enabled = false,
  },
  popupmenu = {
    enabled = false,
  },
  notify = {
    enabled = false,
  },
  lsp = {
    progress = {
      enabled = false,
    },
    message = {
      enabled = false,
    },
    hover = {
      enabled = true,
    },
    signature = {
      enabled = true,
      -- automatically show signature help when typing
      auto_open = {
        enabled = true,
      },
      opts = {
        -- TODO: add max_height and max_width, noice doesn't support them yet
        -- TODO: add border, noice doesn't position the window correctly with border enabled
      },
    },
    override = {
      -- better highlighting for lsp signature/hover windows
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
}

M.keys = {
  -- scroll signature/hover windows
  {
    "<c-u>",
    function()
      if not require("noice.lsp").scroll(-4) then
        return "<c-u>"
      end
    end,
    silent = true,
    expr = true,
    desc = "Scroll backward",
    mode = { "i", "n", "s" },
  },
  {
    "<c-d>",
    function()
      if not require("noice.lsp").scroll(4) then
        return "<c-d>"
      end
    end,
    silent = true,
    expr = true,
    desc = "Scroll forward",
    mode = { "i", "n", "s" },
  },
}

return M
