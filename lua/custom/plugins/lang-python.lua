local constants = require "custom.utils.constants"

-- source: https://github.com/serranomorante/.dotfiles/blob/main/docs/python-dev-setup.md
local global_python_folder_path = os.getenv "GLOBAL_PYTHON_FOLDER_PATH" or ""
local global_kitty_folder_path = os.getenv "GLOBAL_KITTY_FOLDER_PATH" or ""
local venv_path = table.concat({
  "import sys",
  'sys.path.append("' .. global_python_folder_path .. '/lib/python3.11/site-packages")',
  'sys.path.append("' .. global_kitty_folder_path .. '/lib/kitty")',
  "import pylint_venv",
  "pylint_venv.inithook(force_venv_activation=True, quiet=True)",
}, "; ")

return {
  {
    enabled = not constants.first_install,
    import = "lazyvim.plugins.extras.lang.python",
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        ruff = {
          keys = {
            {
              "<leader>co",
              false,
            },
            {
              "<leader>lo",
              function()
                vim.lsp.buf.code_action {
                  apply = true,
                  context = {
                    only = { "source.organizeImports" },
                    diagnostics = {},
                  },
                }
              end,
              desc = "Organize Imports",
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
    "mfussenegger/nvim-lint",
    dependencies = {
      {
        "williamboman/mason.nvim",
        optional = true,
        opts = {
          ensure_installed = { "pylint" },
        },
      },
    },
    opts = {
      linters_by_ft = {
        python = { "pylint" },
      },
      linters = {
        pylint = {
          args = {
            "--init-hook",
            venv_path,
            "-f",
            "json",
            "--from-stdin",
            function()
              return vim.api.nvim_buf_get_name(0)
            end,
          },
        },
      },
    },
  },
}
