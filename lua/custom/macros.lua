local keymapsUtils = require "custom.utils.keymaps"
local map = keymapsUtils.map

map("n", ",l", function()
  local prev_l = vim.fn.getreg "l"
  local prev_ltype = vim.fn.getregtype "l"
  -- stylua: ignore
  vim.fn.setreg("l", "EF/ý5krvE\"zyBi[\"zpa](Ea)")
  -- stylua: ignore end
  vim.cmd "normal! @l"
  vim.fn.setreg("l", prev_l, prev_ltype)
end, "markdown link", { noremap = true })
