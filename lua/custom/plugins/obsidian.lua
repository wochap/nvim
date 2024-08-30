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
}
