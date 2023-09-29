local dap = require "dap"

local function attach()
  vim.notify "Attaching"

  -- Requires NodeJS 18
  -- dap.run {
  --   type = "pwa-node",
  --   request = "attach",
  --   cwd = "${workspaceFolder}",
  --   sourceMaps = true,
  --   protocol = "inspector",
  --   skipFiles = { "<node_internals>/**/*.js" },
  -- }

  -- Works on NodeJS 14
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
