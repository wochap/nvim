local in_leetcode = require("custom.utils.constants").in_leetcode

return {
  {
    "kawre/leetcode.nvim",
    lazy = not in_leetcode,
    keys = {
      {
        "<leader>e",
        "<cmd>Leet menu<cr>",
        desc = "opens menu dashboard",
      },
      {
        "<leader>b",
        "<cmd>Leet desc<cr>",
        desc = "toggle question description",
      },
      {
        "<leader>Ld",
        "<cmd>Leet daily<cr>",
        desc = "opens the question of today",
      },
      {
        "<leader>Lc",
        "<cmd>Leet console<cr>",
        desc = "opens console pop-up for currently opened question",
      },
      {
        "<leader>Li",
        "<cmd>Leet info<cr>",
        desc = "opens a pop-up containing information about the currently opened question",
      },
      {
        "<leader>fb",
        "<cmd>Leet tabs<cr>",
        desc = "opens a picker with all currently opened question tabs",
      },
      {
        "<leader>Ll",
        "<cmd>Leet lang<cr>",
        desc = "opens a picker to change the language of the current question",
      },
      {
        "<leader>Lr",
        "<cmd>Leet run<cr>",
        desc = "run currently opened question",
      },
      {
        "<leader>Ls",
        "<cmd>Leet submit<cr>",
        desc = "submit currently opened question",
      },
      {
        "<leader>ff",
        "<cmd>Leet list<cr>",
        desc = "opens a problemlist picker",
      },
    },
    opts = {
      lang = "javascript",
      description = {
        width = "50%",
      },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      defaults = {
        ["<leader>L"] = { name = "leetcode" },
      },
    },
  },
}
