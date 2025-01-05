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
    event = { "CmdlineEnter", "InsertEnter", "VeryLazy" },
    version = false, -- last release is way too old
    main = "lazyvim.util.cmp",
    dependencies = {
      -- cmp sources plugins
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "dmitmel/cmp-cmdline-history",
    },
    opts_extend = { "sources" },
    opts = function(_, opts)
      local cmp = require "cmp"
      local defaults = require "cmp.config.default"()
      return {
        enabled = function()
          local cmp_ctx = require "cmp.config.context"
          if
            -- disable when recording a macro
            (vim.fn.reg_recording() ~= "")
            or (vim.fn.reg_executing() ~= "")
            -- disable in comments
            or (cmp_ctx.in_treesitter_capture "comment" == true)
            or (cmp_ctx.in_syntax_group "comment" == true)
          then
            return false
          end

          local has_cmp_dap_load = lazyUtils.is_loaded "cmp-dap"
          if has_cmp_dap_load then
            local cmp_dap = require "cmp_dap"
            -- enable if in dap buffer
            if cmp_dap.is_dap_buffer() then
              return true
            end
          end

          return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
        end,
        preselect = cmp.PreselectMode.None,
        completion = {
          completeopt = "menu,menuone,noinsert,noselect,fuzzy",
        },
        window = {
          completion = {
            -- NOTE: changing border breaks scrollbar UI
            border = cmpUtils.border "CmpBorder",
            side_padding = 1,
            winhighlight = "Normal:Pmenu,FloatBorder:CmpBorder,CursorLine:CmpSel,Search:None",
            scrollbar = true,
          },
          documentation = {
            border = cmpUtils.border "CmpDocBorder",
            winhighlight = "Normal:CmpDoc,FloatBorder:CmpDocBorder,Search:None",
          },
        },
        view = {
          entries = {
            follow_cursor = true,
          },
        },
        formatting = {
          fields = { "abbr", "kind", "menu" },
          format = function(entry, item)
            if opts and opts.formatting and opts.formatting.format then
              opts.formatting.format(entry, item)
            end

            local color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })
            local icon = iconsUtils.lspkind[item.kind] or " "
            item.kind = string.format(" %s %s", icon, item.kind)
            -- apply nvim-highlight-colors
            if color_item.abbr_hl_group then
              item.kind_hl_group = color_item.abbr_hl_group
              item.kind = string.format(" %s %s", color_item.abbr, item.kind)
            end
            -- limit str length
            if string.len(item.abbr) > 60 then
              item.abbr = string.format("%s…", string.sub(item.abbr, 1, 60))
            end
            if item.menu and string.len(item.menu) > 20 then
              item.menu = string.format("%s… ", string.sub(item.abbr, 1, 20))
            end
            return item
          end,
        },
        mapping = {
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-b>"] = cmpUtils.scroll(-4),
          ["<C-f>"] = cmpUtils.scroll(4),
          ["<C-n>"] = cmpUtils.select_next_item,
          ["<C-p>"] = cmpUtils.select_prev_item,
          ["<C-e>"] = cmp.mapping.abort(),

          -- lazyvim has a better cmp.confirm
          ["<C-y>"] = function(...)
            require("lazyvim.util.cmp").confirm {
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            }(...)
          end,

          -- close cmp menu on movements
          ["<Up>"] = function(fallback)
            cmpUtils.async_cmp_close_tl()
            fallback()
          end,
          ["<Down>"] = function(fallback)
            cmpUtils.async_cmp_close_tl()
            fallback()
          end,
          ["<Left>"] = function(fallback)
            cmpUtils.async_cmp_close_tl()
            fallback()
          end,
          ["<Right>"] = function(fallback)
            cmpUtils.async_cmp_close_tl()
            fallback()
          end,
          ["<CR>"] = function(fallback)
            cmpUtils.async_cmp_close_tl()
            fallback()
          end,
        },
        sources = {
          { name = "path", max_item_count = 10, group_index = 1 },
          { name = "nvim_lsp", max_item_count = 25, group_index = 1 },
          {
            name = "buffer",
            max_item_count = 10,
            group_index = 99,
            option = {
              -- visible buffers
              get_bufnrs = function()
                local bufs = {}
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                  bufs[vim.api.nvim_win_get_buf(win)] = true
                end
                return vim.tbl_keys(bufs)
              end,
            },
          },
        },
        experimental = {
          ghost_text = false,
          native_menu = false,
        },
        sorting = defaults.sorting,
      }
    end,
    config = function(_, opts)
      local cmp = require "cmp"
      local cmdlineMapping = {
        ["<C-Space>"] = {
          c = cmp.mapping.complete(),
        },
        ["<C-n>"] = {
          c = cmpUtils.select_next_item,
        },
        ["<C-p>"] = {
          c = cmpUtils.select_prev_item,
        },
        ["<C-e>"] = {
          c = cmp.mapping.abort(),
        },
        ["<C-y>"] = {
          c = function(...)
            require("lazyvim.util.cmp").confirm {
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            }(...)
          end,
        },
        ["<C-S-y>"] = {
          c = function(fallback)
            if cmp.core.view:visible() or vim.fn.pumvisible() == 1 then
              cmp.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
              }, function()
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "")
              end)
            end
          end,
        },
        ["<Tab>"] = {
          c = cmpUtils.select_next_item,
        },
        ["<S-Tab>"] = {
          c = cmpUtils.select_prev_item,
        },
      }

      cmp.setup(opts)
      -- TODO: cmdline on / and ? causes that
      -- arrow up and down don't work as expected
      -- cmp.setup.cmdline({ "/", "?" }, {
      --   mapping = cmdlineMapping,
      --   sources = {
      --     { name = "cmdline_history", max_item_count = 10 },
      --     { name = "buffer", max_item_count = 10 },
      --   },
      -- })

      cmp.setup.cmdline(":", {
        mapping = cmdlineMapping,
        sources = {
          { name = "cmdline", max_item_count = 10 },
          { name = "cmdline_history", max_item_count = 10 },
          { name = "path", max_item_count = 10 },
          { name = "nvim_lua", max_item_count = 10 },
        },
      })
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    event = { "InsertEnter", "VeryLazy" },
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
      {
        "carbonid1/EmmetJSS",
        config = function()
          local plugin_path = vim.fn.stdpath "data" .. "/lazy/EmmetJSS"
          require("luasnip.loaders.from_vscode").load { paths = plugin_path }
        end,
      },
    },
    keys = {
      {
        "<C-k>",
        "<cmd>lua require'luasnip'.expand()<CR>",
        desc = "Expand Snippet",
        mode = "i",
      },
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
      -- Show snippets related to the language
      -- in the current cursor position
      ft_func = function()
        return require("luasnip.extras.filetype_functions").from_pos_or_filetype()
      end,
    },
    config = function(_, opts)
      local luasnip = require "luasnip"
      luasnip.setup(opts)

      -- load snippets in nvim config folder
      require("luasnip.loaders.from_vscode").load {
        paths = vim.fn.stdpath "config" .. "/snippets",
      }

      -- clear luasnip on InsertLeave
      vim.api.nvim_create_autocmd("InsertLeave", {
        callback = function()
          if
            luasnip.session.current_nodes[vim.api.nvim_get_current_buf()]
            and not require("luasnip").session.jump_active
          then
            luasnip.unlink_current()
          end
        end,
      })
    end,
  },
  {
    "iguanacucumber/magazine.nvim",
    optional = true,
    dependencies = {
      -- cmp sources plugins
      "saadparwaiz1/cmp_luasnip",
    },
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      {
        "<tab>",
        function()
          require("luasnip").jump(1)
        end,
        mode = "s",
      },
      {
        "<s-tab>",
        function()
          require("luasnip").jump(-1)
        end,
        mode = { "i", "s" },
      },
    },
    opts = {
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = {
        ["<C-k>"] = function()
          require("luasnip").expand()
        end,
      },
      sources = {
        { name = "luasnip", max_item_count = 10, group_index = 1 },
      },
    },
  },

  -- auto pairs
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
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
