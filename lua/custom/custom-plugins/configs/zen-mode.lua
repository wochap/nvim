local options = {
  window = {
    backdrop = 1,
    width = 120, -- width of the Zen window
    height = 1, -- height of the Zen window
  },
  plugins = {
    options = {
      enabled = true,
      ruler = false, -- disables the ruler text in the cmd line area
      showcmd = false, -- disables the command in the last line of the screen
    },
    twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
    gitsigns = { enabled = true }, -- disables git signs
  },
  on_open = function(win) end,
  on_close = function() end,
}

return options
