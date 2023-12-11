local neorg_arg = "neorg"

local function keybinds_hook(keybinds)
  local leader = keybinds.leader

  keybinds.map_event_to_mode("norg", {
    n = {
      { leader .. "n", "core.dirman.new.note" },
    },
  }, {
    silent = true,
    noremap = true,
  })
end

return {
  {
    "nvim-neorg/neorg",
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
        },
      }
    end,
  },
}
