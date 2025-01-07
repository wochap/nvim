local M = {}

M.border = function(hl_name)
  return {
    -- just the enought chars to show the scrollbar correctly
    { "╭", hl_name }, -- top left
    { "─", hl_name }, -- top
    { "╮", hl_name }, -- top right
    { " ", hl_name }, -- right
    { " ", hl_name }, -- bottom right
    { " ", hl_name }, -- bottom
    { " ", hl_name }, -- bottom left
    { " ", hl_name }, -- left
  }
end

-- source: https://github.com/Saghen/blink.cmp/issues/569
M.select_next_idx = function(idx, dir)
  dir = dir or 1

  local list = require "blink.cmp.completion.list"
  if #list.items == 0 then
    return
  end

  local target_idx
  -- haven't selected anything yet
  if list.selected_item_idx == nil then
    if dir == 1 then
      target_idx = idx
    else
      target_idx = #list.items - idx
    end
  elseif list.selected_item_idx == #list.items then
    if dir == 1 then
      target_idx = 1
    else
      target_idx = #list.items - idx
    end
  elseif list.selected_item_idx == 1 and dir == -1 then
    target_idx = #list.items - idx
  else
    target_idx = list.selected_item_idx + (idx * dir)
  end

  -- clamp
  if target_idx < 1 then
    target_idx = 1
  elseif target_idx > #list.items then
    target_idx = #list.items
  end

  list.select(target_idx)
end

return M
