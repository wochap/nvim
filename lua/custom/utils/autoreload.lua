-- Reload buffers changed outside nvim (e.g. AI agents)
-- fs_event watchers react instantly, polling catches what watchers miss,
-- FileChangedShell asks before discarding unsaved changes
local nvim_utils = require "custom.utils.nvim"

local M = {}

local POLL_INTERVAL = 1000

-- buf -> { handle, file }
local watchers = {}
-- buf -> true while the reload prompt is open
local prompting = {}
-- buf -> true when the file changed again while the prompt was open
local pending = {}

local function is_file_buf(buf)
  return vim.api.nvim_buf_is_valid(buf)
    and vim.api.nvim_buf_is_loaded(buf)
    and vim.bo[buf].buftype == ""
    and vim.api.nvim_buf_get_name(buf) ~= ""
end

local function can_checktime()
  return not vim.fn.mode():match "^[cr]" and vim.fn.getcmdwintype() == ""
end

local function checktime(buf)
  if not can_checktime() then
    return
  end
  if buf then
    if is_file_buf(buf) then
      pcall(vim.cmd.checktime, buf)
    end
  else
    pcall(vim.cmd.checktime)
  end
end

local function unwatch(buf)
  local w = watchers[buf]
  if not w then
    return
  end
  pcall(function()
    w.handle:stop()
    w.handle:close()
  end)
  watchers[buf] = nil
end

local function watch(buf)
  if not is_file_buf(buf) then
    return
  end
  local file = vim.api.nvim_buf_get_name(buf)
  if watchers[buf] and watchers[buf].file == file then
    return
  end
  unwatch(buf)

  local handle = vim.uv.new_fs_event()
  if not handle then
    return
  end
  -- watch the parent dir, atomic writes (write tmp + rename) replace the inode
  local dir, name = vim.fs.dirname(file), vim.fs.basename(file)
  local ok = pcall(handle.start, handle, dir, {}, function(err, fname)
    if err then
      vim.schedule(function()
        unwatch(buf)
      end)
      return
    end
    if fname and fname ~= name then
      return
    end
    -- small delay so renames/partial writes settle
    vim.defer_fn(function()
      checktime(buf)
    end, 50)
  end)
  if ok then
    watchers[buf] = { handle = handle, file = file }
  else
    pcall(handle.close, handle)
  end
end

local function prompt_reload(buf, again)
  if prompting[buf] then
    pending[buf] = true
    return
  end
  prompting[buf] = true
  pending[buf] = nil
  local file = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":~:.")
  local choices = {
    { label = "Keep my changes", action = "keep" },
    { label = "Reload from disk (discard my changes)", action = "reload" },
  }
  vim.ui.select(choices, {
    prompt = file .. (again and " changed on disk again" or " changed on disk"),
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    prompting[buf] = nil
    if not vim.api.nvim_buf_is_valid(buf) then
      pending[buf] = nil
      return
    end
    if not choice or choice.action ~= "reload" then
      -- the file changed while the prompt was open, the kept changes are stale again
      if pending[buf] and vim.bo[buf].modified then
        vim.schedule(function()
          prompt_reload(buf, true)
        end)
      end
      pending[buf] = nil
      return
    end
    -- edit! reads the latest content, including changes made during the prompt
    pending[buf] = nil
    vim.api.nvim_buf_call(buf, function()
      vim.cmd "edit!"
    end)
  end)
end

M.setup = function()
  local group = nvim_utils.augroup "autoreload"

  nvim_utils.autocmd("FileChangedShell", {
    group = group,
    callback = function(ev)
      local buf = ev.buf
      local reason = vim.v.fcs_reason
      if reason == "deleted" then
        vim.v.fcs_choice = ""
        vim.schedule(function()
          vim.notify(vim.fn.fnamemodify(ev.file, ":~:.") .. " deleted on disk", vim.log.levels.WARN)
        end)
        return
      end
      if not vim.bo[buf].modified then
        vim.v.fcs_choice = "reload"
        return
      end
      -- nvim updates the buffer timestamp before this autocmd,
      -- so keeping the changes won't trigger the prompt again
      vim.v.fcs_choice = ""
      vim.schedule(function()
        prompt_reload(buf)
      end)
    end,
  })

  nvim_utils.autocmd({ "BufReadPost", "BufWritePost", "BufFilePost", "BufEnter" }, {
    group = group,
    callback = function(ev)
      watch(ev.buf)
    end,
  })

  nvim_utils.autocmd({ "BufDelete", "BufWipeout", "BufUnload" }, {
    group = group,
    callback = function(ev)
      unwatch(ev.buf)
      prompting[ev.buf] = nil
      pending[ev.buf] = nil
    end,
  })

  nvim_utils.autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = group,
    callback = function()
      checktime()
    end,
  })

  nvim_utils.autocmd("VimLeavePre", {
    group = group,
    callback = function()
      for buf in pairs(watchers) do
        unwatch(buf)
      end
    end,
  })

  local timer = vim.uv.new_timer()
  timer:start(POLL_INTERVAL, POLL_INTERVAL, vim.schedule_wrap(function()
    checktime()
  end))

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    watch(buf)
  end
end

return M
