local M = {}

M.init = function()
  vim.g.rainbow_delimiters = {
    query = {
      javascript = "rainbow-parens",
    },
    highlight = {
      "rainbow1",
      "rainbow2",
      "rainbow3",
      "rainbow4",
      "rainbow5",
      "rainbow6",
    },
    whitelist = { "javascript" },
  }
end

return M

