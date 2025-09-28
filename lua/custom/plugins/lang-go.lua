local constants = require "custom.constants"
local lang_utils = require "custom.utils.lang"

return {
  {
    enabled = not constants.first_install,
    import = "lazyvim.plugins.extras.lang.go",
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        gopls = {
          keys = {
            {
              "<leader>td",
              false,
            },
            -- Workaround for the lack of a DAP strategy in neotest-go: https://github.com/nvim-neotest/neotest-go/issues/12
            {
              "<leader>dt",
              "<cmd>lua require('dap-go').debug_test()<CR>",
              desc = "Debug Nearest (Go)",
            },
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
    "mason-org/mason.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      lang_utils.remove_str_from_list(opts.ensure_installed, "gomodifytags")
      lang_utils.remove_str_from_list(opts.ensure_installed, "impl")
    end,
  },
}
