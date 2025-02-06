M = {}

local function get_socket_path()
  local tmux = vim.env.TMUX
  if not tmux or #tmux == 0 then
    return nil
  end

  return vim.split(tmux, ",", { trimempty = true })[1]
end

---@param args (string|number)[]
---@param as_list boolean|nil
M.tmux_exec = function(args, as_list)
  local socket = get_socket_path()
  if not socket then
    return nil
  end

  local cmd = vim.list_extend({ "tmux", "-S", socket }, args, 1, #args)
  if as_list then
    return vim.fn.systemlist(cmd) --[[ @as string[] ]]
  end
  return vim.fn.system(cmd)
end

return M
