local M = {}

M.matches_any_regex = function(str, tbl)
  for _, pattern in ipairs(tbl) do
    if string.match(str, pattern) then
      return true
    end
  end
  return false
end

M.remove_str_from_list = function(list, str)
  for i, value in ipairs(list) do
    if value == str then
      table.remove(list, i)
    end
  end
end

M.list_merge = function(...)
  local lists = {}
  for _, list in ipairs { ... } do
    vim.list_extend(lists, list)
  end
  return lists
end

M.tbl_merge = function(...)
  return LazyVim.merge(...)
end

return M
