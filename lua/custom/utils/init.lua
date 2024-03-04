local M = {}

local function get_buf_size(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local ok, stats = pcall(function()
    return vim.loop.fs_stat(vim.api.nvim_buf_get_name(bufnr))
  end)
  if not (ok and stats) then
    return
  end
  return math.floor(0.5 + (stats.size / (1024 * 1024)))
end

M.is_bigfile = function(bufnr, maxfilesize)
  local status_ok, is_bigfile_cached = pcall(vim.api.nvim_buf_get_var, bufnr, "is_bigfile")
  if status_ok then
    return is_bigfile_cached
  end

  local filesize = get_buf_size(bufnr) or 0
  local is_bigfile = filesize >= maxfilesize

  if not is_bigfile then
    vim.api.nvim_buf_set_var(bufnr, "is_bigfile", false)
    return false
  end

  vim.api.nvim_buf_set_var(bufnr, "is_bigfile", true)
  return true
end

M.disable_ufo = function()
  local has_ufo, ufo = pcall(require, "ufo")
  if not has_ufo then
    return
  end
  pcall(ufo.detach)
  vim.opt_local.foldenable = false
  vim.opt_local.foldcolumn = "0"
end

M.disable_statuscol = function()
  vim.api.nvim_set_option_value("stc", "", { scope = "local" })
end

M.autocmd = vim.api.nvim_create_autocmd

M.augroup = function(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

return M
