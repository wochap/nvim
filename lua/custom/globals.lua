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
   " set guifont=FiraCode\ Nerd\ Font:h10
   set guifont=JetBrainsMono\ Nerd\ Font\ Mono:h10:#e-antialias

   let g:matchup_matchparen_offscreen = {'method': 'popup'}
]]

-- Use nvim as git editor in lazygit
vim.cmd [[
  if has('nvim') && executable('nvr')
    let $GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
  endif
]]
