local M = {}

local constants = require "custom.utils.constants"

M.options = {
  indent = {
    char = "▎",
    tab_char = "»",
  },
  scope = { enabled = false },
  exclude = {
    filetypes = constants.exclude_filetypes,
    buftypes = constants.exclude_buftypes,
  },
}

return M
