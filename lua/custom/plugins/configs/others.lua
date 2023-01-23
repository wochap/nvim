local M = {}

M.nvim_surround = function()
  local present, nvim_surround = pcall(require, "nvim-surround")

  if not present then
    return
  end

  nvim_surround.setup {
    keymaps = {
      insert = "<C-g>s",
      insert_line = "<C-g>S",
      normal = "ys",
      normal_cur = "yss",
      normal_line = "yS",
      normal_cur_line = "ySS",
      visual = "S",
      visual_line = "gS",
      delete = "ds",
      change = "cs",
    },
    highlight = {
      duration = 1,
    },
  }
end

M.conflict_marker = function()
  local g = vim.g

  -- Include text after begin and end markers
  g.conflict_marker_begin = "^<<<<<<< .*$"
  g.conflict_marker_end = "^>>>>>>> .*$"
end

M.emmet_vim = function()
  local g = vim.g

  -- Not necessary with my fork
  -- https://github.com/mattn/emmet-vim/issues/350
  g.user_emmet_settings = {
    javascript = {
      extends = "jsx",
    },
  }
end

M.trouble_nvim = function()
  local present, trouble = pcall(require, "trouble")

  if not present then
    return
  end

  trouble.setup {
    use_diagnostic_signs = true,
    -- group = false,
  }
end

M.which_key = function()
  local wk = require "which-key"

  wk.register({
    o = {
      name = "neorg",
    },
    d = { name = "dap" },
    h = { name = "harpon" },
    l = { name = "lsp" },
    n = { name = "misc" },
    p = { name = "packer" },
    q = { name = "quit" },
    s = { name = "search" },
    t = { name = "terminal" },
    x = { name = "trouble" },
  }, { prefix = "<leader>" })
end

return M
