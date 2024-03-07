local M = {}

local terminals = {}

function M.toggle(cmd, opts)
  opts = vim.tbl_deep_extend("force", {
    ft = "term",
    size = { width = 0.5, height = 0.5 },
  }, opts or {}, { persistent = true })

  local termkey = vim.inspect {
    cmd = cmd or "shell",
    cwd = opts.cwd,
    env = opts.env,
    count = vim.v.count1,
  }

  if terminals[termkey] and terminals[termkey]:buf_valid() then
    terminals[termkey]:toggle()
  else
    terminals[termkey] = require("lazy.util").float_term(cmd, opts)
    local buf = terminals[termkey].buf

    vim.api.nvim_create_autocmd("BufEnter", {
      buffer = buf,
      callback = function()
        vim.cmd.startinsert()
      end,
    })
  end

  return terminals[termkey]
end

return M
