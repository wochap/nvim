local M = {}

---@param opts? table
function M.setup(opts)
  require("aiwo.config").setup(opts)
end

---@param opts table merged opts
---@param lines string[]
---@param path string
local function commit(opts, lines, path)
  local ui = require "aiwo.ui"
  local buf = ui.append(path, lines)
  if opts.copy then
    ui.copy(buf)
  end
  if opts.show then
    ui.focus_end(path, opts.focus)
  end
end

---@param opts table merged opts
---@param get_path fun(): string
local function run(opts, get_path)
  local snippet = require "aiwo.snippet"
  local ui = require "aiwo.ui"
  local buf = vim.api.nvim_get_current_buf()
  local range = nil
  if snippet.in_visual() then
    range = snippet.visual_range()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
  end
  local lines = snippet.build(buf, range)

  local function finish(text)
    local out = {}
    if text and text ~= "" then
      vim.list_extend(out, vim.split(text, "\n", { plain = true }))
      out[#out + 1] = ""
    end
    vim.list_extend(out, lines)
    commit(opts, out, get_path())
  end

  if opts.input then
    ui.input("aiwo> ", function(text)
      if text == nil then
        return
      end
      finish(text)
    end)
  else
    finish(nil)
  end
end

---@param opts? table
function M.new(opts)
  local o = require("aiwo.config").get(opts)
  run(o, function()
    return require("aiwo.store").create()
  end)
end

---@param opts? table
function M.append(opts)
  local o = require("aiwo.config").get(opts)
  run(o, function()
    local store = require "aiwo.store"
    return store.current() or store.create()
  end)
end

function M.pick()
  local store = require "aiwo.store"
  local ui = require "aiwo.ui"
  local files = store.list()
  if #files == 0 then
    Snacks.notify("No prompts for this project", { title = "aiwo", level = "warn" })
    return
  end
  ui.pick(files, function(path)
    store.set_current(path)
    ui.focus_end(path)
  end)
end

---@param opts? table
function M.run(opts)
  local o = require("aiwo.config").get(opts)
  local store = require "aiwo.store"
  local ui = require "aiwo.ui"

  local name = vim.api.nvim_buf_get_name(0)
  local path = store.is_prompt(name) and name or store.current()
  if not path then
    Snacks.notify("No prompt for this project", { title = "aiwo", level = "warn" })
    return
  end

  local buf = vim.fn.bufnr(path)
  if buf ~= -1 then
    ui.write(buf)
  end

  local lines = vim.fn.filereadable(path) == 1 and vim.fn.readfile(path) or {}
  local text = vim.trim(table.concat(lines, "\n"))
  if text == "" then
    Snacks.notify("Prompt is empty", { title = "aiwo", level = "warn" })
    return
  end

  local cmd = o.cmd
  local argv
  if type(cmd) == "function" then
    argv = cmd(path)
  else
    argv = {}
    for _, item in ipairs(cmd) do
      if item == "{prompt}" then
        argv[#argv + 1] = text
      elseif item == "{file}" then
        argv[#argv + 1] = path
      else
        argv[#argv + 1] = item
      end
    end
  end

  store.set_current(path)
  ui.terminal(argv)
end

function M.open()
  local store = require "aiwo.store"
  local path = store.current()
  if not path then
    return M.pick()
  end
  require("aiwo.ui").focus_end(path)
end

return M
