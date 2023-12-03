local M = {}

M.exclude_filetypes = {
  "DiffviewFileHistory",
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
  "leetcode.nvim",
}

M.exclude_buftypes = {
  "terminal",
}

return M
