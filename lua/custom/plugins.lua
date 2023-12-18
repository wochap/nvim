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
  { import = "custom.custom-plugins.editor" },
  { import = "custom.custom-plugins.coding" },

  { import = "custom.custom-plugins.extras-lang.c" },
  { import = "custom.custom-plugins.extras-lang.go" },
  { import = "custom.custom-plugins.extras-lang.lua" },
  { import = "custom.custom-plugins.extras-lang.nix" },
  { import = "custom.custom-plugins.extras-lang.python" },
  { import = "custom.custom-plugins.extras-lang.web" },
  { import = "custom.custom-plugins.extras-lang.shell" },
  { import = "custom.custom-plugins.extras-lang.zig" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.yaml" },

  { import = "custom.custom-plugins.colorscheme" },
}
