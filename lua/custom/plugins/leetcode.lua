local in_leetcode = require("custom.utils.constants").in_leetcode

return {
  {
    "kawre/leetcode.nvim",
    lazy = not in_leetcode,
    opts = {
      lang = "javascript",
      description = {
        width = "50%",
      },
      hooks = {
        LeetEnter = {
          function()
            require("core.utils").load_mappings "leetcode"
          end,
        },
      },
    },
  },
}
