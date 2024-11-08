local lazyUtils = require "custom.utils.lazy"

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
            desc = "next breakpoint",
          },
          {
            "[h",
            function()
              require("goto-breakpoints").prev()
            end,
            desc = "prev breakpoint",
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
            desc = "clear virtual text",
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
            local ensureInstalled = vim.tbl_extend("force", {}, treesitterOpts.ensure_installed, {
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
        desc = "step out",
      },
      {
        "<leader>d<Right>",
        "<cmd>lua require'dap'.step_into()<CR>",
        desc = "step into",
      },
      {
        "<leader>d<Down>",
        "<cmd>lua require'dap'.step_over()<CR>",
        desc = "step over",
      },
      {
        "<leader>d<Left>",
        "<cmd>lua require'dap'.continue()<CR>",
        desc = "continue",
      },
      {
        "<leader>dH",
        "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
        desc = "set breakpoint condition",
      },
      {
        "<leader>dh",
        "<cmd>lua require'dap'.toggle_breakpoint()<CR>",
        desc = "set breakpoint",
      },
      {
        "<leader>dc",
        "<cmd>lua require'dap'.terminate()<CR>",
        desc = "terminate",
      },
      {
        "<leader>de",
        "<cmd>lua require'dap'.set_exception_breakpoints({'all'})<CR>",
        desc = "set exception breakpoints ALL",
      },
      {
        "<leader>di",
        "<cmd>lua require'dap.ui.widgets'.hover()<CR>",
        desc = "hover",
      },
      {
        "<leader>dr",
        "<cmd>lua require'dap'.repl.toggle({}, 'vsplit')<CR><C-w>l",
        desc = "toggle repl",
      },
      {
        "<leader>dn",
        "<cmd>lua require'dap'.run_to_cursor()<CR>",
        desc = "run to cursor",
      },
      {
        "<leader>du",
        function()
          require("dapui").toggle { reset = true }
          vim.cmd "wincmd ="
        end,
        desc = "open dapui",
      },
    },
    config = function()
      -- Load vscode launchjs
      local filetypes = require "mason-nvim-dap.mappings.filetypes"
      require("dap.ext.vscode").load_launchjs(nil, filetypes)

      vim.api.nvim_set_hl(0, "DapStoppedLine", {
        default = true,
        link = "Visual",
      })

      vim.fn.sign_define("DapBreakpoint", {
        text = " ",
        texthl = "DiagnosticError",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapBreakpointCondition", {
        text = " ",
        texthl = "DiagnosticError",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapBreakpointRejected", {
        text = " ",
        texthl = "DiagnosticError",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapStopped", {
        text = "󰁕 ",
        texthl = "DiagnosticWarn",
        linehl = "DapStoppedLine",
        numhl = "",
      })
      vim.fn.sign_define("DapLogPoint", {
        text = ".>",
        texthl = "DiagnosticError",
        linehl = "",
        numhl = "",
      })

      lazyUtils.on_load("magazine.nvim", function()
        local cmp = require "cmp"
        cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
          sources = {
            { name = "dap" },
          },
        })
      end)
    end,
  },
}
