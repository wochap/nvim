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
map("n", "<leader>ft", "<cmd>tabnew<CR> ", "new tab")

-- windows
map("n", "<C-w>x", "<C-w>s", "Split window horizontally")
map("n", "<C-`>", "<C-w>p", "Focus prev window")

-- terminal
map("t", "<C-x>", terminalUtils.exitTerminalMode, "exit terminal mode")
map("t", "<C-S-x>", terminalUtils.exitTerminalMode .. "<C-w>q", "hide terminal")
map({ "n", "t" }, "<A-i>", terminalUtils.toggleScratchTerm, "toggle floating term")

-- scrolling
map({ "n", "v" }, "<C-S-d>", "zL", "scroll half screen to the right")
map({ "n", "v" }, "<C-S-u>", "zH", "scroll half screen to the left")
map("n", "<C-k>", "4<C-y>", "scroll up keeping cursor position")
map("n", "<C-j>", "4<C-e>", "scroll down keeping cursor position")

-- debug nvim config
map("n", "<f2>", keymapsUtils.print_syntax_info, "print syntax info")
map("n", "<f3>", keymapsUtils.print_buf_info, "print buffer info")
map("n", "<leader>md", "<cmd>lua require('osv').launch({ port = 8086 })<cr>", "start nvim server")
map("n", "<leader>mD", "<cmd>lua require('osv').stop()<cr>", "stop nvim server")

-- editing
map("n", "[<Space>", ":set paste<CR>m`O<Esc>``:set nopaste<CR>", "add empty line up", { silent = true })
map("n", "]<Space>", ":set paste<CR>m`o<Esc>``:set nopaste<CR>", "add empty line down", { silent = true })
map("n", "]<Del>", "m`:silent +g/\\m^\\s*$/d<CR>``:noh<CR>", "remove emply line up", { silent = true })
map("n", "[<Del>", "m`:silent -g/\\m^\\s*$/d<CR>``:noh<CR>", "remove emply line down", { silent = true })
map("i", "<A-BS>", '<Esc>"zcb<Del>', "delete backward-word")
map("i", "<A-S-BS>", '<Esc>"zcB<Del>', "delete the entire backward-word")
-- map("i", "<A-Del>", '<Esc>"zcw', "delete forward-word")
-- map("i", "<A-S-Del>", '<Esc>"zcW', "delete the entire forward-word")
map("v", "g<A-a>", ":s/\\([^ ]\\) \\{2,\\}/\\1 /g<CR>:nohlsearch<CR>", "Unalign", { silent = true })
map(
  { "n", "i", "x" },
  "<S-A-Down>",
  keymapsUtils.getCloneLineFn "down",
  "clone line down",
  { silent = true, noremap = true }
)
map({ "n", "i", "x" }, "<S-A-Up>", keymapsUtils.getCloneLineFn "up", "clone line up", { silent = true, noremap = true })
map("s", "<BS>", function()
  keymapsUtils.runExpr '<C-o>"_c'
end, "delete selection")
map("n", "K", "kJ", "Join with prev line")
map("i", "<S-CR>", "'<C-o>o'", "add new line", { expr = true, noremap = true })

-- Allow moving the cursor through wrapped lines with <Up> and <Down>
-- and add numbered movement to jump list
map({ "n", "x" }, "<Down>", function()
  return vim.v.count == 0 and "gj" or "m'" .. vim.v.count .. "j"
end, nil, { expr = true, silent = true })
map({ "n", "x" }, "<Up>", function()
  return vim.v.count == 0 and "gk" or "m'" .. vim.v.count .. "k"
end, nil, { expr = true, silent = true })

-- editing movement
map("i", "<A-Left>", "<C-o>b", "move backward one word")
map("i", "<A-S-Left>", "<C-o>B", "move backward one entire word")
map("i", "<A-Right>", "<C-o>w", "move forward one word")
map("i", "<A-S-Right>", "<C-o>W", "move forward one entire word")
map("i", "<A-e>", "<C-o>e", "")
map("i", "<A-S-e>", "<C-o>E", "")

-- toggling
map("n", [[\]] .. "s", "<cmd>setlocal spell!<CR>", "Toggle 'spell'")
map("n", [[\]] .. "w", "<cmd>setlocal wrap!<CR>", "Toggle 'wrap'")
map("n", [[\]] .. "C", function()
  local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
  keymapsUtils.toggleLocalOpt("conceallevel", { 0, conceallevel })
end, "Toggle Conceal")

-- misc
map("n", "<C-y>", "<cmd> %y+ <CR>", "copy whole file")
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><esc>", "save buffer")
map({ "n", "i", "v" }, "<C-S-s>", "<cmd>w!<cr><esc>", "save buffer!")
map("n", "<leader>qq", "<cmd>qa <CR>", "exit")
map("n", "<leader>q!", "<cmd>qa! <CR>", "exit!")
map("n", "gV", "`[v`]", "select last yanked/changed text")
map({ "n", "i", "v", "s" }, "<C-e>", keymapsUtils.close_all_floating, "close floating windows")
map("n", "<f5>", "<cmd>edit %<CR>", "reload buffer")
map("n", "<leader>mps", function()
  vim.cmd [[
    :profile start /tmp/nvim-profile.log
    :profile func *
    :profile file *
  ]]
end, "Profile Start")
map("n", "<leader>mpe", function()
  vim.cmd [[
    :profile stop
    :e /tmp/nvim-profile.log
  ]]
end, "Profile End")
map("n", "<leader>mPs", "<cmd>syntime on<CR>", "Profile Syntax Start")
map("n", "<leader>mPe", "<cmd>syntime report<CR>", "Profile Syntax End")
-- https://vim.fandom.com/wiki/Super_retab
map("n", "<leader>mt", "<cmd>retab!<CR>", "format leading spacing in whole file")

-- better insert register pasting
-- disables autoindent before pasting
-- NOTE: missing register ":.="
local registers = '*+"-%/#abcdefghijklmnopqrstuvwxyz0123456789'
for i = 1, #registers do
  local register = registers:sub(i, i)

  map("i", "<C-r>" .. register, function()
    if vim.fn.reg_recording() then
      return "<C-r>" .. register
    end
    return "<cmd>lua require('custom.utils.keymaps').insertPaste(" .. register .. ")<CR>"
  end, nil, { expr = true, noremap = true })
end

-- fast macros execution
-- registers = "abcdefghijklmnopqrstuvwxyz"
-- for i = 1, #registers do
--   local register = registers:sub(i, i)
--
--   map("n", "@" .. register, function()
--     vim.opt.lazyredraw = true
--     vim.cmd.normal { "@" .. register, bang = true }
--     vim.opt.lazyredraw = false
--   end, nil, { noremap = true })
-- end

-- enable terminal like copy and paste in neovide
if vim.g.neovide then
  map({ "n", "v", "i", "c", "t" }, "<C-S-v>", keymapsUtils.paste, nil, { noremap = true })
end
