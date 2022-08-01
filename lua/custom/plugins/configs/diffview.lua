local present, diffview = pcall(require, "diffview")
if not present then
   return
end

local M = {}

M.setup = function()
  diffview.setup {
    enhanced_diff_hl = true,
    file_panel = {
      listing_style = "list",
    },
  }
end

return M

