local utils = require "custom.utils"
local constants = require "custom.utils.constants"
local lspUtils = require "custom.utils.lsp"
local lazyUtils = require "custom.utils.lazy"
local nvimtreeUtils = require "custom.utils-plugins.nvimtree"
local keymapsUtils = require "custom.utils.keymaps"
local iconsUtils = require "custom.utils.icons"
local snacksUtils = require "custom.utils-plugins.snacks"
local in_leetcode = require("custom.utils.constants").in_leetcode

return {
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    keys = {
      {
        "<leader>o",
        "<cmd>Oil<CR>",
        desc = "Oil (Cwd)",
      },
      {
        "<leader>O",
        function()
          require("oil").open(LazyVim.root())
        end,
        desc = "Oil (Root)",
      },
    },
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
          default_file = iconsUtils.file.default,
          directory = iconsUtils.folder.default,
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
        ["<C-c>"] = "actions.close",
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
        ["go"] = "actions.open_external",
      },
      view_options = {
        show_hidden = true,
      },
    },
  },

  {
    "nvim-tree/nvim-tree.lua",
    event = "VeryLazy",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = (in_leetcode and {}) or {
      {
        "<leader>E",
        function()
          if utils.in_big_project() then
            -- source: https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/826#discussioncomment-5429747
            local manager = require "neo-tree.sources.manager"
            local renderer = require "neo-tree.ui.renderer"
            local state = manager.get_state "filesystem"
            local window_exists = renderer.window_exists(state)

            if window_exists then
              -- focus
              require("neo-tree.command").execute {
                dir = LazyVim.root(),
                reveal = true,
              }
            else
              -- open
              require("neo-tree.command").execute {
                dir = LazyVim.root(),
                reveal = true,
              }
            end

            return
          end

          local api = require "nvim-tree.api"
          if api.tree.is_visible() then
            -- focus nvim-tree
            api.tree.open()
          else
            -- open nvim-tree
            utils.close_sidebars "nvim_tree"
            vim.schedule(function()
              api.tree.toggle {
                find_file = false,
                focus = true,
                update_root = false,
                path = LazyVim.root(),
              }
            end)
          end
        end,
        desc = "Nvimtree (Root)", -- focus/toggle
      },
      {
        "<leader>e",
        function()
          if utils.in_big_project() then
            -- source: https://github.com/nvim-neo-tree/neo-tree.nvim/discussions/826#discussioncomment-5429747
            local manager = require "neo-tree.sources.manager"
            local renderer = require "neo-tree.ui.renderer"
            local state = manager.get_state "filesystem"
            local window_exists = renderer.window_exists(state)

            if window_exists then
              -- focus
              require("neo-tree.command").execute {
                dir = vim.uv.cwd(),
                reveal = true,
              }
            else
              -- open
              require("neo-tree.command").execute {
                dir = vim.uv.cwd(),
                reveal = true,
              }
            end

            return
          end

          local api = require "nvim-tree.api"
          if api.tree.is_visible() then
            -- focus nvim-tree
            api.tree.open()
          else
            -- open nvim-tree
            utils.close_sidebars "nvim_tree"
            vim.schedule(function()
              api.tree.toggle {
                find_file = false,
                focus = true,
                update_root = false,
                path = vim.uv.cwd(),
              }
            end)
          end
        end,
        desc = "Nvimtree (Cwd)", -- focus/toggle
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
        side = "right",
        preserve_window_proportions = true,
        width = {
          min = 50,
          max = 50,
          padding = 2,
        },
        signcolumn = "no",
      },
      git = {
        enable = true,
        ignore = false,
        show_on_dirs = true,
        show_on_open_dirs = false,
        timeout = 400,
      },
      filesystem_watchers = {
        enable = true,
        -- PERF: nvim-tree.lua will freeze nvim on projects
        -- with a lot of files after every BufWritePost
        -- to prevent that we ignore those folders
        ignore_dirs = { "node_modules", ".direnv", ".git" },
      },
      actions = {
        open_file = {
          window_picker = {
            picker = function()
              local ok, winid = pcall(require("window-picker").pick_window)

              if not ok then
                return -1
              end

              return winid
            end,
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
            folder_arrow = true,
            git = true,
            modified = true,
          },
          glyphs = {
            default = iconsUtils.file.default,
            symlink = iconsUtils.file.symlink,
            modified = iconsUtils.git.Change,
            folder = {
              default = iconsUtils.folder.default,
              empty = iconsUtils.folder.empty,
              empty_open = iconsUtils.folder.empty_open,
              open = iconsUtils.folder.open,
              symlink = iconsUtils.folder.symlink,
              symlink_open = iconsUtils.folder.symlink_open,
              arrow_open = " ",
              arrow_closed = " ",
            },
            git = {
              unstaged = "󰄱",
              staged = "",
              unmerged = "",
              renamed = "󰁕",
              untracked = "",
              deleted = iconsUtils.git.Delete,
              ignored = "",
            },
          },
        },
      },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)
      local api = require "nvim-tree.api"
      local Event = api.events.Event
      api.events.subscribe(Event.TreeOpen, function()
        vim.cmd ":wincmd ="
      end)
      api.events.subscribe(Event.TreeClose, function()
        vim.cmd ":wincmd ="
      end)
    end,
  },
  {
    "antosha417/nvim-lsp-file-operations",
    event = "LspAttach",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      operations = {
        willRenameFiles = true,
        didRenameFiles = true,
        willCreateFiles = false,
        didCreateFiles = false,
        willDeleteFiles = false,
        didDeleteFiles = false,
      },
      timeout_ms = 1000,
    },
    config = function(_, opts)
      lazyUtils.on_load("nvim-tree.lua", function()
        require("lsp-file-operations").setup(opts)
      end)
    end,
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    event = "VeryLazy",
    cmd = "Neotree",
    keys = {
      -- {
      --   "<leader>b",
      --   function()
      --     require("neo-tree.command").execute { toggle = true, dir = vim.loop.cwd() }
      --   end,
      --   desc = "toggle neotree",
      -- },
      -- {
      --   "<leader>e",
      --   function()
      --     require("neo-tree.command").execute { action = "focus", dir = vim.loop.cwd() }
      --   end,
      --   desc = "focus neotree",
      -- },
      {
        "<leader>ge",
        function()
          -- TODO: only close sidebars if neo_tree is close
          utils.close_sidebars "neo_tree"
          vim.schedule(function()
            require("neo-tree.command").execute {
              source = "git_status",
              toggle = true,
              reveal = true,
            }
          end)
        end,
        desc = "Git Explorer",
      },
    },
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require "neo-tree"
        end
      end
    end,
    opts = {
      sources = {
        "filesystem",
        "git_status",
      },
      auto_clean_after_session_restore = true,
      close_if_last_window = true,
      enable_diagnostics = false,
      enable_opened_markers = false,
      -- enable_cursor_hijack = true,
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
      event_handlers = {
        {
          event = "neo_tree_window_after_open",
          handler = function(event)
            vim.cmd ":wincmd ="
            utils.disable_ufo(event.bufnr, event.winid)
          end,
        },
        {
          event = "neo_tree_window_after_close",
          handler = function()
            vim.cmd ":wincmd ="
          end,
        },
      },
      filesystem = {
        hijack_netrw_behavior = "disabled",
        bind_to_cwd = false,
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
      git_status = {
        window = {
          mappings = {
            ["<leader>gS"] = "git_add_file",
            ["<leader>gU"] = "git_unstage_file",
            ["<leader>gR"] = "git_revert_file",
          },
        },
      },
      window = {
        width = 50,
        position = "right",
        mappings = {
          ["<CR>"] = "open_with_window_picker",
          ["<C-v>"] = "vsplit_with_window_picker",
          ["<C-x>"] = "split_with_window_picker",
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
        container = {
          width = "100%",
          right_padding = 1,
        },
        indent = {
          with_markers = false,
          padding = 2,
        },
        icon = {
          folder_empty = iconsUtils.folder.empty,
          folder_empty_open = iconsUtils.folder.empty_open,
        },
        modified = {
          symbol = "",
        },
        git_status = {
          symbols = {
            added = iconsUtils.git.Add,
            deleted = iconsUtils.git.Delete,
            modified = iconsUtils.git.Change,
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
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      {
        "<leader>xw",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Project)",
      },
      {
        "<leader>xf",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Diagnostics (Buffer)",
      },
      {
        "<leader>xl",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Loclist",
      },
      {
        "<leader>xq",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quicklist",
      },
      {
        "[x",
        function()
          if require("trouble").is_open() then
            require("trouble").prev { skip_groups = true, jump = true }
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Prev Trouble/Quickfix Item",
      },
      {
        "]x",
        function()
          if require("trouble").is_open() then
            require("trouble").next { skip_groups = true, jump = true }
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next Trouble/Quickfix Item",
      },
    },
    opts = {
      focus = true,
      indent_guides = false,
      multiline = false,
      open_no_results = true,
      win = {
        type = "split",
        position = "bottom",
        padding = {
          left = 0,
        },
        wo = {
          number = true,
          signcolumn = "yes",
          relativenumber = true,
        },
      },
      preview = {
        type = "main",
        scratch = true,
      },
      keys = {
        ["<c-s>"] = false,
        ["<c-x>"] = "jump_split",
        ["<c-v>"] = "jump_vsplit",
      },
      icons = {
        indent = {
          ws = "",
          fold_open = iconsUtils.fold.open .. " ",
          fold_closed = iconsUtils.fold.closed .. " ",
        },
        folder_closed = iconsUtils.folder.default .. " ",
        folder_open = iconsUtils.folder.open .. " ",
        kinds = vim.tbl_map(function(icon)
          return icon .. " "
        end, iconsUtils.lspkind),
      },
    },
  },
  {
    "folke/snacks.nvim",
    optional = true,
    opts = {
      picker = {
        actions = {
          trouble_open = function(...)
            require("trouble.sources.snacks").actions.trouble_open.action(...)
          end,
          trouble_open_selected = function(...)
            require("trouble.sources.snacks").actions.trouble_open_selected.action(...)
          end,
          trouble_open_all = function(...)
            require("trouble.sources.snacks").actions.trouble_open_all.action(...)
          end,
          trouble_add = function(...)
            require("trouble.sources.snacks").actions.trouble_add.action(...)
          end,
          trouble_add_selected = function(...)
            require("trouble.sources.snacks").actions.trouble_add_selected.action(...)
          end,
          trouble_add_all = function(...)
            require("trouble.sources.snacks").actions.trouble_add_all.action(...)
          end,
        },
        win = {
          input = {
            keys = {
              ["<c-t>"] = { "trouble_open", mode = { "n", "i" } },
            },
          },
        },
      },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = { { "<leader>x", group = "trouble" } },
    },
  },

  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble" },
    event = "VeryLazy",
    opts = {
      signs = true,
      highlight = {
        multiline = false,
      },
    },
    keys = {
      {
        "]t",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next Todo Comment",
      },
      {
        "[t",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous Todo Comment",
      },
      {
        "<leader>xt",
        "<cmd>Trouble todo toggle<cr>",
        desc = "Todo (Project)",
      },
      {
        "<leader>xT",
        "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
        desc = "Todo/Fix/Fixme (Project)",
      },
    },
    config = function(_, opts)
      local tc = require "todo-comments"
      tc.setup(opts)
      -- disable todo-comments highlight
      tc.disable()
    end,
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
    keys = {
      {
        "<leader>gf",
        "<cmd>DiffviewFileHistory --no-merges %<CR>",
        desc = "Buffer Git History",
      },
      {
        "<leader>gd",
        "<cmd>DiffviewOpen<CR>",
        desc = "Merge Tool",
      },
    },
    opts = {
      enhanced_diff_hl = false,
      show_help_hints = false,
      view = {
        default = {
          disable_diagnostics = true,
        },
        merge_tool = {
          layout = "diff4_mixed",
        },
        file_history = {
          disable_diagnostics = true,
        },
      },
      file_panel = {
        listing_style = "list",
        win_config = {
          position = "right",
          width = 50,
        },
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
        diff_buf_read = function(bufnr)
          vim.opt_local.wrap = false
          lspUtils.toggle_inlay_hints(bufnr, false)
        end,
        diff_buf_win_enter = function(bufnr, winid, ctx)
          if ctx.layout_name == "diff2_horizontal" then
            if ctx.symbol == "a" then
              vim.opt_local.winhl = table.concat({
                "DiffAdd:GitSignsDeletePreview",
                "DiffDelete:DiffviewDiffDeleteSign",
                "DiffChange:GitSignsDeletePreview",
                "DiffText:GitSignsDeleteInline",
              }, ",")
            elseif ctx.symbol == "b" then
              vim.opt_local.winhl = table.concat({
                "DiffDelete:DiffviewDiffDeleteSign",
                "DiffChange:GitSignsAddPreview",
                "DiffText:GitSignsAddInline",
              }, ",")
            end
          end

          if ctx.layout_name == "diff4_mixed" then
            if ctx.symbol == "a" then
              vim.opt_local.winhl = table.concat({
                "DiffDelete:DiffviewDiffDeleteSign",
                "DiffChange:GitSignsAddPreview",
                "DiffText:GitSignsAddInline",
              }, ",")
            -- NOTE: b is local
            elseif ctx.symbol == "b" then
              vim.opt_local.winhl = table.concat({
                "DiffAdd:None",
                "DiffDelete:None",
                "DiffChange:None",
                "DiffText:None",
              }, ",")
            elseif ctx.symbol == "c" then
              vim.opt_local.winhl = table.concat({
                "DiffDelete:DiffviewDiffDeleteSign",
                "DiffChange:GitSignsAddPreview",
                "DiffText:GitSignsAddInline",
              }, ",")
            -- NOTE: d is base
            elseif ctx.symbol == "d" then
              vim.opt_local.winhl = table.concat({
                "DiffDelete:DiffviewDiffDeleteSign",
                "DiffChange:GitSignsDeletePreview",
                "DiffText:GitSignsDeleteInline",
              }, ",")
            end
          end
        end,
      },
    },
    config = function(_, opts)
      local actions = require "diffview.actions"
      opts.keymaps = {
        view = {
          { "n", "<leader>b", false },
          { "n", "[x", false },
          { "n", "]x", false },
          {
            "n",
            "[c",
            actions.prev_conflict,
            { desc = "In the merge-tool: jump to the previous conflict" },
          },
          {
            "n",
            "]c",
            actions.next_conflict,
            { desc = "In the merge-tool: jump to the next conflict" },
          },

          { "n", "<leader>co", false },
          { "n", "<leader>ct", false },
          { "n", "<leader>cb", false },
          { "n", "<leader>ca", false },
          { "n", "dx", false },
          { "n", "<leader>cO", false },
          { "n", "<leader>cT", false },
          { "n", "<leader>cB", false },
          { "n", "<leader>cA", false },
          { "n", "dX", false },
          {
            "n",
            "<leader>gco",
            actions.conflict_choose "ours",
            { desc = "Choose the OURS version of a conflict" },
          },
          {
            "n",
            "<leader>gct",
            actions.conflict_choose "theirs",
            { desc = "Choose the THEIRS version of a conflict" },
          },
          {
            "n",
            "<leader>gcb",
            actions.conflict_choose "base",
            { desc = "Choose the BASE version of a conflict" },
          },
          {
            "n",
            "<leader>gca",
            actions.conflict_choose "all",
            { desc = "Choose all the versions of a conflict" },
          },
          {
            "n",
            "dc",
            actions.conflict_choose "none",
            { desc = "Delete the conflict region" },
          },
          {
            "n",
            "<leader>gcO",
            actions.conflict_choose_all "ours",
            { desc = "Choose the OURS version of a conflict for the whole file" },
          },
          {
            "n",
            "<leader>gcT",
            actions.conflict_choose_all "theirs",
            { desc = "Choose the THEIRS version of a conflict for the whole file" },
          },
          {
            "n",
            "<leader>gcB",
            actions.conflict_choose_all "base",
            { desc = "Choose the BASE version of a conflict for the whole file" },
          },
          {
            "n",
            "<leader>gcA",
            actions.conflict_choose_all "all",
            { desc = "Choose all the versions of a conflict for the whole file" },
          },
          {
            "n",
            "dC",
            actions.conflict_choose_all "none",
            { desc = "Delete the conflict region for the whole file" },
          },
        },
        file_panel = {
          { "n", "gf", false },
          {
            "n",
            "e",
            actions.goto_file_edit,
            { desc = "Open the file in the previous tabpage" },
          },
          {
            "n",
            "q",
            actions.close,
            { desc = "Close" },
          },

          { "n", "<leader>b", false },
          { "n", "[x", false },
          { "n", "]x", false },
          { "n", "[c", actions.prev_conflict, { desc = "Go to the previous conflict" } },
          { "n", "]c", actions.next_conflict, { desc = "Go to the next conflict" } },

          { "n", "<leader>cO", false },
          { "n", "<leader>cT", false },
          { "n", "<leader>cB", false },
          { "n", "<leader>cA", false },
          { "n", "dX", false },
          {
            "n",
            "<leader>gcO",
            actions.conflict_choose_all "ours",
            { desc = "Choose the OURS version of a conflict for the whole file" },
          },
          {
            "n",
            "<leader>gcT",
            actions.conflict_choose_all "theirs",
            { desc = "Choose the THEIRS version of a conflict for the whole file" },
          },
          {
            "n",
            "<leader>gcB",
            actions.conflict_choose_all "base",
            { desc = "Choose the BASE version of a conflict for the whole file" },
          },
          {
            "n",
            "<leader>gcA",
            actions.conflict_choose_all "all",
            { desc = "Choose all the versions of a conflict for the whole file" },
          },
          {
            "n",
            "dC",
            actions.conflict_choose_all "none",
            { desc = "Delete the conflict region for the whole file" },
          },
        },
        file_history_panel = {
          { "n", "<leader>b", false },

          {
            "n",
            "q",
            actions.close,
            { desc = "Close" },
          },
        },
      }
      require("diffview").setup(opts)
    end,
  },

  {
    "nvim-pack/nvim-spectre",
    keys = {
      {
        "<leader>fs",
        "<cmd>lua require('spectre').open()<CR>",
        desc = "Search And Replace (Spectre)",
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
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      {
        "<leader>fr",
        function()
          local grug = require "grug-far"
          local ext = vim.bo.buftype == "" and vim.fn.expand "%:e"
          grug.open {
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          }
        end,
        mode = { "n", "v" },
        desc = "Search And Replace (GrugFar)",
      },
    },
    opts = {
      wrap = false,
      transient = true,
      folding = {
        enabled = false,
      },
      searchOnInsertLeave = false,
      windowCreationCommand = "vsplit",
      headerMaxWidth = 80,
      engines = {
        ripgrep = {
          showReplaceDiff = true,
        },
      },
      icons = {
        -- actionEntryBullet = " ",
        searchInput = " ",
        pathsInput = iconsUtils.folder.default .. " ",
        resultsStatusError = iconsUtils.diagnostic.Error .. " ",
        -- resultsStatusSuccess = "󰗡 ",
        resultsActionMessage = " " .. iconsUtils.diagnostic.Info .. " ",
        -- resultsChangeIndicator = "┃",
        -- resultsAddedIndicator = "▒",
        -- resultsRemovedIndicator = "▒",
        -- resultsDiffSeparatorIndicator = "┊",
      },
      keymaps = {
        replace = { n = "<leader>Rr" },
        qflist = { n = "<leader>Rq" },
        syncLocations = { n = "<leader>Rs" },
        syncLine = { n = "<leader>Rl" },
        close = { n = "<leader>Rc" },
        historyOpen = { n = "<leader>Rt" },
        historyAdd = { n = "<leader>Ra" },
        refresh = { n = "<leader>Rf" },
        openLocation = { n = "<leader>Ro" },
        openNextLocation = false,
        openPrevLocation = false,
        gotoLocation = { n = "<enter>" },
        pickHistoryEntry = { n = "<enter>" },
        abort = { n = "<leader>Rb" },
        help = { n = "g?" },
        toggleShowCommand = { n = "<leader>Rp" },
        swapEngine = { n = "<leader>Re" },
      },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = { { "<leader>R", group = "grug-far" } },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    cmd = "Telescope",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
        enabled = vim.fn.executable "cmake" == 1,
        config = function()
          lazyUtils.on_load("telescope.nvim", function()
            require("telescope").load_extension "fzf"
          end)
        end,
      },
    },
    opts = {
      defaults = {
        vimgrep_arguments = {
          "rg",
          "-L", -- Follow symlinks
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "-g",
          "!{node_modules,.git,.direnv}/",
        },
        multi_icon = "┃",
        prompt_prefix = "  ",
        selection_caret = " ",
        entry_prefix = " ",
        get_selection_window = function()
          local ok, winid = pcall(require("window-picker").pick_window, {
            include_current_win = true,
          })
          if not ok then
            return 0
          end
          if not winid then
            return 0
          end
          return winid
        end,
        dynamic_preview_title = true,
        results_title = false,
        layout_strategy = "flex",
        sorting_strategy = "ascending",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
          },
          vertical = {
            prompt_position = "top",
            mirror = true,
          },
          width = 0.9,
          height = 0.9,
        },
        -- NOTE: We don't ignore node_modules here
        -- because we use Telescope to find references,
        -- and sometimes references are in node_modules.
        file_ignore_patterns = { "%.lock$", "%-lock.json$" },
        -- NOTE: path_display might have a negative performance impact
        path_display = {
          filename_first = {},
          truncate = 1,
        },
        winblend = 0,
        border = {},
        mappings = {
          n = {
            ["<C-c>"] = function(...)
              require("telescope.actions").close(...)
            end,
          },
          i = {
            ["<c-q>"] = function(...)
              return require("trouble.sources.telescope").open(...)
            end,
            ["<a-q>"] = function(...)
              return require("trouble.sources.telescope").open(...)
            end,
            ["<C-f>"] = function(...)
              require("telescope.actions").results_scrolling_down(...)
            end,
            ["<C-b>"] = function(...)
              require("telescope.actions").results_scrolling_up(...)
            end,
            ["<C-S-f>"] = function(...)
              require("telescope.actions").results_scrolling_right(...)
            end,
            ["<C-S-b>"] = function(...)
              require("telescope.actions").results_scrolling_left(...)
            end,
            ["<C-S-d>"] = function(...)
              require("telescope.actions").preview_scrolling_right(...)
            end,
            ["<C-S-u>"] = function(...)
              require("telescope.actions").preview_scrolling_left(...)
            end,
            ["<C-Down>"] = function(...)
              require("telescope.actions").cycle_history_next(...)
            end,
            ["<C-Up>"] = function(...)
              require("telescope.actions").cycle_history_prev(...)
            end,
            ["<C-S-v>"] = keymapsUtils.command_paste,
            ["<CR>"] = function(prompt_bufnr)
              local action_state = require "telescope.actions.state"
              local picker = action_state.get_current_picker(prompt_bufnr)
              local prev_get_selection_window = picker.get_selection_window

              -- open files in the first window that is an actual file.
              -- use the current window if no other window is available.
              picker.get_selection_window = function()
                local wins = vim.api.nvim_list_wins()
                table.insert(wins, 1, vim.api.nvim_get_current_win())
                for _, win in ipairs(wins) do
                  local buf = vim.api.nvim_win_get_buf(win)
                  if vim.bo[buf].buftype == "" then
                    return win
                  end
                end
                return 0
              end
              require("telescope.actions").select_default(prompt_bufnr)

              -- restore get_selection_window
              picker.get_selection_window = prev_get_selection_window
            end,
            ["<S-CR>"] = function(...)
              require("telescope.actions").select_default(...)
            end,
          },
        },
        pickers = {
          oldfiles = {
            cwd_only = true,
          },
        },
        preview = {
          filesize_limit = 0.5,
          highlight_limit = 0.5,
          filetype_hook = function(_, bufnr)
            return not utils.is_minfile(bufnr)
          end,
        },
      },
    },
  },

  {
    "folke/snacks.nvim",
    optional = true,
    keys = (in_leetcode and {}) or {
      -- pick
      {
        "<leader>ff",
        function()
          snacksUtils.files {
            cwd = vim.uv.cwd(),
          }
        end,
        desc = "Files (Cwd)",
      },
      {
        "<leader>fF",
        function()
          snacksUtils.files {
            cwd = LazyVim.root(),
          }
        end,
        desc = "Files (Root)",
      },
      {
        "<leader>fa",
        function()
          snacksUtils.files {
            cwd = vim.uv.cwd(),
            ignored = true,
          }
        end,
        desc = "Files! (Cwd)",
      },
      {
        "<leader>fA",
        function()
          snacksUtils.files {
            cwd = LazyVim.root(),
            ignored = true,
          }
        end,
        desc = "Files! (Root)",
      },
      {
        "<leader>fw",
        function()
          snacksUtils.grep {
            cwd = vim.uv.cwd(),
          }
        end,
        desc = "Grep (Cwd)",
      },
      {
        "<leader>fw",
        function()
          snacksUtils.grep {
            cwd = vim.uv.cwd(),
          }
        end,
        desc = "Grep (Cwd)",
      },
      {
        "<leader>fW",
        function()
          snacksUtils.grep {
            cwd = LazyVim.root(),
          }
        end,
        desc = "Grep (Root)",
      },
      {
        "<leader>fy",
        function()
          Snacks.picker.lsp_symbols {
            filter = {
              default = snacksUtils.default_lsp_symbols,
            },
          }
        end,
        desc = "LSP Symbols (Buffer)",
      },
      {
        "<leader>fY",
        function()
          Snacks.picker.lsp_workspace_symbols {
            filter = {
              default = snacksUtils.default_lsp_symbols,
            },
          }
        end,
        desc = "LSP Symbols (Project)",
      },
      {
        "<leader>fo",
        function()
          Snacks.picker.recent()
        end,
        desc = "Old Files",
      },
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers {
            hidden = true,
          }
        end,
        desc = "Opened Buffers",
      },
      {
        "<leader>fd",
        function()
          Snacks.picker.lines()
        end,
        desc = "Grep (Buffer)",
      },
      {
        "<leader>fx",
        function()
          Snacks.picker.marks()
        end,
        desc = "Marks",
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.git_status {
            layout = "vertical",
          }
        end,
        desc = "Changed Files",
      },
      {
        "<leader>fu",
        function()
          Snacks.picker.pick {
            finder = "vim_undo",
            format = "undo",
            preview = "preview",
            confirm = "item_action",
            win = {
              preview = {
                wo = {
                  number = false,
                  relativenumber = false,
                  signcolumn = "no",
                },
              },
            },
          }
        end,
        desc = "Undo Tree",
      },
      {
        "<leader>mf",
        function()
          snacksUtils.filetypes()
        end,
        desc = "Pick Filetype",
      },
      {
        "<leader>fp",
        function()
          snacksUtils.projects()
        end,
        desc = "Pick Project",
      },

      -- lazygit
      {
        "<leader>gl",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit (Cwd)",
      },
      {
        "<leader>gL",
        function()
          Snacks.lazygit { cwd = LazyVim.root.git() }
        end,
        desc = "Lazygit (Root)",
      },
    },
    opts = {
      picker = {
        -- TODO: filetype hook, disable preview hl, not utils.is_minfile
        layouts = {
          default = {
            layout = {
              box = "horizontal",
              width = 0.9,
              min_width = 120,
              height = 0.9,
              {
                box = "vertical",
                border = "rounded",
                title = "{source} {live} {flags}",
                title_pos = "center",
                { win = "input", height = 1, border = "bottom" },
                { win = "list", border = "none" },
              },
              { win = "preview", border = "rounded", width = 0.55 },
            },
          },
          vertical = {
            layout = {
              width = 0.9,
              min_width = 80,
              height = 0.9,
              min_height = 30,
              box = "vertical",
              border = "rounded",
              title = "{source} {live} {flags}",
              title_pos = "center",
              { win = "input", height = 1, border = "bottom" },
              { win = "list", border = "bottom" },
              { win = "preview", height = 0.55, border = "top" },
            },
          },
        },
        actions = {
          pick = function(picker, item)
            picker:close()
            local winid = snacksUtils.window_pick()
            if winid == nil then
              return
            end
            vim.api.nvim_set_current_win(winid)
            picker:action "edit"
          end,
          pick_vsplit = function(picker, item)
            picker:close()
            local winid = snacksUtils.window_pick()
            if winid == nil then
              return
            end
            vim.api.nvim_set_current_win(winid)
            picker:action "edit_vsplit"
          end,
          pick_split = function(picker, item)
            picker:close()
            local winid = snacksUtils.window_pick()
            if winid == nil then
              return
            end
            vim.api.nvim_set_current_win(winid)
            picker:action "edit_split"
          end,
        },
        formatters = {
          file = {
            filename_first = true,
          },
        },
        previewers = {
          git = {
            native = true,
          },
        },
        win = {
          input = {
            keys = {
              ["<C-c>"] = { "close", mode = { "i", "n" } },
              ["<C-b>"] = { "list_scroll_up", mode = { "i", "n" } },
              ["<C-f>"] = { "list_scroll_down", mode = { "i", "n" } },
              ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<C-x>"] = { "edit_split", mode = { "i", "n" } },
              ["<S-CR>"] = { "pick", mode = { "i", "n" } },
              ["<c-v>"] = { "pick_vsplit", mode = { "i", "n" } },
              ["<c-x>"] = { "pick_split", mode = { "i", "n" } },
            },
          },
        },
        icons = {
          diagnostics = iconsUtils.diagnostic,
          kinds = iconsUtils.lspkind,
        },
      },

      lazygit = {
        configure = false,
        win = {
          style = "lazygit",
          width = 0,
          height = 0,
        },
      },
    },
  },

  {
    "folke/flash.nvim",
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
        prefix = { { "  ", "FlashPromptMode" }, { " " } },
      },
    },
  },

  {
    "wochap/git-conflict.nvim",
    version = "*",
    event = { "LazyFile", "VeryLazy" },
    cmd = "GitConflictListQf",
    keys = {
      {
        "<leader>xg",
        "<cmd>GitConflictListQf<cr>",
        desc = "Git Conflicts (Project)",
      },
    },
    opts = {
      default_mappings = {
        ours = "<leader>gco",
        theirs = "<leader>gct",
        none = "<leader>gc0",
        both = "<leader>gcb",
        next = "]c",
        prev = "[c",
      },
      disable_diagnostics = true,
      list_opener = function()
        require("trouble").open { mode = "quickfix" }
      end,
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("User", {
        pattern = "GitConflictDetected",
        callback = function(event)
          lspUtils.toggle_inlay_hints(event.buf, false)
          utils.disable_ufo(event.buf)
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "GitConflictResolved",
        callback = function(event)
          lspUtils.toggle_inlay_hints(event.buf, true)
          utils.enable_ufo(event.buf)
        end,
      })

      require("git-conflict").setup(opts)
    end,
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = { { "<leader>gc", group = "git conflict" } },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      signs = {
        add = {
          text = constants.in_kitty and "▍" or "▎",
        },
        change = {
          text = constants.in_kitty and "▍" or "▎",
        },
        delete = {
          text = "",
        },
        changedelete = {
          text = constants.in_kitty and "▍" or "▎",
        },
        topdelete = {
          text = "",
        },
        untracked = {
          text = constants.in_kitty and "▍" or "▎",
        },
      },
      preview_config = {
        row = 1,
      },
      max_file_length = 9999,
      signs_staged_enable = true,
      signs_staged = {
        add = {
          text = constants.in_kitty and "▍" or "▎",
        },
        change = {
          text = constants.in_kitty and "▍" or "▎",
        },
        delete = {
          text = "",
        },
        changedelete = {
          text = constants.in_kitty and "▍" or "▎",
        },
        topdelete = {
          text = "",
        },
        untracked = {
          text = constants.in_kitty and "▍" or "▎",
        },
      },
      word_diff = false,
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
        end, "Next Hunk", { expr = true, buffer = bufnr })
        map("n", "[g", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            require("gitsigns").prev_hunk()
          end)
          return "<Ignore>"
        end, "Prev Hunk", { expr = true, buffer = bufnr })
        map("n", "<leader>gS", "<cmd>lua require('gitsigns').stage_buffer()<cr>", "Stage Buffer", { buffer = bufnr })
        map("n", "<leader>gs", "<cmd>lua require('gitsigns').stage_hunk()<cr>", "Stage Hunk", { buffer = bufnr })
        map("n", "<leader>gR", "<cmd>lua require('gitsigns').reset_buffer()<cr>", "Reset Buffer", { buffer = bufnr })
        map("n", "<leader>gr", "<cmd>lua require('gitsigns').reset_hunk()<cr>", "Reset Hunk", { buffer = bufnr })
        map("n", "<leader>gp", "<cmd>lua require('gitsigns').preview_hunk()<cr>", "Preview Hunk", { buffer = bufnr })
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select Hunk (GitSigns)", { silent = true })
        map(
          "n",
          "<leader>gb",
          "<cmd>lua require('gitsigns').blame_line({ full = true })<cr>",
          "Blame Line",
          { buffer = bufnr }
        )
        map(
          "n",
          "<leader>gD",
          "<cmd>lua require('gitsigns').toggle_deleted()<cr>",
          "Toggle Deleted",
          { buffer = bufnr }
        )
      end,
    },
  },

  {
    "FabijanZulj/blame.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>gB",
        "<cmd>BlameToggle window<CR>",
        desc = "Blame (Buffer)",
      },
    },
    opts = {
      date_format = "%a %d %b %Y",
      blame_options = { "-w" },
      focus_blame = true, -- focus blame window
      merge_consecutive = true,
      commit_detail_view = function(commit_hash, row, file_path)
        vim.cmd("DiffviewOpen " .. commit_hash .. "^! --selected-file=" .. file_path)
        -- TODO: use DiffviewFileHistory
        -- vim.cmd("DiffviewFileHistory " .. file_path .. " --range=" .. commit_hash .. "^!")
      end,
      format_fn = function(line_porcelain, config, idx)
        local hash = string.sub(line_porcelain.hash, 0, 7)
        local line_with_hl = {}
        local is_commited = hash ~= "0000000"
        if is_commited then
          local summary
          if #line_porcelain.summary > config.max_summary_width then
            summary = string.sub(line_porcelain.summary, 0, config.max_summary_width - 3) .. "..."
          else
            summary = line_porcelain.summary
          end
          line_with_hl = {
            idx = idx,
            values = {
              {
                textValue = os.date(config.date_format, line_porcelain.committer_time),
                hl = "Comment",
              },
              {
                textValue = line_porcelain.author,
                hl = "Comment",
              },
              {
                textValue = summary,
                hl = hash,
              },
            },
            format = " %s  %s  %s",
          }
        else
          line_with_hl = {
            idx = idx,
            values = {
              {
                textValue = "Not commited",
                hl = "Comment",
              },
            },
            format = " %s",
          }
        end
        return line_with_hl
      end,
      mappings = {
        commit_info = "i",
        stack_push = "<TAB>",
        stack_pop = { "<S-TAB>", "<BS>" },
        show_commit = "<CR>",
        close = "q",
      },
    },
    config = function(_, opts)
      -- colors
      lazyUtils.on_load("catppuccin", function()
        local mocha = require("catppuccin.palettes").get_palette "mocha"
        opts.colors = {
          mocha.rosewater,
          mocha.flamingo,
          mocha.pink,
          mocha.mauve,
          mocha.red,
          mocha.maroon,
          mocha.peach,
          mocha.yellow,
          mocha.green,
          mocha.teal,
          mocha.sky,
          mocha.sapphire,
          mocha.blue,
          mocha.lavender,
        }
        require("blame").setup(opts)
      end)
    end,
  },

  {
    "michaelb/sniprun",
    cmd = { "SnipRun", "SnipRunOperator" },
    build = "sh install.sh",
    keys = {
      {
        "<leader>S",
        "",
        desc = "sniprun",
        mode = { "n", "v" },
      },

      {
        "<leader>Sr",
        "<Plug>SnipRun",
        desc = "Run Code",
        mode = { "n", "v" },
      },
      {
        "<leader>SR",
        "<Plug>SnipRunOperator",
        desc = "Run Code With Nvim Operator",
      },
      {
        "<leader>SC",
        "<cmd>SnipClose<CR>",
        desc = "Clear Virtual Text",
      },
    },
    opts = {
      display = {
        "VirtualText",
      },
    },
    config = function(_, opts)
      local sniprun = require "sniprun"
      lazyUtils.on_load("catppuccin", function()
        local mocha = require("catppuccin.palettes").get_palette "mocha"
        opts.snipruncolors = {
          SniprunVirtualTextOk = { bg = "NONE", fg = mocha.surface1, ctermbg = "NONE", ctermfg = "Blue" },
          SniprunVirtualTextErr = { bg = "NONE", fg = mocha.red, ctermbg = "NONE", ctermfg = "Red" },
        }
        sniprun.setup(opts)
      end)
    end,
  },
}
