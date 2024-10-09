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
    "iguanacucumber/magazine.nvim",
    optional = true,
    dependencies = {
      "f3fora/cmp-spell",
    },
    opts = {
      sources = {
        {
          name = "spell",
          max_item_count = 10,
          group_index = 99,
          option = {
            -- enable_in_context = function()
            --   return require("cmp.config.context").in_treesitter_capture "spell"
            -- end,
            preselect_correct_word = false,
          },
        },
      },
    },
  },
}
