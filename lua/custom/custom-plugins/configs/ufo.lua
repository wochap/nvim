local M = {}

M.setup = function()
  vim.opt.foldcolumn = "1" -- '0' is not bad
  vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
  vim.opt.foldlevelstart = 99
  vim.opt.foldenable = true

  require("ufo").setup()
end

return M
