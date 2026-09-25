local config = require "aiwo.config"

local M = {}

---@type table<string, snacks.win>
M.wins = {}

---@param buf integer
local function yank_all(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  vim.fn.setreg("+", lines, "l")
  Snacks.notify("Prompt copied to clipboard", { title = "aiwo" })
end

--- Close every open prompt window (only one prompt split at a time).
---@param except? string path to keep open
function M.close_all(except)
  for path, win in pairs(M.wins) do
    if path ~= except and win:valid() then
      M.write(win.buf)
      win:close()
    end
  end
end

---@param path string
---@return snacks.win
function M.open(path)
  M.close_all(path)
  local win = M.wins[path]
  if win and win:valid() then
    win:focus()
    return win
  end
  if win then
    win:show()
    win:focus()
    return win
  end
  win = Snacks.win {
    file = path,
    relative = "win",
    win = vim.api.nvim_get_current_win(),
    position = "right",
    width = config.options.width,
    enter = true,
    minimal = false,
    fixbuf = false,
    bo = { filetype = "markdown", bufhidden = "hide" },
    wo = { wrap = true, linebreak = true, winfixwidth = false, winfixheight = false },
    keys = {
      q = "close",
      ["<localleader>y"] = {
        "<localleader>y",
        function(self)
          yank_all(self.buf)
        end,
        desc = "Yank prompt",
      },
    },
    events = {
      {
        event = "BufLeave",
        callback = function(self)
          M.write(self.buf)
        end,
      },
    },
  }
  vim.wo[win.win].winfixwidth = false
  vim.wo[win.win].winfixheight = false
  M.wins[path] = win
  return win
end

-- prompt files live in tmpfs; keep their windows out of saved sessions
vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("aiwo_session", { clear = true }),
  pattern = "PersistenceSavePre",
  callback = function()
    M.close_all()
  end,
})

---@param buf integer
function M.write(buf)
  if not vim.api.nvim_buf_is_valid(buf) or not vim.bo[buf].modified then
    return
  end
  vim.api.nvim_buf_call(buf, function()
    vim.cmd "silent! write"
  end)
end

---@param path string
---@return integer buf loaded buffer for `path` (hidden if no window)
function M.load_buf(path)
  local buf = vim.fn.bufadd(path)
  vim.fn.bufload(buf)
  vim.bo[buf].bufhidden = "hide"
  return buf
end

---@param path string
---@param lines string[]
---@return integer buf
function M.append(path, lines)
  local buf = M.load_buf(path)
  local count = vim.api.nvim_buf_line_count(buf)
  local last = vim.api.nvim_buf_get_lines(buf, count - 1, count, false)[1] or ""
  local empty = count == 1 and last == ""
  local new = {}
  if not empty then
    if last ~= "" then
      new[#new + 1] = ""
    end
  end
  vim.list_extend(new, lines)
  if empty then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, new)
  else
    vim.api.nvim_buf_set_lines(buf, count, count, false, new)
  end
  M.write(buf)
  return buf
end

---@param path string
---@param focus? boolean move cursor to the prompt window (default true)
function M.focus_end(path, focus)
  local prev = vim.api.nvim_get_current_win()
  local win = M.open(path)
  local count = vim.api.nvim_buf_line_count(win.buf)
  vim.api.nvim_win_set_cursor(win.win, { count, 0 })
  if focus == false and vim.api.nvim_win_is_valid(prev) then
    vim.api.nvim_set_current_win(prev)
  end
end

---@param buf integer
function M.copy(buf)
  yank_all(buf)
end

---@param prompt string
---@param cb fun(text: string?)
function M.input(prompt, cb)
  vim.ui.input({ prompt = prompt }, cb)
end

---@param cmd string[]
function M.terminal(cmd)
  local win = Snacks.terminal.open(cmd, {
    cwd = vim.fn.getcwd(),
    auto_close = false,
    win = { position = "bottom", fixbuf = false, wo = { winfixwidth = false, winfixheight = false } },
  })
  vim.wo[win.win].winfixwidth = false
  vim.wo[win.win].winfixheight = false
end

---@param files string[]
---@param on_confirm fun(path: string)
function M.pick(files, on_confirm)
  local items = {}
  for _, file in ipairs(files) do
    items[#items + 1] = { file = file, text = vim.fn.fnamemodify(file, ":t") }
  end
  Snacks.picker.pick {
    source = "aiwo",
    title = "aiwo prompts",
    items = items,
    format = "file",
    preview = "file",
    confirm = function(picker, item)
      picker:close()
      if item then
        on_confirm(item.file)
      end
    end,
  }
end

return M
