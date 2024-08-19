local utils = require "custom.utils"

-- Check if we need to reload the file when it changed
utils.autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = utils.augroup "checktime",
  command = "checktime",
})

-- Highlight on yank
utils.autocmd("TextYankPost", {
  group = utils.augroup "highlight_yank",
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = 200 }
  end,
})

-- Resize splits if window got resized
utils.autocmd({ "VimResized" }, {
  group = utils.augroup "resize_splits",
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd "tabdo wincmd ="
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Go to last loc when opening a buffer
utils.autocmd("BufReadPost", {
  group = utils.augroup "last_loc",
  callback = function()
    local exclude = { "gitcommit", "gitrebase", "Trouble" }
    local buf = vim.api.nvim_get_current_buf()
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

utils.autocmd("FileType", {
  group = utils.augroup "nvr_as_git_editor",
  pattern = {
    "gitcommit",
    "gitrebase",
    "gitconfig",
  },
  callback = function()
    vim.opt_local.bufhidden = "wipe"
  end,
})

-- Close some filetypes with <q>
-- Don't list the following filetypes
utils.autocmd("FileType", {
  group = utils.augroup "close_with_q",
  pattern = {
    "gitcommit",
    "gitrebase",
    "gitconfig",
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
utils.autocmd({ "CmdwinEnter" }, {
  group = utils.augroup "close_with_q_cmd",
  command = "nnoremap <buffer> q :q<CR>",
})

-- Wrap text filetypes
utils.autocmd("FileType", {
  group = utils.augroup "wrap_text",
  pattern = { "gitcommit", "gitrebase", "markdown", "norg", "tex", "" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
utils.autocmd({ "BufWritePre" }, {
  group = utils.augroup "auto_create_dir",
  callback = function(event)
    if event.match:match "^%w%w+://" then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

utils.autocmd("FileType", {
  pattern = { "gitsendemail", "conf", "editorconfig" },
  group = utils.augroup "enable_filetypes_syntax",
  callback = function()
    vim.opt_local.syntax = vim.bo.filetype
  end,
})
