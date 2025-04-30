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

vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"

-- When jumping back to a recent file, restore scroll position
-- source: https://www.reddit.com/r/neovim/comments/16nead7/comment/k1e1nj5/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
-- source: https://www.reddit.com/r/neovim/comments/1cytkbq/comment/l7cqdmq/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
vim.opt.jumpoptions = "stack,view"

-- Confirm to save changes before exiting modified buffer
vim.opt.confirm = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- use snacks statuscolumn
vim.opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]

-- hide nvim bottom status
vim.opt.cmdheight = 0

-- global statusline
vim.opt.laststatus = 3
vim.opt.statusline = "%#Normal#"
if not constants.in_kittyscrollback then
  require("custom.utils.statusline").init()
  vim.opt.statusline = "%!v:lua.require('custom.utils.statusline').statusline()"
end
utils.autocmd("FileType", {
  group = utils.augroup "load_statusline_in_qf",
  pattern = "qf",
  callback = function()
    if not constants.in_kittyscrollback then
      vim.opt_local.statusline = "%!v:lua.require('custom.utils.statusline').statusline()"
      vim.opt_local.signcolumn = "yes:1"
    end
  end,
})

-- global bufferline
vim.opt.showtabline = 2
vim.o.tabline = "%#Normal#"

-- folds
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.require'custom.utils.folds'.ts_foldexpr()"
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax = 10 -- deepest fold is 10 levels
vim.opt.foldenable = false -- don't fold by default
vim.opt.foldlevel = 99
vim.opt.foldcolumn = "0"
vim.opt.foldtext = "v:lua.require'custom.utils.folds'.foldtext()"

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
-- PERF: decreases performance on buffers with very long lines
vim.opt.breakindent = false

-- Save undo history
vim.opt.undofile = true
vim.opt.undolevels = 10000

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
  fold = " ",
}

-- Preview substitutions live, as you type!
vim.opt.inccommand = "nosplit"

-- Show which line/column your cursor is on
-- NOTE: cursorcolumn causes glitches
vim.opt.cursorline = true
vim.opt.cursorcolumn = not constants.transparent_background

-- Minimal number of screen lines to keep above, below, left and right before the cursor.
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 4

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true

-- Indenting
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = false -- fix indent of line starting with `#`
vim.opt.shiftround = true -- Round indent

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

-- opacity for autocomplete menu
vim.opt.pumblend = 0

-- don't scroll after splitting
vim.opt.splitkeep = "screen"

-- NOTE: horizontal scrolling can be laggy with large horizontal lines because of regex highlighting
vim.opt.wrap = false

-- disable swapfiles
vim.opt.swapfile = false

-- sync buffers between neovim windows
vim.opt.autoread = true

if vim.fn.has "nvim-0.10" == 1 then
  vim.opt.smoothscroll = true
end

-- set cursor style to underline
-- opt.guicursor = "n-v-c-sm:hor20-Cursor,i-ci-ve:ver25,r-cr-o:hor20"

-- neovide ignore its font config
-- if we set guifont
if not constants.in_neovide then
  vim.opt.guifont = "IosevkaTerm NF:h10"
end

if constants.in_neovide then
  vim.opt.shell = "zsh"
end

-- PERF: stop highlighting large lines
-- only works with syntax builtin nvim plugin
vim.opt.synmaxcol = 500

vim.opt.spell = false
vim.opt.spelllang = { "en_us", "es" }

-- docs: https://neovim.io/doc/user/options.html#'sessionoptions'
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "skiprtp", "folds" }

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
vim.opt.whichwrap:append "<>[]hl"

if vim.fn.has "nvim-0.11" == 1 then
  vim.opt.winborder = "none"
end
