local present, gitsigns = pcall(require, "gitsigns")

if not present then
   return
end

gitsigns.setup {
   signs = {
      add = {
         hl = "GitSignsAdd",
         text = "▍",
         numhl = "GitSignsAddNr",
         linehl = "GitSignsAddLn",
      },
      change = {
         hl = "GitSignsChange",
         text = "▍",
         numhl = "GitSignsChangeNr",
         linehl = "GitSignsChangeLn",
      },
      delete = {
         hl = "GitSignsDelete",
         text = "",
         numhl = "GitSignsDeleteNr",
         linehl = "GitSignsDeleteLn",
      },
      changedelete = {
         hl = "GitSignsChange",
         text = "~",
         numhl = "GitSignsChangeNr",
         linehl = "GitSignsChangeLn",
      },
      topdelete = {
         hl = "GitSignsDelete",
         text = "‾",
         numhl = "GitSignsDeleteNr",
         linehl = "GitSignsDeleteLn",
      },
   },
   keymaps = {
      ["n ]g"] = { expr = true, "&diff ? ']g' : '<cmd>Gitsigns next_hunk<CR>'" },
      ["n [g"] = { expr = true, "&diff ? '[g' : '<cmd>Gitsigns prev_hunk<CR>'" },
      ["n <leader>gb"] = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
      ["n <leader>gp"] = "<cmd>Gitsigns preview_hunk<CR>",
      ["n <leader>gR"] = "<cmd>Gitsigns reset_buffer<CR>",
      ["n <leader>gr"] = "<cmd>Gitsigns reset_hunk<CR>",
      ["n <leader>gS"] = "<cmd>Gitsigns stage_buffer<CR>",
      ["n <leader>gs"] = "<cmd>Gitsigns stage_hunk<CR>",
      ["n <leader>gU"] = "<cmd>Gitsigns reset_buffer_index<CR>",
      ["n <leader>gu"] = "<cmd>Gitsigns undo_stage_hunk<CR>",

      ["v <leader>gr"] = ":Gitsigns reset_hunk<CR>",
      ["v <leader>gs"] = ":Gitsigns stage_hunk<CR>",

      -- Text objects
      -- ['o ih'] = ':<C-U>Gitsigns select_hunk<CR>',
      -- ['x ih'] = ':<C-U>Gitsigns select_hunk<CR>'
   },
   numhl = false,
   linehl = false,
}
