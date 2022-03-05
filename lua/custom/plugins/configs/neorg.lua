local M = {}

M.setup = function()
   local neorg = require "neorg"
   neorg.setup {
      -- Tell Neorg what modules to load
      load = {
         -- Load all the default modules
         ["core.defaults"] = {},

         -- Get things done
         ["core.gtd.base"] = {
            config = {
               workspace = "gtd",
            },
         },

         -- Allows for use of icons
         ["core.norg.concealer"] = {
            config = {},
         },

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

         ["core.norg.completion"] = {
            config = {
               engine = "nvim-cmp",
            },
         },
      },
   }
end

return M
