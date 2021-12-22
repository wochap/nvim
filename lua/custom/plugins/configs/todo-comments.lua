local ok, todo_comments = pcall(require, "todo-comments")

if not ok then
  return
end

local M = {}

M.setup = function(on_attach)
  todo_comments.setup {
    signs = false,
  }
end

return M