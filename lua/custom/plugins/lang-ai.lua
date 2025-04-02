local lazyUtils = require "custom.utils.lazy"
local utils = require "custom.utils"

return {
  {
    -- NOTE: run CopilotAuth
    "zbirenbaum/copilot.lua",
    enabled = false,
    event = "VeryLazy",
    opts = {},
  },

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "echasnovski/mini.icons",
    },
    keys = function(_, keys)
      local opts =
        require("lazy.core.plugin").values(require("lazy.core.config").spec.plugins["avante.nvim"], "opts", false)
      return {
        {
          "<leader>a",
          "",
          desc = "avante",
          mode = { "n", "v" },
        },

        {
          "<leader>aC",
          "<cmd>AvanteClear<CR>",
          desc = "Clear",
        },
        {
          opts.mappings.ask,
          function()
            if not require("avante").is_sidebar_open() then
              utils.close_sidebars "avante"
            end
            vim.schedule(function()
              if require("avante").is_sidebar_open() and require("avante.utils").is_sidebar_buffer(0) then
                return
              end
              require("avante.api").focus()
            end)
          end,
          desc = "Ask",
          mode = { "n", "v" },
        },
        {
          opts.mappings.refresh,
          function()
            require("avante.api").refresh()
          end,
          desc = "Refresh",
          mode = "n",
        },
        {
          opts.mappings.edit,
          function()
            require("avante.api").edit()
          end,
          desc = "Edit",
          mode = "v",
        },
        {
          opts.mappings.toggle.default,
          function()
            if not require("avante").is_sidebar_open() then
              utils.close_sidebars "avante"
            end
            vim.schedule(function()
              if require("avante").is_sidebar_open() then
                require("avante").close_sidebar()
              else
                require("avante.api").focus()
              end
            end)
          end,
          desc = "Toggle",
        },
      }
    end,
    init = function()
      utils.autocmd("FileType", {
        group = utils.augroup "close_avante_with_q",
        pattern = {
          "Avante",
          "AvanteInput",
          "AvanteSelectedFiles",
        },
        callback = function(event)
          vim.keymap.set("n", "q", function()
            require("avante").close_sidebar()
          end, { buffer = event.buf, silent = true })
        end,
      })
    end,
    opts = {
      provider = "deepseek_chat",
      auto_suggestions_provider = "copilot",
      vendors = {
        deepseek_coder = {
          __inherited_from = "openai",
          disable_tools = true,
          api_key_name = "cmd:bat --plain " .. vim.env.HOME .. "/.config/secrets/deepseek/gean.marroquin@gmail.com",
          endpoint = "https://api.deepseek.com/v1",
          model = "deepseek-coder",
          timeout = 30000, -- 30s
          temperature = 0,
          max_tokens = 4096,
        },
        deepseek_chat = {
          __inherited_from = "openai",
          disable_tools = true,
          api_key_name = "cmd:bat --plain " .. vim.env.HOME .. "/.config/secrets/deepseek/gean.marroquin@gmail.com",
          endpoint = "https://api.deepseek.com/v1",
          model = "deepseek-chat",
          timeout = 30000, -- 30s
          temperature = 0,
          max_tokens = 4096,
        },
        deepseek_r1 = {
          __inherited_from = "openai",
          disable_tools = true,
          api_key_name = "cmd:bat --plain " .. vim.env.HOME .. "/.config/secrets/deepseek/gean.marroquin@gmail.com",
          endpoint = "https://api.deepseek.com/v1",
          model = "deepseek-reasoner",
          timeout = 30000, -- 30s
          temperature = 0,
          max_tokens = 4096,
        },
      },
      behaviour = {
        auto_focus_sidebar = false,
        auto_suggestions = false,
      },
      highlights = {
        diff = {
          current = "DiffText",
          incoming = "DiffAdd",
        },
      },
      mappings = {
        diff = {
          ours = "<leader>aco",
          theirs = "<leader>act",
          all_theirs = "<leader>acT",
          both = "<leader>acb",
          cursor = "<leader>acc",
          next = "]c",
          prev = "[c",
        },
        suggestion = {
          accept = "<A-y>",
          next = "<A-n>",
          prev = "<A-p>",
          dismiss = "<A-e>",
        },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        -- NOTE: The following will be safely set by avante.nvim
        ask = "<leader>aa",
        edit = "<leader>ae",
        refresh = "<leader>ar",
        focus = "<leader>af",
        toggle = {
          default = "<leader>at",
          debug = "<leader>aTd",
          hint = "<leader>aTh",
          suggestion = "<leader>aTs",
          repomap = "<leader>aTr",
        },
        sidebar = {
          apply_all = "A",
          apply_cursor = "a",
          switch_windows = "<Tab>",
          reverse_switch_windows = "<S-Tab>",
          remove_file = "d",
          add_file = "@",
          close = {},
        },
        files = {
          add_current = "<leader>aA", -- Add current buffer to selected files
        },
      },
      windows = {
        wrap = true,
        width = 50,
        sidebar_header = {
          enabled = false,
        },
        input = {
          prefix = "❯ ",
          height = 8, -- Height of the input window in vertical layout
        },
        edit = {
          start_insert = true,
        },
        ask = {
          start_insert = false,
        },
      },
      hints = {
        enabled = false,
      },
      repo_map = {
        ignore_patterns = { "%.git", "%.worktree", "__pycache__", "node_modules", "%.direnv" },
      },
      file_selector = {
        provider = "snacks",
      },
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      sources = {
        defaults = {
          function()
            local filetype = vim.api.nvim_buf_get_option(0, "filetype")
            local has_avante_load = lazyUtils.is_loaded "avante.nvim"
            if has_avante_load then
              if filetype == "AvanteInput" then
                return { "buffer", "avante_commands", "avante_mentions", "avante_files" }
              end
            end
            return nil
          end,
        },
        providers = {
          avante_commands = {
            name = "avante_commands",
            module = "blink.compat.source",
            score_offset = 90,
            opts = {},
            kind = "Avante",
          },
          avante_files = {
            name = "avante_commands",
            module = "blink.compat.source",
            score_offset = 100,
            opts = {},
            kind = "Avante",
          },
          avante_mentions = {
            name = "avante_mentions",
            module = "blink.compat.source",
            score_offset = 1000,
            opts = {},
            kind = "Avante",
          },
        },
      },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = { { "<leader>ac", group = "conflict" } },
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    opts = {
      file_types = { "Avante" },
      overrides = {
        filetype = {
          Avante = {
            enabled = true,
          },
        },
      },
    },
  },
}
