local opt = vim.opt
local g = vim.g

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

opt.compatible = false
opt.cursorcolumn = true
opt.fillchars = {
  eob = " ",
  diff = "╱",
  foldopen = "",
  foldclose = "",
  foldsep = " ",
}
opt.list = true
opt.listchars:append "tab:» "
opt.listchars:append "trail: "
opt.pumheight = 15
opt.relativenumber = true
opt.scrolloff = 4
opt.sidescrolloff = 4
opt.smartindent = false -- fix indent of line starting with `#`
opt.splitkeep = "screen"
-- PERF: horizontal scrolling is laggy with large lines because of regex highlighting
opt.wrap = true

if vim.fn.has "nvim-0.10" == 1 then
  opt.smoothscroll = true
end

-- set cursor style to underline
-- opt.guicursor = "n-v-c-sm:hor20-Cursor,i-ci-ve:ver25,r-cr-o:hor20"
opt.guifont = "Iosevka NF:h10:#e-antialias"

vim.cmd [[
  " set linespace=13
]]
