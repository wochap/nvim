local in_neorg = require("custom.utils.constants").in_neorg

local function keybinds_hook(keybinds)
  local leader = keybinds.leader

  keybinds.map_event_to_mode("norg", {
    n = {
      { ">.", "core.promo.promote", opts = { desc = "promote object (non-recursively)" } },
      { "<,", "core.promo.demote", opts = { desc = "demote object (non-recursively)" } },
      { ">>", "core.promo.promote", "nested", opts = { desc = "promote object (recursively)" } },
      { "<<", "core.promo.demote", "nested", opts = { desc = "demote object (recursively)" } },

      { "tu", "core.qol.todo_items.todo.task_undone", opts = { desc = "mark undone" } },
      { "tp", "core.qol.todo_items.todo.task_pending", opts = { desc = "mark pending" } },
      { "td", "core.qol.todo_items.todo.task_done", opts = { desc = "mark done" } },
      { "th", "core.qol.todo_items.todo.task_on_hold", opts = { desc = "mark on hold" } },
      { "tc", "core.qol.todo_items.todo.task_cancelled", opts = { desc = "mark cacelled" } },
      { "tr", "core.qol.todo_items.todo.task_recurring", opts = { desc = "mark recurring" } },
      { "ti", "core.qol.todo_items.todo.task_important", opts = { desc = "mark important" } },
      { "<A-Space>", "core.qol.todo_items.todo.task_cycle", opts = { desc = "cycle" } },

      { leader .. "t", "<cmd>Neorg journal today<cr>", opts = { desc = "journal today" } },
      { leader .. "T", "<cmd>Neorg journal tomorrow<cr>", opts = { desc = "journal tomorrow" } },
      { leader .. "jt", "<cmd>Neorg journal toc open<cr>", opts = { desc = "journal toc open" } },
      { leader .. "jT", "<cmd>Neorg journal toc update<cr>", opts = { desc = "journal to update" } },

      { leader .. "n", "core.dirman.new.note", opts = { desc = "new note" } },
      { leader .. "d", "core.tempus.insert-date", opts = { desc = "insert Date" } },
      { "gl", "core.esupports.hop.hop-link", opts = { desc = "jump to Link" } },
      { "]h", "core.integrations.treesitter.next.heading", opts = { desc = "move to next heading" } },
      {
        "[h",
        "core.integrations.treesitter.previous.heading",
        opts = { desc = "Move to Previous Heading" },
      },
      { "]l", "core.integrations.treesitter.next.link", opts = { desc = "move to next link" } },
      {
        "[l",
        "core.integrations.treesitter.previous.link",
        opts = { desc = "Move to Previous Link" },
      },
    },

    i = {
      { "<A-d>", "core.tempus.insert-date-insert-mode", opts = { desc = "insert date" } },
    },
  }, {
    silent = true,
    noremap = true,
  })

  keybinds.map_event_to_mode("all", {
    n = {
      { leader .. "o", ":Neorg toc", opts = { desc = "open table of contents" } },
    },
  }, {
    silent = true,
    noremap = true,
  })
end

return {
  {
    "nvim-neorg/neorg",
    commit = "baaf13a3145534144b795ad37db22bfffd2ad343",
    lazy = not in_neorg,
    build = ":Neorg sync-parsers",
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {},
          ["core.concealer"] = {},
          ["core.completion"] = {
            config = {
              engine = "nvim-cmp",
            },
          },

          ["core.qol.todo_items"] = {
            config = {
              create_todo_items = true,
              create_todo_parents = true,
            },
          },

          ["core.keybinds"] = {
            config = {
              neorg_leader = "<C-n>",
              default_keybinds = false,
              hook = keybinds_hook,
            },
          },

          ["core.dirman"] = {
            config = {
              workspaces = {
                home = "~/Sync/neorg",
                vtm = "~/Sync/vtm",
                -- gtd = "~/Sync/gtd",
              },
              default_workspace = "home",
            },
          },

          ["core.journal"] = {
            config = {
              workspace = "home",
              journal_folder = "journal",
            },
          },

          ["core.export"] = {},
        },
      }
    end,
  },
}
