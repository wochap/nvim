local present, diffview = pcall(require, "diffview")
if not present then
   return
end

local M = {}

M.setup = function(on_attach)
  diffview.setup {
    signs = {
      add = {
        hl = 'GitSignsAdd'   , text = '▍', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'
      },
      change = {
        hl = 'GitSignsChange', text = '▍', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'
      },
      delete = {
        hl = 'GitSignsDelete', text = '▍', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'
      },
      changedelete = {
        hl = 'GitSignsChange', text = '▍', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'
      },
      topdelete = {
        hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'
      },
    },
    enhanced_diff_hl = true,
  }
end

return M