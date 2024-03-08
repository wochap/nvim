-- Set <space> as the leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Make line numbers default
vim.opt.number = true
vim.opt.numberwidth = 2
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- global statusline
vim.opt.laststatus = 3

-- global bufferline
vim.opt.showtabline = 2

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
vim.opt.clipboard = "unnamedplus"

-- Enable break indent, long lines will continue visually indented
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.fillchars = {
  eob = " ",
  diff = "╱",
  foldopen = "",
  foldclose = "",
  foldsep = " ",
}

-- Preview substitutions live, as you type!
vim.opt.inccommand = "nosplit"

-- Show which line/column your cursor is on
vim.opt.cursorline = true
vim.opt.cursorcolumn = true

-- Minimal number of screen lines to keep above, below, left and right before the cursor.
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 4

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true

-- Indenting
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.smartindent = false -- fix indent of line starting with `#`
vim.opt.tabstop = 2
vim.opt.softtabstop = 2

-- disable nvim intro
vim.opt.shortmess:append "sI"

-- enable 24-bit colour
vim.opt.termguicolors = true

vim.opt.compatible = false

-- max items in autocomplete menu
vim.opt.pumheight = 15

vim.opt.splitkeep = "screen"

-- PERF: horizontal scrolling is laggy with large lines because of regex highlighting
vim.opt.wrap = true

if vim.fn.has "nvim-0.10" == 1 then
  vim.opt.smoothscroll = true
end

-- set cursor style to underline
-- opt.guicursor = "n-v-c-sm:hor20-Cursor,i-ci-ve:ver25,r-cr-o:hor20"
vim.opt.guifont = "Iosevka NF:h10:#e-antialias"
