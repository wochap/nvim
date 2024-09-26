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
      spec = { { "gs", group = "surround" } },
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

  {
    "echasnovski/mini.ai",
    event = { "LazyFile", "VeryLazy" },
    opts = function()
      local ai = require "mini.ai"
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
          g = function() -- Whole buffer, similar to `gg` and 'G' motion
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line "$",
              col = math.max(vim.fn.getline("$"):len(), 1),
            }
            return { from = from, to = to }
          end,
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call { name_pattern = "[%w_]" }, -- without dot in function name
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)

      lazyUtils.on_load("which-key.nvim", function()
        vim.schedule(function()
          require("lazyvim.util.mini").ai_whichkey(opts)
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
        desc = "Telescope",
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
      },
    },
    config = function(_, opts)
      require("textcase").setup(opts)

      local to_kebab_case = require("textcase.shared.utils").create_wrapped_method(
        "to_dash_case",
        require("textcase.conversions.stringcase").to_dash_case,
        "to-kebab-case"
      )
      require("textcase.plugin.plugin").register_keybindings(opts.prefix, to_kebab_case, {
        prefix = opts.prefix,
        quick_replace = "k",
        operator = "ok",
        lsp_rename = "K",
      })

      lazyUtils.on_load("telescope.nvim", function()
        require("telescope").load_extension "textcase"
      end)
    end,
  },

  {
    "yioneko/nvim-cmp",
    branch = "perf-up",
    event = { "CmdlineEnter", "InsertEnter", "VeryLazy" },
    version = false, -- last release is way too old
    dependencies = {
      -- cmp sources plugins
      "saadparwaiz1/cmp_luasnip",
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
            (vim.fn.reg_recording() ~= "")
            or (vim.fn.reg_executing() ~= "")
            or (cmp_ctx.in_treesitter_capture "comment" == true)
            or (cmp_ctx.in_syntax_group "comment" == true)
          then
            return false
          end

          local has_cmp_dap_load = lazyUtils.is_loaded "cmp-dap"
          if has_cmp_dap_load then
            local cmp_dap = require "cmp_dap"
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
            border = cmpUtils.border "CmpBorder",
            side_padding = 1,
            winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel,Search:None",
            scrollbar = true,
          },
          documentation = {
            border = cmpUtils.border "CmpDocBorder",
            winhighlight = "Normal:CmpDoc,Search:None",
          },
        },
        view = {
          entries = {
            follow_cursor = true,
          },
        },
        snippet = {
          expand = function(args)
            local has_luasnip, luasnip = pcall(require, "luasnip")
            if not has_luasnip then
              return
            end
            luasnip.lsp_expand(args.body)
          end,
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
          -- TODO: add C-f and C-b mappings to scroll options
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-u>"] = cmp.mapping.scroll_docs(-4),
          ["<C-d>"] = cmp.mapping.scroll_docs(4),
          ["<C-n>"] = cmpUtils.select_next_item,
          ["<C-p>"] = cmpUtils.select_prev_item,
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-k>"] = function()
            require("luasnip").expand()
          end,
          ["<Up>"] = function(fallback)
            cmpUtils.cmp_close_tl()
            fallback()
          end,
          ["<Down>"] = function(fallback)
            cmpUtils.cmp_close_tl()
            fallback()
          end,
          ["<Left>"] = function(fallback)
            cmpUtils.cmp_close_tl()
            fallback()
          end,
          ["<Right>"] = function(fallback)
            cmpUtils.cmp_close_tl()
            fallback()
          end,
          ["<C-y>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          },
          ["<Tab>"] = {
            i = function(fallback)
              if require("luasnip").jumpable(1) then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-next", true, true, true), "")
              else
                fallback()
              end
            end,
            s = function(fallback)
              require("luasnip").jump(1)
            end,
          },
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            require("luasnip").jump(-1)
          end, {
            "i",
            "s",
          }),
          ["<CR>"] = function(fallback)
            cmpUtils.cmp_close_tl()
            fallback()
          end,
        },
        sources = {
          { name = "path", max_item_count = 10, group_index = 1 },
          { name = "luasnip", max_item_count = 10, group_index = 1 },
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
        ["<C-Space>"] = { c = cmp.mapping.complete() },
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
          c = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          },
        },
        ["<C-S-y>"] = {
          c = function(fallback)
            cmp.confirm({
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            }, function()
              vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "")
            end)
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
        desc = "expand snippet",
        mode = "i",
      },
    },
    opts = {
      history = true,
      updateevents = "TextChanged,TextChangedI",
      -- Show snippets related to the language
      -- in the current cursor position
      ft_func = function()
        return require("luasnip.extras.filetype_functions").from_pos_or_filetype()
      end,
    },
    config = function(_, opts)
      local luasnip = require "luasnip"
      luasnip.config.set_config(opts)
      require("luasnip.loaders.from_vscode").load { paths = vim.fn.stdpath "config" .. "/snippets" }
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
    "windwp/nvim-autopairs",
    event = { "InsertEnter", "VeryLazy" },
    opts = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "spectre_panel", "vim" },
      check_ts = true,
      map_bs = false,
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)

      lazyUtils.on_load("nvim-cmp", function()
        local cmp_autopairs = require "nvim-autopairs.completion.cmp"
        require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end)
    end,
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    opts = {
      enable_autocmd = false,
    },
  },
  {
    "numToStr/Comment.nvim",
    event = { "LazyFile", "VeryLazy" },
    keys = {
      {
        "<leader>/",
        function()
          require("Comment.api").toggle.linewise.current()
        end,
        desc = "Toggle comment",
      },
      {
        "<leader>/",
        "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
        desc = "Toggle comment",
        mode = "v",
      },
    },
    opts = function()
      return {
        mappings = {
          basic = false,
          extra = false,
        },
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },

  {
    "monkoose/matchparen.nvim",
    event = { "LazyFile", "VeryLazy" },
    opts = {
      debounce_time = 100,
    },
  },

  {
    "NMAC427/guess-indent.nvim",
    event = { "LazyFile", "VeryLazy" },
    opts = {},
  },
}
