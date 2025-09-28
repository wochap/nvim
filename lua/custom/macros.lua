local keymaps_utils = require "custom.utils.keymaps"
local map = keymaps_utils.map

map("n", ",l", function()
  local prev_l = vim.fn.getreg "l"
  local prev_ltype = vim.fn.getregtype "l"
  -- stylua: ignore
  vim.fn.setreg("l", "EF/€ý5€krvE\"zyBi[\"zpa](Ea)")
  -- stylua: ignore end
  vim.cmd "normal! @l"
  vim.fn.setreg("l", prev_l, prev_ltype)
end, "markdown link", { noremap = true })

map("n", ",i", function()
  local register_key = "i"
  local prev_register = vim.fn.getreg(register_key)
  local prev_register_type = vim.fn.getregtype(register_key)
  -- stylua: ignore
  vim.fn.setreg(register_key, "^cwimportf=€ý5vf(€ý5cfrom AF€ý50f)€ý5C")
  -- stylua: ignore end
  vim.cmd("normal! @" .. register_key)
  vim.fn.setreg(register_key, prev_register, prev_register_type)
end, "require to import", { noremap = true })

