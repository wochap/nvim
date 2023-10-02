local wk = require "which-key"
local M = {}

M.setup = function()
  wk.register({
    o = {
      name = "neorg",
    },
    g = { name = "git" },
    f = { name = "find" },
    d = { name = "dap" },
    h = { name = "harpon" },
    l = { name = "lsp" },
    p = { name = "lazy" },
    q = { name = "quit" },
    t = { name = "todo" },
    T = { name = "terminal" },
    x = { name = "trouble" },
  }, { prefix = "<leader>" })
end

return M
