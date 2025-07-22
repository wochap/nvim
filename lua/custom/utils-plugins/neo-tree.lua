local M = {}

M.revert_preview = function(...)
  return require("neo-tree.sources.common.commands").revert_preview(...)
end

M.toggle_node = function(...)
  return require("neo-tree.sources.common.commands").toggle_node(...)
end

---Open file or expandable node
---@param state table The state of the source
---@param open_cmd string The vim command to use to open the file
---@param toggle_directory function The function to call to toggle a directory
---open/closed
local open_with_cmd = function(state, open_cmd, toggle_directory, open_file)
  local log = require "neo-tree.log"
  local utils = require "neo-tree.utils"

  local tree = state.tree
  local success, node = pcall(tree.get_node, tree)
  if not (success and node) then
    log.debug "Could not get node."
    return
  end

  local function open()
    M.revert_preview()
    local path = node.path or node:get_id()
    local bufnr = node.extra and node.extra.bufnr
    if node.type == "terminal" then
      path = node:get_id()
    end
    if type(open_file) == "function" then
      open_file(state, path, open_cmd, bufnr)
    else
      utils.open_file(state, path, open_cmd, bufnr)
    end
    local extra = node.extra or {}
    local pos = extra.position or extra.end_position
    if pos ~= nil then
      vim.api.nvim_win_set_cursor(0, { (pos[1] or 0) + 1, pos[2] or 0 })
      vim.api.nvim_win_call(0, function()
        vim.cmd "normal! zvzz" -- expand folds and center cursor
      end)
    end
  end

  local config = state.config or {}
  if node.type == "file" and config.no_expand_file ~= nil then
    log.warn "`no_expand_file` options is deprecated, move to `expand_nested_files` (OPPOSITE)"
    config.expand_nested_files = not config.no_expand_file
  end

  local should_expand_file = config.expand_nested_files and not node:is_expanded()
  if utils.is_expandable(node) and (node.type ~= "file" or should_expand_file) then
    M.toggle_node(state, toggle_directory)
  else
    open()
  end
end

---Marks potential windows with letters and will open the give node in the picked window.
---@param state table The state of the source
---@param path string The path to open
---@param cmd string Command that is used to perform action on picked window
local use_window_picker = function(state, path, cmd)
  local log = require "neo-tree.log"

  local success, picker = pcall(require, "window-picker")
  if not success then
    print "You'll need to install window-picker to use this command: https://github.com/s1n7ax/nvim-window-picker"
    return
  end
  local events = require "neo-tree.events"
  local event_result = events.fire_event(events.FILE_OPEN_REQUESTED, {
    state = state,
    path = path,
    open_cmd = cmd,
  }) or {}
  if event_result.handled then
    events.fire_event(events.FILE_OPENED, path)
    return
  end
  local ok, picked_window_id = pcall(picker.pick_window, {
    include_current_win = true,
  })
  if not ok then
    -- no windows available to select
    picked_window_id = 0
  end
  if not ok and cmd == "edit" then
    return
  end
  if picked_window_id then
    vim.api.nvim_set_current_win(picked_window_id)
    ---@diagnostic disable-next-line: param-type-mismatch
    local result, err = pcall(vim.cmd, cmd .. " " .. vim.fn.fnameescape(path))
    if result or err == "Vim(edit):E325: ATTENTION" then
      -- fixes #321
      vim.bo[0].buflisted = true
      events.fire_event(events.FILE_OPENED, path)
    else
      log.error("Error opening file:", err)
    end
  end
end

---Marks potential windows with letters and will open the give node in the picked window.
M.open_with_window_picker = function(state)
  local fs = require "neo-tree.sources.filesystem"
  local utils = require "neo-tree.utils"
  local toggle_directory = utils.wrap(fs.toggle_directory, state)

  open_with_cmd(state, "edit", toggle_directory, use_window_picker)
end

---Marks potential windows with letters and will open the give node in a split next to the picked window.
M.split_with_window_picker = function(state)
  local fs = require "neo-tree.sources.filesystem"
  local utils = require "neo-tree.utils"
  local toggle_directory = utils.wrap(fs.toggle_directory, state)

  open_with_cmd(state, "split", toggle_directory, use_window_picker)
end

---Marks potential windows with letters and will open the give node in a vertical split next to the picked window.
M.vsplit_with_window_picker = function(state)
  local fs = require "neo-tree.sources.filesystem"
  local utils = require "neo-tree.utils"
  local toggle_directory = utils.wrap(fs.toggle_directory, state)

  open_with_cmd(state, "vsplit", toggle_directory, use_window_picker)
end

return M
