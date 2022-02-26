local M = {}

M.branches = function()
   local actions = require "telescope.actions"
   require("telescope.builtin").git_branches {
      attach_mappings = function(_, map)
         map("i", "<C-j>", actions.git_create_branch)
         map("n", "<C-j>", actions.git_create_branch)
         return true
      end,
   }
end

local function live_grep(state, actions)
   local builtin = require "telescope.builtin"

   builtin.live_grep {
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

         args[index] = "--vimgrep"
         index = index + 1

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
      symbols = { "Class", "Function", "Method", "Constructor", "Interface", "Module" },
   }
end

return M
