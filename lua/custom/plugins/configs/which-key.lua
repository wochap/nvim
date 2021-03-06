local M = {}

M.setup = function()
   local present, which_key = pcall(require, "which-key")

   if not present then
      return
   end

   -- local opts = {
   --   mode = "n", -- NORMAL mode
   --   prefix = "<leader>",
   --   buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
   --   silent = true, -- use `silent` when creating keymaps
   --   noremap = true, -- use `noremap` when creating keymaps
   --   nowait = true, -- use `nowait` when creating keymaps
   -- }

   which_key.setup {}
   which_key.register({
      ["/"] = "Comment toggle current line",
      d = {
         name = "Dap",
         a = "Attach",
         h = "Set breakpoint condition",
         H = "Toggle breakpoint",
         c = "Terminate",
         e = "Set exception breakpoints ALL",
         i = "Hover widget",
         r = "Toggle repl",
         n = "Run to cursor",
         u = "Open DapUI",
         ["<Up>"] = "Step out",
         ["<Right>"] = "Step into",
         ["<Down>"] = "Step over",
         ["<Left>"] = "Continue",
      },
      f = {
         name = "Files",
         n = "Open new buffer",
         k = "Close all but the focused",
         K = "Close all but the focused (FORCE)",
         a = "Telescope find_files hidden",
      },
      g = {
         name = "Git",
         B = "Telescope branches",
         b = "Gitsigns blame line",
      },
      l = {
         name = "Lsp",
      },
      s = {
         name = "Search",
      },
      t = {
         name = "Terminal",
         v = "Terminal vertical",
         h = "Terminal horizontal",
      },
      z = {
         name = "IGNORE",
      },
      q = {
         name = "Exit",
      },
      h = {
         name = "Harpon",
      },
      n = {
         name = "Misc",
         c = "Show nvchad cheatsheet",
         n = "Toggle numbers",
         r = "Toggle relative numbers",
         l = "Load last session",
      },
      p = {
         name = "Packer",
      },
      x = {
         name = "Trouble",
      },
      w = {
         name = "Close current buffer",
      },
      W = {
         name = "Close current buffer (FORCE)",
      },
   }, {
      mode = "n",
      prefix = "<leader>",
   })

   which_key.register({
      ["/"] = "Comment toggle current line",
      g = {
         name = "Git",
      },
      l = {
         name = "Lsp",
         r = {
            name = "Refactor",
            e = "Extract Function",
            f = "Extract Function To File",
            v = "Extract Variable",
            i = "Inline Variable",
         },
      },
   }, {
      mode = "v",
      prefix = "<leader>",
   })

   which_key.register({
      g = {
         c = "Comment toggle_current_line_linewise",
         b = "Comment toggle_current_line_blockwise",

         D = "Lsp declaration",
         I = "Lsp implementation",
         d = "Lsp definition",
         s = "Lsp signature_help",
         t = "Lsp type_definition",
         r = "Lsp references",
         h = "Lsp hover",

         V = "Switch to VISUAL using last paste",
      },
      c = {
         r = {
            -- vim-abolish
            name = "Coerse",
            s = "Coerse snake_case",
            c = "Coerse camelCase",
            u = "Coerse UPPER_CASE",
            ["-"] = "Coerse kebab-case",
         },
      },
      ["["] = {
         d = "Prev diagnostic",
         e = "Prev diagnostic error",
         g = "Prev git hunk",
         t = "Prev trouble item",
      },
      ["]"] = {
         d = "Next diagnostic",
         e = "Next diagnostic error",
         g = "Next git hunk",
         t = "Next trouble item",
      },
   }, {
      mode = "n",
   })

   which_key.register({
      g = {
         c = "Comment toggle_current_lines_linewise",
         b = "Comment toggle_current_lines_blockwise",
         ["."] = "TS textsubjects-smart",
         [","] = "TS textsubjects-container-inner",
         [";"] = "TS textsubjects-container-outer",
      },
   }, {
      mode = "v",
   })
end

return M
