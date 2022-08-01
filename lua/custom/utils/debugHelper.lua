local dap = require "dap"

local function attach()
   vim.notify "Attaching"

   dap.run {
      type = "node2",
      request = "attach",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      protocol = "inspector",
      skipFiles = { "<node_internals>/**/*.js" },
   }
end

return {
   attach = attach,
}
