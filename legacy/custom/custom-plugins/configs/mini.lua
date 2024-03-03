local M = {}

M.setup = function()
  require("mini.surround").setup {
    mappings = {
      add = "gsa", -- Add surrounding in Normal and Visual modes
      delete = "gsd", -- Delete surrounding
      find = "gsf", -- Find surrounding (to the right)
      find_left = "gsF", -- Find surrounding (to the left)
      highlight = "gsh", -- Highlight surrounding
      replace = "gsr", -- Replace surrounding
      update_n_lines = "gsn", -- Update `n_lines`

      suffix_last = "l", -- Suffix to search with "prev" method
      suffix_next = "n", -- Suffix to search with "next" method
    },
  }

  require("mini.bracketed").setup {
    buffer = { suffix = "" },
    comment = { suffix = "" },
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
      prefix = "gss",
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

  -- Better text-objects
  local ai = require "mini.ai"
  ai.setup {
    n_lines = 500,
    custom_textobjects = {
      o = ai.gen_spec.treesitter({
        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
      }, {}),
      f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
      c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
      t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
    },
  }
  require("lazyvim.util").on_load("which-key.nvim", function()
    local i = {
      [" "] = "Whitespace",
      ['"'] = 'Balanced "',
      ["'"] = "Balanced '",
      ["`"] = "Balanced `",
      ["("] = "Balanced (",
      [")"] = "Balanced ) including white-space",
      [">"] = "Balanced > including white-space",
      ["<lt>"] = "Balanced <",
      ["]"] = "Balanced ] including white-space",
      ["["] = "Balanced [",
      ["}"] = "Balanced } including white-space",
      ["{"] = "Balanced {",
      ["?"] = "User Prompt",
      _ = "Underscore",
      a = "Argument",
      b = "Balanced ), ], }",
      c = "Class",
      f = "Function",
      o = "Block, conditional, loop",
      q = "Quote `, \", '",
      t = "Tag",
    }
    local a = vim.deepcopy(i)
    for k, v in pairs(a) do
      a[k] = v:gsub(" including.*", "")
    end

    local ic = vim.deepcopy(i)
    local ac = vim.deepcopy(a)
    for key, name in pairs { n = "Next", l = "Last" } do
      i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
      a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
    end
    require("which-key").register {
      mode = { "o", "x" },
      i = i,
      a = a,
    }
  end)
end

return M
