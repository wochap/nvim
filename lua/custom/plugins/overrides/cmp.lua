local cmp = require "cmp"

local options = {
  formatting = {
    format = function(_, vim_item)
      local icons = require "nvchad.icons.lspkind"
      vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)

      -- limit str length
      if string.len(vim_item.abbr) > 60 then
        vim_item.abbr = string.format("%s...", string.sub(vim_item.abbr, 1, 60))
      end

      return vim_item
    end,
  },
  mapping = {
    ["<C-f>"] = nil,
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
  },
}

return options
