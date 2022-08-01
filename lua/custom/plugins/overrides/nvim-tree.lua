return {
   respect_buf_cwd = true,
   update_cwd = false,
   view = {
      hide_root_folder = false,
      number = true,
      relativenumber = true,
      width = 35,
      mappings = {
         list = {
            { key = "R", action = "full_rename" },
            { key = "<C-r>", action = "refresh" },
            { key = "?", action = "toggle_help" },
            { key = "[g", action = "prev_git_item" },
            { key = "]g", action = "next_git_item" },
            { key = { "<CR>", "<2-LeftMouse>" }, action = "edit" },
            { key = "o", action = "system_open" },
            { key = "<C-h>", action = "split" },
         },
      },
   },
   git = {
      enable = true,
      ignore = false,
   },
   renderer = {
      root_folder_modifier = table.concat { ":t:gs?$?/..", string.rep(" ", 1000), "?:gs?^??" },
      group_empty = true,
      special_files = {},
      highlight_git = true,
      indent_markers = {
         enable = true,
      },
      icons = {
         show = {
            folder_arrow = false,
         },
         glyphs = {
            default = "",
            symlink = "",
            folder = {
               arrow_open = "",
               arrow_closed = "",
               default = "",
               empty = "",
               empty_open = "",
               open = "",
               symlink = "",
               symlink_open = "",
            },
         },
      },
   },
}
