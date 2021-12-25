local ok, todo_comments = pcall(require, "todo-comments")

if not ok then
  return
end

local M = {}

M.setup = function(on_attach)
  todo_comments.setup {
    signs = false,
    highlight = {
      before = "fg", -- "fg" or "bg" or empty
      keyword = "fg", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
      after = "fg", -- "fg" or "bg" or empty
    },
  }
end

return M