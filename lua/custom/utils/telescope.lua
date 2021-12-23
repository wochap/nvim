
  
local telescope = require('telescope')
local actions = require('telescope.actions')
local M = {}

M.branches = function()
  require'telescope.builtin'.git_branches({ 
    attach_mappings = function(_, map)
      map('i', '<c-j>', actions.git_create_branch)
      map('n', '<c-j>', actions.git_create_branch)
      return true
    end
  })
end

return M