local M = {}

M.register = function(...)
  require("lazyvim.util.format").register(...)
end

M.resolve = function(...)
  return require("lazyvim.util.format").resolve(...)
end

M.format = function(...)
  require("lazyvim.util.format").format(...)
end

M.info = function(...)
  require("lazyvim.util.format").info(...)
end

M.setup = function()
  -- NOTE: uncomment if you want Autoformat
  -- vim.api.nvim_create_autocmd("BufWritePre", {
  --   group = vim.api.nvim_create_augroup("LazyFormat", {}),
  --   callback = function(event)
  --     M.format({ buf = event.buf })
  --   end,
  -- })

  -- Manual format
  vim.api.nvim_create_user_command("LazyFormat", function()
    M.format { force = true }
  end, { desc = "Format selection or buffer" })

  -- Format info
  vim.api.nvim_create_user_command("LazyFormatInfo", function()
    M.info()
  end, { desc = "Show info about the formatters for the current buffer" })
end

return M
