local M = {}

M.options = {
  auto_load = true, -- whether to automatically load preview when
  -- entering another markdown buffer

  close_on_bdelete = true, -- close preview window on buffer delete
  syntax = false, -- enable syntax highlighting, affects performance
  theme = "dark", -- 'dark' or 'light'
  update_on_change = true,
  app = { "qutebrowser", "--target", "window" }, -- 'webview', 'browser', string or a table of strings
  filetype = { "markdown" }, -- list of filetypes to recognize as markdown

  -- relevant if update_on_change is true
  throttle_at = 200000, -- start throttling when file exceeds this
  -- amount of bytes in size

  throttle_time = "auto", -- minimum amount of time in milliseconds
  -- that has to pass before starting new render
}

return M
