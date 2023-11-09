local M = {}

local function files_live_grep(opts)
  local Path = require "plenary.path"
  local conf = require("telescope.config").values
  local finders = require "telescope.finders"
  local make_entry = require "telescope.make_entry"
  local pickers = require "telescope.pickers"
  local sorters = require "telescope.sorters"
  local filter = vim.tbl_filter
  local flatten = vim.tbl_flatten

  local vimgrep_arguments = opts.vimgrep_arguments or conf.vimgrep_arguments
  local search_dirs = opts.search_dirs
  local grep_open_files = opts.grep_open_files
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()

  local filelist = {}

  if grep_open_files then
    local bufnrs = filter(function(b)
      if 1 ~= vim.fn.buflisted(b) then
        return false
      end
      return true
    end, vim.api.nvim_list_bufs())
    if not next(bufnrs) then
      return
    end

    for _, bufnr in ipairs(bufnrs) do
      local file = vim.api.nvim_buf_get_name(bufnr)
      table.insert(filelist, Path:new(file):make_relative(opts.cwd))
    end
  elseif search_dirs then
    for i, path in ipairs(search_dirs) do
      search_dirs[i] = vim.fn.expand(path)
    end
  end

  local additional_args = {}
  if opts.additional_args ~= nil and type(opts.additional_args) == "function" then
    additional_args = opts.additional_args(opts)
  end

  local live_grepper = finders.new_job(function(prompt)
    -- TODO: Probably could add some options for smart case and whatever else rg offers.

    if not prompt or prompt == "" then
      return nil
    end

    local search_list = {}

    if search_dirs then
      table.insert(search_list, search_dirs)
    end

    if grep_open_files then
      search_list = filelist
    end

    return flatten { vimgrep_arguments, additional_args, "--", prompt, search_list }
  end, opts.entry_maker or make_entry.gen_from_vimgrep(opts), opts.max_results, opts.cwd)

  pickers
    .new(opts, {
      prompt_title = opts.prompt_title or "Live Grep",
      finder = live_grepper,
      previewer = conf.grep_previewer(opts),
      -- TODO: It would be cool to use `--json` output for this
      -- and then we could get the highlight positions directly.
      sorter = sorters.highlighter_only(opts),
    })
    :find()
end

local function live_grep(state, actions)
  local builtin = require "telescope.builtin"
  local prompt_title = "Live Grep"

  if state.match_case or state.match_word then
    prompt_title = prompt_title .. " "
  end

  if state.match_case then
    prompt_title = prompt_title .. "[C]"
  end

  if state.match_word then
    prompt_title = prompt_title .. "[W]"
  end

  -- builtin.live_grep {
  files_live_grep {
    prompt_title = prompt_title,
    default_text = state.prompt,
    additional_args = function()
      local args = {}
      local index = 1

      if state.glob and #state.glob > 0 then
        args[index] = "-g"
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

      args[index] = "--hidden"
      index = index + 1

      args[index] = "--trim"
      index = index + 1

      -- TODO: add shortcut to disable
      args[index] = "--fixed-strings"
      index = index + 1

      -- args[index] = "--vimgrep"
      -- index = index + 1

      return args
      -- return { "-g", glob, "--word-regexp", "--case-sensitive", "--hidden" }
      -- --glob-case-insensitive
    end,
    attach_mappings = function(_, map)
      map("i", "<A-g>", actions.glob_filter)
      map("i", "<A-w>", actions.toggle_match_word)
      map("i", "<A-c>", actions.toggle_match_case)
      map("n", "<A-g>", actions.glob_filter)
      map("n", "<A-w>", actions.toggle_match_word)
      map("n", "<A-c>", actions.toggle_match_case)
      return true
    end,
  }
end

local function reload(state, prompt_bufnr, actions)
  -- save prompt value
  local action_state = require "telescope.actions.state"
  local picker = action_state.get_current_picker(prompt_bufnr)
  local prompt = picker:_get_prompt()
  state.prompt = prompt

  -- refresh telescope
  require("telescope.actions").close(prompt_bufnr)
  vim.schedule(function()
    live_grep(state, actions)
  end)
end

M.live_grep = function()
  local actions = {}
  local state = {
    match_case = false,
    match_word = false,
    glob = "",
    prompt = "",
  }

  actions.glob_filter = function(prompt_bufnr)
    local glob = vim.fn.input "Enter glob filter: "
    vim.api.nvim_command "normal :esc<CR>"
    state.glob = glob

    reload(state, prompt_bufnr, actions)
  end

  actions.toggle_match_case = function(prompt_bufnr)
    state.match_case = not state.match_case

    reload(state, prompt_bufnr, actions)
  end

  actions.toggle_match_word = function(prompt_bufnr)
    state.match_word = not state.match_word

    reload(state, prompt_bufnr, actions)
  end

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

return M
