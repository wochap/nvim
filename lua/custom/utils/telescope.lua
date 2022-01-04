
  
local telescope = require('telescope')
local actions = require('telescope.actions')
local M = {}

M.branches = function()
  require'telescope.builtin'.git_branches({ 
    attach_mappings = function(_, map)
      map('i', '<C-j>', actions.git_create_branch)
      map('n', '<C-j>', actions.git_create_branch)
      return true
    end
  })
end

M.symbols = function()
  require("telescope.builtin").lsp_document_symbols({
    symbols = { "Class", "Function", "Method", "Constructor", "Interface", "Module" },
  })
end

return M
