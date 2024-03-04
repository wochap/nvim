local keymapsUtils = require "custom.utils.keymaps"
local map = keymapsUtils.map

-- clear highlights of search
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- create new buffer
map("n", "<Leader>fn", "<cmd>enew<CR>", "new buffer")

-- tabs
map("n", "<S-Up>", "<cmd>tabprevious<CR>", "goto next tab")
map("n", "<S-Down>", "<cmd>tabnext<CR> ", "goto prev tab")

-- windows
map("n", "<C-w>x", "<C-w>s", "Split window horizontally")
map("n", "<leader>|", "<C-w>v", "split window vertically")
map("n", "<leader>_", "<C-w>s", "split window horizontally")

-- terminal
map("t", "<C-x>", keymapsUtils.exitTerminalMode, "exit terminal mode")
map("t", "<C-S-x>", keymapsUtils.exitTerminalMode .. "<C-w>q", "hide terminal")

-- scrolling
map({ "n", "v" }, "<C-S-d>", "zL", "scroll half screen to the right")
map({ "n", "v" }, "<C-S-u>", "zH", "scroll half screen to the left")
map("n", "<C-k>", "4<C-y>", "scroll up keeping cursor position")
map("n", "<C-j>", "4<C-e>", "scroll down keeping cursor position")

-- debug nvim config
map("n", "<f2>", keymapsUtils.print_syntax_info, "print syntax info")
map("n", "<f3>", keymapsUtils.print_buf_info, "print buffer info")
map("n", "<leader>cd", "<cmd>lua require('osv').launch({ port = 8086 })<cr>", "start nvim server")
map("n", "<leader>cD", "<cmd>lua require('osv').stop()<cr>", "stop nvim server")

-- editing
map("n", "[<Space>", ":set paste<CR>m`O<Esc>``:set nopaste<CR>", "add empty line up")
map("n", "]<Space>", ":set paste<CR>m`o<Esc>``:set nopaste<CR>", "add empty line down")
map("n", "[<Del>", "m`:silent +g/\\m^\\s*$/d<CR>``:noh<CR>", "remove emply line up")
map("n", "]<Del>", "m`:silent -g/\\m^\\s*$/d<CR>``:noh<CR>", "remove emply line down")
map("i", "<A-BS>", "<Esc>cb<Del>", "delete backward-word")
map("i", "<A-S-BS>", "<Esc>cB<Del>", "delete the entire backward-word")
map("i", "<A-Del>", "<Esc>cw", "")
map("i", "<A-S-Del>", "<Esc>cW", "")
map("v", "g<C-a>", ":s/\\([^ ]\\) \\{2,\\}/\\1 /g<CR>", "Unalign")
map({ "n", "i" }, "<S-A-Down>", keymapsUtils.getCloneLineFn "down", "clone line down")
map("x", "<S-A-Down>", keymapsUtils.getCloneLineFn "down", "clone line down")
map({ "n", "i" }, "<S-A-Up>", keymapsUtils.getCloneLineFn "up", "clone line up")
map("x", "<S-A-Up>", keymapsUtils.getCloneLineFn "up", "clone line up")

-- Allow moving the cursor through wrapped lines with <Up> and <Down>
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", nil, { expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", nil, { expr = true, silent = true })

-- movement
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
map({ "n", "i" }, "<C-e>", keymapsUtils.close_all_floating, "close floating windows")
map("n", "<f5>", ":e %<CR>", "reload buffer")

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
