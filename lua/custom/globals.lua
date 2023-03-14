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

vim.cmd [[
   set guifont=FiraCode\ Nerd\ Font:h10

   let g:matchup_matchparen_offscreen = {'method': 'popup'}
]]

-- Fix error when using nvim inside nvim terminal
vim.cmd [[
   if has('nvim') && executable('nvr')
      let $VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
   endif

   autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete
]]
