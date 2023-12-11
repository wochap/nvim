local neorg_arg = "neorg"

local function keybinds_hook(keybinds)
  local leader = keybinds.leader

  keybinds.map_event_to_mode("norg", {
    n = {
      { "tu", "core.qol.todo_items.todo.task_undone", "mark undone", desc = "mark undone" },
      { "tp", "core.qol.todo_items.todo.task_pending" },
      { "td", "core.qol.todo_items.todo.task_done" },
      { "th", "core.qol.todo_items.todo.task_on_hold" },
      { "tc", "core.qol.todo_items.todo.task_cancelled" },
      { "tr", "core.qol.todo_items.todo.task_recurring" },
      { "ti", "core.qol.todo_items.todo.task_important" },
      { "<A-Space>", "core.qol.todo_items.todo.task_cycle" },
      { leader .. "n", "core.dirman.new.note" },
      { leader .. "t", ":Neorg journal today" },
      { leader .. "T", ":Neorg journal tomorrow" },
    },
  }, {
    silent = true,
    noremap = true,
  })

  local ok, wk = pcall(require, "which-key")
  if not ok then
    return
  end
  wk.register {
    ["tu"] = "mark undone",
    ["tp"] = "mark pending",
    ["td"] = "mark done",
    ["th"] = "mark on hold",
    ["tc"] = "mark cacelled",
    ["tr"] = "mark recurring",
    ["ti"] = "mark important",

    [leader .. "n"] = "new note",
    [leader .. "t"] = "journal today",
    [leader .. "T"] = "journal tomorrow",
  }
end

return {
  {
    "nvim-neorg/neorg",
    commit = "baaf13a3145534144b795ad37db22bfffd2ad343",
    lazy = neorg_arg ~= vim.fn.argv()[1],
    build = ":Neorg sync-parsers",
    dependencies = { "nvim-lua/plenary.nvim" },
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
                journal = "~/Sync/journal",
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
        },
      }
    end,
  },
}
