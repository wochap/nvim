local M = {}

local constants = require "custom.utils.constants"

M.options = {
  ignore = {
    filetypes = constants.exclude_filetypes,
  },
  hide = {
    focused_win = true,
    only_win = true,
  },
  window = {
    margin = {
      horizontal = 0,
      vertical = 1,
    },
  },
  render = function(props)
    local bufnr = props.buf
    local icon = "󰈚 "
    local modified_indicator = "  "
    local bufname = vim.api.nvim_buf_get_name(props.buf)
    local filename = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "No Name"

    if filename ~= "No Name" then
      local devicons_present, devicons = pcall(require, "nvim-web-devicons")

      if devicons_present then
        local ft_icon, _ = devicons.get_icon(filename)
        icon = (ft_icon ~= nil and ft_icon .. " ") or icon
      end
    end

    if vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
      modified_indicator = " "
    end

    return { { icon }, { filename }, { modified_indicator } }
  end,
}

return M
