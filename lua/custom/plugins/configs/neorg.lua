local M = {}

M.setup = function()
   local neorg = require "neorg"
   neorg.setup {
      -- Tell Neorg what modules to load
      load = {
         ["core.defaults"] = {}, -- Load all the default modules
         ["core.norg.concealer"] = {}, -- Allows for use of icons
         ["core.norg.dirman"] = { -- Manage your directories with Neorg
            config = {
               workspaces = {
                  home = "~/Sync/neorg",
               },
            },
         },
         -- ["core.norg.completion"] = {
         --    config = {
         --       engine = "nvim-cmp",
         --    },
         -- },
      },
   }
end

return M
