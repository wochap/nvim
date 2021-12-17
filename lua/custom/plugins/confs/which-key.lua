local present, which_key = pcall(require, "which-key")
if not present then
   return
end

local M = {}

M.setup = function(on_attach)
  which_key.setup {
    
  }
end

return M