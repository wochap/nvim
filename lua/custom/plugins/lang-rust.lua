local constants = require "custom.utils.constants"

vim.g.lazyvim_rust_diagnostics = "rust-analyzer"

return {
  {
    enabled = not constants.first_install,
    import = "lazyvim.plugins.extras.lang.rust",
  },

  {
    "mason-org/mason.nvim",
    optional = true,
    opts = {
      ensure_installed = { "rust-analyzer", "rustfmt" },
    },
  },

  {
    "mrcjkb/rustaceanvim",
    optional = true,
    opts = {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>lc", function()
            vim.cmd.RustLsp "codeAction"
          end, { desc = "Code Action", buffer = bufnr })
          vim.keymap.set("n", "<leader>dR", function()
            vim.cmd.RustLsp "debuggables"
          end, { desc = "Rust Debuggables", buffer = bufnr })
        end,
      },
    },
  },
}
