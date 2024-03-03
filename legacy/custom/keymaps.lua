local map = function(mode, lhs, rhs, desc, opts)
  if type(desc) == "table" then
    opts = desc
  end
  if not desc then
    desc = ""
  end
  if not opts then
    opts = {}
  end
  opts.desc = desc
  vim.keymap.set(mode, lhs, rhs, opts)
end

local function termcodes(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end
local exitTerminalMode = termcodes "<C-\\><C-N>"
-- local Util = require("lazyvim.util")
-- local lazyterm = function()
--   Util.terminal(nil, { cwd = Util.root() })
-- end
local runExpr = function(expr)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(expr, true, false, true), "n", true)
end
-- TODO: refactor getCloneLineFn
local getCloneLineFn = function(direction)
  return function()
    if vim.api.nvim_get_mode().mode == "v" then
      vim.cmd "normal! V"
    end
    local mode = vim.api.nvim_get_mode().mode
    if mode == "V" then
      vim.cmd 'normal! mz"zy'
      local start_line = vim.fn.line "'<"
      local end_line = vim.fn.line "'>"
      local num_lines = end_line - start_line + 1
      if direction == "down" then
        vim.cmd('normal! `]"zp`z' .. num_lines .. "j")
      elseif direction == "up" then
        vim.cmd('normal! `]"zP`z' .. num_lines .. "k")
      end
    elseif mode == "i" then
      if direction == "down" then
        runExpr '<C-o>mz<Esc>"zyy"zp`zi<Down>'
      elseif direction == "up" then
        runExpr '<C-o>mz<Esc>"zyy"zP`zi<Up>'
      end
    elseif mode == "n" then
      if direction == "down" then
        runExpr 'mz"zyy"zp`z<Down>'
      elseif direction == "up" then
        runExpr 'mz"zyy"zP`z<Up>'
      end
    end
  end
end

-- focus windows
map("n", "<C-Left>", "<cmd>lua require('smart-splits').move_cursor_left()<cr>")
map("n", "<C-Right>", "<cmd>lua require('smart-splits').move_cursor_right()<cr>")
map("n", "<C-Down>", "<cmd>lua require('smart-splits').move_cursor_down()<cr>")
map("n", "<C-Up>", "<cmd>lua require('smart-splits').move_cursor_up()<cr>")
map("n", "<C-F4>", "<cmd>WindowPick<cr>", "focus visible window")
-- HACK: maps C-F4 in terminal linux
map("n", "<F28>", "<cmd>WindowPick<cr>", "focus visible window")

-- resize windows
map("n", "<C-S-A-Left>", "<cmd>lua require('smart-splits').resize_left()<cr>")
map("n", "<C-S-A-Right>", "<cmd>lua require('smart-splits').resize_right()<cr>")
map("n", "<C-S-A-Down>", "<cmd>lua require('smart-splits').resize_down()<cr>")
map("n", "<C-S-A-Up>", "<cmd>lua require('smart-splits').resize_up()<cr>")

-- swap windows
map("n", "<C-S-Left>", "<cmd>lua require('smart-splits').swap_buf_left()<cr>")
map("n", "<C-S-Right>", "<cmd>lua require('smart-splits').swap_buf_right()<cr>")
map("n", "<C-S-Down>", "<cmd>lua require('smart-splits').swap_buf_down()<cr>")
map("n", "<C-S-Up>", "<cmd>lua require('smart-splits').swap_buf_up()<cr>")
map("n", "<C-S-F4>", "<cmd>WindowSwap<cr>", "swap with window")
-- HACK: maps C-S-F4 in terminal linux
map("n", "<F40>", "<cmd>WindowSwap<cr>", "swap with window")

-- windows
map("n", "<C-w>x", "<C-w>s", "Split window horizontally")
map("n", "<leader>|", "<C-w>v", "split window vertically")
map("n", "<leader>_", "<C-w>s", "split window horizontally")

-- terminal
map("t", "<C-x>", exitTerminalMode, "exit terminal mode")
map("t", "<C-S-x>", exitTerminalMode .. "<C-w>q", "hide terminal")
map("n", "<leader>Tt", "<cmd> Telescope terms <CR>", "pick hidden term")
-- map({ "n", "t" }, "<A-i>", lazyterm, "terminal (root dir)")
-- map({ "n", "t" }, "<A-S-i>", function()
--   Util.terminal()
-- end, "terminal (cwd)")

-- scrolling
map({ "n", "v" }, "<C-S-d>", "zL", "scroll half screen to the right")
map({ "n", "v" }, "<C-S-u>", "zH", "scroll half screen to the left")
map("n", "<C-k>", "4<C-y>", "scroll up keeping cursor position")
map("n", "<C-j>", "4<C-e>", "scroll down keeping cursor position")

-- debug nvim config
map("n", "<f2>", "<cmd>lua require'custom.utils'.print_syntax_info()<CR>", "print syntax info")
map("n", "<f3>", "<cmd>lua require'custom.utils'.print_buf_info()<CR>", "print buffer info")
map("n", "<leader>cd", "<cmd>lua require('osv').launch({ port = 8086 })<cr>", "start nvim server")
map("n", "<leader>cD", "<cmd>lua require('osv').stop()<cr>", "stop nvim server")

-- editing
map("n", "[<Space>", ":set paste<CR>m`O<Esc>``:set nopaste<CR>", "add empty line up")
map("n", "]<Space>", ":set paste<CR>m`o<Esc>``:set nopaste<CR>", "add empty line down")
map("n", "[<Del>", "m`:silent +g/\\m^\\s*$/d<CR>``:noh<CR>", "remove emply line up")
map("n", "]<Del>", "m`:silent -g/\\m^\\s*$/d<CR>``:noh<CR>", "remove emply line down")
map("i", "<A-Down>", "<Cmd>lua MiniMove.move_line('down')<CR>", "Move line down")
map("i", "<A-Up>", "<Cmd>lua MiniMove.move_line('up')<CR>", "Move line up")
map("i", "<A-BS>", "<Esc>cb<Del>", "delete backward-word")
map("i", "<A-S-BS>", "<Esc>cB<Del>", "delete the entire backward-word")
map("i", "<A-Del>", "<Esc>cw", "")
map("i", "<A-S-Del>", "<Esc>cW", "")
map("v", "g<C-a>", ":s/\\([^ ]\\) \\{2,\\}/\\1 /g<CR>", "Unalign")
map("i", "<C-k>", "<cmd>lua require'luasnip'.expand()<CR>", "expand snippet") -- TODO: also add it to cmp keymaps
map({ "n", "i" }, "<S-A-Down>", getCloneLineFn "down", "clone line down")
map("x", "<S-A-Down>", getCloneLineFn "down", "clone line down")
map({ "n", "i" }, "<S-A-Up>", getCloneLineFn "up", "clone line up")
map("x", "<S-A-Up>", getCloneLineFn "up", "clone line up")

-- movement
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", "", { expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", "", { expr = true, silent = true })
map("i", "<A-Left>", "<C-o>b", "move backward one word")
map("i", "<A-S-Left>", "<C-o>B", "move backward one entire word")
map("i", "<A-Right>", "<C-o>w", "move forward one word")
map("i", "<A-S-Right>", "<C-o>W", "move forward one entire word")
map("i", "<A-e>", "<C-o>e", "")
map("i", "<A-S-e>", "<C-o>E", "")

-- misc
map("n", "<C-y>", "<cmd> %y+ <CR>", "copy whole file")
map({ "n", "i", "v" }, "<C-s>", "<Esc>:w <CR>", "save buffer")
map({ "n", "i", "v" }, "<C-S-s>", "<Esc>:w! <CR>", "save buffer!")
map("n", "<leader>qq", "<cmd>qa <CR>", "exit")
map("n", "<leader>q!", "<cmd>qa! <CR>", "exit!")
map("n", "gV", "`[v`]", "select last yanked/changed text")
map({ "n", "i" }, "<C-e>", "<cmd>lua require'custom.utils'.close_all_floating()<CR>", "close floating windows")
map("n", "<f5>", ":e %<CR>", "reload buffer")

-- lazy
map("n", "<leader>pR", "<cmd>Lazy restore<cr>", "restore")
map("n", "<leader>pI", "<cmd>Lazy install<cr>", "install")
map("n", "<leader>pS", "<cmd>Lazy sync<cr>", "sync")
map("n", "<leader>pC", "<cmd>Lazy check<cr>", "check")
map("n", "<leader>pU", "<cmd>Lazy update<cr>", "update")
map("n", "<leader>pP", "<cmd>Lazy profile<cr>", "profile")
map("n", "<leader>pi", "<cmd>Lazy<cr>", "info")

-- HACK: disable autoindent when pasting
-- make <C-r> work like <C-r><C-o>
-- https://neovim.io/doc/user/insert.html#i_CTRL-R_CTRL-O
-- missing register ":.="
local registers = '*+"-%/#abcdefghijklmnopqrstuvwxyz0123456789'
for i = 1, #registers do
  local register = registers:sub(i, i)

  vim.keymap.set("i", "<C-r>" .. register, function()
    -- disable paste mode before pasting and
    vim.o.paste = true
    pcall(vim.cmd, 'normal! "' .. register .. "p")
    -- enable paste mode after pasting
    vim.o.paste = false
  end, { expr = false, noremap = true })
end
