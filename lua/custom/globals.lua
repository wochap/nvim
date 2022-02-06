local opt = vim.opt
local g = vim.g

opt.pastetoggle = "<F2>"
opt.scrolloff = 4
opt.sidescrolloff = 4
opt.list = true
opt.compatible = false
opt.listchars:append "tab:» "
opt.listchars:append "trail:·"

vim.cmd [[
   let g:matchup_matchparen_offscreen = {'method': 'popup'}

   " Protect large files from sourcing and other overhead.
   " Files become read only
   if !exists("my_auto_commands_loaded")
   let my_auto_commands_loaded = 1
      " Large files are > 10M
      " Set options:
      " eventignore+=FileType (no syntax highlighting etc
      " assumes FileType always on)
      " noswapfile (save copy of file)
      " bufhidden=unload (save memory when other file is viewed)
      " buftype=nowrite (file is read-only)
      " undolevels=-1 (no undo possible)
      let g:LargeFile = 1024 * 1024 * 10
      augroup LargeFile
         autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > g:LargeFile | set eventignore+=FileType | setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 | else | set eventignore-=FileType | endif
      augroup END
   endif
]]
