local M = {}

M.luasnip = {
  -- nvchad opts
  history = true,
  updateevents = "TextChanged,TextChangedI",

  -- Show snippets related to the language
  -- in the current cursor position
  ft_func = function()
    return require("luasnip.extras.filetype_functions").from_pos_or_filetype()
  end,
}

M.comment = {
  pre_hook = function(ctx)
    local pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook()
    pre_hook(ctx)
  end,
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
