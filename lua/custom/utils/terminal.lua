local M = {}

local terminals = {}

M.toggle = function(cmd, opts)
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

M.exit_terminal_mode = vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true)

M.toggle_scratch_term = function()
  M.toggle(nil, {
    cwd = vim.uv.cwd(),
    size = { width = 0.8, height = 0.8 },
    border = "single",
  })
end

return M
