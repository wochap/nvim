local keymapsUtils = require "custom.utils.keymaps"
local terminalUtils = require "custom.utils.terminal"
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
map({ "n", "t" }, "<A-i>", function()
  terminalUtils.toggle(nil, {
    cwd = vim.loop.cwd(),
    size = { width = 0.8, height = 0.8 },
    border = "single",
  })
end, "toggle floating term")

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
map("i", "<A-BS>", '<Esc>"zcb<Del>', "delete backward-word")
map("i", "<A-S-BS>", '<Esc>"zcB<Del>', "delete the entire backward-word")
-- map("i", "<A-Del>", '<Esc>"zcw', "delete forward-word")
-- map("i", "<A-S-Del>", '<Esc>"zcW', "delete the entire forward-word")
map("v", "g<C-a>", ":s/\\([^ ]\\) \\{2,\\}/\\1 /g<CR>:nohlsearch<CR>", "Unalign")
map({ "n", "i" }, "<S-A-Down>", keymapsUtils.getCloneLineFn "down", "clone line down")
map("x", "<S-A-Down>", keymapsUtils.getCloneLineFn "down", "clone line down")
map({ "n", "i" }, "<S-A-Up>", keymapsUtils.getCloneLineFn "up", "clone line up")
map("x", "<S-A-Up>", keymapsUtils.getCloneLineFn "up", "clone line up")
map("s", "<BS>", "<C-o>c")

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
map("n", "<leader>cps", function()
  vim.cmd [[
		:profile start /tmp/nvim-profile.log
		:profile func *
		:profile file *
	]]
end, "Profile Start")
map("n", "<leader>cpe", function()
  vim.cmd [[
		:profile stop
		:e /tmp/nvim-profile.log
	]]
end, "Profile End")
map("n", "<leader>cPs", "<cmd>syntime on<CR>", "Profile Syntax Start")
map("n", "<leader>cPe", "<cmd>syntime report<CR>", "Profile Syntax End")

-- better insert register pasting
-- disables autoindent
-- missing register ":.="
local registers = '*+"-%/#abcdefghijklmnopqrstuvwxyz0123456789'
for i = 1, #registers do
  local register = registers:sub(i, i)

  map("i", "<C-r>" .. register, function()
    if vim.fn.reg_recording() then
      return "<C-r>" .. register
    end
    return "<cmd>lua require('custom.utils.keymaps').insertPaste(" .. register .. ")<CR>"
  end, nil, { expr = true, noremap = false })
end

-- fast macros execution
registers = "abcdefghijklmnopqrstuvwxyz"
for i = 1, #registers do
  local register = registers:sub(i, i)

  map("n", "@" .. register, function()
    vim.opt.lazyredraw = true
    vim.cmd.normal { "@" .. register, bang = true }
    vim.opt.lazyredraw = false
  end, nil, { noremap = true })
end

if vim.g.neovide then
  map({ "n", "v", "i", "c", "t" }, "<C-S-v>", keymapsUtils.paste, nil, { noremap = true })
end
