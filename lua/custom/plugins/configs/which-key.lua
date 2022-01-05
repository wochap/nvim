local M = {}

M.setup = function(on_attach)
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
      },
      p = {
         name = "Packer",
      },
      x = {
         name = "Trouble",
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
         d = "Lsp definition",
         s = "Lsp signature_help",
         t = "Lsp type_definition",
         r = "Lsp references",
      },
      c = {
         r = {
            name = "Coerse",
            s = "Coerse snake_case",
            c = "Coerse camelCase",
            u = "Coerse UPPER_CASE",
            ["-"] = "Coerse kebab-case",
         },
      },
   }, {
      mode = "n",
   })

   which_key.register({
      g = {
         c = "Comment toggle_current_lines_linewise",
         b = "Comment toggle_current_lines_blockwise",
      },
      l = {
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
   })
end

return M
