local M = {}

M.luasnip = {
  -- Show snippets related to the language
  -- in the current cursor position
  ft_func = function()
    return require("luasnip.extras.filetype_functions").from_pos_or_filetype()
  end,
}

M.gitsigns = {
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
    ["n <leader>gR"] = "<cmd>Gitsigns reset_buffer<CR>",
    ["n <leader>gS"] = "<cmd>Gitsigns stage_buffer<CR>",
    ["n <leader>gs"] = "<cmd>Gitsigns stage_hunk<CR>",
    ["n <leader>gU"] = "<cmd>Gitsigns reset_buffer_index<CR>",
    ["n <leader>gu"] = "<cmd>Gitsigns undo_stage_hunk<CR>",

    ["v <leader>gs"] = ":Gitsigns stage_hunk<CR>",

    -- Text objects
    -- ['o ih'] = ':<C-U>Gitsigns select_hunk<CR>',
    -- ['x ih'] = ':<C-U>Gitsigns select_hunk<CR>'
  },
}

M.comment = {
  pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
}

M.which_key = function()
  local wk = require "which-key"

  wk.register({
    o = {
      name = "neorg",
    },
    g = { name = "git" },
    f = { name = "find" },
    d = { name = "dap" },
    h = { name = "harpon" },
    l = { name = "lsp" },
    n = { name = "misc" },
    p = { name = "packer" },
    q = { name = "quit" },
    t = { name = "terminal" },
    x = { name = "trouble" },
  }, { prefix = "<leader>" })
end

return M
