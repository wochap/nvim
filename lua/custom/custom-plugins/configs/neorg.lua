local function keybinds_hook(keybinds)
  local leader = keybinds.leader

  -- Map all the below keybinds only when the "norg" mode is active
  keybinds.map_event_to_mode("norg", {
    n = {

      -- Keys for managing TODO items and setting their states
      { "tu", "core.qol.todo_items.todo.task_undone" },
      { "tp", "core.qol.todo_items.todo.task_pending" },
      { "td", "core.qol.todo_items.todo.task_done" },
      { "th", "core.qol.todo_items.todo.task_on_hold" },
      { "tc", "core.qol.todo_items.todo.task_cancelled" },
      { "tr", "core.qol.todo_items.todo.task_recurring" },
      { "ti", "core.qol.todo_items.todo.task_important" },
      { "<C-Space>", "core.qol.todo_items.todo.task_cycle" },

      -- Keys for managing notes
      { leader .. "on", "core.dirman.new.note" },
    },

    o = {
      { "ah", "core.manoeuvre.textobject.around-heading" },
      { "ih", "core.manoeuvre.textobject.inner-heading" },
      { "at", "core.manoeuvre.textobject.around-tag" },
      { "it", "core.manoeuvre.textobject.inner-tag" },
      { "al", "core.manoeuvre.textobject.around-whole-list" },
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
      { "<CR>", "core.qol.toc.hop-toc-link" },

      -- Closes the TOC split
      -- ^Quit
      { "q", "core.qol.toc.close" },

      -- Closes the TOC split
      -- ^escape
      { "<Esc>", "core.qol.toc.close" },
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
      ["core.esupports.hop"] = {},
      ["core.esupports.indent"] = {},
      ["core.esupports.metagen"] = {},
      ["core.news"] = {},
      ["core.syntax"] = {},
      ["core.tangle"] = {},
      ["core.keybinds"] = {
        config = {
          neorg_leader = "<leader>",
          default_keybinds = false,
          hook = keybinds_hook,
        },
      },
      ["core.qol.todo_items"] = {},

      -- Manage your directories with Neorg
      ["core.dirman"] = {
        config = {
          workspaces = {
            home = "~/Sync/neorg",
            journal = "~/Sync/journal",
            gtd = "~/Sync/gtd",
          },
          default_workspace = "home",
        },
      },

      ["core.journal"] = {
        config = {
          workspace = "journal",
          journal_folder = "",
        },
      },

      -- Allows for use of icons
      ["core.concealer"] = {
        config = {},
      },

      ["core.completion"] = {
        config = {
          engine = "nvim-cmp",
        },
      },
    },
  }
end

return M
