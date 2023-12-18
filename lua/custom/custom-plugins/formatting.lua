return {
  -- Formatter, pull config from LazyVim
  -- https://www.lazyvim.org/plugins/formatting
  { import = "lazyvim.plugins.formatting" },
  {
    "stevearc/conform.nvim",
    keys = { { "<leader>cF", false, mode = { "n", "v" } } },
    opts = function(_, opts)
      opts.formatters_by_ft = {} -- remove lua, fish and sh added by LazyVim
      return opts
    end,
  },
}
