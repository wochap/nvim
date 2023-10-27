local M = {}

M.close_all_floating = function()
  local present, cmp = pcall(require, "cmp")

  if not present then
    return
  end

  if cmp.visible() then
    return
  end

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      vim.api.nvim_win_close(win, false)
      print("Closing window", win)
    end
  end
end

return M
