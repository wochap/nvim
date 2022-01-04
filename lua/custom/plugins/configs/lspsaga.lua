local M = {}

M.setup = function()
   local ok, lspsaga = pcall(require, "lspsaga")

   if not ok then
      return
   end

   lspsaga.setup {
      use_saga_diagnostic_sign = false,
   }
end

return M
