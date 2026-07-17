return {
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "lewis6991/async.nvim",
    },
    keys = {
      {
        "<leader>r",
        "",
        desc = "refactor",
        mode = { "n", "x" },
      },

      {
        "<leader>rs",
        function()
          return require("refactoring").select_refactor()
        end,
        mode = { "n", "x" },
        desc = "Select Refactor",
      },
      {
        "<leader>ri",
        function()
          return require("refactoring").inline_var()
        end,
        mode = { "n", "x" },
        desc = "Inline Variable",
        expr = true,
      },
      {
        "<leader>rP",
        function()
          return require("refactoring.debug").print_loc { output_location = "below" }
        end,
        desc = "Debug Print Location",
        expr = true,
      },
      {
        "<leader>rp",
        function()
          return require("refactoring.debug").print_var { output_location = "below" } .. "iw"
        end,
        mode = { "n", "x" },
        desc = "Debug Print Variable",
        expr = true,
      },
      {
        "<leader>rc",
        function()
          return require("refactoring.debug").cleanup { restore_view = true } .. "ag"
        end,
        desc = "Debug Cleanup",
        expr = true,
      },
      {
        "<leader>rf",
        function()
          return require("refactoring").extract_func()
        end,
        mode = { "n", "x" },
        desc = "Extract Function",
        expr = true,
      },
      {
        "<leader>rF",
        function()
          return require("refactoring").extract_func_to_file()
        end,
        mode = { "n", "x" },
        desc = "Extract Function To File",
        expr = true,
      },
      {
        "<leader>rx",
        function()
          return require("refactoring").extract_var()
        end,
        mode = { "n", "x" },
        desc = "Extract Variable",
        expr = true,
      },
    },
    opts = {},
  },
}
