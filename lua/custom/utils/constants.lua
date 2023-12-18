local M = {}

M.exclude_filetypes = {
  "DiffviewFileHistory",
  "DiffviewFiles",
  "NvimTree",
  "TelescopePrompt",
  "TelescopeResults",
  "Trouble",
  "alpha",
  "dap-repl",
  "dapui_breakpoints",
  "dapui_console",
  "dapui_scopes",
  "dapui_stacks",
  "dapui_watches",
  "dashboard",
  "help",
  "lazy",
  "lazyterm",
  "leetcode.nvim",
  "lspinfo",
  "mason",
  "neo-tree",
  "notify",
  "nvcheatsheet",
  "nvdash",
  "oil",
  "qf",
  "terminal",
  "toggleterm",
  "trouble",
}

M.exclude_buftypes = {
  "terminal",
}

local neorg_arg = "neorg"
M.in_neorg = neorg_arg == vim.fn.argv()[1]

local leet_arg = "leetcode.nvim"
M.in_leetcode = leet_arg == vim.fn.argv()[1]

local kitty_arg = "kitty-scrollback"
M.in_kittyscrollback = kitty_arg == vim.fn.argv()[1]

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
M.lazyPathExists = vim.loop.fs_stat(lazypath)

return M
