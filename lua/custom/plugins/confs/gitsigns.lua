local present, gitsigns = pcall(require, "gitsigns")

if not present then
   return
end

gitsigns.setup {
   signs = {
      add = {
        hl = 'DiffAdd'   , text = '▍', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'
      },
      change = {
        hl = 'DiffChange', text = '▍', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'
      },
      delete = {
        hl = 'DiffDelete', text = '▍', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'
      },
      changedelete = {
        hl = 'DiffChangeDelete', text = '▍', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'
      },
      topdelete = {
        hl = 'DiffDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'
      },
    },
}
