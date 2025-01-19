return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = {
        "hyprlang",
        "rasi",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function()
      vim.filetype.add {
        extension = {
          rasi = "rasi",
        },
        pattern = {
          [".*/hypr/.+%.conf"] = "hyprlang",
        },
      }
    end,
  },
}
