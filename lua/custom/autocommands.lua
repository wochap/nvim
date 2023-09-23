vim.cmd [[
  augroup _general_settings
    autocmd!
    " map q to exit list buffers
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR>
    " highlight yanked text
    autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200})
  augroup end
]]

vim.cmd [[
  augroup _more_settings
    autocmd!
    autocmd FileType Trouble set nu
    autocmd FileType dap-repl lua require('dap.ext.autocompl').attach()
  augroup end
]]

local tintGroup = vim.api.nvim_create_augroup("tintBufEnter", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = tintGroup,
  pattern = "*",
  callback = function()
    local ok, tint = pcall(require, "tint")

    if not ok then
      return
    end

    if not vim.g.vimenter then
      return
    end

    tint.refresh()
  end,
})

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    vim.g.vimenter = true
  end,
})

local cmdWinGroup = vim.api.nvim_create_augroup("mapQCmdWinEnter", { clear = true })
vim.api.nvim_create_autocmd({ "CmdwinEnter" }, { group = cmdWinGroup, command = "nnoremap <buffer> q :q<CR>" })

-- vim.cmd [[
--    " Protect large files from sourcing and other overhead.
--    " Files become read only
--    if !exists("my_auto_commands_loaded")
--    let my_auto_commands_loaded = 1
--       " Large files are > 10M
--       " Set options:
--       " eventignore+=FileType (no syntax highlighting etc
--       " assumes FileType always on)
--       " noswapfile (save copy of file)
--       " bufhidden=unload (save memory when other file is viewed)
--       " buftype=nowrite (file is read-only)
--       " undolevels=-1 (no undo possible)
--       let g:LargeFile = 1024 * 1024 * 10
--       augroup LargeFile
--          autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > g:LargeFile | set eventignore+=FileType | setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 | else | set eventignore-=FileType | endif
--       augroup END
--    endif
-- ]]
