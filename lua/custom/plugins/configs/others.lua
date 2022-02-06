local M = {}

M.conflict_marker = function()
   local g = vim.g

   -- Include text after begin and end markers
   g.conflict_marker_begin = "^<<<<<<< .*$"
   g.conflict_marker_end = "^>>>>>>> .*$"
end

M.emmet_vim = function()
   local g = vim.g
end

M.cmp_cmdline = function()
   local present, cmp = pcall(require, "cmp")

   if not present then
      return
   end

   cmp.setup.cmdline("/", {
      sources = {
         { name = "buffer" },
      },
   })

   cmp.setup.cmdline(":", {
      sources = cmp.config.sources({
         { name = "path" },
      }, {
         { name = "cmdline" },
      }),
   })
end

M.trouble_nvim = function()
   local present, trouble = pcall(require, "trouble")

   if not present then
      return
   end

   trouble.setup {
      use_diagnostic_signs = true,
      -- group = false,
   }
end

M.nvim_spectre = function()
   local present, spectre = pcall(require, "spectre")

   if not present then
      return
   end

   spectre.setup {
      mapping = {
         ["send_to_qf"] = {
            map = "<C-q>",
            cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
            desc = "send all item to quickfix",
         },
      },
   }
end

M.refactoring = function()
   local present, refactoring = pcall(require, "refactoring")

   if not present then
      return
   end

   refactoring.setup {}
end

M.nvim_dap_virtual_text = function()
   local present, nvim_dap_virtual_text = pcall(require, "nvim-dap-virtual-text")

   if not present then
      return
   end

   nvim_dap_virtual_text.setup {}
end

M.filetype = function()
   local present, filetype = pcall(require, "filetype")

   if not present then
      return
   end

   filetype.setup {
      overrides = {
         extensions = {
            nix = "nix",
            rasi = "less",
         },
      },
   }
end

M.gitsigns = {
   signs = {
      add = {
         hl = "GitSignsAdd",
         text = "▍",
         numhl = "GitSignsAddNr",
         linehl = "GitSignsAddLn",
      },
      change = {
         hl = "GitSignsChange",
         text = "▍",
         numhl = "GitSignsChangeNr",
         linehl = "GitSignsChangeLn",
      },
      delete = {
         hl = "GitSignsDelete",
         text = "",
         numhl = "GitSignsDeleteNr",
         linehl = "GitSignsDeleteLn",
      },
      changedelete = {
         hl = "GitSignsChange",
         text = "~",
         numhl = "GitSignsChangeNr",
         linehl = "GitSignsChangeLn",
      },
      topdelete = {
         hl = "GitSignsDelete",
         text = "‾",
         numhl = "GitSignsDeleteNr",
         linehl = "GitSignsDeleteLn",
      },
   },
   keymaps = {
      ["n ]g"] = { expr = true, "&diff ? ']g' : '<cmd>Gitsigns next_hunk<CR>'" },
      ["n [g"] = { expr = true, "&diff ? '[g' : '<cmd>Gitsigns prev_hunk<CR>'" },
      ["n <leader>gb"] = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
      ["n <leader>gp"] = "<cmd>Gitsigns preview_hunk<CR>",
      ["n <leader>gR"] = "<cmd>Gitsigns reset_buffer<CR>",
      ["n <leader>gr"] = "<cmd>Gitsigns reset_hunk<CR>",
      ["n <leader>gS"] = "<cmd>Gitsigns stage_buffer<CR>",
      ["n <leader>gs"] = "<cmd>Gitsigns stage_hunk<CR>",
      ["n <leader>gU"] = "<cmd>Gitsigns reset_buffer_index<CR>",
      ["n <leader>gu"] = "<cmd>Gitsigns undo_stage_hunk<CR>",

      ["v <leader>gr"] = ":Gitsigns reset_hunk<CR>",
      ["v <leader>gs"] = ":Gitsigns stage_hunk<CR>",

      -- Text objects
      -- ['o ih'] = ':<C-U>Gitsigns select_hunk<CR>',
      -- ['x ih'] = ':<C-U>Gitsigns select_hunk<CR>'
   },
}

M.bufferline = {
   options = {
      show_close_icon = false,
      show_buffer_close_icons = false,
   },
}

M.nvim_comment = {
   pre_hook = function(ctx)
      local U = require "Comment.utils"

      local location = nil
      if ctx.ctype == U.ctype.block then
         location = require("ts_context_commentstring.utils").get_cursor_location()
      elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
         location = require("ts_context_commentstring.utils").get_visual_start_location()
      end

      return require("ts_context_commentstring.internal").calculate_commentstring {
         key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
         location = location,
      }
   end,
}

return M
