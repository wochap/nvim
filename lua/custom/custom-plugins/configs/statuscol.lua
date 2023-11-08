local M = {}

local constants = require "custom.utils.constants"
local builtin = require "statuscol.builtin"

M.options = {
  ft_ignore = constants.exclude_filetypes,
  bt_ignore = constants.exclude_buftypes,
  segments = {
    -- {
    --   text = { "%s" },
    --   condition = { true },
    --   click = "v:lua.ScSa",
    -- },
    {
      text = { " " },
      condition = { true },
    },
    {
      sign = { name = { "Dap*" }, namespace = { "bulb*" } },
      click = "v:lua.ScSa",
    },
    {
      text = { builtin.lnumfunc, " " },
      condition = { true, builtin.not_empty },
      click = "v:lua.ScLa",
    },
    {
      sign = { namespace = { "gitsign*" }, colwidth = 1 },
      click = "v:lua.ScSa",
    },
    {
      text = { builtin.foldfunc, "  " },
      condition = { true, builtin.not_empty },
      click = "v:lua.ScFa",
    },
  },
}

return M
