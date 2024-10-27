local utils = require "custom.utils"

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = { "typst" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    optional = true,
    init = function()
      utils.autocmd({
        "BufNewFile",
        "BufRead",
      }, {
        group = utils.augroup "set_typst_filetype",
        pattern = "*.typ",
        callback = function(event)
          vim.bo[event.buf].filetype = "typst"
        end,
      })
    end,
    opts = {
      servers = {
        tinymist = {
          mason = false,
          single_file_support = true,
          root_dir = function()
            return vim.fn.getcwd()
          end,
          settings = {
            exportPdf = "onSave",
            outputPath = "$root/$dir/$name",
            systemFonts = true,
            fontPaths = nil,
          },
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    -- NOTE: mason doesn't have typstyle
    opts = {
      formatters_by_ft = {
        ["typst"] = { "typstyle" },
      },
    },
  },
}
