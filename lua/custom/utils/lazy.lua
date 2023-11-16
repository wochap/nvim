local M = {}

M.find_spec = function(tbl, target)
  for _, entry in ipairs(tbl) do
    if entry[1] == target then
      return entry
    end
  end
end

return M
