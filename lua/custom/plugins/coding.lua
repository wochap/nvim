local lazyUtils = require "custom.utils.lazy"
local iconsUtils = require "custom.utils.icons"
local cmpUtils = require "custom.utils-plugins.cmp"

return {
  {
    "echasnovski/mini.surround",
    event = { "LazyFile", "VeryLazy" },
    opts = {
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`

        suffix_last = "l", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
      },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "gs", group = "surround" },
      },
    },
  },

  -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-align.md
  -- ga or gA
  {
    "echasnovski/mini.align",
    event = { "LazyFile", "VeryLazy" },
    opts = {},
  },

  {
    "echasnovski/mini.operators",
    event = { "LazyFile", "VeryLazy" },
    opts = {
      evaluate = {
        prefix = "",
      },
      exchange = {
        prefix = "gx",
        reindent_linewise = false,
      },
      multiply = {
        prefix = "",
      },
      replace = {
        prefix = "",
      },
      sort = {
        prefix = "gS",
        reindent_linewise = false,
      },
    },
  },

  {
    "echasnovski/mini.move",
    event = { "LazyFile", "VeryLazy" },
    opts = {
      mappings = {
        left = "<A-Left>",
        right = "<A-Right>",
        down = "<A-Down>",
        up = "<A-Up>",
        line_left = "<A-Left>",
        line_right = "<A-Right>",
        line_down = "<A-Down>",
        line_up = "<A-Up>",
      },
      options = {
        reindent_linewise = false,
      },
    },
  },

  -- Better text-objects
  {
    "echasnovski/mini.ai",
    event = { "LazyFile", "VeryLazy" },
    opts = function()
      local ai = require "mini.ai"
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter { -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          },
          f = ai.gen_spec.treesitter { a = "@function.outer", i = "@function.inner" }, -- function
          c = ai.gen_spec.treesitter { a = "@class.outer", i = "@class.inner" }, -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          g = LazyVim.mini.ai_buffer, -- buffer
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call { name_pattern = "[%w_]" }, -- without dot in function name
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      LazyVim.on_load("which-key.nvim", function()
        vim.schedule(function()
          LazyVim.mini.ai_whichkey(opts)
        end)
      end)
    end,
  },

  {
    "johmsalas/text-case.nvim",
    event = { "LazyFile", "VeryLazy" },
    keys = {
      {
        "gt.",
        "<cmd>TextCaseOpenTelescope<CR>",
        mode = { "n", "v" },
        desc = "Pick (Telescope)",
      },
    },
    opts = {
      prefix = "gt",
      enabled_methods = {
        "to_snake_case",
        "to_dash_case",
        "to_constant_case",
        "to_camel_case",
        "to_pascal_case",
        "to_title_case",
      },
    },
    config = function(_, opts)
      require("textcase").setup(opts)

      -- create alias for dash-case
      local to_kebab_case = require("textcase.shared.utils").create_wrapped_method(
        "to_dash_case",
        require("textcase.conversions.stringcase").to_dash_case,
        "to-kebab-case"
      )
      local to_title_case = require("textcase.plugin.api").to_title_case
      require("textcase.plugin.plugin").register_keybindings(opts.prefix, to_kebab_case, {
        prefix = opts.prefix,
        quick_replace = "k",
        operator = "ok",
        lsp_rename = "K",
      })

      -- setup Title Case keymap
      require("textcase.plugin.plugin").register_keybindings(opts.prefix, to_title_case, {
        prefix = opts.prefix,
        quick_replace = "t",
        operator = "ot",
        lsp_rename = "T",
      })

      lazyUtils.on_load("telescope.nvim", function()
        require("telescope").load_extension "textcase"
      end)
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    enabled = false,
  },
  {
    -- hrsh7th/nvim-cmp fork
    "iguanacucumber/magazine.nvim",
    enabled = false,
  },
  {
    "saghen/blink.cmp",
    version = "v0.9.3",
    event = { "InsertEnter", "VeryLazy" },
    dependencies = {
      {
        "saghen/blink.compat",
        opts = {},
      },
      {
        "carbonid1/EmmetJSS",
        opts = {},
        config = function() end,
      },
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        opts = {},
        config = function() end,
      },
      "dmitmel/cmp-cmdline-history",
    },
    opts = {
      enabled = function()
        local recording_macro = vim.fn.reg_recording() ~= "" or vim.fn.reg_executing() ~= ""
        return vim.bo.buftype ~= "prompt" and vim.b.completion ~= false and not recording_macro
      end,
      snippets = {
        expand = function(snippet, _)
          return LazyVim.cmp.expand(snippet)
        end,
      },
      appearance = {
        kind_icons = iconsUtils.lspkind,
        use_nvim_cmp_as_default = false,
        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },
      completion = {
        keyword = {
          -- will fuzzy match on the text before the cursor
          range = "prefix",
        },
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          winblend = 5,
          min_width = 15,
          max_height = 15,
          border = cmpUtils.border "BlinkCmpMenuBorder",
          auto_show = function(ctx)
            -- Don't show completion menu automatically in cmdline mode and when searching
            return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
          end,
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind", gap = 1 },
            },
            components = {
              label = {
                highlight = function(ctx)
                  -- label and label details
                  local highlights = {
                    { 0, #ctx.label, group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel" },
                  }
                  if ctx.label_detail then
                    table.insert(
                      highlights,
                      { #ctx.label, #ctx.label + #ctx.label_detail, group = "BlinkCmpLabelDetail" }
                    )
                  end
                  -- characters matched on the label by the fuzzy matcher
                  for _, idx in ipairs(ctx.label_matched_indices) do
                    table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                  end
                  return highlights
                end,
              },
            },
            -- highlight lsp source with treesitter
            treesitter = { "lsp" },
          },
          -- Screen coordinates of the command line
          cmdline_position = function()
            if LazyVim.has "noice.nvim" then
              local Api = require "noice.api"
              local pos = Api.get_cmdline_position()
              return { pos.screenpos.row - 1, pos.screenpos.col - 2 }
            end
            if vim.g.ui_cmdline_pos ~= nil then
              local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
              return { pos[1] - 1, pos[2] }
            end
            local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
            return { vim.o.lines - height, 0 }
          end,
        },
        list = {
          selection = "auto_insert",
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            min_width = 15,
            max_height = 20,
            border = cmpUtils.border "BlinkCmpDocBorder",
          },
          -- NOTE: improve perf
          -- treesitter_highlighting = false,
        },
        ghost_text = {
          enabled = true,
        },
      },
      -- experimental signature help support
      signature = {
        enabled = false,
      },
      sources = {
        -- Dynamically picking providers by treesitter node/filetype
        default = function()
          local success, node = pcall(vim.treesitter.get_node)
          if success and node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
            return { "buffer" }
          end
          return { "lazydev", "lsp", "path", "snippets", "buffer" }
        end,
        cmdline = function()
          local type = vim.fn.getcmdtype()
          -- Search forward and backward
          if type == "/" or type == "?" then
            return { "buffer" }
          end
          -- Commands
          if type == ":" or type == "@" then
            return { "cmdline_history", "cmdline" }
          end
          return {}
        end,
        providers = {
          snippets = {
            max_items = 10,
            -- NOTE: kind doesn't exists in blink.cmp
            kind = "Snippet",
            opts = {
              search_paths = {
                vim.fn.stdpath "config" .. "/snippets",
                vim.fn.stdpath "data" .. "/lazy/EmmetJSS",
              },
              friendly_snippets = false,
              get_filetype = function(ctx)
                -- TODO: get filetype from cursor position
                -- local filetypes = require("luasnip.extras.filetype_functions").from_pos_or_filetype()
                -- if #filetypes > 0 then
                --   return filetypes[1]
                -- end
                return vim.bo.filetype
              end,
            },
          },
          buffer = {
            max_items = 10,
            score_offset = -1,
          },
          path = {
            max_items = 10,
          },
          cmdline = {
            max_items = 10,
          },
          cmdline_history = {
            name = "cmdline_history",
            module = "blink.compat.source",
          },
        },
      },
      keymap = {
        preset = "none",
        ["<C-Space>"] = { "show" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-b>"] = {
          function(cmp)
            if not cmp.is_visible() then
              return
            end
            vim.schedule(function()
              cmpUtils.select_next_idx(4, -1)
            end)
            return true
          end,
          "fallback",
        },
        ["<C-f>"] = {
          function(cmp)
            if not cmp.is_visible() then
              return
            end
            vim.schedule(function()
              cmpUtils.select_next_idx(4)
            end)
            return true
          end,
          "fallback",
        },
        ["<C-p>"] = {
          function(cmp)
            if not cmp.is_visible() then
              cmp.show()
              return
            end
            cmp.select_prev()
          end,
        },
        ["<C-n>"] = {
          function(cmp)
            if not cmp.is_visible() then
              cmp.show()
              return
            end
            cmp.select_next()
          end,
        },
        ["<C-e>"] = { "cancel", "fallback" },
        ["<C-y>"] = { "select_and_accept" },
        ["<C-k>"] = { "select_and_accept" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        cmdline = {
          ["<C-Space>"] = { "show" },
          ["<C-b>"] = {
            function(cmp)
              if not cmp.is_visible() then
                return
              end
              vim.schedule(function()
                cmpUtils.select_next_idx(4, -1)
              end)
              return true
            end,
            "fallback",
          },
          ["<C-f>"] = {
            function(cmp)
              if not cmp.is_visible() then
                return
              end
              vim.schedule(function()
                cmpUtils.select_next_idx(4)
              end)
              return true
            end,
            "fallback",
          },
          ["<C-p>"] = {
            function(cmp)
              if not cmp.is_visible() then
                cmp.show()
                return
              end
              cmp.select_prev()
            end,
          },
          ["<C-n>"] = {
            function(cmp)
              if not cmp.is_visible() then
                cmp.show()
                return
              end
              cmp.select_next()
            end,
          },
          ["<C-e>"] = { "cancel", "fallback" },
          ["<C-y>"] = { "select_and_accept" },
          ["<C-S-y>"] = {
            function()
              vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "")
            end,
          },
          ["<Tab>"] = {
            function(cmp)
              if not cmp.is_visible() then
                cmp.show()
                return
              end
              cmp.select_next()
            end,
          },
          ["<S-Tab>"] = {
            function(cmp)
              if not cmp.is_visible() then
                cmp.show()
                return
              end
              cmp.select_prev()
            end,
          },
        },
      },
    },
    config = function(_, opts)
      -- check if we need to override symbol kinds
      for _, provider in pairs(opts.sources.providers or {}) do
        if provider.kind then
          local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
          local kind_idx = #CompletionItemKind + 1
          CompletionItemKind[kind_idx] = provider.kind
          CompletionItemKind[provider.kind] = kind_idx
          local transform_items = provider.transform_items
          provider.transform_items = function(ctx, items)
            items = transform_items and transform_items(ctx, items) or items
            for _, item in ipairs(items) do
              item.kind = kind_idx or item.kind
            end
            return items
          end
          -- Unset custom prop to pass blink.cmp validation
          provider.kind = nil
        end
      end

      -- check for sources.defaults
      if opts.sources.defaults then
        local defaults = opts.sources.defaults
        local originalDefault = opts.sources.default
        table.insert(defaults, originalDefault)
        opts.sources.default = function()
          for _, func in ipairs(defaults) do
            local result = func()
            if result ~= nil then
              return result
            end
          end
        end
        -- Unset custom prop
        opts.sources.defaults = nil
      end

      -- check for enableds
      if opts.enableds then
        local enableds = opts.enableds
        local originalEnabled = opts.enabled
        table.insert(enableds, originalEnabled)
        opts.enabled = function()
          for _, func in ipairs(enableds) do
            local result = func()
            if result ~= nil then
              return result
            end
          end
        end
        -- Unset custom prop
        opts.enableds = nil
      end

      require("blink.cmp").setup(opts)
    end,
  },

  -- auto pairs
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = {
        insert = true,
        command = false,
        terminal = false,
      },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string", "comment" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
    config = function(_, opts)
      LazyVim.mini.pairs(opts)
    end,
  },

  -- comments
  {
    "folke/ts-comments.nvim",
    event = { "LazyFile", "VeryLazy" },
    keys = {
      {
        "<leader>/",
        function()
          vim.cmd.norm "gcc"
        end,
        desc = "Comment", -- toggle
        mode = "n",
      },
      {
        "<leader>/",
        function()
          vim.cmd.norm "gc"
        end,
        desc = "Comment", -- toggle
        mode = "v",
      },
    },
    opts = {},
  },

  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    keys = {
      {
        "<leader>c",
        "",
        desc = "multicursor",
        mode = { "n", "v" },
      },

      {
        "<C-leftmouse>",
        function()
          local mc = require "multicursor-nvim"
          mc.handleMouse()
        end,
        desc = "Toggle",
        mode = "n",
      },
      {
        "<leader>c<Up>",
        function()
          local mc = require "multicursor-nvim"
          mc.lineAddCursor(-1)
        end,
        desc = "Add Above",
        mode = { "n", "v" },
      },
      {
        "<leader>c<Down>",
        function()
          local mc = require "multicursor-nvim"
          mc.lineAddCursor(1)
        end,
        desc = "Add Below",
        mode = { "n", "v" },
      },
      {
        "<leader>cn",
        function()
          local mc = require "multicursor-nvim"
          mc.matchAddCursor(1)
        end,
        desc = "Add And Jump To Next Word",
        mode = { "n", "v" },
      },
      {
        "<leader>cN",
        function()
          local mc = require "multicursor-nvim"
          mc.matchAddCursor(-1)
        end,
        desc = "Add And Jump To Prev Word",
        mode = { "n", "v" },
      },
      {
        "<leader>cs",
        function()
          local mc = require "multicursor-nvim"
          mc.matchSkipCursor(1)
        end,
        desc = "Skip And Jump To Next Word",
        mode = { "n", "v" },
      },
      {
        "<leader>cS",
        function()
          local mc = require "multicursor-nvim"
          mc.matchSkipCursor(-1)
        end,
        desc = "Skip And Jump To Prev Word",
        mode = { "n", "v" },
      },
      {
        "<leader>c*",
        function()
          local mc = require "multicursor-nvim"
          mc.matchAllAddCursors()
        end,
        desc = "Add To All Words",
        mode = { "n", "v" },
      },
      {
        "<leader>c<Right>",
        function()
          local mc = require "multicursor-nvim"
          mc.nextCursor()
        end,
        desc = "Next",
        mode = { "n", "v" },
      },
      {
        "<leader>c<Left>",
        function()
          local mc = require "multicursor-nvim"
          mc.prevCursor()
        end,
        desc = "Prev",
        mode = { "n", "v" },
      },
      {
        "<leader>cx",
        function()
          local mc = require "multicursor-nvim"
          mc.deleteCursor()
        end,
        desc = "Delete",
        mode = { "n", "v" },
      },
      {
        "<leader>cq",
        function()
          local mc = require "multicursor-nvim"
          if mc.cursorsEnabled() then
            -- Stop other cursors from moving.
            -- This allows you to reposition the main cursor.
            mc.disableCursors()
          else
            mc.addCursor()
          end
        end,
        desc = "Stop Other Or Add",
        mode = { "n", "v" },
      },
      {
        "<leader>c<Esc>",
        function()
          local mc = require "multicursor-nvim"
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          elseif mc.hasCursors() then
            mc.clearCursors()
          else
            -- Default <esc> handler.
          end
        end,
        desc = "Start Other Or Clear",
        mode = "n",
      },
      {
        "<leader>cr",
        function()
          local mc = require "multicursor-nvim"
          mc.restoreCursors()
        end,
        desc = "Restore",
        mode = "n",
      },
      {
        "<leader>ct",
        function()
          local mc = require "multicursor-nvim"
          mc.toggleCursor()
        end,
        desc = "Toggle",
        mode = "n",
      },
      {
        "<leader>ca",
        function()
          local mc = require "multicursor-nvim"
          if mc.cursorsEnabled() then
            mc.alignCursors()
          else
            LazyVim.error("Cursors are disabled", { title = "multicursor.nvim" })
          end
        end,
        desc = "Align Columns",
        mode = "n",
      },
      {
        "<leader>cS",
        function()
          local mc = require "multicursor-nvim"
          mc.splitCursors()
        end,
        desc = "Split By Regex",
        mode = "v",
      },
      {
        "<leader>cM",
        function()
          local mc = require "multicursor-nvim"
          mc.matchCursors()
        end,
        desc = "Match By Regex",
        mode = "v",
      },
      {
        "I",
        function()
          local mc = require "multicursor-nvim"
          mc.insertVisual()
        end,
        desc = "Insert",
        mode = "v",
      },
      {
        "A",
        function()
          local mc = require "multicursor-nvim"
          mc.appendVisual()
        end,
        desc = "Append",
        mode = "v",
      },
      {
        "<leader>cr",
        function()
          local mc = require "multicursor-nvim"
          mc.transposeCursors(1)
        end,
        desc = "Rotate Next",
        mode = "v",
      },
      {
        "<leader>cR",
        function()
          local mc = require "multicursor-nvim"
          mc.transposeCursors(-1)
        end,
        desc = "Rotate Prev",
        mode = "v",
      },
    },
    opts = {},
  },

  {
    "monkoose/matchparen.nvim",
    event = { "LazyFile", "VeryLazy" },
    opts = {
      debounce_time = 50,
    },
  },

  {
    "NMAC427/guess-indent.nvim",
    event = { "LazyFile", "VeryLazy" },
    opts = {},
  },
}
