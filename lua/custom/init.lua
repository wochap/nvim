-- This is where your custom modules and plugins go.
-- See the wiki for a guide on how to extend NvChad

local hooks = require "core.hooks"

-- NOTE: To use this, make a copy with `cp example_init.lua init.lua`

--------------------------------------------------------------------

-- To modify packaged plugin configs, use the overrides functionality
-- if the override does not exist in the plugin config, make or request a PR,
-- or you can override the whole plugin config with 'chadrc' -> M.plugins.default_plugin_config_replace{}
-- this will run your config instead of the NvChad config for the given plugin

-- hooks.override("lsp", "publish_diagnostics", function(current)
--   current.virtual_text = false;
--   return current;
-- end)

-- To add new mappings, use the "setup_mappings" hook,
-- you can set one or many mappings
-- example below:

-- hooks.add("setup_mappings", function(map)
--    map("n", "<leader>cc", "gg0vG$d", opt) -- example to delete the buffer
--    .... many more mappings ....
-- end)
hooks.add("setup_mappings", function(map)
   local opts = { noremap = true, silent = true }

   -- Git
   map("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", opts)
   map("n", "<leader>gg", "<cmd>Neogit<CR>", opts)

   -- For null-ls
   map("n", "<leader>fm", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

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
end)

-- To add new plugins, use the "install_plugin" hook,
-- NOTE: we heavily suggest using Packer's lazy loading (with the 'event' field)
-- see: https://github.com/wbthomason/packer.nvim
-- examples below:

-- hooks.add("install_plugins", function(use)
--    use {
--       "max397574/better-escape.nvim",
--       event = "InsertEnter",
--    }
-- end)

-- alternatively, put this in a sub-folder like "lua/custom/plugins/mkdir"
-- then source it with

-- require "custom.plugins.mkdir"

require "custom.globals"
require "custom.plugins"
