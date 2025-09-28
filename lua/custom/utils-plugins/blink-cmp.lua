local nvimUtils = require "custom.utils.nvim"

local M = {}

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

M.scroll_signature_up = function(count)
  local cmp = require "blink.cmp"
  local config = require("blink.cmp.config").signature
  if not config.enabled or not cmp.is_signature_visible() then
    return
  end
  local signature = require "blink.cmp.signature.window"
  vim.schedule(function()
    signature.scroll_up(count or 4)
  end)
  return true
end

M.scroll_signature_down = function(count)
  local cmp = require "blink.cmp"
  local config = require("blink.cmp.config").signature
  if not config.enabled or not cmp.is_signature_visible() then
    return
  end
  local signature = require "blink.cmp.signature.window"
  vim.schedule(function()
    signature.scroll_down(count or 4)
  end)
  return true
end

M.show_signature = function()
  local cmp = require "blink.cmp"
  local config = require("blink.cmp.config").signature
  if not config.enabled or cmp.is_signature_visible() then
    return
  end
  vim.schedule(function()
    require("blink.cmp.signature.trigger").show()
    -- HACK: scroll the signature window to the top
    -- sometimes it opens already scrolled down
    nvimUtils.set_timeout(250, function()
      local signature = require "blink.cmp.signature.window"
      local winnr = signature.win:get_win()
      if winnr == nil then
        vim.notify "No signature help available"
        return
      end
      vim.api.nvim_win_set_cursor(winnr, { 1, 0 })
    end)
  end)
  return true
end

M.hide_signature = function()
  local cmp = require "blink.cmp"
  if not cmp.is_signature_visible() then
    return
  end
  cmp.hide_signature()
  return true
end

M.inside_comment_block = function()
  if vim.api.nvim_get_mode().mode ~= "i" then
    return false
  end
  local node_under_cursor = vim.treesitter.get_node()
  local parser = vim.treesitter.get_parser(nil, nil, { error = false })
  if not parser then
    return false
  end
  local query = vim.treesitter.query.get(parser:lang(), "highlights")
  if not node_under_cursor or not query then
    return false
  end
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  for id, node, _ in query:iter_captures(node_under_cursor, 0, row, row + 1) do
    if query.captures[id]:find "comment" then
      local start_row, start_col, end_row, end_col = node:range()
      if start_row <= row and row <= end_row then
        if start_row == row and end_row == row then
          if start_col <= col and col <= end_col then
            return true
          end
        elseif start_row == row then
          if start_col <= col then
            return true
          end
        elseif end_row == row then
          if col <= end_col then
            return true
          end
        else
          return true
        end
      end
    end
  end
  return false
end

return M
