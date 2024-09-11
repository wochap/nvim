local M = {}

-- NOTE: you can't exclude empty filetypes
M.exclude_filetypes = {
  -- diffview.nvim
  "DiffviewFileHistory",
  "DiffviewFiles",
  -- nvim-tree.lua
  "NvimTree",
  -- telescope.nvim
  "TelescopePrompt",
  "TelescopeResults",
  -- trouble.nvim
  "trouble",
  -- nvim-dap
  "dap-repl",
  "dapui_breakpoints",
  "dapui_console",
  "dapui_scopes",
  "dapui_stacks",
  "dapui_watches",
  -- lazy.nvim
  "lazy",
  -- nvim-lspconfig
  "lspinfo",
  -- leetcode.nvim
  "leetcode.nvim",
  -- mason.nvim
  "mason",
  -- neo-tree.nvim
  "neo-tree",
  -- oil.nvim
  "oil",
  -- which-key.nvim
  "wk",
  -- noice.nvim
  "noice",
  -- grug-far.nvim
  "grug-far",
  "grug-far-history",
  "grug-far-help",
  -- harpoon
  "harpoon",
  -- incline.nvim
  "incline",
  -- nvim
  "help",
  "qf",
  "notify",
  "terminal",
  "vim",
}

M.exclude_buftypes = {
  "terminal",
  "nofile",
}

M.in_foot = os.getenv "TERM" == "foot"

M.in_kitty = os.getenv "TERM" == "xterm-kitty"

M.in_neovide = vim.g.neovide

local zk_arg = "zk"
M.in_zk = zk_arg == vim.fn.argv()[1]

local leet_arg = "leetcode.nvim"
M.in_leetcode = leet_arg == vim.fn.argv()[1]

local kitty_arg = "kitty-scrollback"
M.in_kittyscrollback = kitty_arg == vim.fn.argv()[1]

-- nvim is opening a file from the cmdline
M.has_file_arg = vim.fn.argc(-1) > 0 and not M.in_zk and not M.in_leetcode and not M.in_kittyscrollback

-- M.transparent_background = not vim.g.neovide
M.transparent_background = false

-- HACK: this variable is used to prevent importing
-- specs from lazyvim on the first install
-- otherwise, we end up with a bunch of errors
M.first_install = false

local es_spell_path = vim.fn.stdpath "data" .. "/site/spell/es.utf-8.spl"
M.disable_netrw = vim.loop.fs_stat(es_spell_path) and true or false

return M
