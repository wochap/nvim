local constants = require "custom.utils.constants"
local iconsUtils = require "custom.utils.icons"
local blinkCmpUtils = require "custom.utils-plugins.blink-cmp"
local keymapsUtils = require "custom.utils.keymaps"
local langUtils = require "custom.utils.lang"
local textCaseUtils = require "custom.utils-plugins.text-case"

return {
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
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
    event = "VeryLazy",
    opts = {},
  },

  {
    "echasnovski/mini.operators",
    event = "VeryLazy",
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
    event = "VeryLazy",
    keys = {
      {
        "gt.",
        textCaseUtils.openSelect,
        mode = { "n", "v" },
        desc = "Pick",
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
    -- PERF: runs very slow on nvim 0.11
    "saghen/blink.cmp",
    version = "v1.1.1",
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
      "L3MON4D3/LuaSnip",
      "dmitmel/cmp-cmdline-history",
    },
    opts = {
      enabled = function()
        local recording_macro = vim.fn.reg_recording() ~= "" or vim.fn.reg_executing() ~= ""
        return vim.bo.buftype ~= "prompt" and vim.b.completion ~= false and not recording_macro
      end,
      appearance = {
        kind_icons = iconsUtils.lsp_kind,
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
          winblend = vim.o.pumblend,
          min_width = 15,
          max_height = 15,
          border = "rounded",
          draw = {
            align_to = "label",
            gap = 2,
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "kind" },
            },
            components = {
              label = {
                width = { fill = true, max = 40 },
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
              local type = vim.fn.getcmdtype()
              if type == "/" or type == "?" then
                return { pos.screenpos.row - 1, pos.screenpos.col - 2 }
              end
              return { pos.screenpos.row, pos.screenpos.col - 1 }
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
          max_items = 100,
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            min_width = 15,
            max_height = 20,
            border = "rounded",
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
        enabled = true,
        trigger = {
          -- buggy
          show_on_insert = false,
        },
        window = {
          min_width = 15,
          max_height = 20,
          border = "rounded",
          -- TODO: fix scrollbar position
          -- scrollbar = true,
          treesitter_highlighting = true,
          show_documentation = true,
        },
      },
      sources = {
        defaults = {
          -- Dynamically picking providers by treesitter node/filetype
          function()
            if blinkCmpUtils.inside_comment_block() then
              return { "buffer" }
            end
            return nil
          end,
        },
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lsp = {
            -- if lsp takes more than 500ms then make it async
            timeout_ms = 500,
            score_offset = 0,
            fallbacks = {},
            opts = {
              tailwind_color_icon = iconsUtils.other.color,
            },
          },
          snippets = {
            max_items = 10,
            -- NOTE: kind doesn't exists in blink.cmp
            kind = "Snippet",
            score_offset = 0,
          },
          buffer = {
            max_items = 10,
            score_offset = -10,
          },
          path = {
            max_items = 10,
            score_offset = 20,
            fallbacks = {},
          },
          cmdline = {
            max_items = 10,
            score_offset = 0,
          },
          cmdline_history_cmd = {
            name = "cmdline_history",
            module = "blink.compat.source",
            max_items = 5,
            score_offset = -20,
            opts = {
              history_type = "cmd",
            },
            kind = "History",
          },
          cmdline_history_search = {
            name = "cmdline_history",
            module = "blink.compat.source",
            max_items = 5,
            score_offset = -20,
            opts = {
              history_type = "search",
            },
            kind = "History",
          },
        },
      },
      keymap = {
        preset = "none",
        ["<C-Space>"] = { "show" },
        ["<C-u>"] = {
          "scroll_documentation_up",
          function()
            return blinkCmpUtils.scroll_signature_up()
          end,
          "fallback",
        },
        ["<C-d>"] = {
          "scroll_documentation_down",
          function()
            return blinkCmpUtils.scroll_signature_down()
          end,
          "fallback",
        },
        ["<C-b>"] = {
          function(cmp)
            if not cmp.is_visible() then
              return
            end
            vim.schedule(function()
              blinkCmpUtils.select_next_idx(4, -1)
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
              blinkCmpUtils.select_next_idx(4)
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
        ["<C-e>"] = {
          function()
            return blinkCmpUtils.hide_signature()
          end,
          "cancel",
          "fallback",
        },
        ["<C-y>"] = {
          function()
            -- insert undo breakpoint
            keymapsUtils.run_expr "<C-g>u"
          end,
          "select_and_accept",
        },
      },
      cmdline = {
        sources = function()
          local type = vim.fn.getcmdtype()
          -- Search forward and backward
          if type == "/" or type == "?" then
            return { "buffer", "cmdline_history_search" }
          end
          -- Commands
          if type == ":" or type == "@" then
            return { "cmdline", "cmdline_history_cmd" }
          end
          return {}
        end,
        keymap = {
          preset = "none",
          ["<C-Space>"] = { "show" },
          ["<C-b>"] = {
            function(cmp)
              if not cmp.is_visible() then
                return
              end
              vim.schedule(function()
                blinkCmpUtils.select_next_idx(4, -1)
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
                blinkCmpUtils.select_next_idx(4)
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
        completion = {
          menu = {
            auto_show = true,
            draw = {
              -- gap = 2,
              columns = {
                { "kind_icon" },
                { "label", "label_description", gap = 1 },
                { "kind" },
              },
            },
          },
          list = {
            selection = {
              preselect = false,
              auto_insert = true,
            },
          },
          ghost_text = {
            enabled = false,
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
        opts.sources.default = function()
          for _, func in ipairs(defaults) do
            local result = func(originalDefault)
            if result ~= nil then
              return result
            end
          end
          return originalDefault
        end
        -- Unset custom prop
        opts.sources.defaults = nil
      end

      -- check for enableds
      if opts.enableds then
        local enableds = opts.enableds
        local originalEnabled = opts.enabled
        opts.enabled = function()
          for _, func in ipairs(enableds) do
            local result = func()
            if result ~= nil then
              return result
            end
          end
          return originalEnabled()
        end
        -- Unset custom prop
        opts.enableds = nil
      end

      require("blink.cmp").setup(opts)
    end,
  },

  -- uncomment to use native snippets
  -- {
  --   "saghen/blink.cmp",
  --   optional = true,
  --   opts = {
  --     snippets = {
  --       expand = function(snippet, _)
  --         return LazyVim.cmp.expand(snippet)
  --       end,
  --     },
  --     sources = {
  --       providers = {
  --         snippets = {
  --           opts = {
  --             search_paths = {
  --               vim.fn.stdpath "config" .. "/snippets",
  --               vim.fn.stdpath "data" .. "/lazy/EmmetJSS",
  --             },
  --             friendly_snippets = false,
  --             get_filetype = function(ctx)
  --               -- TODO: get filetype from cursor position
  --               -- local filetypes = require("luasnip.extras.filetype_functions").from_pos_or_filetype()
  --               -- if #filetypes > 0 then
  --               --   return filetypes[1]
  --               -- end
  --               return vim.bo.filetype
  --             end,
  --           },
  --         },
  --       },
  --     },
  --     keymap = {
  --       ["<C-k>"] = { "select_and_accept" },
  --       ["<Tab>"] = { "snippet_forward", "fallback" },
  --       ["<S-Tab>"] = { "snippet_backward" },
  --     },
  --   },
  -- },

  {
    "L3MON4D3/LuaSnip",
    event = { "InsertEnter", "VeryLazy" },
    version = "v2.*",
    build = "make install_jsregexp",
    keys = {
      {
        "<Tab>",
        function()
          local luasnip = require "luasnip"
          if luasnip.jumpable(1) then
            luasnip.jump(1)
          else
            keymapsUtils.run_expr "<Tab>"
          end
        end,
        desc = "Snippet Forward",
        mode = "i",
      },
      {
        "<Tab>",
        function()
          require("luasnip").jump(1)
        end,
        desc = "Snippet Forward",
        mode = "s",
      },
      {
        "<S-Tab>",
        function()
          require("luasnip").jump(-1)
        end,
        desc = "Snippet Backward",
        mode = { "i", "s" },
      },
      {
        "<C-k>",
        function()
          local luasnip = require "luasnip"
          if luasnip.choice_active() then
            luasnip.change_choice(1)
            return
          end
          -- insert undo breakpoint
          keymapsUtils.run_expr "<C-g>u"

          vim.schedule(function()
            require("luasnip").expand()
          end)
        end,
        desc = "Expand Snippet Or Next Choice",
        mode = "i",
      },
      {
        "<C-S-k>",
        function()
          local luasnip = require "luasnip"
          if luasnip.choice_active() then
            luasnip.change_choice(-1)
          end
        end,
        desc = "Prev Choice",
        mode = "i",
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
      -- Show snippets related to the language
      -- in the current cursor position
      ft_func = function()
        local filetypes = require("luasnip.extras.filetype_functions").from_pos_or_filetype()
        if vim.tbl_contains(filetypes, "markdown_inline") then
          -- HACK: fix markdown snippets not being expanded
          return { "markdown" }
        end
        return filetypes
      end,
      -- for lazy load snippets for given buffer
      load_ft_func = function(...)
        return require("luasnip.extras.filetype_functions").extend_load_ft {
          -- TODO: add injected filetypes for each filetype
          markdown = { "javascript", "json" },
        }(...)
      end,
    },
    config = function(_, opts)
      require("luasnip").setup(opts)

      -- load snippets in nvim config folder
      -- NOTE: when using sync `load`, entries are duplicated in blink.cmp
      -- lazy_load doesn't work on nvim 0.11
      -- require("luasnip.loaders.from_vscode").load {
      require("luasnip.loaders.from_vscode").lazy_load {
        paths = vim.fn.stdpath "config" .. "/snippets",
      }
    end,
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      snippets = {
        preset = "luasnip",
      },
    },
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
        "<C-leftdrag>",
        function()
          local mc = require "multicursor-nvim"
          mc.handleMouseDrag()
        end,
        desc = "Drag",
        mode = "n",
      },
      {
        "<C-leftrelease>",
        function()
          local mc = require "multicursor-nvim"
          mc.handleMouseRelease()
        end,
        desc = "Release",
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
        "<leader>ce",
        function()
          local mc = require "multicursor-nvim"
          mc.searchAllAddCursors()
        end,
        desc = "Add To All Search",
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
        "<leader>cd",
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
        "<leader>cm",
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
        "<leader>ct",
        function()
          local mc = require "multicursor-nvim"
          mc.transposeCursors(1)
        end,
        desc = "Rotate Next",
        mode = "v",
      },
      {
        "<leader>cT",
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
    "gbprod/yanky.nvim",
    keys = {
      {
        "p",
        "<Plug>(YankyPutAfter)",
        mode = { "n", "x" },
        desc = "Paste After Cursor",
      },
      {
        "P",
        "<Plug>(YankyPutBefore)",
        mode = { "n", "x" },
        desc = "Paste Before Cursor",
      },
      {
        "=p",
        "<Plug>(YankyPutAfterLinewise)",
        desc = "Paste In Line Below",
      },
      {
        "=P",
        "<Plug>(YankyPutBeforeLinewise)",
        desc = "Paste In Line Above",
      },
      {
        "[y",
        "<Plug>(YankyCycleForward)",
        desc = "Cycle Forward Through Yank History",
      },
      {
        "]y",
        "<Plug>(YankyCycleBackward)",
        desc = "Cycle Backward Through Yank History",
      },
      -- TODO: disable when in multicursor
      {
        "y",
        "<Plug>(YankyYank)",
        mode = { "n", "x" },
        desc = "Yanky Yank",
      },
    },
    opts = {
      ring = {
        history_length = 20,
      },
      highlight = {
        timer = 100,
      },
    },
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
    opts = {
      filetype_exclude = langUtils.list_merge(constants.exclude_filetypes, {
        "diff",
      }),
      buftype_exclude = constants.exclude_buftypes,
    },
  },
}
