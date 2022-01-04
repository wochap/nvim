local utils = require "core.utils"
local hooks = require "core.hooks"

local config = utils.load_config()
local map = utils.map

local maps = config.mappings
local plugin_maps = maps.plugins

hooks.add("setup_mappings", function(map)
   local opts = { noremap = true, silent = true }

   -- Clone lines ala vscode 
   map("n", "<C-S-A-Down>", "yyp", opts)
   map("n", "<C-S-A-Up>", "yyP", opts)
   map("v", "<C-S-A-Down>", "y`]p", opts)
   map("v", "<C-S-A-Up>", "y`[P", opts)

   map("n", "<leader>qa", ":qa <CR>", opts)

   map("n", "<leader>sr", "<cmd>lua require('spectre').open()<CR>", opts)
   map("n", "<leader>ss", "<cmd>lua require'custom.utils.telescope'.symbols()<CR>", opts)
   map("n", "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", opts)

   -- Harpon
   map("n", "<leader>hs", [[ <Cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>]], opts)
   map("n", "<leader>ha", [[ <Cmd>lua require("harpoon.mark").add_file()<CR>]], opts)
   map("n", "<leader>hl", [[ <Cmd>lua require("harpoon.ui").nav_file(1)<CR>]], opts)
   map("n", "<leader>hu", [[ <Cmd>lua require("harpoon.ui").nav_file(2)<CR>]], opts)
   map("n", "<leader>hy", [[ <Cmd>lua require("harpoon.ui").nav_file(3)<CR>]], opts)
   map("n", "<leader>h;", [[ <Cmd>lua require("harpoon.ui").nav_file(4)<CR>]], opts)

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
   map("n", "<leader>gg", "<cmd>Neogit<CR>", opts)
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

   -- Move current line / block with Alt-j/k ala vscode.
   map("i", "<A-Down>", "<Esc>:m .+1<CR>==gi", opts)
   map("i", "<A-Up>", "<Esc>:m .-2<CR>==gi", opts)
   map("n", "<A-Down>", ":m .+1<CR>==", opts)
   map("n", "<A-Up>", ":m .-2<CR>==", opts)
   map("x", "<A-Down>", ":m '>+1<CR>gv-gv", opts)
   map("x", "<A-Up>", ":m '<-2<CR>gv-gv", opts)

   -- Save on insert mode
   map("i", "<C-s>", "<Esc>:w <CR>", opts)
end)
