local utils = require "custom.utils"
local lazyUtils = require "custom.utils.lazy"
local langUtils = require "custom.utils.lang"

-- Debugger
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",

      {
        "ofirgall/goto-breakpoints.nvim",
        keys = {
          {
            "]h",
            function()
              require("goto-breakpoints").next()
            end,
            desc = "Next Breakpoint",
          },
          {
            "[h",
            function()
              require("goto-breakpoints").prev()
            end,
            desc = "Prev Breakpoint",
          },
        },
      },

      {
        "rcarriga/nvim-dap-ui",
        opts = {
          layouts = {
            {
              elements = {
                {
                  id = "scopes",
                  size = 0.25,
                },
                {
                  id = "breakpoints",
                  size = 0.25,
                },
                {
                  id = "stacks",
                  size = 0.25,
                },
                {
                  id = "watches",
                  size = 0.25,
                },
              },
              position = "right",
              size = 50,
            },
            {
              elements = {
                {
                  id = "repl",
                  size = 0.5,
                },
                {
                  id = "console",
                  size = 0.5,
                },
              },
              position = "bottom",
              size = 10,
            },
          },
        },
        config = function(_, opts)
          local dap = require "dap"
          local dapui = require "dapui"
          dapui.setup(opts)
          dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open {}
            vim.cmd "wincmd ="
          end
          dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close {}
          end
          dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close {}
          end
        end,
      },

      {
        "theHamsta/nvim-dap-virtual-text",
        keys = {
          {
            "<leader>dC",
            function()
              local virtual_text = require "nvim-dap-virtual-text/virtual_text"
              virtual_text.clear_virtual_text()
              virtual_text.clear_last_frames()
            end,
            desc = "Clear Virtual Text",
          },
        },
        opts = {
          virt_text_pos = "eol",
        },
      },

      {
        "LiadOz/nvim-dap-repl-highlights",
        config = function()
          lazyUtils.on_load("nvim-treesitter", function()
            local treesitterOpts = lazyUtils.opts "nvim-treesitter"
            local ensureInstalled = langUtils.list_merge(treesitterOpts.ensure_installed, {
              "dap_repl",
            })
            require("nvim-dap-repl-highlights").setup()
            require("nvim-treesitter.configs").setup { ensure_installed = ensureInstalled }
          end)
        end,
      },

      "mason.nvim",

      {
        "jay-babu/mason-nvim-dap.nvim",
        cmd = { "DapInstall", "DapUninstall" },
        opts_extend = { "ensure_installed" },
        opts = {
          ensure_installed = {},
          automatic_installation = true,
          handlers = {
            function() end,
          },
        },
        config = function() end,
      },

      "rcarriga/cmp-dap",
    },
    keys = {
      {
        "<leader>d",
        "",
        desc = "dap",
      },

      {
        "<leader>d<Up>",
        "<cmd>lua require'dap'.step_out()<CR>",
        desc = "Step Out",
      },
      {
        "<leader>d<Right>",
        "<cmd>lua require'dap'.step_into()<CR>",
        desc = "Step Into",
      },
      {
        "<leader>d<Down>",
        "<cmd>lua require'dap'.step_over()<CR>",
        desc = "Step Over",
      },
      {
        "<leader>d<Left>",
        "<cmd>lua require'dap'.continue()<CR>",
        desc = "Continue",
      },
      {
        "<leader>dH",
        "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
        desc = "Add Breakpoint Condition",
      },
      {
        "<leader>dh",
        "<cmd>lua require'dap'.toggle_breakpoint()<CR>",
        desc = "Add Breakpoint",
      },
      {
        "<leader>dc",
        "<cmd>lua require'dap'.terminate()<CR>",
        desc = "Terminate",
      },
      {
        "<leader>de",
        "<cmd>lua require'dap'.set_exception_breakpoints({'all'})<CR>",
        desc = "Add Exception Breakpoints All",
      },
      {
        "<leader>di",
        "<cmd>lua require'dap.ui.widgets'.hover()<CR>",
        desc = "Hover",
      },
      {
        "<leader>dr",
        "<cmd>lua require'dap'.repl.toggle({}, 'vsplit')<CR><C-w>l",
        desc = "Toggle Repl",
      },
      {
        "<leader>dn",
        "<cmd>lua require'dap'.run_to_cursor()<CR>",
        desc = "Run To Cursor",
      },
      {
        "<leader>du",
        function()
          local is_dapui_open = false
          local windows = require "dapui.windows"
          for _, win_layout in ipairs(windows.layouts) do
            if win_layout:is_open() then
              is_dapui_open = true
            end
          end

          if not is_dapui_open then
            utils.close_sidebars "dapui"
          end

          vim.schedule(function()
            require("dapui").toggle { reset = true }
            vim.cmd "wincmd ="
          end)
        end,
        desc = "DapUI",
      },
    },
    config = function()
      -- load mason-nvim-dap here, after all adapters have been setup
      require("mason-nvim-dap").setup(lazyUtils.opts "mason-nvim-dap.nvim")

      -- setup dap config by VsCode launch.json file
      local vscode = require "dap.ext.vscode"
      local json = require "plenary.json"
      vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end

      vim.fn.sign_define("DapBreakpoint", {
        text = "●",
        texthl = "DapBreakpoint",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapBreakpointCondition", {
        text = "●",
        texthl = "DapBreakpointCondition",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapBreakpointRejected", {
        text = "●",
        texthl = "DapBreakpointRejected",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapStopped", {
        text = "",
        texthl = "DapStopped",
        linehl = "DapStoppedLine",
        numhl = "",
      })
      vim.fn.sign_define("DapLogPoint", {
        text = "◆",
        texthl = "DapLogPoint",
        linehl = "",
        numhl = "",
      })
    end,
  },

  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      enableds = {
        function()
          local has_cmp_dap, _ = pcall(require, "cmp_dap")
          if has_cmp_dap then
            local cmp_dap = require "cmp_dap"
            -- enable if in dap buffer
            if cmp_dap.is_dap_buffer() then
              return true
            end
          end
          return nil
        end,
      },
      sources = {
        defaults = {
          function()
            local has_cmp_dap, _ = pcall(require, "cmp_dap")
            if has_cmp_dap then
              local cmp_dap = require "cmp_dap"
              -- enable if in dap buffer
              if cmp_dap.is_dap_buffer() then
                return { "dap", "buffer" }
              end
            end
            return nil
          end,
        },
        providers = {
          -- the following command tells if current dap session supports completion
          -- :lua= require("dap").session().capabilities.supportsCompletionsRequest
          dap = {
            name = "dap",
            module = "blink.compat.source",
            kind = "Dap",
          },
        },
      },
    },
  },
}
