local keymapsUtils = require "custom.utils.keymaps"
local terminalUtils = require "custom.utils.terminal"
local constants = require "custom.utils.constants"
local map = keymapsUtils.map

-- clear search
map({ "n", "i", "s" }, "<Esc>", function()
  vim.cmd "noh"
  local has_luasnip, luasnip = pcall(require, "luasnip")
  if has_luasnip then
    luasnip.unlink_current()
  end
  return "<Esc>"
end, "Esc and Clear hlsearch", { expr = true })

-- buffers
map("n", "<Leader>bn", "<cmd>enew<CR>", "New")
map("n", "<C-y>", "<cmd> %y+ <CR>", "Copy Buffer")
map({ "n", "i", "v" }, "<C-s>", function()
  local filename = (vim.fn.expand "%" == "" and "") or vim.fn.expand "%:t"
  local buftype = vim.api.nvim_get_option_value("buftype", { buf = 0 })
  if #filename == 0 or #buftype > 0 then
    return ""
  end
  vim.notify('"' .. filename .. '" written', vim.log.levels.INFO)
  return "<cmd>w<cr><esc>"
end, "Save Buffer", { expr = true })
map({ "n", "i", "v" }, "<C-S-s>", function()
  local filename = (vim.fn.expand "%" == "" and "") or vim.fn.expand "%:t"
  local buftype = vim.api.nvim_get_option_value("buftype", { buf = 0 })
  if #filename == 0 or #buftype > 0 then
    return ""
  end
  vim.notify('"' .. filename .. '" written', vim.log.levels.INFO)
  return "<cmd>w!<cr><esc>"
end, "Save Buffer!")
map("n", "<f5>", "<cmd>edit %<Bar>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", "Reload Buffer")

-- tabs
map("n", "<S-Up>", "<cmd>tabprevious<CR>", "Next Tab")
map("n", "<S-Down>", "<cmd>tabnext<CR>", "Previous Tab")
map("n", "<leader><tab>n", "<cmd>tabnew<CR>", "New")
map("n", "<leader><tab>o", "<cmd>tabonly<CR>", "Close Others")

-- windows
map("n", "<C-w>x", "<C-w>s", "Split Window Below")
map("n", "<C-w>v", "<C-w>v", "Split Window Right")
map("n", "<C-`>", "<C-w>p", "Previous Window")

-- terminal
map("t", "<C-x>", terminalUtils.exit_terminal_mode, "Esc Terminal") -- exit terminal mode
map("t", "<C-S-x>", terminalUtils.exit_terminal_mode .. "<C-w>q", "Hide Terminal")
map({ "n", "t" }, "<A-i>", terminalUtils.toggle_scratch_term, "Toggle Terminal")

-- scrolling
map({ "n", "v" }, "<C-S-d>", "zL", "Scroll Right") -- half screen
map({ "n", "v" }, "<C-S-u>", "zH", "Scroll Left") -- half screen
map("n", "<C-k>", "4<C-y>", "Scroll Up") -- keeping cursor position
map("n", "<C-j>", "4<C-e>", "Scroll Down") -- keeping cursor position

-- debug nvim config
map("n", "<f2>", keymapsUtils.print_syntax_info, "Inspect Cursor Syntax")
map("n", "<f3>", keymapsUtils.print_buf_info, "Inspect Buffer Info")
map("n", "<leader>md", "<cmd>lua require('osv').launch({ port = 8086 })<cr>", "Start Nvim Server")
map("n", "<leader>mD", "<cmd>lua require('osv').stop()<cr>", "Stop Nvim Server")

-- editing
map("n", "[<Space>", ":set paste<CR>m`O<Esc>``:set nopaste<CR>", "Add Empty Line Up", { silent = true })
map("n", "]<Space>", ":set paste<CR>m`o<Esc>``:set nopaste<CR>", "Add Empty Line Down", { silent = true })
map("n", "]<Del>", "m`:silent +g/\\m^\\s*$/d<CR>``:noh<CR>", "Remove Emply Line Up", { silent = true })
map("n", "[<Del>", "m`:silent -g/\\m^\\s*$/d<CR>``:noh<CR>", "Remove Emply Line Down", { silent = true })
map("i", "<A-BS>", '<Esc>"zcb<Del>', "Delete Backward Word")
map("i", "<A-S-BS>", '<Esc>"zcB<Del>', "Delete Entire Backward Word")
-- map("i", "<A-Del>", '<Esc>"zcw', "Delete Forward Word")
-- map("i", "<A-S-Del>", '<Esc>"zcW', "Delete Entire Forward Word")
map("v", "g<A-a>", ":s/\\([^ ]\\) \\{2,\\}/\\1 /g<CR>:nohlsearch<CR>", "Unalign", { silent = true })
map(
  { "n", "i", "x" },
  "<S-A-Down>",
  keymapsUtils.get_clone_line_fn "down",
  "Clone Line Down",
  { silent = true, noremap = true }
)
map(
  { "n", "i", "x" },
  "<S-A-Up>",
  keymapsUtils.get_clone_line_fn "up",
  "Clone Line Up",
  { silent = true, noremap = true }
)
map("s", "<BS>", function()
  keymapsUtils.run_expr '<C-o>"_c'
end, "Delete")
map("n", "K", "kJ", "Join With Prev Line")
map("i", "<S-CR>", "'<C-o>o'", "Add New Line", { expr = true, noremap = true })

-- Allow moving the cursor through wrapped lines with <Up> and <Down>
-- and add numbered movement to jump list
map({ "n", "x" }, "<Down>", function()
  return vim.v.count == 0 and "gj" or "m'" .. vim.v.count .. "j"
end, nil, { expr = true, silent = true })
map({ "n", "x" }, "<Up>", function()
  return vim.v.count == 0 and "gk" or "m'" .. vim.v.count .. "k"
end, nil, { expr = true, silent = true })

-- editing movement
map("i", "<A-Left>", "<C-o>b", "Move Backward Word")
map("i", "<A-S-Left>", "<C-o>B", "Move Entire Backward Word")
map("i", "<A-Right>", "<C-o>w", "Move Forward Word")
map("i", "<A-S-Right>", "<C-o>W", "Move Entire Forward Word")
-- map("i", "<A-e>", "<C-o>e", "")
-- map("i", "<A-S-e>", "<C-o>E", "")

-- toggling
Snacks.toggle.option("spell", { name = "Spelling" }):map "<leader>us"
Snacks.toggle.option("wrap", { name = "Wrap" }):map "<leader>uw"
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map "<leader>uL"
Snacks.toggle.line_number():map "<leader>ul"
Snacks.toggle
  .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" })
  :map "<leader>uc"
Snacks.toggle.diagnostics():map "<leader>ud"
Snacks.toggle.treesitter():map "<leader>uT"
-- Snacks.toggle.inlay_hints():map "<leader>uh"

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", "Next Search Result", { expr = true })
map("x", "n", "'Nn'[v:searchforward]", "Next Search Result", { expr = true })
map("o", "n", "'Nn'[v:searchforward]", "Next Search Result", { expr = true })
map("n", "N", "'nN'[v:searchforward].'zv'", "Prev Search Result", { expr = true })
map("x", "N", "'nN'[v:searchforward]", "Prev Search Result", { expr = true })
map("o", "N", "'nN'[v:searchforward]", "Prev Search Result", { expr = true })

-- misc
map("n", "<leader>qq", "<cmd>qa <CR>", "Exit")
map("n", "<leader>q!", "<cmd>qa! <CR>", "Exit!")
map("n", "gV", "`[v`]", "Last Yanked/Changed")
map({ "n", "i", "v", "s" }, "<C-e>", keymapsUtils.close_all_floating, "Close Floating Windows")
map("n", "<leader>mps", function()
  vim.cmd [[
    :profile start /tmp/nvim-profile.log
    :profile func *
    :profile file *
  ]]
end, "Profile Start (Custom)")
map("n", "<leader>mpe", function()
  vim.cmd [[
    :profile stop
    :e /tmp/nvim-profile.log
  ]]
end, "Profile End (Custom)")
map("n", "<leader>mPs", "<cmd>syntime on<CR>", "Profile Syntax Start")
map("n", "<leader>mPe", "<cmd>syntime report<CR>", "Profile Syntax End")
map("n", "<leader>mc", "<cmd>DiffClip<CR>", "DiffClip")
-- https://vim.fandom.com/wiki/Super_retab
map("n", "<leader>mt", "<cmd>retab!<CR>", "Format Leading Spacing") -- in buffer

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
    return "<cmd>lua require('custom.utils.keymaps').insert_paste(" .. register .. ")<CR>"
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
if constants.in_neovide then
  map({ "n", "v", "i", "c", "t" }, "<C-S-v>", keymapsUtils.paste, "Paste", { noremap = true })
end
