local present, neogit = pcall(require, "neogit")
if not present then
   return
end

local M = {}

M.setup = function(on_attach)
  neogit.setup {
    kind = "vsplit",
    integrations = {
      diffview = true,
    },
    signs = {
      section = { "", "" },
      item = { "", "" },
      hunk = { "", "" },
    },
    sections = {
      untracked = {
        folded = false
      },
      unstaged = {
        folded = false
      },
      staged = {
        folded = false
      },
      stashes = {
        folded = false
      },
      unpulled = {
        folded = false
      },
      unmerged = {
        folded = false
      },
      recent = {
        folded = false
      },
    },
    mappings = {
      status = {
        ["1"] = "",
        ["2"] = "",
        ["3"] = "",
        ["4"] = "",
        -- ["1"] = "Depth1",
        -- ["2"] = "Depth2",
        -- ["3"] = "Depth3",
        -- ["4"] = "Depth4",
      },
    },
  }
end

return M