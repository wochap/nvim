local constants = require "custom.utils.constants"
local utils = require "custom.utils"
local lazyUtils = require "custom.utils.lazy"

return {
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = not constants.in_vi_edit and not constants.in_kittyscrollback,
    version = false, -- last release is way too old and doesn't work on Windows
    lazy = not constants.has_file_arg,
    build = ":TSUpdate",
    event = { "LazyFile", "VeryLazy" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require "nvim-treesitter.query_predicates"
    end,
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "ssh_config",
        "gitcommit",
        "git_rebase",
        "git_config",
        "query",
        "regex",
        "vim",
        "vimdoc",
        "diff",
        "dockerfile",
        "just",
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]a"] = "@parameter.inner" },
          goto_next_end = { ["]F"] = "@function.outer", ["]A"] = "@parameter.inner" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[a"] = "@parameter.inner" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[A"] = "@parameter.inner" },
        },
      },
      indent = {
        enable = true,
        disable = { "yaml", "lua" },
      },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        disable = function(_, bufnr)
          return utils.is_minfile(bufnr) or utils.is_bigfile(bufnr, constants.big_file_mb)
        end,
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
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      vim.treesitter.language.register("bash", "zsh")

      -- add toggle keymap for treesitter
      Snacks.toggle.treesitter():map "<leader>uT"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    enabled = not constants.in_vi_edit and not constants.in_kittyscrollback,
    event = "VeryLazy",
    config = function()
      -- If treesitter is already loaded, we need to run config again for textobjects
      if lazyUtils.is_loaded "nvim-treesitter" then
        local treesitterOpts = lazyUtils.opts "nvim-treesitter"
        require("nvim-treesitter.configs").setup { textobjects = treesitterOpts.textobjects }
      end

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
    -- fork introduces get_window_contexts fn
    "wochap/nvim-treesitter-context",
    event = "VeryLazy",
    keys = {
      {
        "[C",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        mode = "n",
        desc = "GoTo Context",
      },
    },
    opts = function()
      local tsc = require "treesitter-context"
      Snacks.toggle({
        name = "Treesitter Context",
        get = tsc.enabled,
        set = function(state)
          if state then
            tsc.enable()
          else
            tsc.disable()
          end
        end,
      }):map "<leader>ut"

      return {
        mode = "cursor",
        max_lines = 3,
        zindex = constants.zindex_float,
        line_numbers = true,
        enable_hl = false,
      }
    end,
  },

  {
    "HiPhish/rainbow-delimiters.nvim",
    enabled = false,
    submodules = false,
    event = "VeryLazy",
    opts = {
      query = {
        javascript = "rainbow-parens",
        tsx = "rainbow-parens",
      },
      highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
      },
      -- whitelist = { "javascript" },
    },
    config = function(_, opts)
      lazyUtils.on_load("nvim-treesitter", function()
        require("rainbow-delimiters.setup").setup(opts)
      end)
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    event = { "InsertEnter", "VeryLazy" },
    config = function()
      lazyUtils.on_load("nvim-treesitter", function()
        require("nvim-ts-autotag").setup()
      end)
    end,
  },

  {
    "aaronik/treewalker.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<A-j>",
        "<cmd>Treewalker Down<CR>",
        mode = { "n", "v" },
        desc = "Treewalker Down",
      },
      {
        "<A-k>",
        "<cmd>Treewalker Up<CR>",
        mode = { "n", "v" },
        desc = "Treewalker Up",
      },
      {
        "<A-h>",
        "<cmd>Treewalker Left<CR>",
        mode = { "n", "v" },
        desc = "Treewalker Left",
      },
      {
        "<A-l>",
        "<cmd>Treewalker Right<CR>",
        mode = { "n", "v" },
        desc = "Treewalker Right",
      },
    },
    opts = {
      highlight = true,
      highlight_duration = 100,
      highlight_group = "Highlight",
    },
  },
}
