local M = {}

M.statuscolumn = function()
  return package.loaded.snacks and require("snacks.statuscolumn").get() or ""
end

return M
