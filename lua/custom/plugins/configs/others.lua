local M = {}

M.conflict_marker = function()
  local g = vim.g

  -- Include text after begin and end markers
  g.conflict_marker_begin = '^<<<<<<< .*$'
  g.conflict_marker_end = '^>>>>>>> .*$'
end

M.emmet_vim = function()
  local g = vim.g
end

M.trouble_nvim = function()
  local present, trouble = pcall(require, "trouble")

  if not present then
    return
  end

  trouble.setup {
    use_diagnostic_signs = true
  }
end

return M