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
  _signs_staged_enable = true,
  _signs_staged = {
    add = {
      hl = "GitSignsStagedAdd",
      text = "▍",
    },
    change = {
      hl = "GitSignsStagedChange",
      text = "▍",
    },
    delete = {
      hl = "GitSignsStagedDelete",
      text = "",
    },
    changedelete = {
      hl = "GitSignsStagedChange",
      text = "▍",
    },
    topdelete = {
      hl = "GitSignsStagedDelete",
      text = "",
    },
  },
}

return M
