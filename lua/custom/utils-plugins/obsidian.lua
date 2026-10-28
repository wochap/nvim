local M = {}

M.get_workspaces = function()
  local base_dir = vim.fn.expand "~/Sync/obsidian"
  local dirs = vim.fn.globpath(base_dir, "*", false, true)
  local workspaces = {}
  local pretty_names = {
    utp = "UTP",
    recipes = "Recipes",
    visualfaktory = "VisualFaktory",
    default = "Default",
  }

  for _, dir in ipairs(dirs) do
    if vim.fn.isdirectory(dir) == 1 then
      local basename = vim.fs.basename(dir)
      if not vim.startswith(basename, ".") then
        local display_name = pretty_names[basename:lower()] or basename
        table.insert(workspaces, {
          name = display_name,
          path = dir,
        })
      end
    end
  end

  if #workspaces == 0 then
    table.insert(workspaces, { name = "Default", path = "~/Sync/obsidian" })
  else
    table.sort(workspaces, function(a, b)
      return a.name:lower() < b.name:lower()
    end)
  end

  return workspaces
end

M.new = function(in_same_dir)
  local title = vim.trim(vim.fn.input "Title: ")

  if title == "" then
    return
  end

  local dir = nil
  if in_same_dir then
    dir = vim.fn.expand "%:p:h"
  end

  if dir and dir ~= "" then
    local note = require("obsidian.note").create {
      id = title,
      dir = dir,
    }
    note:write()
    note:open { sync = true }
  else
    vim.cmd("Obsidian new " .. vim.fn.fnameescape(title))
  end
end

M.open_main = function()
  local workspace_root = Obsidian and Obsidian.workspace and tostring(Obsidian.workspace.root)
  local root = workspace_root or vim.uv.cwd()
  local main_path = root .. "/main.md"

  if vim.uv.fs_stat(main_path) then
    vim.cmd("e " .. vim.fn.fnameescape(main_path))
  else
    vim.notify("main.md not found at " .. main_path, vim.log.levels.WARN)
  end
end

M.rename = function()
  local api = require "obsidian.api"
  local cur_buf = vim.api.nvim_get_current_buf()
  local cur_file = vim.api.nvim_buf_get_name(cur_buf)
  local is_obsidian_buffer = vim.b[cur_buf].obsidian_buffer
    or (cur_file ~= "" and api.find_workspace(cur_file) ~= nil)

  if not is_obsidian_buffer then
    vim.notify("Current buffer is not an Obsidian note", vim.log.levels.WARN)
    return
  end

  local note = api.current_note(cur_buf)
  local default_name = (note and (note.title or note.id))
    or vim.fs.basename(cur_file):gsub("%.md$", "")

  vim.ui.input({
    prompt = "Rename note (updates backlinks & file): ",
    default = default_name,
  }, function(new_name)
    if not new_name or new_name == "" or new_name == default_name then
      return
    end
    vim.cmd("Obsidian rename " .. vim.fn.fnameescape(new_name))
  end)
end

M.insert_link = function()
  local picker = require "obsidian.picker"
  local mappings = require "obsidian.picker.mappings"

  picker.find_notes {
    prompt_title = "Insert Link",
    callback = function(paths)
      local path = paths and paths[1]
      if path then
        mappings.insert_link(path)
      end
    end,
  }
end

M.create_and_link = function(in_same_dir)
  local api = require "obsidian.api"
  local viz = api.get_visual_selection()

  local title = nil
  if viz and viz.selection and #viz.lines == 1 and viz.selection ~= "" then
    title = vim.trim(viz.selection)
  else
    title = vim.trim(vim.fn.input "Title: ")
  end

  if not title or title == "" then
    return
  end

  local cur_buf = vim.api.nvim_get_current_buf()
  local cur_file = vim.api.nvim_buf_get_name(cur_buf)
  local is_obsidian_buffer = vim.b[cur_buf].obsidian_buffer
    or (cur_file ~= "" and api.find_workspace(cur_file) ~= nil)

  local dir = nil
  if in_same_dir then
    dir = vim.fn.expand "%:p:h"
  end

  local note = require("obsidian.note").create {
    id = title,
    dir = dir,
  }
  note:write()

  if is_obsidian_buffer then
    if viz and #viz.lines == 1 then
      require("obsidian.actions").link_new(title)
    else
      local link = note:format_link { label = title }
      vim.api.nvim_put({ link }, "", false, true)
      vim.cmd "silent! write"
    end
  end

  note:open { sync = true }
end

M.post_set_workspace = function(workspace)
  local root = tostring(workspace.root)
  vim.fn.chdir(root)
  vim.api.nvim_set_current_dir(root)

  local cur_buf = vim.api.nvim_get_current_buf()
  local cur_file = vim.api.nvim_buf_get_name(cur_buf)
  if cur_file ~= "" then
    local ws = require("obsidian.api").find_workspace(cur_file)
    if ws and ws.name ~= workspace.name then
      local main_file = root .. "/main.md"
      if vim.uv.fs_stat(main_file) then
        vim.schedule(function()
          vim.cmd("edit " .. vim.fn.fnameescape(main_file))
        end)
      else
        vim.schedule(function()
          vim.cmd "enew"
        end)
      end
    end
  end
end

local function get_last_daily()
  local workspace_root = Obsidian and Obsidian.workspace and tostring(Obsidian.workspace.root)
  local root = workspace_root or vim.uv.cwd()
  local daily_folder = (Obsidian and Obsidian.opts and Obsidian.opts.daily_notes and Obsidian.opts.daily_notes.folder)
    or "journal/dailies"
  local journal_dir = root .. "/" .. daily_folder

  local files = vim.fn.globpath(journal_dir, "*.md", false, true)

  if #files == 0 then
    -- Fallback: check all workspaces for any daily notes
    for _, ws in ipairs(M.get_workspaces()) do
      local ws_dir = ws.path .. "/" .. daily_folder
      local ws_files = vim.fn.globpath(ws_dir, "*.md", false, true)
      for _, f in ipairs(ws_files) do
        table.insert(files, f)
      end
    end
  end

  if #files == 0 then
    return nil
  end

  table.sort(files, function(a, b)
    return a > b
  end)

  return files[1]
end

M.open_last_daily = function()
  local last_daily_path = get_last_daily()

  if not last_daily_path then
    vim.notify("No daily notes found", vim.log.levels.WARN)
    return
  end

  vim.cmd("e " .. vim.fn.fnameescape(last_daily_path))
end

return M
