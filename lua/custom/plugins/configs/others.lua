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

M.refactoring = function()
  local present, refactoring = pcall(require, "refactoring")

  if not present then
    return
  end

  refactoring.setup({})
end

M.nvim_dap_virtual_text = function()
  local present, nvim_dap_virtual_text = pcall(require, "nvim-dap-virtual-text")

  if not present then
    return
  end

  nvim_dap_virtual_text.setup({})
end

M.filetype = function()
  local present, filetype = pcall(require, "filetype")

  if not present then
    return
  end

  filetype.setup({
    overrides = {
      extensions = {
        nix = "nix",
      },
    }
  })
end

return M
