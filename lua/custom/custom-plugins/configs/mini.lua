local M = {}

M.setup = function()
  require("mini.surround").setup {
    mappings = {
      add = "sa", -- Add surrounding in Normal and Visual modes
      delete = "sd", -- Delete surrounding
      find = "sf", -- Find surrounding (to the right)
      find_left = "sF", -- Find surrounding (to the left)
      highlight = "sh", -- Highlight surrounding
      replace = "sr", -- Replace surrounding
      update_n_lines = "sn", -- Update `n_lines`

      suffix_last = "l", -- Suffix to search with "prev" method
      suffix_next = "n", -- Suffix to search with "next" method
    },
  }

  require("mini.bracketed").setup {
    buffer = { suffix = "" },
    comment = { suffix = "c" },
    conflict = { suffix = "" },
    diagnostic = { suffix = "" },
    file = { suffix = "" },
    indent = { suffix = "" },
    jump = { suffix = "j" },
    location = { suffix = "l" },
    oldfile = { suffix = "o" },
    quickfix = { suffix = "q" },
    treesitter = { suffix = "s" },
    undo = { suffix = "" },
    window = { suffix = "" },
    yank = { suffix = "" },
  }

  -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-align.md
  -- ga or gA
  require("mini.align").setup {}

  require("mini.operators").setup {
    evaluate = {
      prefix = "",
    },
    exchange = {
      prefix = "gx",
      reindent_linewise = false,
    },
    multiply = {
      prefix = "",
    },
    replace = {
      prefix = "",
    },
    sort = {
      prefix = "gs",
      reindent_linewise = false,
    },
  }

  require("mini.move").setup {
    mappings = {
      left = "<A-Left>",
      right = "<A-Right>",
      down = "<A-Down>",
      up = "<A-Up>",
      line_left = "<A-Left>",
      line_right = "<A-Right>",
      line_down = "<A-Down>",
      line_up = "<A-Up>",
    },
    options = {
      reindent_linewise = false,
    },
  }
end

return M
