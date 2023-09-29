local cmp = require "cmp"
local cmp_ui = require("core.utils").load_config().ui.cmp
local cmp_style = cmp_ui.style

local M = {}

M.options = {
  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
  end,
  formatting = {
    format = function(_, item)
      local icons = require "nvchad.icons.lspkind"
      local icon = (cmp_ui.icons and icons[item.kind]) or ""

      if cmp_style == "atom" or cmp_style == "atom_colored" then
        icon = " " .. icon .. " "
        item.menu = cmp_ui.lspkind_text and "   (" .. item.kind .. ")" or ""
        item.kind = icon
      else
        icon = cmp_ui.lspkind_text and (" " .. icon .. " ") or icon
        item.kind = string.format("%s %s", icon, cmp_ui.lspkind_text and item.kind or "")
      end

      -- limit str length
      if string.len(item.abbr) > 60 then
        item.abbr = string.format("%s...", string.sub(item.abbr, 1, 60))
      end

      return item
    end,
  },
  mapping = {
    ["<C-f>"] = nil,
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Select },
    ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Select },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
      elseif require("luasnip").jumpable(1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-next", true, true, true), "")
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
      elseif require("luasnip").jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  },
  experimental = {
    ghost_text = false,
    native_menu = false,
  },
}

local cmdlineMapping = {
  ["<C-Space>"] = { c = cmp.mapping.complete() },
  ["<C-n>"] = {
    c = function(fallback)
      if cmp.visible() then
        cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
      else
        cmp.complete()
      end
    end,
  },
  ["<C-p>"] = {
    c = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
      else
        cmp.complete()
      end
    end,
  },
  ["<C-e>"] = {
    c = cmp.mapping.abort(),
  },
  ["<CR>"] = { c = cmp.mapping.confirm {
    behavior = cmp.ConfirmBehavior.Insert,
    select = true,
  } },
  ["<C-CR>"] = {
    c = function(fallback)
      if cmp.visible() then
        cmp.confirm({
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        }, fallback)
      else
        fallback()
      end
    end,
  },
  ["<Tab>"] = {
    c = function(fallback)
      if cmp.visible() then
        cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
      else
        cmp.complete()
      end
    end,
  },
  ["<S-Tab>"] = {
    c = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
      else
        cmp.complete()
      end
    end,
  },
}

M.setup = function(opts)
  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmdlineMapping,
    sources = {
      { name = "buffer", max_item_count = 10 },
      { name = "cmdline_history", max_item_count = 10 },
    },
  })

  cmp.setup.cmdline(":", {
    mapping = cmdlineMapping,
    sources = {
      { name = "cmdline", max_item_count = 10 },
      { name = "cmdline_history", max_item_count = 10 },
      { name = "path", max_item_count = 10 },
      { name = "nvim_lua", max_item_count = 10 },
    },
  })

  cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
      { name = "dap" },
    },
  })
end

return M
