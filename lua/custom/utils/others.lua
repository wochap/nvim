local M = {}

M.expandSnippet = function()
   local present, luasnip = pcall(require, "luasnip")

   if not present then
      return
   end

   if luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
   end
end

return M
