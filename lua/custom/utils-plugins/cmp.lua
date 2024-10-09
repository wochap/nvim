local defer = require "custom.utils.defer"

local M = {}

M.border = function(hl_name)
  return {
    -- just the enought chars to show the scrollbar correctly
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { " ", hl_name },
    { " ", hl_name },
    { " ", hl_name },
    { " ", hl_name },
    { " ", hl_name },
  }
end

M.select_prev_item = function(fallback)
  local cmp = require "cmp"
  if cmp.visible() then
    cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
  else
    cmp.complete()
  end
end

M.select_next_item = function(fallback)
  local cmp = require "cmp"
  if cmp.visible() then
    cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
  else
    cmp.complete()
  end
end

M.scroll = function(count)
  return function(fallback)
    local cmp = require "cmp"
    if cmp.visible() then
      cmp.select_next_item {
        behavior = cmp.SelectBehavior.Insert,
        count = count,
      }
    else
      cmp.complete()
    end
  end
end

local async_cmp_close = function()
  local cmp = require "cmp"
  vim.schedule(function()
    -- HACK: we don't use cmp.close because that is a sync operation
    if cmp.core.view:visible() or vim.fn.pumvisible() == 1 then
      local release = cmp.core:suspend()
      cmp.core.view:close()
      vim.schedule(release)
    end
  end)
end
M.async_cmp_close_tl = defer.throttle_leading(async_cmp_close, 100)

return M
