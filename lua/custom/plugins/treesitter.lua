local constants = require "custom.constants"
local lazy_utils = require "custom.utils.lazy"
local treesitter_utils = require "custom.utils-plugins.treesitter"

return {
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = not constants.in_vi_edit and not constants.in_kittyscrollback,
    version = false,
    branch = "main",
    build = function()
      local treesitter = require "nvim-treesitter"
      treesitter.update(nil, { summary = true })
    end,
    event = constants.first_install and { "VeryLazy" } or { "LazyFile", "VeryLazy" },
    cmd = { "TSUpdate", "TSInstall", "TSInstallFromGrammar", "TSLog", "TSUninstall" },
    opts_extend = { "ensure_installed" },
    opts = {
      -- NOTE: nvim-treesitter doesn't have the option `ensure_installed`
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
        "toml",
      },
    },
    config = function(_, opts)
      local treesitter = require "nvim-treesitter"

      -- setup treesitter
      treesitter.setup(opts)
      treesitter_utils.get_installed(true) -- initialize the installed langs

      -- install missing parsers
      local install = vim.tbl_filter(function(lang)
        return not treesitter_utils.have(lang)
      end, opts.ensure_installed or {})
      if #install > 0 then
        treesitter.install(install, { summary = true }):await(function()
          treesitter_utils.get_installed(true) -- refresh the installed langs
        end)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("lazyvim_treesitter", { clear = true }),
        callback = function(ev)
          if not treesitter_utils.have(ev.match) then
            return
          end

          -- highlighting
          pcall(vim.treesitter.start)

          -- indents
          if treesitter_utils.have(ev.match, "indents") then
            local exclude_filetypes = { "html", "yaml", "lua", "javascript" }
            if not vim.tbl_contains(exclude_filetypes, ev.match) then
              vim.bo.indentexpr = [[%!v:lua.require('custom.utils-plugins.treesitter').indentexpr()]]
            end
          end

          -- folds
          if treesitter_utils.have(ev.match, "folds") then
            vim.wo.foldexpr = [[%!v:lua.require('custom.utils-plugins.treesitter').foldexpr()]]
          end
        end,
      })

      vim.treesitter.language.register("bash", "zsh")

      -- add toggle keymap for treesitter
      Snacks.toggle.treesitter():map "<leader>uT"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    enabled = not constants.in_vi_edit and not constants.in_kittyscrollback,
    branch = "main",
    event = "VeryLazy",
    opts = {},
    keys = function()
      local moves = {
        goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
        goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
        goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
      }
      local ret = {} ---@type LazyKeysSpec[]
      for method, keymaps in pairs(moves) do
        for key, query in pairs(keymaps) do
          local queries = type(query) == "table" and query or { query }
          local parts = {}
          for _, q in ipairs(queries) do
            local part = q:gsub("@", ""):gsub("%..*", "")
            part = part:sub(1, 1):upper() .. part:sub(2)
            table.insert(parts, part)
          end
          local desc = table.concat(parts, " or ")
          desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
          desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
          ret[#ret + 1] = {
            key,
            function()
              -- don't use treesitter if in diff mode and the key is one of the c/C keys
              if vim.wo.diff and key:find "[cC]" then
                return vim.cmd("normal! " .. key)
              end
              require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
            end,
            desc = desc,
            mode = { "n", "x", "o" },
            silent = true,
          }
        end
      end
      return ret
    end,
    config = function(_, opts)
      if lazy_utils.is_loaded "nvim-treesitter" then
        require("nvim-treesitter-textobjects").setup(opts)
      end
    end,
  },

  {
    -- fork introduces get_window_contexts fn
    "wochap/nvim-treesitter-context",
    event = "VeryLazy",
    keys = {
      {
        "gC",
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
    "windwp/nvim-ts-autotag",
    event = { "InsertEnter", "VeryLazy" },
    config = function()
      lazy_utils.on_load("nvim-treesitter", function()
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
