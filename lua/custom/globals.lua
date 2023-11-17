local opt = vim.opt
local g = vim.g

opt.smartindent = false -- fix indent of line starting with `#`
opt.wrap = false
opt.relativenumber = true
opt.fillchars = {
  eob = " ",
  diff = "╱",
  foldopen = "",
  foldclose = "",
  foldsep = " ",
}
opt.pastetoggle = "<F2>"
opt.scrolloff = 4
opt.sidescrolloff = 4
opt.list = true
opt.compatible = false
opt.listchars:append "tab:» "
opt.listchars:append "trail: "
opt.pumheight = 15
opt.cursorcolumn = true
-- set cursor style to underline
-- opt.guicursor = "n-v-c-sm:hor20-Cursor,i-ci-ve:ver25,r-cr-o:hor20"
opt.guifont = "Iosevka NF:h10:#e-antialias"

-- LazyVim conform config
vim.o.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"

vim.cmd [[
  " set linespace=13
]]

g.matchup_matchparen_offscreen = { method = "popup" }

g.terminal_color_0 = "#45475A"
g.terminal_color_1 = "#F38BA8"
g.terminal_color_2 = "#A6E3A1"
g.terminal_color_3 = "#F9E2AF"
g.terminal_color_4 = "#89B4FA"
g.terminal_color_5 = "#F5C2E7"
g.terminal_color_6 = "#94E2D5"
g.terminal_color_7 = "#BAC2DE"

g.terminal_color_8 = "#585B70"
g.terminal_color_9 = "#F38BA8"
g.terminal_color_10 = "#A6E3A1"
g.terminal_color_11 = "#F9E2AF"
g.terminal_color_12 = "#89B4FA"
g.terminal_color_13 = "#F5C2E7"
g.terminal_color_14 = "#94E2D5"
g.terminal_color_15 = "#A6ADC8"
