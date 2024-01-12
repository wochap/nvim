local M = {}

M.options = {
  textobjects = {
    move = {
      enable = true,
      goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
      goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
      goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
      goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
    },
  },

  indent = {
    enable = true,
  },

  highlight = { -- Be sure to enable highlights if you haven't!
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = false,
      node_decremental = "<bs>",
    },
  },

  ensure_installed = {
    "git_config",
    "markdown",
    "markdown_inline",
    "query",
    "rasi",
    "regex",
    "vim",
    "vimdoc",
    -- "dap_repl",
    -- "norg"
  },
}

return M
