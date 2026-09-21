local config = require "aiwo.config"

local M = {}

---@return string
function M.base_dir()
  if config.options.dir then
    return config.options.dir
  end
  local runtime = vim.env.XDG_RUNTIME_DIR
  if runtime and runtime ~= "" and vim.fn.isdirectory(runtime) == 1 then
    return runtime .. "/aiwo"
  end
  return "/tmp/aiwo"
end

---@return string
function M.project_dir()
  local cwd = vim.fn.getcwd()
  return M.base_dir() .. "/" .. cwd:gsub("/", "%%")
end

---@return string path to a fresh prompt file (created on disk)
function M.create()
  local dir = M.project_dir()
  vim.fn.mkdir(dir, "p")
  local path = dir .. "/" .. os.date "%Y%m%d-%H%M%S" .. ".md"
  -- avoid clash when creating two prompts in the same second
  local n = 1
  while vim.fn.filereadable(path) == 1 do
    path = string.format("%s/%s-%d.md", dir, os.date "%Y%m%d-%H%M%S", n)
    n = n + 1
  end
  vim.fn.writefile({}, path)
  M.set_current(path)
  return path
end

---@return string[] prompt files for the current project, newest first
function M.list()
  local dir = M.project_dir()
  if vim.fn.isdirectory(dir) == 0 then
    return {}
  end
  local files = vim.fn.glob(dir .. "/*.md", false, true)
  table.sort(files, function(a, b)
    return a > b
  end)
  return files
end

---@return string marker file remembering the current prompt across nvim sessions
local function marker()
  return M.project_dir() .. "/.current"
end

---@return string?
function M.current()
  local dir = M.project_dir()
  local path = vim.g.aiwo_current
  -- fresh nvim session: restore from marker file
  if type(path) ~= "string" and vim.fn.filereadable(marker()) == 1 then
    path = vim.fn.readfile(marker())[1]
  end
  -- prompts are per project; ignore a current prompt from another cwd
  if type(path) == "string" and not vim.startswith(path, dir .. "/") then
    path = nil
  end
  if type(path) ~= "string" or vim.fn.filereadable(path) == 0 then
    -- fall back to the newest prompt of this project
    path = M.list()[1]
  end
  if path then
    M.set_current(path)
  else
    vim.g.aiwo_current = nil
  end
  return path
end

---@param path string
function M.set_current(path)
  vim.g.aiwo_current = path
  pcall(vim.fn.writefile, { path }, marker())
end

return M
