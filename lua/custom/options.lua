local constants = require "custom.utils.constants"
local utils = require "custom.utils"
local iconsUtils = require "custom.utils.icons"

-- Set <space> as the leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.termsync = false

-- Make line numbers default
vim.opt.number = true
vim.opt.numberwidth = 2
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- hide nvim bottom status
vim.opt.cmdheight = 0

-- global statusline
-- HACK: lazy load statusline, otherwise it produces blinking because of noice.nvim
vim.opt.laststatus = 3
vim.opt.statusline = "%#Normal#"
utils.autocmd("User", {
  group = utils.augroup "load_statusline",
  pattern = "VeryLazy",
  callback = function()
    if not constants.in_kittyscrollback then
      vim.opt.statusline = "%!v:lua.require('custom.utils.statusline').statusline()"
    end
  end,
})

-- global bufferline
vim.opt.showtabline = 2
vim.o.tabline = "%#Normal#"

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Defer clipboard because xsel and pbcopy can be slow
utils.autocmd("User", {
  group = utils.augroup "load_clipboard",
  pattern = "VeryLazy",
  callback = function()
    -- Sync clipboard between OS and Neovim.
    vim.opt.clipboard = "unnamedplus"
  end,
})

-- Enable break indent, long lines will continue visually indented
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Don't store backup while overwriting the file
vim.opt.backup = false
vim.opt.writebackup = false

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
-- NOTE: sync with mcauley-penney/visual-whitespace.nvim opts
vim.opt.list = true
vim.opt.listchars = {
  tab = "󰌒 ",
  extends = "…",
  precedes = "…",
  trail = "·",
  nbsp = "󱁐",
}
vim.opt.fillchars = {
  eob = " ",
  diff = "╱",
  foldopen = iconsUtils.fold.open,
  foldclose = iconsUtils.fold.closed,
  foldsep = " ",
}

-- Preview substitutions live, as you type!
vim.opt.inccommand = "nosplit"

-- Show which line/column your cursor is on
vim.opt.cursorline = true
vim.opt.cursorcolumn = not constants.transparent_background

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

-- Allow going past the end of line in visual block mode
vim.opt.virtualedit = "block"

-- Don't autoformat comments
vim.opt.formatoptions = "qjl1"

-- disable nvim intro
vim.opt.shortmess:append "sI"

-- Reduce command line messages
vim.opt.shortmess:append "WcC"

-- enable 24-bit colour
vim.opt.termguicolors = true

vim.opt.compatible = false

-- max items in autocomplete menu
vim.opt.pumheight = 15

-- don't scroll after splitting
vim.opt.splitkeep = "screen"

-- NOTE: horizontal scrolling can be laggy with large horizontal lines because of regex highlighting
vim.opt.wrap = false

-- disable swapfiles
vim.opt.swapfile = false

if vim.fn.has "nvim-0.10" == 1 then
  vim.opt.smoothscroll = true
end

-- set cursor style to underline
-- opt.guicursor = "n-v-c-sm:hor20-Cursor,i-ci-ve:ver25,r-cr-o:hor20"
vim.opt.guifont = "Iosevka NF:h10:#e-antialias"

-- PERF: stop highlighting large lines
-- only works with syntax builtin nvim plugin
vim.opt.synmaxcol = 500

vim.opt.spell = false
vim.opt.spelllang = { "en_us", "es" }

-- docs: https://neovim.io/doc/user/options.html#'sessionoptions'
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "skiprtp" }
