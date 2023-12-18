return {
  -- LazyVim
  { "LazyVim/LazyVim" },
  { import = "custom.custom-plugins.lazyvim-driver" },

  -- NvChad
  { import = "custom.custom-plugins.nvchad" },

  { import = "custom.custom-plugins.lsp" },
  { import = "custom.custom-plugins.formatting" },
  { import = "custom.custom-plugins.linting" },
  { import = "custom.custom-plugins.dap" },

  { import = "custom.custom-plugins.neorg" },
  { import = "custom.custom-plugins.leetcode" },
  { import = "custom.custom-plugins.ui" },
  { import = "custom.custom-plugins.util" },
  { import = "custom.custom-plugins.others" },

  -- { import = "custom.extras-lang.c" },
  -- { import = "custom.extras-lang.go" },
  { import = "custom.extras-lang.lua" },
  -- { import = "custom.extras-lang.nix" },
  -- { import = "custom.extras-lang.python" },
  -- { import = "custom.extras-lang.web" },
  -- { import = "custom.extras-lang.shell" },
  -- { import = "custom.extras-lang.zig" },
  -- { import = "lazyvim.plugins.extras.lang.json" },
  -- { import = "lazyvim.plugins.extras.lang.yaml" },
}
