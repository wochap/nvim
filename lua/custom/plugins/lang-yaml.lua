return {
  {
    import = "lazyvim.plugins.extras.lang.yaml",
  },

  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = {
        "yaml",
      },
    },
  },
}
