local present, bufferline = pcall(require, "bufferline")
if not present then
   return
end

local default = {
   colors = require("colors").get(),
}
local bufferlineColors = {
   focused = {
      fg = default.colors.white,
      bg = default.colors.black,
   },
   unfocused = {
      fg = default.colors.light_grey,
      bg = default.colors.black2,
   },
}

default = {
   options = {
      offsets = {
         {
            filetype = "NvimTree",
            highlight = "CustomDirectory",
            padding = 0,
            text = "  File Explorer",
            text_align = "left",
         },
         {
            filetype = "DiffviewFiles",
            highlight = "CustomDirectory",
            padding = 0,
            text = "  Diff view",
            text_align = "left",
         },
      },
      buffer_close_icon = "",
      modified_icon = "",
      close_icon = "",
      show_close_icon = false,
      left_trunc_marker = "",
      right_trunc_marker = "",
      max_name_length = 14,
      max_prefix_length = 13,
      tab_size = 20,
      show_tab_indicators = true,
      enforce_regular_tabs = false,
      view = "multiwindow",
      show_buffer_close_icons = false,
      separator_style = "thin",
      always_show_bufferline = true,
      diagnostics = false,
      custom_filter = function(buf_number)
         -- Func to filter out our managed/persistent split terms
         local present_type, type = pcall(function()
            return vim.api.nvim_buf_get_var(buf_number, "term_type")
         end)

         if present_type then
            if type == "vert" then
               return false
            elseif type == "hori" then
               return false
            end
            return true
         end

         return true
      end,
   },

   highlights = {
      background = {
         guifg = default.colors.grey_fg,
         guibg = bufferlineColors.unfocused.bg,
      },

      -- buffers
      buffer_selected = {
         guifg = bufferlineColors.focused.fg,
         guibg = bufferlineColors.focused.bg,
         gui = "bold",
      },
      buffer_visible = {
         guifg = bufferlineColors.unfocused.fg,
         guibg = bufferlineColors.unfocused.bg,
      },

      -- for diagnostics = "nvim_lsp"
      error = {
         guifg = bufferlineColors.unfocused.fg,
         guibg = bufferlineColors.unfocused.bg,
      },
      error_diagnostic = {
         guifg = bufferlineColors.unfocused.fg,
         guibg = bufferlineColors.unfocused.bg,
      },

      -- close buttons
      close_button = {
         guifg = bufferlineColors.unfocused.fg,
         guibg = bufferlineColors.unfocused.bg,
      },
      close_button_visible = {
         guifg = bufferlineColors.unfocused.fg,
         guibg = bufferlineColors.unfocused.bg,
      },
      close_button_selected = {
         guifg = default.colors.red,
         guibg = bufferlineColors.focused.bg,
      },
      fill = {
         guifg = default.colors.grey_fg,
         guibg = bufferlineColors.unfocused.bg,
      },
      indicator_selected = {
         guifg = bufferlineColors.focused.bg,
         guibg = bufferlineColors.focused.bg,
      },

      -- modified
      modified = {
         guifg = default.colors.red,
         guibg = bufferlineColors.unfocused.bg,
      },
      modified_visible = {
         guifg = default.colors.red,
         guibg = bufferlineColors.unfocused.bg,
      },
      modified_selected = {
         guifg = default.colors.green,
         guibg = bufferlineColors.focused.bg,
      },

      -- separators
      separator = {
         guifg = bufferlineColors.unfocused.bg,
         guibg = bufferlineColors.unfocused.bg,
      },
      separator_visible = {
         guifg = bufferlineColors.unfocused.bg,
         guibg = bufferlineColors.unfocused.bg,
      },
      separator_selected = {
         guifg = bufferlineColors.unfocused.bg,
         guibg = bufferlineColors.unfocused.bg,
      },

      -- tabs
      tab = {
         guifg = bufferlineColors.unfocused.fg,
         guibg = default.colors.one_bg3,
      },
      tab_selected = {
         guifg = bufferlineColors.unfocused.bg,
         guibg = default.colors.nord_blue,
      },
      tab_close = {
         guifg = default.colors.red,
         guibg = bufferlineColors.focused.bg,
      },

      -- dublicate
      duplicate = {
         guifg = default.colors.grey_fg,
         guibg = bufferlineColors.unfocused.bg,
      },
      duplicate_selected = {
         guifg = bufferlineColors.focused.fg,
         guibg = bufferlineColors.focused.bg,
      },
      duplicate_visible = {
         guifg = bufferlineColors.unfocused.fg,
         guibg = bufferlineColors.unfocused.bg,
      },
   },
}

bufferline.setup(default)
