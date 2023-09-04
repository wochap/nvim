local M = {}

M.luasnip = {
  -- nvchad opts
  history = true,
  updateevents = "TextChanged,TextChangedI",

  -- Show snippets related to the language
  -- in the current cursor position
  ft_func = function()
    return require("luasnip.extras.filetype_functions").from_pos_or_filetype()
  end,
}

M.colorizer = {
  user_default_options = {
    names = false, -- "Name" codes like Blue or blue
    RRGGBBAA = true, -- #RRGGBBAA hex codes
    AARRGGBB = true, -- 0xAARRGGBB hex codes
    rgb_fn = true, -- CSS rgb() and rgba() functions
    hsl_fn = true, -- CSS hsl() and hsla() functions
    css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
    -- Available modes for `mode`: foreground, background,  virtualtext
    mode = "virtualtext", -- Set the display mode.
    -- Available methods are false / true / "normal" / "lsp" / "both"
    -- True is same as normal
    tailwind = false, -- Enable tailwind colors
    -- parsers can contain values used in |user_default_options|
    sass = { enable = true, parsers = { "css" } }, -- Enable sass colors
    virtualtext = "■",
  },
}

M.which_key = function()
  local wk = require "which-key"

  wk.register({
    o = {
      name = "neorg",
    },
    g = { name = "git" },
    f = { name = "find" },
    d = { name = "dap" },
    h = { name = "harpon" },
    l = { name = "lsp" },
    n = { name = "misc" },
    p = { name = "packer" },
    q = { name = "quit" },
    t = { name = "terminal" },
    x = { name = "trouble" },
  }, { prefix = "<leader>" })
end

return M
