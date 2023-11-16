local plugins = {
  { import = "lazyvim.plugins.extras.lang.go" },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        gopls = {
          keys = {
            { "<leader>td", false },
            -- Workaround for the lack of a DAP strategy in neotest-go: https://github.com/nvim-neotest/neotest-go/issues/12
            { "<leader>dt", "<cmd>lua require('dap-go').debug_test()<CR>", desc = "Debug Nearest (Go)" },
          },
        },
      },
    },
  },

  -- undo none-ls changes added by LazyVim
  {
    "nvimtools/none-ls.nvim",
    enabled = false,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      local remove_str_from_list = require("custom.utils").remove_str_from_list
      remove_str_from_list(opts.ensure_installed, "gomodifytags")
      remove_str_from_list(opts.ensure_installed, "impl")
    end,
  },
}

return plugins
