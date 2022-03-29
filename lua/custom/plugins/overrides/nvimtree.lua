-- globals must be set prior to requiring nvim-tree to function
local g = vim.g

g.nvim_tree_group_empty = 1
g.nvim_tree_add_trailing = 0 -- append a trailing slash to folder names
g.nvim_tree_git_hl = 1
g.nvim_tree_highlight_opened_files = 0
g.nvim_tree_indent_markers = 1
g.nvim_tree_root_folder_modifier = table.concat { ":t:gs?$?/..", string.rep(" ", 1000), "?:gs?^??" }
g.nvim_tree_special_files = {}
g.nvim_tree_respect_buf_cwd = 1

g.nvim_tree_show_icons = {
   folders = 1,
   files = 1,
   git = 0,
   folder_arrows = 0,
}

g.nvim_tree_icons = {
   default = "",
   symlink = "",
   git = {
      deleted = "",
      ignored = "◌",
      renamed = "➜",
      staged = "✓",
      unmerged = "",
      unstaged = "✗",
      untracked = "★",
   },
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
}

local present, nvimtree = pcall(require, "nvim-tree")

if not present then
   return
end

local default = {
   filters = {
      dotfiles = false,
   },
   disable_netrw = true,
   hijack_netrw = true,
   ignore_ft_on_setup = { "dashboard" },
   auto_close = false,
   open_on_tab = false,
   hijack_cursor = true,
   hijack_unnamed_buffer_when_opening = false,
   update_cwd = false,
   update_focused_file = {
      enable = true,
      update_cwd = false,
   },
   view = {
      allow_resize = true,
      hide_root_folder = false,
      number = true,
      relativenumber = true,
      side = "left",
      width = 35,
   },
   git = {
      enable = true,
      ignore = false,
   },
   actions = {
      open_file = {
         resize_window = true,
      },
   },
}

nvimtree.setup(default)
