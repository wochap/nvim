local opt = vim.opt
local g = vim.g

opt.wrap = false
opt.relativenumber = true
opt.fillchars = {
  eob = " ",
  diff = "╱",
}
opt.pastetoggle = "<F2>"
opt.scrolloff = 4
opt.sidescrolloff = 4
opt.list = true
opt.compatible = false
opt.listchars:append "tab:» "
opt.listchars:append "trail:·"
opt.pumheight = 15
opt.cursorcolumn = true
-- set cursor style to underline
-- opt.guicursor = "n-v-c-sm:hor20-Cursor,i-ci-ve:ver25,r-cr-o:hor20"

vim.cmd [[
  set guifont=FiraCode\ Nerd\ Font\ Ret:h10:#e-antialias
  set linespace=13

  let g:matchup_matchparen_offscreen = {'method': 'popup'}

  let g:terminal_color_0 = '#45475A'
  let g:terminal_color_1 = '#F38BA8'
  let g:terminal_color_2 = '#A6E3A1'
  let g:terminal_color_3 = '#F9E2AF'
  let g:terminal_color_4 = '#89B4FA'
  let g:terminal_color_5 = '#F5C2E7'
  let g:terminal_color_6 = '#94E2D5'
  let g:terminal_color_7 = '#BAC2DE'

  let g:terminal_color_8 = '#585B70'
  let g:terminal_color_9 = '#F38BA8'
  let g:terminal_color_10 = '#A6E3A1'
  let g:terminal_color_11 = '#F9E2AF'
  let g:terminal_color_12 = '#89B4FA'
  let g:terminal_color_13 = '#F5C2E7'
  let g:terminal_color_14 = '#94E2D5'
  let g:terminal_color_15 = '#A6ADC8'
]]

-- Use nvim as git editor in lazygit
vim.cmd [[
  if has('nvim') && executable('nvr')
    let $GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
  endif
]]
