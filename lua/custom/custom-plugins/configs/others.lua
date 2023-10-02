local M = {}

M.conflict_marker = function()
  local g = vim.g

  -- Include text after begin and end markers
  g.conflict_marker_begin = "^<<<<<<< .*$"
  g.conflict_marker_end = "^>>>>>>> .*$"
end

M.emmet_vim = function()
  local g = vim.g

  g.user_emmet_leader_key = "<C-z>"

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

M.nvim_spectre = function()
  local spectre = require "spectre"

  spectre.setup {
    highlight = {
      ui = "String",
      search = "SpectreSearch",
      replace = "DiffAdd",
    },
    mapping = {
      ["send_to_qf"] = {
        map = "<C-q>",
        cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
        desc = "send all item to quickfix",
      },
    },
  }
end

M.rainbow_delimiters = function()
  vim.g.rainbow_delimiters = {
    query = {
      javascript = "rainbow-parens",
    },
    highlight = {
      "rainbow1",
      "rainbow2",
      "rainbow3",
      "rainbow4",
      "rainbow5",
      "rainbow6",
    },
    whitelist = { "javascript", "lua" },
  }
end

return M
