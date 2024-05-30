local M = {}

M.register = function(formatter)
  local lazyvimFormatUtils = require "lazyvim.util.format"
  lazyvimFormatUtils.register(formatter)
end

M.resolve = function(buf)
  local lazyvimFormatUtils = require "lazyvim.util.format"
  return lazyvimFormatUtils.resolve(buf)
end

M.format = function(opts)
  local lazyCoreUtils = require "lazy.core.util"
  opts = opts or {}
  local buf = opts.buf or vim.api.nvim_get_current_buf()
  if not (opts and opts.force) then
    return
  end
  local done = false
  for _, formatter in ipairs(M.resolve(buf)) do
    if formatter.active then
      done = true
      lazyCoreUtils.try(function()
        return formatter.format(buf)
      end, { msg = "Formatter `" .. formatter.name .. "` failed" })
    end
  end
  if not done and opts and opts.force then
    lazyCoreUtils.warn("No formatter available", { title = "Conform" })
  end
end

M.info = function(buf)
  local lazyCoreUtils = require "lazy.core.util"
  buf = buf or vim.api.nvim_get_current_buf()
  local lines = {
    "# Status",
  }
  local have = false
  for _, formatter in ipairs(M.resolve(buf)) do
    if #formatter.resolved > 0 then
      have = true
      lines[#lines + 1] = "\n# " .. formatter.name .. (formatter.active and " ***(active)***" or "")
      for _, line in ipairs(formatter.resolved) do
        lines[#lines + 1] = ("- [%s] **%s**"):format(formatter.active and "x" or " ", line)
      end
    end
  end
  if not have then
    lines[#lines + 1] = "\n***No formatters available for this buffer.***"
  end
  lazyCoreUtils.info(table.concat(lines, "\n"), { title = "CustomFormat" })
end

M.setup = function()
  -- Manual format
  vim.api.nvim_create_user_command("CustomFormat", function()
    M.format { force = true }
  end, { desc = "Format selection or buffer" })

  -- Format info
  vim.api.nvim_create_user_command("CustomFormatInfo", function()
    M.info()
  end, { desc = "Show info about the formatters for the current buffer" })
end

return M
