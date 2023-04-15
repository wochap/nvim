function get_relative_path()
  local filename_str = vim.fn.expand "%:t"

  if string.len(filename_str) == 0 then
    return " "
  end

  local filename = vim.api.nvim_buf_get_name(0)
  local relative_path = vim.fn.fnamemodify(filename, ":~:.")

  relative_path = string.sub(relative_path, 1, -1 + string.len(filename_str) * -1)

  return " " .. relative_path
end

return {
  -- separator_style = "block",
  overriden_modules = function()
    local fn = vim.fn
    local sep_style = vim.g.statusline_sep_style
    local separators = (type(sep_style) == "table" and sep_style)
      or require("nvchad_ui.icons").statusline_separators[sep_style]
    local sep_r = separators["right"]

    return {
      fileInfo = function()
        local icon = "  "
        local filename = (fn.expand "%" == "" and "Empty ") or fn.expand "%:t"
        local relative_path = ""

        if filename ~= "Empty " then
          relative_path = get_relative_path()
          local devicons_present, devicons = pcall(require, "nvim-web-devicons")

          if devicons_present then
            local ft_icon = devicons.get_icon(filename)
            icon = (ft_icon ~= nil and " " .. ft_icon) or ""
          end

          filename = filename .. " "
        end

        return "%#St_file_info#"
          .. icon
          .. "%#St_relative_path#"
          .. relative_path
          .. "%#St_file_info#"
          .. filename
          .. "%#St_file_sep#"
          .. sep_r
      end,
    }
  end,
}
