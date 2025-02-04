local utils = require "custom.utils"
local lazyUtils = require "custom.utils.lazy"
local iconsUtils = require "custom.utils.icons"
local constants = require "custom.utils.constants"
local in_zk = require("custom.utils.constants").in_zk
local in_leetcode = require("custom.utils.constants").in_leetcode
local in_kittyscrollback = require("custom.utils.constants").in_kittyscrollback

return {
  {
    "folke/which-key.nvim",
    -- https://github.com/folke/which-key.nvim/issues/824
    version = "v3.14.1",
    event = "VeryLazy",
    init = function()
      vim.opt.timeout = true
    end,
    opts_extend = { "spec" },
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
          { "<leader>p", group = "lazy" },
          { "<leader>q", group = "quit/session" },
        },
      },
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
      -- https://github.com/folke/which-key.nvim/issues/824
      -- triggers = {
      --   { "<auto>", mode = "nsot" },
      -- },
    },
  },

  {
    "b0o/incline.nvim",
    enabled = not in_kittyscrollback and not in_leetcode and not in_zk,
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
    enabled = not in_kittyscrollback and not in_leetcode and not in_zk,
    event = { "LazyFile", "VeryLazy" },
    dependencies = {
      "kevinhwang91/promise-async",
    },
    keys = {
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "Open Folds (Ufo)",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "Close Folds (Ufo)",
      },
      {
        "zm",
        function()
          require("ufo").closeFoldsWith()
        end,
        desc = "Close Folds With (Ufo)",
      },
      {
        "zp",
        function()
          local winid = require("ufo.preview").floatWinid()
          require("ufo").peekFoldedLinesUnderCursor(winid ~= nil)
        end,
        desc = "Preview Fold (Ufo)",
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
        callback = function(event)
          utils.disable_ufo(event.buf)
        end,
      })

      utils.autocmd("FileType", {
        group = utils.augroup "hide_ufo_folds",
        pattern = "*",
        callback = function(event)
          local buftype = vim.api.nvim_get_option_value("buftype", { buf = event.buf })
          if vim.tbl_contains(constants.exclude_buftypes, buftype) then
            utils.disable_ufo(event.buf)
          end
        end,
      })
    end,
    opts = {
      open_fold_hl_timeout = 100,
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
      -- source: https://github.com/kevinhwang91/nvim-ufo?tab=readme-ov-file#minimal-configuration
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
          enabled = true,
          -- automatically show signature help when typing
          auto_open = {
            enabled = false,
          },
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
            style = "solid",
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
          zindex = 46,
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
    tag = "v1.4.0",
    event = "LspAttach",
    opts = {
      notification = {
        window = {
          winblend = 100,
          zindex = 45,
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
          enabled = true,
          char = constants.in_kitty and "▎" or "▏",
          only_scope = false,
          only_current = true,
          hl = "SnacksIndent",
        },
        animate = {
          enabled = false,
        },
        scope = {
          enabled = false,
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

  -- {
  --   "mcauley-penney/visual-whitespace.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     highlight = { link = "VisualWhitespace" },
  --     space_char = "·",
  --     tab_char = "󰌒",
  --     nl_char = "",
  --     cr_char = "",
  --   },
  -- },

  -- PERF: it causes nvim to freeze
  -- when scrolling to code with colors
  -- fork fixed that issue
  {
    "wochap/nvim-highlight-colors",
    branch = "perf",
    event = "VeryLazy",
    opts = {
      render = "virtual",
      virtual_symbol_position = "eol",
      enable_named_colors = false,
      enable_tailwind = false,
      custom_colors = {},
    },
  },

  {
    "echasnovski/mini.hipatterns",
    event = "VeryLazy",
    opts = {
      highlighters = {
        -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
        fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
        hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
        note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
        todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
        perf = { pattern = "%f[%w]()PERF()%f[%W]", group = "MiniHipatternsPerf" },
      },
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
      keymaps = {
        undo = {
          hlgroup = "Highlight",
        },
        redo = {
          hlgroup = "Highlight",
        },
        paste = {
          hlgroup = "Highlight",
        },
        Paste = {
          hlgroup = "Highlight",
        },
      },
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
    "3rd/image.nvim",
    enabled = constants.in_kitty and not constants.in_neovide,
    event = "VeryLazy",
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = true,
          download_remote_images = true,
          only_render_image_at_cursor = true,
          filetypes = { "markdown" },
        },
        neorg = {
          enabled = false,
        },
        typst = {
          enabled = false,
        },
      },
      -- max_width = nil,
      -- max_height = nil,
      -- max_width_window_percentage = nil,
      max_height_window_percentage = 40,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = {},
      -- editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
      -- tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
      -- hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
    },
  },

  {
    "sphamba/smear-cursor.nvim",
    -- enabled = not constants.in_kitty and not constants.in_neovide,
    enabled = false,
    event = "VeryLazy",
    opts = {
      legacy_computing_symbols_support = true,
      smear_between_neighbor_lines = false,
      windows_zindex = 47,
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
}
