local langUtils = require "custom.utils.lang"

local M = {}

M.width_fullscreen = 174
M.height_fullscreen = 0.9

-- lazy.nvim uses 50
-- but float windows uses 50 as well
M.zindex_fullscreen = 49

-- 43 is used because mason.nvim uses 44, and its zindex isn't configurable
-- notifications look bad over fullscreen buffers, such as mason.nvim
M.zindex_float = 43

M.text_filetypes = {
  "gitcommit",
  "gitrebase",
  "markdown",
  "tex",
  "bib",
  "typst",
  "",
}

local common_exclude_filetypes = {
  -- neo-tree.nvim
  "neo-tree",
  -- diffview.nvim
  "DiffviewFileHistory",
  "DiffviewFiles",
  -- blame.nvim
  "blame",
  -- trouble.nvim
  "trouble",
  -- nvim-dap
  "dap-repl",
  -- nvim-dap-ui
  "dap-view",
  "dap-view-term",
  -- lazy.nvim
  "lazy",
  -- mason.nvim
  "mason",
  -- which-key.nvim
  "wk",
  -- noice.nvim
  "noice",
  -- harpoon
  "harpoon",
  -- avante.nvim
  "Avante",
  "AvanteInput",
  "AvanteSelectedFiles",
  -- incline.nvim
  "incline",
  -- snacks
  "snacks_picker_input",
  "snacks_picker_list",
  "snacks_picker_preview",
  -- fidget.nvim
  "fidget",
  -- nvim
  "qf",
  "notify",
  "terminal",
  "netrw",
  "tutor",
}

M.window_picker_exclude_filetypes = langUtils.list_merge(common_exclude_filetypes, {
  -- nvim-treesitter-context
  "treesitter_context",
})

-- NOTE: you can't exclude empty filetypes
M.exclude_filetypes = langUtils.list_merge(common_exclude_filetypes, {
  -- nvim-lspconfig
  "lspinfo",
  -- leetcode.nvim
  "leetcode.nvim",
  -- oil.nvim
  "oil",
  -- grug-far.nvim
  "grug-far",
  "grug-far-history",
  "grug-far-help",
  -- nvim-spectre
  "spectre_panel",
  -- checkhealth
  "checkhealth",
  -- nvim
  "help",
  "vim",
})

M.window_picker_exclude_buftypes = {
  "terminal",
  "nofile",
  "prompt",
}

M.exclude_buftypes = langUtils.list_merge(M.window_picker_exclude_buftypes, {
  "help",
})

M.in_foot = os.getenv "TERM" == "foot"

M.in_kitty = os.getenv "TERM" == "xterm-kitty"

M.in_neovide = vim.g.neovide

M.in_zk = os.getenv "IN_ZK" == "true"

M.in_obsidian = os.getenv "IN_OBSIDIAN" == "true"

local leet_arg = "leetcode.nvim"
M.in_leetcode = leet_arg == vim.fn.argv()[1]

M.in_kittyscrollback = os.getenv "IN_KITTYSCROLLBACK" == "true"

-- nvim is opening a file from the cmdline
M.has_file_arg = vim.fn.argc(-1) > 0

M.transparent_background = os.getenv "TRANSPARENT" == "true" and true or false

-- TODO: makes more elements transparent
M.blur_background = os.getenv "BLUR" == "true" and true or false

-- HACK: this variable is used to prevent importing
-- specs from lazyvim on the first install
-- otherwise, we end up with a bunch of errors
M.first_install = false

local es_spell_path = vim.fn.stdpath "data" .. "/site/spell/es.utf-8.spl"
M.disable_netrw = vim.uv.fs_stat(es_spell_path) and true or false

M.big_file_mb = 0.5

local nix_path = os.getenv "NIX_PATH"
M.in_nix = nix_path ~= nil and nix_path ~= ""

-- disables some plugins for faster editing
M.in_lite = os.getenv "LITE" == "true"

-- disables more plugins for faster editing
-- called from zvm_vi_edit_command_line
M.in_vi_edit = os.getenv "IN_VI_EDIT" == "true"

return M
