local utils = require "core.utils"

local map = utils.map
local config = utils.load_config()
local maps = config.mappings
local plugin_maps = maps.plugins

local opts = { noremap = true, silent = true }

map("n", "<C-e>", "<cmd>lua require'custom.utils.window'.closeAllFloating()<CR>", opts)
map("i", "<C-e>", "<cmd>lua require'custom.utils.window'.closeAllFloating()<CR>", opts)

map("i", "<C-k>", "<cmd>lua require'custom.utils.others'.expandSnippet()<CR>", opts)

-- Remaps for each of the four debug operations currently offered by the plugin
map("v", "<Leader>lre", "<Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>", opts)
map("v", "<Leader>lrf", "<Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>", opts)
map("v", "<Leader>lrv", "<Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>", opts)
map("v", "<Leader>lri", "<Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>", opts)

-- Open new buffer
map("n", "<Leader>fn", ":enew<CR>", opts)

-- Close buffers
map("n", "<leader>w", "<cmd>lua require('close_buffers').delete({ type = 'this' })<CR>", opts)
map("n", "<leader>W", "<cmd>lua require('close_buffers').delete({ type = 'this', force = true })<CR>", opts)
map("n", "<leader>fk", "<cmd>lua require('close_buffers').delete({ type = 'other' })<CR>", opts)
map("n", "<leader>fK", "<cmd>lua require('close_buffers').delete({ type = 'other', force = true })<CR>", opts)

-- Persistence
map("n", "<leader>nl", "<cmd>lua require('persistence').load()<CR>", opts)

-- Search
map("n", "<leader>ff", "<cmd>lua require'custom.utils.telescope'.find_files()<CR>", opts)
map("n", "<leader>fa", "<cmd>lua require'custom.utils.telescope'.find_all_files()<CR>", opts)
map("n", "<leader>sg", "<cmd>lua require'custom.utils.telescope'.live_grep()<CR>", opts)
map("n", "<leader>sr", "<cmd>lua require('spectre').open()<CR>", opts)
map("n", "<leader>ss", "<cmd>lua require'custom.utils.telescope'.symbols()<CR>", opts)
map("n", "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", opts)

-- Harpon
map("n", "<leader>ht", "<cmd>lua require('harpoon.cmd-ui').toggle_quick_menu()<CR>", opts)
map("n", "<leader>hl", "<cmd>lua require('harpoon.term').gotoTerminal(1)<CR>", opts)
map("n", "<leader>hu", "<cmd>lua require('harpoon.term').gotoTerminal(2)<CR>", opts)
map("n", "<leader>hy", "<cmd>lua require('harpoon.term').gotoTerminal(3)<CR>", opts)
map("n", "<leader>h;", "<cmd>lua require('harpoon.term').gotoTerminal(4)<CR>", opts)
map("n", "<leader>hs", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", opts)
map("n", "<leader>ha", "<cmd>lua require('harpoon.mark').add_file()<CR>", opts)
map("n", "<leader>hp", "<cmd>lua require('harpoon.ui').nav_file(1)<CR>", opts)
map("n", "<leader>hf", "<cmd>lua require('harpoon.ui').nav_file(2)<CR>", opts)
map("n", "<leader>hw", "<cmd>lua require('harpoon.ui').nav_file(3)<CR>", opts)
map("n", "<leader>hq", "<cmd>lua require('harpoon.ui').nav_file(4)<CR>", opts)

-- Trouble
map("n", "<leader>xx", "<cmd>TroubleToggle<cr>", opts)
map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", opts)
map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", opts)
map("n", "<leader>xt", "<cmd>TodoTrouble<cr>", opts)
map("n", "<leader>xT", "<cmd>TodoTelescope<cr>", opts)
map("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", opts)
map("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", opts)
map("n", "grr", "<cmd>TroubleToggle lsp_references<cr>", opts)
map("n", "[t", "<cmd>lua require('trouble').previous({skip_groups = true, jump = true})<CR>", opts)
map("n", "]t", "<cmd>lua require('trouble').next({skip_groups = true, jump = true})<CR>", opts)

-- Packer
map("n", "<leader>pc", "<cmd>PackerCompile<cr>", opts)
map("n", "<leader>pi", "<cmd>PackerInstall<cr>", opts)
map("n", "<leader>ps", "<cmd>PackerSync<cr>", opts)
map("n", "<leader>pS", "<cmd>PackerStatus<cr>", opts)
map("n", "<leader>pu", "<cmd>PackerUpdate<cr>", opts)

-- LSP
map("n", "<leader>lr", "<cmd>Lspsaga rename<CR>")
map("n", "<leader>la", "<cmd>Lspsaga code_action<CR>")
map("v", "<leader>la", "<cmd><C-U>Lspsaga range_code_action<CR>")
map("n", "grh", "<cmd>lua vim.lsp.buf.document_highlight()<CR>")
map("n", "grc", "<cmd>lua vim.lsp.buf.clear_references()<CR>")
map("n", "gdv", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", opts)
map("n", "gds", "<cmd>split | lua vim.lsp.buf.definition()<CR>", opts)
map("n", "[e", "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>", opts)
map("n", "]e", "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>", opts)
map("v", plugin_maps.lspconfig.formatting, "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)

map("n", "<leader>fs", "<cmd>Telescope filetypes<CR>")

-- Git
map("n", "<leader>gf", "<cmd>DiffviewFileHistory<CR>", opts)
map("n", "<leader>gB", "<cmd>lua require'custom.utils.telescope'.branches()<CR>", opts)
map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", opts)
map("n", "<leader>gq", "<cmd>DiffviewClose<CR>", opts)
map("n", "<leader>gg", "<cmd>Neogit kind=vsplit<CR>", opts)
map("n", "<leader>gl", "<cmd>LazyGit<CR>", opts)
-- map("n", "<leader>gf", "<cmd>Telescope git_bcommits <CR>", opts)

-- MaximizerToggle
map("n", "<leader>m", "<cmd>MaximizerToggle!<CR>", opts)

-- Dap
map("n", "<leader>d<Up>", "<cmd>lua require'dap'.step_out()<CR>", opts)
map("n", "<leader>d<Right>", "<cmd>lua require'dap'.step_into()<CR>", opts)
map("n", "<leader>d<Down>", "<cmd>lua require'dap'.step_over()<CR>", opts)
map("n", "<leader>d<Left>", "<cmd>lua require'dap'.continue()<CR>", opts)
map("n", "<leader>da", "<cmd>lua require'custom.utils.debugHelper'.attach()<CR>", opts)
map("n", "<leader>dH", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", opts)
map("n", "<leader>dh", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", opts)
map("n", "<leader>dc", "<cmd>lua require'dap'.terminate()<CR>", opts)
map("n", "<leader>de", "<cmd>lua require'dap'.set_exception_breakpoints({'all'})<CR>", opts)
map("n", "<leader>di", "<cmd>lua require'dap.ui.widgets'.hover()<CR>", opts)
map("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle({}, 'vsplit')<CR><C-w>l", opts)
map("n", "<leader>dn", "<cmd>lua require'dap'.run_to_cursor()<CR>", opts)
map("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<CR>", opts)
-- map("n", "<leader>d?", "<cmd>lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>", opts)
-- map("n", "<leader>dk", "<cmd>lua require"dap".up()<CR>", opts)
-- map("n", "<leader>dj", "<cmd>lua require"dap".down()<CR>", opts)

map("n", "[q", ":cprevious<CR>", opts)
map("n", "]q", ":cnext<CR>", opts)
map("n", "[l", ":lprevious<CR>", opts)
map("n", "]l", ":lnext<CR>", opts)

-- Quickly adding and deleting empty lines
map("n", "[<Space>", ":set paste<CR>m`O<Esc>``:set nopaste<CR>", opts)
map("n", "]<Space>", ":set paste<CR>m`o<Esc>``:set nopaste<CR>", opts)
map("n", "[<Del>", "m`:silent +g/\\m^\\s*$/d<CR>``:noh<CR>", opts)
map("n", "]<Del>", "m`:silent -g/\\m^\\s*$/d<CR>``:noh<CR>", opts)

-- Exit
map("n", "<leader>qa", "<cmd>qa <CR>", opts)
map("n", "<leader>q!", "<cmd>qa! <CR>", opts)

-- Select last yanked/changed text
map("n", "gV", "`[v`]", opts)

-- Stay in indent mode
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Sort multiples lines with F9
map("v", "<F9>", ":'<,'>sort<CR>", opts)

-- ThePrimeagen - keeping centered
map("n", "n", "nzzzv", opts)
map("n", "N", "Nzzzv", opts)
map("n", "J", "mzJ`z", opts)

-- ThePrimeagen - unto break points
map("i", ",", ",<C-g>u", opts)
map("i", ".", ".<C-g>u", opts)
map("i", "!", "!<C-g>u", opts)
map("i", "?", "?<C-g>u", opts)

-- Clone lines ala vscode
map("n", "<C-S-A-Down>", '"zyy"zp', opts)
map("n", "<C-S-A-Up>", '"zyy"zP', opts)
map("v", "<C-S-A-Down>", '"zy`]"zp', opts)
map("v", "<C-S-A-Up>", '"zy`["zP', opts)

-- Move current line / block with Alt-Down/Up ala vscode.
map("i", "<A-Down>", "<Esc>:m .+1<CR>==gi", opts)
map("i", "<A-Up>", "<Esc>:m .-2<CR>==gi", opts)
map("n", "<A-Down>", ":m .+1<CR>==", opts)
map("n", "<A-Up>", ":m .-2<CR>==", opts)
map("x", "<A-Down>", ":m '>+1<CR>gv-gv", opts)
map("x", "<A-Up>", ":m '<-2<CR>gv-gv", opts)

-- Save in insert mode
map("i", "<C-s>", "<Esc>:w <CR>", opts)
map("v", "<C-s>", "<Esc>:w <CR>", opts)

map("n", "<S-Up>", "<cmd>tabn<CR>", opts)
map("n", "<S-Down>", "<cmd>tabp<CR>", opts)

-- -- Prevent changes made to text from landing in the default registers
-- map("n", "c", '"_c', opts)
-- map("n", "C", '"_C', opts)
-- map("n", "s", '"_s', opts)
-- map("n", "S", '"_S', opts)
--
-- -- Same as above but for visual mode
-- map("v", "c", '"_c', opts)
-- map("v", "C", '"_C', opts)
-- map("v", "s", '"_s', opts)
-- map("v", "S", '"_S', opts)

-- Don't change default register on pasting (visual mode)
map("v", "p", '"_dp', opts)
map("v", "P", '"_dP', opts)

-- Change selected content
map("s", "c", '<C-o>"_c', opts)
