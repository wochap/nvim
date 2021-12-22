local colors = require("colors").get()
local theme = require("core.utils").load_config().ui.theme
local present, base16 = pcall(require, "base16")
local themeColors = base16.themes(theme)

-- Add # sign
for name, color in pairs(themeColors) do
   themeColors[name] = "#" .. color
end

local function highlight(group, color)
  local style = color.style and "gui=" .. color.style or "gui=NONE"
  local fg = color.fg and "guifg=" .. color.fg or "guifg=NONE"
  local bg = color.bg and "guibg=" .. color.bg or "guibg=NONE"
  local sp = color.sp and "guisp=" .. color.sp or ""
 
  local hl = "highlight " .. group .. " " .. style .. " " .. fg .. " " .. bg .. " " .. sp
 
  if color.link then
     vim.cmd("highlight! link " .. group .. " " .. color.link)
  else
     vim.cmd(hl)
  end
end

local syntax = {
   -- diffAdded
   -- diffChanged
   -- diffChanged
   -- diffFile
   -- diffIndexLine
   -- diffLine
   -- diffNewFile
   -- diffOldFile
   -- diffRemoved

   -- Diffview
   DiffviewDiffAddAsDelete = { fg = themeColors.base08, bg = themeColors.base01 },
   DiffviewFilePanelCounter = { fg = colors.purple, bg = "NONE" },
   DiffviewFilePanelTitle = { fg = colors.blue, bg = "NONE" },
   -- DiffviewFilePanelFileName = { fg = , bg = },
   -- DiffviewNormal = { fg = , bg = },
   -- DiffviewCursorLine = { fg = , bg = },
   -- DiffviewVertSplit = { fg = , bg = },
   -- DiffviewSignColumn = { fg = , bg = },
   -- DiffviewStatusLine = { fg = , bg = },
   -- DiffviewStatusLineNC = { fg = , bg = },
   -- DiffviewEndOfBuffer = { fg = , bg = },
   -- DiffviewFilePanelRootPath = { fg = , bg = },
   -- DiffviewFilePanelPath = { fg = , bg = },
   -- DiffviewFilePanelInsertions = { fg = , bg = },
   -- DiffviewFilePanelDeletions = { fg = , bg = },
   -- DiffviewStatusAdded = { fg = , bg = },
   -- DiffviewStatusUntracked = { fg = , bg = },
   -- DiffviewStatusModified = { fg = , bg = },
   -- DiffviewStatusRenamed = { fg = , bg = },
   -- DiffviewStatusCopied = { fg = , bg = },
   -- DiffviewStatusTypeChange = { fg = , bg = },
   -- DiffviewStatusUnmerged = { fg = , bg = },
   -- DiffviewStatusUnknown = { fg = , bg = },
   -- DiffviewStatusDeleted = { fg = , bg = },
   -- DiffviewStatusBroken = { fg = , bg = },

   -- Neogit
   NeogitDiffAddHighlight = { fg = themeColors.base0B, bg = themeColors.base01 },
   NeogitDiffDeleteHighlight = { fg = themeColors.base08, bg = themeColors.base01 },
   -- NeogitBranch = { fg = , bg = },
   -- NeogitDiffContextHighlight = { fg = , bg = },
   -- NeogitHunkHeader = { fg = , bg = },
   -- NeogitHunkHeaderHighlight ={ fg = , bg = },
   -- NeogitRemote = { fg = , bg = },
}

for group, colors in pairs(syntax) do
   highlight(group, colors)
end
