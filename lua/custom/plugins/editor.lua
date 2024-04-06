local utils = require "custom.utils"
local lazyUtils = require "custom.utils.lazy"
local nvimtreeUtils = require "custom.utils.nvimtree"
local keymapsUtils = require "custom.utils.keymaps"
local in_leetcode = require("custom.utils.constants").in_leetcode

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
    -- enabled = false,
    event = "VeryLazy",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = (in_leetcode and {}) or {
      {
        "<leader>b",
        "<cmd>NvimTreeToggle<CR>",
        desc = "toggle nvimtree",
      },
      {
        "<leader>B",
        function()
          local api = require "nvim-tree.api"
          api.tree.toggle {
            find_file = false,
            focus = true,
            path = utils.get_buffer_root_path(),
            update_root = false,
          }
        end,
        desc = "toggle nvimtree (relative root dir)",
      },
      {
        "<leader>e",
        "<cmd>NvimTreeFocus<CR>",
        desc = "focus nvimtree",
      },
    },
    opts = {
      filters = {
        exclude = { vim.fn.stdpath "config" .. "/lua/custom" },
        custom = { "^.git$" },
      },
      on_attach = nvimtreeUtils.on_attach,
      respect_buf_cwd = false,
      update_cwd = false,
      disable_netrw = true,
      hijack_cursor = true,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
      },
      view = {
        preserve_window_proportions = true,
        width = 40,
      },
      git = {
        enable = true,
        ignore = false,
        show_on_dirs = true,
        show_on_open_dirs = false,
      },
      filesystem_watchers = {
        enable = true,
      },
      actions = {
        open_file = {
          window_picker = {
            exclude = {
              filetype = {
                "notify",
                "packer",
                "qf",
                "fugitive",
                "fugitiveblame",
              },
            },
          },
        },
      },
      modified = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = false,
      },
      renderer = {
        root_folder_label = false,
        group_empty = false,
        special_files = {},
        highlight_git = "name",
        icons = {
          git_placement = "after",
          show = {
            bookmarks = false,
            diagnostics = false,
            file = true,
            folder = true,
            folder_arrow = false,
            git = true,
            modified = true,
          },
          glyphs = {
            default = "󰈚",
            symlink = "",
            modified = "",
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
              unstaged = "󰄱",
              staged = "",
              unmerged = "",
              renamed = "󰁕",
              untracked = "",
              deleted = "",
              ignored = "",
            },
          },
        },
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "ten3roberts/window-picker.nvim",
    },
    keys = {
      {
        "<leader>b",
        function()
          require("neo-tree.command").execute { toggle = true, dir = vim.loop.cwd() }
        end,
        desc = "toggle neotree",
      },
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute { action = "focus", dir = vim.loop.cwd() }
        end,
        desc = "focus neotree",
      },
    },
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require "neo-tree"
        end
      end

      -- replace s1n7ax/nvim-window-picker with ten3roberts/window-picker.nvim
      lazyUtils.on_load("window-picker.nvim", function()
        local wp = require "window-picker"
        wp.pick_window = function()
          return wp.select({
            include_cur = false,
            hl = "WindowPicker",
            prompt = "Pick window: ",
          }, function(winid)
            if not winid then
              return nil
            else
              return winid
            end
          end)
        end
      end)
    end,
    opts = {
      sources = {
        "filesystem",
      },
      auto_clean_after_session_restore = true,
      close_if_last_window = true,
      enable_diagnostics = false,
      popup_border_style = "single",
      use_popups_for_input = false,
      use_default_mappings = false,
      hide_root_node = true,
      open_files_do_not_replace_types = {
        "terminal",
        "qf",
        "Trouble",
        "spectre_panel",
        "DiffviewFileHistory",
        "dapui_console",
        "dap-repl",
        "dapui_watches",
        "dapui_stacks",
        "dapui_breakpoints",
      },
      filesystem = {
        window = {
          mappings = {
            ["."] = "toggle_hidden",
            ["/"] = "fuzzy_finder",
            ["<A-Up>"] = "navigate_up",
            ["-"] = "set_root",
            ["[g"] = "prev_git_modified",
            ["]g"] = "next_git_modified",
            ["i"] = "show_file_details",
          },
        },
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            ".git",
            "node_modules",
          },
        },
      },
      window = {
        mappings = {
          ["<CR>"] = "open_with_window_picker",
          ["<C-v>"] = "split_with_window_picker",
          ["<C-x>"] = "vsplit_with_window_picker",
          ["<BS>"] = "close_node",
          ["zC"] = "close_all_nodes",
          ["zO"] = "expand_all_nodes",
          ["<C-r>"] = "refresh",
          ["a"] = "add",
          ["d"] = "delete",
          ["r"] = "rename",
          ["c"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["q"] = "close_window",
          ["?"] = "show_help",
          ["o"] = function(state)
            require("lazy.util").open(state.tree:get_node().path, { system = true })
          end,
          ["y"] = function(state)
            local node = state.tree:get_node()
            local filename = node.name
            vim.fn.setreg("+", filename, "c")
            vim.notify("Copied: " .. filename)
          end,
          ["Y"] = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            local modify = vim.fn.fnamemodify
            local relativepath = modify(filepath, ":.")
            vim.fn.setreg("+", relativepath, "c")
            vim.notify("Copied: " .. relativepath)
          end,
          ["gy"] = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            vim.fn.setreg("+", filepath, "c")
            vim.notify("Copied: " .. filepath)
          end,
        },
      },
      default_component_configs = {
        indent = {
          with_markers = false,
        },
        icon = {
          folder_empty = "",
          folder_empty_open = "",
        },
        modified = {
          symbol = "",
        },
        git_status = {
          symbols = {
            added = "",
            deleted = "",
            modified = "",
            renamed = "󰁕",
            untracked = "",
            ignored = "",
            unstaged = "󰄱",
            staged = "",
            conflict = "",
          },
          align = "right",
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
      utils.autocmd("FileType", {
        group = utils.augroup "hijack_quickfix_and_location_list",
        pattern = "qf",
        callback = function()
          local trouble = require "trouble"
          if vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0 then
            vim.defer_fn(function()
              vim.cmd.lclose()
              trouble.open "loclist"
            end, 0)
          else
            vim.defer_fn(function()
              vim.cmd.cclose()
              trouble.open "quickfix"
            end, 0)
          end
        end,
      })
    end,
    opts = {
      use_diagnostic_signs = true,
      group = false,
      padding = false,
      indent_lines = false,
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
    commit = "37372a53bf792e5bbb1bb8704c78d865d996cb3c",
    event = "VeryLazy",
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
    keys = (in_leetcode and {})
      or {
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
          "<cmd>Telescope find_files find_command=fd,--fixed-strings,--type,f,--exclude,node_modules follow=true hidden=true no_ignore=true <CR>",
          desc = "find files!",
        },
        {
          "<leader>fx",
          "<cmd>Telescope marks<CR>",
          desc = "find marks",
        },
        {
          "<leader>fp",
          "<cmd>lua require'custom.utils.telescope'.projects()<CR>",
          desc = "change project",
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
          file_ignore_patterns = { "%.git/", "%.lock$", "%-lock.json$", "%.direnv/" },
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
              ["<esc>"] = actions.close,
              ["<C-S-v>"] = keymapsUtils.commandPaste,
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
          text = "", -- PERF: a lot of signs with statuscol.nvim causes lag
        },
      },
      preview_config = {
        row = 1,
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
      attach_to_untracked = true,
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
