local colors = require("colors").get()

local black = colors.black
local black2 = colors.black2
local blue = colors.blue
local darker_black = colors.darker_black
local folder_bg = colors.folder_bg
local green = colors.green
local grey = colors.grey
local grey_fg = colors.grey_fg
local line = colors.line
local nord_blue = colors.nord_blue
local one_bg = colors.one_bg
local one_bg2 = colors.one_bg2
local pmenu_bg = colors.pmenu_bg
local purple = colors.purple
local red = colors.red
local white = colors.white
local yellow = colors.yellow
local yellow_fg = colors.yellow_fg
local orange = colors.orange
local one_bg3 = colors.one_bg3

-- functions for setting highlights
local fg = require("core.utils").fg
local fg_bg = require("core.utils").fg_bg
local bg = require("core.utils").bg
local function highlight(group, guifg, guibg, attr, guisp)
  local parts = { group }
  if guifg then
     table.insert(parts, "guifg=#" .. guifg)
  end
  if guibg then
     table.insert(parts, "guibg=#" .. guibg)
  end
  if attr then
     table.insert(parts, "gui=" .. attr)
  end
  if guisp then
     table.insert(parts, "guisp=#" .. guisp)
  end

  -- nvim.ex.highlight(parts)
  vim.api.nvim_command("highlight " .. table.concat(parts, " "))
end

-- Registers
bg("RegistersWindow", one_bg)

-- Git signs
-- fg_bg("DiffAdd", green, "NONE")
-- fg_bg("DiffChange", yellow, "NONE")
-- fg_bg("DiffChangeDelete", red, "NONE")
-- fg_bg("DiffModified", red, "NONE")
-- fg_bg("DiffDelete", red, "NONE")

-- Diff highlighting
-- highlight("DiffAdd", theme.base0B, theme.base01, nil, nil)
-- highlight("DiffChange", theme.base03, theme.base01, nil, nil)
-- highlight("DiffDelete", theme.base08, theme.base01, nil, nil)
-- highlight("DiffText", theme.base0D, theme.base01, nil, nil)
-- highlight("DiffAdded", theme.base0B, theme.base00, nil, nil)
-- highlight("DiffFile", theme.base08, theme.base00, nil, nil)
-- highlight("DiffNewFile", theme.base0B, theme.base00, nil, nil)
-- highlight("DiffLine", theme.base0D, theme.base00, nil, nil)
-- highlight("DiffRemoved", theme.base08, theme.base00, nil, nil)

vim.cmd("hi! link diffAdded DiffAdd")
vim.cmd("hi! link diffChanged DiffChange")
vim.cmd("hi! link diffRemoved DiffDelete")

-- TODO: fix diff colors
