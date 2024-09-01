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
        {
          name = "utp",
          path = "~/Sync/obsidian/utp",
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
        img_folder = "assets/imgs",
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
        "<leader>zn",
        "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>",
        desc = "new note",
      },
      {
        "<leader>zd",
        "<Cmd>ZkNew { dir = 'journal' }<CR>",
        desc = "new daily",
      },
      {
        "<leader>zf",
        "<Cmd>ZkNotes<CR>",
        desc = "notes picker",
      },
    },
    init = function()
      utils.autocmd({ "BufEnter" }, {
        group = utils.augroup "load_zk_mappings",
        pattern = "*.md",
        callback = function(event)
          if require("zk.util").notebook_root(vim.fn.expand "%:p") ~= nil then
            local opts = { noremap = true, buffer = event.buf }
            keymapsUtils.map("n", "<CR>", "<Cmd>lua vim.lsp.buf.definition()<CR>", "open link under cursor", opts)
            keymapsUtils.map(
              "n",
              "<leader>zN",
              "<Cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
              "new note (same directory)",
              opts
            )
            keymapsUtils.map(
              "v",
              "<leader>zt",
              ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>",
              "new note (same directory, selection as title)",
              opts
            )
            keymapsUtils.map(
              "v",
              "<leader>zc",
              ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
              "new note (same directory, selection as content)",
              opts
            )
            keymapsUtils.map("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", "pick zk backlinks", opts)
            keymapsUtils.map("n", "<leader>zl", "<Cmd>ZkLinks<CR>", "pick zk links", opts)
            keymapsUtils.map("n", "<leader>zi", "<Cmd>ZkInsertLink<CR>", "insert link", opts)
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
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        {
          mode = { "n", "v" },
          { "<leader>z", group = "zk" },
        },
      },
    },
  },
}
