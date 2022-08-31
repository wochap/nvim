local M = {}

M.setup = function()
   local ok, dap = pcall(require, "dap")

   if not ok then
      return
   end

   dap.adapters.node2 = {
      type = "executable",
      command = "node",
      args = { os.getenv "HOME" .. "/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js" },
   }

   dap.adapters.chrome = {
      type = "executable",
      command = "node",
      args = { os.getenv "HOME" .. "/dev/microsoft/vscode-chrome-debug/out/src/chromeDebug.js" },
   }

   dap.configurations.javascript = {
      {
         name = "Launch",
         type = "node2",
         request = "launch",
         program = "${file}",
         cwd = vim.fn.getcwd(),
         sourceMaps = true,
         protocol = "inspector",
         console = "integratedTerminal",
      },
      {
         -- For this to work you need to make sure the node process is started with the `--inspect` flag.
         name = "Attach to process",
         type = "node2",
         request = "attach",
         processId = require("dap.utils").pick_process,
      },
   }

   dap.configurations.typescript = {
      {
         name = "Launch node",
         type = "node2",
         request = "launch",
         cwd = vim.fn.getcwd(),
         runtimeArgs = { "-r", "ts-node/register" },
         args = { "${file}" },
         sourceMaps = true,
         protocol = "inspector",
         console = "integratedTerminal",
      },

      -- TODO: test
      {
         name = "Launch chrome",
         type = "chrome",
         request = "launch",
         program = "${file}",
         cwd = vim.fn.getcwd(),
         sourceMaps = true,
         protocol = "inspector",
         console = "integratedTerminal",
         port = 9222,
         webRoot = "${workspaceFolder}",
         runtimeExecutable = "/run/current-system/sw/bin/google-chrome-stable",
         runtimeArgs = { "--remote-debugging-port=9222" },
      },
      {
         name = "Attach to process chrome",
         type = "chrome",
         request = "attach",
         program = "${file}",
         cwd = vim.fn.getcwd(),
         sourceMaps = true,
         protocol = "inspector",
         console = "integratedTerminal",
         port = 9222,
         webRoot = "${workspaceFolder}",
      },
   }

   -- Load vscode launchjs
   require("dap.ext.vscode").load_launchjs()

   vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
   vim.fn.sign_define("DapBreakpointRejected", { text = "🟦", texthl = "", linehl = "", numhl = "" })
   vim.fn.sign_define("DapStopped", { text = "⭐️", texthl = "", linehl = "", numhl = "" })
end

return M
