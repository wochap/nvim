local M = {}

M.remove_str_from_list = function(list, str)
  for i, value in ipairs(list) do
    if value == str then
      table.remove(list, i)
    end
  end
end

M.disable_ufo = function()
  local has_ufo, ufo = pcall(require, "ufo")
  if not has_ufo then
    return
  end
  pcall(ufo.detach)
  vim.opt_local.foldenable = false
  vim.opt_local.foldcolumn = "0"
end

M.disable_statuscol = function()
  vim.api.nvim_set_option_value("stc", "", { scope = "local" })
end

return M
