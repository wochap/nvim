local M = {}

M.remove_str_from_list = function(list, str)
  for i, value in ipairs(list) do
    if value == str then
      table.remove(list, i)
    end
  end
end

return M
