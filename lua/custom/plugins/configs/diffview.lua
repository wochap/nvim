local present, diffview = pcall(require, "diffview")
if not present then
   return
end

local M = {}

M.setup = function(on_attach)
  diffview.setup {
    enhanced_diff_hl = true,
  }
end

return M