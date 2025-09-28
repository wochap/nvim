local nvimUtils = require "custom.utils.nvim"

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
      nvimUtils.autocmd({
        "BufNewFile",
        "BufRead",
      }, {
        group = nvimUtils.augroup "set_typst_filetype",
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

  {
    "folke/ts-comments.nvim",
    optional = true,
    opts = {
      lang = {
        typst = "// %s",
      },
    },
  },

  {
    "OXY2DEV/markview.nvim",
    event = "VeryLazy",
    opts = {
      preview = {
        enable = true,
        icon_provider = "mini",
        debounce = 50,
        hybrid_modes = { "n" },
        linewise_hybrid_mode = true,
        filetypes = { "typst" },
      },
      html = {
        enable = false,
      },
      latex = {
        enable = false,
      },
      markdown = {
        enable = false,
      },
      markdown_inline = {
        enable = false,
      },
      typst = {
        enable = true,
        code_blocks = {
          style = "simple",
          text = "",
          hl = "",
          sign_hl = "SignColumn",
        },
        raw_blocks = {
          style = "simple",
          sign_hl = "SignColumn",
        },
        math_blocks = {
          -- TODO: add style simple
          pad_amount = 0,
        },
        headings = {
          enable = true,
          shift_width = 0,
          heading_1 = {
            sign = "",
          },
          heading_2 = {
            sign = "",
          },
        },
        list_items = {
          enable = true,
          marker_minus = {
            add_padding = false,
          },
          marker_plus = {
            add_padding = false,
          },
          marker_dot = {
            add_padding = false,
          },
        },
      },
      yaml = {
        enable = false,
        math_blocks = {
          enable = false,
        },
        math_spans = {
          enable = false,
        },
      },
    },
    init = function()
      -- HACK: don't load blink or cmp plugin
      vim.g.markview_blink_loaded = true
      vim.g.markview_cmp_loaded = true
    end,
  },
}
