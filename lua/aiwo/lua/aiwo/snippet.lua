local M = {}

---@param lines string[]
---@return string fence long enough to wrap `lines`
local function fence_for(lines, min)
  local longest = 0
  for _, line in ipairs(lines) do
    for run in line:gmatch "`+" do
      longest = math.max(longest, #run)
    end
  end
  return string.rep("`", math.max(min or 3, longest + 1))
end

---@param buf integer
---@return string? path relative to cwd when inside it, absolute otherwise, nil when buffer has no file
local function buf_path(buf)
  if vim.bo[buf].buftype ~= "" then
    return nil
  end
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then
    return nil
  end
  local abs = vim.fn.fnamemodify(name, ":p")
  local cwd = vim.fn.getcwd()
  if vim.startswith(abs, cwd .. "/") then
    return vim.fn.fnamemodify(abs, ":.")
  end
  return abs
end

---@return { start: integer, finish: integer }? 1-indexed inclusive line range of the visual selection
function M.visual_range()
  local mode = vim.fn.mode()
  local s, e
  if mode == "v" or mode == "V" or mode == "\22" then
    s = vim.fn.getpos("v")[2]
    e = vim.fn.getpos(".")[2]
  else
    s = vim.fn.getpos("'<")[2]
    e = vim.fn.getpos("'>")[2]
  end
  if s == 0 or e == 0 then
    return nil
  end
  if s > e then
    s, e = e, s
  end
  return { start = s, finish = e }
end

---@return boolean
function M.in_visual()
  local mode = vim.fn.mode()
  return mode == "v" or mode == "V" or mode == "\22"
end

---@param buf integer
---@param range { start: integer, finish: integer }
---@return string[]
function M.from_range(buf, range)
  local lines = vim.api.nvim_buf_get_lines(buf, range.start - 1, range.finish, false)
  local fence = fence_for(lines, 3)
  local out = {}
  local path = buf_path(buf)
  if path then
    out[#out + 1] = string.format("%s:%d-%d", path, range.start, range.finish)
  end
  out[#out + 1] = fence .. vim.bo[buf].filetype
  vim.list_extend(out, lines)
  out[#out + 1] = fence
  return out
end

---@param buf integer
---@return string[]
function M.from_buffer(buf)
  local path = buf_path(buf)
  if path and vim.fn.filereadable(vim.fn.fnamemodify(path, ":p")) == 1 then
    return { "read " .. path }
  end
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local fence = fence_for(lines, 4)
  local out = { fence .. vim.bo[buf].filetype }
  vim.list_extend(out, lines)
  out[#out + 1] = fence
  return out
end

---@param buf integer
---@param range? { start: integer, finish: integer }
---@return string[]
function M.build(buf, range)
  if range then
    return M.from_range(buf, range)
  end
  return M.from_buffer(buf)
end

return M
