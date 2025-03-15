local utils = require "custom.utils"
local windowPickerUtils = require "custom.utils-plugins.window-picker"
local lspUtils = require "custom.utils.lsp"
local constants = require "custom.utils.constants"
local smartSplitsUtils = require "custom.utils-plugins.smart-splits"

return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    keys = {
      {
        "<leader>ql",
        "<cmd>lua require('persistence').load()<CR>",
        desc = "Last Session",
      },
      {
        "<leader>qs",
        "<cmd>lua require('persistence').save()<CR>",
        desc = "Save Session",
      },
    },
    opts = {},
  },

  {
    "echasnovski/mini.bracketed",
    event = "VeryLazy",
    opts = {
      buffer = { suffix = "" },
      comment = { suffix = "" },
      conflict = { suffix = "" },
      diagnostic = { suffix = "" },
      file = { suffix = "" },
      indent = { suffix = "" },
      jump = { suffix = "j" },
      location = { suffix = "l" },
      oldfile = { suffix = "o" },
      quickfix = { suffix = "q" },
      treesitter = { suffix = "s" },
      undo = { suffix = "" },
      window = { suffix = "" },
      yank = { suffix = "" },
    },
  },

  {
    "kazhala/close-buffers.nvim",
    keys = {
      {
        "<leader>bo",
        function()
          require("close_buffers").delete { type = "hidden" }
        end,
        desc = "Close Others",
      },
      {
        "<leader>bO",
        function()
          require("close_buffers").delete { type = "hidden", force = true }
        end,
        desc = "Close Others!",
      },
    },
    opts = {
      filetype_ignore = constants.exclude_filetypes,
    },
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    keys = {
      {
        "<leader>h",
        "",
        desc = "harpoon",
      },

      {
        "<leader>hs",
        function()
          local harpoon = require "harpoon"
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Quick Menu",
      },
      {
        "<leader>ha",
        "<cmd>lua require('harpoon'):list():add()<CR>",
        desc = "Add",
      },
      {
        "<leader>hp",
        "<cmd>lua require('harpoon'):list():select(1)<CR>",
        desc = "Buffer 1",
      },
      {
        "<leader>hf",
        "<cmd>lua require('harpoon'):list():select(2)<CR>",
        desc = "Buffer 2",
      },
      {
        "<leader>hw",
        "<cmd>lua require('harpoon'):list():select(3)<CR>",
        desc = "Buffer 3",
      },
      {
        "<leader>hq",
        "<cmd>lua require('harpoon'):list():select(4)<CR>",
        desc = "Buffer 4",
      },
      {
        "[H",
        "<cmd>lua require('harpoon'):list():prev()<CR>",
        desc = "Prev Buffer (Harpoon)",
      },
      {
        "]H",
        "<cmd>lua require('harpoon'):list():next()<CR>",
        desc = "Next Buffer (Harpoon)",
      },
    },
    opts = {
      settings = {
        save_on_toggle = true,
      },
    },
  },

  {
    "declancm/maximize.nvim",
    event = "VeryLazy",
    opts = function()
      Snacks.toggle({
        name = "Maximize",
        get = function()
          return vim.t.maximized
        end,
        set = function(enabled)
          local m = require "maximize"
          if enabled then
            m.maximize()
          else
            m.restore()
          end
        end,
      }):map "<leader>um"

      return {
        aerial = { enable = false },
      }
    end,
  },

  {
    "mrjones2014/smart-splits.nvim",
    -- PERF: It can double the startup time in some environments,
    -- e.g., when your laptop is in power-saving mode
    lazy = false,
    commit = "4a231987665d3c6e02ca88833d050e918afe3e1e", -- v1.8.1
    keys = {
      -- focus windows
      {
        "<C-Left>",
        "<cmd>lua require('smart-splits').move_cursor_left()<cr>",
        desc = "Focus Window Left",
      },
      {
        "<C-Right>",
        "<cmd>lua require('smart-splits').move_cursor_right()<cr>",
        desc = "Focus Window Right",
      },
      {
        "<C-Down>",
        "<cmd>lua require('smart-splits').move_cursor_down()<cr>",
        desc = "Focus Window Down",
      },
      {
        "<C-Up>",
        "<cmd>lua require('smart-splits').move_cursor_up()<cr>",
        desc = "Focus Window Up",
      },

      -- resize windows
      {
        "<C-S-A-Left>",
        "<cmd>lua require('smart-splits').resize_left()<cr>",
        desc = "Resize Window Left",
      },
      {
        "<C-S-A-Right>",
        "<cmd>lua require('smart-splits').resize_right()<cr>",
        desc = "Resize Window Right",
      },
      {
        "<C-S-A-Down>",
        "<cmd>lua require('smart-splits').resize_down()<cr>",
        desc = "Resize Window Down",
      },
      {
        "<C-S-A-Up>",
        "<cmd>lua require('smart-splits').resize_up()<cr>",
        desc = "Resize Window Up",
      },

      -- swap windows
      {
        "<C-S-Left>",
        "<cmd>lua require('smart-splits').swap_buf_left()<cr>",
        desc = "Swap Buffer Left",
      },
      {
        "<C-S-Right>",
        "<cmd>lua require('smart-splits').swap_buf_right()<cr>",
        desc = "Swap Buffer Right",
      },
      {
        "<C-S-Down>",
        "<cmd>lua require('smart-splits').swap_buf_down()<cr>",
        desc = "Swap Buffer Down",
      },
      {
        "<C-S-Up>",
        "<cmd>lua require('smart-splits').swap_buf_up()<cr>",
        desc = "Swap Buffer Up",
      },
    },
    opts = {
      cursor_follows_swapped_bufs = true,
      at_edge = "stop",
      default_amount = 4,
    },
    config = function(_, opts)
      require("smart-splits").setup(opts)

      -- in tmux, smart-splits sometimes set pane-is-vim to 0
      -- even if we didn't left nvim
      local mux = require("smart-splits.mux").get()
      if not mux or mux.type ~= "tmux" then
        return
      end
      utils.autocmd("FocusGained", {
        group = utils.augroup "fix_on_init_smart_splits_nvim",
        callback = function()
          local pane_id = os.getenv "TMUX_PANE"
          if tonumber(smartSplitsUtils.tmux_exec { "show-options", "-pqvt", pane_id, "@pane-is-vim" }) == 1 then
            return
          end
          smartSplitsUtils.tmux_exec { "set-option", "-pt", pane_id, "@pane-is-vim", 1 }
        end,
      })
    end,
  },

  {
    -- fork throw error if there are not windows
    "wochap/nvim-window-picker",
    name = "window-picker",
    keys = {
      -- focus windows
      {
        "<C-F4>",
        windowPickerUtils.window_pick,
        "Focus Window",
      },
      {
        -- HACK: F28 maps C-F4 in terminal linux
        "<F28>",
        windowPickerUtils.window_pick,
        "Focus Window",
      },

      -- swap windows
      {
        "<C-S-F4>",
        windowPickerUtils.window_swap,
        "Swap With Window",
      },
      {
        -- HACK: F40 maps C-S-F4 in terminal linux
        "<F40>",
        windowPickerUtils.window_swap,
        "Swap With Window",
      },
    },
    opts = {
      hint = "floating-big-letter",
      selection_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
      picker_config = {
        statusline_winbar_picker = {
          use_winbar = "always",
        },
      },
      filter_rules = {
        bo = {
          filetype = constants.window_picker_exclude_filetypes,
          buftype = constants.window_picker_exclude_buftypes,
        },
      },
    },
  },

  {
    "stevearc/profile.nvim",
    keys = {
      {
        "<leader>mpt",
        function()
          local profile = require "profile"
          if profile.is_recording() then
            profile.stop()
            vim.ui.input(
              { prompt = "Save profile to:", completion = "file", default = "profile.json" },
              function(filename)
                if filename then
                  profile.export(filename)
                  vim.notify(string.format("Wrote %s", filename))
                end
              end
            )
          else
            profile.start "*"
          end
        end,
        desc = "Toggle (profile.nvim)",
      },
    },
  },

  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>p",
        "<cmd>PasteImage<CR>",
        desc = "Paste image",
      },
    },
    opts = {
      default = {
        dir_path = "attachments",
        use_absolute_path = false,
        relative_to_current_file = true,
        show_dir_path_in_prompt = true,
        drag_and_drop = {
          enabled = false,
        },
      },
      filetypes = {
        typst = {
          template = [[#image("./$FILE_PATH")]],
          relative_to_current_file = true,
        },
      },
    },
  },

  {
    "folke/snacks.nvim",
    optional = true,
    keys = {
      -- scratch
      {
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Toggle Scratch Buffer",
      },

      -- bufdelete
      {
        "<leader>w",
        "<leader>bd",
        desc = "Close Buffer",
        remap = true,
      },
      {
        "<leader>W",
        "<leader>bD",
        desc = "Close Buffer!",
        remap = true,
      },
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Close",
      },
      {
        "<leader>bD",
        function()
          Snacks.bufdelete { force = true }
        end,
        desc = "Close!",
      },

      -- gitbrowse
      {
        "<leader>go",
        function()
          Snacks.gitbrowse()
        end,
        desc = "Git Browse",
        mode = { "n", "v" },
      },
    },
    opts = {
      styles = {
        scratch = {
          wo = {
            winhighlight = "",
          },
          width = constants.width_fullscreen,
          height = constants.height_fullscreen,
          zindex = constants.zindex_fullscreen,
        },
      },
    },
  },

  {
    "folke/snacks.nvim",
    optional = true,
    opts = function(_, opts)
      Snacks.toggle.zen():map "<leader>uz"

      return vim.tbl_deep_extend("force", opts, {
        zen = {
          toggles = {
            dim = false,
            diagnostics = false,
            -- TODO: it doesn't toggle off git_signs
            git_signs = false,
          },
          show = {
            statusline = false,
          },
          on_open = function(win)
            local bufnr = win.buf
            -- TODO: edge case where if you are in zen mode
            -- and switch to a different buffer
            -- this fn doesn't get called
            utils.disable_ufo(bufnr)
            lspUtils.toggle_inlay_hints(bufnr, false)
          end,
          on_close = function(win)
            local bufnr = win.buf
            utils.enable_ufo(bufnr)
            lspUtils.toggle_inlay_hints(bufnr, true)
          end,
        },
        styles = {
          zen = {
            zindex = constants.zindex_fullscreen,
            width = constants.width_fullscreen,
            height = 0,
            wo = {
              cursorline = false,
              cursorcolumn = false,
            },
            -- removes cursorline, cursorcolumn, numbers and signs
            minimal = false,
          },
        },
      })
    end,
  },

  {
    "folke/snacks.nvim",
    optional = true,
    opts = function(_, opts)
      Snacks.toggle.option("spell", { name = "Spelling" }):map "<leader>us"
      Snacks.toggle.option("wrap", { name = "Wrap" }):map "<leader>uw"
      Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map "<leader>uL"
      Snacks.toggle.line_number():map "<leader>ul"
      Snacks.toggle
        .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" })
        :map "<leader>uc"

      return vim.tbl_deep_extend("force", opts, {
        toggle = {
          map = LazyVim.safe_keymap_set,
          notify = false,
        },
      })
    end,
  },

  {
    "derektata/lorem.nvim",
    keys = {
      {
        "<leader>mlw",
        function()
          local n_str = vim.fn.input "Words count: "
          local n = tonumber(n_str)
          if n and n > 0 then
            vim.cmd("LoremIpsum words " .. n)
          end
        end,
        desc = "Lorem Words",
      },
      {
        "<leader>mlp",
        function()
          local n_str = vim.fn.input "Paragraphs count: "
          local n = tonumber(n_str)
          if n and n > 0 then
            vim.cmd("LoremIpsum paragraphs " .. n)
          end
        end,
        desc = "Lorem Paragraphs",
      },
    },
    opts = {},
    config = function(_, opts)
      require("lorem").opts(opts)
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = { { "<leader>ml", group = "lorem" } },
    },
  },

  -- library used by other plugins
  { "nvim-lua/plenary.nvim" },
  { "nvim-lua/popup.nvim" },
  { "MunifTanjim/nui.nvim" },
  { "nvim-neotest/nvim-nio" },
}
