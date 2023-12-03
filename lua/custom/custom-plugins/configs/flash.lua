local M = {}

M.keys = {
  {
    "s",
    mode = { "n", "x", "o" },
    function()
      require("flash").jump()
    end,
    desc = "Flash",
  },
  {
    "<A-s>",
    mode = { "n", "x", "o" },
    function()
      require("flash").jump { continue = true }
    end,
    desc = "Flash",
  },
  {
    "S",
    mode = { "n", "o", "x" },
    function()
      require("flash").treesitter()
    end,
    desc = "Flash Treesitter",
  },
  {
    "r",
    mode = "o",
    function()
      require("flash").remote()
    end,
    desc = "Remote Flash",
  },
  {
    "R",
    mode = { "o", "x" },
    function()
      require("flash").treesitter_search()
    end,
    desc = "Treesitter Search",
  },
  {
    "<C-s>",
    mode = { "c" },
    function()
      require("flash").toggle()
    end,
    desc = "Toggle Flash Search",
  },
}

M.options = {
  search = {
    multi_window = false,
  },
  modes = {
    char = {
      enabled = false,
      jump_labels = true,
      multi_line = false,
    },
  },
  prompt = {
    enabled = true,
    prefix = { { " FLASH ", "FlashPromptMode" }, { " ", "FlashPromptModeSep" } },
  },
}

return M
