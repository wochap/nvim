local utils = require "custom.utils"
local lazyUtils = require "custom.utils.lazy"

return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "LazyFile", "VeryLazy" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
          -- When in diff mode, we want to use the default
          -- vim text objects c & C instead of the treesitter ones.
          local move = require "nvim-treesitter.textobjects.move"
          local configs = require "nvim-treesitter.configs"
          for name, fn in pairs(move) do
            if name:find "goto" == 1 then
              move[name] = function(q, ...)
                if vim.wo.diff then
                  local config = configs.get_module("textobjects.move")[name]
                  for key, query in pairs(config or {}) do
                    if q == query and key:find "[%]%[][cC]" then
                      vim.cmd("normal! " .. key)
                      return
                    end
                  end
                end
                return fn(q, ...)
              end
            end
          end
        end,
      },

      {
        url = "https://gitlab.com/HiPhish/rainbow-delimiters.nvim.git",
        init = function()
          vim.g.rainbow_delimiters = {
            query = {
              javascript = "rainbow-parens",
            },
            highlight = {
              "rainbow1",
              "rainbow2",
              "rainbow3",
              "rainbow4",
              "rainbow5",
              "rainbow6",
            },
            whitelist = { "javascript" },
          }
        end,
      },
    },
    init = function(plugin)
      -- PERF: disable nvim syntax plugin, which causes lag when scrolling
      -- treesitter enables it everytime you open a new file
      utils.autocmd({ "BufReadPost" }, {
        group = utils.augroup "disable_nvim_syntax",
        command = "syntax off",
      })

      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require "nvim-treesitter.query_predicates"
    end,
    opts = {
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
      },
      indent = {
        enable = true,
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      ensure_installed = {
        "git_config",
        "markdown",
        "markdown_inline",
        "query",
        "rasi",
        "regex",
        "vim",
        "vimdoc",
        "diff",
        -- "norg"
      },
    },
    config = function(_, opts)
      -- TODO: move to dap file
      require("nvim-dap-repl-highlights").setup()

      require("nvim-treesitter.configs").setup(opts)

      vim.treesitter.language.register("bash", "zsh")
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      lazyUtils.on_load("nvim-treesitter", function()
        require("nvim-ts-autotag").setup()
      end)
    end,
  },
}
