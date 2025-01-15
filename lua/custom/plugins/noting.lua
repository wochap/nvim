local utils = require "custom.utils"
local lazyUtils = require "custom.utils.lazy"
local keymapsUtils = require "custom.utils.keymaps"
local constants = require "custom.utils.constants"

return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    event = {
      "BufReadPre " .. vim.fn.expand "~" .. "/Sync/obsidian/*.md",
      "BufNewFile " .. vim.fn.expand "~" .. "/Sync/obsidian/*.md",
    },
    opts = {
      workspaces = {
        -- TODO: automagically populate workspaces
        {
          name = "utp",
          path = "~/Sync/obsidian/utp",
        },
        {
          name = "recipes",
          path = "~/Sync/obsidian/recipes",
        },
      },
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
      },
      picker = {
        name = "telescope.nvim",
        note_mappings = {
          new = "<C-n>",
          insert_link = "<C-l>",
        },
        tag_mappings = {
          tag_note = "<C-n>",
          insert_tag = "<C-l>",
        },
      },
      ui = {
        enable = false,
      },
      attachments = {
        img_folder = "attachments",
      },
    },
  },

  {
    "zk-org/zk-nvim",
    lazy = not constants.in_zk,
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
        "<leader>zd",
        "<Cmd>ZkNew { dir = 'journal' }<CR>",
        desc = "New (Daily)",
      },
      {
        "<leader>zf",
        "<Cmd>ZkNotes<CR>",
        desc = "Picker (Telescope)", -- notes picker
      },
    },
    init = function()
      utils.autocmd({ "BufEnter" }, {
        group = utils.augroup "load_zk_mappings",
        pattern = "*.md",
        callback = function(event)
          if require("zk.util").notebook_root(vim.fn.expand "%:p") ~= nil then
            local opts = { noremap = true, buffer = event.buf }
            keymapsUtils.map("n", "<CR>", "<Cmd>lua vim.lsp.buf.definition()<CR>", "Open Link Under Cursor", opts)
            keymapsUtils.map(
              "n",
              "<leader>zN",
              "<Cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
              "New (Same Directory)",
              opts
            )
            keymapsUtils.map(
              "v",
              "<leader>zt",
              ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>",
              "New (Same Directory, Selection As Title)",
              opts
            )
            keymapsUtils.map(
              "v",
              "<leader>zc",
              ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
              "New (Same Directory, Selection As Content)",
              opts
            )
            keymapsUtils.map("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", "Pick Zk Backlinks", opts)
            keymapsUtils.map("n", "<leader>zl", "<Cmd>ZkLinks<CR>", "Pick Zk Links", opts)
            keymapsUtils.map("n", "<leader>zi", "<Cmd>ZkInsertLink<CR>", "Insert Link", opts)
          end
        end,
      })
    end,
    opts = {
      picker = "telescope",
    },
    config = function(_, opts)
      require("zk").setup(opts)

      lazyUtils.on_load("telescope.nvim", function()
        require("telescope").load_extension "zk"
      end)
    end,
  },
}
