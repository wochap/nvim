local M = {}

local handlers = {
  function(config)
    require("mason-nvim-dap").default_setup(config)
  end,
  js = function(config)
    config.name = "pwa-node"
    config.filetypes = { "javascriptreact", "typescriptreact", "typescript", "javascript" }

    config.adapters = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        -- 💀 Make sure to update this path to point to your installation
        args = {
          require("mason-registry").get_package("js-debug-adapter"):get_install_path()
            .. "/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
    }

    config.configurations = {
      {
        name = "JS: Launch file",
        type = "pwa-node",
        request = "launch",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },

      -- For this to work you need to make sure the node process is started with the `--inspect` flag.
      {
        name = "JS: Attach to process",
        type = "pwa-node",
        request = "attach",
        -- processId = require("dap.utils").pick_process,
        cwd = "${workspaceFolder}",
        sourceMaps = true,
        protocol = "inspector",
        skipFiles = { "<node_internals>/**/*.js" },
      },
    }

    require("mason-nvim-dap").default_setup(config)
  end,
  node2 = function(config)
    config.adapters = {
      type = "executable",
      command = "node",
      args = {
        require("mason-registry").get_package("node-debug2-adapter"):get_install_path() .. "/out/src/nodeDebug.js",
      },
    }

    config.configurations = {
      {
        -- For this to work you need to make sure the node process is started with the `--inspect` flag.
        name = "Node2: Attach to process",
        type = "node2",
        request = "attach",
        -- processId = require("dap.utils").pick_process,
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        skipFiles = { "<node_internals>/**/*.js" },
      },
      {
        name = "Node2: Launch file",
        type = "node2",
        request = "launch",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
      },
      {
        name = "Node2: Launch file TS",
        type = "node2",
        request = "launch",
        cwd = vim.fn.getcwd(),
        runtimeArgs = { "-r", "ts-node/register" },
        args = { "${file}" },
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
      },
    }

    require("mason-nvim-dap").default_setup(config)
  end,
  chrome = function(config)
    config.adapters = {
      type = "executable",
      command = "node",
      args = {
        require("mason-registry").get_package("chrome-debug-adapter"):get_install_path() .. "/out/src/chromeDebug.js",
      },
    }

    config.configurations = {
      {
        name = "Chrome: Launch file",
        type = "chrome",
        request = "launch",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        port = 9222,
        webRoot = "${workspaceFolder}",
        runtimeExecutable = "/run/current-system/sw/bin/google-chrome-stable",
        runtimeArgs = { "--remote-debugging-port=9222" },
      },
      {
        name = "Chrome: Attach to process",
        type = "chrome",
        request = "attach",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        port = 9222,
        webRoot = "${workspaceFolder}",
      },
    }

    require("mason-nvim-dap").default_setup(config)
  end,
}

M.options = {
  ensure_installed = {
    "chrome",
    "js",
    "node2",
  },
  automatic_installation = false,
  handlers = handlers,
}

return M
