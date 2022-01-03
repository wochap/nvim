local opt = vim.opt
local g = vim.g

g.did_load_filetypes = 1

opt.pastetoggle = "<F2>"
opt.scrolloff = 4
opt.sidescrolloff = 4
opt.list = true
opt.listchars:append("tab:▸ ")
opt.listchars:append("trail:·")
