local M = {}

M.autocmd = vim.api.nvim_create_autocmd

M.augroup = function(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

M.replace_visual_selection = function(text)
  local start_line, start_col = vim.fn.getpos("'<")[2], vim.fn.getpos("'<")[3]
  local end_line, end_col = vim.fn.getpos("'>")[2], vim.fn.getpos("'>")[3]

  if start_line == end_line then
    local line = vim.fn.getline(start_line)
    local new_line = line:sub(1, start_col - 1) .. text .. line:sub(end_col + 1)
    vim.fn.setline(start_line, new_line)
    return
  end
end

M.get_visual_selection = function()
  local start_pos = vim.fn.getpos "'<"
  local end_pos = vim.fn.getpos "'>"
  local start_line, start_col = start_pos[2], start_pos[3]
  local end_line, end_col = end_pos[2], end_pos[3]
  local line = vim.fn.getline(start_line)

  if start_line == end_line then
    return string.sub(line, start_col, end_col)
  end

  return nil
end

M.set_timeout = function(ms, callback)
  local timer = vim.loop.new_timer()
  timer:start(ms, 0, function()
    -- Stop and close the timer
    timer:stop()
    timer:close()

    -- Schedule the callback to run on the main thread
    vim.schedule(callback)
  end)
end

return M
