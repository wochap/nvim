local nvim_utils = require "custom.utils.nvim"
local keymaps_utils = require "custom.utils.keymaps"
local constants = require "custom.constants"

return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = not constants.in_obsidian,
    cmd = { "Obsidian" },
    event = {
      "BufReadPost " .. vim.fn.expand "~" .. "/Sync/obsidian/**/*.md",
      "BufNewFile " .. vim.fn.expand "~" .. "/Sync/obsidian/**/*.md",
    },
    keys = {
      {
        "<leader>i",
        "",
        desc = "obsidian",
        mode = { "n", "v" },
      },

      {
        "<leader>in",
        "<Cmd>lua require('custom.utils-plugins.obsidian').new()<CR>",
        desc = "New",
      },
      {
        "<leader>iN",
        "<Cmd>lua require('custom.utils-plugins.obsidian').new(true)<CR>",
        desc = "New (Same Directory)",
      },
      {
        "<leader>ii",
        "<Cmd>lua require('custom.utils-plugins.obsidian').insert_link()<CR>",
        desc = "Insert Link",
      },
      {
        "<leader>iI",
        "<Cmd>lua require('custom.utils-plugins.obsidian').create_and_link()<CR>",
        desc = "Create & Link (and follow)",
        mode = { "n", "v" },
      },
      {
        "<leader>if",
        "<Cmd>Obsidian quick_switch<CR>",
        desc = "Picker (find notes)",
      },
      {
        "<leader>is",
        "<Cmd>Obsidian search<CR>",
        desc = "Search (grep notes)",
      },
      {
        "<leader>iw",
        "<Cmd>Obsidian workspace<CR>",
        desc = "Picker (workspace)",
      },
      {
        "<leader>im",
        "<Cmd>lua require('custom.utils-plugins.obsidian').open_main()<CR>",
        desc = "Main",
      },
      {
        "<leader>ib",
        "<Cmd>Obsidian backlinks<CR>",
        desc = "Pick Obsidian Backlinks",
      },
      {
        "<leader>iB",
        "<Cmd>Obsidian bookmarks<CR>",
        desc = "Bookmarks",
      },
      {
        "<leader>iL",
        "<Cmd>Obsidian links<CR>",
        desc = "Pick Obsidian Links",
      },
      {
        "<leader>it",
        "<Cmd>Obsidian template<CR>",
        desc = "Insert Template",
      },
      {
        "<leader>iO",
        "<Cmd>Obsidian toc<CR>",
        desc = "Table of Contents",
      },
      {
        "<leader>iT",
        "<Cmd>Obsidian tags<CR>",
        desc = "Tags",
      },
      {
        "<leader>ip",
        "<Cmd>Obsidian paste_img<CR>",
        desc = "Paste Image",
      },
      {
        "<leader>ir",
        "<Cmd>lua require('custom.utils-plugins.obsidian').rename()<CR>",
        desc = "Rename Note & References",
      },
      {
        "<leader>id",
        "<Cmd>Obsidian today<CR>",
        desc = "New (Daily)",
      },
      {
        "<leader>iy",
        "<Cmd>Obsidian yesterday<CR>",
        desc = "Yesterday (Daily)",
      },
      {
        "<leader>il",
        "<Cmd>lua require('custom.utils-plugins.obsidian').open_last_daily()<CR>",
        desc = "Last (Daily)",
      },
      {
        "<leader>iD",
        "<Cmd>Obsidian dailies<CR>",
        desc = "Dailies (Picker)",
      },
      {
        "<leader>io",
        "<Cmd>Obsidian open<CR>",
        desc = "Open In Obsidian",
      },
      {
        "<leader>ie",
        "<Cmd>Obsidian extract_note<CR>",
        desc = "Extract Note",
        mode = "v",
      },
      {
        "<leader>il",
        "<Cmd>Obsidian link<CR>",
        desc = "Link Selection",
        mode = "v",
      },
      {
        "<leader>iL",
        "<Cmd>Obsidian link_new<CR>",
        desc = "Link to New Note",
        mode = "v",
      },
    },
    opts = {
      legacy_commands = false,
      workspaces = require("custom.utils-plugins.obsidian").get_workspaces(),
      log_level = vim.log.levels.ERROR,
      notes_subdir = "",
      new_notes_location = "current_dir",
      daily_notes = {
        folder = "journal/dailies",
        date_format = "YYYY-MM-DD",
        default_tags = { "daily-notes" },
      },
      templates = {
        folder = "templates",
        date_format = "YYYY-MM-DD",
        time_format = "HH:mm",
      },
      cache = {
        enabled = true,
      },
      quick_switch = {
        show_existing_only = false,
      },
      picker = {
        name = "snacks.picker",
        note_mappings = {
          new = "<C-n>",
          insert_link = "<C-l>",
        },
        tag_mappings = {
          tag_note = "<C-n>",
          insert_tag = "<C-l>",
        },
      },
      link = {
        style = "wiki",
        format = "shortest",
      },
      open = {
        func = vim.ui.open,
      },
      frontmatter = {
        enabled = true,
        func = function(note)
          -- Match Obsidian app: filename is note ID, do not output 'id' in frontmatter
          local out = {}
          if note.aliases and #note.aliases > 0 then
            out.aliases = note.aliases
          end
          if note.tags and #note.tags > 0 then
            out.tags = note.tags
          end
          if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
            for k, v in pairs(note.metadata) do
              if k ~= "id" then
                out[k] = v
              end
            end
          end
          return out
        end,
        sort = { "aliases", "tags" },
      },
      note_id_func = function(title, dir)
        if title and title ~= "" then
          return title
        end
        local base = "Untitled"
        if not dir then
          return base
        end
        local path = require("obsidian.path").new(dir)
        local candidate = base
        local idx = 1
        while (path / candidate):with_suffix(".md", true):exists() do
          candidate = string.format("%s %d", base, idx)
          idx = idx + 1
        end
        return candidate
      end,
      ui = {
        enable = false,
      },
      attachments = {
        folder = "Attachments",
      },
      callbacks = {
        post_set_workspace = function(workspace)
          require("custom.utils-plugins.obsidian").post_set_workspace(workspace)
        end,
        enter_note = function()
          local actions = require "obsidian.actions"
          keymaps_utils.map("n", "gf", actions.follow_link, "Open Link Under Cursor", { buffer = true })
          keymaps_utils.map("n", "<cr>", actions.smart_action, "Smart Action", { buffer = true, expr = true })
          keymaps_utils.map("n", "<leader>ii", function()
            require("custom.utils-plugins.obsidian").insert_link()
          end, "Insert Link", { buffer = true })
          keymaps_utils.map({ "n", "v" }, "<leader>iI", function()
            require("custom.utils-plugins.obsidian").create_and_link()
          end, "Create & Link (and follow)", { buffer = true })
          keymaps_utils.map("n", "<leader>iN", function()
            require("custom.utils-plugins.obsidian").new(true)
          end, "New (Same Directory)", { buffer = true })
          keymaps_utils.map("n", "<leader>ir", function()
            require("custom.utils-plugins.obsidian").rename()
          end, "Rename Note & References", { buffer = true })
          keymaps_utils.map("v", "<leader>ie", "<Cmd>Obsidian extract_note<CR>", "Extract Note", { buffer = true })
          keymaps_utils.map("v", "<leader>il", "<Cmd>Obsidian link<CR>", "Link Selection", { buffer = true })
          keymaps_utils.map("v", "<leader>iL", function()
            require("custom.utils-plugins.obsidian").create_and_link()
          end, "Link Selection to New Note (and follow)", { buffer = true })
        end,
      },
    },
  },
  {
    "folke/snacks.nvim",
    optional = true,
    opts = {
      image = {
        resolve = function(path, src)
          local ok, api = pcall(require, "obsidian.api")
          if not (ok and path and api.path_is_note(path)) then
            return nil
          end

          src = src:gsub("^%!%[%[", ""):gsub("%]%]$", "")
          src = src:gsub("|.*$", "")
          src = vim.uri_decode(src) or src

          if vim.startswith(src, "file://") then
            src = vim.uri_to_fname(src)
          end

          -- 1. Try vanilla obsidian.nvim
          local ok_res, resolved = pcall(api.resolve_attachment_path, src, path)
          if ok_res and resolved then
            local resolved_str = tostring(resolved)
            if vim.uv.fs_stat(resolved_str) then
              return resolved_str
            end
          end

          -- 2. If vanilla obsidian.nvim didn't find the attachment, check obsidian app (.obsidian/app.json)
          local ok_ws, ws_dir = pcall(api.resolve_workspace_dir, path)
          local ws_root = ok_ws and ws_dir and tostring(ws_dir) or nil
          if not ws_root then
            return nil
          end

          local folder_setting = nil
          local app_json = vim.fs.joinpath(ws_root, ".obsidian", "app.json")
          local f = io.open(app_json, "r")
          if f then
            local content = f:read "*a"
            f:close()
            if content and content ~= "" then
              local ok_json, data = pcall(vim.json.decode, content)
              if ok_json and type(data) == "table" and data.attachmentFolderPath then
                folder_setting = data.attachmentFolderPath
              end
            end
          end

          if folder_setting and folder_setting ~= "" and folder_setting ~= "/" then
            local candidate
            if folder_setting:sub(1, 2) == "./" then
              local rel_folder = folder_setting:sub(3)
              candidate = vim.fs.normalize(vim.fs.joinpath(vim.fs.dirname(path), rel_folder, src))
            else
              candidate = vim.fs.normalize(vim.fs.joinpath(ws_root, folder_setting:gsub("^/", ""), src))
            end
            if vim.uv.fs_stat(candidate) then
              return candidate
            end
          end

          -- 3. If that setting doesn't exist (or not found in configured folder), assume attachments are in root path of vault
          local root_candidate = vim.fs.normalize(vim.fs.joinpath(ws_root, src))
          if vim.uv.fs_stat(root_candidate) then
            return root_candidate
          end
        end,
      },
    },
  },

  {
    "zk-org/zk-nvim",
    lazy = not constants.in_zk,
    main = "zk",
    event = {
      "BufReadPre " .. vim.fn.expand "~" .. "/Sync/zk/*.md",
      "BufNewFile " .. vim.fn.expand "~" .. "/Sync/zk/*.md",
    },
    keys = {
      {
        "<leader>z",
        "",
        desc = "zk",
        mode = { "n", "v" },
      },

      {
        "<leader>zn",
        "<Cmd>lua require('custom.utils-plugins.zk').new()<CR>",
        desc = "New",
      },
      {
        "<leader>zf",
        "<Cmd>ZkNotes<CR>",
        desc = "Picker", -- notes picker
      },
      {
        "<leader>zm",
        "<Cmd>lua require('custom.utils-plugins.zk').open_main()<CR>",
        desc = "Main",
      },
      {
        "<leader>zb",
        "<Cmd>ZkBacklinks<CR>",
        desc = "Pick Zk Backlinks",
      },
      {
        "<leader>zL",
        "<Cmd>ZkLinks<CR>",
        desc = "Pick Zk Links",
      },
      {
        "<leader>zd",
        "<Cmd>ZkNew { dir = 'journal' }<CR>",
        desc = "New (Daily)",
      },
      {
        "<leader>zl",
        "<Cmd>lua require('custom.utils-plugins.zk').open_last_daily()<CR>",
        desc = "Last (Daily)",
      },
    },
    init = function()
      nvim_utils.autocmd({ "BufEnter" }, {
        group = nvim_utils.augroup "load_zk_mappings",
        pattern = "*.md",
        callback = function(event)
          if require("zk.util").notebook_root(vim.fn.expand "%:p") ~= nil then
            local opts = { noremap = true, buffer = event.buf }
            keymaps_utils.map(
              "n",
              "<leader>zN",
              "<Cmd>lua require('custom.utils-plugins.zk').new(true)<CR>",
              "New (Same Directory)",
              opts
            )
            -- TODO: ZkNewFromTitleSelection
            -- TODO: ZkNewFromContentSelection
            keymaps_utils.map("n", "gf", "<Cmd>lua vim.lsp.buf.definition()<CR>", "Open Link Under Cursor", opts)
            keymaps_utils.map("n", "<CR>", "<Cmd>lua vim.lsp.buf.definition()<CR>", "Open Link Under Cursor", opts)
            keymaps_utils.map("n", "<leader>zi", "<Cmd>ZkInsertLink<CR>", "Insert Link", opts)
          end
        end,
      })
    end,
    opts = {
      picker = "snacks_picker",
    },
  },

  {
    "opdavies/toggle-checkbox.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>mx",
        "<Cmd>ToggleCheckbox<CR>",
        desc = "Toggle checkbox",
      },
    },
    opts = {},
    config = function()
      require "toggle-checkbox"
    end,
  },
}
