local utils = require "custom.utils"
local lazyUtils = require "custom.utils.lazy"
local constants = require "custom.utils.constants"
local in_neorg = require("custom.utils.constants").in_neorg
local in_leetcode = require("custom.utils.constants").in_leetcode
local in_kittyscrollback = require("custom.utils.constants").in_kittyscrollback

return {
  {
    "stevearc/dressing.nvim",
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load { plugins = { "dressing.nvim" } }
        return vim.ui.input(...)
      end
    end,
    opts = {
      input = {
        title_pos = "center",
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.opt.timeout = true
    end,
    opts = function(_, opts)
      opts.spec = opts.spec or {}
      vim.list_extend(opts.spec, {
        {
          mode = { "n", "v" },
          { "<leader>c", group = "misc" },
          { "<leader>cp", group = "profile" },
          { "<leader>cP", group = "syntax profile" },
          { "<leader>f", group = "files" },
          { "<leader>g", group = "git" },
          { "<leader>p", group = "lazy" },
          { "<leader>q", group = "quit" },
        },
      })
      return {
        spec = opts.spec,
        preset = "modern",
        layout = {
          align = "left",
          -- TOFIX: spacing also gets added in the first column
          spacing = 0,
        },
        win = {
          no_overlap = false,
          title = false,
          padding = { 0, 1 },
          -- TODO: make it work
          -- wo = {
          --   winhighlight = "Normal:WhichKeyNormal,FloatBorder:WhichKeyBorder,FloatTitle:WhichKeyTitle,Search:None",
          -- },
        },
        icons = {
          -- disable icons
          rules = false,
        },
        plugins = {
          -- NOTE: register keymaps conflict with the which-key registers plugin
          -- additionally, there's a bug: <C-r> + register prints twice when executing macros
          registers = false,
        },
      }
    end,
  },

  {
    "b0o/incline.nvim",
    enabled = not in_kittyscrollback and not in_leetcode and not in_neorg,
    event = "VeryLazy",
    opts = {
      ignore = {
        filetypes = constants.exclude_filetypes,
      },
      hide = {
        focused_win = true,
        only_win = true,
      },
      window = {
        overlap = {
          borders = true,
        },
        zindex = 10,
        margin = {
          horizontal = 0,
          vertical = 1,
        },
      },
      render = function(props)
        local bufnr = props.buf
        local modified_indicator = " "
        local bufname = vim.api.nvim_buf_get_name(props.buf)
        local filename = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]"
        local icon, _ = require("nvim-web-devicons").get_icon(filename, nil, {
          default = true,
        })
        if vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
          modified_indicator = "  "
        end
        return { { " " .. icon .. " " }, { filename }, { modified_indicator } }
      end,
    },
  },

  {
    "kevinhwang91/nvim-ufo",
    enabled = not in_kittyscrollback and not in_leetcode and not in_neorg,
    event = "VeryLazy",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "ufo open all folds",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "ufo open all folds",
      },
      {
        "zm",
        function()
          require("ufo").closeFoldsWith()
        end,
        desc = "ufo close folds with",
      },
    },
    init = function()
      vim.opt.foldcolumn = "1" -- '0' is not bad
      vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.opt.foldlevelstart = 99
      vim.opt.foldenable = true

      utils.autocmd("FileType", {
        group = utils.augroup "hide_ufo_folds",
        pattern = constants.exclude_filetypes,
        callback = function()
          utils.disable_ufo()
        end,
      })
    end,
    opts = {
      open_fold_hl_timeout = 400,
      close_fold_kinds = {},
      enable_get_fold_virt_text = false,
      preview = {
        win_config = {
          border = "single",
          winblend = 0,
          winhighlight = "Normal:UfoPreviewNormal",
        },
        mappings = {
          scrollE = "",
          scrollY = "",
          scrollU = "<C-u>",
          scrollD = "<C-d>",
          close = "<C-e>",
        },
      },
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (" 󰁂 %d "):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { " " })
        table.insert(newVirtText, { suffix, "UfoFoldedEllipsis" })
        return newVirtText
      end,
    },
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      -- nvim-ufo capabilities
      capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      },
    },
  },

  {
    "luukvbaal/statuscol.nvim",
    enabled = not in_kittyscrollback and not in_leetcode and not in_neorg,
    lazy = false,
    opts = function()
      local builtin = require "statuscol.builtin"
      return {
        ft_ignore = constants.exclude_filetypes,
        bt_ignore = constants.exclude_buftypes,
        segments = {
          -- {
          --   text = { "%s" },
          --   condition = { true },
          --   click = "v:lua.ScSa",
          -- },
          {
            text = { " " },
            condition = { true },
          },
          {
            sign = { name = { "Dap*" }, namespace = { "bulb*" } },
            click = "v:lua.ScSa",
          },
          {
            text = { builtin.lnumfunc, " " },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
          },
          {
            sign = { namespace = { "gitsign*" }, colwidth = 1, wrap = true },
            click = "v:lua.ScSa",
          },
          {
            text = { builtin.foldfunc, "  " },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScFa",
          },
        },
      }
    end,
  },

  {
    "wochap/bufferline.nvim",
    enabled = not in_kittyscrollback,
    branch = "main",
    event = "VeryLazy",
    keys = {
      {
        "<S-Right>",
        function()
          local bufferline = require "bufferline"
          pcall(bufferline.cycle, 1)
        end,
        desc = "goto next buffer",
      },
      {
        "<S-Left>",
        function()
          local bufferline = require "bufferline"
          pcall(bufferline.cycle, -1)
        end,
        desc = "goto prev buffer",
      },
      {
        "<leader>fT",
        function()
          -- local state = require "bufferline.state"
          local ui = require "bufferline.ui"
          -- for _, item in ipairs(state.visible_components) do
          --   _G.___bufferline_private.handle_close(item.id)
          -- end
          vim.cmd "tabclose"
          ui.refresh()
        end,
        desc = "close tab",
      },
    },
    init = function()
      vim.o.tabline = " "
      vim.opt.termguicolors = true

      -- Fix bufferline when restoring a session
      utils.autocmd("BufAdd", {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
    opts = {
      options = {
        themable = true,
        numbers = function(_opts)
          return string.format("%s", _opts.raise(_opts.ordinal))
        end,
        close_command = function(n)
          require("mini.bufremove").delete(n, false)
        end,
        right_mouse_command = function(n)
          require("mini.bufremove").delete(n, false)
        end,
        indicator = {
          style = "none",
        },
        modified_icon = "",
        left_trunc_marker = "❮",
        right_trunc_marker = "❯",
        show_buffer_close_icons = false,
        show_close_icon = false,
        color_icons = true,
        get_element_icon = function(element)
          local icon, hl = require("nvim-web-devicons").get_icon(vim.fn.fnamemodify(element.path, ":t"), nil, {
            default = true,
          })
          if vim.api.nvim_get_current_buf() == element.id then
            return icon, hl
          end
          return icon, "DevIconDimmed"
        end,
        separator_style = { "", "" },
        always_show_bufferline = true,
        hover = { enabled = false },
        offsets = constants.transparent_background and {
          {
            padding = 1,
            filetype = "NvimTree",
            text = function()
              return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
            end,
            highlight = "BufferLineOffset",
            separator = false,
          },
        } or {},
      },
    },
    config = function(_, opts)
      local bufferline = require "bufferline"
      lazyUtils.on_load("catppuccin", function()
        local mocha = require("catppuccin.palettes").get_palette "mocha"
        local bufferlineBg = "NONE"
        local bufferlineFg = mocha.surface1
        opts.highlights = require("catppuccin.groups.integrations.bufferline").get {
          styles = {},
          custom = {
            mocha = {
              background = {
                bg = bufferlineBg,
                fg = bufferlineFg,
              },
              fill = {
                bg = bufferlineBg,
              },
              tab = {
                bg = bufferlineBg,
                fg = bufferlineFg,
              },
              tab_selected = {
                bg = bufferlineBg,
                fg = mocha.lavender,
              },
              tab_separator = {
                bg = bufferlineBg,
                fg = mocha.base,
              },
              tab_separator_selected = {
                bg = bufferlineBg,
                fg = mocha.base,
              },
              buffer_visible = {
                bg = bufferlineBg,
                fg = bufferlineFg,
              },
              buffer_selected = {
                fg = mocha.lavender,
              },
              duplicate_selected = {
                bg = bufferlineBg,
                fg = mocha.lavender,
              },
              duplicate_visible = {
                bg = bufferlineBg,
                fg = bufferlineFg,
              },
              duplicate = {
                bg = bufferlineBg,
                fg = bufferlineFg,
              },
              numbers = {
                bg = bufferlineBg,
                fg = bufferlineFg,
              },
              numbers_visible = {
                bg = bufferlineBg,
                fg = bufferlineFg,
              },
              numbers_selected = {
                bg = bufferlineBg,
                fg = mocha.lavender,
              },
              modified = {
                bg = bufferlineBg,
                fg = bufferlineFg,
              },
              modified_visible = {
                bg = bufferlineBg,
                fg = bufferlineFg,
              },
              modified_selected = {
                fg = mocha.green,
              },
              indicator_visible = {
                bg = bufferlineBg,
              },
              trunc_marker = {
                bg = bufferlineBg,
                fg = bufferlineFg,
              },
            },
          },
        }
        bufferline.setup(opts)
      end)
    end,
  },

  {
    "wochap/noice.nvim",
    event = "VeryLazy",
    keys = {
      -- scroll signature/hover windows
      {
        "<c-u>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-u>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll backward",
        mode = { "i", "n", "s" },
      },
      {
        "<c-d>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-d>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll forward",
        mode = { "i", "n", "s" },
      },
    },
    opts = {
      cmdline = {
        enabled = false,
      },
      messages = {
        enabled = false,
      },
      popupmenu = {
        enabled = false,
      },
      notify = {
        enabled = false,
      },
      lsp = {
        progress = {
          enabled = false,
        },
        message = {
          enabled = false,
        },
        hover = {
          enabled = true,
        },
        signature = {
          enabled = true,
          -- automatically show signature help when typing
          auto_open = {
            enabled = true,
          },
        },
        override = {
          -- better highlighting for lsp signature/hover windows
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      views = {
        -- fix lsp progress covering lualine
        mini = {
          position = {
            row = -2,
          },
        },
        -- add padding to lsp doc|signature windows
        -- fix position of lsp doc|signature windows
        hover = {
          size = {
            max_width = 90,
          },
          border = {
            style = "none",
            padding = {
              top = 1,
              bottom = 1,
              left = 1,
              right = 1,
            },
          },
          position = {
            row = 1,
            col = 0,
          },
        },
      },
    },
  },

  {
    "j-hui/fidget.nvim",
    tag = "v1.4.0",
    event = "LspAttach",
    opts = {
      notification = {
        window = {
          winblend = 100,
        },
      },
      integration = {
        ["nvim-tree"] = {
          enable = false,
        },
        ["xcodebuild-nvim"] = {
          enable = false,
        },
      },
    },
  },

  {
    "nvimdev/indentmini.nvim",
    event = "LazyFile",
    opts = {
      char = constants.in_kitty and "▎" or "▏",
      exclude = constants.exclude_filetypes,
    },
  },

  {
    "mcauley-penney/visual-whitespace.nvim",
    event = "LazyFile",
    opts = {
      highlight = { link = "VisualWhitespace" },
      space_char = "·",
      tab_char = "»",
      nl_char = "",
      cr_char = "",
    },
  },

  {
    "brenoprata10/nvim-highlight-colors",
    commit = "e0f614a8980c8ce35caa43c0affb5cac3fb344d0",
    event = "VeryLazy",
    opts = {
      render = "virtual",
      enable_named_colors = false,
      enable_tailwind = false,
      custom_colors = {},
    },
  },

  {
    "echasnovski/mini.hipatterns",
    event = "LazyFile",
    opts = {
      highlighters = {
        -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
      },
    },
  },

  {
    "tzachar/highlight-undo.nvim",
    event = "LazyFile",
    opts = {
      duration = 200,
      undo = {
        hlgroup = "Visual",
      },
      redo = {
        hlgroup = "Visual",
      },
      highlight_for_count = true,
    },
  },

  {
    "echasnovski/mini.icons",
    opts = {
      default = {
        file = { glyph = "󰈤", hl = "MiniIconsRed" },
      },
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["README.md"] = { glyph = "󰍔", hl = "MiniIconsGrey" },
        ["robots.txt"] = { glyph = "󰚩", hl = "MiniIconsGrey" },
      },
      extension = {
        lock = { glyph = "󰌾", hl = "MiniIconsGrey" },
        ttf = { glyph = "", hl = "MiniIconsGrey" },
        woff = { glyph = "", hl = "MiniIconsGrey" },
        woff2 = { glyph = "", hl = "MiniIconsGrey" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
}
