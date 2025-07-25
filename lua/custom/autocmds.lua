local utils = require "custom.utils"
local constants = require "custom.utils.constants"

-- Check if we need to reload the file when it changed
utils.autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = utils.augroup "checktime",
  command = "checktime",
})

-- Resize splits if window got resized
utils.autocmd("VimResized", {
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
      vim.api.nvim_command "normal! zz"
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
  callback = function(event)
    vim.bo[event.buf].bufhidden = "wipe"
  end,
})

-- Close some filetypes with <q>
-- Don't list the following filetypes
utils.autocmd("FileType", {
  group = utils.augroup "close_with_q",
  pattern = {
    "trouble",
    "gitcommit",
    "gitrebase",
    "gitconfig",
    "PlenaryTestPopup",
    "spectre_panel",
    -- neotest
    "neotest-output",
    "neotest-summary",
    "neotest-output-panel",
    -- grug-far.nvim
    "grug-far",
    "grug-far-history",
    "grug-far-help",
    -- nvim
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "startuptime",
    "tsplayground",
    "checkhealth",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
utils.autocmd("CmdwinEnter", {
  group = utils.augroup "close_with_q_cmd",
  command = "nnoremap <buffer> q :q<CR>",
})

-- Wrap text filetypes
utils.autocmd("FileType", {
  group = utils.augroup "wrap_text",
  pattern = constants.text_filetypes,
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
utils.autocmd("BufWritePre", {
  group = utils.augroup "auto_create_dir",
  callback = function(event)
    if event.match:match "^%w%w+://" then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Enable native syntax hl
utils.autocmd("FileType", {
  pattern = { "gitsendemail", "conf", "editorconfig", "qf", "checkhealth", "less", "taskedit", "gitignore" },
  group = utils.augroup "enable_filetypes_syntax",
  callback = function(event)
    vim.bo[event.buf].syntax = vim.bo[event.buf].filetype
  end,
})

-- Handle big files and minified files
vim.filetype.add {
  pattern = {
    [".*"] = {
      function(path, buf)
        return vim.bo[buf]
            and vim.bo[buf].filetype ~= "bigfile"
            and path
            and (utils.is_bigfile(buf, constants.big_file_mb) or utils.is_minfile(buf))
            and "bigfile"
          or nil
      end,
    },
  },
}
utils.autocmd({ "FileType" }, {
  group = utils.augroup "bigfile",
  pattern = "bigfile",
  callback = function(ev)
    -- TODO: does "monkoose/matchparen.nvim" supports disabling it?
    -- vim.cmd [[NoMatchParen]]
    -- vim.cmd [[MatchParenDisable]]
    vim.schedule(function()
      vim.bo[ev.buf].syntax = vim.filetype.match { buf = ev.buf } or ""
      vim.opt_local.breakindent = false
    end)
  end,
})

-- folds
utils.autocmd("LspAttach", {
  group = utils.augroup "use_lsp_foldexpr",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.supports_method "textDocument/foldingRange" then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldmethod = "expr"
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end
  end,
})
utils.autocmd("LspDetach", {
  group = utils.augroup "revert_lsp_foldexpr",
  command = "setl foldexpr<",
})

utils.autocmd({ "FileType" }, {
  group = utils.augroup "continue_markdown_list",
  pattern = "markdown",
  callback = function()
    vim.opt_local.comments = "b:-"
    vim.opt_local.formatoptions:append "r"
  end,
})

if constants.in_vi_edit then
  utils.autocmd("VimEnter", {
    group = utils.augroup "start_in_insert_mode",
    pattern = "*",
    command = [[
      startinsert
      normal! $
    ]],
  })
end
