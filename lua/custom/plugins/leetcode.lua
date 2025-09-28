local in_leetcode = require("custom.constants").in_leetcode

return {
  {
    "kawre/leetcode.nvim",
    lazy = not in_leetcode,
    priority = 1,
    keys = (not in_leetcode and {}) or {
      {
        "<leader>L",
        "",
        desc = "leetcode",
      },

      {
        "<leader>e",
        "<cmd>Leet menu<cr>",
        desc = "Dashboard",
      },
      {
        "<leader>E",
        "<cmd>Leet desc<cr>",
        desc = "Question Description",
      },
      {
        "<leader>Ld",
        "<cmd>Leet daily<cr>",
        desc = "Today's Question",
      },
      {
        "<leader>Lc",
        "<cmd>Leet console<cr>",
        desc = "Question Console",
      },
      {
        "<leader>Li",
        "<cmd>Leet info<cr>",
        desc = "Question Information",
      },
      {
        "<leader>Ll",
        "<cmd>Leet lang<cr>",
        desc = "Question Language",
      },
      {
        "<leader>Lr",
        "<cmd>Leet run<cr>",
        desc = "Run Question",
      },
      {
        "<leader>Ls",
        "<cmd>Leet submit<cr>",
        desc = "Submit Question",
      },
      {
        "<leader>ff",
        "<cmd>Leet list<cr>",
        desc = "Problem List",
      },
      {
        "<leader>fb",
        "<cmd>Leet tabs<cr>",
        desc = "Question Tabs",
      },
    },
    opts = {
      lang = "cpp",
      picker = {
        provider = "snacks-picker",
      },
      description = {
        width = "50%",
      },
    },
  },
}
