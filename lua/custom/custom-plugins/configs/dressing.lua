local M = {}

M.init = function()
  vim.ui.select = function(...)
    require("lazy").load { plugins = { "dressing.nvim" } }
    return vim.ui.select(...)
  end
  vim.ui.input = function(...)
    require("lazy").load { plugins = { "dressing.nvim" } }
    return vim.ui.input(...)
  end
end

M.options = {
  input = {
    override = function(conf)
      conf.col = -1
      conf.row = 0
      return conf
    end,
  },
}

return M
