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

return M
