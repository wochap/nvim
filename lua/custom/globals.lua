local opt = vim.opt
local g = vim.g

opt.pastetoggle = "<F2>"
opt.scrolloff = 4
opt.sidescrolloff = 4
opt.list = true
opt.compatible = false
opt.listchars:append "tab:» "
opt.listchars:append "trail:·"

vim.cmd [[
   let g:matchup_matchparen_offscreen = {'method': 'popup'}
]]
