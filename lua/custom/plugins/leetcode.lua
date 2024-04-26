local in_leetcode = require("custom.utils.constants").in_leetcode

return {
  {
    "kawre/leetcode.nvim",
    lazy = not in_leetcode,
    priority = 1,
    keys = (not in_leetcode and {}) or {
      {
        "<leader>e",
        "<cmd>Leet menu<cr>",
        desc = "focus dashboard",
      },
      {
        "<leader>b",
        "<cmd>Leet desc<cr>",
        desc = "toggle question description",
      },
      {
        "<leader>Ld",
        "<cmd>Leet daily<cr>",
        desc = "opens question of today",
      },
      {
        "<leader>Lc",
        "<cmd>Leet console<cr>",
        desc = "opens question console",
      },
      {
        "<leader>Li",
        "<cmd>Leet info<cr>",
        desc = "opens question information",
      },
      {
        "<leader>Ll",
        "<cmd>Leet lang<cr>",
        desc = "change question language",
      },
      {
        "<leader>Lr",
        "<cmd>Leet run<cr>",
        desc = "run question",
      },
      {
        "<leader>Ls",
        "<cmd>Leet submit<cr>",
        desc = "submit question",
      },
      {
        "<leader>ff",
        "<cmd>Leet list<cr>",
        desc = "opens problemlist",
      },
      {
        "<leader>fb",
        "<cmd>Leet tabs<cr>",
        desc = "opens question tabs",
      },
    },
    opts = {
      lang = "cpp",
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
