local M = {}

M.matchesAnyRegex = function(str, tbl)
  for _, pattern in ipairs(tbl) do
    if string.match(str, pattern) then
      return true
    end
  end
  return false
end

return M
