return {
  -- Linter, pull config from LazyVim
  -- https://www.lazyvim.org/plugins/linting
  -- the following opts for nvim-lint are managed by LazyVim:
  -- linters
  { import = "lazyvim.plugins.linting" },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = {} -- remove fish added by LazyVim
      return opts
    end,
  },
}
