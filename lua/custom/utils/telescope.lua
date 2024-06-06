local M = {}

local function live_grep(state, actions)
  local builtin = require "telescope.builtin"
  local prompt_title = "Live Grep"

  if state.match_case or state.match_word or state.fixed_strings then
    prompt_title = prompt_title .. " "
  end

  if state.fixed_strings then
    prompt_title = prompt_title .. "[S]"
  end

  if state.match_case then
    prompt_title = prompt_title .. "[C]"
  end

  if state.match_word then
    prompt_title = prompt_title .. "[W]"
  end

  builtin.live_grep {
    prompt_title = prompt_title,
    default_text = state.prompt,
    additional_args = function()
      local args = {}
      local index = 1

      if state.glob and #state.glob > 0 then
        args[index] = "--glob"
        index = index + 1
        args[index] = state.glob
        index = index + 1
      end

      if state.match_case then
        args[index] = "--case-sensitive"
        index = index + 1
      else
        args[index] = "--ignore-case"
        index = index + 1
      end

      if state.match_word then
        args[index] = "--word-regexp"
        index = index + 1
      end

      if state.fixed_strings then
        args[index] = "--fixed-strings"
        index = index + 1
      end

      args[index] = "--hidden"
      index = index + 1

      -- NOTE: doesn't work with --json
      args[index] = "--trim"
      index = index + 1

      -- NOTE: doesn't work with --json
      -- args[index] = "--vimgrep"
      -- index = index + 1

      -- --glob-case-insensitive
      return args
    end,
    attach_mappings = function(_, map)
      map("i", "<A-g>", actions.glob_filter)
      map("i", "<A-w>", actions.toggle_match_word)
      map("i", "<A-c>", actions.toggle_match_case)
      map("i", "<A-s>", actions.toggle_fixed_strings)
      map("n", "<A-g>", actions.glob_filter)
      map("n", "<A-w>", actions.toggle_match_word)
      map("n", "<A-c>", actions.toggle_match_case)
      map("n", "<A-s>", actions.toggle_fixed_strings)
      return true
    end,
  }
end

local function reload(state, prompt_bufnr, actions)
  -- save prompt value
  local actions_state = require "telescope.actions.state"
  local picker = actions_state.get_current_picker(prompt_bufnr)
  local prompt = picker:_get_prompt()
  state.prompt = prompt

  -- refresh telescope
  require("telescope.actions").close(prompt_bufnr)
  vim.schedule(function()
    live_grep(state, actions)
  end)
end

local function create_toggle(state, actions, key)
  return function(prompt_bufnr)
    state[key] = not state[key]

    reload(state, prompt_bufnr, actions)
  end
end

M.live_grep = function()
  local actions = {}
  local state = {
    match_case = false,
    match_word = false,
    fixed_strings = true,
    glob = "",
    prompt = "",
  }

  actions.glob_filter = function(prompt_bufnr)
    local glob = vim.fn.input("Enter glob filter: ", state.glob)
    vim.api.nvim_command "normal :esc<CR>"
    state.glob = glob

    reload(state, prompt_bufnr, actions)
  end
  actions.toggle_match_case = create_toggle(state, actions, "match_case")
  actions.toggle_match_word = create_toggle(state, actions, "match_word")
  actions.toggle_fixed_strings = create_toggle(state, actions, "fixed_strings")

  live_grep(state, actions)
end

M.symbols = function()
  require("telescope.builtin").lsp_document_symbols {
    symbols = {
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
    },
  }
end

M.flash = function(prompt_bufnr)
  require("flash").jump {
    pattern = "^",
    label = { after = { 0, 0 } },
    search = {
      mode = "search",
      multi_window = true,
      exclude = {
        function(win)
          return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
        end,
      },
    },
    action = function(match)
      local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
      picker:set_selection(match.pos[1] - 1)
    end,
  }
end

M.projects = function()
  local pickers = require "telescope.pickers"
  local entry_display = require "telescope.pickers.entry_display"
  local finders = require "telescope.finders"
  local utils = require "telescope.utils"
  local conf = require("telescope.config").values
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"

  local opts = {}
  local displayer = entry_display.create {
    separator = " ",
    items = {
      { width = 1 },
      { remaining = true },
    },
  }
  local display = function(entry)
    return displayer {
      { "", "NvimTreeFolderIcon" },
      entry.value,
    }
  end

  pickers
    .new(opts, {
      prompt_title = "Projects",
      finder = finders.new_table {
        results = utils.get_os_command_output { vim.o.shell, "-i", "-c", "projects" },
        entry_maker = function(entry)
          return {
            value = entry,
            ordinal = entry,
            display = display,
          }
        end,
      },
      sorter = conf.generic_sorter(opts),
      -- TODO: change title of previewer
      previewer = conf.file_previewer(opts),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          vim.cmd.tcd(selection.value)
          actions.close(prompt_bufnr)
        end)

        return true
      end,
    })
    :find()
end

return M
