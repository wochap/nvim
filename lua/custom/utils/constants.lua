local M = {}

M.diagnostic_icons = {
  Error = "󰅚 ",
  Warn = " ",
  Info = " ",
  Hint = "󰛩 ",
}

-- NOTE: you can't exclude empty filetypes
M.exclude_filetypes = {
  "DiffviewFileHistory",
  "DiffviewFiles",
  "NvimTree",
  "TelescopePrompt",
  "TelescopeResults",
  "Trouble",
  "dap-repl",
  "dapui_breakpoints",
  "dapui_console",
  "dapui_scopes",
  "dapui_stacks",
  "dapui_watches",
  "help",
  "lazy",
  "lazyterm",
  "leetcode.nvim",
  "lspinfo",
  "mason",
  "neo-tree",
  "notify",
  "oil",
  "qf",
  "terminal",
  "toggleterm",
  "trouble",
  "vim",
  "wk",
}

M.exclude_buftypes = {
  "terminal",
  "nofile",
}

M.in_foot = os.getenv "TERM" == "foot"

M.in_kitty = os.getenv "TERM" == "xterm-kitty"

local neorg_arg = "neorg"
M.in_neorg = neorg_arg == vim.fn.argv()[1]

local leet_arg = "leetcode.nvim"
M.in_leetcode = leet_arg == vim.fn.argv()[1]

local kitty_arg = "kitty-scrollback"
M.in_kittyscrollback = kitty_arg == vim.fn.argv()[1]

-- M.transparent_background = not vim.g.neovide
M.transparent_background = false

-- HACK: this variable is used to prevent importing
-- specs from lazyvim on the first install
-- otherwise, we end up with a bunch of errors
M.first_install = false

return M
