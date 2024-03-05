local utils = require "custom.utils"
local lazyUtils = require "custom.utils.lazy"
local nvimtreeUtils = require "custom.utils.nvimtree"
local keymapsUtils = require "custom.utils.keymaps"
local in_kittyscrollback = require("custom.utils.constants").in_kittyscrollback

return {
  {
    "stevearc/oil.nvim",
    cmd = { "Oil" },
    opts = {
      columns = {
        {
          "permissions",
          highlight = function(permission_str)
            local hls = {}
            local permission_hlgroups = {
              ["-"] = "OilHyphen",
              ["r"] = "OilRead",
              ["w"] = "OilWrite",
              ["x"] = "OilExecute",
            }
            for i = 1, #permission_str do
              local char = permission_str:sub(i, i)
              table.insert(hls, { permission_hlgroups[char], i - 1, i })
            end
            return hls
          end,
        },
        { "size", highlight = "OilSize" },
        { "mtime", highlight = "OilMtime" },
        {
          "icon",
          default_file = "󰈚",
          directory = "",
          add_padding = false,
        },
      },
      win_options = {
        signcolumn = "yes",
        cursorcolumn = true,
      },
      delete_to_trash = true,
      use_default_keymaps = false,
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-t>"] = "actions.select_tab",
        ["<C-p>"] = "actions.preview",
        ["q"] = "actions.close",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",

        ["<C-v>"] = "actions.select_vsplit",
        ["<C-x>"] = "actions.select_split",
        ["<C-r>"] = "actions.refresh",
        ["o"] = "actions.open_external",
      },
      view_options = {
        show_hidden = true,
      },
    },
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      {
        "<leader>b",
        "<cmd> NvimTreeToggle <CR>",
        desc = "toggle nvimtree",
      },
      {
        "<leader>e",
        "<cmd> NvimTreeFocus <CR>",
        desc = "focus nvimtree",
      },
    },
    opts = {
      filters = {
        exclude = { vim.fn.stdpath "config" .. "/lua/custom" },
        custom = { "^.git$" },
      },
      on_attach = nvimtreeUtils.on_attach,
      respect_buf_cwd = true,
      update_cwd = false,
      disable_netrw = true,
      hijack_cursor = true,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
      },
      view = {
        preserve_window_proportions = true,
        number = true,
        relativenumber = true,
        width = 40,
      },
      git = {
        enable = true,
        ignore = false,
      },
      filesystem_watchers = {
        enable = true,
      },
      renderer = {
        root_folder_label = function(path)
          local project = vim.fn.fnamemodify(path, ":t")
          return string.upper(project)
        end,
        group_empty = false,
        special_files = {},
        highlight_git = true,
        icons = {
          show = {
            bookmarks = false,
            diagnostics = false,
            file = true,
            folder = true,
            folder_arrow = false,
            git = false,
            modified = false,
          },
          glyphs = {
            default = "󰈚",
            symlink = "",
            folder = {
              default = "",
              empty = "",
              empty_open = "",
              open = "",
              symlink = "",
              symlink_open = "",
              arrow_open = "",
              arrow_closed = "",
            },
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
            },
          },
        },
      },
    },
  },

  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitFilter" },
    keys = {
      {
        "<leader>gl",
        "<cmd>LazyGit<CR>",
        desc = "open lazygit",
      },
    },
    init = function()
      vim.g.lazygit_floating_window_scaling_factor = 1 -- scaling factor for floating window
    end,
  },

  {
    "folke/todo-comments.nvim",
    event = "LazyFile",
    cmd = { "TodoTrouble", "TodoTelescope" },
    keys = {
      {
        "<leader>tl",
        "<cmd>TodoQuickFix<cr>",
        desc = "show in loclist",
      },
      {
        "<leader>tq",
        "<cmd>TodoLocList<cr>",
        desc = "show in quicklist",
      },
      {
        "[t",
        "<cmd>lua require('todo-comments').jump_prev({keywords = { 'TODO', 'HACK', 'FIX' }})<CR>",
        desc = "go to prev todo|hack|fix comment",
      },
      {
        "]t",
        "<cmd>lua require('todo-comments').jump_next({keywords = { 'TODO', 'HACK', 'FIX' }})<CR>",
        desc = "go to next todo|hack|fix comment",
      },
    },
    opts = {
      signs = false,
      highlight = {
        before = "", -- "fg" or "bg" or empty
        keyword = "fg", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
        after = "", -- "fg" or "bg" or empty
      },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      defaults = {
        ["<leader>t"] = { name = "todo" },
      },
    },
  },

  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    keys = {
      {
        "<leader>xx",
        "<cmd>TroubleToggle<cr>",
        desc = "show last list",
      },
      {
        "<leader>xw",
        "<cmd>TroubleToggle workspace_diagnostics<cr>",
        desc = "show project diagnostics",
      },
      {
        "<leader>xf",
        "<cmd>TroubleToggle document_diagnostics<cr>",
        desc = "show file diagnostic",
      },
      {
        "<leader>xl",
        "<cmd>TroubleToggle loclist<cr>",
        desc = "toggle loclist",
      },
      {
        "<leader>xq",
        "<cmd>TroubleToggle quickfix<cr>",
        desc = "toggle quicklist",
      },
      {
        "gr",
        "<cmd>TroubleToggle lsp_references<cr>",
        desc = "toggle references",
      },
      {
        "[x",
        "<cmd>lua require('trouble').previous({skip_groups = true, jump = true})<CR>",
        desc = "go to prev troublelist item",
      },
      {
        "]x",
        "<cmd>lua require('trouble').next({skip_groups = true, jump = true})<CR>",
        desc = "go to next troublelist item",
      },
    },
    init = function()
      utils.autocmd("FileType", {
        group = utils.augroup "show_numbers_trouble",
        pattern = "Trouble",
        command = "set nu",
      })
    end,
    opts = {
      use_diagnostic_signs = true,
      -- group = false,
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      defaults = {
        ["<leader>x"] = { name = "trouble" },
      },
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      {
        "<leader>gf",
        "<cmd>DiffviewFileHistory %<CR>",
        desc = "open current file history",
      },
    },
    opts = {
      enhanced_diff_hl = false,
      show_help_hints = false,
      file_panel = {
        listing_style = "list",
      },
      file_history_panel = {
        log_options = {
          git = {
            single_file = {
              diff_merges = "first-parent",
            },
          },
        },
      },
      hooks = {
        diff_buf_read = function()
          vim.opt_local.wrap = false
        end,
        diff_buf_win_enter = function(bufnr, winid, ctx)
          if ctx.layout_name:match "^diff2" then
            if ctx.symbol == "a" then
              vim.opt_local.winhl = table.concat({
                "DiffAdd:DiffviewDiffAddAsDelete",
                "DiffDelete:DiffviewDiffDeleteSign",
                "DiffChange:DiffviewDiffDelete",
                "DiffText:DiffviewDiffDeleteText",
              }, ",")
            elseif ctx.symbol == "b" then
              vim.opt_local.winhl = table.concat({
                "DiffDelete:DiffviewDiffDeleteSign",
                "DiffChange:DiffviewDiffAdd",
                "DiffText:DiffviewDiffAddText",
              }, ",")
            end
          end
        end,
      },
    },
  },

  {
    "nvim-pack/nvim-spectre",
    keys = {
      {
        "<leader>fs",
        "<cmd>lua require('spectre').open()<CR>",
        desc = "find word spectre",
      },
    },
    opts = {
      highlight = {
        ui = "String",
        search = "SpectreSearch",
        replace = "DiffAdd",
      },
      mapping = {
        ["send_to_qf"] = {
          map = "<C-q>",
          cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
          desc = "send all item to quickfix",
        },
      },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    url = "https://github.com/wochap/telescope.nvim.git",
    commit = "726dfed63e65131c60d10a3ac3f83b35b771aa83",
    event = { "LazyFile", "VeryLazy" },
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable "make" == 1,
        config = function()
          lazyUtils.on_load("telescope.nvim", function()
            require("telescope").load_extension "fzf"
          end)
        end,
      },
    },
    keys = {
      {
        "<leader>cf",
        "<cmd>Telescope filetypes<cr>",
        desc = "change filetype",
      },

      -- find
      {
        "<leader>fw",
        "<cmd>lua require'custom.utils.telescope'.live_grep()<CR>",
        desc = "find word",
      },
      {
        "<leader>fy",
        "<cmd>lua require'custom.utils.telescope'.symbols()<CR>",
        desc = "find symbols",
      },
      {
        "<leader>fo",
        "<cmd>Telescope oldfiles<CR>",
        desc = "find old files",
      },
      {
        "<leader>fg",
        "<cmd>Telescope git_status<CR>",
        desc = "find changed files",
      },
      {
        "<leader>fb",
        "<cmd>Telescope buffers sort_mru=true sort_lastused=true <CR>",
        desc = "find buffers",
      },
      {
        "<leader>ff",
        "<cmd>Telescope find_files find_command=fd,--fixed-strings,--type,f follow=true hidden=true <CR>",
        desc = "find files",
      },
      {
        "<leader>fa",
        "<cmd>Telescope find_files find_command=fd,--fixed-strings,--type,f follow=true hidden=true no_ignore=true <CR>",
        desc = "find files!",
      },
      {
        "<leader>fx",
        "<cmd>Telescope marks<CR>",
        desc = "find marks",
      },
    },
    opts = function()
      local actions = require "telescope.actions"
      local sorters = require "telescope.sorters"
      return {
        defaults = {
          vimgrep_arguments = {
            "rg",
            "-L",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          prompt_prefix = "   ",
          selection_caret = "  ",
          entry_prefix = "  ",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          file_sorter = sorters.get_fuzzy_file,
          file_ignore_patterns = { "node_modules", "%.git/", "%.lock$", "%-lock.json$", "%.direnv/" },
          generic_sorter = sorters.get_generic_fuzzy_sorter,
          path_display = { "truncate" },
          winblend = 0,
          border = {},
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
          mappings = {
            n = {
              ["q"] = actions.close,
            },
            i = {
              ["<C-Down>"] = actions.cycle_history_next,
              ["<C-Up>"] = actions.cycle_history_prev,
            },
          },
          pickers = {
            oldfiles = {
              cwd_only = true,
            },
          },
        },

        extensions_list = { "fzf" },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)

      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end
    end,
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    init = function()
      utils.autocmd({ "CmdlineLeave", "CmdlineEnter" }, {
        group = utils.augroup "turn_off_flash_search",
        callback = function()
          local has_flash, flash = pcall(require, "flash")
          if not has_flash then
            return
          end
          pcall(flash.toggle, false)
        end,
      })
    end,
    keys = {
      {
        "s",
        function()
          require("flash").jump()
        end,
        desc = "Flash",
        mode = { "n", "x", "o" },
      },
      {
        "<A-s>",
        function()
          require("flash").jump { continue = true }
        end,
        desc = "Flash",
        mode = { "n", "x", "o" },
      },
      {
        "S",
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
        mode = { "n", "o", "x" },
      },
      {
        "r",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
        mode = "o",
      },
      {
        "R",
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
        mode = { "o", "x" },
      },
      {
        "<C-s>",
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
        mode = { "c" },
      },
    },
    opts = {
      search = {
        multi_window = false,
      },
      modes = {
        char = {
          enabled = false,
          jump_labels = true,
          multi_line = false,
        },
      },
      prompt = {
        enabled = true,
        prefix = { { " FLASH ", "FlashPromptMode" }, { " ", "FlashPromptModeSep" } },
      },
    },
  },
  -- integrate flash in telescope
  {
    "nvim-telescope/telescope.nvim",
    url = "https://github.com/wochap/telescope.nvim.git",
    commit = "726dfed63e65131c60d10a3ac3f83b35b771aa83",
    optional = true,
    opts = function(_, opts)
      local flash = require("custom.utils.telescope").flash
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        mappings = { n = { s = flash }, i = { ["<c-s>"] = flash } },
      })
    end,
  },

  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "VeryLazy",
    opts = {
      default_mappings = {
        ours = "<leader>gco",
        theirs = "<leader>gct",
        none = "<leader>gc0",
        both = "<leader>gcb",
        next = "]c",
        prev = "[c",
      },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("User", {
        pattern = "GitConflictDetected",
        callback = function(event)
          lazyUtils.on_load("which-key.nvim", function()
            local wk = require "which-key"
            wk.register({
              ["<leader>gc"] = { name = "git conflict" },
            }, { buffer = event.buf })
          end)
        end,
      })

      require("git-conflict").setup(opts)
    end,
  },

  {
    "NMAC427/guess-indent.nvim",
    event = "VeryLazy",
    opts = {},
  },

  {
    "mikesmithgh/kitty-scrollback.nvim",
    lazy = not in_kittyscrollback,
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    commit = "8c36b74723049521cbcc5361c7477cb69c02812f",
    opts = function()
      local theme = require("catppuccin.palettes").get_palette "mocha"
      return {
        callbacks = {
          after_setup = function()
            local ksb_api = require "kitty-scrollback.api"
            vim.opt_local.signcolumn = "no"
            vim.keymap.set("n", "q", ksb_api.close_or_quit_all, {})
            vim.keymap.del("n", "g?")
            vim.keymap.set("n", "<esc>", ":noh<CR>", {})
          end,
        },
        highlight_overrides = {
          KittyScrollbackNvimSpinner = {
            bg = theme.mantle,
            fg = theme.lavender,
          },
          KittyScrollbackNvimNormal = {
            bg = theme.mantle,
            fg = theme.lavender,
          },
          KittyScrollbackNvimPasteWinNormal = {
            bg = theme.mantle,
          },
          KittyScrollbackNvimPasteWinFloatBorder = {
            bg = theme.mantle,
            fg = theme.mantle,
          },
        },
        keymaps_enabled = true,
        status_window = {
          enabled = true,
          style_simple = true,
        },
        paste_window = {
          hide_footer = true,
          winopts_overrides = function(winopts)
            return vim.tbl_deep_extend("force", {}, {
              anchor = "NW",
              border = "rounded",
              col = 0,
              focusable = true,
              height = math.floor(vim.o.lines / 2.5),
              relative = "editor",
              row = vim.o.lines,
              style = "minimal",
              width = vim.o.columns,
              zindex = 40,
            })
          end,
          footer_winopts_overrides = function(winopts)
            return winopts
          end,
        },
        visual_selection_highlight_mode = "nvim",
      }
    end,
    config = function(_, opts)
      require("kitty-scrollback").setup {
        global = function()
          return opts
        end,
      }
    end,
  },

  {
    "mrjones2014/smart-splits.nvim",
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
    "ten3roberts/window-picker.nvim",
    cmd = { "WindowSwap", "WindowPick" },
    keys = {
      -- focus windows
      {
        "<C-F4>",
        "<cmd>WindowPick<cr>",
        "focus visible window",
      },
      {
        -- HACK: F28 maps C-F4 in terminal linux
        "<F28>",
        "<cmd>WindowPick<cr>",
        "focus visible window",
      },

      -- swap windows
      {
        "<C-S-F4>",
        "<cmd>WindowSwap<cr>",
        "swap with window",
      },
      {
        -- HACK: F40 maps C-S-F4 in terminal linux
        "<F40>",
        "<cmd>WindowSwap<cr>",
        "swap with window",
      },
    },
    opts = {
      swap_shift = false,
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = "LazyFile",
    opts = {
      signs = {
        add = {
          hl = "GitSignsAdd",
          text = "▍",
        },
        change = {
          hl = "GitSignsChange",
          text = "▍",
        },
        delete = {
          hl = "GitSignsDelete",
          text = "",
        },
        changedelete = {
          hl = "GitSignsChange",
          text = "▍",
        },
        topdelete = {
          hl = "GitSignsDelete",
          text = "",
        },
        untracked = {
          hl = "GitSignsAdd",
          text = "▍",
        },
      },
      _signs_staged_enable = true,
      _signs_staged = {
        add = {
          hl = "GitSignsStagedAdd",
          text = "▍",
        },
        change = {
          hl = "GitSignsStagedChange",
          text = "▍",
        },
        delete = {
          hl = "GitSignsStagedDelete",
          text = "",
        },
        changedelete = {
          hl = "GitSignsStagedChange",
          text = "▍",
        },
        topdelete = {
          hl = "GitSignsStagedDelete",
          text = "",
        },
      },
      on_attach = function(bufnr)
        local map = keymapsUtils.map
        map("n", "]g", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            require("gitsigns").next_hunk()
          end)
          return "<Ignore>"
        end, "jump to next hunk", { expr = true, buffer = bufnr })
        map("n", "[g", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            require("gitsigns").prev_hunk()
          end)
          return "<Ignore>"
        end, "jump to prev hunk", { expr = true, buffer = bufnr })
        map("n", "<leader>gS", "<cmd>lua require('gitsigns').stage_buffer()<cr>", "stage buffer", { buffer = bufnr })
        map("n", "<leader>gs", "<cmd>lua require('gitsigns').stage_hunk()<cr>", "stage hunk", { buffer = bufnr })
        map("n", "<leader>gR", "<cmd>lua require('gitsigns').reset_buffer()<cr>", "reset buffer", { buffer = bufnr })
        map("n", "<leader>gr", "<cmd>lua require('gitsigns').reset_hunk()<cr>", "reset hunk", { buffer = bufnr })
        map("n", "<leader>gp", "<cmd>lua require('gitsigns').preview_hunk()<cr>", "preview hunk", { buffer = bufnr })
        map(
          "n",
          "<leader>gb",
          "<cmd>lua require('gitsigns').blame_line({ full = true })<cr>",
          "blame line",
          { buffer = bufnr }
        )
        map(
          "n",
          "<leader>gd",
          "<cmd>lua require('gitsigns').toggle_deleted()<cr>",
          "toggle deleted",
          { buffer = bufnr }
        )
      end,
    },
  },
}
