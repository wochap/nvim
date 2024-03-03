local M = {}

local defer = require "custom.utils.defer"
local cmp = require "cmp"
local defaults = require "cmp.config.default"()
local cmp_ui = require("core.utils").load_config().ui.cmp
local cmp_style = cmp_ui.style
local async_cmp_close = function()
  vim.schedule(function()
    -- HACK: we don't use cmp.close because that is a sync operation
    if cmp.core.view:visible() then
      local release = cmp.core:suspend()
      cmp.core.view:close()
      vim.schedule(release)
    end
  end)
end
local cmp_close_tl = defer.throttle_leading(async_cmp_close, 100)

local function select_prev_item(fallback)
  if cmp.visible() then
    cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
  else
    cmp.complete()
  end
end
local function select_next_item(fallback)
  if cmp.visible() then
    cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
  else
    cmp.complete()
  end
end

M.options = {
  enabled = function()
    local cmp_ctx = require "cmp.config.context"
    if
      (vim.fn.reg_recording() ~= "")
      or (vim.fn.reg_executing() ~= "")
      or (cmp_ctx.in_treesitter_capture "comment" == true)
      or (cmp_ctx.in_syntax_group "comment" == true)
    then
      return false
    end

    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
  end,
  preselect = cmp.PreselectMode.None,
  window = {
    completion = {
      winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:PmenuSel" .. ",Search:None",
    },
    documentation = { winhighlight = "Normal:CmpDoc" .. ",Search:None" },
  },
  completion = {
    completeopt = "menu,menuone,noinsert,noselect",
  },
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
    -- TODO: add C-f and C-b mappings to scroll options
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<C-n>"] = select_next_item,
    ["<C-p>"] = select_prev_item,
    ["<C-e>"] = cmp.mapping.abort(),
    ["<C-k>"] = function()
      require("luasnip").expand()
    end,
    ["<Up>"] = function(fallback)
      cmp_close_tl()
      fallback()
    end,
    ["<Down>"] = function(fallback)
      cmp_close_tl()
      fallback()
    end,
    ["<Left>"] = function(fallback)
      cmp_close_tl()
      fallback()
    end,
    ["<Right>"] = function(fallback)
      cmp_close_tl()
      fallback()
    end,
    ["<C-y>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    },
    ["<Tab>"] = {
      i = function(fallback)
        if require("luasnip").jumpable(1) then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-next", true, true, true), "")
        else
          fallback()
        end
      end,
      s = function(fallback)
        require("luasnip").jump(1)
      end,
    },
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      require("luasnip").jump(-1)
    end, {
      "i",
      "s",
    }),
    ["<CR>"] = function(fallback)
      cmp_close_tl()
      fallback()
    end,

    -- remove mappings
    ["<C-f>"] = function(fallback)
      fallback()
    end,
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp", max_item_count = 20 },
    { name = "luasnip", max_item_count = 10 },
    { name = "path" },
  }, {
    { name = "buffer", max_item_count = 10 },
  }),
  experimental = {
    ghost_text = false,
    native_menu = false,
  },
  sorting = defaults.sorting,
}

local cmdlineMapping = {
  ["<C-Space>"] = { c = cmp.mapping.complete() },
  ["<C-n>"] = {
    c = select_next_item,
  },
  ["<C-p>"] = {
    c = select_prev_item,
  },
  ["<C-e>"] = {
    c = cmp.mapping.abort(),
  },
  ["<C-y>"] = { c = cmp.mapping.confirm {
    behavior = cmp.ConfirmBehavior.Insert,
    select = true,
  } },
  ["<C-S-y>"] = {
    c = function(fallback)
      cmp.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true,
      }, function()
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true), "")
      end)
    end,
  },
  ["<Tab>"] = {
    c = select_next_item,
  },
  ["<S-Tab>"] = {
    c = select_prev_item,
  },
}

M.setup = function(opts)
  cmp.setup(opts)
  cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
      { name = "dap" },
    },
  })

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
end

return M
