local utils = require "custom.utils"
local constants = require "custom.utils.constants"
local autocmd = vim.api.nvim_create_autocmd
local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end
local function custom_augroup(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup "checktime",
  command = "checktime",
})

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup "highlight_yank",
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = 200 }
  end,
})

-- resize splits if window got resized
autocmd({ "VimResized" }, {
  group = augroup "resize_splits",
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd "tabdo wincmd ="
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- go to last loc when opening a buffer
autocmd("BufReadPost", {
  group = augroup "last_loc",
  callback = function()
    local exclude = { "gitcommit" }
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

autocmd("FileType", {
  group = augroup "nvr_as_git_editor",
  pattern = {
    "gitcommit",
    "gitrebase",
    "gitconfig",
  },
  command = "set bufhidden=wipe",
})

-- close some filetypes with <q>
autocmd("FileType", {
  group = augroup "close_with_q",
  pattern = {
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

-- wrap and check for spell in text filetypes
autocmd("FileType", {
  group = augroup "wrap_spell",
  pattern = { "gitcommit", "markdown", "norg", "" },
  callback = function()
    vim.opt_local.wrap = true
    -- vim.opt_local.spell = true
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
autocmd({ "BufWritePre" }, {
  group = augroup "auto_create_dir",
  callback = function(event)
    if event.match:match "^%w%w+://" then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

autocmd({ "VimEnter" }, {
  group = augroup "set_vimenter",
  callback = function()
    vim.g.vimenter = true
  end,
})

autocmd({ "CmdwinEnter" }, {
  group = custom_augroup "close_with_q_cmd",
  command = "nnoremap <buffer> q :q<CR>",
})

autocmd("FileType", {
  group = custom_augroup "show_numbers_trouble",
  pattern = "Trouble",
  command = "set nu",
})

autocmd({ "SwapExists" }, {
  group = custom_augroup("always_edit_with_swap"),
  pattern = "*",
  command = 'let v:swapchoice = "e"',
})

autocmd({ "BufEnter" }, {
  group = custom_augroup "load_peek_mappings",
  pattern = "*.md",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()

    vim.keymap.set("n", "<leader>fm", "<cmd>lua require('peek').open()<CR>", {
      desc = "open markdown previewer",
      buffer = bufnr,
    })
    vim.keymap.set("n", "<leader>fM", "<cmd>lua require('peek').close()<CR>", {
      desc = "close markdown previewer",
      buffer = bufnr,
    })
  end,
})

-- HACK: don't setup this autocmd until lazy.nvim is installed
-- otherwise it will throw a bunch of errors
if constants.lazyPathExists then
  autocmd("FileType", {
    group = custom_augroup "hide_ufo_folds",
    pattern = constants.exclude_filetypes,
    callback = function()
      utils.disable_ufo()
    end,
  })
end

-- HACK: statuscol doesn't reset signcolumn
autocmd("FileType", {
  group = custom_augroup "reset_signcolumn_on_statuscol_excluded_filetypes",
  pattern = constants.exclude_filetypes,
  callback = function()
    vim.opt_local.signcolumn = "yes"
  end,
})

autocmd({ "CmdlineLeave", "CmdlineEnter" }, {
  group = custom_augroup "turn_off_flash_search",
  callback = function()
    local has_flash, flash = pcall(require, "flash")
    if not has_flash then
      return
    end
    pcall(flash.toggle, false)
  end,
})

-- HACK: fix buffer not showing on tabnew
-- https://github.com/NvChad/ui/blob/v2.0/lua/nvchad/tabufline/lazyload.lua
autocmd({ "tabnew" }, {
  group = custom_augroup "nvchad_tabufline_fixes",
  callback = function(args)
    vim.schedule(function()
      if vim.t and vim.t.bufs == nil then
        vim.t.bufs = vim.api.nvim_get_current_buf() == args.buf and {} or { args.buf }
      end
    end)
  end,
})
