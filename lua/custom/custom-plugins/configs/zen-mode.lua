local M = {}

M.options = {
  window = {
    backdrop = 1,
    width = 130, -- width of the Zen window
    height = 1, -- height of the Zen window
    options = {
      cursorline = false,
      cursorcolumn = false,
    },
  },
  plugins = {
    options = {
      enabled = true,
      ruler = false, -- disables the ruler text in the cmd line area
      showcmd = false, -- disables the command in the last line of the screen
      laststatus = 0,
    },
    twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
    gitsigns = { enabled = true }, -- disables git signs
  },
  on_open = function()
    vim.cmd "IBLDisable"
    vim.opt_local.foldcolumn = "0"
  end,
  on_close = function()
    vim.cmd "IBLEnable"
  end,
}

return M
