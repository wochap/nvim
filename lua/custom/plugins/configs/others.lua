local M = {}

M.vim_visual_multi = function()
   vim.g.VM_default_mappings = 0

   vim.cmd [[
      let g:VM_maps = {}
      let g:VM_maps["Add Cursor Down"] = '<S-C-Down>'
      let g:VM_maps["Add Cursor Up"] = '<S-C-Up>'
      let g:VM_maps["Select Cursor Down"] = '<S-C-Down>'
      let g:VM_maps["Select Cursor Up"] = '<S-C-Up>'
   ]]
end

M.conflict_marker = function()
   local g = vim.g

   -- Include text after begin and end markers
   g.conflict_marker_begin = "^<<<<<<< .*$"
   g.conflict_marker_end = "^>>>>>>> .*$"
end

M.emmet_vim = function()
   local g = vim.g

   -- Not necessary with my fork
   -- https://github.com/mattn/emmet-vim/issues/350
   g.user_emmet_settings = {
      javascript = {
         extends = "jsx",
      },
   }
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

return M
