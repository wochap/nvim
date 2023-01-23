local function keybinds_hook(keybinds)
  local leader = keybinds.leader

  -- Map all the below keybinds only when the "norg" mode is active
  keybinds.map_event_to_mode("norg", {
    n = {

      -- Keys for managing TODO items and setting their states
      { "tu", "core.norg.qol.todo_items.todo.task_undone" },
      { "tp", "core.norg.qol.todo_items.todo.task_pending" },
      { "td", "core.norg.qol.todo_items.todo.task_done" },
      { "th", "core.norg.qol.todo_items.todo.task_on_hold" },
      { "tc", "core.norg.qol.todo_items.todo.task_cancelled" },
      { "tr", "core.norg.qol.todo_items.todo.task_recurring" },
      { "ti", "core.norg.qol.todo_items.todo.task_important" },
      { "<C-Space>", "core.norg.qol.todo_items.todo.task_cycle" },

      -- Keys for managing GTD
      { leader .. "oc", "core.gtd.base.capture" },
      { leader .. "ov", "core.gtd.base.views" },
      { leader .. "oe", "core.gtd.base.edit" },

      -- Keys for managing notes
      { leader .. "on", "core.norg.dirman.new.note" },
    },

    o = {
      { "ah", "core.norg.manoeuvre.textobject.around-heading" },
      { "ih", "core.norg.manoeuvre.textobject.inner-heading" },
      { "at", "core.norg.manoeuvre.textobject.around-tag" },
      { "it", "core.norg.manoeuvre.textobject.inner-tag" },
      { "al", "core.norg.manoeuvre.textobject.around-whole-list" },
    },
    i = {
      { "<C-l>", "core.integrations.telescope.insert_link" },
    },
  }, {
    silent = true,
    noremap = true,
  })

  -- Map the below keys only when traverse-heading mode is active
  keybinds.map_event_to_mode("traverse-heading", {
    n = {
      -- Move to the next heading in the document
      { "<Down>", "core.integrations.treesitter.next.heading" },

      -- Move to the previous heading in the document
      { "<Up>", "core.integrations.treesitter.previous.heading" },
    },
  }, {
    silent = true,
    noremap = true,
  })

  keybinds.map_event_to_mode("toc-split", {
    n = {
      -- Hop to the target of the TOC link
      { "<CR>", "core.norg.qol.toc.hop-toc-link" },

      -- Closes the TOC split
      -- ^Quit
      { "q", "core.norg.qol.toc.close" },

      -- Closes the TOC split
      -- ^escape
      { "<Esc>", "core.norg.qol.toc.close" },
    },
  }, {
    silent = true,
    noremap = true,
    nowait = true,
  })

  -- Map the below keys on gtd displays
  keybinds.map_event_to_mode("gtd-displays", {
    n = {
      { "<CR>", "core.gtd.ui.goto_task" },

      -- Keys for closing the current display
      { "q", "core.gtd.ui.close" },
      { "<Esc>", "core.gtd.ui.close" },

      { "e", "core.gtd.ui.edit_task" },
      { "<Tab>", "core.gtd.ui.details" },
    },
  }, {
    silent = true,
    noremap = true,
    nowait = true,
  })

  -- Apply the below keys to all modes
  keybinds.map_to_mode("all", {
    n = {
      { leader .. "omn", ":Neorg mode norg<CR>" },
      { leader .. "omh", ":Neorg mode traverse-heading<CR>" },
    },
  }, {
    silent = true,
    noremap = true,
  })
end

local M = {}

M.setup = function()
  local neorg = require "neorg"

  neorg.setup {
    load = {
      -- Load all the default modules
      ["core.integrations.treesitter"] = {},
      ["core.autocommands"] = {},
      ["core.mode"] = {},
      ["core.neorgcmd"] = {},
      ["core.norg.esupports.hop"] = {},
      ["core.norg.esupports.indent"] = {},
      ["core.norg.esupports.metagen"] = {},
      ["core.norg.news"] = {},
      ["core.syntax"] = {},
      ["core.tangle"] = {},
      ["core.keybinds"] = {
        config = {
          neorg_leader = "<leader>",
          default_keybinds = false,
          hook = keybinds_hook,
        },
      },
      ["core.norg.qol.todo_items"] = {},

      -- Manage your directories with Neorg
      ["core.norg.dirman"] = {
        config = {
          workspaces = {
            home = "~/Sync/neorg",
            journal = "~/Sync/journal",
            gtd = "~/Sync/gtd",
          },
          autochdir = true,
        },
      },

      ["core.norg.journal"] = {
        config = {
          workspace = "journal",
          journal_folder = "",
        },
      },

      -- Allows for use of icons
      ["core.norg.concealer"] = {
        config = {},
      },

      -- Get things done
      -- ["core.gtd.base"] = {
      --   config = {
      --     workspace = "gtd",
      --   },
      --   exclude = { "home", "journal" },
      -- },

      ["core.norg.completion"] = {
        config = {
          engine = "nvim-cmp",
        },
      },
    },
  }
end

return M
