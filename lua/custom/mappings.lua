local utils = require "core.utils"
local hooks = require "core.hooks"

local config = utils.load_config()
local map = utils.map

local maps = config.mappings
local plugin_maps = maps.plugins

hooks.add("setup_mappings", function(map)
   local opts = { noremap = true, silent = true }

   map("n", "<leader>fs", "<cmd>Telescope filetypes<CR>")

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

   -- Git
   map("n", "<leader>gf", "<cmd>DiffviewFileHistory<CR>", opts)
   map("n", "<leader>gb", "<cmd>lua require'custom.utils.telescope'.branches()<CR>")
   map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", opts)
   map("n", "<leader>gq", "<cmd>DiffviewClose<CR>", opts)
   map("n", "<leader>gg", "<cmd>Neogit<CR>", opts)
   -- map("n", "<leader>gf", "<cmd>Telescope git_bcommits <CR>", opts)

   -- Stay in indent mode
   map("v", "<", "<gv", opts)
   map("v", ">", ">gv", opts)
   
   -- Sort multiples lines with F9
   map("v", "<F9>", ":'<,'>sort<CR>", opts)

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

   -- LSP
   map("n", "grh", "<cmd>lua vim.lsp.buf.document_highlight()<CR>")
   map("n", "grc", "<cmd>lua vim.lsp.buf.clear_references()<CR>")
end)
