local iconsUtils = require "custom.utils.icons"

local M = {}

M.default_lsp_symbols = {
  "Class",
  "Function",
  "Method",
  "Constructor",
  "Interface",
  "Module",
  "Struct",
  "Trait",
  "Field",
  "Property",
}

M.window_pick = function()
  local ok, winid = pcall(require("window-picker").pick_window, {
    include_current_win = true,
  })
  if not ok then
    -- no windows available to select
    return 0
  end
  if not winid then
    -- user cancelled pick_window
    return nil
  end
  return winid
end

M.files = function(pick_opts)
  Snacks.picker.pick(
    "files",
    vim.tbl_extend("force", {
      follow = true,
      hidden = true,
      exclude = { "node_modules", ".direnv" },
      args = { "--fixed-strings" },
      cwd = vim.uv.cwd(),
    }, pick_opts)
  )
end

M.grep = function(pick_opts)
  Snacks.picker.pick(
    "grep",
    vim.tbl_extend("force", {
      actions = {
        -- toggles arg --fixed-strings
        toggle_regex = function(picker, item)
          local opts = picker.opts --[[@as snacks.picker.grep.Config]]
          opts.regex = not opts.regex
          picker:find()
          -- TODO: update update_titles fn?
          -- in snacks/picker/core/picker.lua
          -- to show indicator of regex
          -- or just update opts.title?
        end,
        -- toggles arg --word-regexp
        toggle_match_word = function(picker, item)
          local opts = picker.opts --[[@as snacks.picker.grep.Config]]
          if vim.tbl_contains(opts.args, "--word-regexp") then
            opts.args = vim.tbl_filter(function(val)
              return val ~= "--word-regexp"
            end, opts.args)
          else
            table.insert(opts.args, "--word-regexp")
          end
          picker:find()
          -- TODO: add feedback in title
        end,
        -- toggles arg --case-sensitive and --ignore-case
        toggle_match_case = function(picker, item)
          local opts = picker.opts --[[@as snacks.picker.grep.Config]]
          if vim.tbl_contains(opts.args, "--ignore-case") then
            opts.args = vim.tbl_filter(function(val)
              return val ~= "--ignore-case"
            end, opts.args)
            table.insert(opts.args, "--case-sensitive")
          else
            opts.args = vim.tbl_filter(function(val)
              return val ~= "--case-sensitive"
            end, opts.args)
            table.insert(opts.args, "--ignore-case")
          end
          picker:find()
          -- TODO: add feedback in title
        end,
        glob_filter = function(picker, item)
          local opts = picker.opts --[[@as snacks.picker.grep.Config]]
          local glob = vim.fn.input("Enter glob filter: ", opts.glob or "")
          vim.api.nvim_command "normal :esc<CR>"
          opts.glob = glob
          picker:find()
          -- TODO: add feedback in title
        end,
      },
      win = {
        input = {
          keys = {
            ["<A-s>"] = { "toggle_regex", mode = { "i", "n" } },
            ["<A-w>"] = { "toggle_match_word", mode = { "i", "n" } },
            ["<A-c>"] = { "toggle_match_case", mode = { "i", "n" } },
            ["<A-g>"] = { "glob_filter", mode = { "i", "n" } },
          },
        },
      },
      regex = false,
      hidden = true,
      follow = true,
      args = { "-g", "!{node_modules,.git,.direnv}/", "--trim", "--ignore-case" },
      exclude = { "%.lock$", "%-lock.json$" },
    }, pick_opts)
  )
end

M.filetypes = function()
  local filetypes = vim.tbl_map(function(filetype)
    return {
      text = filetype,
    }
  end, vim.fn.getcompletion("", "filetype"))
  Snacks.picker.pick {
    source = "filetypes",
    items = filetypes,
    format = "text",
    confirm = function(picker, item)
      picker:close()
      vim.bo.filetype = item.text
    end,
    layout = "select",
  }
end

local function get_os_command_output(cmd, cwd)
  if type(cmd) ~= "table" then
    vim.notify("get_os_command_output", {
      msg = "cmd has to be a table",
      level = "ERROR",
    })
    return {}
  end
  local Job = require "plenary.job"
  local command = table.remove(cmd, 1)
  local stderr = {}
  local stdout, ret = Job:new({
    command = command,
    args = cmd,
    cwd = cwd,
    on_stderr = function(_, data)
      table.insert(stderr, data)
    end,
  }):sync()
  return stdout, ret, stderr
end

M.projects = function()
  local projects = get_os_command_output { vim.o.shell, "-i", "-c", "projects" }
  local projects_opts = vim.tbl_map(function(project)
    return {
      line = project,
      file = project,
      text = project,
    }
  end, projects or {})
  Snacks.picker.pick {
    source = "custom_projects",
    title = "Projects",
    items = projects_opts,
    format = function(item, picker)
      local ret = {
        { iconsUtils.folder.default .. " ", "NvimTreeFolderIcon" },
        { item.text, item.text_hl },
      } ---@type snacks.picker.Highlight[]
      return ret
    end,
    preview = "directory",
    confirm = function(picker, item)
      picker:close()
      vim.cmd.tcd(item.text)
    end,
  }
end

return M
