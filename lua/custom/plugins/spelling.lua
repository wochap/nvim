return {
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        ltex = {
          filetypes = {
            "bib",
            "gitcommit",
            "markdown",
            "org",
            "plaintex",
            "rst",
            "rnoweb",
            "tex",
            "pandoc",
            "quarto",
            "rmd",
            "context",
            "mail",
            "text",
            "typst",
          },
          settings = {
            ltex = {
              language = "en-US",
              checkFrequency = "save",
              completionEnabled = true,
              additionalRules = {
                motherTongue = "es-AR",
              },
            },
          },
        },
      },
    },
  },

  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      -- remember to enable spell: `vim.opt.spell = true`
      -- use `z=` to use the native spell picker
      "f3fora/cmp-spell",
    },
    opts = {
      sources = {
        default = { "spell" },
        providers = {
          spell = {
            name = "spell",
            module = "blink.compat.source",
            max_items = 10,
            score_offset = -20,
            opts = {
              keep_all_entries = true, -- don't filter it
              -- enable_in_context = function()
              --   return require("cmp.config.context").in_treesitter_capture "spell"
              -- end,
              preselect_correct_word = false,
            },
            kind = "Spell",
          },
        },
      },
    },
  },
}
