local M = {}

M.get_highlights = function()
  local C = require("catppuccin.palettes").get_palette()
  -- TODO: check if theme has transparency and set bg to NONE
  local bufferlineBg = C.base
  local bufferlineFg = C.surface1

  return require("catppuccin.groups.integrations.bufferline").get_theme {
    styles = {},
    custom = {
      all = {
        background = {
          bg = bufferlineBg,
          fg = bufferlineFg,
        },
        fill = {
          bg = bufferlineBg,
        },
        tab = {
          bg = bufferlineBg,
          fg = bufferlineFg,
        },
        tab_selected = {
          bg = bufferlineBg,
          fg = C.lavender,
        },
        tab_separator = {
          bg = bufferlineBg,
          fg = C.base,
        },
        tab_separator_selected = {
          bg = bufferlineBg,
          fg = C.base,
        },
        buffer_visible = {
          bg = bufferlineBg,
          fg = bufferlineFg,
        },
        buffer_selected = {
          bg = bufferlineBg,
          fg = C.lavender,
        },
        duplicate_selected = {
          bg = bufferlineBg,
          fg = C.lavender,
        },
        duplicate_visible = {
          bg = bufferlineBg,
          fg = bufferlineFg,
        },
        duplicate = {
          bg = bufferlineBg,
          fg = bufferlineFg,
        },
        numbers = {
          bg = bufferlineBg,
          fg = bufferlineFg,
        },
        numbers_visible = {
          bg = bufferlineBg,
          fg = bufferlineFg,
        },
        numbers_selected = {
          bg = bufferlineBg,
          fg = C.lavender,
        },
        modified = {
          bg = bufferlineBg,
          fg = bufferlineFg,
        },
        modified_visible = {
          bg = bufferlineBg,
          fg = bufferlineFg,
        },
        modified_selected = {
          bg = bufferlineBg,
          fg = C.green,
        },
        indicator_visible = {
          bg = bufferlineBg,
        },
        indicator_selected = {
          bg = bufferlineBg,
        },
        trunc_marker = {
          bg = bufferlineBg,
          fg = bufferlineFg,
        },
      },
    },
  }
end

return M
