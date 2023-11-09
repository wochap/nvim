local M = {}

M.options = {
  signs = {
    add = {
      hl = "GitSignsAdd",
      text = "▍",
    },
    change = {
      hl = "GitSignsChange",
      text = "▍",
    },
    delete = {
      hl = "GitSignsDelete",
      text = "",
    },
    changedelete = {
      hl = "GitSignsChange",
      text = "▍",
    },
    topdelete = {
      hl = "GitSignsDelete",
      text = "",
    },
    untracked = {
      hl = "GitSignsAdd",
      text = "▍",
    },
  },
}

return M
