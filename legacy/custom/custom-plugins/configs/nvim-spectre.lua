local M = {}

M.options = {
  highlight = {
    ui = "String",
    search = "SpectreSearch",
    replace = "DiffAdd",
  },
  mapping = {
    ["send_to_qf"] = {
      map = "<C-q>",
      cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
      desc = "send all item to quickfix",
    },
  },
}

return M
