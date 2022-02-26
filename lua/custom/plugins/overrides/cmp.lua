local present, cmp = pcall(require, "cmp")

if not present then
   return
end

vim.opt.completeopt = "menuone,noselect"

local default = {
   enabled = function()
      -- disable on macros
      -- https://github.com/hrsh7th/nvim-cmp/issues/551
      return vim.fn.reg_recording() == ""
   end,
   snippet = {
      expand = function(args)
         require("luasnip").lsp_expand(args.body)
      end,
   },
   formatting = {
      format = function(entry, vim_item)
         local icons = require "plugins.configs.lspkind_icons"
         vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)

         vim_item.menu = ({
            nvim_lsp = "[LSP]",
            nvim_lua = "[Lua]",
            buffer = "[BUF]",
            path = "[Path]",
         })[entry.source.name]

         -- limit str length
         if string.len(vim_item.abbr) > 60 then
            vim_item.abbr = string.format("%s...", string.sub(vim_item.abbr, 1, 60))
         end

         return vim_item
      end,
   },
   mapping = {
      ["<Down>"] = cmp.mapping {
         i = function(fallback)
            cmp.close()
            vim.schedule(cmp.suspend())
            fallback()
         end,
      },
      ["<Up>"] = cmp.mapping {
         i = function(fallback)
            cmp.close()
            vim.schedule(cmp.suspend())
            fallback()
         end,
      },
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-u>"] = cmp.mapping.scroll_docs(-4),
      ["<C-d>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping {
         i = cmp.mapping.abort(),
         c = cmp.mapping.close(),
      },
      ["<CR>"] = cmp.mapping.confirm {
         -- behavior = cmp.ConfirmBehavior.Replace,
         select = true,
      },
      ["<Tab>"] = cmp.mapping(function(fallback)
         if cmp.visible() then
            cmp.select_next_item()
         elseif require("luasnip").expand_or_jumpable() then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
         else
            fallback()
         end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
         if cmp.visible() then
            cmp.select_prev_item()
         elseif require("luasnip").jumpable(-1) then
            vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
         else
            fallback()
         end
      end, { "i", "s" }),
   },
   sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "nvim_lua" },
      { name = "path" },
      { name = "neorg" },
   },
   experimental = {
      ghost_text = true,
   },
}

cmp.setup(default)

local isNeorgPresent, neorg = pcall(require, "neorg")

if not isNeorgPresent then
   return
end

local function load_completion()
   neorg.modules.load_module("core.norg.completion", nil, {
      engine = "nvim-cmp",
   })
end

if neorg.is_loaded() then
   load_completion()
else
   neorg.callbacks.on_event("core.started", load_completion)
end
