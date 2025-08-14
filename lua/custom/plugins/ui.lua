local utils = require "custom.utils"
local lazyUtils = require "custom.utils.lazy"
local iconsUtils = require "custom.utils.icons"
local bufferlineUtils = require "custom.utils-plugins.bufferline"
local constants = require "custom.utils.constants"

return {
  {
    "folke/which-key.nvim",
    -- https://github.com/folke/which-key.nvim/issues/824
    -- version = "v3.14.1",
    event = "VeryLazy",
    init = function()
      vim.opt.timeout = true
    end,
    opts_extend = { "spec", "icons.rules" },
    opts = {
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>m", group = "misc" },
          { "<leader>mp", group = "profile" },
          { "<leader>mP", group = "syntax profile" },
          { "<leader><Tab>", group = "tab" },
          { "<leader>b", group = "buffer" },
          { "<leader>u", group = "ui" },
          { "<leader>f", group = "find/search/replace" },
          { "<leader>g", group = "git" },
          { "<leader>p", group = "profiler" },
          { "<leader>q", group = "quit/session" },
        },
      },
      preset = "modern",
      layout = {
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
      -- https://github.com/folke/which-key.nvim/issues/824
      -- triggers = {
      --   { "<auto>", mode = "nsot" },
      -- },
    },
  },

  {
    "b0o/incline.nvim",
    enabled = not constants.in_kittyscrollback and not constants.in_leetcode and not constants.in_zk,
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
        zindex = constants.zindex_float,
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
    -- fork adds element.id in options.get_element_icon fn
    "wochap/bufferline.nvim",
    enabled = not constants.in_kittyscrollback and not constants.in_lite,
    branch = "main",
    event = "VeryLazy",
    keys = {
      {
        "<S-Right>",
        function()
          local bufferline = require "bufferline"
          pcall(bufferline.cycle, 1)
        end,
        desc = "Next Buffer",
      },
      {
        "<S-Left>",
        function()
          local bufferline = require "bufferline"
          pcall(bufferline.cycle, -1)
        end,
        desc = "Prev Buffer",
      },
      {
        "<leader><Tab>d",
        function()
          local ui = require "bufferline.ui"
          vim.cmd "tabclose"
          ui.refresh()
        end,
        desc = "Close",
      },
    },
    init = function()
      -- options already set in options.lua
      -- vim.o.tabline = "%#Normal#"
      -- vim.opt.termguicolors = true

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
          Snacks.bufdelete(n)
        end,
        right_mouse_command = function(n)
          Snacks.bufdelete(n)
        end,
        indicator = {
          style = "none",
        },
        modified_icon = "",
        left_trunc_marker = "❮",
        right_trunc_marker = "❯",
        diagnostics = false,
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
        offsets = {},
      },
    },
    config = function(_, opts)
      local bufferline = require "bufferline"
      lazyUtils.on_load("catppuccin", function()
        opts.highlights = bufferlineUtils.get_highlights()
        bufferline.setup(opts)

        vim.api.nvim_create_autocmd("ColorScheme", {
          pattern = "catppuccin*",
          callback = function()
            opts.highlights = bufferlineUtils.get_highlights()
            bufferline.setup(opts)
            require("bufferline.highlights").reset_icon_hl_cache()
          end,
        })
      end)
    end,
  },

  {
    -- fork fixes position of signature/hover windows
    "wochap/noice.nvim",
    event = { "LazyFile", "VeryLazy" },
    keys = {
      { "<leader>n", "", desc = "noice" },

      {
        "<S-Enter>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "Redirect Cmdline",
      },
      {
        "<leader>nl",
        function()
          require("noice").cmd "last"
        end,
        desc = "Last Message",
      },
      {
        "<leader>nh",
        function()
          require("noice").cmd "history"
        end,
        desc = "History",
      },
      {
        "<leader>na",
        function()
          require("noice").cmd "all"
        end,
        desc = "History All",
      },
      {
        "<leader>nd",
        function()
          require("noice").cmd "dismiss"
        end,
        desc = "Dismiss All",
      },
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
        desc = "Scroll Backward",
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
        desc = "Scroll Forward",
        mode = { "i", "n", "s" },
      },
    },
    opts = {
      -- replace native cmdline
      cmdline = {
        enabled = true,
        format = {
          -- bottom search
          search_down = {
            view = "cmdline",
            icon = "  ",
          },
          search_up = {
            view = "cmdline",
            icon = "  ",
          },
        },
      },
      -- let noice manage messages
      messages = {
        enabled = true,
        -- show search count as virtualtext
        view_search = "virtualtext",
      },
      popupmenu = {
        enabled = false,
      },
      -- show all messages at bottom right
      notify = {
        enabled = true,
        view = "mini",
      },
      lsp = {
        hover = {
          enabled = true,
        },
        signature = {
          -- blink.cmp has signature integration
          enabled = false,
        },
        override = {
          -- better highlighting for lsp signature/hover windows
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              -- yank messages
              { find = "yanked" },
              -- write file messages
              { find = "%d+L, %d+B" },
              -- search messages
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
        },
        -- show long notifications in split
        {
          filter = {
            event = "msg_show",
            min_height = 20,
          },
          view = "cmdline_output",
        },
        -- show cmd output in split
        {
          filter = {
            cmdline = "^:",
          },
          view = "cmdline_output",
        },
      },
      format = {
        level = {
          icons = {
            error = iconsUtils.diagnostic.Error,
            warn = iconsUtils.diagnostic.Warn,
            info = iconsUtils.diagnostic.Info,
          },
        },
      },
      views = {
        -- rice cmdline popup
        cmdline_popup = {
          position = {
            row = 4,
            col = "50%",
          },
          size = {
            min_width = 60,
            width = "auto",
            height = "auto",
          },
          border = {
            style = "rounded",
            padding = { 0, 1 },
          },
          win_options = {
            winhighlight = {
              Normal = "NoiceCmdlinePopupNormal",
              FloatBorder = "NoiceCmdlinePopupBorder",
            },
          },
        },
        -- always enter the split when it opens
        split = {
          enter = true,
        },
        -- fix mini covering statusline
        mini = {
          position = {
            row = -1,
          },
          zindex = constants.zindex_float,
          win_config = {
            winblend = 100,
          },
        },
        -- add padding to lsp doc|signature windows
        -- fix position of lsp doc|signature windows
        hover = {
          size = {
            max_width = 90,
          },
          border = {
            style = "rounded",
            padding = {
              top = 0,
              bottom = 0,
              left = 0,
              right = 0,
            },
          },
          position = {
            row = 1,
            col = 1,
          },
          scrollbarOpts = {
            showBar = false,
            padding = {
              top = 1,
              bottom = 0,
              right = 1,
              left = 0,
            },
          },
        },
        -- rice confirm popup
        confirm = {
          align = "top",
          position = {
            row = 4,
            col = "50%",
          },
          border = {
            text = {
              top = "",
            },
          },
        },
      },
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd [[messages clear]]
      end
      require("noice").setup(opts)
    end,
  },

  {
    "j-hui/fidget.nvim",
    tag = "v1.6.1",
    event = "LspAttach",
    opts = {
      notification = {
        window = {
          winblend = constants.transparent_background and 0 or 100,
          zindex = constants.zindex_float,
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
    "wochap/noice.nvim",
    optional = true,
    opts = {
      -- disable noice lsp progress and messages
      lsp = {
        progress = {
          enabled = false,
        },
        message = {
          enabled = false,
        },
      },
    },
  },

  {
    "folke/snacks.nvim",
    optional = true,
    opts = {
      -- indent lines
      indent = {
        indent = {
          -- PERF: causes lag when folding a lot of lines
          enabled = true,
          char = constants.in_kitty and "│" or "🭲",
          only_scope = false,
          only_current = true,
          hl = "SnacksIndent",
        },
        animate = {
          enabled = false,
        },
        scope = {
          enabled = true,
          char = constants.in_kitty and "│" or "🭲",
          only_current = true,
          hl = "SnacksIndentScope",
        },
        chunk = {
          enabled = false,
          hl = "SnacksIndentChunk",
        },
        blank = {
          hl = "SnacksIndentBlank",
        },
        exclude_filetypes = constants.exclude_filetypes,
        filter = function(buf)
          local exclude_filetypes = LazyVim.opts("snacks.nvim").indent.exclude_filetypes
          local filetype = vim.api.nvim_get_option_value("filetype", { buf = buf })
          return vim.g.snacks_indent ~= false
            and vim.b[buf].snacks_indent ~= false
            and vim.bo[buf].buftype == ""
            and not vim.tbl_contains(exclude_filetypes, filetype)
        end,
      },

      image = {
        enabled = constants.in_kitty and not constants.in_neovide,
        doc = {
          max_width = 80,
          max_height = 40,
        },
      },

      scroll = {
        -- enabled = not constants.in_neovide,
        enabled = false,
        animate = {
          duration = {
            step = 15,
            total = 100,
          },
          easing = "outQuad",
        },
        animate_repeat = {
          delay = 100,
          duration = { step = 5, total = 50 },
          easing = "outQuad",
        },
      },

      statuscolumn = {
        enabled = false,
        left = { "sign" },
        right = { "fold", "git" },
      },

      -- better vim.ui.input
      input = {},

      -- better vim.ui.select
      picker = {
        ui_select = true,
      },

      styles = {
        input = {
          row = 3,
          wo = {
            winhighlight = "",
          },
          keys = {
            n_ctrl_c = { "<C-c>", "cancel", mode = "n" },
          },
        },
      },
    },
  },

  {
    "mcauley-penney/visual-whitespace.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = {
      highlight = { link = "VisualWhitespace" },
      space_char = "·",
      tab_char = "󰌒",
      nl_char = "",
      cr_char = "",
      excluded = {
        filetypes = constants.exclude_filetypes,
        buftypes = constants.exclude_buftypes,
      },
    },
  },

  -- PERF: it causes nvim to freeze
  -- when scrolling to code with colors
  {
    -- fork debounces hl colors, fixing the issue above
    "wochap/nvim-highlight-colors",
    event = "VeryLazy",
    opts = {
      render = "virtual",
      virtual_symbol = iconsUtils.other.color,
      virtual_symbol_position = "eol",
      enable_named_colors = false,
      enable_tailwind = false,
      custom_colors = {},
    },
  },

  {
    "tzachar/highlight-undo.nvim",
    event = "VeryLazy",
    init = function()
      -- Highlight on yank
      utils.autocmd("TextYankPost", {
        group = utils.augroup "highlight_yank",
        callback = function()
          vim.highlight.on_yank { higroup = "Highlight", timeout = 100 }
        end,
      })
    end,
    opts = {
      duration = 100,
      hlgroup = "Highlight",
      ignored_filetypes = constants.exclude_filetypes,
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
        ["CONTRIBUTING.md"] = { glyph = "󰍔", hl = "MiniIconsGrey" },
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

  {
    "sphamba/smear-cursor.nvim",
    -- enabled = not constants.in_kitty and not constants.in_neovide,
    enabled = false,
    event = "VeryLazy",
    opts = {
      legacy_computing_symbols_support = true,
      smear_between_neighbor_lines = false,
      windows_zindex = constants.zindex_fullscreen,
    },
    config = function(_, opts)
      local smear_cursor = require "smear_cursor"
      lazyUtils.on_load("catppuccin", function()
        local mocha = require("catppuccin.palettes").get_palette "mocha"
        opts.cursor_color = mocha.green
        smear_cursor.setup(opts)
      end)
    end,
  },

  {
    "mvllow/modes.nvim",
    enabled = constants.in_vi_edit or constants.in_kittyscrollback,
    lazy = false,
    config = function(_, opts)
      local modes = require "modes"
      lazyUtils.on_load("catppuccin", function()
        local C = require("catppuccin.palettes").get_palette()
        opts.colors = {
          copy = C.yellow,
          delete = C.red,
          format = C.peach,
          insert = C.green,
          replace = C.teal,
          visual = C.mauve,
        }
        modes.setup(opts)
      end)
    end,
  },

  -- very cool plugin but adds flashing :c
  {
    "rasulomaroff/reactive.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = {},
    config = function(_, opts)
      local reactive = require "reactive"
      lazyUtils.on_load("catppuccin", function()
        local flavour = require("catppuccin").flavour
        opts.load = { "catppuccin-" .. flavour .. "-cursor", "catppuccin-" .. flavour .. "-cursorline" }
        reactive.setup(opts)
      end)
    end,
  },
}
