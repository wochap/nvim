local utils = require "custom.utils"
local iconsUtils = require "custom.utils.icons"
local keymapsUtils = require "custom.utils.keymaps"
local windowPickerUtils = require "custom.utils.window-picker"

return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    keys = {
      {
        "<leader>ql",
        "<cmd>lua require('persistence').load()<CR>",
        desc = "load last session",
      },
      {
        "<leader>qs",
        "<cmd>lua require('persistence').save()<CR>",
        desc = "save session",
      },
    },
    opts = {},
  },

  {
    "folke/zen-mode.nvim",
    cmd = { "ZenMode" },
    keys = {
      {
        "<leader>z",
        "<cmd>ZenMode<CR>",
        desc = "toggle zen mode",
      },
    },
    opts = {
      window = {
        backdrop = 1,
        width = 130, -- width of the Zen window
        height = 1, -- height of the Zen window
        options = {
          cursorline = false,
          cursorcolumn = false,
          number = false,
          relativenumber = false,
          signcolumn = "no",
          foldcolumn = "0",
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false, -- disables the ruler text in the cmd line area
          showcmd = false, -- disables the command in the last line of the screen
          laststatus = 0,
        },
        twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
        gitsigns = { enabled = true }, -- disables git signs
      },
      on_open = function()
        vim.cmd "IBLDisable"
        utils.disable_ufo()
        utils.disable_statuscol()
      end,
      on_close = function()
        vim.cmd "IBLEnable"
      end,
    },
  },

  {
    "Saimo/peek.nvim",
    commit = "f23200c241b06866b561150fa0389d535a4b903d",
    build = "deno task --quiet build:fast",
    init = function()
      utils.autocmd({ "BufEnter" }, {
        group = utils.augroup "load_peek_mappings",
        pattern = "*.md",
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          keymapsUtils.map("n", "<leader>fm", "<cmd>lua require('peek').open()<CR>", "open markdown previewer", {
            buffer = bufnr,
          })
          keymapsUtils.map("n", "<leader>fM", "<cmd>lua require('peek').close()<CR>", "close markdown previewer", {
            buffer = bufnr,
          })
        end,
      })
    end,
    opts = {
      auto_load = true, -- whether to automatically load preview when
      -- entering another markdown buffer

      close_on_bdelete = true, -- close preview window on buffer delete
      syntax = false, -- enable syntax highlighting, affects performance
      theme = "dark", -- 'dark' or 'light'
      update_on_change = true,
      app = { "qutebrowser", "--target", "window" }, -- 'webview', 'browser', string or a table of strings
      filetype = { "markdown" }, -- list of filetypes to recognize as markdown

      -- relevant if update_on_change is true
      throttle_at = 200000, -- start throttling when file exceeds this
      -- amount of bytes in size

      throttle_time = "auto", -- minimum amount of time in milliseconds
      -- that has to pass before starting new render
    },
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
    "echasnovski/mini.bufremove",
    keys = {
      {
        "<leader>w",
        function()
          local bd = require("mini.bufremove").delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = "close buffer",
      },
      {
        "<leader>W",
        function()
          require("mini.bufremove").delete(0, true)
        end,
        desc = "close buffer!",
      },
    },
    opts = {},
  },

  {
    "kazhala/close-buffers.nvim",
    keys = {
      {
        "<leader>fk",
        function()
          require("close_buffers").delete { type = "other" }
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
        desc = "close other buffers",
      },
    },
    opts = {},
  },

  {
    "ThePrimeagen/harpoon",
    keys = {
      {
        "<leader>hs",
        "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>",
        desc = "toggle quick menu files",
      },
      {
        "<leader>ha",
        "<cmd>lua require('harpoon.mark').add_file()<CR>",
        desc = "add file",
      },
      {
        "<leader>hp",
        "<cmd>lua require('harpoon.ui').nav_file(1)<CR>",
        desc = "go to file 1",
      },
      {
        "<leader>hf",
        "<cmd>lua require('harpoon.ui').nav_file(2)<CR>",
        desc = "go to file 2",
      },
      {
        "<leader>hw",
        "<cmd>lua require('harpoon.ui').nav_file(3)<CR>",
        desc = "go to file 3",
      },
      {
        "<leader>hq",
        "<cmd>lua require('harpoon.ui').nav_file(4)<CR>",
        desc = "go to file 4",
      },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      defaults = {
        ["<leader>h"] = { name = "harpon" },
      },
    },
  },

  {
    "szw/vim-maximizer",
    cmd = { "MaximizerToggle" },
    keys = {
      {
        "<leader>m",
        "<cmd>MaximizerToggle!<CR>",
        desc = "max window",
      },
    },
  },

  {
    "ariel-frischer/bmessages.nvim",
    cmd = { "Bmessages", "Bmessagesvs", "Bmessagessp", "BmessagesEdit" },
    keys = {
      {
        "<leader>cm",
        "<cmd>Bmessages<CR>",
        desc = "open messages",
      },
    },
    opts = {},
  },

  {
    "mrjones2014/smart-splits.nvim",
    event = "VeryLazy",
    keys = {
      -- focus windows
      {
        "<C-Left>",
        "<cmd>lua require('smart-splits').move_cursor_left()<cr>",
      },
      {
        "<C-Right>",
        "<cmd>lua require('smart-splits').move_cursor_right()<cr>",
      },
      {
        "<C-Down>",
        "<cmd>lua require('smart-splits').move_cursor_down()<cr>",
      },
      {
        "<C-Up>",
        "<cmd>lua require('smart-splits').move_cursor_up()<cr>",
      },

      -- resize windows
      {
        "<C-S-A-Left>",
        "<cmd>lua require('smart-splits').resize_left()<cr>",
      },
      {
        "<C-S-A-Right>",
        "<cmd>lua require('smart-splits').resize_right()<cr>",
      },
      {
        "<C-S-A-Down>",
        "<cmd>lua require('smart-splits').resize_down()<cr>",
      },
      {
        "<C-S-A-Up>",
        "<cmd>lua require('smart-splits').resize_up()<cr>",
      },

      -- swap windows
      {
        "<C-S-Left>",
        "<cmd>lua require('smart-splits').swap_buf_left()<cr>",
      },
      {
        "<C-S-Right>",
        "<cmd>lua require('smart-splits').swap_buf_right()<cr>",
      },
      {
        "<C-S-Down>",
        "<cmd>lua require('smart-splits').swap_buf_down()<cr>",
      },
      {
        "<C-S-Up>",
        "<cmd>lua require('smart-splits').swap_buf_up()<cr>",
      },
    },
    opts = {
      cursor_follows_swapped_bufs = true,
      at_edge = "stop",
    },
  },

  {
    "s1n7ax/nvim-window-picker",
    name = "window-picker",
    keys = {
      -- focus windows
      {
        "<C-F4>",
        windowPickerUtils.window_pick,
        "focus visible window",
      },
      {
        -- HACK: F28 maps C-F4 in terminal linux
        "<F28>",
        windowPickerUtils.window_pick,
        "focus visible window",
      },

      -- swap windows
      {
        "<C-S-F4>",
        windowPickerUtils.window_swap,
        "swap with window",
      },
      {
        -- HACK: F40 maps C-S-F4 in terminal linux
        "<F40>",
        windowPickerUtils.window_swap,
        "swap with window",
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
          filetype = {
            "qf",
            "notify",
            "neo-tree",
            "incline",
            "NvimTree",
          },
          buftype = {
            "terminal",
            "nofile",
          },
        },
      },
    },
  },

  -- library used by other plugins
  { "nvim-lua/plenary.nvim" },
  { "nvim-lua/popup.nvim" },
  {
    "nvim-tree/nvim-web-devicons",
    opts = {
      override = iconsUtils.devicons,
    },
  },
  { "MunifTanjim/nui.nvim" },
  { "nvim-neotest/nvim-nio" },
}
