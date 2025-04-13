local utils = require "custom.utils"
local keymapsUtils = require "custom.utils.keymaps"
local constants = require "custom.utils.constants"

return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = not constants.in_obsidian,
    event = {
      "BufReadPre " .. vim.fn.expand "~" .. "/Sync/obsidian/*.md",
      "BufNewFile " .. vim.fn.expand "~" .. "/Sync/obsidian/*.md",
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
        "<leader>if",
        "<Cmd>ObsidianQuickSwitch<CR>",
        desc = "Picker", -- notes picker
      },
      {
        "<leader>iw",
        "<Cmd>ObsidianWorkspace<CR>",
        desc = "Picker (workspace)", -- notes picker
      },
      {
        "<leader>im",
        "<Cmd>lua require('custom.utils-plugins.obsidian').open_main()<CR>",
        desc = "Main",
      },
      {
        "<leader>ib",
        "<Cmd>ObsidianBacklinks<CR>",
        desc = "Pick Obsidian Backlinks",
      },
      {
        "<leader>iL",
        "<Cmd>ObsidianLinks<CR>",
        desc = "Pick Obsidian Links",
      },
      {
        "<leader>ip",
        "<Cmd>ObsidianPasteImg<CR>",
        desc = "Paste Image",
      },
      {
        "<leader>id",
        "<Cmd>ObsidianToday<CR>",
        desc = "New (Daily)",
      },
      {
        "<leader>il",
        "<Cmd>ObsidianToday -1<CR>",
        desc = "Last (Daily)",
      },
      {
        "<leader>io",
        "<Cmd>ObsidianOpen<CR>",
        desc = "Open In Obsidian",
      },
      -- {
      --   "<leader>mx",
      --   "<Cmd>ObsidianToggleCheckbox<CR>",
      --   desc = "Toggle checkbox",
      -- },
    },
    opts = {
      workspaces = {
        -- TODO: automagically populate workspaces
        {
          name = "UTP",
          path = "~/Sync/obsidian/utp",
        },
        {
          name = "Recipes",
          path = "~/Sync/obsidian/recipes",
        },
        {
          name = "VisualFaktory",
          path = "~/Sync/obsidian/VisualFaktory",
        },
      },
      log_level = vim.log.levels.ERROR,
      notes_subdir = "",
      daily_notes = {
        folder = "journal/dailies",
        -- template = nil,
      },
      mappings = {
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        ["<cr>"] = {
          action = function()
            return require("obsidian").util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
        -- TODO: ObsidianExtractNote
        -- ["<leader>ii"] = {
        --   action = function()
        --     -- TODO: <Cmd>ObsidianLink<CR>
        --   end,
        --   opts = { desc = "Insert Obsidian Link", buffer = true, expr = true },
        -- },
      },
      picker = {
        name = "snacks.pick",
        note_mappings = {
          new = "<C-n>",
          insert_link = "<C-l>",
        },
        tag_mappings = {
          tag_note = "<C-n>",
          insert_tag = "<C-l>",
        },
      },
      wiki_link_func = "use_alias_only",
      markdown_link_func = "use_alias_only",
      follow_url_func = function(url)
        vim.fn.jobstart { "open", url }
      end,
      follow_img_func = function(img)
        vim.fn.jobstart { "open", img }
      end,
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "_" .. suffix
      end,
      ui = {
        enable = false,
      },
      attachments = {
        img_folder = "attachments",
      },
      completion = {
        nvim_cmp = false,
        blink = true,
      },
      callbacks = {
        post_set_workspace = function(_, workspace)
          vim.api.nvim_set_current_dir(tostring(workspace.root))
          require("persistence").load()
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
      utils.autocmd({ "BufEnter" }, {
        group = utils.augroup "load_zk_mappings",
        pattern = "*.md",
        callback = function(event)
          if require("zk.util").notebook_root(vim.fn.expand "%:p") ~= nil then
            local opts = { noremap = true, buffer = event.buf }
            keymapsUtils.map(
              "n",
              "<leader>zN",
              "<Cmd>lua require('custom.utils-plugins.zk').new(true)<CR>",
              "New (Same Directory)",
              opts
            )
            -- TODO: ZkNewFromTitleSelection
            -- TODO: ZkNewFromContentSelection
            keymapsUtils.map("n", "gf", "<Cmd>lua vim.lsp.buf.definition()<CR>", "Open Link Under Cursor", opts)
            keymapsUtils.map("n", "<CR>", "<Cmd>lua vim.lsp.buf.definition()<CR>", "Open Link Under Cursor", opts)
            keymapsUtils.map("n", "<leader>zi", "<Cmd>ZkInsertLink<CR>", "Insert Link", opts)
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
