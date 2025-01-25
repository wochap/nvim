local M = {}

M.window_pick = function()
  local ok, winid = pcall(require("window-picker").pick_window, {
    include_current_win = true,
  })
  if not ok then
    -- no windows available to select
    return 0
  end
  if not winid then
    -- user cancelled pick_window
    return nil
  end
  return winid
end

return M
